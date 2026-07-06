module imem(
       input [31:0] addr,
       output [31:0] inst
    );
       reg [31:0] mem [0:255];
  initial begin
   $readmemh("D:/Vivado/normal/RV32I_Pipeline/RV32I_Pipeline.sim/sim_1/behav/xsim/program.hex.txt", mem);
  end
assign inst=mem[addr[9:2]];
endmodule
