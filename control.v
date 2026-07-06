module control(
       input [6:0] opcode,
       input [2:0] funct3,
       input [6:0] funct7,
       output reg reg_write,
       output reg alu_src,
       output reg mem_write,
       output reg mem_to_reg,
       output reg branch,
       output reg jump,
       output reg [3:0] alu_op
    );
       always@(*)begin
            reg_write=0;
            alu_src=0;
            mem_write=0;
            mem_to_reg=0;
            branch=0;
            jump=0;
            alu_op=4'b0000;
            case(opcode)
               7'b011_0011://RÐÍ
                    begin
                      reg_write=1;
                      case({funct7,funct3})
                          {7'b000_0000,3'b000}:alu_op=4'b0000;//add
                          {7'b010_0000,3'b000}:alu_op=4'b0001;//sub
                          {7'b000_0000,3'b111}:alu_op=4'b0011;//and
                          {7'b000_0000,3'b110}:alu_op=4'b0100;//or
                          {7'b000_0000,3'b010}:alu_op=4'b0101;//slt
                        default:alu_op=4'b0000;
                      endcase
                    end
               7'b001_0011://IÐÍ
                    begin
                      reg_write=1;
                      alu_src=1;
                      case(funct3)
                          3'b000:alu_op=4'b0000;//addi
                          3'b111:alu_op=4'b0011;//andi
                          3'b110:alu_op=4'b0100;//ori
                          3'b010:alu_op=4'b0101;//slti
                        default:alu_op=4'b0000;
                      endcase
                    end
               7'b000_0011://lw
                    begin
                      reg_write=1;
                      alu_src=1;
                      mem_to_reg=1;
                      alu_op=4'b0000;
                    end
               7'b010_0011://sw
                    begin
                      mem_write=1;
                      alu_src=1;
                      alu_op=4'b0000;
                   end
               7'b110_0011://beq,bne
                   begin
                      branch=1;
                      alu_op=4'b0001;
                   end
               7'b110_1111://jal
                   begin
                      jump=1;
                      reg_write=1;
                   end
               7'b110_0111://jalr
                   begin
                      jump=1;
                      reg_write=1;
                      alu_src=1;
                      alu_op=4'b0000;
                   end
               7'b011_0111://lui
                   begin
                      reg_write=1;
                      alu_src=1;
                      alu_op=4'b0010;//pass
                   end
             default:begin
                       reg_write=0;
                       alu_src=0;
                       mem_write=0;
                       mem_to_reg=0;
                       branch=0;
                       jump=0;
                       alu_op=4'b0000;
                     end
         endcase
      end
endmodule
