module BCDCounter1(clr, clk, enable, load, up, d, q, co);

input enable, load, up, clr, clk;
input wire [3:0] d;

output reg [3:0] q;
output reg co;

reg [3:0] count;
reg [3:0] next_count;

always @ (negedge clr, posedge clk)
begin
	if (clr == 0) begin
		q <= 0;
		count <= 0;
	end else begin
		q <= next_count;
		count <= next_count;
	end
end

always @ (clr, count, d, enable, load, up)
begin
	if (clr == 0) begin
		next_count <= 0;
	end else if (load == 1 && enable == 1) begin
		next_count <= d;
	end else if (load == 0 && enable == 1 && up == 1) begin
		if (count == 9) begin
			next_count <= 0;
		end else begin		
			next_count <= count + 1;
		end
	end else if (load == 0 && enable == 1 && up == 0) begin
		if (count == 0) begin
			next_count <= 9;
		end else begin		
			next_count <= count - 1;
		end
	end else begin
		next_count <= count;
	end

	if (clr == 0) begin
		co <= 0;
	end else if (enable == 1 && up == 1 && count == 9) begin
		co <= 1;
	end else if (enable == 1 && up == 0 && count == 0) begin
		co <= 1;
	end else begin
		co <= 0;
	end
end

endmodule


module top(clr, clk, enable, load, up, d, q, co);
input clr, clk, enable, load, up;
input wire [3:0] d;

output wire [3:0] q;
output wire co;

wire slow_clk;

simpleDivider divider_inst1(clk, slow_clk);

BCDCounter1 bcd_inst1(clr, slow_clk, enable, load, up, d, q, co);

endmodule
