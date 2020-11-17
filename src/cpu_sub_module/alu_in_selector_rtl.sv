 `timescale 1ns/10ps
 module alu_in_selector(
						rs1_data,
						rs2_data,
						rs1_exe_hazard,
						rs1_mem_hazard,
						rs2_exe_hazard,
						rs2_mem_hazard,
						mem_data,
						exe_data,
						
						src1_data,
						src2_data
						 
						);
parameter DATA_SIZE  =32;
						
input        [DATA_SIZE-1:0] rs1_data;
input        [DATA_SIZE-1:0] rs2_data;
input        [DATA_SIZE-1:0] mem_data;
input        [DATA_SIZE-1:0] exe_data;
input                        rs1_exe_hazard;
input                        rs1_mem_hazard;
input                        rs2_exe_hazard;
input                        rs2_mem_hazard;

output logic [DATA_SIZE-1:0] src1_data;
output logic [DATA_SIZE-1:0] src2_data;

logic        [          1:0] rs1_hazard_control;
logic        [          1:0] rs2_hazard_control;


always_comb
begin
	rs1_hazard_control={rs1_exe_hazard,rs1_mem_hazard};
	case(rs1_hazard_control)
		2'b00:
		begin
			src1_data=rs1_data;
		end
		2'b01:
		begin
			src1_data=mem_data;
		end
		2'b10:
		begin
			src1_data=exe_data;
		end
		2'b11:
		begin
			src1_data=exe_data;
		end
	endcase
end
always_comb
begin
	rs2_hazard_control={rs2_exe_hazard,rs2_mem_hazard};
	case(rs2_hazard_control)
		2'b00:
		begin
			src2_data=rs2_data;
		end
		2'b01:
		begin
			src2_data=mem_data;
		end
		2'b10:
		begin
			src2_data=exe_data;
		end
		2'b11:
		begin
			src2_data=exe_data;
		end
	endcase
end
endmodule