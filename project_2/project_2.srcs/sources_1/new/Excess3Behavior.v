module behavioral(x, clk, s, v);

	input clk;
	input x;
	output reg s;
	output reg v;

	reg [2:0] state;
	reg [2:0] next_state;

	always @ (negedge clk)
	begin
		state <= next_state;
	end

	always @ (x, state)
	begin
		case (state)
		1: begin
			if (x == 0) begin
				s <= 1; v <= 0; next_state <= 3;
			end else begin
				s <= 0; v <= 0; next_state <= 4;
			end
		end
		2: begin
			if (x == 0) begin
				s <= 0; v <= 0; next_state <= 4;
			end else begin
				s <= 1; v <= 0; next_state <= 4;
			end
		end
		3: begin
			if (x == 0) begin
				s <= 0; v <= 0; next_state <= 5;
			end else begin
				s <= 1; v <= 0; next_state <= 5;
			end
		end
		4: begin
			if (x == 0) begin
				s <= 1; v <= 0; next_state <= 5;
			end else begin
				s <= 0; v <= 0; next_state <= 6;
			end
		end
		5: begin
			if (x == 0) begin
				s <= 0; v <= 0; next_state <= 0;
			end else begin
				s <= 1; v <= 0; next_state <= 0;
			end
		end
		6: begin
			if (x == 0) begin
				s <= 1; v <= 0; next_state <= 0;
			end else begin
				s <= 0; v <= 1; next_state <= 0;
			end
		end
		default: begin
			if (x == 0) begin
				s <= 1; v <= 0; next_state <= 1;
			end else begin
				s <= 0; v <= 0; next_state <= 2;
			end
		end
		endcase
	end

endmodule
