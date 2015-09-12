/*
	File:		pd3_tb.v
	Authour(s):	Chris Thiele, Caleb Amlesom
	Student ID:	cwthiele, camlesom
	Date: 		June 1, 2015
*/

module pd3_tb;

	/* General Purpose Variables */
	integer in; //File Operators
	integer statusI, count, line_count, r_counter;
	integer j = 0;
	integer k = 0;
	integer address = 0;
	reg [31:0] line; 	

/***************************************** Module Variables ************************************/
	/*	Note:
	*	All of these variable are inputs; inputs that considered to be the outputs of one stage to
	*	the next, but that's how it was designed. eg/ XM_pc is actually the output pc from the DX
	*	stage pipeline register.
	*/
	
	/*Global (FD INPUTS)*/
	reg clk;
	
  /* Define OPCODES for memory based insns */
  parameter LB = 6'b100000;
  parameter LBU = 6'b100100;
  parameter LH = 6'b100001;
  parameter LHU = 6'b100101;
  parameter LW = 6'b100011;
  parameter SB = 6'b101000;
  parameter SH = 6'b101001;
  parameter SW = 6'b101011;
	
  /* Fetch mod */
  wire [31:0] fetch_pc_out;
  wire [31:0] fetch_insn_out;
  reg stall; 

  /* Decode mod */
  wire [31:0] decode_pc_out;
  wire [31:0] decode_insn_out;
  wire [4:0] decode_s1_out;
  wire [4:0] decode_s2_out;
  wire decode_rdst;
  wire decode_dmenable;
  wire decode_rwe;
  wire decode_aluinb;
  wire decode_dmwe;
  wire decode_rwd;
  wire decode_jp;
  wire decode_br;
  wire [5:0] decode_aluop;

  /* Register file */
  wire [31:0] rf_s1val_out;
  wire [31:0] rf_s2val_out;

  /* Execute mod */
  wire execute_branch_taken;
  wire [31:0] execute_pc_effective;
  wire [31:0] execute_pc_out;
  wire [31:0] execute_insn_out;
  wire [13:0] execute_controls_out;
  wire [31:0] execute_O_out;
  wire [31:0] execute_B_out;

  /* Load/Store mod */
  wire [31:0] loadstore_pc_out;
  wire [31:0] loadstore_insn_out;
  wire [13:0] loadstore_controls_out;
  wire [31:0] loadstore_O_out;
  wire [31:0] loadstore_D_out;

  /* Writeback mod */
  wire [31:0] writeback_rdval;
  wire writeback_rwe;
  wire [4:0] writeback_d;

  /* FD */
  reg [31:0] FD_pc;
  reg [31:0] FD_insn;

  /* DX */
  reg [31:0] DX_pc;
  reg [31:0] DX_insn;
  reg [31:0] DX_s1val;
  reg [31:0] DX_s2val;
  reg [13:0] DX_controls; 

  /* XM */
  reg [31:0] XM_pc;
  reg [31:0] XM_insn;
  reg [13:0] XM_controls;
  reg [31:0] XM_O;
  reg [31:0] XM_B;

  /* MW */
  reg [31:0] MW_pc;
  reg [31:0] MW_insn;
  reg [13:0] MW_controls;
  reg [31:0] MW_O;
  reg [31:0] MW_D;
  
  /* BYPASS */
  reg WM_bypass;
  reg [31:0] WM_B_bypass;
  
  reg [4:0] XM_reg;
  reg [4:0] MW_reg;
  reg MX_abypass;
  reg MX_bbypass;
  reg [31:0] MX_bypassval;
  reg WX_abypass;
  reg WX_bbypass;
  reg [31:0] WX_bypassval;
  

  /* Every posedge @ clk, shift everything down the pipeline */
  always @ (posedge clk) begin
    FD_pc <= execute_branch_taken ? 32'b0 : (stall ? FD_pc : fetch_pc_out); 			//FD pipe reg pc, flush if branch taken
    FD_insn <= execute_branch_taken ? 32'b0 : (stall ? FD_insn : fetch_insn_out);		//FD pipe reg insn, flush if branch taken
    DX_pc <= (execute_branch_taken || stall)  ? 32'b0 : decode_pc_out;					//DX pipe reg pc, flush if branch taken
    DX_insn <= (execute_branch_taken || stall) ? 32'b0 : decode_insn_out;				//DX pipe reg insn, flush if branch taken
    DX_controls <= (execute_branch_taken || stall) ? 14'b0 : {decode_rdst, decode_dmenable, 
		decode_rwe, decode_aluinb, decode_dmwe, decode_rwd, decode_jp, decode_br, decode_aluop};	//DX pipe reg control bits, flush if branch taken
    DX_s1val <= (execute_branch_taken || stall) ? 32'b0 : rf_s1val_out;	//DX pipe reg s1val, flush if branch taken
    DX_s2val <= (execute_branch_taken || stall) ? 32'b0 : rf_s2val_out;	//DX pipe reg s2val, flush if branch taken
    XM_pc <= execute_pc_out;				//XM pipe reg pc, move PC from execute to XM pipe reg
    XM_insn <= execute_insn_out;			//XM pipe reg insn, move insn from execute to XM pipe reg
    XM_controls <= execute_controls_out;	//XM pipe reg controls, move controls from execute to XM pipe reg
    XM_O <= execute_O_out;					//XM pipe reg O, move O from execute to XM pipe reg
    XM_B <= execute_B_out;					//XM pipe reg B, move B from execute to XM pipe reg
    MW_pc <= loadstore_pc_out;				//MW pipe reg pc, move PC from execute to MW pipe reg
    MW_insn <= loadstore_insn_out;			//MW pipe reg insn, move insn from execute to MW pipe reg
    MW_controls <= loadstore_controls_out;	//MW pipe reg controls, move controls from execute to MW pipe reg
    MW_O <= loadstore_O_out;				//MW pipe reg O, move O from execute to MW pipe reg
    MW_D <= loadstore_D_out;				//MW pipe reg D, move D from execute to MW pipe reg
  end

/********************************************* Fetch Module ***************************************/
  fetch fetch_mod (
    .clk(clk),
    .stall(stall),
    .branch_taken(execute_branch_taken),
    .pc_effective(execute_pc_effective),
    .pc_out(fetch_pc_out),
    .insn_out(fetch_insn_out)
  );
	
/********************************************* Decode Module ***************************************/	
  decode decode_mod (
    /* INPUTS */
    .insn(FD_insn),
    .pc(FD_pc),
    /* OUTPUTS */
    .pc_out(decode_pc_out),
    .insn_out(decode_insn_out),
    .s1_out(decode_s1_out),
    .s2_out(decode_s2_out),
    /* CONTROL BITS */
    .rdst(decode_rdst),
    .dmenable(decode_dmenable),
    .rwe(decode_rwe),
    .aluinb(decode_aluinb),
    .aluop(decode_aluop),
    .dmwe(decode_dmwe),
    .rwd(decode_rwd),
    .jp(decode_jp),
    .br(decode_br)
  );

  registerfile rf_mod (
    .clk(clk),
    .s1(decode_s1_out),
    .s2(decode_s2_out),
    .wb(writeback_rdval), 
    .we(writeback_rwe),
    .d(writeback_d),
    .s1val(rf_s1val_out),
    .s2val(rf_s2val_out)
  );
	
/********************************************* Execute Module ***************************************/	
  execute execute_mod(
    .clk(clk),
    .pc(DX_pc),
    .insn(DX_insn),
    .s1_val(DX_s1val),
    .s2_val(DX_s2val),
    .controls(DX_controls),
    /* BRANCH */
    .branch_taken(execute_branch_taken),
    .pc_effective(execute_pc_effective),
    /* OUTPUTS */
    .pc_out(execute_pc_out),
    .insn_out(execute_insn_out),
    .controls_out(execute_controls_out),
    .O_out(execute_O_out),
    .B_out(execute_B_out),
	/* BYPASS */
	.MX_abypass(MX_abypass),		// A
	.MX_bbypass(MX_bbypass),		// A
	.MX_bypassval(MX_bypassval),	// A
	.WX_abypass(WX_abypass),		// B
	.WX_bbypass(WX_bbypass),		// B
	.WX_bypassval(WX_bypassval)		// B
  );
	
/********************************************* Load/Store Module ***************************************/
  loadstore loadstore_mod(
    .clk(clk),
    .pc(XM_pc),
    .insn(XM_insn),
    .controls(XM_controls),
    .O(XM_O),
    .B(XM_B),
    /* OUTPUTS */
    .pc_out(loadstore_pc_out),
    .insn_out(loadstore_insn_out),
    .controls_out(loadstore_controls_out),
    .O_out(loadstore_O_out),
    .D_out(loadstore_D_out),
    /* BYPASS */
    .WM_bypass(WM_bypass),
    .WM_B_bypass(WM_B_bypass) 
  );

/********************************************* Writeback Module ***************************************/
  writeback writeback_mod (
    .pc(MW_pc),
    .insn(MW_insn),
    .controls(MW_controls),
    .O(MW_O),
    .D(MW_D),
    /* OUTPUTS */
    .rdval(writeback_rdval),
    .rwe(writeback_rwe),
    .d(writeback_d)
  ); 

/*********************************** End Modules Declaration ************************************/


/************************************* Bypasses and Stalls **************************************/
	/* MW Bypass */
	always @ (XM_controls, writeback_rwe, XM_insn, writeback_d, writeback_rdval) begin
		WM_bypass = XM_controls[12] & writeback_rwe & (XM_insn[20:16] === writeback_d);	// WM_bypass = XM_dmenable & writeback_rwe & (XM_insn[20:16] === writeback_d)
		WM_B_bypass = writeback_rdval;													// Bypass value is the value of rdval from writeback
	end
  
	/* A Bypass to X */
	always @ (XM_controls, XM_insn, DX_insn, DX_controls) begin
		XM_reg = XM_controls[13] ? XM_insn[15:11] : XM_insn[20:16];						// XM_reg = XM_rdst ? XM_insn[15:11] : XM_insn[20:16]
		MX_abypass = XM_controls[11] & (DX_insn[25:21] == XM_reg);						// MX_abypass = XM_rwe & (DX_insn[25:21] == XM_reg)
		MX_bbypass = XM_controls[11] & ~DX_controls[10] & (DX_insn[20:16] == XM_reg);	// MX_bbypass = XM_controls_rwe & ~DX_aluinb & (DX_insn[20:16] == XM_reg)
		MX_bypassval = XM_O;															// MX_bypassval = XM_O;
	end

	/* B Bypass to X */
	always @ (MW_controls, MW_insn, MW_controls, DX_insn, DX_controls) begin
		MW_reg = MW_controls[13] ? MW_insn[15:11] : MW_insn[20:16];						// MW_reg = MW_rdst ? MW_insn[15:11] : MW_insn[20:16];
		WX_abypass = MW_controls[11] & (DX_insn[25:21] == MW_reg);						// WX_abypass = MW_rwe & (DX_insn[25:21] == MW_reg);
		WX_bbypass = MW_controls[11] & ~DX_controls[10] & (DX_insn[20:16] == MW_reg);	// WX_bbypass = MW_rwe & ~DX_aluinb & (DX_insn[20:16] == MW_reg);
		WX_bypassval = (MW_controls[12] & ~MW_controls[9]) ? MW_D : MW_O;				// WX_bypassval = (MW_dmenable & ~MW_dmwe) ? MW_D : MW_O;			
	end

	/* Stall Logic */
	always @ (DX_insn, FD_insn) begin
		// fetch_stall = DX_insn[31:26] == LOAD && (DX_rt == FD_rs | DX_rt == FD_rt) && FD_insn[31:26] != STORE 
		// SW $2, 0(4) [FD]  --> LW $2, 0(2) [DX]     CAN USE WM BYPASS
		// ADD $4,$2,$3 [FD] --> LW $3,4($2) [DX]     NEED TO STALL
		stall <= (((DX_insn[31:26] === LB) || (DX_insn[31:26] === LBU) || 							// If insn in DX stage is = load
			(DX_insn[31:26] === LH) || (DX_insn[31:26] === LHU) || (DX_insn[31:26] === LW)) &&		// And the rt in DX stage = rs in FD stage OR rt in DX stage = rt in FD stage
			((DX_insn[20:16] === FD_insn[25:21]) ||	(DX_insn[20:16] === FD_insn[20:16])) &&			// And the following insn is not a Store
			!((FD_insn[31:26] === SB) || (FD_insn[31:26] === SH) || (FD_insn[31:26] === SW)));		// Then --> Stall
	end

/*********************************** End Bypasses and Stalls ************************************/
	
/************************************************************************************************/
/************************************** Test Bench **********************************************/
/************************************************************************************************/	
	
	initial begin
	
		clk = 0;
		fetch_mod.pc = 32'h80020000;
		execute_mod.branch_taken = 0;
		stall = 0;
		WM_bypass = 0;
		
		for(j = 0; j < 32; j = j + 1) begin
		  rf_mod.regfile[j] = 0;
		end

		rf_mod.regfile[29] = 32'h80120000;	// Set SP
		rf_mod.regfile[31] = 32'h8002ABCD;	// Set Return Address to something abitrary
				
		/* DUT - fetch + decode module */
		in  = $fopen ("SimpleAdd.x","r");//("DivDivDiv.x","r"); ("MW_bypass_test.x","r"); ("StallEX.x","r"); ("SimpleAdd.x","r")
		address = 0;
		
		/* Read in values to memory until EOF */
		while($feof(in) == 0) begin
			statusI = $fscanf(in, "%x\n", line);
			fetch_mod.insn_mem_module.memory[address] = line[31:24]; 
			fetch_mod.insn_mem_module.memory[address+1] = line[23:16]; 
			fetch_mod.insn_mem_module.memory[address+2] = line[15:8]; 
			fetch_mod.insn_mem_module.memory[address+3] = line[7:0]; 
			
			loadstore_mod.data_mem_module.memory[address] = line[31:24]; 
			loadstore_mod.data_mem_module.memory[address+1] = line[23:16]; 
			loadstore_mod.data_mem_module.memory[address+2] = line[15:8]; 
			loadstore_mod.data_mem_module.memory[address+3] = line[7:0]; 

			address = address + 4;
		end //end write
				
		$fclose(in);
		end

		always @(posedge clk) begin
			$display("FETCH Stage => PC: %x\n", fetch_mod.pc);
			$display("DECODE Stage => PC: %x, INSN: %x, S1VAL: %x, S2VAL: %x\n", FD_pc, FD_insn, rf_s1val_out, rf_s2val_out);
			$display("EXECUTE Stage => PC: %x, INSN: %x, A: %x, B: %x, RESULT: %x\n", DX_pc, DX_insn, DX_s1val, DX_s2val, execute_O_out);
			$display("MEMORY Stage => PC: %x, INSN: %x, ADDRESS: %x, DATA: %x, DMENABLE: %d\n", XM_pc, XM_insn, XM_O, XM_B, XM_controls[12]);
			$display("WRITEBACK Stage => PC: %x, INSN: %x, RDVAL: %x, RD: %x, RWE: %d\n", MW_pc, MW_insn, writeback_rdval, writeback_d, writeback_rwe);
			// If the PC gets back to the arbitrary RA, stop the program --> program completed
			if (fetch_mod.pc == 32'h8002ABCD) begin
				//print memory
				$stop;
			end
		end

		// Clock block
		always begin
			#10 clk = !clk;
		end

endmodule
