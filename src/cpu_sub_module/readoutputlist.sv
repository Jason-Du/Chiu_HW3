	ARID_M0   =4'b;
	ARADDR_M0 =32'd;
	ARVALID_M0=;
	RREADY_M0 =;
	ARID_M1   =4'b;
	ARADDR_M1 =32'd;
	ARVALID_M1=;
	RREADY_M1 =;

				
				
				
				
				
				
AWID_M=4'b;
AWADDR_M=32'd;
AWLEN_M=4'd;
AWSIZE_M=3'd;
AWBURST_M=2'd;
AWVALID_M=1'b;
	//WRITE DATA1
WDATA_M=32'd;
WSTRB_M=4'b;
WLAST_M=1'b;
WVALID_M=1'b;
	//WRITE RESPONSE1
BREADY_M=1'b;


cpu_write_pause;


input cpu_write_signal;
input cpu_write_data;
input address;