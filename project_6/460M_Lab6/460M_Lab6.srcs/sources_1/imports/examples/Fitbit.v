
module Fitbit(step, clk, reset, seg, an, SI);
input step, clk, reset;
output SI;
output [6:0] seg;
output [3:0] an;

reg [14:0] step_count, old_count, difference;
reg [3:0] count_9; 
reg[3:0] count; // draw to ss
wire [13:0] step_ss; // draw to ss
wire [7:0] miles; // draw to ss
wire SI, slow_clk;

assign SI = (step_count > 9999) ? 1 : 0; // set SI when ss is saturated
assign step_ss = (step_count > 9999) ? 9999 : step_count; // step_ss saturates at 9999
assign miles = step_count / 1024; // miles is double the distance covered so .5 can be used

clockDivider_1Hz clockdiv(clk, slow_clk);

initial begin
  count <= 0;
  count_9 <= 0;
  step_count <= 0;
  old_count <= 0;
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

always @(posedge slow_clk, posedge reset) begin
  
  difference = step_count - old_count;

  if(difference >= 32 && count_9 < 9) begin
    count <= count + 1;
  end
  
  count_9 <= count_9 + 1;
  old_count <= step_count; 

  if(reset == 1) begin
    count <= 0;
    count_9 <= 0;
    old_count <= 0;
  end
end

endmodule
