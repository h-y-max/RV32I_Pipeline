module pc(
    input CLK,
    input reset_n,
    input stall,
    input [31:0] pc_next,
    output reg [31:0] pc
);

    always@(posedge CLK or negedge reset_n)
        if(!reset_n)
            pc<=32'b0;
        else if(!stall)
            pc<=pc_next;
endmodule
