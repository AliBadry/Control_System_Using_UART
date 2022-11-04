
set top_module SYS_TOP

define_design_lib work -path ./work




################## Design Compiler Library Files ######################

lappend search_path /home/IC/Labs/LAST/std_cells
lappend search_path /home/IC/Labs/LAST/dft/Full_System
lappend search_path /home/IC/Labs/LAST/dft/Full_System/ALU
lappend search_path /home/IC/Labs/LAST/dft/Full_System/Controller
lappend search_path /home/IC/Labs/LAST/dft/Full_System/RX_code
lappend search_path /home/IC/Labs/LAST/dft/Full_System/SYNC
lappend search_path /home/IC/Labs/LAST/dft/Full_System/TX_code

set TTLIB "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set SSLIB "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set FFLIB "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"

## Standard Cell libraries 
set target_library [list $TTLIB $SSLIB $FFLIB]

## Standard Cell & Hard Macros libraries 
set link_library [list * $TTLIB $SSLIB $FFLIB]  



#echo "###############################################"
#echo "############# Reading RTL Files  ##############"
#echo "###############################################"

#read_file {/home/IC/Labs/LAST/Full_System} -autoread -recursive -format verilog -top top_module
read_file {/home/IC/Labs/LAST/dft/Full_System /home/IC/Labs/LAST/dft/Full_System/ALU /home/IC/Labs/LAST/dft/Full_System/Controller /home/IC/Labs/LAST/dft/Full_System/RX_code /home/IC/Labs/LAST/dft/Full_System/SYNC /home/IC/Labs/LAST/dft/Full_System/TX_code} -autoread -format verilog -top $top_module


current_design $top_module

set_svf SVF/System.svf

#################### Liniking All The Design Parts #########################
#echo "###############################################"
#echo "# Linking The Top Module with its submodules  #"
#echo "###############################################"

link 

check_design

###########defining the constraints on the design################

source ./cons.tcl

############# Make unique copies of replicated modules by ##################
############# giving each replicated module a unique name  #############

uniquify

###################### Mapping and optimization ########################"

compile -scan

################################################################### 
# Setting Test Timing Variables
################################################################### 

# Preclock Measure Protocol (default protocol)
set test_default_period 100
set test_default_delay 0
set test_default_bidir_delay 0
set test_default_strobe 20
set test_default_strobe_width 0

########################## Define DFT Signals ##########################

set_scan_configuration -clock_mixing no_mix -style multiplexed_flip_flop -replace true -max_length 100

set_dft_signal -port [get_ports Scan_clk] -type ScanClock -view existing_dft -timing {30 60}
set_dft_signal -port [get_ports Scan_rst] -type Reset -view existing_dft -active_state 0
set_dft_signal -port [get_ports Test_mode] -type Constant -view existing_dft -active_state 1
set_dft_signal -port [get_ports SE] -type ScanEnable -view spec -active_state 1 -usage scan
set_dft_signal -port [get_ports SI] -type ScanDataIn -view spec
set_dft_signal -port [get_ports SO] -type ScanDataOut -view spec



############################# Create Test Protocol #####################
                                           
create_test_protocol

###################### Pre-DFT Design Rule Checking ####################

dft_drc -verbose

############################# Preview DFT ##############################

preview_dft -show scan_summary

############################# Insert DFT ###############################

insert_dft

######################## Optimize Logic post DFT #######################

compile -scan -incremental

###################### Design Rule Checking post DFT ###################

dft_drc -verbose -coverage_estimate > coverage.rpt

#############################################################################
# Write out Design after initial compile
#############################################################################

#Avoid Writing assign statements in the netlist
change_name -hier -rule verilog

#############################################################################
# Write out Design after initial compile
#############################################################################


write_file -format verilog -hierarchy -output GLN/System_GLNet.v

write_file -format ddc -hierarchy -output GLN/System_GLNet.ddc

write_sdf SDF/SYSTEM.sdf

write_sdc  -nosplit SDC/$top_module.sdc


#############################################################################
# generating the reports
#############################################################################
report_area -hierarchy > Reports/area_SYSTEM.rpt
report_power -hierarchy > Reports/power_SYSTEM.rpt
report_timing -nworst 10 -delay_type min > Reports/hold_SYSTEM.rpt
report_timing -nworst 10 -delay_type max > Reports/setup_SYSTEM.rpt
report_clock -attributes > Reports/clocks_SYSTEM.rpt
report_constraint -all_violators > Reports/constraints_SYSTEM.rpt

gui_start

