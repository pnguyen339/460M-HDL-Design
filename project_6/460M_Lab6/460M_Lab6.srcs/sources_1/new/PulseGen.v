
module PulseGen(sw, led, seg, an, clk);
input clk;
input [3:0] sw;
output led;
output [6:0] seg;
output [3:0] an;

wire step;
//wire reset, start;
//wire [1:0] mode;
//wire clk_32, clk_64, clk_128;

PulseMode a(clk, step, sw[3:2], sw[1], sw[0], clk_1s);

// fitbit calculates all the data to display and contains seven segment module
Fitbit FB(step, clk, sw[1], seg, an, led, clk_16ms, sw[0], clk_1s);

clockDivider_1s clockdiv1(clk, clk_1s, sw[1], sw[0]);
//assign mode = sw[3:2];
//assign reset = sw[1];
//assign start = sw[0];
//always @(clk) begin
//  // generate a pulse if start is 1
//  if(start == 1) begin
//    if(mode == 0) begin // 32 steps per sec
//      step <= clk_32;
//    end
//    else if(mode == 1) begin // 64 steps per sec
//      step <= clk_64;
//    end
//    else if(mode == 2) begin // 128 steps per sec
//      step <= clk_128;  
//    end
//    else begin // hybrid
  
//    end
//  end
//  else begin
//    step <= 1'b0;
//  end
//end

//clockDivider_32 clockdiv32(clk, clk_32, start);
//clockDivider_64 clockdiv64(clk, clk_64, start);
//clockDivider_128 clockdiv128(clk, clk_128, start);
clockDivider_16ms clockdiv16ms(clk, clk_16ms);

endmodule
