`timescale 1ns/10ps
`include "../include/AXI_define.svh"
module master_write#(
	parameter slaveid        =4'b0001,
	parameter masterid       =4'b0001,
	parameter default_slaveid =4'b0010)(
	clk,
	rst,
	cpu_write_signal,
	cpu_write_data,
	im_read_pause,
	address,
	web,
	
	cpu_write_pause,

	AWID_M,
	AWADDR_M,
	AWLEN_M,
	AWSIZE_M,
	AWBURST_M,
	AWVALID_M,
	//WRITE DATA1
	WDATA_M,
	WSTRB_M,
	WLAST_M,
	WVALID_M,
	//WRITE RESPONSE1
	BREADY_M,
	//WRITE DATA1




	WREADY_M,
	//WRITE ADDRESS1
	AWREADY_M,
	//WRITE RESPONSE1
	BID_M,
	BRESP_M,
	BVALID_M

);
//-------------SYSTEM
	input                              clk;
	input                              rst;
	input                              cpu_write_signal;
	input        [                3:0] web;
	input        [               31:0] cpu_write_data;
	input        [               31:0] address;
	input                              im_read_pause;
	
	output logic                       cpu_write_pause;






//-------------AXI WRITE PORT
	output logic [  `AXI_ID_BITS-1:0] AWID_M;
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_M;
	output logic [ `AXI_LEN_BITS-1:0] AWLEN_M;
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M;
	output logic [               1:0] AWBURST_M;
	output logic                      AWVALID_M;
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_M;
	output logic [`AXI_STRB_BITS-1:0] WSTRB_M;
	output logic                      WLAST_M;
	output logic                      WVALID_M;
	//WRITE RESPONSE1
	output logic                      BREADY_M;
	//WRITE DATA1
	
	
	
	input                             WREADY_M;
	//WRITE ADDRESS1
	input                             AWREADY_M;
	//WRITE RESPONSE1
	input        [  `AXI_ID_BITS-1:0] BID_M;
	input        [               1:0] BRESP_M;
	input                             BVALID_M;
	
	
	
	logic         [               2:0] cs;
	logic         [               2:0] ns;
	logic	      [               3:0] WSTRB_M_register_out;
	logic         [              31:0] AWADDR_M_register_out;
	logic         [              31:0] WDATA_M_register_out;
	logic         [  `AXI_ID_BITS-1:0] BID_M_register_out;
	logic         [               1:0] BRESP_M_register_out;
	logic                              BVALID_M_register_out;
	logic         [               3:0] AWID_M_register_out;
	logic                              AWREADY_M_register_out;
	logic                              WREADY_M_register_out;
	/*
	always_ff@(posedge clk or negedge rst)
	begin
		if (rst==1'b0)
		begin
			BID_M_register_out=4'd0;
			BRESP_M_register_out=2'b00;
			BVALID_M_register_out=1'b0;

		end
		else
		begin
			BID_M_register_out=BID_M;
			BRESP_M_register_out=BRESP_M;
			BVALID_M_register_out=BVALID_M;
			
		end
	end
	*/
	always_ff@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			cs<=3'b000;
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
			WSTRB_M_register_out   <=4'b1111;
			AWADDR_M_register_out  <=32'b0;
			WDATA_M_register_out   <=32'd0;
			AWID_M_register_out    <=4'b0000;
			AWREADY_M_register_out <=1'b0;
			WREADY_M_register_out  <=1'b0;
		end
		else
		begin
			WSTRB_M_register_out   <=WSTRB_M;
			AWADDR_M_register_out  <=AWADDR_M;
			WDATA_M_register_out   <=WDATA_M;
			AWID_M_register_out    <=AWID_M;
			AWREADY_M_register_out <=AWREADY_M;
			WREADY_M_register_out  <=WREADY_M;
		end
	end
	always_comb
	begin
		case(cs)
			3'b000:
			begin
				if(cpu_write_signal==1'b1)
				begin
					ns              =3'b001;
					cpu_write_pause =1'b1;
					WDATA_M         =cpu_write_data;
				end
				else
				begin
					ns              =3'b000;
					cpu_write_pause =1'b0;
					WDATA_M         =32'd0;
				end
				//WDATA_M=cpu_write_data;
				AWID_M              =default_slaveid;
				AWADDR_M            =32'd0;
				AWVALID_M           =1'b0;
				WSTRB_M             =cpu_write_signal?web:4'b1111;
				WLAST_M             =1'b0;
				WVALID_M            =1'b0;
				BREADY_M            =1'b0;
			end
			3'b001:
			begin
				if(AWREADY_M_register_out==1'b1)
				begin
					ns=3'b010;
				end
				else
				begin
					ns=3'b001;

				end
				AWID_M         =slaveid;
				AWADDR_M       =address;
				AWVALID_M      =1'b1;
				//AWVALID_M=1'b1;
					//WRITE DATA1
				WDATA_M        =WDATA_M_register_out;
				//WSTRB_M=WSTRB_M;//modify
				WSTRB_M        =WSTRB_M_register_out;
				WLAST_M        =1'b0;
				WVALID_M       =1'b0;
					//WRITE RESPONSE1
				//BREADY_M=BVALID_M?1'b1:1'b0;
				BREADY_M       =1'b0;
				cpu_write_pause=1'b1;	
			end
			3'b010:
			begin
				if(WREADY_M_register_out==1'b1)
				begin
					ns         =3'b011;
					WVALID_M   =1'b1;
				end
				else
				begin
					ns         =3'b010;
					WVALID_M   =1'b0;
				end
				
				AWID_M         =AWID_M_register_out;
				AWADDR_M       =AWADDR_M_register_out;
				
				AWVALID_M      =1'b1;
					//WRITE DATA1//modify
				WDATA_M        =WDATA_M_register_out;
				//WDATA_M=WREADY_M?WSTRB_M_register_out:32'd0;
				WSTRB_M        =WSTRB_M_register_out;
				WLAST_M        =1'b1;
					//WRITE RESPONSE1
				BREADY_M       =1'b1;
				//BREADY_M=BVALID_M?1'b1:1'b0;
				cpu_write_pause=1'b1;					
			end				
			3'b011:
			begin
				//if(BVALID_M==1'b1 && BRESP_M==2'b00 && BID_M==slaveid)
				//if(BVALID_M_register_out==1'b1 && BRESP_M_register_out==2'b00 && BID_M_register_out==masterid)
				if(BVALID_M==1'b1)
				begin
					ns=3'b100;
				end
				else
				begin
					ns=3'b011;
				end
				BREADY_M       =1'b1;
				AWID_M         =AWID_M_register_out;
				AWADDR_M       =AWADDR_M_register_out;
				
				AWVALID_M      =1'b0;
					//WRITE DATA1
				WDATA_M        =WDATA_M_register_out;
				WSTRB_M        =WSTRB_M_register_out;
				WLAST_M        =1'b0;
				WVALID_M       =1'b0;
					//WRITE RESPONSE1
				
				cpu_write_pause=1'b1;	
			end
			3'b100:
			begin
				ns              =im_read_pause?3'b100:3'b000;
				AWID_M          =AWID_M_register_out;
				AWADDR_M        =AWADDR_M_register_out;
				
				AWVALID_M       =1'b0;
					//WRITE DATA1
				WDATA_M         =WDATA_M_register_out;
				WSTRB_M         =WSTRB_M_register_out;
				WLAST_M         =1'b0;
				WVALID_M        =1'b0;
					//WRITE RESPONSE1
				BREADY_M        =1'b0;
				cpu_write_pause =(im_read_pause==1'b1)?1'b1:1'b0;					
			end
			default:
			begin
				ns             =3'b000;
				AWID_M         =4'b0000;
				AWADDR_M       =32'd0;
				
				AWVALID_M      =1'b0;
					//WRITE DATA1
				WDATA_M        =32'd0;
				WSTRB_M        =4'b0000;
				WLAST_M        =1'b0;
				WVALID_M       =1'b0;
					//WRITE RESPONSE1
				BREADY_M       =1'b0;
				cpu_write_pause=1'b0;		
			end
		endcase
	end
	always_comb
	begin
		AWLEN_M  =4'd0;
		AWSIZE_M =3'd2;
		AWBURST_M=2'd1;
	end
	
	
endmodule
