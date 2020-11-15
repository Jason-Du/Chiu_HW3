//================================================
// Auther:      Chen Yun-Ru (May)
// Filename:    L1C_data.sv
// Description: L1 Cache for data
// Version:     0.1
//================================================
`include "def.svh"
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
  logic        [     `CACHE_LINES-1:0] valid;//64

  //--------------- complete this part by yourself -----------------//
cache_write cah_wr(
					.clk(),
					.rst(),
					.core_addr(),
					.core_req(),
					.core_write(),
					.core_in(),
					.core_type(),//4
					.D_wait(),
					.TA_out;
					//DA_out;
					.valid_data_from_register(),

					.core_wait(),

					  // CPU wrapper to Mem
					.D_req(),
					.D_addr(),
					.D_write(),
					.D_in(),
					.D_type(),


					.index(),
					.TA_in(),
					.TA_write(),
					.TA_read(),

					.DA_in(),
					.DA_write(),


					.vaild_read(),
					.vaild_write()
);
cache_read cahre(
				  .clk(),
				  .rst(),

				  // Core to CPU wrapper
				  //cpu_read_signal(),
				  .valid_from_register(),
				  .core_write(),
				  .DA_out(),//128//input
				  .TA_out;//22//input
				  .core_addr(),
				  .core_req(),
				  .core_type(),//4
				  .D_out(),
				  .D_wait(),
				  // CPU wrapper to core
				  .core_out(),
				  .core_wait(),
				  // CPU wrapper to Mem
				  .D_req(),
				  .D_addr(),
				  .D_in(),
				  .D_type(),
				  .index(),//6//output cache_address

				  .DA_in(),//128//output
				  .DA_write;//16//output
				  .DA_read(),
				  .TA_in(),//22//output
				  .TA_read(),//output
				  .TA_write;
				  .valid_read(),
				  .valid_write()
  
);
cache_write_read_arbitor(
								.core_req(),
								.core_write(),
								.D_req_read(),
								.D_req_write(),
								.D_addr_read(),
								.D_addr_write(),
								.D_in_read(),
								.D_in_write(),
								.D_type_read(),
								.D_type_write(),
								.D_index_read(),
								.D_index_write(),
								.TA_in_read(),
								.TA_in_write(),
								.TA_write_read(),
								.TA_write_write
								.TA_read_read(),
								.TA_read_write(),
								.DA_in_read(),
								.DA_in_write(),
								.DA_write_read(),
								.DA_write_write(),
								.DA_read_read(),
								.DA_read_write(),
								.valid_read_read(),
								.valid_read_write(),
								
								.D_req_data(),
								
								.D_addr_data(),
								
								.D_in_data(),
								
								.D_type_data(),
								
								.D_index_data(),
								
								.TA_in_data(),			
								
								.TA_write_data(),
								
								.TA_read_data(),
								
								.DA_in_data(),
								
								.DA_write_data(),
								
								.DA_read_data(),
								
								.valid_read_data()
								
								
);
valid_register val_rigt(
					.clk(),
					.rst(),
					.valid_addr(),
					.valid_write(),
					.valid_read(),
					
					
					.valid_data()
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

