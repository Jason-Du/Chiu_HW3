`include "def.svh"
`timescale 1ns/10ps
module cache_read(
				  clk,
				  rst,

				  // Core to CPU wrapper
				  //cpu_read_signal,
				  valid_from_register,
				  core_write,
				  DA_out,//128//input
				  TA_out;//22//input
				  core_addr,
				  core_req,
				  core_type,//4
				  D_out,
				  D_wait,
				  // CPU wrapper to core
				  core_out,
				  core_wait,
				  // CPU wrapper to Mem
				  D_req,
				  D_addr,
				  D_in,
				  D_type,
				  index,//6//output cache_address

				  DA_in,//128//output
				  DA_write;//16//output
				  DA_read,
				  TA_in,//22//output
				  TA_read,//output
				  TA_write;
				  valid_read,
				  valid_write
  
);
  input                                clk;
  input                                rst;
  input                               core_write;
  //input                                cpu_read_signal;
  input        [ `CACHE_DATA_BITS-1:0] DA_out;//128//input
  input        [  `CACHE_TAG_BITS-1:0] TA_out;//22//input
  //input        [     `CACHE_LINES-1:0] valid_from_register;//64
  input                                valid_from_register;//64

  // Core to CPU wrapper
  input        [       `DATA_BITS-1:0] core_addr;
  input                                core_req;
  input        [ `CACHE_TYPE_BITS-1:0] core_type;//4
  input        [       `DATA_BITS-1:0] D_out;
  input                                D_wait;
  // CPU wrapper to core
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
  
  //logic        [     `CACHE_LINES-1:0] valid_register_out;
  logic        [     `CACHE_LINES-1:0] index_register_out;
  logic        [     `CACHE_LINES-1:0] TA_in_register_out;
  logic        [                127:0] DA_in_register_out;
  logic        [ `CACHE_TYPE_BITS-1:0] D_type_register_out;
  logic        [                 31:0] D_addr_register_out;
  logic                                single_vaild_data;
  logic                                single_vaild_data_register_out;
  logic        [                  3:0] offset;
  logic        [                  3:0] offset_register_out;
  logic        [                  3:0] cs;
  logic        [                  3:0] ns;

  //logic        [               2:0] read_mem_count;
  //logic        [               2:0] read_mem_count_register_out;  
  
  
  always_ff@(posedge clk or posedge rst)
  begin
	if(rst)
	begin
		cs<=4'b000;
	end
	else
	begin
		cs<=ns;
	end
  end
  always_ff@(posedge clk or posedge rst)
  begin
	if(rst)
	begin
		//valid_register_out<=64'd0;
		index_register_out<=6'd0;
		TA_in_register_out<=22'd0;
		D_type_register_out<=3'b000;
		D_addr_register_out<=32'd0;
		single_vaild_data_register_out<=1'b0;
		offset_register_out<=4'b0000;
		DA_in_register_out<=127'd0;
	end
	else
	begin
		//valid_register_out<=vaild;
		index_register_out<=index;
		TA_in_register_out<=TA_in;
		D_type_register_out<=D_type;
		D_addr_register_out<=D_addr;
		single_vaild_data_register_out<=single_vaild_data;
		offset_register_out<=offset;
		DA_in_register_out<=DA_in;
	end
  end
  /*
  ns
core_out,
core_wait,

D_req,
D_addr,
D_in,
D_type
  
index;//6//output cache_address

DA_in;//128//output
DA_read;
TA_in;//22//output
TA_read;//output
valid_read;
offset
single_vaild_data
DA_write;//16//output
TA_write;
valid_write
	*/
  always_comb
  begin
		case(cs)
			4'b0000:
			begin
				if(core_req&&core_write==1'b0)
				begin
					ns               =4'b0010;
					core_wait        =1'b1;
					index            =core_addr[9:4];
					TA_in            =core_addr[31:10];
					offset           =core_addr[3:0]
					D_type           =core_type;
					D_addr           =core_addr;
					valid_read       =1'b1;
					single_vaild_data=valid_from_register;
					DA_read =1'b1;
					TA_read =1'b1;
					//single_vaild_data=valid_from_register[index];

				end
				else
				begin
					ns               =4'b0000;
					core_wait        =1'b0;
					index            =6'd0;
					TA_in            =22'd0;
					D_type           =3'b000;
					D_addr           =32'd0
					valid_read       =1'b0;
					single_vaild_data=1'd0;
				end
				core_out=32'd0;
				D_req   =1'b0;
				//D_addr  =32'd0;
				D_in    =32'd0;
				DA_in   =128'd0;
				DA_write=1'b0;
				TA_write=1'b0;
				valid_write=1'b0;
				


			end
			/*
			4'b0001:
			begin
				ns               =4'b0010;
				
				valid_read       =1'b0;
				core_out         =32'd0;
				core_wait        =1'b1;
				
				D_req            =1'b0;
				D_addr           =D_addr_register_out;
				D_in             =32'd0;
				D_type           =D_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b1;
				DA_in            =128'd0;
	
				TA_read          =1'b1;
				TA_in            =TA_in_register_out;
				
				single_vaild_data=single_vaild_data_register_out;
				offset           =offset_register_out;
			end
			*/
			4'b0010:
			begin
				if((TA_out==TA_in )&&(single_vaild_data))
				begin
					ns           =4'b1001;
					D_req        =1'b0;
					case(offset):
					begin
						4'd0:
						begin
							core_out         =D_out[127:96];
						4'd1:
						begin
							core_out         =D_out[95:64];
						end
						4'd2:
						begin
							core_out         =D_out[63:32];
						end
						4'd3:
						begin
							core_out         =D_out[31:0];
						end
						default:
						begin
							core_out         =32'd0;
						end						
					end

				end
				else
				begin
					ns           =4'b0011;
					D_req        =1'b1;
					core_out     =32'd0;
				end
				
				valid_read       =1'b0;
				
				core_wait        =1'b1;

				
				D_addr           =D_addr_register_out;
				D_in             =32'd0;
				D_type           =D_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b1;
				DA_in            =128'd0;
	
				TA_read          =1'b1;
				TA_in            =TA_in_register_out;
				
				single_vaild_data=single_vaild_data_register_out;
				offset           =offset_register_out;
				DA_write=1'b0;
				TA_write=1'b0;
				valid_write=1'b0;
			end
			4'b0011:
			begin
				if(D_wait)
				begin
					ns               =4'b0011;
				end
				else
				begin
					ns               =4'b0100;
				end
				valid_read       =1'b0;
				core_out         =(offset==4'd0)?D_in:32'd0;
				core_wait        =1'b1;
				
				D_req            =1'b1;
				D_addr           =D_addr_register_out;
				D_in             =32'd0;
				D_type           =D_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b0;
				DA_in            ={96'd0,D_out};
	
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				
				single_vaild_data=single_vaild_data_register_out;
				offset           =offset_register_out;
				
				DA_write=1'b0;
				TA_write=1'b0;
				valid_write=1'b0;				
			end
			4'b0100:
			begin
				if(D_wait)
				begin
					ns               =4'b0100;
				end
				else
				begin
					ns               =4'b0101;
				end
				valid_read       =1'b0;
				core_out         =(offset==4'd4)?D_in:32'd0;
				core_wait        =1'b1;
				
				D_req            =1'b1;
				D_addr           =D_addr_register_out;
				D_in             =32'd0;
				D_type           =D_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b0;
				DA_in            ={64'd0,D_out,DA_in_register_out[31:0]};
	
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				
				single_vaild_data=single_vaild_data_register_out;
				offset           =offset_register_out;
				
				DA_write=1'b0;
				TA_write=1'b0;
				valid_write=1'b0;					
			end
			4'b0101:
			begin
				if(D_wait)
				begin
					ns               =4'b0101;
				end
				else
				begin
					ns               =4'b0110;
				end
				valid_read       =1'b0;
				core_out         =(offset==4'd8)?D_in:32'd0;
				core_wait        =1'b1;
				
				D_req            =1'b1;
				D_addr           =D_addr_register_out;
				D_in             =32'd0;
				D_type           =D_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b0;
				DA_in            ={32'd0,D_out,DA_in_register_out[63:0]};
	
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				
				single_vaild_data=single_vaild_data_register_out;
				offset           =offset_register_out;
				
				DA_write=1'b0;
				TA_write=1'b0;
				valid_write=1'b0;			
			end
			4'b0110:
			begin
				if(D_wait)
				begin
					ns               =4'b0110;
				end
				else
				begin
					ns               =4'b0111;
				end
				valid_read       =1'b0;
				core_out         =(offset==4'd12)?D_in:32'd0;
				core_wait        =1'b1;
				
				D_req            =1'b1;
				D_addr           =D_addr_register_out;
				D_in             =32'd0;
				D_type           =D_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b0;
				DA_in            ={D_out,DA_in_register_out[95:0]};
	
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				
				single_vaild_data=single_vaild_data_register_out;
				offset           =offset_register_out;
				
				DA_write=1'b0;
				TA_write=1'b0;
				valid_write=1'b0;		
			end
			4'b0111:
			begin
				if(D_wait)

				ns               =4'b1001;

				valid_read       =1'b0;
				core_out         =(offset==4'd12)?D_in:32'd0;
				core_wait        =1'b1;
				
				D_req            =1'b0;
				D_addr           =D_addr_register_out;
				D_in             =32'd0;
				D_type           =D_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b0;
				DA_in            =DA_in_register_out;
	
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				
				single_vaild_data=single_vaild_data_register_out;
				offset           =offset_register_out;
				
				DA_write=1'b1;
				TA_write=1'b1;
				valid_write=1'b1;		
			end
			/*
			4'b1000:
			begin
			end
			*/
			4'b1001:
			begin
				ns               =4'b0010;
				
				valid_read       =1'b0;
				core_out         =32'd0;
				core_wait        =1'b0;
				
				D_req            =1'b0;
				D_addr           =D_addr_register_out;
				D_in             =32'd0;
				D_type           =D_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b0;
				DA_in            =128'd0;
	
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				
				single_vaild_data=single_vaild_data_register_out;
				offset           =offset_register_out;
				DA_write=1'b0;
				TA_write=1'b0;
				valid_write=1'b0;		
			end
			default:
			begin
				ns               =4'b0000;
				
				valid_read       =1'b0;
				core_out         =32'd0;
				core_wait        =1'b0;
				
				D_req            =1'b0;
				D_addr           =32'd0;
				D_in             =32'd0;
				D_type           =4'd0;
				
				index            =6'd0;
				DA_read          =1'b0;
				DA_in            =128'd0;
	
				TA_read          =1'b0;
				TA_in            =22'd0;
				
				single_vaild_data=1'b0;
				offset           =4'd0;
				DA_write=1'b0;
				TA_write=1'b0;
				valid_write=1'b0;		
			end
		endcase
		
  end

endmodule




