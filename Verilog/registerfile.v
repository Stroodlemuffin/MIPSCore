/*
	File:		registerfile.v
	Authour(s):	Chris Thiele, Caleb Amlesom
	Student ID:	cwthiele, camlesom
	Date: 		June 10, 2015
*/

module  registerfile (
	clk,	// clock
	wb,		// write back value
	we, 	// write enable
	s1, 	// source 1
	s2, 	// source 2
	d, 		// destination
	s1val,	// source 1 value = Rsout
	s2val	// source 2 value = Rtout
);
	/* INPUTS */
	input clk;
	input [31:0] wb;
	input we;
	input [4:0] s1;
	input [4:0] s2;
	input [4:0] d;

	/* OUTPUTS */
	output wire [31:0] s1val;
	output wire [31:0] s2val;

	/* MAIN FUNCTIONALITY */
	reg [31:0] regfile [0:31];

	// Reads occur on posedge and writes occur on negedge of clk

	assign s1val = regfile[s1]; //write the register value at address s1 to output
	assign s2val = regfile[s2]; //write the register value at address s2 to output

	always @(negedge clk) begin //writeback into register file from writeback stage
	  if(we) begin
		regfile[d] <= wb;
	  end
	end
	
endmodule