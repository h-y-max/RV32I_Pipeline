module IF_ID(
    input CLK,
    input reset_n,
    input stall,
    input flush,
    input [31:0] pc_if,
    input [31:0] inst_if,
    output reg [31:0] pc_id,
    output reg [31:0] inst_id
);
always@(posedge CLK or negedge reset_n)
    if(!reset_n)begin
        pc_id<= 32'b0;
        inst_id<=32'b0;
    end 
    else if(flush)begin
        pc_id<=32'b0;
        inst_id<=32'b0;
    end 
    else if(!stall)begin
        pc_id<=pc_if;
        inst_id<=inst_if;
    end
endmodule
