`timescale 1ns/10ps
`include "../include/AXI_define.svh"

module master_read(
	clk,
	rst,
	cpu_read_signal,
	address,
	
	read_data,
	read_pause_cpu,

	
	
	//READ ADDRESS0
	ARID_M,
	ARADDR_M,
	ARLEN_M,     
	ARSIZE_M,
	ARBURST_M,
	ARVALID_M,
	//READ DATA0	
	RREADY_M,
	
	
	//READ ADDRESS0
	ARREADY_M,
	//READ DATA0
	RID_M,//unuse
	RDATA_M,
	RRESP_M,
	RLAST_M,
	RVALID_M

);
	//system
	localparam STATE_IDLE        =2'b00;
	localparam STATE_SEND_ADDRESS=2'b01;
	localparam STATE_GET_DATA    =2'b10;
	input                             clk;
	input                             rst;	
	input                             cpu_read_signal;
    input        [              31:0] address; 	

	
	
	logic        [               1:0] dmcs;
	logic        [               1:0] dmns;
	logic        [               1:0] imcs;
	logic        [               1:0] imns;
	

	input                             ARREADY_M;
	//READ DATA0
	input        [  `AXI_ID_BITS-1:0] RID_M;
	input        [`AXI_DATA_BITS-1:0] RDATA_M;
	input        [               1:0] RRESP_M;
	input                             RLAST_M;
	input                             RVALID_M;
	
	
	
	//READ ADDRESS0
	output logic [  `AXI_ID_BITS-1:0] ARID_M;
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M;
	output logic [ `AXI_LEN_BITS-1:0] ARLEN_M;//1
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M;//2
	output logic [               1:0] ARBURST_M;//0
	output logic                      ARVALID_M;
	//READ DATA0
	output logic                      RREADY_M;
	//system
	output logic [              31:0] read_data;      
	output logic                      read_pause_cpu;
	
	logic        [               1:0] cs;
	logic        [               1:0] ns;
	logic        [              31:0] read_data_register_out;
	logic        [              31:0] ARADDR_M_register_out;
	logic                             ARREADY_M_register_out;
	logic                             RLAST_M_register_out;
	always_ff@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			cs<=STATE_IDLE;
		end
		else
		begin
			cs<=ns;
		end
	end
	always_ff@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			read_data_register_out <=32'd0;
			ARADDR_M_register_out  <=32'd0;
			ARREADY_M_register_out <=1'b0;
			RLAST_M_register_out   <=1'b0;
		end
		else
		begin
			read_data_register_out <=read_data;
			ARADDR_M_register_out  <=ARADDR_M;
			ARREADY_M_register_out <=ARREADY_M;
			RLAST_M_register_out   <=RLAST_M;
		end
	end
	always_comb
	begin
		case(cs)
			STATE_IDLE:
			begin
				if(cpu_read_signal)
				begin
					ns             =STATE_SEND_ADDRESS;
					read_pause_cpu =1'b1;
					ARADDR_M       =address;
				end
				else
				begin
					ns             =STATE_IDLE;
					read_pause_cpu =1'b0;
					ARADDR_M       =32'd0;
				end
				ARID_M             =4'b0010;
				//mofify
				//ARADDR_M =32'd0;
				ARVALID_M          =1'b0;
				RREADY_M           =1'b0;
				read_data          =read_data_register_out;
			end

			STATE_SEND_ADDRESS:
			begin
				if(ARREADY_M_register_out==1'b1)
				begin
					ns=STATE_GET_DATA;
				end
				else
				begin
					ns=STATE_SEND_ADDRESS;
					
				end
				ARVALID_M      =1'b1;
				ARID_M         =4'b0001;
				ARADDR_M       =ARADDR_M_register_out;
				RREADY_M       =1'b0;
				read_pause_cpu =1'b1;
				read_data      =32'd0;
			end
			STATE_GET_DATA:
			begin
				ns             =RVALID_M?STATE_IDLE:STATE_GET_DATA;
				RREADY_M       =1'b1;
				ARID_M         =4'b0001;
				ARADDR_M       =ARADDR_M_register_out;
				ARVALID_M      =1'b1;
				RREADY_M       =1'b1;
				read_pause_cpu =1'b1;
				read_data      =(RRESP_M==2'b00 && RVALID_M==1'b1)?RDATA_M:32'd0;
			end
			default:
			begin
				ARID_M         =4'b0010;
				ARADDR_M       =32'd0;
				ARVALID_M      =1'b0;
				RREADY_M       =1'b0;
				read_pause_cpu =1'b0;
				read_data      =32'd0;
				ns             =STATE_IDLE;
			end
		endcase
	end
	
	always_comb
	begin
		ARLEN_M               =4'd0;
		ARSIZE_M              =3'd2;
		ARBURST_M             =2'd1;
	end
	
endmodule
