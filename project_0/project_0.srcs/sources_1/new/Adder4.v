`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2018 04:15:33 AM
// Design Name: 
// Module Name: Adder4
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
//Figure 2-12 Structural Description of a 4-Bit Adder 
module Adder4 (S, Co, A, B, Ci); 
    output [3:0] S;   
output Co;   
input [3:0] A, B; 
    input Ci; 
    wire [3:1] C; // C is an internal signal 
    // instantiate four copies of the FullAdder 
    FullAdder a1(A[0], B[0], Ci, C[1], S[0]); 
    FullAdder a2(A[1], B[1], C[1], C[2], S[1]); 
    FullAdder a3(A[2], B[2], C[2], C[3], S[2]); 
    FullAdder a4(A[3], B[3], C[3], Co, S[3]); 
endmodule 