module SinglePulse(press, clk, SP);
input press, clk;
output SP;

reg QA, QnA, QB, QnB, QC, QnC;

FlipFlop A(press, clk, QA, QnA);
FlipFlop B(QA, clk, QB, QnB);
FlipFlop C(QB, clk, QC, QnC);

assign SP = QB && QnC;

endmodule

