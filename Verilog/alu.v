/*
	File:		alu.v
	Authour(s):	Chris Thiele, Caleb Amlesom
	Student ID:	cwthiele, camlesom
	Date: 		June 15, 2015
*/

module alu (
	s1val,		// s1val from register file = Rsout
	s2val,		// s2val from register file = Rtout
	sa,			// shift amount for shift commands (SRA)
	ALUop,		// function code **NEEDS MORE BITS**
	result,		// result of ALU operation
	branch,		// branch output = 1 -> branch taken, 0 -> branch not taken
	insn
);

//input declaration

input [31:0] s1val;
input [31:0] s2val;
input [31:0] insn;
input [5:0] ALUop;
input [4:0] sa;

reg [31:0] div_hi;	// hi register
reg [31:0] div_lo;	// lo register

parameter MFHI = 12'b000000010000;	// insn code for special + MFHI
parameter MFLO = 12'b000000010010;	// insn code for special + MFLO

/*
integer unsigned xorcode = 28;
integer unsigned beqcode = 40;
integer unsigned bgezcode = 41;
integer unsigned bgtzcode = 42;
integer unsigned blezcode = 43;
integer unsigned bltzcode = 44;
integer unsigned bnecode = 45;
//default code for insns with no ALU
integer unsigned defaultcode = 32;
*/

output reg [31:0] result;
output reg branch;

	always @(ALUop, s1val, s2val, sa) begin //reevaluate if these change
	
		case ({insn[31:26],insn[5:0]})
			MFHI: result <= div_hi; // moves hi register into result when MFHI insn passes through
			MFLO: result <= div_lo;	// moves lo register into result when MFLO insn passes through
			default: result <= 0;
		endcase
	
		case (ALUop)
			0: result <= s1val & s2val;			// result is AND
			1: result <= s1val | s2val;			// result is OR
			2: result <= s1val + s2val;			// result is ADD
			6: result <= s1val - s2val;			// result is SUB
			7: result <= s1val < s2val ? 1 : 0;	// result is SLT (set less than)
			12: result <= ~(s1val | s2val); 	// result is NOR
			14: result <= s2val << sa;			// result is s2val shifted left by sa (define sa = immediate)
			24: result <= s2val >> sa;			// result is s2val shifted right by sa (define sa = immediate)
			20: result <=  s1val * s2val; 		// result is MUL 
			30: begin
					result <= 0;				// returns nothing when the insn is DIV
					div_lo <= s1val / s2val;	// store result of s1/s2 in LO reg
					div_hi <= s1val % s2val;	// store quotient of s1/s2 in HI reg
				end
			28: result <= s1val ^ s2val;		// result is XOR 
		  default: result <= 0;					// result is set to default 0, defaultcode = 32
		endcase

    case (ALUop)
      40: if (s1val==s2val) branch <= 1;	// result is BEQ 
			41: if (s1val == 0) branch <= 1;	// result is BGEZ 
			42: if (s1val > 0) branch <= 1;		// result is BGTZ 
			43: if (s1val <= 0) branch <= 1;	// result is BLEZ 
			44: if (s1val < 0) branch <= 1;		// result is BLTZ 
			45: if (s1val !== s2val) branch <= 1;// result is BNE *ALUop INCORRECT*
      default: branch <= 0;
    endcase
	end

endmodule