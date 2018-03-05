module ParkingMeter(Bup, Bdown, Bleft, Bright, clk, fast_clk, count);

input Bup, Bdown, Bleft, Bright, clk;
output [13:0] count;

initial begin
    count <= 0;
end

// always block to control count value
always @(posedge clk, posedge Bup, posedge Bdown, posedge Bleft, posedge Bright) begin
    // add 50, up to 9999
    if(Bup == 1) begin 
        if(count + 6'b110010 < 14'b10011100010000) begin count <= count + 6'b110010; end
        else begin count <= 14'b10011100001111; end
    end
    // add 150
    else if(Bleft == 1) begin
	if(count + 8'b10010110 < 14'b10011100010000) begin count <= count + 8'b10010110; end
        else begin count <= 14'b10011100001111; end
    end
    // add 200
    else if(Bright == 1) begin
	if(count + 8'b11001000 < 14'b10011100010000) begin count <= count + 8'b11001000; end
	else begin count <= 14'b10011100001111; end
    end
    // add 500
    else if(Bdown == 1) begin
        if(count + 9'b111110100 < 14'b10011100010000) begin count <= count + 9'b111110100; end
	else begin count <= 14'b10011100001111; end
    end
    // decrement, but not below 0
    else if(clk == 1) begin
        if(count == 0) begin count <= 0; end
	else begin count <= count - 1; end
    end
    // for no latches
    else begin count <= 0; end
end
endmodule
