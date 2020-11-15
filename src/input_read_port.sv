input                                clk,
  input                                rst,
  //input                                cpu_read_signal,
  input        [ `CACHE_DATA_BITS-1:0] DA_out;//128//input
  input        [  `CACHE_TAG_BITS-1:0] TA_out;//22//input
  //input        [     `CACHE_LINES-1:0] valid_from_register;//64
  input                                valid_from_register;//64

  // Core to CPU wrapper
  input        [       `DATA_BITS-1:0] core_addr,
  input                                core_req,
  input        [ `CACHE_TYPE_BITS-1:0] core_type,//4
  input        [       `DATA_BITS-1:0] D_out,
  input                                D_wait,
  
  output logic [       `DATA_BITS-1:0] core_out,
  output logic                         core_wait,
  // CPU wrapper to Mem
  output logic                         D_req,
  output logic [       `DATA_BITS-1:0] D_addr,
  output logic [       `DATA_BITS-1:0] D_in,
  output logic [ `CACHE_TYPE_BITS-1:0] D_type
  
  output logic [`CACHE_INDEX_BITS-1:0] index;//6//output cache_address

  output logic [ `CACHE_DATA_BITS-1:0] DA_in;//128//output
  //logic        [`CACHE_WRITE_BITS-1:0] DA_write;//16//output
  output logic                         DA_read;

  output logic [  `CACHE_TAG_BITS-1:0] TA_in;//22//output
  output logic                                TA_write;//output
  output logic                         TA_read;//output
  
  output logic                         valid_read;
  
  
  
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