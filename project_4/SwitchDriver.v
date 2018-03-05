module SwitchDriver(Bup, Bdown, Bleft, Bright, clk);

input Bup, Bdown, Bleft, Bright;
//output Sout;
reg slow_clock, fast_clock;
reg [13:0] count;

// get the slow clock
clockdivider_1Hz div(clk, slow_clock);
clockdivider_2Hz div2(clk, fast_clock);

// controller for the count, use debounced signals
ParkingMeter(Bup, Bdown, Bleft, Bright, slow_clock, fast_clock, count);



endmodule
