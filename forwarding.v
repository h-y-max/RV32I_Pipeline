module forwarding(
    input [4:0] rs1_addr_ex,
    input [4:0] rs2_addr_ex,
    input [4:0] rd_addr_mem,
    input [4:0] rd_addr_wb,
    input reg_write_mem,
    input reg_write_wb,
    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);
    always@(*)begin
        forward_a=2'b00;
        forward_b=2'b00;
        // Forward A (rs1)
        if(reg_write_mem && (rd_addr_mem!=5'b0) && (rd_addr_mem==rs1_addr_ex))
            forward_a=2'b10;
        else if(reg_write_wb && (rd_addr_wb!=5'b0) && (rd_addr_wb==rs1_addr_ex))
            forward_a=2'b01;
        // Forward B (rs2) 
        if(reg_write_mem && (rd_addr_mem!=5'b0) && (rd_addr_mem==rs2_addr_ex))
            forward_b=2'b10;
        else if(reg_write_wb && (rd_addr_wb!=5'b0) && (rd_addr_wb==rs2_addr_ex))
            forward_b=2'b01;
    end
endmodule
