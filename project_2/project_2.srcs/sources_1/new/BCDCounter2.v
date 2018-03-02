module BCDCounter2(clr,clk,enable,load,up,d1,q1,d2,q2,co);
    
    input enable, load, up, clr, clk;
    input wire [3:0] d1,d2;
    output co;    
    output reg [3:0] q1,q2;
    wire co1, co2;
    
    wire enable_second;
    
    assign enable_second = enable & (load | co1);
    
    BCDCounter1 first(clr,clk,enable,load,up,d1,q1,co1);
    BCDCounter1 second(clr,clk,enable_second,load,up,d1,q1,co2);
    
    assign co = (~up & co2) | (up & co1);
    
endmodule
