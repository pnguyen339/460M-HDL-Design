
module Fitbit(step, clk, reset, seg, an, SI, clk_16ms);
input step, clk, reset, clk_16ms;
output SI;
output [6:0] seg;
output [3:0] an;

reg [14:0] step_count, old_count, difference;
reg [3:0] count_9; 
reg [3:0] count; // draw to ss
reg [3:0] display_mode; // total steps, miles, steps over 32, high activity
reg [13:0] high_activity_count;
reg [13:0] high_activity_display; // draw to ss
reg [3:0] d1, d2, d3, d4;
reg [13:0] step_copy;
wire [13:0] step_ss; // draw to ss
wire [7:0] miles; // draw to ss
wire SI, slow_clk, slow_clk2;

assign SI = (step_count > 9999) ? 1 : 0; // set SI when ss is saturated
assign step_ss = (step_count > 9999) ? 9999 : step_count; // step_ss saturates at 9999
assign miles = step_count / 1024; // miles is double the distance covered so .5 can be used

clockDivider_1Hz clockdiv(clk, slow_clk);
clockDivider_2Hz clockdiv2(clk, slow_clk2);

initial begin
  count <= 0;
  count_9 <= 0;
  step_count <= 0;
  old_count <= 0;
  high_activity_count <= 0;
  high_activity_display <= 0;
  display_mode <= 0;
end

always @(posedge step, posedge reset) begin
  
  // reset step count 
  if(reset == 1) begin
    step_count <= 0;
  end
  // increment step count
  else begin
    step_count <= step_count + 1;
  end
end

// runs every second
always @(posedge slow_clk, posedge reset) begin
  
  // gets the number of steps in the last second
  difference = step_count - old_count;
  
  // check if activity is over 32 steps per second
  if(difference >= 32 && count_9 < 9) begin
    count <= count + 1;
    if(count > 9) count <= 9;
  end
  if(count_9 < 10) count_9 <= count_9 + 1;
  
  // check if activity is over 64 steps per second, increment count
  if(difference >= 64) begin
    high_activity_count <= high_activity_count + 1;
  end
  else begin
    high_activity_count <= 0;
  end
  
  // add 60 to display if there are 60 continuous seconds
  if(high_activity_count == 60) begin
    high_activity_display <= high_activity_display + 60;
  end
  // add 1 to the display every second after that
  else if(high_activity_count > 60) begin
    high_activity_display <= high_activity_display + 1;
  end
  
  old_count <= step_count; 

  if(reset == 1) begin
    count <= 0;
    count_9 <= 0;
    old_count <= 0;
    high_activity_count <= 0;
    high_activity_display <= 0;
  end
end

NumberDisplay({d4,d3,d2,d1}, seg, an, clk_16ms);

always @(posedge slow_clk2) begin
  
  // display 4 digits of the step count
  if(display_mode == 0) begin
    step_copy = step_ss;
    d1 = step_copy % 10;
    step_copy = step_copy / 10;
    d2 = step_copy % 10;
    step_copy = step_copy / 10;
    d3 = step_copy % 10;
    step_copy = step_copy / 10;
    d4 = step_copy % 10;
  end
  // display miles, _5 for decimal
  else if(display_mode == 1) begin
    if(miles % 2 == 1) begin
      d1 <= 5;
      d2 <= 10;
      step_copy =  miles / 2;
      d3 = step_copy % 10;
      step_copy = step_copy / 10;
      d4 = step_copy % 10;
    end
    else begin
      step_copy = miles;
      d1 <= step_copy % 10;
      step_copy = step_copy / 10;
      d2 <= step_copy % 10;
      step_copy = step_copy / 10;
      d3 <= step_copy % 10;
      step_copy = step_copy / 10;
      d4 <= step_copy % 10;
    end
  end
  // display the number of active seconds over 32 steps/s
  else if(display_mode == 2) begin
    d1 <= count;
    d2 <= 0;
    d3 <= 0;
    d4 <= 0;
  end
  // display high activity counter
  else begin
    step_copy = high_activity_display;
    d1 = step_copy % 10;
    step_copy = step_copy / 10;
    d2 = step_copy % 10;
    step_copy = step_copy / 10;
    d3 = step_copy % 10;
    step_copy = step_copy / 10;
    d4 = step_copy % 10;  
  end
  
  display_mode <= display_mode + 1;
  if(display_mode == 4) begin 
    display_mode <= 0;
  end 
end

endmodule
