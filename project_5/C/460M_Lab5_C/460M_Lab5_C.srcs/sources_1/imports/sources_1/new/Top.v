
`define break_check keypress[8:1]
`define break_code keypress[19:12]

module Top(PS2Clk, PS2Data,clk, Hsync, Vsync, vgaRed, vgaGreen, vgaBlue);
    input wire PS2Clk;
    input wire PS2Data;
    output Hsync, Vsync;
    output [3:0] vgaRed, vgaGreen, vgaBlue;
    input  wire clk;
    wire clock2Hz;
    wire [21:0] keypress;
    reg [7:0] key;
    reg [7:0] SW;
    
    
    always @(posedge PS2Clk)
      begin
        //LED0 <= 0;
        if (`break_check == 8'hF0) begin
            key <= `break_code; end
      end
    kb_scan k(PS2Clk, PS2Data, keypress);
    clockDivider_2ms c(clk, clock2Hz);
    
    Snake snake(SW, clk, Hsync, Vsync, vgaRed, vgaGreen, vgaBlue);
    
    // convert the hex character into a switch code for the snake module
    always @(key) begin
        
      if(key == 8'b01110100) begin // 0x74 Right
          SW <= 1;
      end
      else if(key == 8'b01101011) begin // 0x6B Left
          SW <= 2; 
      end
      else if(key == 8'b01110101) begin // 0x75 Up
          SW <= 4;
      end
      else if(key == 8'b01110010) begin // 0x72 Down
          SW <= 8;
      end
      else if(key == 8'b01001101) begin //P 0x4D Pause
          SW <= 16;
      end
      else if(key == 8'b00101101) begin //R 0x2D Resume
          SW <= 32;
      end
      else if(key == 8'b01110110) begin //Esc 0x76 Exit
          SW <= 64;
      end
      else if(key == 8'b00011011) begin //S 0x1B Start
          SW <= 128;
      end
      else begin
          SW <= 0;
      end
    end     
endmodule
