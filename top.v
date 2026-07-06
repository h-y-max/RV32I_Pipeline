module top(
    input CLK,
    input reset_n,
    output [31:0] pc,
    output [31:0] inst
);
    // IF ½×¶ÎÐÅºÅ
    wire [31:0] pc_if;
    wire [31:0] pc_plus4_if;
    wire [31:0] inst_if;
    // IF/ID ¼Ä´æÆ÷ÐÅºÅ
    wire [31:0] pc_id;
    wire [31:0] inst_id;
    // ID ½×¶ÎÐÅºÅ
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_i;
    wire [31:0] imm_s;
    wire [31:0] imm_b;
    wire [31:0] imm_j;
    wire [31:0] imm_u;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire reg_write;
    wire alu_src;
    wire mem_write;
    wire mem_to_reg;
    wire branch;
    wire jump;
    wire [3:0] alu_op;
    // ID/EX ¼Ä´æÆ÷ÐÅºÅ
    wire [31:0] pc_ex;
    wire [31:0] rs1_data_ex;
    wire [31:0] rs2_data_ex;
    wire [31:0] imm_i_ex;
    wire [31:0] imm_s_ex;
    wire [31:0] imm_b_ex;
    wire [31:0] imm_j_ex;
    wire [31:0] imm_u_ex;
    wire [4:0] rs1_addr_ex;
    wire [4:0] rs2_addr_ex;
    wire [4:0] rd_addr_ex;
    wire [3:0] alu_op_ex;
    wire reg_write_ex;
    wire alu_src_ex;
    wire mem_write_ex;
    wire mem_to_reg_ex;
    wire branch_ex;
    wire jump_ex;
    wire [6:0] opcode_ex;
    wire [2:0] funct3_ex;
    // EX ½×¶ÎÐÅºÅ
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] alu_result;
    wire [31:0] imm_sel;
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    wire branch_taken_ex;
    wire [31:0] branch_target_ex;
    wire [31:0] jump_target_ex;

    wire [31:0] rs2_forwarded;
    // EX/MEM ¼Ä´æÆ÷ÐÅºÅ
    wire [31:0] pc_mem;
    wire [31:0] alu_result_mem;
    wire [31:0] rs2_data_mem;
    wire [4:0] rd_addr_mem;
    wire reg_write_mem;
    wire mem_write_mem;
    wire mem_to_reg_mem;
    // MEM ½×¶ÎÐÅºÅ
    wire [31:0] read_data_mem;
    // MEM/WB ÐÅºÅ
    wire [31:0] pc_wb;
    wire [31:0] alu_result_wb;
    wire [31:0] read_data_wb;
    wire [4:0] rd_addr_wb;
    wire reg_write_wb;
    wire mem_to_reg_wb;
    // WB ½×¶ÎÐÅºÅ
    wire [31:0] wb_data;
    // Á÷Ë®Ïß¿ØÖÆÐÅºÅ
    wire pc_stall;
    wire if_id_stall;
    wire id_ex_flush;

    wire ex_mem_flush;
    wire flush_global_if_id;
    wire flush_global_id_ex;
    // ¿ØÖÆÐÅºÅ×éºÏ
    wire beq_taken;
    wire bne_taken;
    assign beq_taken=branch_ex && (funct3_ex==3'b000) && (alu_result==32'b0);
    assign bne_taken=branch_ex && (funct3_ex==3'b001) && (alu_result!=32'b0);
    assign branch_taken_ex=(beq_taken || bne_taken);

    assign ex_mem_flush=(branch_taken_ex || jump_ex);

    assign flush_global_if_id=ex_mem_flush;
    assign flush_global_id_ex=(ex_mem_flush || id_ex_flush);
    // PC next
    assign pc_plus4_if=pc_if+32'd4;
    assign branch_target_ex=pc_ex+imm_b_ex;
    assign jump_target_ex=(opcode_ex==7'b110_1111)?(pc_ex+imm_j_ex):(alu_result & 32'hffff_fffe);

    wire [31:0] pc_next;
    assign pc_next=(branch_taken_ex==1)?branch_target_ex :
                   (jump_ex==1)?jump_target_ex :
                   pc_plus4_if;
    // IF ½×¶Î
    pc pc_inst(
        .CLK(CLK),
        .reset_n(reset_n),
        .stall(pc_stall),
        .pc_next(pc_next),
        .pc(pc_if)
    );

    imem imem_inst(
        .addr(pc_if),
        .inst(inst_if)
    );

    IF_ID IF_ID_inst(
        .CLK(CLK),
        .reset_n(reset_n),
        .stall(if_id_stall),
        .flush(flush_global_if_id),
        .pc_if(pc_if),
        .inst_if(inst_if),
        .pc_id(pc_id),
        .inst_id(inst_id)
    );
    // ID ½×¶Î
    decoder decoder_inst(
        .inst(inst_id),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7),
        .imm_i(imm_i),
        .imm_s(imm_s),
        .imm_b(imm_b),
        .imm_j(imm_j),
        .imm_u(imm_u)
    );

    regfile regfile_inst(
        .CLK(CLK),
        .reset_n(reset_n),
        .reg_write(reg_write_wb),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rd_addr(rd_addr_wb),
        .rd_data(wb_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    control control_inst(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    hazard_detection hazard_detection_inst(
        .rs1_addr_id(rs1),
        .rs2_addr_id(rs2),
        .rd_addr_ex(rd_addr_ex),
        .mem_to_reg_ex(mem_to_reg_ex),
        .pc_stall(pc_stall),
        .if_id_stall(if_id_stall),
        .id_ex_flush(id_ex_flush)
    );

    ID_EX ID_EX_inst(
        .CLK(CLK),
        .reset_n(reset_n),
        .stall(1'b0),
        .flush(flush_global_id_ex),
        .opcode(opcode),
        .funct3(funct3),
        .pc_id(pc_id),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm_i(imm_i),
        .imm_s(imm_s),
        .imm_b(imm_b),
        .imm_j(imm_j),
        .imm_u(imm_u),
        .opcode_ex(opcode_ex),
        .funct3_ex(funct3_ex),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rd_addr(rd),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .pc_ex(pc_ex),
        .rs1_data_ex(rs1_data_ex),
        .rs2_data_ex(rs2_data_ex),
        .imm_i_ex(imm_i_ex),
        .imm_s_ex(imm_s_ex),
        .imm_b_ex(imm_b_ex),
        .imm_j_ex(imm_j_ex),
        .imm_u_ex(imm_u_ex),
        .rs1_addr_ex(rs1_addr_ex),
        .rs2_addr_ex(rs2_addr_ex),
        .rd_addr_ex(rd_addr_ex),
        .alu_op_ex(alu_op_ex),
        .reg_write_ex(reg_write_ex),
        .alu_src_ex(alu_src_ex),
        .mem_write_ex(mem_write_ex),
        .mem_to_reg_ex(mem_to_reg_ex),
        .branch_ex(branch_ex),
        .jump_ex(jump_ex)
    );
    // EX ½×¶Î
    assign imm_sel=(opcode_ex==7'b010_0011)?imm_s_ex:
                   (opcode_ex==7'b110_0011)?imm_b_ex:
                   (opcode_ex==7'b110_1111)?imm_j_ex:
                   (opcode_ex==7'b011_0111)?imm_u_ex:
                   imm_i_ex;

    forwarding forwarding_inst(
        .rs1_addr_ex(rs1_addr_ex),
        .rs2_addr_ex(rs2_addr_ex),
        .rd_addr_mem(rd_addr_mem),
        .rd_addr_wb(rd_addr_wb),
        .reg_write_mem(reg_write_mem),
        .reg_write_wb(reg_write_wb),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    assign alu_a=(forward_a==2'b10)?alu_result_mem:
                 (forward_a==2'b01)?wb_data:
                  rs1_data_ex;

    assign alu_b=(alu_src_ex==1)?imm_sel:
                 (forward_b==2'b10)?alu_result_mem:
                 (forward_b==2'b01)?wb_data:
                 rs2_data_ex;

    assign rs2_forwarded=(forward_b==2'b10)?alu_result_mem:
                         (forward_b==2'b01)?wb_data:
                          rs2_data_ex;

    alu alu_inst(
        .a(alu_a),
        .b(alu_b),
        .alu_op(alu_op_ex),
        .result(alu_result)
    );

    wire [31:0] ex_result;
    assign ex_result=(jump_ex==1)?(pc_ex+32'd4):alu_result;

    EX_MEM EX_MEM_inst(
        .CLK(CLK),
        .reset_n(reset_n),
        .stall(1'b0),
        .flush(1'b0),
        .pc_ex(pc_ex),
        .alu_result(ex_result),
        .rs2_data_ex(rs2_forwarded),
        .rd_addr_ex(rd_addr_ex),
        .reg_write_ex(reg_write_ex),
        .mem_write_ex(mem_write_ex),
        .mem_to_reg_ex(mem_to_reg_ex),
        .pc_mem(pc_mem),
        .alu_result_mem(alu_result_mem),
        .rs2_data_mem(rs2_data_mem),
        .rd_addr_mem(rd_addr_mem),
        .reg_write_mem(reg_write_mem),
        .mem_write_mem(mem_write_mem),
        .mem_to_reg_mem(mem_to_reg_mem)
    );
    // MEM ½×¶Î
    dmem dmem_inst(
        .CLK(CLK),
        .addr(alu_result_mem),
        .write_en(mem_write_mem),
        .write_data(rs2_data_mem),
        .read_data(read_data_mem)
    );

    MEM_WB MEM_WB_inst(
        .CLK(CLK),
        .reset_n(reset_n),
        .stall(1'b0),
        .flush(1'b0),
        .pc_mem(pc_mem),
        .alu_result_mem(alu_result_mem),
        .read_data_mem(read_data_mem),
        .rd_addr_mem(rd_addr_mem),
        .reg_write_mem(reg_write_mem),
        .mem_to_reg_mem(mem_to_reg_mem),
        .pc_wb(pc_wb),
        .alu_result_wb(alu_result_wb),
        .read_data_wb(read_data_wb),
        .rd_addr_wb(rd_addr_wb),
        .reg_write_wb(reg_write_wb),
        .mem_to_reg_wb(mem_to_reg_wb)
    );
    // WB ½×¶Î
    assign wb_data=(mem_to_reg_wb==1)?read_data_wb:alu_result_wb;

    assign pc=pc_if;
    assign inst=inst_if;
    
endmodule