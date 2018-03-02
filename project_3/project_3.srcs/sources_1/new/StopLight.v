
module StopLight(rst, Ra, Ya, Ga, 
                        Rb,Yb,Gb,
                        Rw,Yw,Gw, clk);
    output reg Ra, Ya, Ga, Rb,Yb,Gb, Rw,Yw,Gw = 0;
    input wire rst, clk = 0;
    reg [2:0] state, next_state = 3'b0;
    reg [3:0] counter= 4'b0000;
    reg [3:0] next_counter= 4'b0000;
    
    initial
    begin
        state = 3'b0;
        next_counter= 4'b0000;
    end
    
    always @(posedge clk, posedge rst)
    begin
        if(rst == 1)
        begin
            counter = 4'b0000;
            state = 3'b0;
        end
        else if(counter == 4'b0000)
        begin
            counter = next_counter;
            state = next_state;
        end
        else
            counter = counter - 1;
    end
    
    always@(counter)
    begin           
        if(counter == 0)
        begin
            if(state == 3'b0)
            begin
                Ra <= 0;
                Ya <= 0;
                Ga <= 1;
                Rb <= 1;
                Yb <= 0;
                Gb <= 0;
                Rw <= 1;
                Yw <= 0;
                Gw <= 0;
                next_counter <= 3;
                next_state <= 3'b001;
            end
            else if(state == 3'b001)
            begin
                Ra <= 0;
                Ya <= 1;
                Ga <= 0;
                Rb <= 1;
                Yb <= 0;
                Gb <= 0;
                Rw <= 1;
                Yw <= 0;
                Gw <= 0;
                next_counter <= 2;
                next_state <= 3'b010;
            end
            else if(state == 3'b010)
            begin
                Ra <= 1;
                Ya <= 0;
                Ga <= 0;
                Rb <= 0;
                Yb <= 0;
                Gb <= 1;
                Rw <= 1;
                Yw <= 0;
                Gw <= 0;
                next_counter <= 3;
                next_state <= 3'b011;       
            end
            else if(state == 3'b011)
            begin
                Ra <= 1;
                Ya <= 0;
                Ga <= 0;
                Rb <= 0;
                Yb <= 1;
                Gb <= 0;
                Rw <= 1;
                Yw <= 0;
                Gw <= 0;
                next_counter <= 1;
                next_state <= 3'b100;
            end
            else if(state == 3'b100)
            begin
                Ra <= 1;
                Ya <= 0;
                Ga <= 0;
                Rb <= 1;
                Yb <= 0;
                Gb <= 0;
                Rw <= 0;
                Yw <= 0;
                Gw <= 1;
                next_counter <= 2;
                next_state <= 3'b101;
            end
            else if(state == 3'b101)
            begin
                Ra <= 0;
                Ya <= 0;
                Ga <= 1;
                Rb <= 1;
                Yb <= 0;
                Gb <= 0;
                Rw <= 0;
                Yw <= 1;
                Gw <= 0;
                next_counter <= 2;
                next_state <= 3'b000;
            end
        end       
    end     
endmodule



module LightController(clk,rst, LightSignal);
    output reg [8:0] LightSignal;
    input clk,rst;
    wire slow_clk1, slow_clk2;
    wire [8:0] Signal;
    simpleDivider(clk100Mhz, slowClk1);
    //clockDivider_1Hz divider1(clk, slow_clk1);
    clockDivider_2Hz divider2(clk, slow_clk2);
    StopLight aStoplight(rst, Signal[8], Signal[7], Signal[6],Signal[5],Signal[4],Signal[3], Signal[2],Signal[1],Signal[0], slow_clk1);
    always @(posedge slow_clk2, posedge rst)
    begin
        if(rst == 1'b1)
        begin
            //LightSignal = LightSignal & 9'b100100100;
            LightSignal[8] <= ~LightSignal[8];
            LightSignal[5] <= ~LightSignal[5];
            LightSignal[2] <= ~LightSignal[2];
        end
        else
        begin
            LightSignal[8] <= Signal[8];
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