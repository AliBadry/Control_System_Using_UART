
############################## Formality Setup File ##############################

set SSLIB "/home/IC/Labs/LAST/std_cells/scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set TTLIB "/home/IC/Labs/LAST/std_cells/scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set FFLIB "/home/IC/Labs/LAST/std_cells/scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"

set synopsys_auto_setup true
set_svf "/home/IC/Labs/LAST/syn/default.svf"

## Read Reference Design Files

read_db -container Ref [list $SSLIB $TTLIB $FFLIB]
read_verilog -container Ref "/home/IC/Labs/LAST/Full_System/*.v"
read_verilog -container Ref "/home/IC/Labs/LAST/Full_System/ALU/*.v"
read_verilog -container Ref "/home/IC/Labs/LAST/Full_System/Controller/*.v"
read_verilog -container Ref "/home/IC/Labs/LAST/Full_System/RX_code/*.v"
read_verilog -container Ref "/home/IC/Labs/LAST/Full_System/TX_code/*.v"
read_verilog -container Ref "/home/IC/Labs/LAST/Full_System/SYNC/*.v"


## set the top Reference Design 

set_reference_design SYS_TOP
set_top SYS_TOP

## Read Implementation technology libraries

read_db -container Imp [list $SSLIB $TTLIB $FFLIB]

## Read Implementation Design Files


read_verilog -container Imp -netlist "/home/IC/Labs/LAST/syn/GLN/System_GLNet.v"

## set the top Implementation Design

set_implementation_design SYS_TOP
set_top SYS_TOP

## matching Compare points

match

## verify
set successful [verify]
if {!$successful} {
diagnose
analyze_points -failing
}

#Reports
report_passing_points > "Reports/passing_points.rpt"
report_failing_points > "Reports/failing_points.rpt"
report_aborted_points > "Reports/aborted_points.rpt"
report_unverified_points > "Reports/unverified_points.rpt"


start_gui
