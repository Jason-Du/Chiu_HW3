 `timescale 1ns/10ps
 module register(
				rs1_addr,
				rs2_addr,
				rd_addr,
				clk,
				rst,
				read_reg,
				write_reg,
				write_data,
				
				
				rs1_data,
				rs2_data
					);
					
parameter DATA_SIZE   =32;
parameter STP_REGSIZE = 32;//Regoster number

input                       clk;
input                       rst;
input                       read_reg;
input                       write_reg;
input        [          4:0]rs1_addr;
input        [          4:0]rs2_addr;
input        [          4:0]rd_addr;
input        [DATA_SIZE-1:0]write_data;


output logic [DATA_SIZE-1:0] rs1_data;
output logic [DATA_SIZE-1:0] rs2_data;



logic        [DATA_SIZE-1:0] mreg [STP_REGSIZE-1:0];

always_ff@(posedge clk or posedge rst)
begin:write_in_register
	if(rst)
	begin
		mreg[0]<=32'd0;
		mreg[1]<=32'd0;
		mreg[2]<=32'd0;
		mreg[3]<=32'd0;
		mreg[4]<=32'd0;
		mreg[5]<=32'd0;
		mreg[6]<=32'd0;
		mreg[7]<=32'd0;
		mreg[8]<=32'd0;
		mreg[9]<=32'd0;
		mreg[10]<=32'd0;
		mreg[11]<=32'd0;
		mreg[12]<=32'd0;
		mreg[13]<=32'd0;
		mreg[14]<=32'd0;
		mreg[15]<=32'd0;
		mreg[16]<=32'd0;
		mreg[17]<=32'd0;
		mreg[18]<=32'd0;
		mreg[19]<=32'd0;
		mreg[20]<=32'd0;
		mreg[21]<=32'd0;
		mreg[22]<=32'd0;
		mreg[23]<=32'd0;
		mreg[24]<=32'd0;
		mreg[25]<=32'd0;
		mreg[26]<=32'd0;
		mreg[27]<=32'd0;
		mreg[28]<=32'd0;
		mreg[29]<=32'd0;
		mreg[30]<=32'd0;
		mreg[31]<=32'd0;
	end
	
	else
	begin
		if (write_reg==1'b1)
		begin
			if(rd_addr==5'd0)
			begin
				mreg[rd_addr]<=32'd0;
			end
			else
			begin
				mreg[rd_addr]<=write_data;
			end
		end
		else
		mreg<=mreg;
	end

end

always_comb
begin:read_register_data
	begin
		if(read_reg)
		begin
			rs1_data=mreg[rs1_addr];
			rs2_data=mreg[rs2_addr];	
		end
		else
		begin
			rs1_data=mreg[rs1_addr];
			rs2_data=mreg[rs2_addr];
		end
	end
end





endmodule
