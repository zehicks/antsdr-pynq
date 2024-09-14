
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


# The design that will be created by this Tcl script contains the following 
# module references:
# overlay

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name overlay_top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:fir_compiler:7.2\
xilinx.com:ip:util_vector_logic:2.0\
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

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
overlay\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
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



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
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


  # Create interface ports

  # Create ports
  set i_I0_data [ create_bd_port -dir I -from 15 -to 0 i_I0_data ]
  set i_I0_valid [ create_bd_port -dir I i_I0_valid ]
  set i_I1_data [ create_bd_port -dir I -from 15 -to 0 i_I1_data ]
  set i_I1_valid [ create_bd_port -dir I i_I1_valid ]
  set i_Q0_data [ create_bd_port -dir I -from 15 -to 0 i_Q0_data ]
  set i_Q0_valid [ create_bd_port -dir I i_Q0_valid ]
  set i_Q1_data [ create_bd_port -dir I -from 15 -to 0 i_Q1_data ]
  set i_Q1_valid [ create_bd_port -dir I i_Q1_valid ]
  set i_rst [ create_bd_port -dir I i_rst ]
  set i_rx_clk [ create_bd_port -dir I i_rx_clk ]
  set o_I0_data [ create_bd_port -dir O -from 15 -to 0 o_I0_data ]
  set o_I0_valid [ create_bd_port -dir O o_I0_valid ]
  set o_I1_data [ create_bd_port -dir O -from 15 -to 0 o_I1_data ]
  set o_I1_valid [ create_bd_port -dir O o_I1_valid ]
  set o_Q0_data [ create_bd_port -dir O -from 15 -to 0 o_Q0_data ]
  set o_Q0_valid [ create_bd_port -dir O o_Q0_valid ]
  set o_Q1_data [ create_bd_port -dir O -from 15 -to 0 o_Q1_data ]
  set o_Q1_valid [ create_bd_port -dir O o_Q1_valid ]

  # Create instance: fir_decimate_5x_I0, and set properties
  set fir_decimate_5x_I0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_decimate_5x_I0 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {true} \
   CONFIG.Clock_Frequency {7.68} \
   CONFIG.CoefficientVector {\
0.017926080259475487,  -0.12035211259138348,  -0.036208554701390075, \
0.025311459222197356,  0.05052481847108319,  6.815402536415538e-06, \
-0.07581046107316944,  -0.06234473425445337,  0.09350671504844729, \
0.3027523196763338,  0.40012280399110733,  0.3027523196763338, \
0.09350671504844729,  -0.06234473425445337,  -0.07581046107316944, \
6.815402536415538e-06,  0.05052481847108319,  0.025311459222197356, \
-0.036208554701390075,  -0.12035211259138348,  0.017926080259475487} \
   CONFIG.Coefficient_Fractional_Bits {16} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.Data_Fractional_Bits {11} \
   CONFIG.Decimation_Rate {5} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Output_Rounding_Mode {Convergent_Rounding_to_Even} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {1.92} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_decimate_5x_I0

  # Create instance: fir_decimate_5x_I1, and set properties
  set fir_decimate_5x_I1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_decimate_5x_I1 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {true} \
   CONFIG.Clock_Frequency {7.68} \
   CONFIG.CoefficientVector {\
0.017926080259475487,  -0.12035211259138348,  -0.036208554701390075, \
0.025311459222197356,  0.05052481847108319,  6.815402536415538e-06, \
-0.07581046107316944,  -0.06234473425445337,  0.09350671504844729, \
0.3027523196763338,  0.40012280399110733,  0.3027523196763338, \
0.09350671504844729,  -0.06234473425445337,  -0.07581046107316944, \
6.815402536415538e-06,  0.05052481847108319,  0.025311459222197356, \
-0.036208554701390075,  -0.12035211259138348,  0.017926080259475487} \
   CONFIG.Coefficient_Fractional_Bits {16} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.Data_Fractional_Bits {11} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {5} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Output_Rounding_Mode {Convergent_Rounding_to_Even} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {1.92} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_decimate_5x_I1

  # Create instance: fir_decimate_5x_Q0, and set properties
  set fir_decimate_5x_Q0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_decimate_5x_Q0 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {true} \
   CONFIG.Clock_Frequency {7.68} \
   CONFIG.CoefficientVector {\
0.017926080259475487,  -0.12035211259138348,  -0.036208554701390075, \
0.025311459222197356,  0.05052481847108319,  6.815402536415538e-06, \
-0.07581046107316944,  -0.06234473425445337,  0.09350671504844729, \
0.3027523196763338,  0.40012280399110733,  0.3027523196763338, \
0.09350671504844729,  -0.06234473425445337,  -0.07581046107316944, \
6.815402536415538e-06,  0.05052481847108319,  0.025311459222197356, \
-0.036208554701390075,  -0.12035211259138348,  0.017926080259475487} \
   CONFIG.Coefficient_Fractional_Bits {16} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.Data_Fractional_Bits {11} \
   CONFIG.Decimation_Rate {5} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Output_Rounding_Mode {Convergent_Rounding_to_Even} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {1.92} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_decimate_5x_Q0

  # Create instance: fir_decimate_5x_Q1, and set properties
  set fir_decimate_5x_Q1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_decimate_5x_Q1 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {true} \
   CONFIG.Clock_Frequency {7.68} \
   CONFIG.CoefficientVector {\
0.017926080259475487,  -0.12035211259138348,  -0.036208554701390075, \
0.025311459222197356,  0.05052481847108319,  6.815402536415538e-06, \
-0.07581046107316944,  -0.06234473425445337,  0.09350671504844729, \
0.3027523196763338,  0.40012280399110733,  0.3027523196763338, \
0.09350671504844729,  -0.06234473425445337,  -0.07581046107316944, \
6.815402536415538e-06,  0.05052481847108319,  0.025311459222197356, \
-0.036208554701390075,  -0.12035211259138348,  0.017926080259475487} \
   CONFIG.Coefficient_Fractional_Bits {16} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.Data_Fractional_Bits {11} \
   CONFIG.Data_Width {16} \
   CONFIG.Decimation_Rate {5} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Output_Rounding_Mode {Convergent_Rounding_to_Even} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {1.92} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_decimate_5x_Q1

  # Create instance: overlay_0, and set properties
  set block_name overlay
  set block_cell_name overlay_0
  if { [catch {set overlay_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $overlay_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create port connections
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_ports o_I0_data] [get_bd_pins fir_decimate_5x_I0/m_axis_data_tdata]
  connect_bd_net -net cordic_1_m_axis_dout_tdata [get_bd_ports o_I1_data] [get_bd_pins fir_decimate_5x_I1/m_axis_data_tdata]
  connect_bd_net -net cordic_1_m_axis_dout_tvalid [get_bd_ports o_I1_valid] [get_bd_pins fir_decimate_5x_I1/m_axis_data_tvalid]
  connect_bd_net -net fir_decimate_5x_I0_m_axis_data_tvalid [get_bd_ports o_I0_valid] [get_bd_pins fir_decimate_5x_I0/m_axis_data_tvalid]
  connect_bd_net -net fir_decimate_5x_Q0_m_axis_data_tdata [get_bd_ports o_Q0_data] [get_bd_pins fir_decimate_5x_Q0/m_axis_data_tdata]
  connect_bd_net -net fir_decimate_5x_Q0_m_axis_data_tvalid [get_bd_ports o_Q0_valid] [get_bd_pins fir_decimate_5x_Q0/m_axis_data_tvalid]
  connect_bd_net -net fir_decimate_5x_Q1_m_axis_data_tdata [get_bd_ports o_Q1_data] [get_bd_pins fir_decimate_5x_Q1/m_axis_data_tdata]
  connect_bd_net -net fir_decimate_5x_Q1_m_axis_data_tvalid [get_bd_ports o_Q1_valid] [get_bd_pins fir_decimate_5x_Q1/m_axis_data_tvalid]
  connect_bd_net -net i_I0_data_1 [get_bd_ports i_I0_data] [get_bd_pins overlay_0/i_I0_data]
  connect_bd_net -net i_I0_valid_1 [get_bd_ports i_I0_valid] [get_bd_pins overlay_0/i_I0_valid]
  connect_bd_net -net i_I1_data_1 [get_bd_ports i_I1_data] [get_bd_pins overlay_0/i_I1_data]
  connect_bd_net -net i_I1_valid_1 [get_bd_ports i_I1_valid] [get_bd_pins overlay_0/i_I1_valid]
  connect_bd_net -net i_Q0_data_1 [get_bd_ports i_Q0_data] [get_bd_pins overlay_0/i_Q0_data]
  connect_bd_net -net i_Q0_valid_1 [get_bd_ports i_Q0_valid] [get_bd_pins overlay_0/i_Q0_valid]
  connect_bd_net -net i_Q1_data_1 [get_bd_ports i_Q1_data] [get_bd_pins overlay_0/i_Q1_data]
  connect_bd_net -net i_Q1_valid_1 [get_bd_ports i_Q1_valid] [get_bd_pins overlay_0/i_Q1_valid]
  connect_bd_net -net i_clk_1 [get_bd_ports i_rx_clk] [get_bd_pins fir_decimate_5x_I0/aclk] [get_bd_pins fir_decimate_5x_I1/aclk] [get_bd_pins fir_decimate_5x_Q0/aclk] [get_bd_pins fir_decimate_5x_Q1/aclk] [get_bd_pins overlay_0/i_clk]
  connect_bd_net -net i_rst_1 [get_bd_ports i_rst] [get_bd_pins overlay_0/i_rst] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net overlay_0_o_I0_data [get_bd_pins fir_decimate_5x_I0/s_axis_data_tdata] [get_bd_pins overlay_0/o_I0_data]
  connect_bd_net -net overlay_0_o_I0_valid [get_bd_pins fir_decimate_5x_I0/s_axis_data_tvalid] [get_bd_pins overlay_0/o_I0_valid]
  connect_bd_net -net overlay_0_o_I1_data [get_bd_pins fir_decimate_5x_I1/s_axis_data_tdata] [get_bd_pins overlay_0/o_I1_data]
  connect_bd_net -net overlay_0_o_I1_valid [get_bd_pins fir_decimate_5x_I1/s_axis_data_tvalid] [get_bd_pins overlay_0/o_I1_valid]
  connect_bd_net -net overlay_0_o_Q0_data [get_bd_pins fir_decimate_5x_Q0/s_axis_data_tdata] [get_bd_pins overlay_0/o_Q0_data]
  connect_bd_net -net overlay_0_o_Q0_valid [get_bd_pins fir_decimate_5x_Q0/s_axis_data_tvalid] [get_bd_pins overlay_0/o_Q0_valid]
  connect_bd_net -net overlay_0_o_Q1_data [get_bd_pins fir_decimate_5x_Q1/s_axis_data_tdata] [get_bd_pins overlay_0/o_Q1_data]
  connect_bd_net -net overlay_0_o_Q1_valid [get_bd_pins fir_decimate_5x_Q1/s_axis_data_tvalid] [get_bd_pins overlay_0/o_Q1_valid]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins fir_decimate_5x_I0/aresetn] [get_bd_pins fir_decimate_5x_I1/aresetn] [get_bd_pins fir_decimate_5x_Q0/aresetn] [get_bd_pins fir_decimate_5x_Q1/aresetn] [get_bd_pins util_vector_logic_0/Res]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


