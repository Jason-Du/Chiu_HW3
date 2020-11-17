`timescale 1ns/10ps
`include "imm_extended_rtl.sv"
`define PERIOD 20

module test_tb();
 
 
 
parameter DATA_SIZE  =32;		


logic        [         11:0] imm_i_data;
logic        [         11:0] imm_b_data;
logic        [         11:0] imm_s_data;
logic        [         19:0] imm_j_data;
logic        [         19:0] imm_u_data;
logic        [          2:0] imm_extended_control;

logic        [DATA_SIZE-1:0] imm_data;

imm_extended iex(
						.imm_i_data(imm_i_data),
						.imm_b_data(imm_b_data),
						.imm_s_data(imm_s_data),
						.imm_j_data(imm_j_data),
						.imm_u_data(imm_u_data),
						.imm_extended_control(imm_extended_control),
						
						.imm_data(imm_data)
						);
 
 
 
 
initial 
 begin // Declare Input patterns
	imm_i_data=12'hfe0;imm_j_data=20'hff000;imm_b_data=12'hfe0;imm_s_data=12'hfe0;imm_u_data=20'hff000;imm_extended_control=3'd0;
	#5 imm_extended_control=3'd1;
	#5 imm_extended_control=3'd2;
	#5 imm_extended_control=3'd3;
	#5 imm_extended_control=3'd4;
	#5 imm_extended_control=3'd5;
 
 
 

end
 
initial 
begin
	$fsdbDumpfile("imm_extended.fsdb");
	$fsdbDumpvars;
	#10000 $finish;
end



endmodule