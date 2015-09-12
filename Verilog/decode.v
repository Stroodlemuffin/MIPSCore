/*
	File:		decode.v
	Authour(s):	Chris Thiele, Caleb Amlesom
	Student ID:	cwthiele, camlesom
	Date: 		May 15, 2015
*/

/* List of INSNs to decode:
add, addiu, addu, sub, subu
mult, multu, div, divu, mfhi, mflo
slt, slti, sltu, sltiu
sll, sllv, srl, srlv, sra, srav, and, or, ori, xor, xori, nor
lw, sw, li (ori, lui), lb, sb, lbu, move
j, jal, jalr, jr, beq, beqz, bne, bnez, bgez, bgtz, blez, bltz
nop
*/
/* List of specials INSNs:
BNEZ:				
	bne $rs, $rt, Label
	 translates to:
	bne $rs, $zero, Label
LI:				
	li $8, 0x3BF20
	 translates to:
	lui $8, 0x0003
	ori $8, $8, 0xBF20
MOVE:
	move $1, $2
	 translates to
	add $1, $2, $0
BEQZ:
	beqz $rs,Label
	 translates to:
	beq $rs,$zero,Label
*/


//TODO: REFACTOR THE FUCK OUT OF THIS
module decode (
	input  reg [31:0] insn, 	//insn input: This port receives the instruction word from the memory module 
				//associated with the supplied PC.
	input reg [31:0] pc, 	//pc input: This port receives the PC from the fetch stage for the instruction 
				//that is being transferred to the decode stage. Note that you may have to register 
				//this PC.  This is because the data output of the main memory will have the 
				//instruction available in the next cycle after the PC was placed on its address lines.
				//Hence, you should register the pc output from the Fetch to the PC input of the decode 
				//so that they both arrive at the same time.
  /* OUTPUTS */
  output wire [31:0] pc_out,
  output wire [31:0] insn_out,
  output wire [4:0] s1_out,
  output wire [4:0] s2_out,
	/*Control Bits*/
  output reg rdst,
  output reg dmenable,
  output reg rwe,
  output reg aluinb,	
  output reg [5:0] aluop,
  output reg dmwe,
  output reg rwd,
  output reg jp,
  output reg br
);

/*OPCODES*/
parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter MULT = 6'b011000;
parameter DIV = 6'b011010;
parameter MFHI = 6'b010000;
parameter MFLO = 6'b010010;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
//sll and nop share a code
parameter SLLNOP = 6'b000000;
parameter SLLV = 6'b000100;
parameter SRL = 6'b000010;
parameter SRLV = 6'b000110;
parameter SRA = 6'b000011;
parameter SRAV = 6'b000111;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter JALR = 6'b001001;
parameter JR = 6'b001000;
parameter BGEZ = 5'b00001;
parameter BLTZ = 5'b00000;
parameter ADDIU = 6'b001001;
parameter SLTIU = 6'b001011;
parameter ORI = 6'b001101;
parameter XORI = 6'b001110;
parameter LW = 6'b100011;
parameter SW = 6'b101011;
parameter LUI = 6'b001111;
parameter LB = 6'b100000;
parameter SB = 6'b101000;
parameter LBU = 6'b100100;
parameter J = 6'b000010;
parameter JAL = 6'b000011;
parameter BEQ = 6'b000100;
parameter BNE = 6'b000101;
parameter BGTZ = 6'b000111;
parameter BLEZ = 6'b000110;
parameter SLTI = 6'b001010;
/*INSN TYPE*/
parameter SPECIAL = 6'b000000;
parameter REGIMM = 6'b000001;

/* Available Control Bits: 
	rwe, rdst, aluinb, aluop, dmwe, rwd, jp, br 
*/

/*
0: result <= s1val & s2val;			// result is AND
1: result <= s1val | s2val;			// result is OR
2: result <= s1val + s2val;			// result is ADD
6: result <= s1val - s2val;			// result is SUB
7: result <= s1val < s2val ? 1 : 0;	// result is SLT (set less than)
12: result <= ~(s1val | s2val); 	// result is NOR
20: result <=  s1val * s2val; 		// result is MUL 
30: LO <= s1val / s2val;			// result is DIV 
	HI <= s1val / s2val
default: result <= 0;				// result is set to default 0   --using default as 32
*/
/*Custom control codes for the ALU operation*/
integer andcode = 0; 
integer orcode = 1;
integer addcode = 2;
integer subcode = 6;
integer sltcode = 7;
integer norcode = 12;
integer sllcode = 14;
integer srlcode = 24;
integer mulcode = 20;
integer divcode = 30;
integer xorcode = 28;
integer beqcode = 40;
integer bgezcode = 41;
integer bgtzcode = 42;
integer blezcode = 43;
integer bltzcode = 44;
integer bnecode = 45;

//default code for insns with no ALU
integer defaultcode = 32;

  assign pc_out = pc;
  assign insn_out = insn;
  assign s1_out = insn[25:21];
  assign s2_out = insn[20:16];

	always @(insn) begin
		case (insn[31:26])
// Start OPCODE = 000000 (Special)
			SPECIAL: begin 
				case (insn[5:0])
					//ADD
					ADD: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= addcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//ADDU
					ADDU: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= addcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SUB
					SUB: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= subcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SUBU
					SUBU: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= subcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//MULT
					MULT: begin
						//Set control bits
						dmenable = 0;
						rwe = 0;
						rdst = 1;
						aluinb = 0;
						aluop <= mulcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//DIV
					DIV: begin
						//Set control bits
						dmenable = 0;
						rwe = 0;
						rdst = 1;
						aluinb = 0;
						aluop <= divcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//MFHI
					MFHI: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1; 
						aluinb = 0;
						aluop <= defaultcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//MFLO
					MFLO: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1; 
						aluinb = 0;
						aluop <= defaultcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SLT
					SLT: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= sltcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SLTU
					SLTU: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= sltcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SLL or NOP
					SLLNOP: begin
						if (insn == 32'b0) begin
							//Set control bits
							dmenable = 0;
							rwe = 0;
							rdst = 0;
							aluinb = 0;
							aluop <= defaultcode;
							dmwe = 0;
							rwd = 0;
							jp = 0;
							br = 0;
						end else begin
							//Set control bits
							dmenable = 0;
							rwe = 1;
							rdst = 1; 
							aluinb = 0;
							aluop <= sllcode;
							dmwe = 0;
							rwd = 0;
							jp = 0;
							br = 0;
						end
					end
					//SLLV
					SLLV: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1; 
						aluinb = 0;
						aluop <= sllcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SRL
					SRL: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1; 
						aluinb = 0;
						aluop <= srlcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SRLV
					SRLV: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1; 
						aluinb = 0;
						aluop <= srlcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SRA
					SRA: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1; 
						aluinb = 0;
						aluop <= srlcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//SRAV
					SRAV: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= srlcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//AND
					AND: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= andcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//OR
					OR: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= orcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//XOR
					XOR: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= xorcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//NOR
					NOR: begin
						//Set control bits
						dmenable = 0;
						rwe = 1;
						rdst = 1;
						aluinb = 0;
						aluop <= norcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 0;
					end
					//JALR
					JALR: begin
						//Set control bits
						dmenable = 0;
						rwe = 1; //I believe so
						rdst = 1;
						aluinb = 1; //I believe so
						aluop <= defaultcode;
						dmwe = 0;
						rwd = 0;
						jp = 1;
						br = 0;
					end
					//JR
					JR: begin
						//Set control bits
						dmenable = 0;
						rwe = 0; //I believe so
						rdst = 1;
						aluinb = 1; //I believe so
						aluop <= defaultcode;
						dmwe = 0;
						rwd = 0;
						jp = 1;
						br = 0;
					end
					// Default for special
					default: begin
					end
				endcase //endcase for special
			
		
			end // end opcode case 000000

//Start OPCODE = 000001 (REGIMM)
			REGIMM: begin //Start REGIMM Special Case
				case (insn[20:16])
					//BGEZ
					BGEZ: begin
						//Set control bits
						dmenable = 0;
						rwe = 0;
						rdst = 1; //I think so
						aluinb = 1; //I think so
						aluop <= bgezcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 1; 
					end
					//BLTZ
					BLTZ: begin
						//Set control bits
						dmenable = 0;
						rwe = 0;
						rdst = 1; //I think so
						aluinb = 1; //I think so
						aluop <= bltzcode;
						dmwe = 0;
						rwd = 0;
						jp = 0;
						br = 1; 
					end
					default: begin
					end //end default case
				endcase // end regimm case
			end // end special case REGIMM 000001

//START OPCODE != 000000 && OPCODE != 000001 (immediate)
			//ADDIU
			ADDIU: begin 
				//Set control bits
				dmenable = 0;
				rwe = 1;
				rdst = 0;
				aluinb = 1;
				aluop <= addcode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 0;
			end // end case ADDIU
			//SLTIU
			SLTIU: begin 
				//Set control bits
				dmenable = 0;
				rwe = 1;
				rdst = 0;
				aluinb = 1;
				aluop <= sltcode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 0;
			end // end case SLTIU
			//ORI
			ORI: begin 
				//Set control bits
				dmenable = 0;
				rwe = 1;
				rdst = 0;
				aluinb = 1;
				aluop <= orcode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 0;
			end // end case ORI
			//XORI
			XORI: begin 
				//Set control bits
				dmenable = 0;
				rwe = 1;
				rdst = 0;
				aluinb = 1;
				aluop <= xorcode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 0;
			end // end case ORI
			//LW
			LW: begin 
				//Set control bits
				dmenable = 1;
				rwe = 1; //I don't know how to do this
				rdst = 0;
				aluinb = 1;
				aluop <= addcode; //add offset (immediate position) + base (rs position)
				dmwe = 0;
				rwd = 1;
				jp = 0;
				br = 0;
			end // end case LW
			//SW
			SW: begin 
				//Set control bits
				dmenable = 1;
				rwe = 0;
				rdst = 0; //X
				aluinb = 1;
				aluop <= addcode; //add offset (immediate position) + base (rs position)
				dmwe = 1;
				rwd = 0; //X
				jp = 0;
				br = 0;
			end // end case LW
			//LUI
			LUI: begin 
				//Set control bits
				dmenable = 0;
				rwe = 1; //I don't know how to do this
				rdst = 0;
				aluinb = 1;
				aluop <= defaultcode;
				dmwe = 0;
				rwd = 1;
				jp = 0;
				br = 0;
			end // end case LW
			//LB
			LB: begin 
				//Set control bits
				dmenable = 1;
				rwe = 1; //I don't know how to do this
				rdst = 0;
				aluinb = 1;
				aluop <= addcode; //rt ? memory[base+offset]
				dmwe = 0;
				rwd = 1;
				jp = 0;
				br = 0;
			end // end case LB
			//SB
			SB: begin 
				//Set control bits
				dmenable = 1;
				rwe = 1; //I don't know how to do this
				rdst = 1;
				aluinb = 1;
				aluop <= addcode; //memory[base+offset] ? rt
				dmwe = 0;
				rwd = 1;
				jp = 0;
				br = 0;
			end // end case SB
			//LBU
			LBU: begin 
				dmenable = 1;
				rwe = 1; //I don't know how to do this
				rdst = 0;
				aluinb = 1;
				aluop <= addcode; //rt ? memory[base+offset]
				dmwe = 0;
				rwd = 1;
				jp = 0;
				br = 0;
			end // end case LBU
			//J
			J: begin 
				//Set control bits
				dmenable = 0;
				rwe = 0; //I believe so
				rdst = 1;
				aluinb = 1; //I believe so
				aluop <= defaultcode;
				dmwe = 0;
				rwd = 0;
				jp = 1;
				br = 0;
			end // end case J
			//JAL
			JAL: begin 
				//Set control bits
				dmenable = 0;
				rwe = 1; //I believe so
				rdst = 1;
				aluinb = 1; //I believe so
				aluop <= defaultcode;
				dmwe = 0;
				rwd = 0;
				jp = 1;
				br = 0;
			end // end case JAL
			//BEQ
			BEQ: begin 
				//Set control bits
				dmenable = 0;
				rwe = 0;
				rdst = 1; //I think so
				aluinb = 1; //I think so
				aluop <= beqcode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 1;
			end // end case BEQ
			//BNE
			BNE: begin 
				//Set control bits
				dmenable = 0;
				rwe = 0;
				rdst = 1; //I think so
				aluinb = 1; //I think so
				aluop <= bnecode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 1;
			end // end case BNE
			//BGTZ
			BGTZ: begin
				//Set control bits
				dmenable = 0;
				rwe = 0;
				rdst = 1; //I think so
				aluinb = 1; //I think so
				aluop <= bgtzcode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 1; 
			end
			//BLEZ
			BLEZ: begin
				//Set control bits
				dmenable = 0;
				rwe = 0;
				rdst = 1; //I think so
				aluinb = 1; //I think so
				aluop <= blezcode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 1;
			end
			//SLTI
			SLTI: begin
				//Set control bits
				dmenable = 0;
				rwe = 1;
				rdst = 0;
				aluinb = 1;
				aluop <= sltcode;
				dmwe = 0;
				rwd = 0;
				jp = 0;
				br = 0;
			end
			// Default Case for opcode
			default: begin
        br = 0;
        jp = 0;
			end //end default case
		endcase // endcase (opcode)
	end //end always @(posedge clk)
endmodule // end module decode