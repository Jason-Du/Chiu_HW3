`timescale 1ns/10ps

module if_id_rst_controller(
						local_rst,
						//global_rst,
						pc_jump_control,
						enable_jump,
						//bus_stall,
						
						rst_data
						);
output logic rst_data;

input  logic pc_jump_control;
input  logic local_rst;
//input  logic global_rst;
input  logic enable_jump;
//input  logic bus_stall;

always_comb
begin
    //rst_data=bus_stall?1'b0:( enable_jump ? ( pc_jump_control ? local_rst:1'b0) :1'b0);
    //rst_data=bus_stall?1'b0:( enable_jump ? ( pc_jump_control ? local_rst:1'b0) :1'b0);
    rst_data=enable_jump ?( pc_jump_control ? local_rst:1'b0) :1'b0;
end

endmodule