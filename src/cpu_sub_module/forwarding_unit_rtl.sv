 `timescale 1ns/10ps
 module forwarding_unit(
						exe_mem_write_reg,
						mem_wb_write_reg,
						exe_mem_rd_addr,
						mem_wb_rd_addr,
						rs1_addr,
						rs2_addr,
						
						rs1_exe_hazard,
						rs1_mem_hazard,
						rs2_exe_hazard,
						rs2_mem_hazard					
						);

	output logic      rs1_exe_hazard;
	output logic      rs1_mem_hazard;
	output logic      rs2_exe_hazard;
	output logic      rs2_mem_hazard;

	input       [4:0] rs1_addr;
	input       [4:0] rs2_addr;
	input       [4:0] exe_mem_rd_addr;
	input       [4:0] mem_wb_rd_addr;
	input             exe_mem_write_reg;
	input             mem_wb_write_reg;

	always_comb
	begin
		rs1_mem_hazard=(mem_wb_write_reg==1'b1 && mem_wb_rd_addr!=5'd0 && mem_wb_rd_addr==rs1_addr)?1'b1:1'b0;
		rs1_exe_hazard=(exe_mem_write_reg==1'b1 && exe_mem_rd_addr!=5'd0 && exe_mem_rd_addr==rs1_addr)?1'b1:1'b0;
		rs2_mem_hazard=(mem_wb_write_reg==1'b1 && mem_wb_rd_addr!=5'd0 && mem_wb_rd_addr==rs2_addr)?1'b1:1'b0;
		rs2_exe_hazard=(exe_mem_write_reg==1'b1 && exe_mem_rd_addr!=5'd0 && exe_mem_rd_addr==rs2_addr)?1'b1:1'b0;
	end
endmodule