	`include "../include/AXI_define.svh"
module read_fsm(
					ARID_M0,
					ARADDR_M0,
					ARLEN_M0,
					ARSIZE_M0,
					ARBURST_M0,
					ARVALID_M0,
					ARVALID_M0_IN,
					 
						//READ ADDRESS1
					ARID_M1,
					ARADDR_M1,
					ARLEN_M1,
					ARSIZE_M1,
					ARBURST_M1,
					ARVALID_M1,
					ARVALID_M1_IN,
						//READ DATA0
					RREADY_M0,
						//READ DATA1
					RREADY_M1,
						
						
						
						
						//READ DATA0
					RID_M0,
					RDATA_M0,
					RRESP_M0,
					RLAST_M0,
					RVALID_M0,
						//READ ADDRESS1
					ARREADY_M1,
						//READ DATA1
					RID_M1,
					RDATA_M1,
					RRESP_M1,
					RLAST_M1,
					RVALID_M1,
						//READ ADDRESS0
					ARREADY_M0,
						
						
						
		//MASTER INTERFACE FOR SLAVES
	
	//READ ADDRESS0
						
					ARREADY_S0,
						//READ DATA0
					RID_S0,
					RDATA_S0,
					RRESP_S0,
					RLAST_S0,
					RVALID_S0,
						//READ ADDRESS1
					ARREADY_S1,
						//READ DATA1
					RID_S1,
					RDATA_S1,
					RRESP_S1,
					RLAST_S1,
					RVALID_S1,
						
						
						
						//READ DATA0
					 RREADY_S0,
						//READ ADDRESS0
					ARID_S0,
					ARADDR_S0,
					ARLEN_S0,
					ARSIZE_S0,
					ARBURST_S0,
					ARVALID_S0,
						//READ DATA1
						
					RREADY_S1,
						//READ ADDRESS1
					ARID_S1,
					ARADDR_S1,
					ARLEN_S1,
					ARSIZE_S1,
					ARBURST_S1,
					ARVALID_S1,
					rst,
					clk,

					situation2_decode
					);

	//SLAVE INTERFACE FOR MASTERS
	//READ ADDRESS0

	input       [   `AXI_ID_BITS-1:0] ARID_M0;
	input       [ `AXI_ADDR_BITS-1:0] ARADDR_M0;
	input       [  `AXI_LEN_BITS-1:0] ARLEN_M0;
	input       [ `AXI_SIZE_BITS-1:0] ARSIZE_M0;
	input       [                1:0] ARBURST_M0;
	input                              ARVALID_M0;
	input                              ARVALID_M0_IN;
	
	//READ ADDRESS1
	input        [  `AXI_ID_BITS-1:0] ARID_M1;
	input        [`AXI_ADDR_BITS-1:0] ARADDR_M1;
	input        [ `AXI_LEN_BITS-1:0] ARLEN_M1;
	input        [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
	input        [               1:0] ARBURST_M1;
	input                             ARVALID_M1;
	input                              ARVALID_M1_IN;
	//READ DATA0
	input                             RREADY_M0;
	//READ DATA1
	input                             RREADY_M1;
	
	
	
	
	//READ DATA0
	output logic [  `AXI_ID_BITS-1:0] RID_M0;
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0;
	output logic [               1:0] RRESP_M0;
	output logic                      RLAST_M0;
	output logic                      RVALID_M0;
	//READ ADDRESS1
	output logic                      ARREADY_M1;
	//READ DATA1
	output logic [  `AXI_ID_BITS-1:0] RID_M1;
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1;
	output logic [               1:0] RRESP_M1;
	output logic                      RLAST_M1;
	output logic                      RVALID_M1;
	//READ ADDRESS0
	output logic                      ARREADY_M0;
	
	
	
	//MASTER INTERFACE FOR SLAVES
	
	//READ ADDRESS0
	
	input                             ARREADY_S0;
	//READ DATA0
	input        [ `AXI_IDS_BITS-1:0] RID_S0;
	input        [`AXI_DATA_BITS-1:0] RDATA_S0;
	input        [               1:0] RRESP_S0;
	input                             RLAST_S0;
	input                             RVALID_S0;
	//READ ADDRESS1
	input                             ARREADY_S1;
	//READ DATA1
	input        [ `AXI_IDS_BITS-1:0] RID_S1;
	input        [`AXI_DATA_BITS-1:0] RDATA_S1;
	input        [               1:0] RRESP_S1;
	input                             RLAST_S1;
	input                             RVALID_S1;
	
	
	//READ DATA0
	output logic                      RREADY_S0;
	//READ ADDRESS0
	output logic [ `AXI_IDS_BITS-1:0] ARID_S0;
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0;
	output logic [ `AXI_LEN_BITS-1:0] ARLEN_S0;
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0;
	output logic [               1:0] ARBURST_S0;
	output logic                      ARVALID_S0;
	//READ DATA1
	
	output logic                      RREADY_S1;
	//READ ADDRESS1
	output logic [ `AXI_IDS_BITS-1:0] ARID_S1;
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1;
	output logic [ `AXI_LEN_BITS-1:0] ARLEN_S1;
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1;
	output logic [               1:0] ARBURST_S1;
	output logic                      ARVALID_S1;


	input                             clk;
	input                             rst;

	output logic [               1:0] situation2_decode;


	logic        [               1:0] situation_decode;
	logic        [               1:0] situation;
	logic        [              15:0] slave_sel;
	logic                             cs;
	logic                             ns;
	logic        [               1:0] situation_decode_register_out;
        logic        [              15:0] slave_sel_register_out;


	//modify for 2 state
	always_comb
	begin
		situation={ARVALID_M0,ARVALID_M1};
		case(cs)
			1'b0:
			begin
				situation2_decode=situation_decode;
				case(situation)
				2'b00:
				begin
					situation_decode=2'b00;
					slave_sel=16'd0;
					ns=1'b0;
				end
				2'b01:
				begin
					situation_decode=2'b01;
					slave_sel=ARADDR_M1[31:16];
					ns=1'b1;
				end
				2'b10:
				begin
					situation_decode=2'b10;
					slave_sel=ARADDR_M0[31:16];
					ns=1'b1;
				end
				2'b11:
				begin
					situation_decode=2'b00;
					slave_sel=16'd0;
					ns=1'b0;
				end
				endcase
			end
			1'b1:
			begin
				slave_sel=slave_sel_register_out;
				situation_decode=situation_decode_register_out;
				if(situation_decode==2'b01)
				begin
					ns=(RVALID_M1&&RREADY_M1)?1'b0:1'b1;
					situation2_decode=(RVALID_M1&&RREADY_M1)?2'b00:2'b01;
				end
				else
				begin
					ns=(RVALID_M0&&RREADY_M0)?1'b0:1'b1;
					situation2_decode=(RVALID_M0&&RREADY_M0)?2'b00:2'b10;
				end

			end
		endcase
	end
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
			situation_decode_register_out<=2'b00;
			slave_sel_register_out<=16'd0;
		end
		else
		begin
			slave_sel_register_out<=slave_sel;
			situation_decode_register_out<=situation_decode;
		end
	end
always_comb
begin
	case(situation_decode)
		2'b00:
		begin
			//slave_sel =16'd0;
			RID_M0    =4'd0;
			RDATA_M0  =32'd0;
			RRESP_M0  =2'd0;
			RLAST_M0  =1'b0;
			RVALID_M0 =1'b0;
				//READ ADDRESS1
			ARREADY_M1=1'b0;
				//READ DATA1
			RID_M1    =4'd0;
			RDATA_M1  =32'd0;
			RRESP_M1  =2'd0;
			RLAST_M1  =1'b0;
			RVALID_M1 =1'b0;
				//READ ADDRESS0
			ARREADY_M0=1'b0;
			RREADY_S0 =1'b0;
				//READ ADDRESS0
			ARID_S0    =8'd0;
			ARADDR_S0  =32'd0;
			ARLEN_S0   =4'd0;
			ARSIZE_S0  =3'd2;
			ARBURST_S0 =2'd1;
			ARVALID_S0 =1'b0;
				//READ DATA1
				
			RREADY_S1 =1'b0;
				//READ ADDRESS1
			ARID_S1    =8'd0;
			ARADDR_S1  =32'd0;
			ARLEN_S1   =4'd0;
			ARSIZE_S1  =3'd2;
			ARBURST_S1 =2'd1;
			ARVALID_S1 =1'b0;
		end
		2'b01:
		begin
			RID_M0    =4'd0;
			RDATA_M0  =32'd0;
			RRESP_M0  =2'd0;
			RLAST_M0  =1'b0;
			RVALID_M0 =1'b0;
				//READ ADDRESS1
			ARREADY_M0=1'b0;
				//READ DATA1
			//RID_M1    =(slave_sel==16'd1)?4'd1:4'd0;
			RID_M1    =(slave_sel==16'd1)?RID_S1[3:0]:RID_S0[3:0];
			RDATA_M1  =(slave_sel==16'd1)?RDATA_S1:RDATA_S0;
			RRESP_M1  =(slave_sel==16'd1)?RRESP_S1:RRESP_S0;
			RLAST_M1  =(slave_sel==16'd1)?RLAST_S1:RLAST_S0;
			RVALID_M1 =(slave_sel==16'd1)?RVALID_S1:RVALID_S0;
				//READ ADDRESS0
			ARREADY_M1=(slave_sel==16'd1)?ARREADY_S1:ARREADY_S0;


			RREADY_S0 =(slave_sel==16'd1)?1'b0:RREADY_M1;
				//READ ADDRESS0
			ARID_S0    =(slave_sel==16'd1)?8'd0:{4'b0000,ARID_M1};
			ARADDR_S0  =(slave_sel==16'd1)?32'd0:ARADDR_M1;
			ARLEN_S0   =(slave_sel==16'd1)?4'd0:ARLEN_M1;
			ARSIZE_S0  =(slave_sel==16'd1)?3'd2:ARSIZE_M1;
			ARBURST_S0 =(slave_sel==16'd1)?2'd1:ARBURST_M1;
			ARVALID_S0 =(slave_sel==16'd1)?1'b0:ARVALID_M1_IN;
			
				//READ DATA1
				
			RREADY_S1  =(slave_sel==16'd1)?RREADY_M1:1'b0;
				//READ ADDRESS1
			//ARID_S1    =(slave_sel==16'd1)?8'd1:8'd0;
			ARID_S1    =(slave_sel==16'd1)?{4'b0000,ARID_M1}:8'd0;
			ARADDR_S1  =(slave_sel==16'd1)?ARADDR_M1:32'd0;
			ARLEN_S1   =(slave_sel==16'd1)?ARLEN_M1:4'd0;
			ARSIZE_S1  =(slave_sel==16'd1)?ARSIZE_M1:3'd2;
			ARBURST_S1 =(slave_sel==16'd1)?ARBURST_M1:2'd1;
			ARVALID_S1 =(slave_sel==16'd1)?ARVALID_M1_IN:1'b0;			
		end
		2'b10:
		begin
			RID_M1    =4'd0;
			RDATA_M1  =32'd0;
			RRESP_M1  =2'd0;
			RLAST_M1  =1'b0;
			RVALID_M1 =1'b0;
				//READ ADDRESS1
			ARREADY_M1=1'b0;
				//READ DATA1
			//RID_M0    =(slave_sel==16'd1)?4'd1:4'd0;
			RID_M0    =(slave_sel==16'd1)?RID_S1[3:0]:RID_S0[3:0];
			RDATA_M0  =(slave_sel==16'd1)?RDATA_S1:RDATA_S0;
			RRESP_M0  =(slave_sel==16'd1)?RRESP_S1:RRESP_S0;
			RLAST_M0  =(slave_sel==16'd1)?RLAST_S1:RLAST_S0;
			RVALID_M0 =(slave_sel==16'd1)?RVALID_S1:RVALID_S0;
				//READ ADDRESS0
			ARREADY_M0=(slave_sel==16'd1)?ARREADY_S1:ARREADY_S0;




			RREADY_S0 =(slave_sel==16'd1)?1'b0:RREADY_M0;
				//READ ADDRESS0
			ARID_S0    =(slave_sel==16'd1)?8'd0:{4'b0000,ARID_M0};
			ARADDR_S0  =(slave_sel==16'd1)?32'd0:ARADDR_M0;
			ARLEN_S0   =(slave_sel==16'd1)?4'd0:ARLEN_M0;
			ARSIZE_S0  =(slave_sel==16'd1)?3'd2:ARSIZE_M0;
			ARBURST_S0 =(slave_sel==16'd1)?2'd1:ARBURST_M0;
			ARVALID_S0 =(slave_sel==16'd1)?1'b0:ARVALID_M0_IN;
			
			

			RREADY_S1  =(slave_sel==16'd1)?RREADY_M0:1'b0;
				//READ ADDRESS1
			//ARID_S1    =(slave_sel==16'd1)?8'd1:8'd0;
			ARID_S1    =(slave_sel==16'd1)?{4'b0000,ARID_M0}:8'd0;
			ARADDR_S1  =(slave_sel==16'd1)?ARADDR_M0:32'd0;
			ARLEN_S1   =(slave_sel==16'd1)?ARLEN_M0:4'd0;
			ARSIZE_S1  =(slave_sel==16'd1)?ARSIZE_M0:3'd2;
			ARBURST_S1 =(slave_sel==16'd1)?ARBURST_M0:2'd1;
			ARVALID_S1 =(slave_sel==16'd1)?ARVALID_M0_IN:1'b0;					
		end
		2'b11:
		begin
			//slave_sel =16'd0;
			RID_M0    =4'd0;
			RDATA_M0  =32'd0;
			RRESP_M0  =2'd0;
			RLAST_M0  =1'b0;
			RVALID_M0 =1'b0;
				//READ ADDRESS1
			ARREADY_M1=1'b0;
				//READ DATA1
			RID_M1    =4'd0;
			RDATA_M1  =32'd0;
			RRESP_M1  =2'd0;
			RLAST_M1  =1'b0;
			RVALID_M1 =1'b0;
				//READ ADDRESS0
			ARREADY_M0=1'b0;
			RREADY_S0 =1'b0;
				//READ ADDRESS0
			ARID_S0    =8'd0;
			ARADDR_S0  =32'd0;
			ARLEN_S0   =4'd0;
			ARSIZE_S0  =3'd2;
			ARBURST_S0 =2'd1;
			ARVALID_S0 =1'b0;
				//READ DATA1
				
			RREADY_S1 =1'b0;
				//READ ADDRESS1
			ARID_S1    =8'd0;
			ARADDR_S1  =32'd0;
			ARLEN_S1   =4'd0;
			ARSIZE_S1  =3'd2;
			ARBURST_S1 =2'd1;
			ARVALID_S1 =1'b0;			
		end
	endcase
end
endmodule	
