module SwitchDriver(Bup, Bdown, Bleft, Bright, clk);

input Bup, Bdown, Bleft, Bright, clk;
//output Sout;
reg slow_clock, fast_clock, clock_2ms;
reg Bup_d, Bdown_d, Bleft_d, Bright_d;
reg [13:0] count;

// get the slow clock
clockdivider_1Hz div(clk, slow_clock);
clockdivider_2Hz div2(clk, fast_clock);
// get 2 ms clock for debouncing
clockdivider_2ms(clk, clock_2ms);

// send button signals through debounce and single pulse circuit
SinglePulse(Bup, clock_2ms, Bup_d);
SinglePulse(Bdown, clock_2ms, Bdown_d);
SinglePulse(Bleft, clock_2ms, Bleft_d);
SinglePulse(Bright, clock_2ms, Bright_d);

// controller for the count, use debounced signals
ParkingMeter(Bup_d, Bdown_d, Bleft_d, Bright_d, slow_clock, fast_clock, count);



endmodule
