`timescale 1ns/10ps
`include"../include/AXI_define.svh"
`define addr_decode_im =16'h0000;
`define self_ID_im =8'b00000000;

module slave_im(

	input ACLK,
	input ARESETn,
	input [`AXI_IDS_BITS-1:0] AWID,
	input [`AXI_ADDR_BITS-1:0] AWADDR,
	input [`AXI_LEN_BITS-1:0] AWLEN,
	input [`AXI_SIZE_BITS-1:0] AWSIZE,
	input [1:0] AWBURST,
	input AWVALID,
	output logic AWREADY,
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA,
	input [`AXI_STRB_BITS-1:0] WSTRB,
	input WLAST,
	input WVALID,
	output logic WREADY,
	//WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] BID,
	output logic [1:0] BRESP,
	output logic BVALID,
	input BREADY,

	//READ ADDRESS
	input [`AXI_IDS_BITS-1:0] ARID,
	input [`AXI_ADDR_BITS-1:0] ARADDR,
	input [`AXI_LEN_BITS-1:0] ARLEN,
	input [`AXI_SIZE_BITS-1:0] ARSIZE,
	input [1:0] ARBURST,
	input ARVALID,
	output logic ARREADY,
	//READ DATA
	output logic [`AXI_IDS_BITS-1:0] RID,
	output logic [`AXI_DATA_BITS-1:0] RDATA,
	output logic [1:0] RRESP,
	output logic RLAST,
	output logic RVALID,
	input RREADY,
	
	//memory port
	output logic CS,
	output logic OE,
	output logic [3:0] WEB,
	output logic [13:0] A,
	output logic [31:0] DI,
	input [31:0] DO
);

logic [1:0]cs, ns, one_clock;
logic w_select, r_select, flag;

logic [31:0]addr;
logic [7:0]ID;

always_ff@(posedge ACLK or negedge ARESETn)begin
	if(!ARESETn)begin
		cs<=2'b00;
		w_select<=1'b0; 
		r_select<=1'b0;
		flag<=1'b0;
		
		addr<=32'd0;
		ID<=8'hff;
		CS<=1'b0;
		OE<=1'b0;
		WEB<=4'b1111;
		A<=14'd0;		
		DI<=32'd0;
		one_clock<=2'b00;
		RDATA<=32'd0;
	end
	else begin
		if((w_select==1'b0)&&(r_select==1'b0))begin
			w_select<=(AWVALID==1'b1)?1'b1:1'b0;
			r_select<=(ARVALID==1'b1)?1'b1:1'b0;
			cs<=((AWVALID==1'b1)||(ARVALID==1'b1))?2'b01:ns;
			flag<=(AWVALID==1'b1)?1'b1:1'b0;
		end
		else begin
			cs<=ns;
			w_select<=((cs==2'b00)||(r_select==1'b1))?1'b0:1'b1;
			r_select<=((cs==2'b00)||(w_select==1'b1))?1'b0:1'b1;
			flag<=(cs==2'b00)?1'b0:flag;	
		end	
		
		/*------addr , id------*/
		if(cs==2'b01)begin
			if(flag==1'b1)begin
				addr<=AWADDR;
				ID<=AWID;
			end
			else if((flag==1'b0)&&((AWVALID==1'b1)||(ARVALID==1'b1)))begin
				addr<=(r_select==1'b1)?ARADDR:((w_select==1'b1)?AWADDR:addr);
				ID<=(r_select==1'b1)?ARID:((w_select==1'b1)?AWID:ID);
			end
			else begin
				addr<=addr;
				ID<=ID;
			end
		end
		else begin
			addr<=addr;
			ID<=ID;
		end
		/*-------------------*/
		/*----- memory -----*/
		if((cs==2'b10)&&(one_clock==2'b00))begin//////////////////////////////////////////////////////////////////<-----------
			CS<=1'b1;
			OE<=(r_select==1'b1)?1'b1:1'b0;
			WEB<=(w_select==1'b1)?WSTRB:4'b1111;
			A<=addr[15:2];
				
			DI<=WDATA;
			one_clock<=one_clock+2'b01;
		end
		else if(((cs==2'b10)&&(one_clock==2'b01))||((one_clock==2'b01)&&(w_select==1'b1))) begin
			CS<=CS;
			OE<=OE;
			WEB<=WEB;
			A<=A;
				
			DI<=DI;
			one_clock<=one_clock+2'b01;
		end
		else begin
			CS<=CS;
			OE<=OE;
			WEB<=4'hf;
			A<=A;
				
			DI<=DI;
			one_clock<=2'b00;
		end
		/////////////////////////////////////////
		if((cs==2'b10)&&(one_clock==2'b10))begin
			RDATA<=(r_select==1'b1)?DO:RDATA;
		end
		else begin
			RDATA<=RDATA;
		end
		/*-------------------*/
	end
end

always_comb begin
if(flag==1'b1)begin	
	if(w_select==1'b1)begin//write
		case(cs)
			2'b00:begin
				AWREADY=1'b0;
				WREADY=1'b0;
				BID=ID;
				BRESP=(addr<32'h0000ffff)?2'b00:2'b11;
				//BRESP=((ID==8'b00000000)&&(addr<32'h0000ffff))?2'b00:2'b11;
				BVALID=1'b0;
				
				ns=2'b00;
			end
			2'b01:begin
				AWREADY=1'b1;
				WREADY=1'b0;
				BID=ID;
				BRESP=(addr<32'h0000ffff)?2'b00:2'b11;
				//BRESP=((ID==8'b00000000)&&(addr<32'h0000ffff))?2'b00:2'b11;
				BVALID=1'b0;
				
				/*GET ~~~ADDR & ID~~~*/
				
				ns=(AWVALID==1'b1)?2'b10:2'b01;
			end
			2'b10:begin
				AWREADY=1'b0;
				WREADY=1'b1;
				BID=ID;
				BRESP=(addr<32'h0000ffff)?2'b00:2'b11;
				//BRESP=((ID==8'b00000000)&&(addr<32'h0000ffff))?2'b00:2'b11;
				BVALID=1'b0;
				
				/*-----write memory data-----*/
				
				ns=((WLAST==1'b1)&&(WVALID==1'b1))?2'b11:2'b10;			
			end
			2'b11:begin
				BRESP=(addr<32'h0000ffff)?2'b00:2'b11;
				//BRESP=((ID==8'b00000000)&&(addr<32'h0000ffff))?2'b00:2'b11;
				AWREADY=1'b0;
				WREADY=1'b0;
				BID=ID;
				BVALID=1'b1;
				
				ns=(BREADY==1'b1)?2'b00:2'b11;
			end
		endcase
	end
	else begin
		AWREADY=1'b0;
		WREADY=1'b0;
		BID=ID;
		BRESP=2'b00;
		BVALID=1'b0;
		
		ns=2'b00;		
	end
	ARREADY=1'b0;
	RID=ID;
	RRESP=2'b00;
	RLAST=1'b0;
	RVALID=1'b0;
end
else begin
	if(r_select==1'b1)begin//read
		case(cs)
			2'b00:begin
				ARREADY=1'b0;
				RID=ID;
				RRESP=(addr<32'h0000ffff)?2'b00:2'b11;
				//RRESP=((ID==8'b00000000)&&(addr<32'h0000ffff))?2'b00:2'b11;
				RLAST=1'b0;
				RVALID=1'b0;
				
				ns=2'b00;
			end
			2'b01:begin
				ARREADY=1'b1;
				RID=ID;
				RRESP=(addr<32'h0000ffff)?2'b00:2'b11;
				//RRESP=((ID==8'b00000000)&&(addr<32'h0000ffff))?2'b00:2'b11;
				RLAST=1'b0;
				RVALID=1'b0;
				
				/*GET ~~~ADDR & ID~~~*/
				
				ns=(ARVALID==1'b1)?2'b10:2'b01;
			end
			2'b10:begin
				/*--------get data from memory--------*/
				
				ARREADY=1'b0;
				RID=ID;
				RRESP=(addr<32'h0000ffff)?2'b00:2'b11;
				//RRESP=((ID==8'b00000000)&&(addr<32'h0000ffff))?2'b00:2'b11;
				RLAST=1'b0;
				RVALID=1'b0;
				ns=(one_clock==2'b10)?2'b11:2'b10;
				//ns=2'b11;	
			end
			2'b11:begin	
				ARREADY=1'b0;
				RID=ID;
				RRESP=(addr<32'h0000ffff)?2'b00:2'b11;
				//RRESP=((ID==8'b00000000)&&(addr<32'h0000ffff))?2'b00:2'b11;
				RLAST=1'b1;
				RVALID=1'b1;
				
				ns=(RREADY==1'b1)?2'b00:2'b11;
			end
		endcase
	end
	else begin
		ARREADY=1'b0;
		RID=ID;
		RRESP=2'b00;
		RLAST=1'b0;
		RVALID=1'b0;
		
		ns=2'b00;
	end
	AWREADY=1'b0;
	WREADY=1'b0;
	BID=ID;
	BRESP=2'b00;
	BVALID=1'b0;
end
end

endmodule


