/* Example 1 */
module simpleDivider(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output slowClk; //slow clock

  reg[27:0] counter;
  assign slowClk= counter[27];  //(2^27 / 100E6) = 1.34seconds

  initial begin
    counter = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
  end

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/* Example 2 */
module complexDivider(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 50000000) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end

endmodule


module clockDivider_1Hz(clk100Mhz, slowClk1);
  input clk100Mhz; //fast clock
  output reg slowClk1; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk1 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 50000000) begin
      counter <= 1;
      slowClk1 <= ~slowClk1;
    end
    else begin
      counter <= counter + 1;
    end
  end

endmodule

module clockDivider_2Hz(clk100Mhz, slowClk2);
  input clk100Mhz; //fast clock
  output reg slowClk2; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk2 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 100000000) begin
      counter <= 1;
      slowClk2 <= ~slowClk2;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module clockDivider_20ms(clk100Mhz, slowClk3);
  input clk100Mhz; //fast clock
  output reg slowClk3; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk3 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 1000000) begin
      counter <= 1;
      slowClk3 <= ~slowClk3;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module clockDivider_1s(clk100Mhz, slowClk3, reset, start);
  input clk100Mhz, start, reset; //fast clock
  output reg slowClk3; //slow clock

  reg[27:0] counter;

  initial begin
    counter <= 0;
    slowClk3 <= 1;
  end

  always @ (posedge clk100Mhz)
  begin
    if(reset == 1 || start == 0) begin
        counter <= 0;
    end
    else begin // start is 1
      if(counter == 50000000) begin
        counter <= 0;
        slowClk3 <= ~slowClk3;
      end
      else begin
        counter <= counter + 1;
      end
    end
  end
endmodule