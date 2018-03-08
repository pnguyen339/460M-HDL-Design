module ParkingMeter(Bup, Bdown, Bleft, Bright, clk, count, sw0, sw1);

input Bup, Bdown, Bleft, Bright, clk, sw0, sw1;
output [13:0] count;

reg [13:0] count;
reg flag, ld_flag;
integer clk_count;
reg [13:0] additional_count;

initial begin
    count <= 0;
    additional_count <= 0;
    clk_count <= 0;
    ld_flag <= 0;
    flag <= 0;
end

// always block to control count value
always @(posedge clk) begin
    // add 50, up to 9999
    if(Bup == 1) begin 
        flag <= 1; // data ready for count
        if(count + 6'b110010 < 14'b10011100010000) begin 
            additional_count <= additional_count + 6'b110010; 
        end
        else begin 
            additional_count <= 14'b10011100001111 - count - 1; 
        end
    end
    // add 150
    else if(Bleft == 1) begin
        flag <= 1;
	    if(count + 8'b10010110 < 14'b10011100010000) begin 
	        additional_count <= additional_count + 8'b10010110; 
	    end
        else begin 
            additional_count <= 14'b10011100001111 - count - 1; 
        end
    end
    // add 200
    else if(Bright == 1) begin
	    flag <= 1;
	    if(count + 8'b11001000 < 14'b10011100010000) begin 
	        additional_count <= additional_count + 8'b11001000; 
	    end
	    else begin 
	        additional_count <= 14'b10011100001111 - count - 1; 
	    end
    end
    // add 500
    else if(Bdown == 1) begin
        flag <= 1;
        if(additional_count + 9'b111110100 < 14'b10011100010000) begin 
            additional_count <= additional_count + 9'b111110100; 
        end
	    else begin 
	        additional_count <= 14'b10011100001111 - count - 1; 
	    end
    end
    else begin
        ld_flag <= 0;
        additional_count <= 0;
    end
    
    if(flag == 1 && ld_flag == 0) begin
        ld_flag = 1;
        flag <= 0;
        if(count + additional_count < 14'b10011100010000) begin
            count <= count + additional_count;
        end
        else begin
            count <= 14'b10011100001111;
        end
    end
    //else begin
       // flag <= 0;
       // ld_flag <= 0;
       // count <= count + 0;
    //end
    // decrement, but not below 0
    
    clk_count <= clk_count + 1;
    if(clk_count == 100000000) begin
        clk_count <= 0;
        if(count == 0) begin
            count <= 0;
        end
        else begin
            count <= count - 1;
        end
    end
    
    // Switches to reset value
    if(sw0 == 1) begin
        count = 10;
    end
    else if(sw1 == 1) begin
        count = 205;
    end
    //else begin
      //  count <= count + 0;
    //end
    
end
endmodule


module FlashingLight(count, clock2hz, clock1hz, led);
 input wire [13:0] count;
 input wire clock2hz, clock1hz;
 output wire led;
 reg light;
 always @(count) begin
    if(count == 0)
        light <= clock2hz;
    else if(count > 200)
        light <= 1;
    else if(count <= 200)
        light <= clock1hz;
    else
        light <= clock2hz;
 end
 
 assign led = light;
endmodule

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
            default: fourth <= ~7'b0000000;
        endcase  
            
    end
    
    
endmodule


