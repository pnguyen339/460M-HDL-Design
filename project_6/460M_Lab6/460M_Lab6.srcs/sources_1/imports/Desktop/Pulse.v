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


module PulseMode(clk100Mhz, slowClk, sel, reset, start, secondClk);
    input [1:0] sel;
    input start, reset, secondClk;
    input clk100Mhz; //fast clock
    output reg slowClk; //slow clock
    wire secondClk;
    reg noPulse;
    reg[27:0] counter;
    reg[10:0] count;
    reg[27:0] frequency;
    reg[27:0] variableFrequency;
    initial begin
        noPulse <= 0;
        counter <= 0;
        slowClk <= 0;
        frequency <= 0;
        count <= 1;
    end
    
    
    //clockDivider_1s a(clk100Mhz, secondClk, reset, start);
    
    always@(posedge secondClk, posedge reset)
    begin
        if(reset == 1) begin
            count<=1;
        end
        else if(sel == 2'b11) begin
            if(count == 1)begin
                variableFrequency <= 2500000;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count == 2) begin
                variableFrequency <= 1515145;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count == 3) begin
                variableFrequency <= 757576;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count == 4) begin
                variableFrequency <= 1851852;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count == 5) begin
                variableFrequency <= 714286;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count == 6) begin
                variableFrequency <= 1666667;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count == 7) begin
                variableFrequency <= 2631579;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count == 8) begin
                variableFrequency <= 1666667;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count == 9) begin
                variableFrequency <= 1400000;
                count <= count + 1;
                noPulse <= 0;
            end                    
            else if(count <= 73) begin
                variableFrequency <= 724638;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count <= 79) begin
                variableFrequency <= 1470588;
                count <= count + 1;
                noPulse <= 0;
            end
            else if(count <=145)begin
                variableFrequency <= 402326;
                count <= count + 1;
                noPulse <= 0;
            end
            else begin
                noPulse <= 1;
            end
                    
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
            2'b11: frequency <= variableFrequency;
            default: frequency <= 3125000; 
        endcase
    end
    
    always @ (posedge clk100Mhz)
        begin
        if(reset == 0 && start == 1 && noPulse == 0) begin
           if(counter == frequency) begin
              counter <= 0;
              slowClk <= ~slowClk;
            end
            else begin
              counter <= counter + 1;
            end
         end
         else begin
            counter <= 0;
            slowClk <= 0;
         end
    end
endmodule
