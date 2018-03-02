module Sorter(clk, weight, reset, Grp1, Grp2, Grp3, Grp4, Grp5, Grp6, currentGrp);
input clk, reset;
input [11:0] weight;
output [7:0] Grp1, Grp2, Grp3, Grp4, Grp5, Grp6;
output [2:0] currentGrp;

// create a reg version of currentGrp
reg [2:0] current;
assign currentGrp = current;

// create regs for the output groups
reg [7:0] Grp1, Grp2, Grp3, Grp4, Grp5, Grp6;
reg Zflag;

// initialize counts to 0
initial begin
  Grp1 <= 0;
  Grp2 <= 0;
  Grp3 <= 0;
  Grp4 <= 0;
  Grp5 <= 0;
  Grp6 <= 0;
  Zflag <= 1'b0;
end

// use always block to model combinational logic
always @* begin
  if(weight == 0) current <= 0;
  else if(weight < 8'b11111011) current <= 1;
  else if(weight < 9'b111110101) current <= 2;
  else if(weight < 10'b1011101111) current <= 3;
  else if(weight < 11'b10111011101) current <= 4;
  else if(weight < 11'b11111010001) current <= 5;
  else current <= 6;
end

always @(negedge clk, posedge reset) begin

  // asynchronous reset
  if(reset == 1'b1) begin
    Grp1 <= 0;
    Grp2 <= 0;
    Grp3 <= 0;
    Grp4 <= 0;
    Grp5 <= 0;
    Grp6 <= 0;
    Zflag <= 1'b0;
  end
  // if not reset
  else begin
    // if previous weight was removed
    if(Zflag == 1'b0) begin
      Zflag <= 1'b1;
      // increment the group count
      case(currentGrp)
	0: Zflag <= 1'b0;
        1: Grp1 <= Grp1 + 1;
	2: Grp2 <= Grp2 + 1;
	3: Grp3 <= Grp3 + 1;
	4: Grp4 <= Grp4 + 1;
	5: Grp5 <= Grp5 + 1;
	6: Grp6 <= Grp6 + 1;
	default: Zflag <= 1'b1;
      endcase
    end
    // set the flag to 0 if the current weight is 0
    else begin
      if(currentGrp == 0) Zflag <= 1'b0;
      else Zflag <= 1'b1;
    end  
  end
end
endmodule
