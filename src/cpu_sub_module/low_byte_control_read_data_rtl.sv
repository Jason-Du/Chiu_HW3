 `timescale 1ns/10ps
 
 module low_byte_control_read_data(
									memout,
									reminder,
									memout_low_byte,
									
									read_mem_data
									);
 parameter DATA_SIZE  =32;
 
 output logic [DATA_SIZE-1:0] read_mem_data;
 
 input        [DATA_SIZE-1:0] memout;
 input        [DATA_SIZE-1:0] reminder;
 input                        memout_low_byte;
 
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
 
 endmodule