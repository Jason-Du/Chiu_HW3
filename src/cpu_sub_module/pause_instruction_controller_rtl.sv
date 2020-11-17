 `timescale 1ns/10ps
 
 module pause_instruction_controller(
									instruction_stall,
									instruction,
									past_instruction,
									bus_stall,
									
									instruction_data
									);
  parameter DATA_SIZE  =32;
  
  output logic [DATA_SIZE-1:0] instruction_data;
  
  input        [DATA_SIZE-1:0] instruction;
  input        [DATA_SIZE-1:0] past_instruction;
  input                        instruction_stall;
  input                        bus_stall;
  always_comb
  begin
	instruction_data=(instruction_stall||bus_stall)?past_instruction:instruction;
  end
  endmodule