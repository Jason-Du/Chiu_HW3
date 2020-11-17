`timescale 1ns/10ps
module control(
				funt3,
				funt7,
				immi_data,
				op_code,
				
				read_reg,
				write_reg,
				memin_low_byte,
				memout_low_byte,
				alu_rd_control,
				alu_pc_control,
				wb_control,
				imm_control,
				write_mem,
				read_mem,
				enable_jump
					);
					
	output logic        read_reg;
	output logic        write_reg;
	output logic        memout_low_byte;
	output logic        memin_low_byte;
	output logic        wb_control;
	output logic        write_mem;
	output logic        read_mem;
	output logic        enable_jump;
	output logic [ 4:0] alu_rd_control;
	output logic [ 2:0] alu_pc_control;
	output logic [ 2:0] imm_control;

	input        [ 2:0] funt3;
	input        [ 6:0] funt7;
	input        [11:0] immi_data;
	input        [ 6:0] op_code;

	always_comb 
	begin
		case(op_code)
			//Rtype
			7'b0110011:
			begin
				read_reg        = 1'b1;
				write_reg       = 1'b1;
				memin_low_byte  = 1'b0;
				memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b0;
				read_mem        = 1'b0;
				enable_jump     = 1'b0;
				//alu_rd_control  = 5'd0;
				alu_pc_control  = 3'd0;
				imm_control     = 3'd0;
				
				begin
					case(funt3)
						3'b000:
						begin
							alu_rd_control=(funt7==7'b0000000)?5'd0:5'd1;
						end
						3'b001:
						begin
							alu_rd_control=5'd2;
						end
						3'b010:
						begin
							alu_rd_control=5'd3;
						end
						3'b011:
						begin
							alu_rd_control=5'd4;
						end
						3'b100:
						begin
							alu_rd_control=5'd5;
						end
						3'b101:
						begin
							alu_rd_control=(funt7==7'b0000000)?5'd6:5'd7;
						end
						3'b110:
						begin
							alu_rd_control=5'd8;
						end
						3'b111:
						begin
							alu_rd_control=5'd9;
						end						
					endcase
				end
			end
			//I type
			7'b0000011:
			begin
				read_reg        = 1'b1;
				write_reg       = 1'b1;
				memin_low_byte  = 1'b0;
				wb_control      = 1'b1;
				write_mem       = 1'b0;
				read_mem        = 1'b1;
				alu_rd_control  = 5'd0;
				alu_pc_control  = 3'd0;
				imm_control     = 3'd1;
				enable_jump     = 1'b0;
				memout_low_byte = (funt3==3'b000)?1'b1:1'b0;
			end
			//I type
			7'b0010011:
			begin
				read_reg        = 1'b1;
				write_reg       = 1'b1;
				enable_jump     = 1'b0;
				memin_low_byte  = 1'b0;
				memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b0;
				read_mem        = 1'b0;
				//alu_rd_control  = 5'd0;
				alu_pc_control  = 3'd0;
				//imm_control     = 3'd1;
				case(funt3)
					3'b000:
					begin
						alu_rd_control=5'd10;
						imm_control   =3'd1;
					end
					3'b010:
					begin
						alu_rd_control=5'd11;
						imm_control   =3'd1;
					end			
					3'b011:
					begin
						alu_rd_control=5'd12;
						imm_control   =3'd1;
					end
					3'b100:
					begin
						alu_rd_control=5'd13;
						imm_control   =3'd1;
					end
					3'b110:
					begin
						alu_rd_control=5'd14;
						imm_control   =3'd1;
					end
					3'b111:
					begin
						alu_rd_control=5'd15;
						imm_control   =3'd1;
					end
					3'b001:
					begin
						alu_rd_control=5'd16;
						imm_control   =3'd0;
					end
					3'b101:
					begin
						alu_rd_control=(immi_data[11:5]==7'b0000000)?5'd17:5'd18;
						imm_control   =3'd0;
					end
				endcase
			end
			// I type
			7'b1100111:
			begin
				read_reg        = 1'b1;
				write_reg       = 1'b1;
				enable_jump     = 1'b1;
				memin_low_byte  = 1'b0;
				memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b0;
				read_mem        = 1'b0;
				alu_rd_control  = 5'd19;
				alu_pc_control  = 3'd0;
				imm_control     = 3'd1;			
			end
			// S type
			7'b0100011:
			begin
				read_reg        = 1'b1;
				write_reg       = 1'b0;
				enable_jump     = 1'b0;
				memout_low_byte  = 1'b0;
				//memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b1;
				read_mem        = 1'b0;
				alu_rd_control  = 5'd0;
				alu_pc_control  = 3'd0;
				imm_control     = 3'd2;
				memin_low_byte = (funt3==3'b000)?1'b1:1'b0;
			end
			// Btype
			7'b1100011:
			begin
				read_reg        = 1'b1;
				write_reg       = 1'b0;
				enable_jump     = 1'b1;
				memin_low_byte  = 1'b0;
				memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b0;
				read_mem        = 1'b0;
				alu_rd_control  = 5'd0;
				//alu_pc_control  = 3'd0;
				imm_control     = 3'd3;
				case(funt3)
					3'b000:
					begin
						alu_pc_control=3'd1;
					end
					3'b001:
					begin
						alu_pc_control=3'd2;
					end
					3'b100:
					begin
						alu_pc_control=3'd3;
					end
					3'b101:
					begin
						alu_pc_control=3'd4;
					end
					3'b110:
					begin
						alu_pc_control=3'd5;
					end
					3'b111:
					begin
						alu_pc_control=3'd6;
					end				
					default:
					begin
						alu_pc_control=3'd0;
					end
				endcase
			end
			//U-type
			7'b0010111:
			begin
				read_reg        = 1'b0;
				write_reg       = 1'b1;
				enable_jump     = 1'b0;
				memin_low_byte  = 1'b0;
				memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b0;
				read_mem        = 1'b0;
				alu_rd_control  = 5'd20;
				alu_pc_control  = 3'd0;
				imm_control     = 3'd4;			
			end
			//U-type
			7'b0110111:
			begin
				read_reg        = 1'b0;
				write_reg       = 1'b1;
				enable_jump     = 1'b0;
				memin_low_byte  = 1'b0;
				memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b0;
				read_mem        = 1'b0;
				alu_rd_control  = 5'd21;
				alu_pc_control  = 3'd0;
				imm_control     = 3'd4;			
			end
			//J-type
			7'b1101111:
			begin
				read_reg        = 1'b0;
				write_reg       = 1'b1;
				enable_jump     = 1'b1;
				memin_low_byte  = 1'b0;
				memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b0;
				read_mem        = 1'b0;
				alu_rd_control  = 5'd22;
				alu_pc_control  = 3'd7;
				imm_control     = 3'd5;				
			end
			default:
			begin
				read_reg        = 1'b0;
				write_reg       = 1'b0;
				enable_jump     = 1'b0;
				memin_low_byte  = 1'b0;
				memout_low_byte = 1'b0;
				wb_control      = 1'b0;
				write_mem       = 1'b0;
				read_mem        = 1'b0;
				alu_rd_control  = 5'd0;
				alu_pc_control  = 3'd0;
				imm_control     = 3'd0;
			end
		endcase
	end
endmodule
