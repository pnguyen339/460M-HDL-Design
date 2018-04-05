
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


module Top(
    input PS2Clk,
    input PS2Data,
    output [6:0]seg,
    input clk
    );
    
    wire [7:0] key;
    KeyboardInput k(PS2Clk, PS2Data, key);
    //NumberDisplay a(
     
endmodule
