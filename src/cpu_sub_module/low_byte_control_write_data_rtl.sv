 `timescale 1ns/10ps
 module low_byte_control_write_data(
									src2,
									memin_low_byte,
									reminder,
									
									write_data,
									web
									);
 
 parameter DATA_SIZE  =32;
 
 input        [DATA_SIZE-1:0] src2;
 input        [DATA_SIZE-1:0] reminder;
 input                        memin_low_byte;
 
 
 output logic [DATA_SIZE-1:0] write_data;
 output logic [          3:0] web;
 always_comb
 begin
	if (memin_low_byte==1'b0)
	begin
		web=4'b0000;
		write_data=src2;
	end
	else
	begin
		case(reminder)			
			32'd0:
			begin
				web=4'b1110;
				//web=4'b0111;
				write_data={24'd0,src2[7:0]};
						
			end
			32'd1:
			begin
				web=4'b1101;
				//web=4'b1011;
				write_data={16'd0,src2[7:0],8'd0};			
			end
			32'd2:
			begin
				web=4'b1011;
				write_data={8'd0,src2[7:0],16'd0};	
			end
			32'd3:
			begin
				web=4'b0111;
				write_data={src2[7:0],24'd0}	;
				
			end
			default:
			begin
				web=4'b1111;
				write_data=32'd0;
			end
			
		endcase
	end
 
 end
 endmodule