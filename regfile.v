module regfile(
    input CLK,
    input reset_n,
    input reg_write,
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input [4:0] rd_addr,
    input [31:0] rd_data,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);
    reg [31:0] regs [0:31];
    integer i;
    
    assign rs1_data=(rs1_addr==5'b0)?32'b0:
                      (reg_write && rs1_addr==rd_addr)?rd_data: 
                      regs[rs1_addr];
                      
    assign rs2_data=(rs2_addr==5'b0)?32'b0:
                      (reg_write && rs2_addr==rd_addr)?rd_data : 
                      regs[rs2_addr];
    
    // 写端口：posedge（标准做法）
    always@(posedge CLK or negedge reset_n)
        if(!reset_n)
            for (i=0; i<32; i=i+1)
                regs[i]<=32'b0;
        else if((rd_addr!=5'b0) && reg_write)
            regs[rd_addr]<=rd_data;

endmodule