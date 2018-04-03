
module Snake(SW, clk, Hsync, Vsync, vgaRed, vgaGreen, vgaBlue);
input [6:0] SW;
input clk;

output Hsync, Vsync;
output [3:0] vgaRed, vgaGreen, vgaBlue;

wire slow_clk;
wire clk_50hz;
reg [1:0] orientation; // keeps track of the snake direction
reg [9:0] X, Y;
reg pause, freeze;

clockDivider_25MHz clockDiv(clk, slow_clk);
clockDivider_50Hz clockDiv1(clk, clk_50hz);

Screen_Driver driver(slow_clk, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync, X, Y, orientation);

// snake starts going right at X = 40 Y = 240
initial begin
    orientation <= 0;
    X <= 40;
    Y <= 240;
    pause <= 0;
    freeze <= 0;
end

/* change the snake orientation, change XY coordinate, pause/unpause the game
always @(SW) begin
  if(SW[4] == 1) begin
    pause <= 1;
  end
  else if(SW[5] == 1 && freeze == 0) begin
    pause <= 0;
  end
  if(pause == 0) begin
    if(SW[0] == 1) begin
        if(orientation == 2) begin
            X <= X + 39;
            Y <= Y + 9;
        end
        if(orientation == 3) begin
            X <= X + 39;
        end
        orientation <= 0;
    end
    else if(SW[1] == 1) begin
        if(orientation == 2) begin
            X <= X - 30;
            Y <= Y + 9;
        end
        if(orientation == 3) begin
            X <= X - 30;
        end
        orientation <= 1;
    end
    else if(SW[2] == 1) begin
        if(orientation == 0) begin
            X <= X - 9;
            Y <= Y - 39;
        end
        if(orientation == 1) begin
            Y <= Y - 39;
        end
        orientation <= 2;
    end
    else if(SW[3] == 1) begin
        if(orientation == 0) begin
            X <= X - 9;
            Y <= Y + 30;
        end
        if(orientation == 1) begin
            Y <= Y + 30;
        end
        orientation <= 3;
    end
  end
end
*/

// make an always block that updates XY based on orientation
always @(posedge clk_50hz) begin
  
  //change the snake orientation, change XY coordinate, pause/unpause the game
  if(SW[6] == 1) begin
    pause <= 1; // change to black out screen
  end
  if(SW[4] == 1) begin
    pause <= 1;
  end
  else if(SW[5] == 1 && freeze == 0) begin
    pause <= 0;
  end
  
  if(pause == 0 || freeze == 0) begin   
    
    if(SW[0] == 1) begin
      if(orientation == 2) begin
        X <= X + 39;
        Y <= Y + 9;
      end
      if(orientation == 3) begin
        X <= X + 39;
      end
      orientation <= 0;
    end
    else if(SW[1] == 1) begin
      if(orientation == 2) begin
        X <= X - 30;
        Y <= Y + 9;
      end
      if(orientation == 3) begin
        X <= X - 30;
      end
      orientation <= 1;
    end
    else if(SW[2] == 1) begin
      if(orientation == 0) begin
        X <= X - 9;
        Y <= Y - 39;
      end
      if(orientation == 1) begin
        Y <= Y - 39;
      end
      orientation <= 2;
    end
    else if(SW[3] == 1) begin
      if(orientation == 0) begin
        X <= X - 9;
        Y <= Y + 30;
      end
      if(orientation == 1) begin
        Y <= Y + 30;
      end
      orientation <= 3;
    end  
   
    // right
    if(orientation == 0) begin
        X <= X + 1;
    end
    // left
    else if(orientation == 1) begin
        X <= X - 1;
    end
    // up
    else if(orientation == 2) begin
        Y <= Y - 1;
    end
    // down
    else begin
        Y <= Y + 1;
    end
  end
end

// freeze the game if out of bounds
always @(X, Y) begin
    if(X >= 640 || Y >= 480) begin
        freeze <= 1;
    end
    else begin
        freeze <= 0;
    end
end

endmodule


module clockDivider_25MHz(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 2) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module clockDivider_50Hz(clk100Mhz, slowClk1);
  input clk100Mhz; //fast clock
  output reg slowClk1; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk1 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 1000000) begin
      counter <= 1;
      slowClk1 <= ~slowClk1;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule