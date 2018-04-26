module Complete_MIPS(CLK, SW, seg, an, btnL, btnR);
  // Will need to be modified to add functionality
  //output A_Out, D_Out;
  
  input CLK;
  input btnL, btnR;
  input [2:0] SW;
  output [6:0] seg;
  output [3:0] an;

  wire CS, WE, slow_clk;
  wire [6:0] ADDR;
  wire [31:0] Mem_Bus;
  wire [31:0] S2, S3;
  reg RST;
  reg [3:0] d1, d2, d3, d4;
  
  clockDivider_20ms div1(CLK, slow_clk);
  clockDivider_16ms div2(CLK, clk_16ms);
  
  MIPS CPU(CLK, RST, CS, WE, ADDR, Mem_Bus, S2, S3, SW);
  Memory MEM(CS, WE, CLK, ADDR, Mem_Bus);
 
  NumberDisplay display({d4,d3,d2,d1}, seg, an, clk_16ms);
 
 initial begin
   RST = 1'b1; // reset the cpu initially
   d4 <= 0;
   d3 <= 0;
   d2 <= 0;
   d1 <= 0;
 end

 // decide what to show on the seven segment
 always @(posedge CLK) begin
   
   RST = 1'b0; // keep RST low
   
   if(SW == 0) begin
     if(btnL == 0 && btnR == 0) begin
       d4 <= S2[15:12];
       d3 <= S2[11:8];
       d2 <= S2[7:4];
       d1 <= S2[3:0];
     end
     else if(btnL == 0 && btnR == 1) begin
       d4 <= S2[31:28];
       d3 <= S2[27:24];
       d2 <= S2[23:20];
       d1 <= S2[19:16];     
     end  
     else if(btnL == 1 && btnR == 0) begin
       d4 <= S3[15:12];
       d3 <= S3[11:8];
       d2 <= S3[7:4];
       d1 <= S3[3:0];   
     end  
     else begin
       d4 <= S3[31:28];
       d3 <= S3[27:24];
       d2 <= S3[23:20];
       d1 <= S3[19:16];       
     end     
   end
   else begin
     if(btnL == 0 && btnR == 0) begin
       d4 <= S2[15:12];
       d3 <= S2[11:8];
       d2 <= S2[7:4];
       d1 <= S2[3:0];
     end
     else begin
       d4 <= S2[31:28];
       d3 <= S2[27:24];
       d2 <= S2[23:20];
       d1 <= S2[19:16];     
     end    
   end
 end
 
endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module Memory(CS, WE, CLK, ADDR, Mem_Bus);
  input CS;
  input WE;
  input CLK;
  input [6:0] ADDR;
  inout [31:0] Mem_Bus;
  
  integer file, r;
  reg [31:0] data_out;
  reg [31:0] RAM [0:127];


  initial
  begin
    /* Write your Verilog-Text IO code here */
    $readmemb("program.txt", RAM);
  end

  assign Mem_Bus = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bZ : data_out;

  always @(negedge CLK)
  begin

    if((CS == 1'b1) && (WE == 1'b1))
      RAM[ADDR] <= Mem_Bus[31:0];

    data_out <= RAM[ADDR];
  end
endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module REG(CLK, RegW, DR, SR1, SR2, Reg_In, ReadReg1, ReadReg2, S2, S3, SW);
  input CLK;
  input RegW;
  input [4:0] DR;
  input [4:0] SR1;
  input [4:0] SR2;
  input [31:0] Reg_In;
  input [2:0] SW;
  output reg [31:0] ReadReg1;
  output reg [31:0] ReadReg2;
  output [31:0] S2, S3;

  reg [31:0] REG [0:31];
  assign S2 = REG[2];
  assign S3 = REG[3];
  integer i;

  initial begin
    ReadReg1 = 0;
    ReadReg2 = 0;
  end

  always @(posedge CLK)
  begin
    
    // set $1 to be input SW
    REG[1][2:0] <= SW;
    REG[1][31:3] <= 0;
    
    if(RegW == 1'b1)
      REG[DR] <= Reg_In[31:0];

    ReadReg1 <= REG[SR1];
    ReadReg2 <= REG[SR2];
  end
endmodule


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`define opcode instr[31:26]
`define sr1 instr[25:21]
`define sr2 instr[20:16]
`define f_code instr[5:0]
`define numshift instr[10:6]

module MIPS (CLK, RST, CS, WE, ADDR, Mem_Bus, S2, S3, SW);
  input CLK, RST;
  output reg CS, WE;
  output [6:0] ADDR;
  output [31:0] S2, S3;
  inout [31:0] Mem_Bus;
  input [2:0] SW;

  //special instructions (opcode == 000000), values of F code (bits 5-0):
  parameter add = 6'b100000;
  parameter sub = 6'b100010;
  parameter xor1 = 6'b100110;
  parameter and1 = 6'b100100;
  parameter or1 = 6'b100101;
  parameter slt = 6'b101010;
  parameter srl = 6'b000010;
  parameter sll = 6'b000000;
  parameter jr = 6'b001000;

  //non-special instructions, values of opcodes:
  parameter addi = 6'b001000;
  parameter andi = 6'b001100;
  parameter ori = 6'b001101;
  parameter lw = 6'b100011;
  parameter sw = 6'b101011;
  parameter beq = 6'b000100;
  parameter bne = 6'b000101;
  parameter j = 6'b000010;

  // new instruction opcodes
  parameter jal = 6'b000011;
  parameter lui = 6'b001111;
  parameter mult = 6'b011000;
  parameter mfhi = 6'b010000;
  parameter mflo = 6'b010010;
  parameter add8 = 6'b101101;
  parameter rbit = 6'b101111;
  parameter rev = 6'b110000;
  parameter sadd = 6'b110001;
  parameter ssub = 6'b110010;

  //instruction format
  parameter R = 2'd0;
  parameter I = 2'd1;
  parameter J = 2'd2;

  //internal signals
  reg [5:0] op, opsave;
  wire [1:0] format;
  reg [31:0] instr, alu_result;
  reg [6:0] pc, npc;
  wire [31:0] imm_ext, alu_in_A, alu_in_B, reg_in, readreg1, readreg2;
  reg [31:0] alu_result_save;
  reg alu_or_mem, alu_or_mem_save, regw, writing, reg_or_imm, reg_or_imm_save;
  reg fetchDorI;
  wire [4:0] dr;
  reg [2:0] state, nstate;
  reg [31:0] HI, LO;
  reg [63:0] mult_result, mult_result_save;
  reg [7:0] addb1, addb2, addb3, addb4;
  reg [7:0] i;
  reg [32:0] temp_add;

  //combinational
  assign imm_ext = (instr[15] == 1)? {16'hFFFF, instr[15:0]} : {16'h0000, instr[15:0]};//Sign extend immediate field
  assign dr = (format == J)? 6'd31 : ((`opcode == rbit || `opcode == rev)? instr[25:21] : ((format == R)? instr[15:11] : instr[20:16])); //Destination Register MUX (MUX1)
  assign alu_in_A = readreg1;
  assign alu_in_B = (reg_or_imm_save)? imm_ext : readreg2; //ALU MUX (MUX2)
  assign reg_in = (state == 1)? (pc) : ((alu_or_mem_save)? Mem_Bus : alu_result_save); //Data MUX
  assign format = (`opcode == 6'd0)? R : ((`opcode == 6'd2 || `opcode == 6'd3)? J : I);
  assign Mem_Bus = (writing)? readreg2 : 32'bZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ;

  //drive memory bus only during writes
  assign ADDR = (fetchDorI)? pc : alu_result_save[6:0]; //ADDR Mux
  REG Register(CLK, regw, dr, `sr1, `sr2, reg_in, readreg1, readreg2, S2, S3, SW);

  initial begin
    op = and1; opsave = and1;
    state = 3'b0; nstate = 3'b0;
    alu_or_mem = 0;
    regw = 0;
    fetchDorI = 0;
    writing = 0;
    reg_or_imm = 0; reg_or_imm_save = 0;
    alu_or_mem_save = 0;
    HI = 0;
    LO = 0;
  end

  always @(*)
  begin
    fetchDorI = 0; CS = 0; WE = 0; regw = 0; writing = 0; alu_result = 32'd0;
    npc = pc; op = jr; reg_or_imm = 0; alu_or_mem = 0; nstate = 3'd0;
    case (state)
      0: begin //fetch
        npc = pc + 7'd1; CS = 1; nstate = 3'd1;
        fetchDorI = 1;
      end
      1: begin //decode
        nstate = 3'd2; reg_or_imm = 0; alu_or_mem = 0;
        if (format == J) begin //jump, and finish
          npc = instr[6:0];
          if(`opcode == jal) 
            regw = 1; // write pc to $31
          nstate = 3'd0;
        end
        else if (format == R) //register instructions
          op = `f_code;
        else if (format == I) begin //immediate instructions
          reg_or_imm = 1;
          if(`opcode == lw) begin
            op = add;
            alu_or_mem = 1;
          end
          else if ((`opcode == lw)||(`opcode == sw)||(`opcode == addi)) op = add;
          else if ((`opcode == beq)||(`opcode == bne)) begin
            op = sub;
            reg_or_imm = 0;
          end
          else if (`opcode == andi) op = and1;
          else if (`opcode == ori) op = or1;
          else op = `opcode; // added
        end
      end
      2: begin //execute
        nstate = 3'd3;
        if (opsave == and1) alu_result = alu_in_A & alu_in_B;
        else if (opsave == or1) alu_result = alu_in_A | alu_in_B;
        else if (opsave == add) alu_result = alu_in_A + alu_in_B;
        else if (opsave == sub) alu_result = alu_in_A - alu_in_B;
        else if (opsave == srl) alu_result = alu_in_B >> `numshift;
        else if (opsave == sll) alu_result = alu_in_B << `numshift;
        else if (opsave == slt) alu_result = (alu_in_A < alu_in_B)? 32'd1 : 32'd0;
        else if (opsave == xor1) alu_result = alu_in_A ^ alu_in_B;
        else if (opsave == lui) alu_result = alu_in_B << 16;
        else if (opsave == mult) begin
          mult_result_save = alu_in_A * alu_in_B;
          HI = mult_result_save[63:32];
          LO = mult_result_save[31:0];
        end
        else if (opsave == mfhi) alu_result = HI;
        else if (opsave == mflo) alu_result = LO;
        else if (opsave == add8) begin
          addb1 = alu_in_A[7:0] + alu_in_B[7:0];
          addb2 = alu_in_A[15:8] + alu_in_B[15:8];
          addb3 = alu_in_A[23:16] + alu_in_B[23:16];
          addb4 = alu_in_A[31:24] + alu_in_B[31:24];
          alu_result = {addb4, addb3, addb2, addb1};
        
        end
        else if (opsave == rbit) begin
          for(i = 0; i < 32 ; i = i + 1)
            alu_result[i] = alu_in_B[31 - i];
        end
        else if (opsave == rev) begin
          alu_result[31:24] = alu_in_B[7:0];
          alu_result[23:16] = alu_in_B[15:8];
          alu_result[15:8] = alu_in_B[23:16];
          alu_result[7:0] = alu_in_B[31:24];
        end
        else if (opsave == sadd) begin
          temp_add = alu_in_A + alu_in_B;
          if (temp_add > 2^32-1) begin
            alu_result = 2^32-1;
          end
          else alu_result = alu_in_A + alu_in_B;
         end
         else if (opsave == ssub) begin
           if (alu_in_A < alu_in_B) begin
             alu_result = 0;
           end
           else alu_result = alu_in_A - alu_in_B;
          end
        // branch
        if (((alu_in_A == alu_in_B)&&(`opcode == beq)) || ((alu_in_A != alu_in_B)&&(`opcode == bne))) begin
          npc = pc + imm_ext[6:0];
          nstate = 3'd0;
        end
        else if ((`opcode == bne)||(`opcode == beq)) nstate = 3'd0;
        
        // jr
        else if (opsave == jr) begin
          npc = alu_in_A[6:0];
          nstate = 3'd0;
        end
      end
      3: begin //prepare to write to mem
        nstate = 3'd0;
        if ((format == R)||(`opcode == addi)||(`opcode == andi)||(`opcode == ori) ||(`opcode == lui)) 
          regw = 1;
        else if (`opcode == sw) begin
          CS = 1;
          WE = 1;
          writing = 1;
        end
        else if (`opcode == lw) begin
          CS = 1;
          nstate = 3'd4;
        end
      end
      4: begin
        nstate = 3'd0;
        CS = 1;
        if (`opcode == lw) regw = 1;
      end
    endcase
  end //always

  always @(posedge CLK) begin
      if (RST) begin
        state <= 3'd0;
        pc <= 7'd0;
      end
      else begin
        state <= nstate;
        pc <= npc;
      end

      if (state == 3'd0) instr <= Mem_Bus;
      else if (state == 3'd1) begin
        opsave <= op;
        reg_or_imm_save <= reg_or_imm;
        alu_or_mem_save <= alu_or_mem;
      end
      else if (state == 3'd2) begin
        alu_result_save <= alu_result;
      end
  end //always

endmodule
