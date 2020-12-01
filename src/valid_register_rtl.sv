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

output logic       valid_data;
logic        valid_register_single[63:0] ;
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			
			valid_register_single[0]<=1'b0;
			valid_register_single[1]<=1'b0;
			valid_register_single[2]<=1'b0;
			valid_register_single[3]<=1'b0;
			valid_register_single[4]<=1'b0;
			valid_register_single[5]<=1'b0;
			valid_register_single[6]<=1'b0;
			valid_register_single[7]<=1'b0;
			valid_register_single[8]<=1'b0;
			valid_register_single[9]<=1'b0;
			valid_register_single[10]<=1'b0;
			valid_register_single[11]<=1'b0;
			valid_register_single[12]<=1'b0;
			valid_register_single[13]<=1'b0;
			valid_register_single[14]<=1'b0;
			valid_register_single[15]<=1'b0;
			valid_register_single[16]<=1'b0;
			valid_register_single[17]<=1'b0;
			valid_register_single[18]<=1'b0;
			valid_register_single[19]<=1'b0;
			valid_register_single[20]<=1'b0;
			valid_register_single[21]<=1'b0;
			valid_register_single[22]<=1'b0;
			valid_register_single[23]<=1'b0;
			valid_register_single[24]<=1'b0;
			valid_register_single[25]<=1'b0;
			valid_register_single[26]<=1'b0;
			valid_register_single[27]<=1'b0;
			valid_register_single[28]<=1'b0;
			valid_register_single[29]<=1'b0;
			valid_register_single[30]<=1'b0;
			valid_register_single[31]<=1'b0;
			valid_register_single[32]<=1'b0;
			valid_register_single[33]<=1'b0;
			valid_register_single[34]<=1'b0;
			valid_register_single[35]<=1'b0;
			valid_register_single[36]<=1'b0;
			valid_register_single[37]<=1'b0;
			valid_register_single[38]<=1'b0;
			valid_register_single[39]<=1'b0;
			valid_register_single[40]<=1'b0;
			valid_register_single[41]<=1'b0;
			valid_register_single[42]<=1'b0;
			valid_register_single[43]<=1'b0;
			valid_register_single[44]<=1'b0;
			valid_register_single[45]<=1'b0;
			valid_register_single[46]<=1'b0;
			valid_register_single[47]<=1'b0;
			valid_register_single[48]<=1'b0;
			valid_register_single[49]<=1'b0;
			valid_register_single[50]<=1'b0;
			valid_register_single[51]<=1'b0;
			valid_register_single[52]<=1'b0;
			valid_register_single[53]<=1'b0;
			valid_register_single[54]<=1'b0;
			valid_register_single[55]<=1'b0;
			valid_register_single[56]<=1'b0;
			valid_register_single[57]<=1'b0;
			valid_register_single[58]<=1'b0;
			valid_register_single[59]<=1'b0;
			valid_register_single[60]<=1'b0;
			valid_register_single[61]<=1'b0;
			valid_register_single[62]<=1'b0;
			valid_register_single[63]<=1'b0;
		end
		else
		begin
			if(valid_write)
			begin
				valid_register_single[valid_addr]<=1'b1;
			end
			else
				valid_register_single<=valid_register_single;
		end
	end
	always_comb
	begin
		if(valid_read)
		begin
			valid_data=valid_register_single[valid_addr];
		end
		else
		begin
			valid_data=1'b0;
		end
	end
	
endmodule
