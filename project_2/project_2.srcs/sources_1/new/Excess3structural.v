module not1(a, x);
	input a;
	output wire x;

	reg tab [0:1];

	assign x = tab[a];

	initial begin
		tab[0] = 1;
		tab[1] = 0;
	end
endmodule

module and2(a, b, x);
	input a;
	input b;
	output wire x;

	reg tab [0:1] [0:1];

	assign x = tab[a][b];

	initial begin
		tab[0][0] = 0;
		tab[0][1] = 0;
		tab[1][0] = 0;
		tab[1][1] = 1;
	end
endmodule

module and3(a, b, c, x);
	input a;
	input b;
	input c;
	output wire x;

	reg tab [0:1] [0:1] [0:1];

	assign x = tab[a][b][c];

	initial begin
		tab[0][0][0] = 0;
		tab[0][0][1] = 0;
		tab[0][1][0] = 0;
		tab[0][1][1] = 0;
		tab[1][0][0] = 0;
		tab[1][0][1] = 0;
		tab[1][1][0] = 0;
		tab[1][1][1] = 1;
	end
endmodule

module or2(a, b, x);
	input a;
	input b;
	output wire x;

	reg tab [0:1] [0:1];

	assign x = tab[a][b];

	initial begin
		tab[0][0] = 0;
		tab[0][1] = 1;
		tab[1][0] = 1;
		tab[1][1] = 1;
	end
endmodule

module or3(a, b, c, x);
	input a;
	input b;
	input c;
	output wire x;

	reg tab [0:1] [0:1] [0:1];

	assign x = tab[a][b][c];

	initial begin
		tab[0][0][0] = 0;
		tab[0][0][1] = 1;
		tab[0][1][0] = 1;
		tab[0][1][1] = 1;
		tab[1][0][0] = 1;
		tab[1][0][1] = 1;
		tab[1][1][0] = 1;
		tab[1][1][1] = 1;
	end
endmodule

module or4(a, b, c, d, x);
	input a;
	input b;
	input c;
	input d;
	output wire x;

	wire aorb;
	wire cord;

	or2 or2_inst1 (a, b, aorb);
	or2 or2_inst2 (c, d, cord);
	or2 or2_inst3 (aorb, cord, x);
endmodule

module dflipflop(d, clk, q);
	input d;
	input clk;
	output reg q;

	always @ (negedge clk)
	begin
		if (d == 0 || d == 1)
			q <= d;
		else
			q <= 0;
	end
endmodule

module structural(x, clk, s, v);
	input x;
	input clk;
	output wire s;
	output wire v;

	wire [2:0] state;
	wire not_s2, not_s1, not_s0;

	wire not_x;

	wire a1, a2, a3, a_d;
	wire b1, b2, b3, b_d;
	wire c1, c2, c3, c_d;

	wire s1, s2, s3, s4;

	not1 not1_inst2 (state[2], not_s2);
	not1 not1_inst1 (state[1], not_s1);
	not1 not1_inst0 (state[0], not_s0);

	not1 not1_inst3 (x, not_x);

	and3 and3_inst1 (state[2], not_s1, state[0], a1);
	and3 and3_inst2 (not_s2, state[1], state[0], a2);
	and3 and3_inst3 (not_x, state[1], not_s0, a3);
	or3 or3_inst1 (a1, a2, a3, a_d);

	and3 and3_inst4 (not_x, not_s2, not_s1, b1);
	and3 and3_inst5 (x, not_s2, state[1], b2);
	and3 and3_inst6 (x, not_s2, state[0], b3);
	or3 or3_inst2 (b1, b2, b3, b_d);

	and2 and2_inst1 (x, not_s2, c1);
	and2 and2_inst2 (state[1], not_s0, c2);
	and3 and3_inst7 (not_s2, not_s1, state[0], c3);
	or3 or3_inst3 (c1, c2, c3, c_d);

	and3 and3_inst8 (not_x, not_s2, not_s0, s1);
	and3 and3_inst9 (x, not_s1, state[0], s2);
	and2 and2_inst3 (not_x, state[1], s3);
	and3 and3_inst10 (x, state[2], not_s0, s4);
	or4 or4_inst1 (s1, s2, s3, s4, s);

	and3 and3_inst11 (x, state[2], state[1], v);

	dflipflop d_inst1(a_d, clk, state[2]);
	dflipflop d_inst2(b_d, clk, state[1]);
	dflipflop d_inst3(c_d, clk, state[0]);
endmodule
