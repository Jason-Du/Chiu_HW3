	`include "../include/AXI_define.svh"
module write_fsm(
					AWID_M1,
					AWADDR_M1,
					AWLEN_M1,
					AWSIZE_M1,
					AWBURST_M1,
					AWVALID_M1,
					AWVALID_M1_IN,
						//WRITE DATA
					WDATA_M1,
					WSTRB_M1,
					WLAST_M1,
					WVALID_M1,
						//WRITE RESPONSE
					BREADY_M1,
						
						
						
						
						//WRITE DATA
					WREADY_M1,
						//WRITE ADDRESS
					AWREADY_M1,
						//WRITE RESPONSE
					BID_M1,
					BRESP_M1,
					BVALID_M1,
						
						
						//MASTER INTERFACE FOR SLAVES
						
						//WRITE ADDRESS0
					AWID_S0,
					AWADDR_S0,
					AWLEN_S0,
					AWSIZE_S0,
					AWBURST_S0,
					AWVALID_S0,
						
						//WRITE DATA0
					WDATA_S0,
					WSTRB_S0,
					WLAST_S0,
					WVALID_S0,
						//WRITE RESPONSE0
					BREADY_S0,
						//WRITE DATA0
						
						
					WREADY_S0,
						//WRITE ADDRESS0
					AWREADY_S0,
						//WRITE RESPONSE0
					BID_S0,
					BRESP_S0,
					BVALID_S0,
						
						//WRITE ADDRESS1
					AWID_S1,
					AWADDR_S1,
					AWLEN_S1,
					AWSIZE_S1,
					AWBURST_S1,
					AWVALID_S1,
						//WRITE DATA1
					WDATA_S1,
					WSTRB_S1,
					WLAST_S1,
					WVALID_S1,
						//WRITE RESPONSE1
					BREADY_S1,
						//WRITE DATA1
					WREADY_S1,
						//WRITE ADDRESS1
					AWREADY_S1,
						//WRITE RESPONSE1
					BID_S1,
					BRESP_S1,
					BVALID_S1,
					clk,
					rst,

					situation2_decode
);
	//SLAVE INTERFACE FOR MASTERS
	//WRITE ADDRESS
	input        [  `AXI_ID_BITS-1:0] AWID_M1;
	input        [`AXI_ADDR_BITS-1:0] AWADDR_M1;
	input        [ `AXI_LEN_BITS-1:0] AWLEN_M1;
	input        [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
	input        [               1:0] AWBURST_M1;
	input                             AWVALID_M1;
	input                             AWVALID_M1_IN;
	//WRITE DATA
	input        [`AXI_DATA_BITS-1:0] WDATA_M1;
	input        [`AXI_STRB_BITS-1:0] WSTRB_M1;
	input                             WLAST_M1;
	input                             WVALID_M1;
	//WRITE RESPONSE
	input                             BREADY_M1;
	
	
	
	
	//WRITE DATA
	output logic                      WREADY_M1;
	//WRITE ADDRESS
	output logic                      AWREADY_M1;
	//WRITE RESPONSE
	output logic [  `AXI_ID_BITS-1:0] BID_M1;
	output logic [               1:0] BRESP_M1;
	output logic                      BVALID_M1;
	
	
	//MASTER INTERFACE FOR SLAVES
	
	//WRITE ADDRESS0
	output logic [ `AXI_IDS_BITS-1:0] AWID_S0;
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0;
	output logic [ `AXI_LEN_BITS-1:0] AWLEN_S0;
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0;
	output logic [               1:0] AWBURST_S0;
	output logic                      AWVALID_S0;
	
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S0;
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0;
	output logic                      WLAST_S0;
	output logic                      WVALID_S0;
	//WRITE RESPONSE0
	output logic                      BREADY_S0;
	//WRITE DATA0
	
	
	input                             WREADY_S0;
	//WRITE ADDRESS0
	input                             AWREADY_S0;
	//WRITE RESPONSE0
	input        [ `AXI_IDS_BITS-1:0] BID_S0;
	input        [               1:0] BRESP_S0;
	input                             BVALID_S0;
	
	//WRITE ADDRESS1
	output logic [ `AXI_IDS_BITS-1:0] AWID_S1;
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1;
	output logic [ `AXI_LEN_BITS-1:0] AWLEN_S1;
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1;
	output logic [               1:0] AWBURST_S1;
	output logic                      AWVALID_S1;
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1;
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1;
	output logic                      WLAST_S1;
	output logic                      WVALID_S1;
	//WRITE RESPONSE1
	output logic                      BREADY_S1;
	//WRITE DATA1
	input                             WREADY_S1;
	//WRITE ADDRESS1
	input                             AWREADY_S1;
	//WRITE RESPONSE1
	input        [ `AXI_IDS_BITS-1:0] BID_S1;
	input        [               1:0] BRESP_S1;
	input                             BVALID_S1;

	input                             clk;
	input                             rst;


	output logic                      situation2_decode;


	logic                             situation_decode;
	logic                             situation_decode_register_out;
	logic        [              15:0] slave_select;
        logic        [              15:0] slave_select_register_out;
	logic                             cs;
	logic                             ns;
	
	always_ff@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			cs<=1'b0;
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
			situation_decode_register_out<=1'b0;
			slave_select_register_out<=16'd0;
		end
		else
		begin
			situation_decode_register_out<=situation_decode;
			slave_select_register_out<=slave_select;
		end
	
	end
	always_comb
	begin
		case(cs)
			1'b0:
			begin
				if(AWVALID_M1==1'b1)
				begin
					situation_decode=1'b1;
					situation2_decode=1'b1;
					ns=1'b1;
					slave_select=AWADDR_M1[31:16];
				end
				else
				begin
					situation2_decode=1'b0;
					situation_decode=1'b0;
					ns=1'b0;
					slave_select=16'd0;
				end
			end
			1'b1:
			begin
				slave_select=slave_select_register_out;
				situation_decode=situation_decode_register_out;
				ns=(BVALID_M1&&BREADY_M1)?1'b0:1'b1;
				situation2_decode=(BVALID_M1&&BREADY_M1)?1'b0:1'b1;
			end
		endcase
	end	
	always_comb
	begin
		if(situation_decode==1'b1)
		begin
			WREADY_M1 =(slave_select==16'd1)?WREADY_S1:WREADY_S0;
						//WRITE ADDRESS
			AWREADY_M1=(slave_select==16'd1)?AWREADY_S1:AWREADY_S0;
						//WRITE RESPONSE
			BID_M1    =(slave_select==16'd1)?BID_S1[3:0]:BID_S0[3:0];
			BRESP_M1  =(slave_select==16'd1)?BRESP_S1:BRESP_S0;
			BVALID_M1 =(slave_select==16'd1)?BVALID_S1:BVALID_S0;
						//WRITE ADDRESS0

			AWID_S0   =(slave_select==16'd1)?8'd0:{4'b0000,AWID_M1};
			AWADDR_S0 =(slave_select==16'd1)?32'd0:AWADDR_M1;
			AWLEN_S0  =(slave_select==16'd1)?4'd0:AWLEN_M1;
			AWSIZE_S0 =(slave_select==16'd1)?3'd2:AWSIZE_M1;
			AWBURST_S0=(slave_select==16'd1)?2'd1:AWBURST_M1;
			AWVALID_S0=(slave_select==16'd1)?1'b0:AWVALID_M1_IN;
						
						//WRITE DATA0
			WDATA_S0  =(slave_select==16'd1)?32'd0:WDATA_M1;
			WSTRB_S0  =(slave_select==16'd1)?4'd0:WSTRB_M1;
			WLAST_S0  =(slave_select==16'd1)?1'd0:WLAST_M1;
			WVALID_S0 =(slave_select==16'd1)?1'd0:WVALID_M1;
						//WRITE RESPONSE0
			BREADY_S0 =(slave_select==16'd1)?1'd0:BREADY_M1;
						//WRITE DATA0
						//WRITE ADDRESS1



			AWID_S1   =(slave_select==16'd1)?{4'b0000,AWID_M1}:8'd0;
			AWADDR_S1 =(slave_select==16'd1)?AWADDR_M1:32'd0;
			AWLEN_S1  =(slave_select==16'd1)?AWLEN_M1:4'd0;
			AWSIZE_S1 =(slave_select==16'd1)?AWSIZE_M1:3'd2;
			AWBURST_S1=(slave_select==16'd1)?AWBURST_M1:2'd1;
			AWVALID_S1=(slave_select==16'd1)?AWVALID_M1_IN:1'b0;
						
						//WRITE DATA0
			WDATA_S1  =(slave_select==16'd1)?WDATA_M1:32'd0;
			WSTRB_S1  =(slave_select==16'd1)?WSTRB_M1:4'd0;
			WLAST_S1  =(slave_select==16'd1)?WLAST_M1:1'd0;
			WVALID_S1 =(slave_select==16'd1)?WVALID_M1:1'd0;
						//WRITE RESPONSE0
			BREADY_S1 =(slave_select==16'd1)?BREADY_M1:1'd0;
		end
		else
		begin
			//slave_select=16'd0;
			WREADY_M1 =1'b0;
						//WRITE ADDRESS
			AWREADY_M1=1'b0;
						//WRITE RESPONSE
			BID_M1    =4'd0;
			BRESP_M1  =2'b00;
			BVALID_M1 =1'b0;
						//WRITE ADDRESS0
			AWID_S0   =8'd0;
			AWADDR_S0 =32'd0;
			AWLEN_S0  =4'd0;
			AWSIZE_S0 =3'd2;
			AWBURST_S0=2'd1;
			AWVALID_S0=1'b0;
						
						//WRITE DATA0
			WDATA_S0  =32'd0;
			WSTRB_S0  =4'd0;
			WLAST_S0  =1'd0;
			WVALID_S0 =1'd0;
						//WRITE RESPONSE0
			BREADY_S0 =1'd0;
						//WRITE DATA0
						//WRITE ADDRESS1
			AWID_S1   =8'd0;
			AWADDR_S1 =32'd0;
			AWLEN_S1  =4'd0;
			AWSIZE_S1 =3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'b0;
						
						//WRITE DATA0
			WDATA_S1  =32'd0;
			WSTRB_S1  =4'd0;
			WLAST_S1  =1'd0;
			WVALID_S1 =1'd0;
						//WRITE RESPONSE0
			BREADY_S1 =1'd0;
						//WRITE DATA1
		end
	end
endmodule
