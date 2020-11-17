
module alu_rd(
				src1,
				src2,
				imm_data,
				pc,
				alu_rd_control,
				
				alu_rd_data
				);
				
parameter DATA_SIZE  =32;

input        [DATA_SIZE-1:0] src1;
input        [DATA_SIZE-1:0] src2;
input        [DATA_SIZE-1:0] imm_data;
input        [DATA_SIZE-1:0] pc;
input        [          4:0] alu_rd_control;

output logic [DATA_SIZE-1:0] alu_rd_data;
logic        [DATA_SIZE-1:0] src1_signed;
logic        [DATA_SIZE-1:0] src2_signed;
logic        [DATA_SIZE-1:0] imm_data_signed;
always_comb
begin
	src1_signed    = src1;
	src2_signed    = src2;
	imm_data_signed= imm_data;
	
	case(alu_rd_control)
		//R type
		5'd0:
		begin
			alu_rd_data=signed'(src1_signed)+signed'(src2_signed);
		end
		5'd1:
		begin
			alu_rd_data=signed'(src1_signed)-signed'(src2_signed);
		end
		5'd2:
		begin
			alu_rd_data= unsigned'(src1)<<src2[4:0];
		end
		5'd3:
		begin
			alu_rd_data=(signed'(src1_signed)<signed'(src2_signed))?32'd1:32'd0;
		end
		5'd4:
		begin
			alu_rd_data=(unsigned'(src1)<unsigned'(src2))?32'd1:32'd0;
		end
		5'd5:
		begin
			alu_rd_data=src1 ^ src2;
		end
		5'd6:
		begin
			alu_rd_data=unsigned'(src1)>>src2[4:0];
		end
		5'd7:
		begin
			alu_rd_data=signed'(src1_signed)>>>src2[4:0];
		end
		5'd8:
		begin
			alu_rd_data=src1 | src2;
		end
		5'd9:
		begin
			alu_rd_data=src1 & src2;
		end
		// I type
		5'd10:
		begin
			alu_rd_data=signed'(src1_signed)+signed'(imm_data_signed);
		end
		5'd11:
		begin
			alu_rd_data=(signed'(src1_signed)<signed'(imm_data_signed))?1:0;
		end
		5'd12:
		begin
			alu_rd_data=(unsigned'(src1)<unsigned'(imm_data))?1:0;
		end
		5'd13:
		begin
			alu_rd_data=src1 ^ imm_data;
		end
		5'd14:
		begin
			alu_rd_data=src1 | imm_data;
		end
		5'd15:
		begin
			alu_rd_data=src1 & imm_data;
		end
		5'd16:
		begin
			alu_rd_data=unsigned'(src1)<<imm_data[4:0];
		end
		5'd17:
		begin
			alu_rd_data=unsigned'(src1)>>imm_data[4:0];
		end
		5'd18:
		begin
			alu_rd_data=signed'(src1_signed)>>>imm_data[4:0];
		end
		5'd19:
		begin
			alu_rd_data=pc+32'd4;
		end
		// U type
		5'd20:
		begin
			alu_rd_data=unsigned'(pc)+unsigned'(imm_data);
		end
		5'd21:
		begin
			alu_rd_data=unsigned'(imm_data);
		end
		5'd22:
		begin
			alu_rd_data=pc+32'd4;
		end
		default:
		begin
			alu_rd_data=32'd0;
		end
	endcase
end

endmodule