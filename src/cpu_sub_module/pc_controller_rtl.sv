 `timescale 1ns/10ps
 
 module pc_controller(
						pc,
						next_pc,
						pc_jump_address,
						pc_jump_control,
						pc_stall,
						enable_jump,
						bus_stall,
						
						pc_data
						);
 
  parameter DATA_SIZE  =32;
  
  output logic [DATA_SIZE-1:0] pc_data;
  
  input        [DATA_SIZE-1:0] pc;
  input        [DATA_SIZE-1:0] next_pc;
  input        [DATA_SIZE-1:0] pc_jump_address;
  input                        pc_jump_control;
  input                        pc_stall;
  input                        enable_jump;
  input                        bus_stall;
  
  
  always_comb
  begin
	if(pc_stall==1'b1)
	begin
		pc_data=pc;
	end
	else
	begin
		pc_data=bus_stall?pc:(enable_jump?(pc_jump_control?pc_jump_address:next_pc):next_pc);
	end
  end
  
  endmodule