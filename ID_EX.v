module ID_EX(
    input CLK,
    input reset_n,
    input stall,
    input flush,
    input [6:0] opcode,
    input [2:0] funct3,
    input [31:0] pc_id,
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] imm_i,
    input [31:0] imm_s,
    input [31:0] imm_b,
    input [31:0] imm_j,
    input [31:0] imm_u,
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input [4:0] rd_addr,
    input [3:0] alu_op,
    input reg_write,
    input alu_src,
    input mem_write,
    input mem_to_reg,
    input branch,
    input jump,
    output reg [31:0] pc_ex,
    output reg [6:0] opcode_ex,
    output reg [2:0] funct3_ex,
    output reg [31:0] rs1_data_ex,
    output reg [31:0] rs2_data_ex,
    output reg [31:0] imm_i_ex,
    output reg [31:0] imm_s_ex,
    output reg [31:0] imm_b_ex,
    output reg [31:0] imm_j_ex,
    output reg [31:0] imm_u_ex,
    output reg [4:0] rs1_addr_ex,
    output reg [4:0] rs2_addr_ex,
    output reg [4:0] rd_addr_ex,
    output reg [3:0] alu_op_ex,
    output reg reg_write_ex,
    output reg alu_src_ex,
    output reg mem_write_ex,
    output reg mem_to_reg_ex,
    output reg branch_ex,
    output reg jump_ex
);
always@(posedge CLK or negedge reset_n)
    if(!reset_n)begin
        pc_ex<=32'b0;
        opcode_ex<=7'b0;
        funct3_ex<=3'b0;
        rs1_data_ex<=32'b0;
        rs2_data_ex<=32'b0;
        imm_i_ex<=32'b0;
        imm_s_ex<=32'b0;
        imm_b_ex<=32'b0;
        imm_j_ex<=32'b0;
        imm_u_ex<=32'b0;
        rs1_addr_ex<=5'b0;
        rs2_addr_ex<=5'b0;
        rd_addr_ex<=5'b0;
        alu_op_ex<=4'b0;
        reg_write_ex<=1'b0;
        alu_src_ex<=1'b0;
        mem_write_ex<=1'b0;
        mem_to_reg_ex<=1'b0;
        branch_ex<=1'b0;
        jump_ex<=1'b0;
    end 
    else if(flush)begin
        pc_ex<=32'b0;
        opcode_ex<=7'b0;
        funct3_ex<=3'b0;
        rs1_data_ex<=32'b0;
        rs2_data_ex<=32'b0;
        imm_i_ex<=32'b0;
        imm_s_ex<=32'b0;
        imm_b_ex<=32'b0;
        imm_j_ex<=32'b0;
        imm_u_ex<=32'b0;
        rs1_addr_ex<=5'b0;
        rs2_addr_ex<=5'b0;
        rd_addr_ex<=5'b0;
        alu_op_ex<=4'b0;
        reg_write_ex<=1'b0;
        alu_src_ex<=1'b0;
        mem_write_ex<=1'b0;
        mem_to_reg_ex<=1'b0;
        branch_ex<=1'b0;
        jump_ex<=1'b0;
    end 
    else if(!stall)begin
        pc_ex<= pc_id;
        opcode_ex<=opcode;
        funct3_ex<=funct3;
        rs1_data_ex<=rs1_data;
        rs2_data_ex<=rs2_data;
        imm_i_ex<=imm_i;
        imm_s_ex<=imm_s;
        imm_b_ex<=imm_b;
        imm_j_ex<=imm_j;
        imm_u_ex<=imm_u;
        rs1_addr_ex<=rs1_addr;
        rs2_addr_ex<=rs2_addr;
        rd_addr_ex<=rd_addr;
        alu_op_ex<=alu_op;
        reg_write_ex<=reg_write;
        alu_src_ex<=alu_src;
        mem_write_ex<=mem_write;
        mem_to_reg_ex<=mem_to_reg;
        branch_ex<=branch;
        jump_ex<=jump;
    end
endmodule