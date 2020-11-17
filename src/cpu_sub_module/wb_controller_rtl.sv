`timescale 1ns/10ps

module wb_controller(
					alu_rd_data,
					read_mem_data,
					wb_control,
					
					wb_data

						);
parameter DATA_SIZE  =32;

output logic [DATA_SIZE-1:0] wb_data;

input        [DATA_SIZE-1:0] alu_rd_data;
input        [DATA_SIZE-1:0] read_mem_data;
input                        wb_control;

always_comb
begin
	wb_data=(wb_control)?read_mem_data:alu_rd_data;
end
endmodule