module MEM_WB(
    input CLK,
    input reset_n,
    input stall,
    input flush,
    input [31:0] pc_mem,
    input [31:0] alu_result_mem,
    input [31:0] read_data_mem,
    input [4:0] rd_addr_mem,
    input reg_write_mem,
    input mem_to_reg_mem,
    output reg [31:0] pc_wb,
    output reg [31:0] alu_result_wb,
    output reg [31:0] read_data_wb,
    output reg [4:0] rd_addr_wb,
    output reg reg_write_wb,
    output reg mem_to_reg_wb
);

    always@(posedge CLK or negedge reset_n)
        if(!reset_n) begin
            pc_wb <= 32'b0;
            alu_result_wb <= 32'b0;
            read_data_wb <= 32'b0;
            rd_addr_wb <= 5'b0;
            reg_write_wb <= 1'b0;
            mem_to_reg_wb <= 1'b0;
        end
        else if(flush) begin
            pc_wb <= 32'b0;
            alu_result_wb <= 32'b0;
            read_data_wb <= 32'b0;
            rd_addr_wb <= 5'b0;
            reg_write_wb <= 1'b0;
            mem_to_reg_wb <= 1'b0;
        end
        else if(!stall) begin
            pc_wb <= pc_mem;
            alu_result_wb <= alu_result_mem;
            read_data_wb <= read_data_mem;
            rd_addr_wb <= rd_addr_mem;
            reg_write_wb <= reg_write_mem;
            mem_to_reg_wb <= mem_to_reg_mem;
        end

endmodule