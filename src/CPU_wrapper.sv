`timescale 1ns/10ps
`include "../include/AXI_define.svh"
`include"master_read_rtl.sv"
`include"master_write_rtl.sv"
`include"CPU.sv"
module CPU_wrapper(

	clk,
	rst,
	AWID_M1,
	AWADDR_M1,
	AWLEN_M1,
	AWSIZE_M1,
	AWBURST_M1,
	AWVALID_M1,
	//WRITE DATA1
	WDATA_M1,
	WSTRB_M1,
	WLAST_M1,
	WVALID_M1,
	//WRITE RESPONSE1
	BREADY_M1,
	//WRITE DATA1



	WREADY_M1,
	//WRITE ADDRESS1
	AWREADY_M1,
	//WRITE RESPONSE1
	BID_M1,
	BRESP_M1,
	BVALID_M1,
	
	
	
	//READ ADDRESS0
	ARID_M0,
	ARADDR_M0,
	ARLEN_M0,
	ARSIZE_M0,
	ARBURST_M0,
	ARVALID_M0,
	//READ ADDRESS1
	ARID_M1,
	ARADDR_M1,
	ARLEN_M1,
	ARSIZE_M1,
	ARBURST_M1,
	ARVALID_M1,
	//READ DATA1
	RREADY_M1,
	//READ DATA0	
	RREADY_M0,
	
	
	//READ ADDRESS0
	ARREADY_M0,
	//READ ADDRESS1
	ARREADY_M1,
	//READ DATA1
	RID_M1,
	RDATA_M1,
	RRESP_M1,
	RLAST_M1,
	RVALID_M1,
	//READ DATA0
	RID_M0,
	RDATA_M0,
	RRESP_M0,
	RLAST_M0,
	RVALID_M0

				);
	//------------------------WRITE PORT AXI -----------------
	//WRITE ADDRESS1
	output logic [  `AXI_ID_BITS-1:0] AWID_M1;
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
	output logic [ `AXI_LEN_BITS-1:0] AWLEN_M1;
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
	output logic [               1:0] AWBURST_M1;
	output logic                      AWVALID_M1;
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_M1;
	output logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
	output logic                      WLAST_M1;
	output logic                      WVALID_M1;
	//WRITE RESPONSE1
	output logic                      BREADY_M1;
	//WRITE DATA1
	
	
	
	input                             WREADY_M1;
	//WRITE ADDRESS1
	input                             AWREADY_M1;
	//WRITE RESPONSE1
	input        [  `AXI_ID_BITS-1:0] BID_M1;
	input        [               1:0] BRESP_M1;
	input                             BVALID_M1;
	
	

//---------------------------------READ PORT AXI -------------------------
	//READ ADDRESS1
	input                             ARREADY_M1;
	//READ ADDRESS0
	input                             ARREADY_M0;
	//READ DATA0
	input        [  `AXI_ID_BITS-1:0] RID_M0;
	input        [`AXI_DATA_BITS-1:0] RDATA_M0;
	input        [               1:0] RRESP_M0;
	input                             RLAST_M0;
	input                             RVALID_M0;
	//READ DATA1
	input        [  `AXI_ID_BITS-1:0] RID_M1;
	input        [`AXI_DATA_BITS-1:0] RDATA_M1;
	input        [               1:0] RRESP_M1;
	input                             RLAST_M1;
	input                             RVALID_M1;
	
	
	
	//READ ADDRESS0
	output logic [  `AXI_ID_BITS-1:0] ARID_M0;
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
	output logic [ `AXI_LEN_BITS-1:0] ARLEN_M0;//1
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;//1
	output logic [               1:0] ARBURST_M0;//0
	output logic                      ARVALID_M0;
	//READ ADDRESS1
	output logic [  `AXI_ID_BITS-1:0] ARID_M1;
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
	output logic [ `AXI_LEN_BITS-1:0] ARLEN_M1;//1
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;//0
	output logic [               1:0] ARBURST_M1;//1
	output logic                      ARVALID_M1;
	//READ DATA0
	output logic                      RREADY_M0;
	//READ DATA1
	output logic                      RREADY_M1;

	
	
	
	//---------------------------DESIGN
	input                             clk;
	input                             rst;	
	
	
	
	

	

	logic        [              31:0] dm_write_data;
	logic                             cpu_pause;
	logic        [              31:0] dm_read_data;
	logic        [              31:0] im_read_data;
	
	logic                             dm_read_signal;
	logic                             im_read_signal;
	logic                             dm_write_signal;
	logic                             dm_read_pause;
	logic                             im_read_pause;
	logic                             dm_write_pause;
	logic        [              31:0] dm_address;
	logic        [              31:0] im_address;
	//logic                             im_write_pause;
	logic                             im_write_signal;
	logic        [               3:0] dm_web;
	logic                             instruction_stall;
	
	
	logic                             dm_mem_read_signal;
	logic                             dm_mem_write_signal;
	logic        [               2:0] dm_core_type;
	logic                             dm_core_wait;
	logic        [              31:0] dm_core_out;
	logic        [              31:0] dm_core_in;
	logic                             dm_core_req;
    logic                             dm_core_write_signal;
	logic                             dm_core_read_signal;
	logic        [              31:0] dm_core_address;
	logic		                      dm_D_req;//TO WRAPPER TO MEM
	logic        [              31:0] dm_D_addr;//TO WRAPPER TO MEM
	logic        [               2:0] dm_D_type;
	logic        [              31:0] dm_D_read_data;
	logic        [              31:0] dm_D_write_data;
	logic        [              31:0] dm_D_write_signal;
	//logic 		 dm_D_write;//TO WRAPPER TO MEM
	//logic [31:0] dm_D_in;//TO WRAPPER TO MEM
	
	//TO WRAPPER TO MEM

	


	logic [ 2:0] im_core_type;


	//logic        [              31:0] im_write_data;
	//logic        [               3:0] im_web;
	always_comb
	begin
		cpu_pause=(dm_read_pause||dm_write_pause||im_read_pause)?1'b1:1'b0;
		dm_core_req=dm_write_mem||dm_core_write_signal;
		dm_mem_read_signal =(dm_D_req)&&(dm_D_write_signal==1'b0)
		dm_mem_write_signal=(dm_D_req)&&(dm_D_write_signal)	
	end
	

	
	master_read #(4'b0000,4'b0000,4'b0010)imread(
	.clk(clk),
	.rst(rst),
	.cpu_read_signal(im_read_signal),
	.address(im_address),
	.im_read_pause(1'b0),
	.read_data(im_read_data),
	.read_pause_cpu(im_read_pause),
	.instruction_stall(instruction_stall),
	
	
	//READ ADDRESS0
	.ARID_M(ARID_M0),
	.ARADDR_M(ARADDR_M0),
	.ARLEN_M(ARLEN_M0),
	.ARSIZE_M(ARSIZE_M0),
	.ARBURST_M(ARBURST_M0),
	.ARVALID_M(ARVALID_M0),
	//READ DATA0	
	.RREADY_M(RREADY_M0),
	
	
	//READ ADDRESS0
	.ARREADY_M(ARREADY_M0),
	//READ DATA0
	.RID_M(RID_M0),//unuse
	.RDATA_M(RDATA_M0),
	.RRESP_M(RRESP_M0),
	.RLAST_M(RLAST_M0),
	.RVALID_M(RVALID_M0)
	);
	
	
	


L1C_inst IM_L1(
				.clk(clk),
				.rst(rst),
  // Core to CPU wrapper
				.core_addr(),//FROM CPU 
				.core_req(),//FROM CPU 
				.core_write(),//FROM CPU 
				.core_in(),//FROM CPU 
				.core_type(),//FROM CPU 
  // Mem to CPU wrapper
				.I_out(),//FROM WRAPPER
				.I_wait(),//FROM WRAPPER
  // CPU wrapper to core
  
  
  
  
				.core_out(),//TO CPU
				.core_wait(),//TO CPU
				  // CPU wrapper to Mem
				.I_req(),//TO WRAPPER
				.I_addr(),//TO WRAPPER
				.I_write(),//TO WRAPPER
				.I_in(),//TO WRAPPER
				.I_type()//TO WRAPPER
);
CPU CPU1(
			.clk(clk),
			.rst(~rst),
			
			//.dm_dataout(dm_read_data),
			
			.bus_stall(cpu_pause),
			
			.im_addr(im_address),
			.im_read_mem(im_read_signal),
			.im_core_type(im_core_type),
			.im_dataout(im_read_data),

			.dm_core_type(dm_core_type),
			//.dm_web(dm_web),
			.dm_addr(dm_core_address),
			.dm_datain(dm_core_in),
			//.dm_write_mem(dm_write_signal),
			.dm_write_mem(dm_core_write_signal),
			//.dm_read_mem(dm_read_signal)
			.dm_read_mem(dm_core_read_signal),
			.dm_dataout(dm_core_out)
				);
L1C_data L1CD(
			.clk(clk),
			.rst(rst),

			  // Core to CPU wrapper
			.core_addr(dm_core_address),//FROM CPU 
			.core_req(dm_core_req),//FROM CPU 
			.core_write(dm_core_write_signal),//FROM CPU 
			.core_in(dm_core_in),//FROM CPU 
			.core_type(dm_core_type),//4//FROM CPU 
			  // Mem to CPU wrapper

			.D_wait(bus_stall),//FROM WRAPPER
			  // CPU wrapper to core
			  
			  
			.core_out(dm_core_out),//TO CPU
			.core_wait(dm_core_wait),//TO CPU
			  // CPU wrapper to Mem
			.D_req(dm_D_req),//TO WRAPPER
			.D_addr(dm_D_addr),//TO WRAPPER
			.D_write(dm_D_write_signal),//TO WRAPPER
			.D_in  (dm_D_write_data),//TO WRAPPER
			.D_type(dm_D_type)//TO WRAPPER
			.D_out(dm_D_read_data),//FROM WRAPPER
);
master_write #(4'b0001,4'b0001,4'b0010)dmwrite (
	.clk(clk),
	.rst(rst),
	.cpu_write_signal(dm_mem_write_signal),
	.cpu_write_data(dm_D_write_data),
	.im_read_pause(im_read_pause),
	.address(dm_D_addr),
	//.web(dm_web),
	.D_type(dm_D_type),
	
	.cpu_write_pause(dm_write_pause),

	.AWID_M(AWID_M1),
	.AWADDR_M(AWADDR_M1),
	.AWLEN_M(AWLEN_M1),
	.AWSIZE_M(AWSIZE_M1),
	.AWBURST_M(AWBURST_M1),
	.AWVALID_M(AWVALID_M1),
	//WRITE DATA1
	.WDATA_M(WDATA_M1),
	.WSTRB_M(WSTRB_M1),
	.WLAST_M(WLAST_M1),
	.WVALID_M(WVALID_M1),
	//WRITE RESPONSE1
	.BREADY_M(BREADY_M1),
	//WRITE DATA1
	.WREADY_M(WREADY_M1),
	//WRITE ADDRESS1
	.AWREADY_M(AWREADY_M1),
	//WRITE RESPONSE1
	.BID_M(BID_M1),
	.BRESP_M(BRESP_M1),
	.BVALID_M(BVALID_M1)

);
			
	master_read #(4'b0001,4'b0001,4'b0010)dmread(
		.clk(clk),
		.rst(rst),
		.cpu_read_signal(dm_mem_read_signal),
		.address(dm_D_addr),
		.im_read_pause(im_read_pause),
		.read_data(dm_D_read_data),
		.read_pause_cpu(dm_read_pause),
		.instruction_stall(1'b0),



		//READ ADDRESS0
		.ARID_M(ARID_M1),
		.ARADDR_M(ARADDR_M1),
		.ARLEN_M(ARLEN_M1),
		.ARSIZE_M(ARSIZE_M1),
		.ARBURST_M(ARBURST_M1),
		.ARVALID_M(ARVALID_M1),
		//READ DATA0	
		.RREADY_M(RREADY_M1),


		//READ ADDRESS0
		.ARREADY_M(ARREADY_M1),
		//READ DATA0
		.RID_M(RID_M1),//unuse
		.RDATA_M(RDATA_M1),
		.RRESP_M(RRESP_M1),
		.RLAST_M(RLAST_M1),
		.RVALID_M(RVALID_M1)

	);
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
