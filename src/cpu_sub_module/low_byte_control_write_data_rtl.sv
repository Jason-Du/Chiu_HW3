 `timescale 1ns/10ps
 module low_byte_control_write_data(
									src2,
									memin_low_byte,
									memin_half_word,
									mem_address,
									
									write_data,
									core_type,
									web
									);
 
localparam DATA_SIZE  =32;
 
 input        [DATA_SIZE-1:0] src2;
 input                        memin_low_byte;
 input 						  memin_half_word;
 input        [DATA_SIZE-1:0] mem_address;
 
 output logic [DATA_SIZE-1:0] write_data;
 output logic [          2:0] core_type;
 output logic [          3:0] web;
 logic        [          1:0] code_situation;
 
 
 always_comb
 begin
	code_situation={memin_low_byte,memin_half_word};
	case(code_situation)
		2'b00:
		begin
			web       =4'b0000;
			write_data=src2;
			core_type =3'b010;
		end
		2'b10:
		begin
			case(mem_address[1:0])		
			2'b00:
			begin
				web=4'b1110;
				//web=4'b0111;
				write_data={24'd0,src2[7:0]};
				core_type =3'b000;	
			end
			2'b01:
			begin
				web=4'b1101;
				//web=4'b1011;
				core_type =3'b000;
				write_data={16'd0,src2[7:0],8'd0};			
			end
			2'b10:
			begin
				web=4'b1011;
				core_type =3'b100;
				write_data={8'd0,src2[7:0],16'd0};	
			end
			2'b11:
			begin
				web=4'b0111;
				core_type =3'b100;
				write_data={src2[7:0],24'd0};
			end
			endcase
		end
		2'b01:
		begin
			core_type =(mem_address[1]==1'b0)?3'b001:3'b101;
			web       =(mem_address[1]==1'b0)?4'b1100:4'b0011;
			write_data=(mem_address[1]==1'b0)?{16'd0,src2[15:0]}:{src2[15:0],16'd0};
		end
		2'b11:
		begin
			core_type=3'b010;
			web=4'b1111;
			write_data=32'd0;
		end
	endcase
 end
 endmodule
