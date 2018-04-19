`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2018 02:36:29 PM
// Design Name: 
// Module Name: PulseMode
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


module PulseMode(clk100Mhz, slowClk, sel, start);
    input [1:0] sel;
    input start;
    input clk100Mhz; //fast clock
    output reg slowClk; //slow clock
    wire secondClk;
    reg[27:0] counter;
    reg[9:0] count;
    reg[27:0] frequency;
    reg[27:0] variableFrequency;
    initial begin
        counter = 0;
        slowClk = 0;
        frequency = 0;
        count = 1;
    end
    
    
    clockDivider_1s a(clk100Mhz, secondClk, start);
    
    always@(posedge secondClk)
    begin
        if(sel == 2'b11) begin
            if(count == 1)begin
                variableFrequency <= 5000000/2;
            end
            else if(count == 2) begin
                variableFrequency <= 3030303/2;
            end
            else if(count == 3) begin
                variableFrequency <= 1515152/2;
            end
            else if(count == 4) begin
                variableFrequency <= 3703704/2;
            end
            else if(count == 5) begin
                variableFrequency <= 1428571/2;
            end
            else if(count == 6) begin
                variableFrequency <= 3333333/2;
            end
            else if(count == 7) begin
                variableFrequency <= 5263158/2;
            end
            else if(count == 8) begin
                variableFrequency <= 3333333/2;
            end
            else if(count == 9) begin
                variableFrequency <= 3030303/2;
            end                    
            else if(count <= 73) begin
                variableFrequency <= 1449275/2;
            end
            else if(count <= 79) begin
                variableFrequency <= 2941176/2;
            end
            else begin
                variableFrequency <= 806452/2;
            end
            
            count = count + 1;
            
        end
        else begin
            count <= 1;
        end
    end

    
    
    always@(sel) begin
        case(sel) 
            2'b00: frequency <= 3125000;
            2'b01: frequency <= 1562500;
            2'b10: frequency <= 781250;
            default: frequency <= 0; 
        endcase
    end
    
    always @ (posedge clk100Mhz)
        begin
        if(start == 1) begin
            if(sel == 2'b11 && counter == variableFrequency)begin
                      counter <= 1;
                      slowClk <= ~slowClk;
            end
            else if(counter == frequency) begin
              counter <= 1;
              slowClk <= ~slowClk;
            end
            else begin
              counter <= counter + 1;
            end
         end
         else
            counter<=1;
    end
endmodule
