module dmem(
    input CLK,
    input [31:0] addr,
    input write_en,
    input [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] mem [0:1023];
    
    assign read_data=mem[addr[11:2]];
    
    always@(posedge CLK)
        if(write_en)
           mem[addr[11:2]]<=write_data;
endmodule



                