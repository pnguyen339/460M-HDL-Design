
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2018 08:11:18 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define break_check keypress[8:1]
`define break_code keypress[19:12]

module Top(PS2Clk,PS2Data,seg,an,clk
    );
    input wire PS2Clk;
    input wire PS2Data;
    output wire [6:0]seg;
    output wire [3:0] an;
    input  wire clk;
    wire clock2Hz;
    wire [21:0] keypress;
    reg [7:0] key, key2;
    
    
    always @(posedge PS2Clk)
      begin
        //LED0 <= 0;
        if (`break_check == 8'hF0) begin
            key <= `break_code;
            key2 <= {key[3:0], key[7:4]}; 
        end
      end
    kb_scan k(PS2Clk, PS2Data, keypress);
    clockDivider_2ms c(clk, clock2Hz);
    NumberDisplay a(key2, seg, an, clock2Hz);
     
endmodule
