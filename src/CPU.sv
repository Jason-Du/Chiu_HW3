`timescale 1ns/10ps
`include "./cpu_sub_module/pc_controller_rtl.sv"
`include "./cpu_sub_module/pause_pc_controller_rtl.sv"
`include "./cpu_sub_module/pause_instruction_controller_rtl.sv"
`include "./cpu_sub_module/decoder_rtl.sv"
`include "./cpu_sub_module/control_rtl.sv"
`include "./cpu_sub_module/register_rtl.sv"
`include "./cpu_sub_module/imm_extended_rtl.sv"
`include "./cpu_sub_module/if_id_rst_controller_rtl.sv"
`include "./cpu_sub_module/id_exe_rst_controller_rtl.sv"
`include "./cpu_sub_module/exe_mem_rst_controller_rtl.sv"
`include "./cpu_sub_module/alu_rd_rtl.sv"
`include "./cpu_sub_module/alu_in_selector_rtl.sv"
`include "./cpu_sub_module/alu_addr_rtl.sv"
`include "./cpu_sub_module/alu_pc_rtl.sv"
`include "./cpu_sub_module/load_hazard_rtl.sv"
`include "./cpu_sub_module/divider4_rtl.sv"
`include "./cpu_sub_module/low_byte_control_write_data_rtl.sv"
`include "./cpu_sub_module/low_byte_control_read_data_rtl.sv"
`include "./cpu_sub_module/wb_controller_rtl.sv"
`include "./cpu_sub_module/forwarding_unit_rtl.sv"
module CPU(
			clk,
			rst,
			im_dataout,
			dm_dataout,
			cpu_stall,
			im_core_type,

			im_addr,
			im_read_mem,

			//dm_web,
			dm_core_type,
			dm_addr,
			dm_datain,
			dm_write_mem,
			dm_read_mem,
			
				);
 
localparam DATA_SIZE  =32;

input                        clk;
input                        rst;
input        [DATA_SIZE-1:0] im_dataout;
input        [DATA_SIZE-1:0] dm_dataout;
input						 cpu_stall;

  
  
  
output logic [         31:0] im_addr;
//output logic [          3:0] dm_web;
output logic [         31:0] dm_addr;
output logic [DATA_SIZE-1:0] dm_datain;
output logic                 dm_write_mem;
output logic                 dm_read_mem;

//output logic                 im_write_mem;
output logic                 im_read_mem;
output logic [          2:0] im_core_type;
output logic [          2:0] dm_core_type;

logic        [DATA_SIZE-1:0] pc_data;
logic        [DATA_SIZE-1:0] next_pc;
logic        [DATA_SIZE-1:0] pc_register_out;
logic        [DATA_SIZE-1:0] instruction;
logic        [         63:0] stage1_register_in;
logic        [         63:0] stage1_register_out;
logic        [         19:0] imm_u_data;
logic        [         19:0] imm_j_data;
logic        [         11:0] imm_b_data;
logic        [         11:0] imm_i_data;
logic        [         11:0] imm_s_data;
logic        [          4:0] rs1_addr;
logic        [          4:0] rs2_addr;
logic        [          4:0] rd_addr;
logic        [          2:0] funt3;
logic        [          6:0] funt7;
logic        [          6:0] op_code;
logic                        read_reg;
logic                        write_reg;
logic                        memout_low_byte;
logic                        memin_low_byte;
logic                        wb_control;
logic                        write_mem;
logic                        read_mem;
logic                        enable_jump;
logic        [          4:0] alu_rd_control;
logic        [          2:0] alu_pc_control;
logic        [          2:0] imm_control;
logic        [DATA_SIZE-1:0] rs1_data;
logic        [DATA_SIZE-1:0] rs2_data;
logic        [DATA_SIZE-1:0] imm_data;
logic                        if_id_rst;
logic                        id_exe_rst;
logic        [        157:0] stage2_register_in;
logic        [        157:0] stage2_register_out;
logic        [DATA_SIZE-1:0] src1_data;
logic        [DATA_SIZE-1:0] src2_data;
logic        [DATA_SIZE-1:0] alu_rd_data;
logic        [DATA_SIZE-1:0] alu_addr_data;
logic        [DATA_SIZE-1:0] pc_jump_address;
logic                        id_exe_rst_data;					
logic                        if_id_rst_data;
logic                        pc_jump_control;
logic                        pc_stall;
//logic                        instruction_stall;
logic        [        142:0] stage3_register_in;
logic        [        142:0] stage3_register_out;
logic        [DATA_SIZE-1:0] reminder;
logic        [DATA_SIZE-1:0] quotient;
logic        [          3:0] web_data;
logic        [DATA_SIZE-1:0] read_mem_data;
logic        [DATA_SIZE-1:0] wb_data;
logic        [         37:0] stage4_register_in;
logic        [         37:0] stage4_register_out;
logic                        rs1_exe_hazard;
logic                        rs1_mem_hazard;
logic                        rs2_exe_hazard;
logic                        rs2_mem_hazard;
logic                        exe_mem_rst;
logic        [DATA_SIZE-1:0] pc_stage1_register;
logic                 instruction_stall;
//logic        [         13:0] im_addr0;
logic        [         31:0] im_dataout_data;
logic                        write_reg_bus;

//DEBUG







pc_controller ptl(.pc(pc_register_out),
				  .next_pc(next_pc),
				  .pc_jump_address(stage3_register_out[31:0]),
				  .pc_jump_control(stage3_register_out[133]),
				  .pc_stall(pc_stall),
				  .enable_jump(stage3_register_out[141]),
				  .cpu_stall(cpu_stall),		

				  .pc_data(pc_data)
					);

always_ff@(posedge clk or posedge rst)
begin:pc_id
	if (rst)
	begin
		pc_register_out<=32'd0;
	end
	else
	begin
		pc_register_out<=pc_data;
	end
end
always_comb
begin:if_comb
	im_read_mem=(instruction_stall)?1'b0:1'b1;
	next_pc=pc_register_out+32'd4;
	//unsigned'(mem_addr)>>2
	//im_addr=unsigned'(pc_register_out)>>2;
	im_addr=pc_register_out;
	//im_cs=1'b1;
	//im_oe=1'b1;
	//im_web=4'b1111;
	//im_datain=32'd0;
	im_dataout_data=rst?32'd0:im_dataout;
	stage1_register_in=(cpu_stall||instruction_stall)?stage1_register_out:(if_id_rst?64'd0:{im_dataout_data,pc_register_out});
end
if_id_rst_controller ifidrst(
					.local_rst(stage3_register_out[134]),
					.pc_jump_control(stage3_register_out[133]),
					.enable_jump(stage3_register_out[141]),
					.rst_data(if_id_rst)
					);

always_ff@(posedge clk or posedge rst)
begin:if_id
	if(rst==1'b1)
	begin
		stage1_register_out<=64'd0;
	end
	else
	begin
		stage1_register_out<=stage1_register_in;
	end
end
always_comb
begin:id_comb
	stage2_register_in=(cpu_stall)?stage2_register_out:(id_exe_rst?158'd0:{
						wb_control,
						enable_jump,
						write_reg,
						write_mem,
						read_mem,
						memin_low_byte,
						memout_low_byte,
						alu_pc_control,
						alu_rd_control,
						rs1_addr,
						rs2_addr,
						rd_addr,					
						rs1_data,
						rs2_data,
						imm_data,
						stage1_register_out[31:0]
						});	
	write_reg_bus=cpu_stall?1'b0:stage3_register_out[140];
end
decoder dc(
			.instruction(stage1_register_out[63:32]),
			
			.imm_u_data(imm_u_data),
			.imm_j_data(imm_j_data),
			.imm_b_data(imm_b_data),
			.imm_i_data(imm_i_data),
			.imm_s_data(imm_s_data),
			.rs1_addr(rs1_addr),
			.rs2_addr(rs2_addr),
			.rd_addr(rd_addr),
			.funt3(funt3),
			.funt7(funt7),
			.op_code(op_code)
			);
control cl(
			.funt3(funt3),
			.funt7(funt7),
			.immi_data(imm_i_data),
			.op_code(op_code),
			
			.read_reg(read_reg),
			.write_reg(write_reg),
			.memin_low_byte(memin_low_byte),
			.memout_low_byte(memout_low_byte),
			.alu_rd_control(alu_rd_control),
			.alu_pc_control(alu_pc_control),
			.wb_control(wb_control),
			.imm_control(imm_control),
			.write_mem(write_mem),
			.read_mem(read_mem),
			.enable_jump(enable_jump)
				);
register rigt(
			.rs1_addr(rs1_addr),
			.rs2_addr(rs2_addr),
			//.rd_addr(stage4_register_out[36:32]),
			.rd_addr(stage3_register_out[132:128]),
			.clk(clk),
			.rst(rst),
			.read_reg(read_reg),
			
			//.write_reg(stage3_register_out[140]),
			.write_reg(write_reg_bus),
			.write_data(wb_data),
			//.write_reg(stage4_register_out[37]),
			//.write_data(stage4_register_out[31:0]),
			
			
			.rs1_data(rs1_data),
			.rs2_data(rs2_data)
				);
/*
		stage4_register_in={
					stage3_register_out[140],
					stage3_register_out[132:128],
					wb_data
					};
*/
imm_extended iex(
					.imm_i_data(imm_i_data),
					.imm_b_data(imm_b_data),
					.imm_s_data(imm_s_data),
					.imm_j_data(imm_j_data),
					.imm_u_data(imm_u_data),
					.imm_extended_control(imm_control),
					
					.imm_data(imm_data)
					);
	//modify
id_exe_rst_controller idexerst(
				.local_rst(stage3_register_out[135]),
				.pc_jump_control(stage3_register_out[133]),
				.pc_stall(pc_stall),
				.enable_jump(stage3_register_out[141]),			
				.rst_data(id_exe_rst)
				);

always_ff@(posedge clk or posedge rst)
begin:id_exe
	if(rst==1'b1)
	begin
		stage2_register_out<=158'd0;
	end
	else
	begin
		stage2_register_out<=stage2_register_in;
	end
end
always_comb
begin:exe_comb
	stage3_register_in=(cpu_stall)?stage3_register_out:(exe_mem_rst?143'd0:{
					stage2_register_out[157],
					stage2_register_out[156],
					stage2_register_out[155],
					stage2_register_out[154],
					stage2_register_out[153],
					stage2_register_out[152],
					stage2_register_out[151],
					id_exe_rst_data,
					if_id_rst_data,
					pc_jump_control,
					stage2_register_out[132:128],
					alu_addr_data,
					alu_rd_data,
					src2_data,
					pc_jump_address
					});
end

alu_in_selector ais(
						.rs1_data(stage2_register_out[127:96]),
						.rs2_data(stage2_register_out[95:64]),
						.rs1_exe_hazard(rs1_exe_hazard),
						.rs1_mem_hazard(rs1_mem_hazard),
						.rs2_exe_hazard(rs2_exe_hazard),
						.rs2_mem_hazard(rs2_mem_hazard),
						.mem_data(stage4_register_out[31:0]),
						.exe_data(stage3_register_out[95:64]),
						
						.src1_data(src1_data),
						.src2_data(src2_data)
						 
						);	
alu_rd ard(
			.src1(src1_data),
			.src2(src2_data),
			.imm_data(stage2_register_out[63:32]),
			.pc(stage2_register_out[31:0]),
			.alu_rd_control(stage2_register_out[147:143]),
			
			.alu_rd_data(alu_rd_data)
			);
			
alu_addr adr(
			.src1(src1_data),
			.imm_data(stage2_register_out[63:32]),
			
			.alu_addr_out(alu_addr_data)
			);
alu_pc apc(
				.alu_pc_control(stage2_register_out[150:148]),
				.imm_data(stage2_register_out[63:32]),
				.src1(src1_data),
				.src2(src2_data),
				.pc(stage2_register_out[31:0]),
				.enable_jump(stage2_register_out[156]),
				
				.pc_jump_address(pc_jump_address),
				.id_exe_rst(id_exe_rst_data),
				.if_id_rst(if_id_rst_data),
				.pc_jump_control(pc_jump_control)
				);
load_hazard lhd(
				.if_id_rs1_addr(rs1_addr),
				.if_id_rs2_addr(rs2_addr),
				.id_exe_rd_addr(stage2_register_out[132:128]),
				.id_exe_read_mem(stage2_register_out[153]),
				
				.pc_stall(pc_stall),
				.instruction_stall(instruction_stall),
				.pc_jump_confirm(stage3_register_out[133]),
				);
forwarding_unit fwu(
					.exe_mem_write_reg(stage3_register_out[140]),
					.mem_wb_write_reg(stage4_register_out[37]),
					.exe_mem_rd_addr(stage3_register_out[132:128]),
					.mem_wb_rd_addr(stage4_register_out[36:32]),
					.rs1_addr(stage2_register_out[142:138]),
					.rs2_addr(stage2_register_out[137:133]),
					
					.rs1_exe_hazard(rs1_exe_hazard),
					.rs1_mem_hazard(rs1_mem_hazard),
					.rs2_exe_hazard(rs2_exe_hazard),
					.rs2_mem_hazard(rs2_mem_hazard)
					);
	//modify
exe_mem_rst_controller exememrst(
					.local_rst(stage3_register_out[134]),
					.pc_jump_control(stage3_register_out[133]),
					.enable_jump(stage3_register_out[141]),				
					.rst_data(exe_mem_rst)
					);

always_ff@(posedge clk or posedge rst)
begin:exe_mem
	if(rst==1'b1)
	begin
		stage3_register_out<=143'd0;
	end
	else
	begin
		stage3_register_out<=stage3_register_in;
	end
end

always_comb
begin:mem_comb
	//dm_oe=stage3_register_out[138];
	//dm_cs=1'b1;
	dm_read_mem=stage3_register_out[138];
	dm_write_mem=stage3_register_out[139];
	//dm_addr={16'h0001,2'b00,quotient[13:0]};
	dm_addr=stage3_register_out[127:96];
	dm_web=(stage3_register_out[139])?web_data:4'b1111;
	stage4_register_in=(cpu_stall)?stage4_register_out:{
					stage3_register_out[140],
					stage3_register_out[132:128],
					wb_data
					};
end
divider4 div4(
			.mem_addr(stage3_register_out[127:96]),
			
			.reminder(reminder),
			.quotient(quotient)
			);

low_byte_control_write_data lwd(
							.src2(stage3_register_out[63:32]),
							.memin_low_byte(stage3_register_out[137]),
							.reminder(reminder),
							
							.write_data(dm_datain),
							.web(web_data)
							);

low_byte_control_read_data lrd(
							.memout(dm_dataout),
							.reminder(reminder),
							.memout_low_byte(stage3_register_out[136]),
							
							.read_mem_data(read_mem_data)
							);
wb_controller wbc(
				.alu_rd_data(stage3_register_out[95:64]),
				.read_mem_data(read_mem_data),
				.wb_control(stage3_register_out[142]),
				
				.wb_data(wb_data)
					);
	//modify



always_ff@(posedge clk or posedge rst)
begin
	if(rst==1'b1)
	begin
		stage4_register_out<=38'd0;
	end
	else
	begin
		stage4_register_out<=stage4_register_in;
	end
end


endmodule
