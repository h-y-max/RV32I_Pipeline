module EX_MEM(
    input CLK,
    input reset_n,
    input stall,
    input flush,
    input [31:0] pc_ex,
    input [31:0] alu_result,
    input [31:0] rs2_data_ex,
    input [4:0] rd_addr_ex,
    input reg_write_ex,
    input mem_write_ex,
    input mem_to_reg_ex,
//mem
    output reg [31:0] pc_mem,
    output reg [31:0] alu_result_mem,
    output reg [31:0] rs2_data_mem,
    output reg [4:0] rd_addr_mem,
    output reg reg_write_mem,
    output reg mem_write_mem,
    output reg mem_to_reg_mem
);

always@(posedge CLK or negedge reset_n) 
    if(!reset_n)begin
        pc_mem<=32'b0;
        alu_result_mem<=32'b0;
        rs2_data_mem<=32'b0;
        rd_addr_mem<=5'b0;
        reg_write_mem<=1'b0;
        mem_write_mem<=1'b0;
        mem_to_reg_mem<=1'b0;
    end 
    else if(flush)begin
        pc_mem<=32'b0;
        alu_result_mem<=32'b0;
        rs2_data_mem<=32'b0;
        rd_addr_mem<=5'b0;
        reg_write_mem<=1'b0;
        mem_write_mem<=1'b0;
        mem_to_reg_mem<=1'b0;
    end 
    else if(!stall)begin
        pc_mem<=pc_ex;
        alu_result_mem<=alu_result;
        rs2_data_mem<=rs2_data_ex;
        rd_addr_mem<=rd_addr_ex;
        reg_write_mem<=reg_write_ex;
        mem_write_mem<=mem_write_ex;
        mem_to_reg_mem<=mem_to_reg_ex;
    end
endmodule