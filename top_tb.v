`timescale 1ns / 1ps
module top_tb();
      reg CLK;
      reg reset_n;
      wire [31:0] pc;
      wire [31:0] inst;
top top_inst(
      .CLK(CLK),
      .reset_n(reset_n),
      .pc(pc),
      .inst(inst)
);

initial CLK=0;
always #5 CLK=~CLK;

initial begin
reset_n=0;
#100;
reset_n=1;
#500;
$finish;
end
endmodule
