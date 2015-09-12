/*
	File:		fetch.v
	Authour(s):	Chris Thiele, Caleb Amlesom
	Student ID:	cwthiele, camlesom
	Date: 		May 15, 2015
*/
module fetch(
  clk,
  stall,
  branch_taken,
  pc_effective,
  pc_out,
  insn_out
);  
  /*MODULE I/O*/
  input wire clk;
  input wire stall;
  input wire branch_taken;
  input wire [31:0] pc_effective;
  output wire [31:0] pc_out;
  output wire [31:0] insn_out;
  
  /*LOCAL*/
  wire busy;
  wire enable;
  wire read_write;
  wire [1:0] access_size;
  wire [31:0] data_in;

  reg [31:0] pc;

  // Insn Memory module
	mainmemory insn_mem_module(
		.clk (clk),
		.busy (busy),
		.enable (enable),
		.read_write (read_write),
		.address_in (pc),
		.access_size (access_size),
		.data_in (data_in),
		.data_out (insn_out)
	);

  assign enable = 1;
  assign read_write = 1;
  assign access_size = 2'b10;

  assign pc_out = pc;

  always @ (posedge clk) begin
    pc <= branch_taken ? pc_effective : (stall ? pc : pc + 4);
  end

endmodule