/*
	File:		mainmemory.v
	Authour(s):	Chris Thiele, Caleb Amlesom
	Student ID:	cwthiele, camlesom
	Date: 		May 16, 2015
*/

module mainmemory(
	output reg [0:31] data_out,
	output reg busy,
	input enable,
	input [0:31] address_in,
	input [0:31] data_in, 
	input read_write,
	input [0:1] access_size,	// 1 byte = 0x00, 2 bytes (halfword) = 0x01, 4 bytes (word) = 0x10
	input clk
);
parameter MEGABYTES = 1;
parameter OFFSET = 32'h80020000;
reg [0:7] count = 0;
reg [0:7] memory [0:MEGABYTES*1048576];

	always @(enable, read_write, address_in, access_size) begin
		if(enable == 1) begin
			if (read_write) begin //read/write --> == 1 --> read			
				busy = 1; 			//set busy to 1, memory is in use
				case(access_size)
				2'b00: begin		//1 byte
						data_out[0:7] = memory[address_in-OFFSET]; 			//MSB memory position in LSB of bus
					end
				2'b01: begin		//2 bytes (halfword)
						data_out[0:7] = memory[address_in-OFFSET];
						data_out[8:15] = memory[address_in-OFFSET + 1]; 	//MSB memory position in LSB of bus
					end
				2'b10: begin		//4 bytes (word) <-- most common case
						data_out[0:7] = memory[address_in-OFFSET]; 			//LSB memory position in MSB of bus
						data_out[8:15] = memory[address_in-OFFSET + 1];
						data_out[16:23] = memory[address_in-OFFSET + 2];
						data_out[24:31] = memory[address_in-OFFSET + 3]; 	//MSB memory position in LSB of bus
					end
				default: begin							
					end
				endcase //end case statement for access_size read
				busy = 0; //set busy back to 0, memory can be used
      end else begin //read/write --> == 0 --> write
				busy = 1; 			// memory is in use, set busy
				case(access_size)
				2'b00: begin		//1 byte
						memory[address_in-OFFSET] = data_in[0:7];	//LSB bus in MSB memory position
					end	
				2'b01: begin		//2 bytes (halfword)
						memory[address_in-OFFSET] = data_in[0:7];	//LSB bus in MSB memory position
						memory[address_in-OFFSET + 1] = data_in[8:15];
					end	
				2'b10: begin		//4 bytes (word) <-- most common
						memory[address_in-OFFSET + 3] = data_in[0:7];	//LSB bus in MSB memory position
						memory[address_in-OFFSET + 2] = data_in[8:15];
						memory[address_in-OFFSET + 1] = data_in[16:23];
						memory[address_in-OFFSET] = data_in[24:31];		// MSB bus in LSB memory position
					end	
				default: begin
					end	
				endcase
				busy = 0;	// busy is deasserted, memory can be used again
    		end //end if read/write
		end //end if enable == 1
		
		//write zeros to the output in case of stall --> set enable ==0 and you get a stall
		else begin //if enable == 0, you get a stall
			busy = 1; // set busy
			data_out[24:31] = 8'b0; 	//LSB memory position in MSB of bus
			data_out[16:23] = 8'b0;
			data_out[8:15] = 8'b0;
			data_out[0:7] = 8'b0; 		//MSB memory position in LSB of bus
			busy = 0; //set busy back to 0, not busy
		end
	end //end @always (variables)
endmodule