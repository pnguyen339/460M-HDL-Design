module dataflow(x, clk, s, v);

	input clk;
	input x;
	output reg s;
	output reg v;

	reg [2:0] state;
	reg [2:0] next_state;

	initial begin
		next_state = 0;
		state = 0;
	end

	always @ (negedge clk)
	begin
		state <= next_state;
	end

	always @ (x, state)
	begin
		if (x == 0 || x == 1) begin
			next_state[2] <= (state[2] & ~state[1] & state[0]) | (~state[2] & state[1] & state[0]) | (~x & state[1] & ~state[0]);
			next_state[1] <= (~x & ~state[2] & ~state[1]) | (x & ~state[2] & state[1]) | (x & ~state[2] & state[0]);
			next_state[0] <= (x & ~state[2]) | (state[1] & ~state[0]) | (~state[2] & ~state[1] & state[0]);

			s <= (~x & ~state[2] & ~state[0]) | (x & ~state[1] & state[0]) | (~x & state[1]) | (x & state[2] & ~state[0]);
			v <= (x & state[2] & state[1]);
		end else begin
			next_state <= 0;
			s <= 0;
			v <= 0;
		end
	end

endmodule