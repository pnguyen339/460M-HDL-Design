//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2018 07:10:31 AM
// Design Name: 
// Module Name: KeyboardInput
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


module KeyboardInput(
    input PS2Clk,
    input PS2Data,
    output reg [7:0] OutData
    );
 reg [3:0] counter;   
 reg start;
 reg break_code;
 reg [7:0] shift_reg;
 initial
 begin
        shift_reg = 8'b0;
        counter = 4'b0;
 end
 
 always@(negedge PS2Clk, negedge PS2Data)
 begin
    if(start != 1 && PS2Data == 0) begin
         start = 1;
         counter = 8;
    end
    else begin
        if(start == 1 && counter > 1) begin
            shift_reg <= shift_reg | (PS2Data<<(counter-1));
            counter = counter -1;
        end
        else begin
            counter = counter - 1;
        end
        if(counter == 0 && start == 1)begin 
            if(break_code == 1) begin
                 OutData <= shift_reg;
                 shift_reg <= 8'b0;
                 start <= 0;
                 break_code <= 0;
            end
            else begin
                if(shift_reg == 8'hF0) begin
                    break_code <= 1;
                    start <= 0;
                end  
            end
        end
    end     
 end   
endmodule
