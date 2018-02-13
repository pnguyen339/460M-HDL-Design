module  ALU(O, Co, A, B, Ci, Sel); 
output [3:0] O;   
output Co;
input [2:0] Sel;   
input [3:0] A, B; 
input Ci;

reg  [3:0] O;
always@(*)
begin 
    if(Sel == 3'b000)
       Adder4 (O,Co,A,B,Ci);
    else if(Sel == 3'b001) 
       Sub4 (O,Co,A,B,Ci);    
    else if(Sel == 3'b010)
       assign O = A^B; 
    else if(Sel == 3'b011)
        assign O = A&B;
    else if(Sel == 3'b100)
        assign O = A<<1;
    else if(Sel == 3'b101)
        assign O = A>>1;
    else if(Sel == 3'b110)
        assign O = ((A & 4'b1000)>>4) + (A<<1);
    else if(Sel == 3'b111)
        assign O = ((A & 4'b0001)<<4) + (A>>1);      
end    
endmodule 