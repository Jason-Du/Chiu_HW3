 `timescale 1ns/10ps
 module imm_extended(
						imm_i_data,
						imm_b_data,
						imm_s_data,
						imm_j_data,
						imm_u_data,
						imm_extended_control,
						
						imm_data
						);
					
parameter DATA_SIZE  =32;		


input        [         11:0] imm_i_data;
input        [         11:0] imm_b_data;
input        [         11:0] imm_s_data;
input        [         19:0] imm_j_data;
input        [         19:0] imm_u_data;
input        [          2:0] imm_extended_control;

output logic [DATA_SIZE-1:0] imm_data;
logic        [         11:0] imm_i_data_signed;

always_comb
begin:extended_imm_block
	imm_i_data_signed=imm_i_data;
	case(imm_extended_control)
	//I
		3'd0:
		begin
			imm_data=32'(unsigned'(imm_i_data));
		end
		3'd1:
		begin
			imm_data=32'(signed'(imm_i_data_signed));
		end
	//S pass
		3'd2:
		begin
			imm_data=32'(signed'(imm_s_data));
		end
	//B
		3'd3:
		begin
			imm_data=32'(signed'({imm_b_data,1'b0}));
		end
	//U
		3'd4:
		begin
			imm_data={imm_u_data,12'd0};
		end
	//J pass
		3'd5:
		begin
			imm_data=32'(signed'({imm_j_data,1'b0}));
		end
		default:
		begin
			imm_data=32'd0;
		end
	endcase
end

endmodule