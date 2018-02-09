module FullSubtractor (A, B, Bin, Bout, Diff);   
output Bout, Diff; 
    input A, B, Bin; 
        assign #10 Diff = (~A && ~B && Bin) || (~A && B && ~Bin) || (A && B && Bin) || (A && ~B && ~Bin); 
        assign #10 Bout = (~A && B) || (~A && Bin) || (B && Bin); 
endmodule