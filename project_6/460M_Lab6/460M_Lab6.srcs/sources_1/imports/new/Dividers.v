
module clockDivider_32(clk100Mhz, slowClk1, start);
  input clk100Mhz, start; //fast clock
  output reg slowClk1; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk1 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 1562500) begin
      counter <= 1;
      slowClk1 <= ~slowClk1;
    end
    else begin
      if(start == 1) begin
        counter <= counter + 1;
      end
      else counter <= 0;
    end
  end
endmodule

module clockDivider_64(clk100Mhz, slowClk1, start);
  input clk100Mhz, start; //fast clock
  output reg slowClk1; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk1 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 781250) begin
      counter <= 1;
      slowClk1 <= ~slowClk1;
    end
    else begin
      if(start == 1) begin
        counter <= counter + 1;    
      end
      else counter <= 0;
    end
  end
endmodule

module clockDivider_128(clk100Mhz, slowClk1, start);
  input clk100Mhz, start; //fast clock
  output reg slowClk1; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk1 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 390625) begin
      counter <= 1;
      slowClk1 <= ~slowClk1;
    end
    else begin
      if(start == 1) begin
        counter <= counter + 1;    
      end
      else counter <= 0;
    end
  end
endmodule

module clockDivider_16ms(clk100Mhz, slowClk3);
  input clk100Mhz; //fast clock
  output reg slowClk3; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk3 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 200000) begin
      counter <= 1;
      slowClk3 <= ~slowClk3;
    end
    else begin
      counter <= counter + 1;
    end
  end

endmodule