/*
	File:		writeback.v
	Authour(s):	Chris Thiele, Caleb Amlesom
	Student ID:	cwthiele, camlesom
	Date: 		July 10, 2015
*/
module writeback (
  /* INPUTS */
  input wire [31:0] pc,
  input wire [31:0] insn,
  input wire [13:0] controls,
  input wire [31:0] O,
  input wire [31:0] D,
  /* OUTPUTS */
  output wire [31:0] rdval,
  output wire rwe,
  output wire [4:0] d
);
  /* JAL OPCODE */
  parameter JAL = 6'b000011;

  wire rdst;
  wire dmenable;
  wire dmwe;

  /* CONTROL BITS */
  assign rdst = controls[13];
  assign dmenable = controls[12];
  assign rwe = controls[11];
  assign dmwe = controls[9]; 

  /* d gets the value 1f if insn is JAL, OR if insn is not JAL then if rdst is 1,
     d gets the value of rd, and if rdst is 0, it gets the value of rt */
  assign d = (insn[31:26] == JAL) ? 5'h1f : (rdst ? insn[15:11] : insn[20:16]);
  /* rdval gets the value of O if dmenable is 0, and if dmenable is 1, it gets the
	 value of O if dmwe is 1 or the value of D if dmwe is 0 */
  assign rdval = dmenable ? (dmwe ? O : D) : O; 

endmodule
