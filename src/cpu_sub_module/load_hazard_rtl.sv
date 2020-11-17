 `timescale 1ns/10ps
 module load_hazard(
					if_id_rs1_addr,
					if_id_rs2_addr,
					id_exe_rd_addr,
					id_exe_read_mem,
					
					pc_stall,
					instruction_stall,
					pc_jump_confirm,
					bus_stall
					);
					
output logic        pc_stall;
output logic       instruction_stall;

input        [4:0] if_id_rs1_addr;
input        [4:0] if_id_rs2_addr;
input        [4:0] id_exe_rd_addr;
input  					bus_stall;
input              id_exe_read_mem;
input              pc_jump_confirm;
logic              pc_stall_stage1;
always_comb
begin
	//pc_stall=(id_exe_read_mem==1'b1 && (if_id_rs1_addr==id_exe_rd_addr || if_id_rs2_addr==id_exe_rd_addr))?1'b1:1'b0;
	//instruction_stall=pc_stall;
	pc_stall_stage1=(id_exe_read_mem==1'b1 && (if_id_rs1_addr==id_exe_rd_addr || if_id_rs2_addr==id_exe_rd_addr))?1'b1:1'b0;
	pc_stall=pc_jump_confirm?1'b0:pc_stall_stage1;
	//pc_stall=bus_stall?1'b0:(pc_jump_confirm?1'b0:pc_stall_stage1);
	instruction_stall=pc_stall;
end
endmodule