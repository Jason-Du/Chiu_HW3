 `timescale 1ns/10ps
 module pause_pc_controller(
									instruction_stall,
									pc,
									past_pc,
									bus_stall,
									
									pc_data
									);
  parameter DATA_SIZE  =32;
  
  output logic [DATA_SIZE-1:0] pc_data;
  
  input        [DATA_SIZE-1:0] pc;
  input        [DATA_SIZE-1:0] past_pc;
  input                        instruction_stall;
  input                        bus_stall;
  
  always_comb
  begin
	pc_data=(instruction_stall||bus_stall)?past_pc:pc;
  end
  endmodule