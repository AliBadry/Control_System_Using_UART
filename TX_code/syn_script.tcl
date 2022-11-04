########################### Define Top Module ############################
                                                   
set top_module UART_TX

##################### Define Working Library Directory ######################
                                                   
define_design_lib work -path ./work

################## Design Compiler Library Files #setup ######################

puts "###########################################"
puts "#      #setting Design Libraries           #"
puts "###########################################"
lappend search_path /home/IC/Labs/TX_code/std_cells
lappend search_path /home/IC/Labs/TX_code/rtl

set TTLIB "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"

## standard cell libraries

set target_library [list $TTLIB]

## standard cell & hard macro libraries

set link_library [list * $TTLIB]

############# Reading RTL files ##################

read_file -format verilog FSM.v
read_file -format verilog Serializer.v
read_file -format verilog MUX4x1.v
read_file -format verilog Parity_Calc.v
read_file -format verilog UART_TX.v

current_design $top_module

link

################### Mapping and optimization ###########

compile

######### write out design after initial design #############

write_file -format verilog -output UART_TX_mapped.v
gui_start
