
module VGA(clk, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync, SW);
input clk;
input [7:0] SW;
output Hsync, Vsync;
output [3:0] vgaRed, vgaGreen, vgaBlue;

wire slow_clk;

clockDivider_25MHz clockDiv(clk, slow_clk);

Screen_Driver driver(slow_clk, SW, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync);

endmodule


module clockDivider_25MHz(clk100Mhz, slowClk1);
  input clk100Mhz; //fast clock
  output reg slowClk1; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk1 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 2) begin
      counter <= 1;
      slowClk1 <= ~slowClk1;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule