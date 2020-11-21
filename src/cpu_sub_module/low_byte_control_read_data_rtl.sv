 `timescale 1ns/10ps
 
 module low_byte_control_read_data(
									memout,
									//reminder,
									mem_address,
									memout_low_byte,
									memout_half_word,
									padding_zero,
									
									read_mem_data
									);
 parameter DATA_SIZE  =32;
 
 output logic [DATA_SIZE-1:0] read_mem_data;
 
 input        [DATA_SIZE-1:0] memout;
 input        [DATA_SIZE-1:0] mem_address;
 //input        [DATA_SIZE-1:0] reminder;
 input                        memout_low_byte;
 input					      memout_half_word;
 input                        padding_zero;
 logic        [          2:0] code_situation;
 logic        [DATA_SIZE-1:0] memout_unsigned; 
 always_comb
 begin
	memout_unsigned=memout;
	code_situation={memout_low_byte,memout_half_word,padding_zero};
	case(code_situation)
		3'b000:
		begin
			read_mem_data=memout;
		end
		3'b010://LH
		begin
			read_mem_data=(mem_address[1]==1'b0)?32'(signed'(memout[15:0])):32'(signed'(memout[31:16]));
		end
		3'b011://LHU
		begin
			read_mem_data=(mem_address[1]==1'b0)?32'(unsigned'(memout_unsigned[15:0])):32'(unsigned'(memout_unsigned[31:16]));
		end
		3'b100://LB
		begin
			case(mem_address[1:0])
				2'b00:
				begin
					read_mem_data=32'(signed'(memout[7:0]));
				end
				2'b01:
				begin
					read_mem_data=32'(signed'(memout[15:8]));
				end
				2'b10:
				begin
					read_mem_data=32'(signed'(memout[23:16]));
				end
				2'b11:
				begin
					read_mem_data=32'(signed'(memout[31:24]));
				end
			endcase
		end
		3'b101://LBU
		begin
			case(mem_address[1:0])
				2'b00:
				begin
					read_mem_data=32'(unsigned'(memout_unsigned[7:0]));
				end
				2'b01:
				begin
					read_mem_data=32'(unsigned'(memout_unsigned[15:8]));
				end
				2'b10:
				begin
					read_mem_data=32'(unsigned'(memout_unsigned[23:16]));
				end
				2'b11:
				begin
					read_mem_data=32'(unsigned'(memout_unsigned[31:24]));
				end
			endcase
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
