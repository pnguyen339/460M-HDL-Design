module SwitchDriver(Bup, Bdown, Bleft, Bright, clk);

input Bup, Bdown, Bleft, Bright, clk;
//output Sout;
wire slow_clock, fast_clock;
wire [13:0] count;

// get the slow clock
clockDivider_1Hz div(clk, slow_clock);
clockDivider_2Hz div2(clk, fast_clock);

// controller for the count, use debounced signals
ParkingMeter(Bup, Bdown, Bleft, Bright, slow_clock, fast_clock, count);



endmodule
