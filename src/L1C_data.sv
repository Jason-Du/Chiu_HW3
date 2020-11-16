//================================================
// Auther:      Chen Yun-Ru (May)
// Filename:    L1C_data.sv
// Description: L1 Cache for data
// Version:     0.1
//================================================
`include "../include/def.svh"
`include "cache_write_read_arbitor_rtl.sv"
`include "cache_read_rtl.sv"
`include "cache_write_rtl.sv"
`include "valid_register_rtl.sv"
`timescale 1ns/10ps
module L1C_data(
  input                               clk,
  input                               rst,

  // Core to CPU wrapper
  input        [       `DATA_BITS-1:0] core_addr,
  input                               core_req,
  input                               core_write,
  input        [       `DATA_BITS-1:0] core_in,
  input        [ `CACHE_TYPE_BITS-1:0] core_type,//4
  // Mem to CPU wrapper
  input        [       `DATA_BITS-1:0] D_out,
  input                               D_wait,
  // CPU wrapper to core
  output logic [       `DATA_BITS-1:0] core_out,
  output logic                         core_wait,
  // CPU wrapper to Mem
  output logic                         D_req,
  output logic [       `DATA_BITS-1:0] D_addr,
  output logic                         D_write,
  output logic [       `DATA_BITS-1:0] D_in,
  output logic [ `CACHE_TYPE_BITS-1:0] D_type
);

  logic        [`CACHE_INDEX_BITS-1:0] index;//6//address
  logic        [ `CACHE_DATA_BITS-1:0] DA_out;//128//output
  logic        [ `CACHE_DATA_BITS-1:0] DA_in;//128
  logic        [`CACHE_WRITE_BITS-1:0] DA_write;//16
  logic                                DA_read;
  logic        [  `CACHE_TAG_BITS-1:0] TA_out;//22
  logic        [  `CACHE_TAG_BITS-1:0] TA_in;//22
  logic                                TA_write;
  logic                                TA_read;
  //logic        [     `CACHE_LINES-1:0] valid;//64

  //--------------- complete this part by yourself -----------------//
  logic                                valid_data_from_register;
  logic                                vaild_read_signal;
  logic                                valid_write;
  
  logic                                core_wait_write;
  logic                                D_req_write;//1
  logic        [       `DATA_BITS-1:0] D_addr_write;//32
  logic        [       `DATA_BITS-1:0] D_in_write;//32
  logic        [ `CACHE_TYPE_BITS-1:0] D_type_write;//3
  logic        [                  5:0] index_write; //6
  logic        [                 21:0] TA_in_write;//1
  logic                                TA_write_write;//1
  logic                                TA_read_write;//1
  logic        [                127:0] DA_in_write;//128
  logic        [                 15:0] DA_write_write;//16
  logic                                DA_read_write;//1
  logic                                valid_read_write;//1
  logic							       core_wait_read;
  logic                                D_req_read;
  logic        [       `DATA_BITS-1:0] D_addr_read;
  logic        [       `DATA_BITS-1:0] D_in_read;
  logic        [ `CACHE_TYPE_BITS-1:0] D_type_read;
  logic        [                  5:0] index_read; 
  logic        [                 21:0] TA_in_read;
  logic                                TA_write_read;
  logic                                TA_read_read;
  logic        [                127:0] DA_in_read;
  logic        [                 15:0] DA_write_read;
  logic                                DA_read_read;
  logic                                valid_read_read;
cache_write cah_wr(
					.clk(clk),
					.rst(rst),
					.core_addr(core_addr),
					.core_req(core_req),
					.core_write(core_write),
					.core_in(core_in),
					.core_type(core_type),//4
					.D_wait(D_wait),
					.TA_out(TA_out),
					//DA_out;
					.valid_data_from_register(valid_data_from_register),

					.core_wait(core_wait_write),

					  // CPU wrapper to Mem
					.D_req(D_req_write),
					.D_addr(D_addr_write),
					.D_write(D_write),
					.D_in(D_in_write),
					.D_type(D_type_write),


					.index(index_write),
					.TA_in(TA_in_write),
					.TA_write(TA_write_write),
					.TA_read(TA_read_write),

					.DA_in(DA_in_write),
					.DA_write(DA_write_write),
					.DA_read(DA_read_write),


					.valid_read(valid_read_write)
);
cache_read cahre(
				  .clk(clk),
				  .rst(rst),

				  // Core to CPU wrapper
				  //cpu_read_signal(),
				  .valid_from_register(valid_data_from_register),
				  .core_write(core_write),
				  .DA_out(DA_out),//128//input
				  .TA_out(TA_out),//22//input
				  .core_addr(core_addr),
				  .core_req(core_req),
				  .core_type(core_type),//4
				  .D_out(D_out),
				  .D_wait(D_wait),
				  // CPU wrapper to core
				  .core_out(core_out),
				  .core_wait(core_wait_read),
				  // CPU wrapper to Mem
				  .D_req(D_req_read),
				  .D_addr(D_addr_read),
				  .D_in(D_in_read),
				  .D_type(D_type_read),
				  .index(index_read),//6//output cache_address

				  .DA_in(DA_in_read),//128//output
				  .DA_write(DA_write_read),//16//output
				  .DA_read(DA_read_read),
				  .TA_in(TA_in_read),//22//output
				  .TA_read(TA_read_read),//output
				  .TA_write(TA_write_read),
				  .valid_read(valid_read_read),
				  .valid_write(valid_write)
  
);
cache_write_read_arbitor cah_arbitor(
								.clk(clk),
								.rst(rst),
								.core_req(core_req),
								.core_write(core_write),
								.core_wait_read(core_wait_read),
								.core_wait_write(core_wait_write),
								.D_req_read(D_req_read),
								.D_req_write(D_req_write),
								.D_addr_read(D_addr_read),
								.D_addr_write(D_addr_write),
								.D_in_read(D_in_read),
								.D_in_write(D_in_write),
								.D_type_read(D_type_read),
								.D_type_write(D_type_write),
								.index_read(index_read),
								.index_write(index_write),
								.TA_in_read(TA_in_write),
								.TA_in_write(TA_in_write),
								.TA_write_read(TA_write_read),
								.TA_write_write(TA_write_write),
								.TA_read_read(TA_read_read),
								.TA_read_write(TA_read_write),
								.DA_in_read(DA_in_read),
								.DA_in_write(DA_in_write),
								.DA_write_read(DA_write_read),
								.DA_write_write(DA_write_write),
								.DA_read_read(DA_read_read),
								.DA_read_write(DA_read_write),
								.valid_read_read(valid_read_read),
								.valid_read_write(valid_read_write),
								
								.core_wait_data(core_wait),
								
								.D_req_data(D_req),
								
								.D_addr_data(D_addr),
								
								.D_in_data(D_in),
								
								.D_type_data(D_type),
								
								.index_data(index),
								
								.TA_in_data(TA_in),			
								
								.TA_write_data(TA_write),
								
								.TA_read_data(TA_read),
								
								.DA_in_data(DA_in),
								
								.DA_write_data(DA_write),
								
								.DA_read_data(DA_read),
								
								.valid_read_data(vaild_read_signal)
);

valid_register val_rigt(
					.clk(clk),
					.rst(rst),
					.valid_addr(index),
					.valid_write(valid_write),
					.valid_read(vaild_read_signal),
					
					
					.valid_data(valid_data_from_register)
						);

  
  data_array_wrapper DA(
    .A(index),
    .DO(DA_out),
    .DI(DA_in),
    .CK(clk),
    .WEB(DA_write),
    .OE(DA_read),
    .CS(1'b1)
  );
   
  tag_array_wrapper  TA(
    .A(index),
    .DO(TA_out),
    .DI(TA_in),
    .CK(clk),
    .WEB(TA_write),
    .OE(TA_read),
    .CS(1'b1)
  );

endmodule

