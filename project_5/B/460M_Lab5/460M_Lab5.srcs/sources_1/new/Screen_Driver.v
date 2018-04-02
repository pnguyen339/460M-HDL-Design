module Screen_Driver(pixel_clk, pixel_color, R, G, B, hsync, vsync);
input pixel_clk;
input [7:0] pixel_color;
output [3:0] R, G, B;
output hsync, vsync;

wire hsync, vsync;
reg [9:0] hcount, vcount;
reg [3:0] R, G, B;
wire visible;

initial begin
    hcount <= 0;
    vcount <= 0;
    R <= 0;
    G <= 0;
    B <= 0;
end

always @(posedge pixel_clk) begin
    
    // increment hcount and vcount
    hcount = hcount + 1;
    hcount = hcount % 800;
    
    if(hcount == 0) begin
        vcount = vcount + 1;
        vcount = vcount % 525; 
    end
        // output R, G, B or 0, 0, 0
    if(visible) begin
        if(pixel_color == 1) begin
            R <= 0;
            G <= 0;
            B <= 0;
        end
        else if(pixel_color == 2) begin
            R <= 0;
            G <= 0;
            B <= 15;
        end
        else if(pixel_color == 4) begin
            R <= 10;
            G <= 2;
            B <= 2;
        end
        else if(pixel_color == 8) begin
            R <= 0;
            G <= 15;
            B <= 15;
        end
        else if(pixel_color == 16) begin
            R <= 15;
            G <= 0;
            B <= 0;
        end
        else if(pixel_color == 32) begin
            R <= 15;
            G <= 0;
            B <= 15;
        end
        else if(pixel_color == 64) begin
            R <= 15;
            G <= 15;
            B <= 0;
        end
        else if(pixel_color == 128)begin
            R <= 15;
            G <= 15;
            B <= 15;
        end
        else begin
            R <= 0;
            G <= 0;
            B <= 0;
        end
    end
    else begin
        R <= 0;
        G <= 0;
        B <= 0;
    end
    
end

// generate visible signal
assign visible = (hcount < 640 && vcount < 480) ? 1 : 0;
assign hsync = (hcount > 658 && hcount < 756) ? 0 : 1; // low on 659 high on 756
assign vsync = (vcount > 492 && vcount < 495) ? 0 : 1; // low on 493 high on 495

endmodule
