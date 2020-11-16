`include "../include/def.svh"
`timescale 1ns/10ps
module cache_write(
					clk,
					rst,
					core_addr,
					core_req,
					core_write,
					core_in,
					core_type,//4
					D_wait,
					TA_out,
					//DA_out;
					valid_data_from_register,

					core_wait,

					  // CPU wrapper to Mem
					D_req,
					D_addr,
					D_write,
					D_in,
					D_type,


					index,
					TA_in,
					TA_write,
					TA_read,

					DA_in,
					DA_write,
					DA_read,

					valid_read,
					//valid_write
);
  localparam STATE_START            =3'b000;
  localparam STATE_WRITE_MEM        =3'b001;
  localparam STATE_READ_CACHE_ARRAY =3'b010;
  localparam STATE_CHECK_HIT        =3'b011;
  localparam STATE_WRITE_CACHE      =3'b100;
  localparam STATE_WAIT             =3'b101;
  input                                 clk;
  input                                 rst;

  // Core to CPU wrapper
  input        [       `DATA_BITS-1:0] core_addr;
  input                                core_req;
  input                                core_write;
  input        [       `DATA_BITS-1:0] core_in;
  input        [ `CACHE_TYPE_BITS-1:0] core_type;//4
  // Mem to CPU wrapper
  input                                D_wait;
  input        [                 21:0] TA_out;
  //input        [                127:0] DA_out;
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
  output logic                         valid_read;

  logic        [                  2:0] cs;
  logic        [                  2:0] ns;
  
 
  logic                                single_valid_data;
  logic        [                  3:0] offset;
  logic        [                  5:0] index_register_out;
  logic        [                 21:0] TA_in_register_out;
  logic        [                  3:0] offset_register_out;
  logic                                single_valid_data_register_out;
  logic        [                  2:0] D_type_register_out;
  logic        [                 31:0] D_addr_register_out;
  logic        [                 31:0] D_in_register_out;
  
  
always_ff@(posedge clk or negedge rst)
begin
	if(rst)
	begin
		cs<=STATE_START;
	end
	else
	begin
		cs<=ns;
	end
end
always_ff@(posedge clk or negedge rst)
begin
	if(rst)
	begin
		TA_in_register_out<=22'd0;
		D_type_register_out<=3'b000;
		D_addr_register_out<=32'd0;
		index_register_out<=6'd0;
		offset_register_out<=4'd0;
		single_valid_data_register_out<=1'b0;
		D_in_register_out<=32'd0;
	end
	else
	begin
		TA_in_register_out<=TA_in;
		D_type_register_out<=D_type;
		D_addr_register_out<=D_addr;
		index_register_out<=index;
		offset_register_out<=offset;
		single_valid_data_register_out<=single_valid_data;
		D_in_register_out<=D_in;
	end
end
/*
 core_wait;

  // CPU wrapper to Mem
D_req;
D_addr;
D_write;
D_in;
D_type;
index; 
TA_in;
TA_write;
TA_read;
DA_in;
DA_write;
valid_read;
cs;
ns;
  
address_tag;
address_index;
address_offset;
single_valid_data;
address_tag_register_out;
address_index_register_out;
address_offset_register_out;
single_valid_data_register_out;
TA_in_register_out;
  */
always_comb
begin
	case(cs)
		STATE_START:
		begin
			if(core_req&&core_write)
			begin
				ns       =STATE_WRITE_MEM;
				core_wait=1'b1;
				D_type   =core_type;
				D_req    =1'b1;
				D_addr   =core_addr;
				D_in     =core_in;
				D_write  =1'b1;
				index    =core_addr[  9:4];
				TA_in    =core_addr[31:10];
				offset   =core_addr[  3:0];
				
				//D_in     =core_in;
			end
			else
			begin
				ns       =STATE_START;
				core_wait=1'b0;
				D_type   =core_type;
				D_in     =32'd0;
				D_req    =1'b0;
				D_addr   =32'd0;
				D_write  =1'b0;
				index    =6'd0;
				TA_in    =22'd0;
				offset   =4'd0;
			end
			
			TA_write     =1'b0;
			TA_read      =1'b0;
			DA_in        =128'd0;
			DA_write     =16'hffff;
			DA_read      =1'b0;
			valid_read   =1'b0;
			single_valid_data =1'b0;
		end
		STATE_WRITE_MEM:
		begin
			if(D_wait)
			begin
				ns=STATE_WRITE_MEM;
				D_req    =1'b1;
				D_write      =1'b1;
			end
			else
			begin
				ns=STATE_READ_CACHE_ARRAY;
				D_req    =1'b0;
				D_write      =1'b0;
			end
			core_wait    =1'b1;
			D_type       =D_type_register_out;
			D_addr       =D_addr_register_out;
			D_in         =D_in_register_out;
			index        =index_register_out;
			TA_in        =TA_in_register_out;
			offset       =offset_register_out;
			TA_write     =1'b0;
			TA_read      =1'b0;
			DA_in        =128'd0;
			DA_write     =16'hffff;
			DA_read      =1'b0;
			valid_read   =1'b0;
			single_valid_data =1'b0;
		end
		STATE_READ_CACHE_ARRAY:
		begin
			ns                =STATE_CHECK_HIT;
			D_req             =1'b0;
			D_write           =1'b0;
			core_wait         =1'b1;
			D_type            =D_type_register_out;
			D_addr            =D_addr_register_out;
			D_in              =D_in_register_out;
			index             =index_register_out;
			TA_in             =TA_in_register_out;
			offset            =offset_register_out;
			TA_write          =1'b0;
			TA_read           =1'b1;
			DA_in             =128'd0;
			DA_write          =16'hffff;
			DA_read           =1'b1;
			valid_read        =1'b1;
			single_valid_data =valid_data_from_register;
		end
		STATE_CHECK_HIT:
		begin
			if(single_valid_data&&(TA_out==TA_in))
			begin
				ns=STATE_WRITE_CACHE;
			end
			else
			begin
				ns=STATE_START;
			end
			D_req             =1'b0;
			D_write           =1'b0;
			core_wait         =1'b1;
			D_type            =D_type_register_out;
			D_addr            =D_addr_register_out;
			D_in              =D_in_register_out;
			index             =index_register_out;
			TA_in             =TA_in_register_out;
			offset            =offset_register_out;
			TA_write          =1'b0;
			TA_read           =1'b1;
			DA_in             =128'd0;
			DA_write          =16'hffff;
			DA_read           =1'b1;
			valid_read        =1'b1;			
			single_valid_data =valid_data_from_register;
		end
		STATE_WRITE_CACHE:
		begin
			ns=STATE_START;
			D_req             =1'b0;
			D_write           =1'b0;
			core_wait         =1'b0;
			D_type            =D_type_register_out;
			D_addr            =D_addr_register_out;
			D_in              =D_in_register_out;
			index             =index_register_out;
			TA_in             =TA_in_register_out;
			offset            =offset_register_out;
			TA_write          =1'b1;
			TA_read           =1'b0;
			//DA_in             =128'd0;
			//DA_write          =1'b1;
			DA_read           =1'b0;
			valid_read        =1'b0;			
			single_valid_data =valid_data_from_register;
			case(offset)
				4'd0:
				begin
					case(D_type)
						`CACHE_BYTE:
						begin
							DA_write          ={4'b1110,12'hfff};
							DA_in             ={24'd0,D_in[7:0],96'd0};
						end
						`CACHE_HWORD:
						begin
							DA_write          ={4'b1100,12'hfff};
							DA_in             ={16'd0,D_in[15:0],96'd0};
						end
						`CACHE_WORD:
						begin
							DA_write          ={4'b0000,12'hfff};
							DA_in             ={D_in,96'd0};
						end
						`CACHE_BYTE_U:
						begin
							DA_write          ={4'b0111,12'hfff};
							DA_in             ={D_in[7:0],24'd0,96'd0};
						end
						`CACHE_HWORD_U:
						begin
							DA_write          ={4'b0011,12'hfff};
							DA_in             ={D_in[15:0],16'd0,96'd0};
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
					case(D_type)
						`CACHE_BYTE:
						begin
							DA_write          ={4'hf,4'b1110,8'hff};
							DA_in             ={32'd0,24'd0,D_in[7:0],64'd0};
						end
						`CACHE_HWORD:
						begin
							DA_write          ={4'hf,4'b1100,8'hff};
							DA_in             ={32'd0,16'd0,D_in[15:0],64'd0};
						end
						`CACHE_WORD:
						begin
							DA_write          ={4'hf,4'b0000,8'hff};
							DA_in             ={32'd0,D_in,64'd0};
						end
						`CACHE_BYTE_U:
						begin
							DA_write          ={4'hf,4'b0111,8'hff};
							DA_in             ={32'd0,D_in[7:0],24'd0,64'd0};
						end
						`CACHE_HWORD_U:
						begin
							DA_write          ={4'hf,4'b0011,8'hff};
							DA_in             ={64'd0,D_in[15:0],16'd0,64'd0};
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
					case(D_type)
						`CACHE_BYTE:
						begin
							DA_write          ={8'hff,4'b1110,4'hf};
							DA_in             ={64'd0,24'd0,D_in[7:0],32'd0};
						end
						`CACHE_HWORD:
						begin
							DA_write          ={8'hff,4'b1100,4'hf};
							DA_in             ={64'd0,16'd0,D_in[15:0],32'd0};
						end
						`CACHE_WORD:
						begin
							DA_write          ={8'hff,4'b0000,4'hf};
							DA_in             ={64'd0,D_in,32'd0};
						end
						`CACHE_BYTE_U:
						begin
							DA_write          ={8'hff,4'b0111,4'hf};
							DA_in             ={64'd0,D_in[7:0],24'd0,32'd0};
						end
						`CACHE_HWORD_U:
						begin
							DA_write          ={8'hff,4'b0011,4'hf};
							DA_in             ={64'd0,D_in[15:0],16'd0,32'd0};
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
					case(D_type)
						`CACHE_BYTE:
						begin
							DA_write          ={12'hfff,4'b1110};
							DA_in             ={96'd0,24'd0,DA_in[7:0]};
						end
						`CACHE_HWORD:
						begin
							DA_write          ={12'hfff,4'b1100};
							DA_in             ={96'd0,16'd0,D_in[15:0]};
						end
						`CACHE_WORD:
						begin
							DA_write          ={12'hfff,4'b0000};
							DA_in             ={96'd0,D_in};
						end
						`CACHE_BYTE_U:
						begin
							DA_write          ={12'hfff,4'b0111};
							DA_in             ={96'd0,D_in[7:0],24'd0};
						end
						`CACHE_HWORD_U:
						begin
							DA_write          ={12'hfff,4'b0011};
							DA_in             ={96'd0,D_in[15:0],16'd0};
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
		default:
		begin
			DA_write          =16'hffff;
			DA_in             =128'd0;
			ns                =STATE_START;
			D_req             =1'b0;
			D_write           =1'b0;
			core_wait         =1'b0;
			D_type            =3'b000;
			D_addr            =32'd0;
			D_in              =128'd0;
			index             =6'd0;
			TA_in             =22'd0;
			offset            =6'd0;
			TA_write          =1'b0;
			TA_read           =1'b0;
			DA_read           =1'b0;
			//DA_in             =128'd0;
			//DA_write          =1'b1;
			valid_read        =1'b0;			
			single_valid_data =1'b0;
		end
	endcase
end




endmodule
/*

			
			
			
			
			
*/
/*
case(offset)
				4'd0:
				begin
					case(D_type)
						`CACHE_BYTE:
						begin
							DA_write          ={12'hfff,4'b1110};
							DA_in             ={96'd0,24'd0,DA_in[7:0]};
						end
						`CACHE_HWORD:
						begin
							DA_write          ={12'hfff,4'b1100};
							DA_in             ={96'd0,16'd0,D_in[15:0]};
						end
						`CACHE_WORD:
						begin
							DA_write          ={12'hfff,4'b0000};
							DA_in             ={96'd0,D_in};
						end
						`CACHE_BYTE_U:
						begin
							DA_write          ={12'hfff,4'b0111};
							DA_in             ={96'd0,D_in[7:0],24'd0};
						end
						`CACHE_HWORD_U:
						begin
							DA_write          ={12'hfff,4'b0011};
							DA_in             ={96'd0,D_in[15:0],16'd0};
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
					case(D_type)
						`CACHE_BYTE:
						begin
							DA_write          ={8'hff,4'b1110,4'hf};
							DA_in             ={64'd0,24'd0,D_in[7:0],32'd0};
						end
						`CACHE_HWORD:
						begin
							DA_write          ={8'hff,4'b1100,4'hf};
							DA_in             ={64'd0,16'd0,D_in[15:0],32'd0};
						end
						`CACHE_WORD:
						begin
							DA_write          ={8'hff,4'b0000,4'hf};
							DA_in             ={64'd0,D_in,32'd0};
						end
						`CACHE_BYTE_U:
						begin
							DA_write          ={8'hff,4'b0111,4'hf};
							DA_in             ={64'd0,D_in[7:0],24'd0,32'd0};
						end
						`CACHE_HWORD_U:
						begin
							DA_write          ={8'hff,4'b0011,4'hf};
							DA_in             ={64'd0,D_in[15:0],16'd0,32'd0};
						end
						default
						begin
							DA_write          =16'h1111;
							DA_in             =128'd0;
						end
					endcase
				end
				4'd8:
				begin
					case(D_type)
						`CACHE_BYTE:
						begin
							DA_write          ={4'hf,4'b1110,8'hff};
							DA_in             ={32'd0,24'd0,D_in[7:0],64'd0};
						end
						`CACHE_HWORD:
						begin
							DA_write          ={4'hf,4'b1100,8'hff};
							DA_in             ={32'd0,16'd0,D_in[15:0],64'd0};
						end
						`CACHE_WORD:
						begin
							DA_write          ={4'hf,4'b0000,8'hff};
							DA_in             ={32'd0,D_in,64'd0};
						end
						`CACHE_BYTE_U:
						begin
							DA_write          ={4'hf,4'b0111,8'hff};
							DA_in             ={32'd0,D_in[7:0],24'd0,64'd0};
						end
						`CACHE_HWORD_U:
						begin
							DA_write          ={4'hf,4'b0011,8'hff};
							DA_in             ={64'd0,D_in[15:0],16'd0,64'd0};
						end
						default
						begin
							DA_write          =16'h1111;
							DA_in             =128'd0;
						end
					endcase
				end
				4'd12:
				begin
					case(D_type)
						`CACHE_BYTE:
						begin
							DA_write          ={4'b1110,12'hfff};
							DA_in             ={24'd0,DA_in[7:0],96'd0};
						end
						`CACHE_HWORD:
						begin
							DA_write          ={4'b1100,12'hfff};
							DA_in             ={16'd0,D_in[15:0],96'd0};
						end
						`CACHE_WORD:
						begin
							DA_write          ={4'b0000,12'hfff};
							DA_in             ={D_in,96'd0};
						end
						`CACHE_BYTE_U:
						begin
							DA_write          ={4'b0111,12'hfff};
							DA_in             ={D_in[7:0],24'd0,96'd0};
						end
						`CACHE_HWORD_U:
						begin
							DA_write          ={4'b0011,12'hfff};
							DA_in             ={D_in[15:0],16'd0,96'd0};
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
					DA_write          =16'h1111;
					DA_in             =128'd0;
				end
			endcase
*/

