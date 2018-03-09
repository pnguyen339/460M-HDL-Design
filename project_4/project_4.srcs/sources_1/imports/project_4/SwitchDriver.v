module SwitchDriver(Bup, Bdown, Bleft, Bright, clk, seg, an, sw0, sw1);

input Bup, Bdown, Bleft, Bright, clk, sw0, sw1;
//output led;
output wire [6:0] seg;
output wire [3:0] an;
//output Sout;
wire clock1hz, clock2hz, clock_2ms, clock_16ms, clock_half;
wire Bup_d, Bdown_d, Bleft_d, Bright_d;
wire [13:0] count;


// get the slow clock
clockDivider_1Hz div(clk, clock1hz);
clockDivider_2Hz div2(clk, clock2hz);
// get 2 ms clock for debouncing
clockDivider_Half_Hz div3(clk, clock_half);
clockDivider_16ms div4(clk, clock_16ms);
//flashing light



// send button signals through debounce and single pulse circuit
SinglePulse but1(Bup, clock_16ms, Bup_d);
SinglePulse but2(Bdown, clock_16ms, Bdown_d);
SinglePulse but3(Bleft, clock_16ms, Bleft_d);
SinglePulse but4(Bright, clock_16ms, Bright_d);

// controller for the count, use debounced signals
ParkingMeter a(Bup_d, Bdown_d, Bleft_d, Bright_d, clk, count, sw0, sw1, clock_half);
//FlashingLight l(count, clock2hz, clock1hz, led);
NumberDisplay dis(count, seg, an, clock_16ms,clock1hz, clock_half, sw0, sw1);

endmodule
