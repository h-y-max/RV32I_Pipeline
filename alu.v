module alu(
       input [31:0] a,
       input [31:0] b,
       input [3:0] alu_op,
       output reg [31:0] result
    );
always@(*)begin
      case(alu_op)
         4'b0000:result=a + b;//add,addi
         4'b0001:result=a - b;//sub
         4'b0010:result=b;//pass
         4'b0011:result=a & b;//and,andi
         4'b0100:result=a | b;//or,ori
         4'b0101:result=($signed(a)<$signed(b))?1:0;//slt,slti
         4'b0110:result=(a<b)?1:0;//sltu
       default:result=32'b0;
     endcase
 end
endmodule
