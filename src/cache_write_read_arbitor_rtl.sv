`include "../include/def.svh"
`timescale 1ns/10ps

module cache_write_read_arbitor(
								core_req,
								core_write,
								D_req_read,
								D_req_write,
								D_addr_read,
								D_addr_write,
								D_in_read,
								D_in_write,
								D_type_read,
								D_type_write,
								D_index_read,
								D_index_write,
								TA_in_read,
								TA_in_write,
								TA_write_read,
								TA_write_write
								TA_read_read,
								TA_read_write,
								DA_in_read,
								DA_in_write,
								DA_write_read,
								DA_write_write,
								DA_read_read,
								DA_read_write,
								valid_read_read,
								valid_read_write,
								
								D_req_data,
								
								D_addr_data,
								
								D_in_data,
								
								D_type_data,
								
								D_index_data,
								
								TA_in_data,			
								
								TA_write_data,
								
								TA_read_data,
								
								DA_in_data,
								
								DA_write_data,
								
								DA_read_data,
								
								valid_read_data,
								
								
);
  input                                core_req;
  input                                core_write;
  input                                D_req_write;//1
  input        [       `DATA_BITS-1:0] D_addr_write;//32
  input        [       `DATA_BITS-1:0] D_in_write;//32
  input        [ `CACHE_TYPE_BITS-1:0] D_type_write;//3
  input        [                  5:0] index_write; //6
  input        [                 21:0] TA_in_write;//1
  input                                TA_write_write;//1
  input                                TA_read_write;//1
  input        [                127:0] DA_in_write;//128
  input                                DA_write_write;//16
  input                                DA_read_write;//1
  input                                vaild_read_write;//1
  input                                D_req_read;
  input        [       `DATA_BITS-1:0] D_addr_read;
  input        [       `DATA_BITS-1:0] D_in_read;
  input        [ `CACHE_TYPE_BITS-1:0] D_type_read;
  input        [                  5:0] index_read; 
  input        [                 21:0] TA_in_read;
  input                                TA_write_read;
  input                                TA_read_read;
  input        [                127:0] DA_in_read;
  input                                DA_write_read;
  input                                DA_read_read;
  input                                vaild_read_read;
  
  
  
  output logic                         D_req_data;
  output logic [       `DATA_BITS-1:0] D_addr_data;
  output logic [       `DATA_BITS-1:0] D_in_data;
  output logic [ `CACHE_TYPE_BITS-1:0] D_type_data;
  output logic [                  5:0] index_data; 
  output logic [                 21:0] TA_in_data;
  output logic                         TA_write_data;
  output logic                         TA_read_data;
  output logic [                127:0] DA_in_data;
  output logic                         DA_write_data;
  output logic                         DA_read_data;
  output logic                         vaild_read_data;
  
  logic        [                221:0] read_signal;
  logic        [                221:0] write_signal;
  logic        [                221:0] decide_signal;
  always_comb
  begin
	write_signal={
					D_req_write,//1
					D_addr_write,//32
					D_in_write,//32
					D_type_write,//3
					index_write, //6
					TA_in_write,//1
					TA_write_write,//1
					TA_read_write,//1
					DA_in_write,//128
					DA_write_write,//16
					DA_read_write,//1
					vaild_read_write,//1
	};
	read_signal={
					D_req_read,
					D_addr_read,
					D_in_read,
					D_type_read,
					index_read, 
					TA_in_read,
					TA_write_read,
					TA_read_read,
					DA_in_read,
					DA_write_read,
					DA_read_read,
					vaild_read_read,
	};
	decide_signal=(core_req&&(core_write==1'b1))?write_signal:read_signal;
	{
		D_req_data,
		D_addr_data,
		D_in_data,
		D_type_data,
		index_data, 
		TA_in_data,
		TA_write_data,
		TA_read_data,
		DA_in_data,
		DA_write_data,
		DA_read_data,
		vaild_read_data,
	}=decide_signal;
  
  end
 endmodule
  
  

/*READ
				 output logic [       `DATA_BITS-1:0] core_out;
  output logic                         core_wait;
  // CPU wrapper to Mem
  output logic                         D_req;
  output logic [       `DATA_BITS-1:0] D_addr;
  output logic [       `DATA_BITS-1:0] D_in;
  output logic [ `CACHE_TYPE_BITS-1:0] D_type
  
  output logic [`CACHE_INDEX_BITS-1:0] index;//6//output cache_address

  output logic [ `CACHE_DATA_BITS-1:0] DA_in;//128//output
  output logic [`CACHE_WRITE_BITS-1:0] DA_write;//16//output
  output logic                         DA_read;

  output logic [  `CACHE_TAG_BITS-1:0] TA_in;//22//output
  output logic                         TA_write;//output
  output logic                         TA_read;//output
  
  output logic                         valid_read;
  output logic                         valid_write;
*/