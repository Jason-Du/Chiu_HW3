# Clear the environment
clear -all
# Analyze design files
analyze -sv +incdir+../include+../src+../sim ../src/L1C_data.sv
# Analyze SVA file
analyze -sv ../sva/cache_props.sva
# Elaborate design and properties
elaborate -top L1C_data -bbox true -bbox_i {DA TA}
# Set up Clock and Reset
clock clk
reset -expression {rst}
#Prove all properties
set_engine_mode {Hp Ht B D Tri}
prove -all
