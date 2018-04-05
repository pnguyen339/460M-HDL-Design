module NumberDisplay(count,segment_dis, an, clk, clock1hz, clock_half, sw0, sw1);
    input wire [13:0] count;
    input clk, clock1hz, clock_half, sw0, sw1;
    output reg [6:0] segment_dis;
    output reg [3:0] an;
    
    wire clock1hz_n, clock_half_n;
    assign clock1hz_n = ~clock1hz;
    assign clock_half_n = ~clock_half;
     
    reg light;
    reg [3:0] ans, state;
    reg [6:0] first,second,third, fourth;
    reg [3:0] st,nd,rd,th;

    
    initial begin
        first <= 0;
        second <= 0;
        third <= 0;
        fourth <= 0;
        st <= 0;
        nd <= 0;
        rd <= 0;
        th <= 0;
        ans <= 4'b0000;
    end
    
    always @(count) begin
        if(count == 0)
            light <= clock1hz_n;
        else if(sw0 == 1 || sw1 == 1)
            light <= clk;
        else if(count > 200)
            light <= clk;
        else if(count <= 200)
            light <= clock_half_n;
        else
            light <= clock1hz_n;
    end
    
    always @(posedge clk) begin
        ans = ans<<1;
            
        if(ans == 4'b0000) begin
            ans = 4'b0001;
        end
        
        case(ans)
            4'b0001: segment_dis <= first;
            4'b0010: segment_dis <= second;
            4'b0100: segment_dis <= third;
            4'b1000: segment_dis <= fourth;
        endcase;                 
    end
    
    always@(posedge light, posedge clk) begin
        if(light == 1)
            an = ~ans; 
        else
            an = 4'b1111;
    end
     
    always @(count) begin
        st <= count%10;
        nd <= (count/10)%10;
        rd <= (count/100)%10;
        th <= (count/1000)%10;
        
        case(st)
            4'b0000: first <= ~7'b0111111;
            4'b0001: first <= ~7'b0000110;
            4'b0010: first <= ~7'b1011011;
            4'b0011: first <= ~7'b1001111;
            4'b0100: first <= ~7'b1100110;
            4'b0101: first <= ~7'b1101101;
            4'b0110: first <= ~7'b1111101;
            4'b0111: first <= ~7'b0000111;
            4'b1000: first <= ~7'b1111111;
            4'b1001: first <= ~7'b1101111;
            4'b1010: first <= ~7'b1110111; // A
            4'b1011: first <= ~7'b1111100; // b
            4'b1100: first <= ~7'b0111001; // C
            4'b1101: first <= ~7'b1011110; // d
            4'b1110: first <= ~7'b1111001; // E
            4'b1111: first <= ~7'b1110001; // F
            default: first <= ~7'b0000000;
        endcase
        
        case(nd)
            4'b0000: second <= ~7'b0111111;
            4'b0001: second <= ~7'b0000110;
            4'b0010: second <= ~7'b1011011;
            4'b0011: second <= ~7'b1001111;
            4'b0100: second <= ~7'b1100110;
            4'b0101: second <= ~7'b1101101;
            4'b0110: second <= ~7'b1111101;
            4'b0111: second <= ~7'b0000111;
            4'b1000: second <= ~7'b1111111;
            4'b1001: second <= ~7'b1101111;
            4'b1010: second <= ~7'b1110111; // A
            4'b1011: second <= ~7'b1111100; // b
            4'b1100: second <= ~7'b0111001; // C
            4'b1101: second <= ~7'b1011110; // d
            4'b1110: second <= ~7'b1111001; // E
            4'b1111: second <= ~7'b1110001; // F            
            default: second <= ~7'b0000000;
        endcase
        
        case(rd)
            4'b0000: third <= ~7'b0111111;
            4'b0001: third <= ~7'b0000110;
            4'b0010: third <= ~7'b1011011;
            4'b0011: third <= ~7'b1001111;
            4'b0100: third <= ~7'b1100110;
            4'b0101: third <= ~7'b1101101;
            4'b0110: third <= ~7'b1111101;
            4'b0111: third <= ~7'b0000111;
            4'b1000: third <= ~7'b1111111;
            4'b1001: third <= ~7'b1101111;
            4'b1010: third <= ~7'b1110111; // A
            4'b1011: third <= ~7'b1111100; // b
            4'b1100: third <= ~7'b0111001; // C
            4'b1101: third <= ~7'b1011110; // d
            4'b1110: third <= ~7'b1111001; // E
            4'b1111: third <= ~7'b1110001; // F            
            default: third <= ~7'b0000000;
        endcase
        
        case(th)
            4'b0000: fourth <= ~7'b0111111;
            4'b0001: fourth <= ~7'b0000110;
            4'b0010: fourth <= ~7'b1011011;
            4'b0011: fourth <= ~7'b1001111;
            4'b0100: fourth <= ~7'b1100110;
            4'b0101: fourth <= ~7'b1101101;
            4'b0110: fourth <= ~7'b1111101;
            4'b0111: fourth <= ~7'b0000111;
            4'b1000: fourth <= ~7'b1111111;
            4'b1001: fourth <= ~7'b1101111;
            4'b1010: fourth <= ~7'b1110111; // A
            4'b1011: fourth <= ~7'b1111100; // b
            4'b1100: fourth <= ~7'b0111001; // C
            4'b1101: fourth <= ~7'b1011110; // d
            4'b1110: fourth <= ~7'b1111001; // E
            4'b1111: fourth <= ~7'b1110001; // F            
            default: fourth <= ~7'b0000000;
        endcase  
 
    end

endmodule

