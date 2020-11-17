 `timescale 1ns/10ps

 module alu_addr(
				src1,
				imm_data,
				
				alu_addr_out
				);
 parameter DATA_SIZE  =32;
 
 input        [DATA_SIZE-1:0] src1;
 input        [DATA_SIZE-1:0] imm_data;
 
 output logic [         31:0] alu_addr_out;
 
 always_comb
 begin
	alu_addr_out=signed'(src1)+signed'(imm_data);
 end
 
 endmodule