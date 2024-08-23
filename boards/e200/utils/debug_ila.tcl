
################################################################
# This is a generated script based on design: overlay_top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source overlay_top_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:ila:6.2\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:xpm_cdc_gen:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: debug_ila
proc create_hier_cell_debug_ila { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_debug_ila() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 15 -to 0 i_I_data
  create_bd_pin -dir I i_I_valid
  create_bd_pin -dir I -from 15 -to 0 i_Q_data
  create_bd_pin -dir I i_Q_valid
  create_bd_pin -dir I -type clk rx_clk
  create_bd_pin -dir I -type clk sys_clk

  # Create instance: ila_input, and set properties
  set ila_input [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_input ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {2} \
   CONFIG.C_ADV_TRIGGER {false} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {4} \
   CONFIG.C_PROBE0_MU_CNT {2} \
   CONFIG.C_PROBE1_MU_CNT {2} \
   CONFIG.C_PROBE1_WIDTH {16} \
   CONFIG.C_PROBE2_MU_CNT {2} \
   CONFIG.C_PROBE2_WIDTH {1} \
   CONFIG.C_PROBE3_MU_CNT {2} \
   CONFIG.C_PROBE3_WIDTH {16} \
   CONFIG.C_PROBE4_MU_CNT {2} \
   CONFIG.C_PROBE4_WIDTH {1} \
   CONFIG.C_TRIGIN_EN {false} \
 ] $ila_input

  # Create instance: xlconcat_i_I, and set properties
  set xlconcat_i_I [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_i_I ]

  # Create instance: xlconcat_i_Q, and set properties
  set xlconcat_i_Q [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_i_Q ]

  # Create instance: xlslice_i_I_data, and set properties
  set xlslice_i_I_data [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_i_I_data ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_i_I_data

  # Create instance: xlslice_i_I_valid, and set properties
  set xlslice_i_I_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_i_I_valid ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {17} \
 ] $xlslice_i_I_valid

  # Create instance: xlslice_i_Q_data, and set properties
  set xlslice_i_Q_data [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_i_Q_data ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {16} \
 ] $xlslice_i_Q_data

  # Create instance: xlslice_i_Q_valid, and set properties
  set xlslice_i_Q_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_i_Q_valid ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {17} \
 ] $xlslice_i_Q_valid

  # Create instance: xpm_cdc_gen_i_I, and set properties
  set xpm_cdc_gen_i_I [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 xpm_cdc_gen_i_I ]
  set_property -dict [ list \
   CONFIG.CDC_TYPE {xpm_cdc_gray} \
   CONFIG.WIDTH {17} \
 ] $xpm_cdc_gen_i_I

  # Create instance: xpm_cdc_gen_i_Q, and set properties
  set xpm_cdc_gen_i_Q [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 xpm_cdc_gen_i_Q ]
  set_property -dict [ list \
   CONFIG.CDC_TYPE {xpm_cdc_gray} \
   CONFIG.WIDTH {17} \
 ] $xpm_cdc_gen_i_Q

  # Create port connections
  connect_bd_net -net axi_ad9361_l_clk [get_bd_pins rx_clk] [get_bd_pins xpm_cdc_gen_i_I/src_clk] [get_bd_pins xpm_cdc_gen_i_Q/src_clk]
  connect_bd_net -net i_I0_data_1 [get_bd_pins i_I_data] [get_bd_pins xlconcat_i_I/In1]
  connect_bd_net -net i_I0_valid_1 [get_bd_pins i_I_valid] [get_bd_pins xlconcat_i_I/In0]
  connect_bd_net -net i_Q0_data_1 [get_bd_pins i_Q_data] [get_bd_pins xlconcat_i_Q/In1]
  connect_bd_net -net i_Q0_valid_1 [get_bd_pins i_Q_valid] [get_bd_pins xlconcat_i_Q/In0]
  connect_bd_net -net sys_cpu_clk [get_bd_pins sys_clk] [get_bd_pins ila_input/clk] [get_bd_pins xpm_cdc_gen_i_I/dest_clk] [get_bd_pins xpm_cdc_gen_i_Q/dest_clk]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_i_I/dout] [get_bd_pins xpm_cdc_gen_i_I/src_in_bin]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_i_Q/dout] [get_bd_pins xpm_cdc_gen_i_Q/src_in_bin]
  connect_bd_net -net xlslice_i_I_valid1_Dout [get_bd_pins ila_input/probe1] [get_bd_pins xlslice_i_I_data/Dout]
  connect_bd_net -net xlslice_i_I_valid2_Dout [get_bd_pins ila_input/probe2] [get_bd_pins xlslice_i_Q_valid/Dout]
  connect_bd_net -net xlslice_i_I_valid3_Dout [get_bd_pins ila_input/probe3] [get_bd_pins xlslice_i_Q_data/Dout]
  connect_bd_net -net xlslice_i_I_valid_Dout [get_bd_pins ila_input/probe0] [get_bd_pins xlslice_i_I_valid/Dout]
  connect_bd_net -net xpm_cdc_gen_i_I_dest_out_bin [get_bd_pins xlslice_i_I_data/Din] [get_bd_pins xlslice_i_I_valid/Din] [get_bd_pins xpm_cdc_gen_i_I/dest_out_bin]
  connect_bd_net -net xpm_cdc_gen_i_Q_dest_out_bin [get_bd_pins xlslice_i_Q_data/Din] [get_bd_pins xlslice_i_Q_valid/Din] [get_bd_pins xpm_cdc_gen_i_Q/dest_out_bin]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_debug_ila parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
