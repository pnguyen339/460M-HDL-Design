module SinglePulse(press, clk, SP);
input press, clk;
output SP;

wire QA, QnA, QB, QnB, QC, QnC;

DFF_S A(press, clk, QA, QnA);
DFF_S B(QA, clk, QB, QnB);
DFF_S C(QB, clk, QC, QnC);

assign SP = QB && QnC;

endmodule

