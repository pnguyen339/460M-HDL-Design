module Screen_Driver(pixel_clk, R, G, B, hsync, vsync, X, Y, orientation);
input pixel_clk;
// X,Y is the current coordinates of the snake head
input [9:0] X, Y;
input [1:0] orientation;
output [3:0] R, G, B;
output hsync, vsync;

reg hsync, vsync;
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
       
    // output R, G, B or 0, 0, 0
    if(visible) begin
        
        // right
        if(orientation == 0) begin
            // only draw snake when within the 40, 10 of X,Y
            // X,Y is bottom right corner
            if((hcount > (X - 40)) && (hcount <= X) && (vcount > (Y - 10)) && (vcount <= Y)) begin
                R <= 0;
                G <= 0;
                B <= 15;
            end
            else begin
                R <= 15;
                G <= 15;
                B <= 15;
            end
        end
        // left
        else if(orientation == 1) begin
            
            // X,Y is bottom left corner
            if((hcount < (X + 40)) && (hcount >= X) && (vcount > (Y - 10)) && (vcount <= Y)) begin
                R <= 0;
                G <= 0;
                B <= 15;
            end
            else begin
                R <= 15;
                G <= 15;
                B <= 15;
            end
        end
        // up
        else if(orientation == 2) begin
            
            // X,Y is top left corner
            if((hcount < (X + 10)) && (hcount >= X) && (vcount < (Y + 40)) && (vcount >= Y)) begin
              R <= 0;
              G <= 0;
              B <= 15;
            end
            else begin
              R <= 15;
              G <= 15;
              B <= 15;
            end
        end
        // down
        else begin
            
            // X,Y is bottom left corner
            if((hcount < (X + 10)) && (hcount >= X) && (vcount > (Y - 40)) && (vcount <= Y)) begin
              R <= 0;
              G <= 0;
              B <= 15;
            end
            else begin
              R <= 15;
              G <= 15;
              B <= 15;
            end
        end
    end
    else begin
        R <= 0;
        G <= 0;
        B <= 0;
    end
    
    // increment hcount and vcount
    hcount = hcount + 1;
    hcount = hcount % 800;
    
    if(hcount == 0) begin
        vcount = vcount + 1;
        vcount = vcount % 525; 
    end
    
    // generate hsync signal
    if(hcount > 658 && hcount < 755) begin
        hsync <= 0;
    end
    else begin
        hsync <= 1;
    end
    
    // geneate vsync signal
    if(vcount > 492 && vcount < 494) begin
        vsync <= 0;
    end
    else begin
        vsync <= 1;
    end
end

// generate visible signal
assign visible = (hcount < 640 && vcount < 480) ? 1 : 0;

endmodule
