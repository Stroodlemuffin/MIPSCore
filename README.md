# MIPSCore
5 stage 32 Bit MIPS processor with bypassing and forwarding done in Verilog
FDXMW - Fetch, Decode, eXecute, Memory, Writeback

**Documentation Folder**

-Resources and guides used to structure the 32 bit MIPS 5 staged pipeline core

**x files Folder**

-Sample .x files used to test the MIPS Core

**Verilog Folder**

-Where the various .v files are for the MIPS Core, files that build up the functionality of the core listed here:
  
  -fetch.v: Fetches the instruction from memory, increments the PC
  
  -decode.v: Decodes the instruction from the fetch stage (breaks it into insn type, rd, rs, rt, offset, etc)
  
  -execute.v: Execution stage of the core, uses the ALU unit
  
  -alu.v: ALU of the core, calculates address offsets and whether or not core needs to branch and where to branch
  
  -loadstore.v: Memory stage of the core, writes or reads from memory depending on the instruction
  
  -mainmemory.v: Memory for the core (size = 1MB)
  
  -registerfile.v: Register delegation in the decode stage of the core
  
  -writeback.v: Writeback stage of the core, decides whether or not to writeback to the register file depending on the load/store instruction
  
  -pd3_tb.v: where all the pipelining, bypassing, forwarding, and all of the modules are placed. All hardware is Asynchronous (combinational) while all stages are Synchronous to the clock
  
For a breakdown of the core refer to the MIPS_Block_Diagram.vsdx visio block diagram file. Note: this is not entirely correct, or complete

**FIXES**

-Need to implement ~5 more instructions for this core to work with all .x files (BubbleSort.x, CheckVowel.x, etc.)
