/*
	File:		execute.v
	Authour(s):	Chris Thiele, Caleb Amlesom
	Student ID:	cwthiele, camlesom
	Date: 		June 30, 2015
*/
module execute (
  /* INPUTS */
  input wire clk,
  input wire [31:0] pc,
  input wire [31:0] insn,
  input wire [31:0] s1_val,
  input wire [31:0] s2_val,
  /* CONTROLS */
  input wire [13:0] controls,
  /* BRANCH */
  output reg branch_taken,
  output wire [31:0] pc_effective,
  /* OUTPUTS */
  output wire [31:0] pc_out,
  output wire [31:0] insn_out,
  output wire [13:0] controls_out,
  output wire [31:0] O_out,
  output wire [31:0] B_out,
  /* BYPASS */
  input wire MX_abypass,			// A
  input wire MX_bbypass,			// A
  input wire [31:0] MX_bypassval,	// A
  input wire WX_abypass,			// B
  input wire WX_bbypass,			// B
  input wire [31:0] WX_bypassval	// B
);
  /*CONTROL BITS*/
  wire rwe;
  wire aluinb;
  wire dmwe;
  wire rwd;
  wire jp;
  wire br;
  wire [5:0] aluop;

  wire [4:0] alusa;
  wire [31:0] aluinA;
  wire [31:0] aluinB;
  wire [31:0] aluresult;
  wire alubranch;
  
  /*JUMP OFFSETS*/
  wire [31:0] branch_adder;
  wire [31:0] j_jal_offset;
  wire j_special;
  wire [31:0] j_special_result;

  assign pc_out = pc;
  assign insn_out = insn;
  assign controls_out = controls;
  assign O_out = aluresult;
  assign B_out = s2_val;

  /*CONTROL BITS*/
  assign rdst = controls [13]; 
  assign dmenable = controls[12]; 
  assign rwe = controls[11];
  assign aluinb = controls[10];
  assign dmwe = controls[9];
  assign rwd = controls[8];
  assign jp = controls[7];
  assign br = controls[6];
  assign aluop = controls[5:0];

  assign alusa = insn[10:6]; 
  assign aluinA = (MX_abypass === 1)  ? MX_bypassval : ((WX_abypass === 1) ? WX_bypassval : s1_val ); //changed
  assign aluinB = aluinb ? {{16{insn[15]}}, insn[15:0]} : ((MX_bbypass === 1) ? MX_bypassval : ((WX_bbypass === 1) ? WX_bypassval : s2_val )); //changed
 
  /* ALU MODULE */
  alu alu_mod (
    .s1val(aluinA),
    .s2val(aluinB),
    .sa(alusa),
    .ALUop(aluop),
    .result(aluresult),
    .branch(alubranch),
	.insn(insn)
  );
    
  /*Jump/Branch Logic*/
  assign branch_adder = {{16{insn[15]}}, insn[15:0], 2'b00} + pc + 4;   // fucking adder to the first thing with the shift
  always @(br, alubranch, jp) begin
    branch_taken = (br & alubranch) | jp;
  end

  /*CALCULATE JUMP OFFSETS*/
  assign j_jal_offset = {pc[31:28],insn[25:0],2'b00};          // Imm26<<2 concatenated (pc)[31:28]
  assign j_special = ({insn[31:26],insn[5:0]} == 12'h8) | ({insn[31:26],insn[5:0]} == 12'h9); //control bit for j_special mux
  assign j_special_result = j_special ? s1_val : j_jal_offset;

  assign pc_effective = jp ? j_special_result : branch_adder;

endmodule
