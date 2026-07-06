module hazard_detection(
    input [4:0] rs1_addr_id,
    input [4:0] rs2_addr_id,
    input [4:0] rd_addr_ex,
    input mem_to_reg_ex,
    output reg pc_stall,
    output reg if_id_stall,
    output reg id_ex_flush
);
always@(*)begin
     pc_stall=1'b0;
     if_id_stall=1'b0;
     id_ex_flush=1'b0;
     if (mem_to_reg_ex && (rd_addr_ex!=5'b0) &&((rd_addr_ex==rs1_addr_id) || (rd_addr_ex==rs2_addr_id))) begin
            pc_stall=1'b1;
            if_id_stall=1'b1;
            id_ex_flush=1'b1;
     end
    end
endmodule