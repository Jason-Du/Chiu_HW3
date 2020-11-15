  input                                 clk;
  input                                 rst;

  // Core to CPU wrapper
  input        [       `DATA_BITS-1:0] core_addr;
  input                                core_req;
  input                                core_write;
  input        [       `DATA_BITS-1:0] core_in;
  input        [ `CACHE_TYPE_BITS-1:0] core_type;//4
  input        [                 21:0] TA_out;
  input        [                127:0] DA_out;
  // Mem to CPU wrapper
  input                                D_wait;
  input                                valid_data_from_register;
  // CPU wrapper to core
  output logic                         core_wait;
  // CPU wrapper to Mem
  output logic                         D_req;
  output logic [       `DATA_BITS-1:0] D_addr;
  output logic                         D_write;
  output logic [       `DATA_BITS-1:0] D_in;
  output logic [ `CACHE_TYPE_BITS-1:0] D_type;
  output logic [                  5:0] index; 
  output logic [                 21:0] TA_in;
  output logic                         TA_write;
  output logic                         TA_read;
  output logic [                127:0] DA_in;
  output logic                         DA_write;
  output logic                         DA_read;
  output logic                         vaild_read;

  logic        [                  2:0] cs;
  logic        [                  2:0] ns;
  
  logic        [                 21:0] address_tag;
  //logic        [                 21:0] address_index;
  logic        [                  3:0] address_offset;
  logic                                single_valid_data;
  logic        [                 21:0] address_tag_register_out;
  logic        [                 21:0] address_index_register_out;
  logic        [                  3:0] address_offset_register_out;
  logic                                single_valid_data_register_out;
  logic        [                 21:0] TA_in_register_out;