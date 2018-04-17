# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.cache/wt [current_project]
set_property parent.project_path C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.srcs/sources_1/imports/new/NumberDisplay.v
  {C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.srcs/sources_1/imports/examples/EE 460M_Lab2_Starter_File.v}
  C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.srcs/sources_1/new/Dividers.v
  C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.srcs/sources_1/imports/examples/Fitbit.v
  C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.srcs/sources_1/new/PulseGen.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.srcs/constrs_1/imports/460M-HDL-Design/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/Users/erick/Documents/GitHub/460M-HDL-Design/project_6/460M_Lab6/460M_Lab6.srcs/constrs_1/imports/460M-HDL-Design/Basys3_Master.xdc]


synth_design -top PulseGen -part xc7a35tcpg236-1


write_checkpoint -force -noxdef PulseGen.dcp

catch { report_utilization -file PulseGen_utilization_synth.rpt -pb PulseGen_utilization_synth.pb }
