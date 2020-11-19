//================================================
// Auther:      Chen Yun-Ru (May)
// Filename:    L1C_inst.sv
// Description: L1 Cache for instruction
// Version:     0.1
//================================================
`include "../include/def.svh"
`include "cache_write_read_arbitor_rtl.sv"
`include "cache_read_rtl.sv"
`include "cache_write_rtl.sv"
`include "valid_register_rtl.sv"
`include "data_array_wrapper.sv"
`include "tag_array_wrapper.sv"
`timescale 1ns/10ps
module L1C_inst(
  input                               clk,
  input                               rst,
  // Core to CPU wrapper
  input        [      `DATA_BITS-1:0] core_addr,
  input                               core_req,
  input                               core_write,
  input        [      `DATA_BITS-1:0] core_in,
  input        [`CACHE_TYPE_BITS-1:0] core_type,
  // Mem to CPU wrapper
  input        [      `DATA_BITS-1:0] I_out,
  input                               I_wait,
  // CPU wrapper to core
  output logic [      `DATA_BITS-1:0] core_out,
  output logic                        core_wait,
  // CPU wrapper to Mem
  output logic                        I_req,
  output logic [      `DATA_BITS-1:0] I_addr,
  output logic                        I_write,
  output logic [      `DATA_BITS-1:0] I_in,
  output logic [`CACHE_TYPE_BITS-1:0] I_type
);
  localparam STATE_IDLE             =4'b0000;
  localparam STATE_CHECK_HIT_READ   =4'b0001;
  localparam STATE_READ_MEM1        =4'b0010;
  localparam STATE_READ_MEM2        =4'b0011;
  localparam STATE_READ_MEM3        =4'b0100;
  localparam STATE_READ_MEM4        =4'b0101;
  localparam STATE_WRITE_CACHE      =4'b0110;
  localparam STATE_CHECK_HIT_WRITE  =4'b1000;
  localparam STATE_WRITE_MISS       =4'b1001;  
  localparam STATE_WRITE_HIT        =4'b1010;
  localparam STATE_SEND_READ_MEM2   =4'b0111;
  localparam STATE_SEND_READ_MEM3   =4'b1011;
  localparam STATE_SEND_READ_MEM4   =4'b1100;
  logic [`CACHE_INDEX_BITS-1:0] index;
  logic [`CACHE_DATA_BITS-1:0] DA_out;
  logic [`CACHE_DATA_BITS-1:0] DA_in;
  logic [`CACHE_WRITE_BITS-1:0] DA_write;
  logic DA_read;
  logic [`CACHE_TAG_BITS-1:0] TA_out;
  logic [`CACHE_TAG_BITS-1:0] TA_in;
  logic TA_write;
  logic TA_read;
  //logic [`CACHE_LINES-1:0] valid;

  //--------------- complete this part by yourself -----------------//
/*
  logic        [`CACHE_INDEX_BITS-1:0] index;//6//address
  logic        [ `CACHE_DATA_BITS-1:0] DA_out;//128//output
  logic        [ `CACHE_DATA_BITS-1:0] DA_in;//128
  logic        [`CACHE_WRITE_BITS-1:0] DA_write;//16
  logic                                DA_read;
  logic        [  `CACHE_TAG_BITS-1:0] TA_out;//22
  logic        [  `CACHE_TAG_BITS-1:0] TA_in;//22
  logic                                TA_write;
  logic                                TA_read;
  */
  //logic        [     `CACHE_LINES-1:0] valid;//64

  //--------------- complete this part by yourself -----------------//
  logic                                valid_data_from_register;
  logic                                vaild_read_signal;
  logic                                valid_write;
  logic        [`CACHE_INDEX_BITS-1:0] index_register_out;
  logic        [  `CACHE_TAG_BITS-1:0] TA_in_register_out;
  logic        [                127:0] DA_in_register_out;

  logic                                single_valid_data ;
  logic                                single_valid_data_register_out;
  logic        [                  3:0] offset;
  logic        [                  3:0] offset_register_out;
  logic        [                  3:0] cs;
  logic        [                  3:0] ns;
  logic        [                 31:0] core_out_register_out;
  logic        [                 31:0] I_in_register_out;
  logic        [ `CACHE_TYPE_BITS-1:0] I_type_register_out;
  logic        [                 31:0] I_addr_register_out;

  //logic        [               2:0] read_mem_count;
  //logic        [               2:0] read_mem_count_register_out;  

  always_ff@(posedge clk or posedge rst)
  begin
	if(rst)
	begin
		cs<=STATE_IDLE;
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
		I_type_register_out<=3'b000;
		I_addr_register_out<=32'd0;
		single_valid_data_register_out<=1'b0;
		offset_register_out<=4'b0000;
		DA_in_register_out<=128'd0;
		core_out_register_out<=32'd0;
		I_in_register_out<=32'd0;
	end
	else
	begin
		//valid_register_out<=vaild;
		index_register_out<=index;
		TA_in_register_out<=TA_in;
		I_type_register_out<=I_type;
		I_addr_register_out<=I_addr;
		single_valid_data_register_out<=single_valid_data ;
		offset_register_out<=offset;
		DA_in_register_out<=DA_in;
		core_out_register_out<=core_out;
		I_in_register_out<=I_in;
	end
  end
  
always_comb
  begin
		case(cs)
			STATE_IDLE:
			begin
				if(core_req&&(!core_write))
				begin
					ns               =STATE_CHECK_HIT_READ;
					vaild_read_signal=1'b1;
					single_valid_data=valid_data_from_register;
					core_wait        =1'b1;
					
					I_addr           =core_addr;
					I_write          =1'b0;
					I_type           =core_type;
					index            =core_addr[9:4];
					DA_read          =1'b1;
					TA_read          =1'b1;
					TA_in            =core_addr[31:10];
					offset           =core_addr[3:0];
				end
				else if(core_req&&core_write)
				begin
					ns               =STATE_CHECK_HIT_WRITE;
					vaild_read_signal=1'b1;
					single_valid_data=valid_data_from_register;
					core_wait        =1'b1;
					
					I_addr           =core_addr;
					I_write          =1'b0;
					I_type           =core_type;
					
					index            =core_addr[9:4];
					DA_read          =1'b1;
					TA_read          =1'b1;
					TA_in            =core_addr[31:10];
					offset           =core_addr[3:0];
				end
				else
				begin
					ns               =STATE_IDLE;
					vaild_read_signal=1'b0;
					single_valid_data=1'd0;
					core_wait        =1'b0;
					I_addr           =32'd0;
					I_write          =1'b0;
					I_type           =3'b000;
					
					index            =6'd0;
					DA_read          =1'b0;
					TA_read          =1'b0;
					TA_in            =22'd0;
					offset           =offset_register_out;
					
				end
				valid_write=1'b0;
				core_out=32'd0;
				I_req   =1'b0;
				I_in    =32'd0;
				DA_write=16'hffff;
				DA_in   =128'd0;
				TA_write=1'b0;
				
				


			end
			STATE_CHECK_HIT_READ:
			begin
				if((TA_out==TA_in )&&(single_valid_data))
				begin
					//ns           =STATE_WAIT;
					ns             =STATE_IDLE;
					I_req        =1'b0;
					case(offset)
						4'd0:
						begin
							core_out         =DA_out[31:0];
						end
						4'd4:
						begin
							core_out         =DA_out[63:32];
						end
						4'd8:
						begin
							
							core_out         =DA_out[95:64];
						end
						4'd12:
						begin
							
							core_out         =DA_out[127:96];
						end
						default:
						begin
							core_out         =32'd0;
						end						
					endcase
				end
				else
				begin
					ns           =STATE_READ_MEM1;
					core_out     =32'd0;
					I_req        =1'b1;
				end
				valid_write      =1'b0;
				vaild_read_signal=1'b1;
				single_valid_data=single_valid_data_register_out;
				core_wait        =1'b1;
				I_write          =1'b0;
				I_addr           ={I_addr_register_out[31:2],2'b00};
				I_in             =32'd0;
				I_type           =I_type_register_out;
				index            =index_register_out;
				DA_write         =16'hffff;
				DA_read          =1'b1;
				DA_in            =128'd0;
				TA_write         =1'b0;
				TA_read          =1'b1;
				TA_in            =TA_in_register_out;
				
				
				offset           =offset_register_out;
				
				
				
				
			end
			STATE_READ_MEM1:
			begin
				if(I_wait)
				begin
					ns               =STATE_READ_MEM1;
					I_addr           =I_addr_register_out;
				end
				else
				begin
					ns               =STATE_READ_MEM2;
					I_addr           =I_addr_register_out+32'd4;
				end
				valid_write      =1'b0;
				vaild_read_signal=1'b0;
				single_valid_data=single_valid_data_register_out;

				core_out         =(offset==4'd0)?I_out:32'd0;
				core_wait        =1'b1;
				
				I_req            =1'b0;
				I_write          =1'b0;
				I_in             =32'd0;
				I_type           =I_type_register_out;
				index            =index_register_out;
				DA_write         =16'hffff;
				DA_read          =1'b0;
				DA_in            ={96'd0,I_out};
				TA_write         =1'b0;
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				offset           =offset_register_out;
			end
			STATE_SEND_READ_MEM2:
			begin
				ns               =STATE_READ_MEM2;
				I_addr           =I_addr_register_out;
				valid_write      =1'b0;
				vaild_read_signal=1'b0;
				single_valid_data =single_valid_data_register_out;
				core_out         =core_out_register_out;
				core_wait        =1'b1;
				I_req            =1'b1;
				I_write          =1'b0;
				I_in             =32'd0;
				I_type           =I_type_register_out;
				index            =index_register_out;
				DA_write         =16'hffff;
				DA_read          =1'b0;
				DA_in            ={96'd0,I_out};
				TA_write         =1'b0;
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				offset           =offset_register_out;
			end
			STATE_READ_MEM2:
			begin
				if(I_wait)
				begin
					ns               =STATE_READ_MEM2;
					I_addr           =I_addr_register_out;
				end
				else
				begin
					ns               =STATE_READ_MEM3;
					I_addr           =I_addr_register_out+32'd4;
				end
				valid_write      =1'b0;
				vaild_read_signal=1'b0;
				single_valid_data =single_valid_data_register_out;
				core_out         =(offset==4'd4)?I_out:core_out_register_out;
				core_wait        =1'b1;
				
				I_req            =1'b0;
				I_write          =1'b0;
				I_in             =32'd0;
				I_type           =I_type_register_out;
				
				index            =index_register_out;
				DA_write         =16'hffff;
				DA_read          =1'b0;
				DA_in            ={64'd0,I_out,DA_in_register_out[31:0]};
				TA_write         =1'b0;
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				offset           =offset_register_out;
			end
			STATE_SEND_READ_MEM3:
			begin
				ns               =STATE_READ_MEM3;
				I_addr           =I_addr_register_out;
				valid_write      =1'b0;
				vaild_read_signal=1'b0;
				single_valid_data =single_valid_data_register_out;
				core_out         =core_out_register_out;
				core_wait        =1'b1;
				I_req            =1'b1;
				I_write          =1'b0;
				I_in             =32'd0;
				I_type           =I_type_register_out;
				index            =index_register_out;
				DA_write         =16'hffff;
				DA_read          =1'b0;
				DA_in            ={96'd0,I_out};
				TA_write         =1'b0;
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				offset           =offset_register_out;
			end
			STATE_READ_MEM3:
			begin
				if(I_wait)
				begin
					ns               =STATE_READ_MEM3;
					I_addr           =I_addr_register_out;
				end
				else
				begin
					ns               =STATE_READ_MEM4;
					I_addr           =I_addr_register_out+32'd4;
				end
				valid_write      =1'b0;
				vaild_read_signal=1'b0;
				single_valid_data =single_valid_data_register_out;
				core_out         =(offset==4'd8)?I_out:core_out_register_out;
				core_wait        =1'b1;
				I_req            =1'b0;
				I_write          =1'b0;
				I_in             =32'd0;
				I_type           =I_type_register_out;
				
				index            =index_register_out;
				DA_write         =16'hffff;
				DA_read          =1'b0;
				DA_in            ={32'd0,I_out,DA_in_register_out[63:0]};
				TA_write         =1'b0;
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;

				offset           =offset_register_out;				
			end
			STATE_SEND_READ_MEM4:
			begin
				ns               =STATE_READ_MEM4;
				I_addr           =I_addr_register_out;
				valid_write      =1'b0;
				vaild_read_signal=1'b0;
				single_valid_data =single_valid_data_register_out;
				core_out         =core_out_register_out;
				core_wait        =1'b1;
				I_req            =1'b1;
				I_write          =1'b0;
				I_in             =32'd0;
				I_type           =I_type_register_out;
				index            =index_register_out;
				DA_write         =16'hffff;
				DA_read          =1'b0;
				DA_in            ={96'd0,I_out};
				TA_write         =1'b0;
				TA_read          =1'b0;
				TA_in            =TA_in_register_out;
				offset           =offset_register_out;
			end
			STATE_READ_MEM4:
			begin
				if(I_wait)
				begin
					ns               =STATE_READ_MEM4;
					I_addr           =I_addr_register_out;
				end
				else
				begin
					ns               =STATE_WRITE_CACHE;
					I_addr           =32'd0;
				end
				valid_write      =1'b0;
				single_valid_data=single_valid_data_register_out;
				core_out         =(offset==4'd12)?I_out:core_out_register_out;
				core_wait        =1'b1;
				I_write          =1'b0;
				I_req            =1'b0;
				I_in             =32'd0;
				I_type           =I_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b0;
				DA_write=16'hffff;
				DA_in            ={I_out,DA_in_register_out[95:0]};
				TA_read          =1'b0;
				TA_write         =1'b0;
				TA_in            =TA_in_register_out;				

				
				single_valid_data=single_valid_data_register_out;
				offset           =offset_register_out;
				
				

				valid_write=1'b0;		
			end
			STATE_WRITE_CACHE:
			begin
				//ns=STATE_WAIT;
				ns=STATE_IDLE;

				valid_write      =1'b1;
				vaild_read_signal=1'b0;
				single_valid_data=single_valid_data_register_out;				
				core_out         =core_out_register_out;
				core_wait        =1'b1;
				I_req            =1'b0;
				I_write          =1'b0;
				I_addr           =I_addr_register_out;
				I_in             =32'd0;
				I_type           =I_type_register_out;
				
				index            =index_register_out;
				DA_read          =1'b0;
				DA_write         =16'h0000;
				DA_in            =DA_in_register_out;
				TA_read          =1'b0;
				TA_write         =1'b1;
				TA_in            =TA_in_register_out;
				offset           =offset_register_out;
			end
			STATE_CHECK_HIT_WRITE:
			begin
				if(single_valid_data&&(TA_out==TA_in))
				begin
					ns=STATE_WRITE_HIT;
					I_req        =1'b1;
					I_write      =1'b1;
				end
				else
				begin
					ns=STATE_WRITE_MISS;
					I_req        =1'b0;
					I_write      =1'b0;
				end
				valid_write       =1'b0;
				vaild_read_signal =1'b1;
				single_valid_data =valid_data_from_register;
				core_out          =32'd0;
				core_wait         =1'b1;
				I_addr            =core_addr;
				I_in              =core_in;
				I_type            =core_type;

				index        =index_register_out;
				
				offset       =offset_register_out;
				/*
				index    =core_addr[  9:4];
				TA_in    =core_addr[31:10];
				offset   =core_addr[  3:0];
				*/
				TA_write          =1'b0;
				TA_read           =1'b1;
				TA_in             =TA_in_register_out;
				DA_write          =16'hffff;
				DA_read           =1'b1;
				DA_in             =128'd0;
			end
			STATE_WRITE_HIT:
			begin
			if(I_wait)
				begin
					ns           =STATE_WRITE_MISS;

				end
				else
				begin
					ns=STATE_IDLE;

				end
				core_wait         =1'b1;
				core_out          =32'd0;
				valid_write       =1'b0;
				vaild_read_signal =1'b0;
				single_valid_data =single_valid_data_register_out;	
				I_type            =core_type;
				I_addr            =core_addr;
				I_in              =core_in;
				I_req        =1'b0;
				I_write      =1'b0;
				index             =index_register_out;
				DA_read           =1'b0;
				TA_in             =TA_in_register_out;
				TA_write          =1'b0;
				TA_read           =1'b0;
				offset            =offset_register_out;
				case(offset)
					4'd0:
					begin
						case(I_type)
							`CACHE_BYTE:
							begin
								DA_write          =I_addr[0]?{12'hfff,4'b1101}:{12'hfff,4'b1110};
								DA_in             =I_addr[0]?{96'd0,16'd0,I_in[7:0],8'd0}:{96'd0,24'd0,I_in[7:0]};
							end
							`CACHE_HWORD:
							begin
								DA_write          ={12'hfff,4'b1100};
								DA_in             ={96'd0,16'd0,I_in[15:0]};
							end
							`CACHE_WORD:
							begin
								DA_write          ={12'hfff,4'b0000};
								DA_in             ={96'd0,I_in};
							end
							`CACHE_BYTE_U:
							begin
								DA_write          =I_addr[0]?{12'hfff,4'b0111}:{12'hfff,4'b1011};
								DA_in             =I_addr[0]?{96'd0,I_in[7:0],24'd0}:{96'd0,8'd0,I_in[7:0],16'd0};
							end
							`CACHE_HWORD_U:
							begin
								DA_write          ={12'hfff,4'b0011};
								DA_in             ={96'd0,I_in[15:0],16'd0};
							end
							default
							begin
								DA_write          =16'hffff;
								DA_in             =128'd0;
							end
						endcase
						
					end
					4'd4:
					begin
						case(I_type)
							`CACHE_BYTE:
							begin
								DA_write          =I_addr[0]?{8'hff,4'b1101,4'hf}:{8'hff,4'b1110,4'hf};
								DA_in             =I_addr[0]?{64'd0,16'd0,I_in[7:0],8'd0,32'd0}:{64'd0,24'd0,I_in[7:0],32'd0};
							end
							`CACHE_HWORD:
							begin
								DA_write          ={8'hff,4'b1100,4'hf};
								DA_in             ={64'd0,16'd0,I_in[15:0],32'd0};
							end
							`CACHE_WORD:
							begin
								DA_write          ={8'hff,4'b0000,4'hf};
								DA_in             ={64'd0,I_in,32'd0};
							end
							`CACHE_BYTE_U:
							begin
								DA_write          =I_addr[0]?{8'hff,4'b0111,4'hf}:{8'hff,4'b1011,4'hf};
								DA_in             =I_addr[0]?{64'd0,I_in[7:0],24'd0,32'd0}:{64'd0,8'd0,I_in[7:0],16'd0,32'd0};
							end
							`CACHE_HWORD_U:
							begin
								DA_write          ={8'hff,4'b0011,4'hf};
								DA_in             ={64'd0,I_in[15:0],16'd0,32'd0};
							end
							default
							begin
								DA_write          =16'hffff;
								DA_in             =128'd0;
							end
						endcase
						
					end
					4'd8:
					begin
						case(I_type)
							`CACHE_BYTE:
							begin
								DA_write          =I_addr[0]?{4'hf,4'b1101,8'hff}:{4'hf,4'b1110,8'hff};
								DA_in             =I_addr[0]?{32'd0,16'd0,I_in[7:0],8'd0,64'd0}:{32'd0,24'd0,I_in[7:0],64'd0};
							end
							`CACHE_HWORD:
							begin
								DA_write          ={4'hf,4'b1100,8'hff};
								DA_in             ={32'd0,16'd0,I_in[15:0],64'd0};
							end
							`CACHE_WORD:
							begin
								DA_write          ={4'hf,4'b0000,8'hff};
								DA_in             ={32'd0,I_in,64'd0};
							end
							`CACHE_BYTE_U:
							begin
								DA_write          =I_addr[0]?{4'hf,4'b0111,8'hff}:{4'hf,4'b1011,8'hff};
								DA_in             =I_addr[0]?{32'd0,I_in[7:0],24'd0,64'd0}:{32'd0,8'd0,I_in[7:0],16'd0,64'd0};
							end
							`CACHE_HWORD_U:
							begin
								DA_write          ={4'hf,4'b0011,8'hff};
								DA_in             ={32'd0,I_in[15:0],16'd0,64'd0};
							end
							default
							begin
								DA_write          =16'hffff;
								DA_in             =128'd0;
							end
						endcase
					end
					4'd12:
					begin
						case(I_type)
							`CACHE_BYTE://000
							begin
								DA_write          =I_addr[0]?{4'b1101,12'hfff}:{4'b1110,12'hfff};
								DA_in             =I_addr[0]?{16'd0,I_in[7:0],8'd0,96'd0}:{24'd0,I_in[7:0],96'd0};
							end
							`CACHE_HWORD:
							begin
								DA_write          ={4'b1100,12'hfff};
								DA_in             ={16'd0,I_in[15:0],96'd0};
							end
							`CACHE_WORD:
							begin
								DA_write          ={4'b0000,12'hfff};
								DA_in             ={I_in,96'd0};
							end
							`CACHE_BYTE_U:
							begin
								DA_write          =I_addr[0]?{4'b0111,12'hfff}:{4'b1011,12'hfff};
								DA_in             =I_addr[0]?{I_in[7:0],24'd0,96'd0}:{8'd0,I_in[7:0],16'd0,96'd0};
							end
							`CACHE_HWORD_U:
							begin
								DA_write          ={4'b0011,12'hfff};
								DA_in             ={I_in[15:0],16'd0,96'd0};
							end
							default
							begin
								DA_write          =16'hffff;
								DA_in             =128'd0;
							end
						endcase
					end
					default:
					begin
						DA_write          =16'hffff;
						DA_in             =128'd0;
					end
				endcase
			end
			STATE_WRITE_MISS:
			begin
			if(I_wait)
				begin
					ns           =STATE_WRITE_MISS;
				end
				else
				begin
					ns=STATE_IDLE;
				end
				core_wait         =1'b1;
				core_out          =32'd0;
				valid_write       =1'b0;
				vaild_read_signal =1'b0;
				single_valid_data =single_valid_data_register_out;	
				I_req             =1'b0;
				I_write           =1'b0;
				I_type            =core_type;
				I_addr            =core_addr;
				I_in              =core_in;
				index             =index_register_out;
				DA_write          =16'hffff;
				DA_read           =1'b0;
				DA_in             =128'd0;
				TA_in             =TA_in_register_out;
				TA_write          =1'b0;
				TA_read           =1'b0;
				offset            =offset_register_out;
			end
			default:
			begin
				ns               =STATE_IDLE;
				valid_write      =1'b0;
				single_valid_data=1'b0;
				single_valid_data=1'b0;
				core_out         =32'd0;
				core_wait        =1'b0;
				
				I_req            =1'b0;
				I_write          =1'b0;				
				I_addr           =32'd0;
				I_in             =32'd0;
				I_type           =3'b000;
				
				index            =6'd0;
				DA_write         =16'hffff;
				DA_read          =1'b0;
				DA_in            =128'd0;
				TA_write         =1'b0;
				TA_read          =1'b0;
				TA_in            =22'd0;
				offset           =4'd0;	
			end
			
		endcase
		
		
  end
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

