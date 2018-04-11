
module PulseGen(sw, led, seg, an, clk);
input clk;
input [3:0] sw;
output led;
output [6:0] seg;
output [3:0] an;

reg step, reset;

// fitbit calculates all the data to display and contains seven segment module
Fitbit FB(step, clk, reset, seg, an, led);

endmodule
