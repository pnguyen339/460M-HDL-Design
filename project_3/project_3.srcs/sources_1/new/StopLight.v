
module StopLight(rst, Ra, Ya, Ga, Rb, Yb, Gb, Rw, Gw, fast_clk, slow_clk);
    
    output Ra, Ya, Ga, Rb, Yb, Gb, Rw, Gw;
    input rst,slow_clk, fast_clk;
    reg Ra, Ya, Ga, Rb, Yb, Gb, Rw, Gw;
    reg flag;
    reg [2:0] state, next_state;
    reg [3:0] counter;
    reg [3:0] next_counter;
    
    initial
    begin
        counter = 4'b0011<<2;
        state = 3'b000;
	flag = 0;
        Rw = 1;
    end
    
    always @(posedge fast_clk, posedge rst)
    begin
        if(rst == 1)
        begin
            counter <= 1;
            state <= 3'b111;
        end
        else if(counter == 4'b0000)
        begin
            counter <= next_counter-1;
            state <= next_state;
        end
        else
            counter = counter - 1;
    end
    
    always@(state)
    begin         
            if(state == 3'b000) begin
                Ra <= 0;
                Ya <= 0;
                Ga <= 1;
                Rb <= 1;
                Yb <= 0;
                Gb <= 0;
                Rw <= 1;
                Gw <= 0;
                next_counter <= 4;
                next_state <= 3'b001;
                flag <= 0;
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
                Gw <= 0;
                next_counter <= 6;
                next_state <= 3'b010;
                flag <= 0;
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
                Gw <= 0;
                next_counter <= 2;
                next_state <= 3'b011; 
                flag <= 0;      
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
                Gw <= 0;
                next_counter <= 4;
                next_state <= 3'b100;
                flag <= 0;
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
                Gw <= 1;
                next_counter <= 4;
                next_state <= 3'b101;
                flag <= 0;
            end
            else if(state == 3'b101)
            begin
                Ra <= 1;
                Ya <= 0;
                Ga <= 0;
                Rb <= 1;
                Yb <= 0;
                Gb <= 0;
	            Rw <= fast_clk;
                Gw <= 0;
                next_counter <= 6;
                next_state <= 3'b000;
                flag <= 1;
            end
            else if(state == 3'b111)
            begin
                Ra <= slow_clk;
                Ya <= 0;
                Ga <= 0;
                Rb <= slow_clk;
                Yb <= 0;
                Gb <= 0;
                Rw <= slow_clk;
                Gw <= 0;
                next_counter <= 6;
                next_state <= 3'b000;
                flag <= 1;
            end
            else begin
                  flag <= 0;
                  Ra <= 0;
                  Ya <= 0;
                  Ga <= 0;
                  Rb <= 0;
                  Yb <= 0;
                  Gb <= 0;
                  Rw <= 0;
                  Gw <= 0;
                  next_counter <= 1;
                  next_state <= 3'b000;
                    
	        end       
    end 
endmodule



module LightController(clk,rst, LightSignal);
    output wire [7:0] LightSignal;
    input clk,rst;
    wire slow_clk1, slow_clk2;
    wire [8:0] Signal;
    
    clockDivider_2Hz divider2(clk, slow_clk2);
    clockDivider_1Hz divider1(clk, slow_clk1);
    
    StopLight aStoplight(rst, LightSignal[0], LightSignal[1],LightSignal[2],LightSignal[5],LightSignal[6], LightSignal[7],LightSignal[4],LightSignal[3], slow_clk2, slow_clk1);
    
endmodule