module LightController(clk,rst, LightSignal);
    
    output LightSignal;
    input clk,rst;

    reg slow_clk1, slow_clk2;
    wire [7:0] Signal;
    reg [7:0] LightSignal;
    
    //simpleDivider(clk100Mhz, slowClk1);
    //initial begin
     //   slow_clk1 = 1'b0;
     //   slow_clk2 = 1'b0;
     //   forever #2 slow_clk1 = ~slow_clk1;
     //   slow_clk2 = ~slow_clk2;
    //end

    clockDivider_1Hz divider1(clk, slow_clk1);
    clockDivider_2Hz divider2(clk, slow_clk2);
    StopLight aStoplight(rst, Signal[7], Signal[6],Signal[5],Signal[4],Signal[3], Signal[2],Signal[1],Signal[0], slow_clk1, slow_clk2);
    
    always @(posedge slow_clk2, posedge rst)
    begin
        if(rst == 1'b1)
        begin
            LightSignal = LightSignal & 8'b10010010;
            LightSignal[7] <= ~LightSignal[7];
            LightSignal[4] <= ~LightSignal[4];
            LightSignal[1] <= ~LightSignal[1];
        end
        else
        begin
            LightSignal[7] <= Signal[7];         
            LightSignal[6] <= Signal[6];         
            LightSignal[5] <= Signal[5];         
            LightSignal[4] <= Signal[4];         
            LightSignal[3] <= Signal[3];         
            LightSignal[2] <= Signal[2];         
            LightSignal[1] <= Signal[1];
            LightSignal[0] <= Signal[0];                 
                               
        end
    end
endmodule
