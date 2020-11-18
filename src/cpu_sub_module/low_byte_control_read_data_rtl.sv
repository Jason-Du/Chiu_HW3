 `timescale 1ns/10ps
 
 module low_byte_control_read_data(
									memout,
									//reminder,
									memout_low_byte,
									memout_half_word,
									padding_zero,
									
									read_mem_data
									);
 parameter DATA_SIZE  =32;
 
 output logic [DATA_SIZE-1:0] read_mem_data;
 
 input        [DATA_SIZE-1:0] memout;
 //input        [DATA_SIZE-1:0] reminder;
 input                        memout_low_byte;
 input					      memout_half_word;
 input                        padding_zero;
 logic                        code_situation;
 always_comb
 begin
	code_situation={memout_low_byte,memout_half_word,padding_zero};
	case(code_situation)
		3'b000:
		begin
			read_mem_data=memout;
		end
		3'b010://LH
		begin
			read_mem_data=32'(signed'(memout[15:0]));
		end
		3'b011://LHU
		begin
			read_mem_data={16'd0,memout[15:0]};
		end
		3'b100://LB
		begin
			read_mem_data=32'(signed'(memout[7:0]));
		end
		3'b101://LBU
		begin
			read_mem_data={24'd0,memout[7:0]};
		end
		default
		begin
			read_mem_data=32'd0;
		end
	endcase
 end
 
/*
 always_comb
 begin
	if(memout_low_byte==1'b0)
	begin
		read_mem_data=memout;
	end
	else
	begin
		case(reminder)
			32'd0:
			begin
				read_mem_data=32'(signed'(memout[7:0]));
			end
			32'd1:
			begin
				read_mem_data=32'(signed'(memout[15:8]));
			end
			32'd2:
			begin
				read_mem_data=32'(signed'(memout[23:16]));
			end
			32'd3:
			begin
				read_mem_data=32'(signed'(memout[31:24]));
			end
			default:
			begin
				read_mem_data=32'd0;
			end
		endcase
	end
 end
 */
 endmodule