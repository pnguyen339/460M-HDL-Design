module SwitchDriver(Bup, Bdown, Bleft, Bright, clk, seg, an);

input Bup, Bdown, Bleft, Bright, clk;
//output led;
output wire [6:0] seg;
output wire [3:0] an;
//output Sout;
wire clock1hz, clock2hz, clock_2ms,clock_16ms;
wire Bup_d, Bdown_d, Bleft_d, Bright_d;
wire [13:0] count;


// get the slow clock
clockDivider_1Hz div(clk, clock1hz);
clockDivider_2Hz div2(clk, clock2hz);
// get 2 ms clock for debouncing
clockDivider_2ms div3(clk, clock_2ms);
clockDivider_16ms div4(clk, clock_16ms);
//flashing light



// send button signals through debounce and single pulse circuit
SinglePulse but1(Bup, clock_2ms, Bup_d);
SinglePulse but2(Bdown, clock_2ms, Bdown_d);
SinglePulse but3(Bleft, clock_2ms, Bleft_d);
SinglePulse but4(Bright, clock_2ms, Bright_d);

// controller for the count, use debounced signals
ParkingMeter a(Bup_d, Bdown_d, Bleft_d, Bright_d, clock1hz, count);
//FlashingLight l(count, clock2hz, clock1hz, led);
NumberDisplay dis(count, seg, an, clock_16ms,clock2hz, clock1hz);

endmodule
