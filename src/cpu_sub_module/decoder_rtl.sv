 `timescale 1ns/10ps
 module decoder(
				instruction,
				
				imm_u_data,
				imm_j_data,
				imm_b_data,
				imm_i_data,
				imm_s_data,
				rs1_addr,
				rs2_addr,
				rd_addr,
				funt3,
				funt7,
				op_code
 
				);
parameter DATA_SIZE  =32;
	
	
input       [DATA_SIZE-1:0] instruction;

output logic [         19:0] imm_u_data;
output logic [         19:0] imm_j_data;
output logic [         11:0] imm_b_data;
output logic [         11:0] imm_i_data;
output logic [         11:0] imm_s_data;
output logic [          4:0] rs1_addr;
output logic [          4:0] rs2_addr;
output logic [          4:0] rd_addr;
output logic [          2:0] funt3;
output logic [          6:0] funt7;
output logic [          6:0] op_code;

always_comb
begin:decoding_comb
	imm_i_data=instruction[31:20];
	imm_s_data={instruction[31:25],instruction[11:7]};
	imm_b_data={instruction[31],instruction[7],instruction[30:25],instruction[11:8]};
	imm_u_data=instruction[31:12];
	imm_j_data={instruction[31],instruction[19:12],instruction[20],instruction[30:21]};
	rs1_addr  =instruction[19:15];
	rs2_addr  =instruction[24:20];
	rd_addr   =instruction[11:7];
	funt3     =instruction[14:12];
	funt7     =instruction[31:25];
	op_code   =instruction[6:0];

end		
				
endmodule