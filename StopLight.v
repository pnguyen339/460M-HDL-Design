
module StopLight(rst, Ra, Ya, Ga, Rb,Yb,Gb, Rw, Yw, Gw, clk);
    
    output Ra, Ya, Ga, Rb, Yb, Gb, Rw, Yw, Gw;
    input rst, clk;
    reg Ra, Ya, Ga, Rb, Yb, Gb, Rw, Yw, Gw;
    reg [2:0] state, next_state;
    reg [3:0] counter;
    reg [3:0] next_counter;
    
    initial
    begin
        counter = 4'b0010;
        state = 3'b000;
    end
    
    always @(posedge clk, posedge rst)
    begin
        if(rst == 1)
        begin
            counter <= 4'b0000;
            state <= 3'b000;
        end
        else if(counter == 4'b0000)
        begin
            counter <= next_counter;
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
                Yw <= 0;
                Gw <= 0;
                next_counter <= 1;
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
                next_counter <= 0;
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
                next_counter <= 1;
                next_state <= 3'b101;
            end
            else if(state == 3'b101)
            begin
                Ra <= 1;
                Ya <= 0;
                Ga <= 0;
                Rb <= 1;
                Yb <= 0;
                Gb <= 0;
                Rw <= 0;
                Yw <= 1; // should be flash walk, no yellow walk
                Gw <= 0;
                next_counter <= 2;
                next_state <= 3'b000;
            end
            //else begin
	     // assign led to flash       
    end     
endmodule



