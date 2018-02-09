module Sub4 (S, Co, A, B, Ci); 
    output [3:0] S;   
output Co;   
input [3:0] A, B; 
    input Ci; 
    wire [3:1] C; // C is an internal signal 
    // instantiate four copies of the FullAdder 
    FullSubtractor a1(A[0], B[0], Ci, C[1], S[0]); 
    FullSubtractor a2(A[1], B[1], C[1], C[2], S[1]); 
    FullSubtractor a3(A[2], B[2], C[2], C[3], S[2]); 
    FullSubtractor a4(A[3], B[3], C[3], Co, S[3]); 
endmodule 