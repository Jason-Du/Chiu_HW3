 `timescale 1ns/10ps
module valid_register(
					clk,
					rst,
					valid_addr,
					valid_write,
					valid_read,
					
					
					valid_data
						);
input              clk;
input              rst;
input              valid_write;
input              valid_read;
input        [5:0] valid_addr;

//output logic [5:0] valid_data;
output logic       valid_data;
//logic        valid_register [5:0] ;
logic  [5:0] valid_register;
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			valid_register<=64'd0
			/*
			valid_register[0]<=1'b0;
			valid_register[1]<=1'b0;
			valid_register[2]<=1'b0;
			valid_register[3]<=1'b0;
			valid_register[4]<=1'b0;
			valid_register[5]<=1'b0;
			valid_register[6]<=1'b0;
			valid_register[7]<=1'b0;
			valid_register[8]<=1'b0;
			valid_register[9]<=1'b0;
			valid_register[10]<=1'b0;
			valid_register[11]<=1'b0;
			valid_register[12]<=1'b0;
			valid_register[13]<=1'b0;
			valid_register[14]<=1'b0;
			valid_register[15]<=1'b0;
			valid_register[16]<=1'b0;
			valid_register[17]<=1'b0;
			valid_register[18]<=1'b0;
			valid_register[19]<=1'b0;
			valid_register[20]<=1'b0;
			valid_register[21]<=1'b0;
			valid_register[22]<=1'b0;
			valid_register[23]<=1'b0;
			valid_register[24]<=1'b0;
			valid_register[25]<=1'b0;
			valid_register[26]<=1'b0;
			valid_register[27]<=1'b0;
			valid_register[28]<=1'b0;
			valid_register[29]<=1'b0;
			valid_register[30]<=1'b0;
			valid_register[31]<=1'b0;
			valid_register[32]<=1'b0;
			valid_register[33]<=1'b0;
			valid_register[34]<=1'b0;
			valid_register[35]<=1'b0;
			valid_register[36]<=1'b0;
			valid_register[37]<=1'b0;
			valid_register[38]<=1'b0;
			valid_register[39]<=1'b0;
			valid_register[40]<=1'b0;
			valid_register[41]<=1'b0;
			valid_register[42]<=1'b0;
			valid_register[43]<=1'b0;
			valid_register[44]<=1'b0;
			valid_register[45]<=1'b0;
			valid_register[46]<=1'b0;
			valid_register[47]<=1'b0;
			valid_register[48]<=1'b0;
			valid_register[49]<=1'b0;
			valid_register[50]<=1'b0;
			valid_register[51]<=1'b0;
			valid_register[52]<=1'b0;
			valid_register[53]<=1'b0;
			valid_register[54]<=1'b0;
			valid_register[55]<=1'b0;
			valid_register[56]<=1'b0;
			valid_register[57]<=1'b0;
			valid_register[58]<=1'b0;
			valid_register[59]<=1'b0;
			valid_register[60]<=1'b0;
			valid_register[61]<=1'b0;
			valid_register[62]<=1'b0;
			valid_register[63]<=1'b0;
			*/
		end
		else
		begin
			if(valid_write)
			begin
				valid_register[valid_addr]<=1'b0;
			end
			else
				valid_register<=valid_register;
		end
	end
	always_comb
	begin
		if(rst)
		begin
			//valid_data=64'd0;
			valid_data=1'd0;
		end
		else
		begin
			if(valid_read)
			begin
				//valid_data=valid_register;
				valid_data=valid_register[addr];
			end
			else
			begin
				//valid_data=64'd0;
				valid_data=1'd0;
			end
		end
	end
	
endmodule