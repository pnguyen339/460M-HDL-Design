module TestBench;
wire [7:0] Grp1, Grp2, Grp3, Grp4, Grp5, Grp6;
wire [2:0] currentGrp;
reg clk, reset;
reg [11:0] weight;

// set up the clock
initial
begin
  clk = 1'b0;
  forever #1 clk = ~clk;
end

// declare arrays
reg [11:0] weight_array1[2:0];
reg [11:0] weight_array2[2:0];
reg [11:0] weight_array3[2:0];
reg [11:0] weight_array4[2:0];
reg [11:0] weight_array5[2:0];

reg reset_array1[2:0];
reg reset_array2[2:0];
reg reset_array3[2:0];
reg reset_array4[2:0];
reg reset_array5[2:0];

reg [2:0] count_array1[2:0];
reg [2:0] count_array2[2:0];
reg [2:0] count_array3[2:0];
reg [2:0] count_array4[2:0];
reg [2:0] count_array5[2:0];
reg [2:0] count_array6[2:0];

// set up array values
initial
begin
  weight_array1[0] <= 12'b000000010000;
  weight_array1[1] <= 12'b001011101110;
  weight_array1[2] <= 12'b000011111011;

  weight_array2[0] <= 12'b000111110101;
  weight_array2[1] <= 12'b001011101111;
  weight_array2[2] <= 12'b000110010000;

  weight_array3[0] <= 12'b001001011000;
  weight_array3[1] <= 12'b010111011100;
  weight_array3[2] <= 12'b011010100100;

  weight_array4[0] <= 12'b011001000000;
  weight_array4[1] <= 12'b010111011101;
  weight_array4[2] <= 12'b011111010001;

  weight_array5[0] <= 12'b011111010101;
  weight_array5[1] <= 12'b010111100010;
  weight_array5[2] <= 12'b011111010010;

  reset_array1[0] <= 0;
  reset_array1[1] <= 0;
  reset_array1[2] <= 0;

  reset_array2[0] <= 0;
  reset_array2[1] <= 0;
  reset_array2[2] <= 0;

  reset_array3[0] <= 0;
  reset_array3[1] <= 0;
  reset_array3[2] <= 0;

  reset_array3[0] <= 0;
  reset_array3[1] <= 0;
  reset_array3[2] <= 0;

  reset_array4[0] <= 0;
  reset_array4[1] <= 0;
  reset_array4[2] <= 0;

  reset_array5[0] <= 0;
  reset_array5[1] <= 0;
  reset_array5[2] <= 0;
  
  count_array1[0] <= 1;
  count_array1[1] <= 0;
  count_array1[2] <= 0;

  count_array2[0] <= 0;
  count_array2[1] <= 0;
  count_array2[2] <= 2; 

  count_array3[0] <= 2;
  count_array3[1] <= 1;
  count_array3[2] <= 0; 

  count_array4[0] <= 0;
  count_array4[1] <= 2;
  count_array4[2] <= 0; 

  count_array5[0] <= 1;
  count_array5[1] <= 2;
  count_array5[2] <= 1; 

  count_array6[0] <= 1;
  count_array6[1] <= 0;
  count_array6[2] <= 2;  
end

integer i;

always
begin
  i = 0;
  for(i = 0; i < 3; i = i+1) begin
    $display(i);
    weight <= 0;
    #50;
    // feed in the weights and reset values
    weight <= weight_array1[i];
    reset <= reset_array1[i];
    #20;
    weight <= 0;
    #20;

    weight <= weight_array2[i];
    reset <= reset_array2[i];
    #20;
    weight <= 0;
    #20;

    weight <= weight_array3[i];
    reset <= reset_array3[i];
    #20;
    weight <= 0;
    #20;

    weight <= weight_array4[i];
    reset <= reset_array4[i];
    #20;
    weight <= 0;
    #20;

    weight <= weight_array5[i];
    reset <= reset_array5[i];
    #20;
    weight <= 0;
    #20;

    // check if the output is correct
    if(Grp1 == count_array1[i] && Grp2 == count_array2[i] && Grp3 == count_array3[i] && Grp4 == count_array4[i] && Grp5 == count_array5[i] && Grp6 == count_array6[i]) begin
      $display("Correct!");
    end
    else begin
      $write("Error: ");
      $display("Wrong Answer");
    end
    reset <= 1;
    $display("Test Finished");
  end
end

Sorter sort1(clk, weight, reset, Grp1, Grp2, Grp3, Grp4, Grp5, Grp6, currentGrp);
endmodule

