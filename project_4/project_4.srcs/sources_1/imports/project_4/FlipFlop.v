module DFF_S(D, CLK, Q, QN);
input D, CLK;
output Q, QN;

reg Q;
reg QN;

initial
begin
  Q = 1'b0;
  QN = 1'b1;
end

always @(posedge CLK)
begin
  Q <= D;
  QN <= (~D);
end
endmodule
