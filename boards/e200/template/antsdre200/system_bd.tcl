
################################################################
# This is a generated script based on design: system
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
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# ol_top

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
set design_name system

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
xilinx.com:ip:xlconstant:1.1\
analog.com:user:axi_ad9361:1.0\
analog.com:user:axi_dmac:1.0\
analog.com:user:util_rfifo:1.0\
analog.com:user:axi_gpreg:1.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_iic:2.1\
analog.com:user:axi_sysid:1.0\
analog.com:user:sysid_rom:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:gmii_to_rgmii:4.1\
xilinx.com:ip:proc_sys_reset:5.0\
analog.com:user:util_wfifo:1.0\
analog.com:user:util_cpack2:1.0\
analog.com:user:util_upack2:1.0\
analog.com:user:util_clkdiv:1.0\
xilinx.com:ip:util_reduced_logic:2.0\
analog.com:user:util_tdd_sync:1.0\
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
ol_top\
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


# Hierarchical cell: antsdr_pynq
proc create_hier_cell_antsdr_pynq { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_antsdr_pynq() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 15 -to 0 i_I0_data
  create_bd_pin -dir I i_I0_valid
  create_bd_pin -dir I -from 15 -to 0 i_I1_data
  create_bd_pin -dir I i_I1_valid
  create_bd_pin -dir I -from 15 -to 0 i_Q0_data
  create_bd_pin -dir I i_Q0_valid
  create_bd_pin -dir I -from 15 -to 0 i_Q1_data
  create_bd_pin -dir I i_Q1_valid
  create_bd_pin -dir I i_clk
  create_bd_pin -dir I i_rst
  create_bd_pin -dir O -from 15 -to 0 o_I0_data
  create_bd_pin -dir O o_I0_valid
  create_bd_pin -dir O -from 15 -to 0 o_I1_data
  create_bd_pin -dir O o_I1_valid
  create_bd_pin -dir O -from 15 -to 0 o_Q0_data
  create_bd_pin -dir O o_Q0_valid
  create_bd_pin -dir O -from 15 -to 0 o_Q1_data
  create_bd_pin -dir O o_Q1_valid

  # Create instance: ol_top_0, and set properties
  set block_name ol_top
  set block_cell_name ol_top_0
  if { [catch {set ol_top_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ol_top_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net i_I0_data_1 [get_bd_pins i_I0_data] [get_bd_pins ol_top_0/i_I0_data]
  connect_bd_net -net i_I0_valid_1 [get_bd_pins i_I0_valid] [get_bd_pins ol_top_0/i_I0_valid]
  connect_bd_net -net i_I1_data_1 [get_bd_pins i_I1_data] [get_bd_pins ol_top_0/i_I1_data]
  connect_bd_net -net i_I1_valid_1 [get_bd_pins i_I1_valid] [get_bd_pins ol_top_0/i_I1_valid]
  connect_bd_net -net i_Q0_data_1 [get_bd_pins i_Q0_data] [get_bd_pins ol_top_0/i_Q0_data]
  connect_bd_net -net i_Q0_valid_1 [get_bd_pins i_Q0_valid] [get_bd_pins ol_top_0/i_Q0_valid]
  connect_bd_net -net i_Q1_data_1 [get_bd_pins i_Q1_data] [get_bd_pins ol_top_0/i_Q1_data]
  connect_bd_net -net i_Q1_valid_1 [get_bd_pins i_Q1_valid] [get_bd_pins ol_top_0/i_Q1_valid]
  connect_bd_net -net i_clk_4x_1 [get_bd_pins i_clk] [get_bd_pins ol_top_0/i_clk]
  connect_bd_net -net i_rst_1 [get_bd_pins i_rst] [get_bd_pins ol_top_0/i_rst]
  connect_bd_net -net ol_top_0_o_I0_data [get_bd_pins o_I0_data] [get_bd_pins ol_top_0/o_I0_data]
  connect_bd_net -net ol_top_0_o_I0_valid [get_bd_pins o_I0_valid] [get_bd_pins ol_top_0/o_I0_valid]
  connect_bd_net -net ol_top_0_o_I1_data [get_bd_pins o_I1_data] [get_bd_pins ol_top_0/o_I1_data]
  connect_bd_net -net ol_top_0_o_I1_valid [get_bd_pins o_I1_valid] [get_bd_pins ol_top_0/o_I1_valid]
  connect_bd_net -net ol_top_0_o_Q0_data [get_bd_pins o_Q0_data] [get_bd_pins ol_top_0/o_Q0_data]
  connect_bd_net -net ol_top_0_o_Q0_valid [get_bd_pins o_Q0_valid] [get_bd_pins ol_top_0/o_Q0_valid]
  connect_bd_net -net ol_top_0_o_Q1_data [get_bd_pins o_Q1_data] [get_bd_pins ol_top_0/o_Q1_data]
  connect_bd_net -net ol_top_0_o_Q1_valid [get_bd_pins o_Q1_valid] [get_bd_pins ol_top_0/o_Q1_valid]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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
  set MDIO_PHY [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 MDIO_PHY ]

  set RGMII [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 RGMII ]

  set ddr [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr ]

  set fixed_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io ]

  set iic_main [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main ]


  # Create ports
  set enable [ create_bd_port -dir O enable ]
  set gp_in_0 [ create_bd_port -dir I -from 31 -to 0 gp_in_0 ]
  set gp_in_1 [ create_bd_port -dir I -from 31 -to 0 gp_in_1 ]
  set gp_in_2 [ create_bd_port -dir I -from 31 -to 0 gp_in_2 ]
  set gp_in_3 [ create_bd_port -dir I -from 31 -to 0 gp_in_3 ]
  set gp_out_0 [ create_bd_port -dir O -from 31 -to 0 gp_out_0 ]
  set gp_out_1 [ create_bd_port -dir O -from 31 -to 0 gp_out_1 ]
  set gp_out_2 [ create_bd_port -dir O -from 31 -to 0 gp_out_2 ]
  set gp_out_3 [ create_bd_port -dir O -from 31 -to 0 gp_out_3 ]
  set gpio_i [ create_bd_port -dir I -from 63 -to 0 gpio_i ]
  set gpio_o [ create_bd_port -dir O -from 63 -to 0 gpio_o ]
  set gpio_t [ create_bd_port -dir O -from 63 -to 0 gpio_t ]
  set gps_pps [ create_bd_port -dir I gps_pps ]
  set otg_vbusoc [ create_bd_port -dir I otg_vbusoc ]
  set rx_clk_in_n [ create_bd_port -dir I rx_clk_in_n ]
  set rx_clk_in_p [ create_bd_port -dir I rx_clk_in_p ]
  set rx_data_in_n [ create_bd_port -dir I -from 5 -to 0 rx_data_in_n ]
  set rx_data_in_p [ create_bd_port -dir I -from 5 -to 0 rx_data_in_p ]
  set rx_frame_in_n [ create_bd_port -dir I rx_frame_in_n ]
  set rx_frame_in_p [ create_bd_port -dir I rx_frame_in_p ]
  set spi0_clk_i [ create_bd_port -dir I spi0_clk_i ]
  set spi0_clk_o [ create_bd_port -dir O spi0_clk_o ]
  set spi0_csn_0_o [ create_bd_port -dir O spi0_csn_0_o ]
  set spi0_csn_1_o [ create_bd_port -dir O spi0_csn_1_o ]
  set spi0_csn_2_o [ create_bd_port -dir O spi0_csn_2_o ]
  set spi0_csn_i [ create_bd_port -dir I spi0_csn_i ]
  set spi0_sdi_i [ create_bd_port -dir I spi0_sdi_i ]
  set spi0_sdo_i [ create_bd_port -dir I spi0_sdo_i ]
  set spi0_sdo_o [ create_bd_port -dir O spi0_sdo_o ]
  set spi1_clk_i [ create_bd_port -dir I spi1_clk_i ]
  set spi1_clk_o [ create_bd_port -dir O spi1_clk_o ]
  set spi1_csn_0_o [ create_bd_port -dir O spi1_csn_0_o ]
  set spi1_csn_1_o [ create_bd_port -dir O spi1_csn_1_o ]
  set spi1_csn_2_o [ create_bd_port -dir O spi1_csn_2_o ]
  set spi1_csn_i [ create_bd_port -dir I spi1_csn_i ]
  set spi1_sdi_i [ create_bd_port -dir I spi1_sdi_i ]
  set spi1_sdo_i [ create_bd_port -dir I spi1_sdo_i ]
  set spi1_sdo_o [ create_bd_port -dir O spi1_sdo_o ]
  set tdd_sync_i [ create_bd_port -dir I tdd_sync_i ]
  set tdd_sync_o [ create_bd_port -dir O tdd_sync_o ]
  set tdd_sync_t [ create_bd_port -dir O tdd_sync_t ]
  set tx_clk_out_n [ create_bd_port -dir O tx_clk_out_n ]
  set tx_clk_out_p [ create_bd_port -dir O tx_clk_out_p ]
  set tx_data_out_n [ create_bd_port -dir O -from 5 -to 0 tx_data_out_n ]
  set tx_data_out_p [ create_bd_port -dir O -from 5 -to 0 tx_data_out_p ]
  set tx_frame_out_n [ create_bd_port -dir O tx_frame_out_n ]
  set tx_frame_out_p [ create_bd_port -dir O tx_frame_out_p ]
  set txnrx [ create_bd_port -dir O txnrx ]
  set up_enable [ create_bd_port -dir I up_enable ]
  set up_txnrx [ create_bd_port -dir I up_txnrx ]

  # Create instance: GND_1, and set properties
  set GND_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 GND_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $GND_1

  # Create instance: antsdr_pynq
  create_hier_cell_antsdr_pynq [current_bd_instance .] antsdr_pynq

  # Create instance: axi_ad9361, and set properties
  set axi_ad9361 [ create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361 ]
  set_property -dict [ list \
   CONFIG.ADC_DATAFORMAT_DISABLE {0} \
   CONFIG.ADC_DATAPATH_DISABLE {0} \
   CONFIG.ADC_DCFILTER_DISABLE {0} \
   CONFIG.ADC_INIT_DELAY {29} \
   CONFIG.ADC_IQCORRECTION_DISABLE {0} \
   CONFIG.ADC_USERPORTS_DISABLE {0} \
   CONFIG.CMOS_OR_LVDS_N {0} \
   CONFIG.DAC_DATAPATH_DISABLE {0} \
   CONFIG.DAC_DDS_DISABLE {0} \
   CONFIG.DAC_IODELAY_ENABLE {0} \
   CONFIG.DAC_IQCORRECTION_DISABLE {0} \
   CONFIG.DAC_USERPORTS_DISABLE {0} \
   CONFIG.ID {0} \
   CONFIG.MODE_1R1T {0} \
   CONFIG.TDD_DISABLE {0} \
 ] $axi_ad9361

  # Create instance: axi_ad9361_adc_dma, and set properties
  set axi_ad9361_adc_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma ]
  set_property -dict [ list \
   CONFIG.AXI_SLICE_DEST {false} \
   CONFIG.AXI_SLICE_SRC {false} \
   CONFIG.CYCLIC {false} \
   CONFIG.DMA_2D_TRANSFER {false} \
   CONFIG.DMA_DATA_WIDTH_SRC {64} \
   CONFIG.DMA_TYPE_DEST {0} \
   CONFIG.DMA_TYPE_SRC {2} \
   CONFIG.SYNC_TRANSFER_START {true} \
 ] $axi_ad9361_adc_dma

  # Create instance: axi_ad9361_dac_dma, and set properties
  set axi_ad9361_dac_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma ]
  set_property -dict [ list \
   CONFIG.AXI_SLICE_DEST {false} \
   CONFIG.AXI_SLICE_SRC {false} \
   CONFIG.CYCLIC {true} \
   CONFIG.DMA_2D_TRANSFER {false} \
   CONFIG.DMA_DATA_WIDTH_DEST {64} \
   CONFIG.DMA_TYPE_DEST {1} \
   CONFIG.DMA_TYPE_SRC {0} \
 ] $axi_ad9361_dac_dma

  # Create instance: axi_ad9361_dac_fifo, and set properties
  set axi_ad9361_dac_fifo [ create_bd_cell -type ip -vlnv analog.com:user:util_rfifo:1.0 axi_ad9361_dac_fifo ]
  set_property -dict [ list \
   CONFIG.DIN_ADDRESS_WIDTH {4} \
   CONFIG.DIN_DATA_WIDTH {16} \
   CONFIG.DOUT_DATA_WIDTH {16} \
 ] $axi_ad9361_dac_fifo

  # Create instance: axi_cpu_interconnect, and set properties
  set axi_cpu_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {6} \
 ] $axi_cpu_interconnect

  # Create instance: axi_gpreg, and set properties
  set axi_gpreg [ create_bd_cell -type ip -vlnv analog.com:user:axi_gpreg:1.0 axi_gpreg ]
  set_property -dict [ list \
   CONFIG.NUM_OF_CLK_MONS {0} \
   CONFIG.NUM_OF_IO {4} \
 ] $axi_gpreg

  # Create instance: axi_hp1_interconnect, and set properties
  set axi_hp1_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp1_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_hp1_interconnect

  # Create instance: axi_hp2_interconnect, and set properties
  set axi_hp2_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp2_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_hp2_interconnect

  # Create instance: axi_iic_main, and set properties
  set axi_iic_main [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_main ]
  set_property -dict [ list \
   CONFIG.IIC_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_iic_main

  # Create instance: axi_sysid_0, and set properties
  set axi_sysid_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_sysid:1.0 axi_sysid_0 ]
  set_property -dict [ list \
   CONFIG.ROM_ADDR_BITS {9} \
 ] $axi_sysid_0

  # Create instance: rom_sys_0, and set properties
  set rom_sys_0 [ create_bd_cell -type ip -vlnv analog.com:user:sysid_rom:1.0 rom_sys_0 ]
  set_property -dict [ list \
   CONFIG.PATH_TO_FILE {/home/hicksze1/antsdr-pynq/boards/e200/base/antsdre200/mem_init_sys.txt} \
   CONFIG.ROM_ADDR_BITS {9} \
 ] $rom_sys_0

  # Create instance: sys_concat_intc, and set properties
  set sys_concat_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {16} \
 ] $sys_concat_intc

  # Create instance: sys_logic_inv, and set properties
  set sys_logic_inv [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 sys_logic_inv ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
 ] $sys_logic_inv

  # Create instance: sys_ps7, and set properties
  set sys_ps7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 sys_ps7 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {166.666672} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {200000000} \
   CONFIG.PCW_CLK2_FREQ {200000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_ENET0_IO {EMIO} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {EMIO} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_EN_EMIO_ENET0 {1} \
   CONFIG.PCW_EN_EMIO_GPIO {1} \
   CONFIG.PCW_EN_EMIO_SPI0 {1} \
   CONFIG.PCW_EN_EMIO_SPI1 {1} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {1} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST1_PORT {1} \
   CONFIG.PCW_EN_RST2_PORT {1} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SPI0 {1} \
   CONFIG.PCW_EN_SPI1 {1} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {64} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_IRQ_F2P_MODE {REVERSE} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {inout} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {inout} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {inout} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {inout} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {inout} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {inout} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {inout} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {inout} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {inout} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {inout} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {inout} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {inout} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {inout} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {inout} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {inout} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {inout} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {inout} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {\
GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI\
Flash#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#UART 0#UART\
0#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#USB 0#USB 0#USB\
0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD\
0#SD 0#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO} \
   CONFIG.PCW_MIO_TREE_SIGNALS {\
gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#rx#tx#gpio[16]#gpio[17]#gpio[18]#gpio[19]#gpio[20]#gpio[21]#gpio[22]#gpio[23]#gpio[24]#gpio[25]#gpio[26]#gpio[27]#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#gpio[46]#gpio[47]#gpio[48]#gpio[49]#gpio[50]#gpio[51]#gpio[52]#gpio[53]} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PACKAGE_NAME {clg400} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS0_IO {EMIO} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS1_IO {EMIO} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS2_IO {EMIO} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI0_SPI0_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS0_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS1_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS2_IO {EMIO} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI1_SPI1_IO {EMIO} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {EMIO} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.241} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.240} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.048} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.050} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.91} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {1} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
 ] $sys_ps7

  # Create instance: sys_rgmii, and set properties
  set sys_rgmii [ create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii:4.1 sys_rgmii ]
  set_property -dict [ list \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Core} \
 ] $sys_rgmii

  # Create instance: sys_rstgen, and set properties
  set sys_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen ]
  set_property -dict [ list \
   CONFIG.C_EXT_RST_WIDTH {1} \
 ] $sys_rstgen

  # Create instance: util_ad9361_adc_fifo, and set properties
  set util_ad9361_adc_fifo [ create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 util_ad9361_adc_fifo ]
  set_property -dict [ list \
   CONFIG.DIN_ADDRESS_WIDTH {4} \
   CONFIG.DIN_DATA_WIDTH {16} \
   CONFIG.DOUT_DATA_WIDTH {16} \
   CONFIG.NUM_OF_CHANNELS {4} \
 ] $util_ad9361_adc_fifo

  # Create instance: util_ad9361_adc_pack, and set properties
  set util_ad9361_adc_pack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack2:1.0 util_ad9361_adc_pack ]
  set_property -dict [ list \
   CONFIG.NUM_OF_CHANNELS {4} \
   CONFIG.SAMPLE_DATA_WIDTH {16} \
 ] $util_ad9361_adc_pack

  # Create instance: util_ad9361_dac_upack, and set properties
  set util_ad9361_dac_upack [ create_bd_cell -type ip -vlnv analog.com:user:util_upack2:1.0 util_ad9361_dac_upack ]
  set_property -dict [ list \
   CONFIG.NUM_OF_CHANNELS {4} \
   CONFIG.SAMPLE_DATA_WIDTH {16} \
 ] $util_ad9361_dac_upack

  # Create instance: util_ad9361_divclk, and set properties
  set util_ad9361_divclk [ create_bd_cell -type ip -vlnv analog.com:user:util_clkdiv:1.0 util_ad9361_divclk ]

  # Create instance: util_ad9361_divclk_reset, and set properties
  set util_ad9361_divclk_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 util_ad9361_divclk_reset ]

  # Create instance: util_ad9361_divclk_sel, and set properties
  set util_ad9361_divclk_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_ad9361_divclk_sel ]
  set_property -dict [ list \
   CONFIG.C_SIZE {2} \
 ] $util_ad9361_divclk_sel

  # Create instance: util_ad9361_divclk_sel_concat, and set properties
  set util_ad9361_divclk_sel_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 util_ad9361_divclk_sel_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $util_ad9361_divclk_sel_concat

  # Create instance: util_ad9361_tdd_sync, and set properties
  set util_ad9361_tdd_sync [ create_bd_cell -type ip -vlnv analog.com:user:util_tdd_sync:1.0 util_ad9361_tdd_sync ]
  set_property -dict [ list \
   CONFIG.TDD_SYNC_PERIOD {10000000} \
 ] $util_ad9361_tdd_sync

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_ps7/M_AXI_GP0]
  connect_bd_intf_net -intf_net axi_ad9361_adc_dma_m_dest_axi [get_bd_intf_pins axi_ad9361_adc_dma/m_dest_axi] [get_bd_intf_pins axi_hp1_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_ad9361_dac_dma_m_axis [get_bd_intf_pins axi_ad9361_dac_dma/m_axis] [get_bd_intf_pins util_ad9361_dac_upack/s_axis]
  connect_bd_intf_net -intf_net axi_ad9361_dac_dma_m_src_axi [get_bd_intf_pins axi_ad9361_dac_dma/m_src_axi] [get_bd_intf_pins axi_hp2_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M00_AXI [get_bd_intf_pins axi_cpu_interconnect/M00_AXI] [get_bd_intf_pins axi_sysid_0/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M01_AXI [get_bd_intf_pins axi_cpu_interconnect/M01_AXI] [get_bd_intf_pins axi_iic_main/S_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M02_AXI [get_bd_intf_pins axi_ad9361/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M02_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M03_AXI [get_bd_intf_pins axi_ad9361_adc_dma/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M03_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M04_AXI [get_bd_intf_pins axi_ad9361_dac_dma/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M04_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M05_AXI [get_bd_intf_pins axi_cpu_interconnect/M05_AXI] [get_bd_intf_pins axi_gpreg/s_axi]
  connect_bd_intf_net -intf_net axi_hp1_interconnect_M00_AXI [get_bd_intf_pins axi_hp1_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_hp2_interconnect_M00_AXI [get_bd_intf_pins axi_hp2_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_iic_main_IIC [get_bd_intf_ports iic_main] [get_bd_intf_pins axi_iic_main/IIC]
  connect_bd_intf_net -intf_net sys_ps7_DDR [get_bd_intf_ports ddr] [get_bd_intf_pins sys_ps7/DDR]
  connect_bd_intf_net -intf_net sys_ps7_FIXED_IO [get_bd_intf_ports fixed_io] [get_bd_intf_pins sys_ps7/FIXED_IO]
  connect_bd_intf_net -intf_net sys_ps7_GMII_ETHERNET_0 [get_bd_intf_pins sys_ps7/GMII_ETHERNET_0] [get_bd_intf_pins sys_rgmii/GMII]
  connect_bd_intf_net -intf_net sys_ps7_MDIO_ETHERNET_0 [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_0] [get_bd_intf_pins sys_rgmii/MDIO_GEM]
  connect_bd_intf_net -intf_net sys_rgmii_MDIO_PHY [get_bd_intf_ports MDIO_PHY] [get_bd_intf_pins sys_rgmii/MDIO_PHY]
  connect_bd_intf_net -intf_net sys_rgmii_RGMII [get_bd_intf_ports RGMII] [get_bd_intf_pins sys_rgmii/RGMII]
  connect_bd_intf_net -intf_net util_ad9361_adc_pack_packed_fifo_wr [get_bd_intf_pins axi_ad9361_adc_dma/fifo_wr] [get_bd_intf_pins util_ad9361_adc_pack/packed_fifo_wr]

  # Create port connections
  connect_bd_net -net GND_1_dout [get_bd_pins GND_1/dout] [get_bd_pins sys_concat_intc/In0] [get_bd_pins sys_concat_intc/In1] [get_bd_pins sys_concat_intc/In2] [get_bd_pins sys_concat_intc/In3] [get_bd_pins sys_concat_intc/In4] [get_bd_pins sys_concat_intc/In5] [get_bd_pins sys_concat_intc/In6] [get_bd_pins sys_concat_intc/In7] [get_bd_pins sys_concat_intc/In8] [get_bd_pins sys_concat_intc/In9] [get_bd_pins sys_concat_intc/In10] [get_bd_pins sys_concat_intc/In15]
  connect_bd_net -net antsdr_pynq_o_I0_data [get_bd_pins antsdr_pynq/o_I0_data] [get_bd_pins util_ad9361_adc_fifo/din_data_0]
  connect_bd_net -net antsdr_pynq_o_I0_valid [get_bd_pins antsdr_pynq/o_I0_valid] [get_bd_pins util_ad9361_adc_fifo/din_valid_0]
  connect_bd_net -net antsdr_pynq_o_I1_data [get_bd_pins antsdr_pynq/o_I1_data] [get_bd_pins util_ad9361_adc_fifo/din_data_2]
  connect_bd_net -net antsdr_pynq_o_I1_valid [get_bd_pins antsdr_pynq/o_I1_valid] [get_bd_pins util_ad9361_adc_fifo/din_valid_2]
  connect_bd_net -net antsdr_pynq_o_Q0_data [get_bd_pins antsdr_pynq/o_Q0_data] [get_bd_pins util_ad9361_adc_fifo/din_data_1]
  connect_bd_net -net antsdr_pynq_o_Q0_valid [get_bd_pins antsdr_pynq/o_Q0_valid] [get_bd_pins util_ad9361_adc_fifo/din_valid_1]
  connect_bd_net -net antsdr_pynq_o_Q1_data [get_bd_pins antsdr_pynq/o_Q1_data] [get_bd_pins util_ad9361_adc_fifo/din_data_3]
  connect_bd_net -net antsdr_pynq_o_Q1_valid [get_bd_pins antsdr_pynq/o_Q1_valid] [get_bd_pins util_ad9361_adc_fifo/din_valid_3]
  connect_bd_net -net axi_ad9361_adc_data_i0 [get_bd_pins antsdr_pynq/i_I0_data] [get_bd_pins axi_ad9361/adc_data_i0]
  connect_bd_net -net axi_ad9361_adc_data_i1 [get_bd_pins antsdr_pynq/i_I1_data] [get_bd_pins axi_ad9361/adc_data_i1]
  connect_bd_net -net axi_ad9361_adc_data_q0 [get_bd_pins antsdr_pynq/i_Q0_data] [get_bd_pins axi_ad9361/adc_data_q0]
  connect_bd_net -net axi_ad9361_adc_data_q1 [get_bd_pins antsdr_pynq/i_Q1_data] [get_bd_pins axi_ad9361/adc_data_q1]
  connect_bd_net -net axi_ad9361_adc_dma_irq [get_bd_pins axi_ad9361_adc_dma/irq] [get_bd_pins sys_concat_intc/In13]
  connect_bd_net -net axi_ad9361_adc_enable_i0 [get_bd_pins axi_ad9361/adc_enable_i0] [get_bd_pins util_ad9361_adc_fifo/din_enable_0]
  connect_bd_net -net axi_ad9361_adc_enable_i1 [get_bd_pins axi_ad9361/adc_enable_i1] [get_bd_pins util_ad9361_adc_fifo/din_enable_2]
  connect_bd_net -net axi_ad9361_adc_enable_q0 [get_bd_pins axi_ad9361/adc_enable_q0] [get_bd_pins util_ad9361_adc_fifo/din_enable_1]
  connect_bd_net -net axi_ad9361_adc_enable_q1 [get_bd_pins axi_ad9361/adc_enable_q1] [get_bd_pins util_ad9361_adc_fifo/din_enable_3]
  connect_bd_net -net axi_ad9361_adc_r1_mode [get_bd_pins axi_ad9361/adc_r1_mode] [get_bd_pins util_ad9361_divclk_sel_concat/In0]
  connect_bd_net -net axi_ad9361_adc_valid_i0 [get_bd_pins antsdr_pynq/i_I0_valid] [get_bd_pins axi_ad9361/adc_valid_i0]
  connect_bd_net -net axi_ad9361_adc_valid_i1 [get_bd_pins antsdr_pynq/i_I1_valid] [get_bd_pins axi_ad9361/adc_valid_i1]
  connect_bd_net -net axi_ad9361_adc_valid_q0 [get_bd_pins antsdr_pynq/i_Q0_valid] [get_bd_pins axi_ad9361/adc_valid_q0]
  connect_bd_net -net axi_ad9361_adc_valid_q1 [get_bd_pins antsdr_pynq/i_Q1_valid] [get_bd_pins axi_ad9361/adc_valid_q1]
  connect_bd_net -net axi_ad9361_dac_dma_irq [get_bd_pins axi_ad9361_dac_dma/irq] [get_bd_pins sys_concat_intc/In12]
  connect_bd_net -net axi_ad9361_dac_enable_i0 [get_bd_pins axi_ad9361/dac_enable_i0] [get_bd_pins axi_ad9361_dac_fifo/dout_enable_0]
  connect_bd_net -net axi_ad9361_dac_enable_i1 [get_bd_pins axi_ad9361/dac_enable_i1] [get_bd_pins axi_ad9361_dac_fifo/dout_enable_2]
  connect_bd_net -net axi_ad9361_dac_enable_q0 [get_bd_pins axi_ad9361/dac_enable_q0] [get_bd_pins axi_ad9361_dac_fifo/dout_enable_1]
  connect_bd_net -net axi_ad9361_dac_enable_q1 [get_bd_pins axi_ad9361/dac_enable_q1] [get_bd_pins axi_ad9361_dac_fifo/dout_enable_3]
  connect_bd_net -net axi_ad9361_dac_fifo_din_enable_0 [get_bd_pins axi_ad9361_dac_fifo/din_enable_0] [get_bd_pins util_ad9361_dac_upack/enable_0]
  connect_bd_net -net axi_ad9361_dac_fifo_din_enable_1 [get_bd_pins axi_ad9361_dac_fifo/din_enable_1] [get_bd_pins util_ad9361_dac_upack/enable_1]
  connect_bd_net -net axi_ad9361_dac_fifo_din_enable_2 [get_bd_pins axi_ad9361_dac_fifo/din_enable_2] [get_bd_pins util_ad9361_dac_upack/enable_2]
  connect_bd_net -net axi_ad9361_dac_fifo_din_enable_3 [get_bd_pins axi_ad9361_dac_fifo/din_enable_3] [get_bd_pins util_ad9361_dac_upack/enable_3]
  connect_bd_net -net axi_ad9361_dac_fifo_din_valid_0 [get_bd_pins axi_ad9361_dac_fifo/din_valid_0] [get_bd_pins util_ad9361_dac_upack/fifo_rd_en]
  connect_bd_net -net axi_ad9361_dac_fifo_dout_data_0 [get_bd_pins axi_ad9361/dac_data_i0] [get_bd_pins axi_ad9361_dac_fifo/dout_data_0]
  connect_bd_net -net axi_ad9361_dac_fifo_dout_data_1 [get_bd_pins axi_ad9361/dac_data_q0] [get_bd_pins axi_ad9361_dac_fifo/dout_data_1]
  connect_bd_net -net axi_ad9361_dac_fifo_dout_data_2 [get_bd_pins axi_ad9361/dac_data_i1] [get_bd_pins axi_ad9361_dac_fifo/dout_data_2]
  connect_bd_net -net axi_ad9361_dac_fifo_dout_data_3 [get_bd_pins axi_ad9361/dac_data_q1] [get_bd_pins axi_ad9361_dac_fifo/dout_data_3]
  connect_bd_net -net axi_ad9361_dac_fifo_dout_unf [get_bd_pins axi_ad9361/dac_dunf] [get_bd_pins axi_ad9361_dac_fifo/dout_unf]
  connect_bd_net -net axi_ad9361_dac_r1_mode [get_bd_pins axi_ad9361/dac_r1_mode] [get_bd_pins util_ad9361_divclk_sel_concat/In1]
  connect_bd_net -net axi_ad9361_dac_valid_i0 [get_bd_pins axi_ad9361/dac_valid_i0] [get_bd_pins axi_ad9361_dac_fifo/dout_valid_0]
  connect_bd_net -net axi_ad9361_dac_valid_i1 [get_bd_pins axi_ad9361/dac_valid_i1] [get_bd_pins axi_ad9361_dac_fifo/dout_valid_2]
  connect_bd_net -net axi_ad9361_dac_valid_q0 [get_bd_pins axi_ad9361/dac_valid_q0] [get_bd_pins axi_ad9361_dac_fifo/dout_valid_1]
  connect_bd_net -net axi_ad9361_dac_valid_q1 [get_bd_pins axi_ad9361/dac_valid_q1] [get_bd_pins axi_ad9361_dac_fifo/dout_valid_3]
  connect_bd_net -net axi_ad9361_enable [get_bd_ports enable] [get_bd_pins axi_ad9361/enable]
  connect_bd_net -net axi_ad9361_gps_pps_irq [get_bd_pins axi_ad9361/gps_pps_irq] [get_bd_pins sys_concat_intc/In11]
  connect_bd_net -net axi_ad9361_l_clk [get_bd_pins antsdr_pynq/i_clk] [get_bd_pins axi_ad9361/clk] [get_bd_pins axi_ad9361/l_clk] [get_bd_pins axi_ad9361_dac_fifo/dout_clk] [get_bd_pins util_ad9361_adc_fifo/din_clk] [get_bd_pins util_ad9361_divclk/clk]
  connect_bd_net -net axi_ad9361_rst [get_bd_pins antsdr_pynq/i_rst] [get_bd_pins axi_ad9361/rst] [get_bd_pins axi_ad9361_dac_fifo/dout_rst] [get_bd_pins util_ad9361_adc_fifo/din_rst]
  connect_bd_net -net axi_ad9361_tdd_sync_cntr [get_bd_ports tdd_sync_t] [get_bd_pins axi_ad9361/tdd_sync_cntr] [get_bd_pins util_ad9361_tdd_sync/sync_mode]
  connect_bd_net -net axi_ad9361_tx_clk_out_n [get_bd_ports tx_clk_out_n] [get_bd_pins axi_ad9361/tx_clk_out_n]
  connect_bd_net -net axi_ad9361_tx_clk_out_p [get_bd_ports tx_clk_out_p] [get_bd_pins axi_ad9361/tx_clk_out_p]
  connect_bd_net -net axi_ad9361_tx_data_out_n [get_bd_ports tx_data_out_n] [get_bd_pins axi_ad9361/tx_data_out_n]
  connect_bd_net -net axi_ad9361_tx_data_out_p [get_bd_ports tx_data_out_p] [get_bd_pins axi_ad9361/tx_data_out_p]
  connect_bd_net -net axi_ad9361_tx_frame_out_n [get_bd_ports tx_frame_out_n] [get_bd_pins axi_ad9361/tx_frame_out_n]
  connect_bd_net -net axi_ad9361_tx_frame_out_p [get_bd_ports tx_frame_out_p] [get_bd_pins axi_ad9361/tx_frame_out_p]
  connect_bd_net -net axi_ad9361_txnrx [get_bd_ports txnrx] [get_bd_pins axi_ad9361/txnrx]
  connect_bd_net -net axi_gpreg_up_gp_out_0 [get_bd_ports gp_out_0] [get_bd_pins axi_gpreg/up_gp_out_0]
  connect_bd_net -net axi_gpreg_up_gp_out_1 [get_bd_ports gp_out_1] [get_bd_pins axi_gpreg/up_gp_out_1]
  connect_bd_net -net axi_gpreg_up_gp_out_2 [get_bd_ports gp_out_2] [get_bd_pins axi_gpreg/up_gp_out_2]
  connect_bd_net -net axi_gpreg_up_gp_out_3 [get_bd_ports gp_out_3] [get_bd_pins axi_gpreg/up_gp_out_3]
  connect_bd_net -net axi_iic_main_iic2intc_irpt [get_bd_pins axi_iic_main/iic2intc_irpt] [get_bd_pins sys_concat_intc/In14]
  connect_bd_net -net axi_sysid_0_rom_addr [get_bd_pins axi_sysid_0/rom_addr] [get_bd_pins rom_sys_0/rom_addr]
  connect_bd_net -net gp_in_0_1 [get_bd_ports gp_in_0] [get_bd_pins axi_gpreg/up_gp_in_0]
  connect_bd_net -net gp_in_1_1 [get_bd_ports gp_in_1] [get_bd_pins axi_gpreg/up_gp_in_1]
  connect_bd_net -net gp_in_2_1 [get_bd_ports gp_in_2] [get_bd_pins axi_gpreg/up_gp_in_2]
  connect_bd_net -net gp_in_3_1 [get_bd_ports gp_in_3] [get_bd_pins axi_gpreg/up_gp_in_3]
  connect_bd_net -net gpio_i_1 [get_bd_ports gpio_i] [get_bd_pins sys_ps7/GPIO_I]
  connect_bd_net -net gps_pps_1 [get_bd_ports gps_pps] [get_bd_pins axi_ad9361/gps_pps]
  connect_bd_net -net otg_vbusoc_1 [get_bd_ports otg_vbusoc] [get_bd_pins sys_logic_inv/Op1]
  connect_bd_net -net rom_sys_0_rom_data [get_bd_pins axi_sysid_0/sys_rom_data] [get_bd_pins rom_sys_0/rom_data]
  connect_bd_net -net rx_clk_in_n_1 [get_bd_ports rx_clk_in_n] [get_bd_pins axi_ad9361/rx_clk_in_n]
  connect_bd_net -net rx_clk_in_p_1 [get_bd_ports rx_clk_in_p] [get_bd_pins axi_ad9361/rx_clk_in_p]
  connect_bd_net -net rx_data_in_n_1 [get_bd_ports rx_data_in_n] [get_bd_pins axi_ad9361/rx_data_in_n]
  connect_bd_net -net rx_data_in_p_1 [get_bd_ports rx_data_in_p] [get_bd_pins axi_ad9361/rx_data_in_p]
  connect_bd_net -net rx_frame_in_n_1 [get_bd_ports rx_frame_in_n] [get_bd_pins axi_ad9361/rx_frame_in_n]
  connect_bd_net -net rx_frame_in_p_1 [get_bd_ports rx_frame_in_p] [get_bd_pins axi_ad9361/rx_frame_in_p]
  connect_bd_net -net spi0_clk_i_1 [get_bd_ports spi0_clk_i] [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi0_csn_i_1 [get_bd_ports spi0_csn_i] [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi0_sdi_i_1 [get_bd_ports spi0_sdi_i] [get_bd_pins sys_ps7/SPI0_MISO_I]
  connect_bd_net -net spi0_sdo_i_1 [get_bd_ports spi0_sdo_i] [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi1_clk_i_1 [get_bd_ports spi1_clk_i] [get_bd_pins sys_ps7/SPI1_SCLK_I]
  connect_bd_net -net spi1_csn_i_1 [get_bd_ports spi1_csn_i] [get_bd_pins sys_ps7/SPI1_SS_I]
  connect_bd_net -net spi1_sdi_i_1 [get_bd_ports spi1_sdi_i] [get_bd_pins sys_ps7/SPI1_MISO_I]
  connect_bd_net -net spi1_sdo_i_1 [get_bd_ports spi1_sdo_i] [get_bd_pins sys_ps7/SPI1_MOSI_I]
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9361/delay_clk] [get_bd_pins sys_ps7/FCLK_CLK1]
  connect_bd_net -net sys_concat_intc_dout [get_bd_pins sys_concat_intc/dout] [get_bd_pins sys_ps7/IRQ_F2P]
  connect_bd_net -net sys_cpu_clk [get_bd_pins axi_ad9361/s_axi_aclk] [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aclk] [get_bd_pins axi_ad9361_adc_dma/s_axi_aclk] [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aclk] [get_bd_pins axi_ad9361_dac_dma/s_axi_aclk] [get_bd_pins axi_cpu_interconnect/ACLK] [get_bd_pins axi_cpu_interconnect/M00_ACLK] [get_bd_pins axi_cpu_interconnect/M01_ACLK] [get_bd_pins axi_cpu_interconnect/M02_ACLK] [get_bd_pins axi_cpu_interconnect/M03_ACLK] [get_bd_pins axi_cpu_interconnect/M04_ACLK] [get_bd_pins axi_cpu_interconnect/M05_ACLK] [get_bd_pins axi_cpu_interconnect/S00_ACLK] [get_bd_pins axi_gpreg/s_axi_aclk] [get_bd_pins axi_hp1_interconnect/aclk] [get_bd_pins axi_hp2_interconnect/aclk] [get_bd_pins axi_iic_main/s_axi_aclk] [get_bd_pins axi_sysid_0/s_axi_aclk] [get_bd_pins rom_sys_0/clk] [get_bd_pins sys_ps7/FCLK_CLK0] [get_bd_pins sys_ps7/M_AXI_GP0_ACLK] [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] [get_bd_pins sys_ps7/S_AXI_HP2_ACLK] [get_bd_pins sys_rstgen/slowest_sync_clk] [get_bd_pins util_ad9361_tdd_sync/clk]
  connect_bd_net -net sys_cpu_reset [get_bd_pins sys_rgmii/rx_reset] [get_bd_pins sys_rgmii/tx_reset] [get_bd_pins sys_rstgen/peripheral_reset]
  connect_bd_net -net sys_cpu_resetn [get_bd_pins axi_ad9361/s_axi_aresetn] [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aresetn] [get_bd_pins axi_ad9361_adc_dma/s_axi_aresetn] [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aresetn] [get_bd_pins axi_ad9361_dac_dma/s_axi_aresetn] [get_bd_pins axi_cpu_interconnect/ARESETN] [get_bd_pins axi_cpu_interconnect/M00_ARESETN] [get_bd_pins axi_cpu_interconnect/M01_ARESETN] [get_bd_pins axi_cpu_interconnect/M02_ARESETN] [get_bd_pins axi_cpu_interconnect/M03_ARESETN] [get_bd_pins axi_cpu_interconnect/M04_ARESETN] [get_bd_pins axi_cpu_interconnect/M05_ARESETN] [get_bd_pins axi_cpu_interconnect/S00_ARESETN] [get_bd_pins axi_gpreg/s_axi_aresetn] [get_bd_pins axi_hp1_interconnect/aresetn] [get_bd_pins axi_hp2_interconnect/aresetn] [get_bd_pins axi_iic_main/s_axi_aresetn] [get_bd_pins axi_sysid_0/s_axi_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn] [get_bd_pins util_ad9361_divclk_reset/ext_reset_in] [get_bd_pins util_ad9361_tdd_sync/rstn]
  connect_bd_net -net sys_logic_inv_Res [get_bd_pins sys_logic_inv/Res] [get_bd_pins sys_ps7/USB0_VBUS_PWRFAULT]
  connect_bd_net -net sys_ps7_FCLK_CLK2 [get_bd_pins sys_ps7/FCLK_CLK2] [get_bd_pins sys_rgmii/clkin]
  connect_bd_net -net sys_ps7_FCLK_RESET0_N [get_bd_pins sys_ps7/FCLK_RESET0_N] [get_bd_pins sys_rstgen/ext_reset_in]
  connect_bd_net -net sys_ps7_GPIO_O [get_bd_ports gpio_o] [get_bd_pins sys_ps7/GPIO_O]
  connect_bd_net -net sys_ps7_GPIO_T [get_bd_ports gpio_t] [get_bd_pins sys_ps7/GPIO_T]
  connect_bd_net -net sys_ps7_SPI0_MOSI_O [get_bd_ports spi0_sdo_o] [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net sys_ps7_SPI0_SCLK_O [get_bd_ports spi0_clk_o] [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net sys_ps7_SPI0_SS1_O [get_bd_ports spi0_csn_1_o] [get_bd_pins sys_ps7/SPI0_SS1_O]
  connect_bd_net -net sys_ps7_SPI0_SS2_O [get_bd_ports spi0_csn_2_o] [get_bd_pins sys_ps7/SPI0_SS2_O]
  connect_bd_net -net sys_ps7_SPI0_SS_O [get_bd_ports spi0_csn_0_o] [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net sys_ps7_SPI1_MOSI_O [get_bd_ports spi1_sdo_o] [get_bd_pins sys_ps7/SPI1_MOSI_O]
  connect_bd_net -net sys_ps7_SPI1_SCLK_O [get_bd_ports spi1_clk_o] [get_bd_pins sys_ps7/SPI1_SCLK_O]
  connect_bd_net -net sys_ps7_SPI1_SS1_O [get_bd_ports spi1_csn_1_o] [get_bd_pins sys_ps7/SPI1_SS1_O]
  connect_bd_net -net sys_ps7_SPI1_SS2_O [get_bd_ports spi1_csn_2_o] [get_bd_pins sys_ps7/SPI1_SS2_O]
  connect_bd_net -net sys_ps7_SPI1_SS_O [get_bd_ports spi1_csn_0_o] [get_bd_pins sys_ps7/SPI1_SS_O]
  connect_bd_net -net tdd_sync_i_1 [get_bd_ports tdd_sync_i] [get_bd_pins util_ad9361_tdd_sync/sync_in]
  connect_bd_net -net up_enable_1 [get_bd_ports up_enable] [get_bd_pins axi_ad9361/up_enable]
  connect_bd_net -net up_txnrx_1 [get_bd_ports up_txnrx] [get_bd_pins axi_ad9361/up_txnrx]
  connect_bd_net -net util_ad9361_adc_fifo_din_ovf [get_bd_pins axi_ad9361/adc_dovf] [get_bd_pins util_ad9361_adc_fifo/din_ovf]
  connect_bd_net -net util_ad9361_adc_fifo_dout_data_0 [get_bd_pins util_ad9361_adc_fifo/dout_data_0] [get_bd_pins util_ad9361_adc_pack/fifo_wr_data_0]
  connect_bd_net -net util_ad9361_adc_fifo_dout_data_1 [get_bd_pins util_ad9361_adc_fifo/dout_data_1] [get_bd_pins util_ad9361_adc_pack/fifo_wr_data_1]
  connect_bd_net -net util_ad9361_adc_fifo_dout_data_2 [get_bd_pins util_ad9361_adc_fifo/dout_data_2] [get_bd_pins util_ad9361_adc_pack/fifo_wr_data_2]
  connect_bd_net -net util_ad9361_adc_fifo_dout_data_3 [get_bd_pins util_ad9361_adc_fifo/dout_data_3] [get_bd_pins util_ad9361_adc_pack/fifo_wr_data_3]
  connect_bd_net -net util_ad9361_adc_fifo_dout_enable_0 [get_bd_pins util_ad9361_adc_fifo/dout_enable_0] [get_bd_pins util_ad9361_adc_pack/enable_0]
  connect_bd_net -net util_ad9361_adc_fifo_dout_enable_1 [get_bd_pins util_ad9361_adc_fifo/dout_enable_1] [get_bd_pins util_ad9361_adc_pack/enable_1]
  connect_bd_net -net util_ad9361_adc_fifo_dout_enable_2 [get_bd_pins util_ad9361_adc_fifo/dout_enable_2] [get_bd_pins util_ad9361_adc_pack/enable_2]
  connect_bd_net -net util_ad9361_adc_fifo_dout_enable_3 [get_bd_pins util_ad9361_adc_fifo/dout_enable_3] [get_bd_pins util_ad9361_adc_pack/enable_3]
  connect_bd_net -net util_ad9361_adc_fifo_dout_valid_0 [get_bd_pins util_ad9361_adc_fifo/dout_valid_0] [get_bd_pins util_ad9361_adc_pack/fifo_wr_en]
  connect_bd_net -net util_ad9361_adc_pack_fifo_wr_overflow [get_bd_pins util_ad9361_adc_fifo/dout_ovf] [get_bd_pins util_ad9361_adc_pack/fifo_wr_overflow]
  connect_bd_net -net util_ad9361_dac_upack_fifo_rd_data_0 [get_bd_pins axi_ad9361_dac_fifo/din_data_0] [get_bd_pins util_ad9361_dac_upack/fifo_rd_data_0]
  connect_bd_net -net util_ad9361_dac_upack_fifo_rd_data_1 [get_bd_pins axi_ad9361_dac_fifo/din_data_1] [get_bd_pins util_ad9361_dac_upack/fifo_rd_data_1]
  connect_bd_net -net util_ad9361_dac_upack_fifo_rd_data_2 [get_bd_pins axi_ad9361_dac_fifo/din_data_2] [get_bd_pins util_ad9361_dac_upack/fifo_rd_data_2]
  connect_bd_net -net util_ad9361_dac_upack_fifo_rd_data_3 [get_bd_pins axi_ad9361_dac_fifo/din_data_3] [get_bd_pins util_ad9361_dac_upack/fifo_rd_data_3]
  connect_bd_net -net util_ad9361_dac_upack_fifo_rd_underflow [get_bd_pins axi_ad9361_dac_fifo/din_unf] [get_bd_pins util_ad9361_dac_upack/fifo_rd_underflow]
  connect_bd_net -net util_ad9361_dac_upack_fifo_rd_valid [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_0] [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_1] [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_2] [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_3] [get_bd_pins util_ad9361_dac_upack/fifo_rd_valid]
  connect_bd_net -net util_ad9361_divclk_clk_out [get_bd_pins axi_ad9361_adc_dma/fifo_wr_clk] [get_bd_pins axi_ad9361_dac_dma/m_axis_aclk] [get_bd_pins axi_ad9361_dac_fifo/din_clk] [get_bd_pins util_ad9361_adc_fifo/dout_clk] [get_bd_pins util_ad9361_adc_pack/clk] [get_bd_pins util_ad9361_dac_upack/clk] [get_bd_pins util_ad9361_divclk/clk_out] [get_bd_pins util_ad9361_divclk_reset/slowest_sync_clk]
  connect_bd_net -net util_ad9361_divclk_reset_peripheral_aresetn [get_bd_pins axi_ad9361_dac_fifo/din_rstn] [get_bd_pins util_ad9361_adc_fifo/dout_rstn] [get_bd_pins util_ad9361_divclk_reset/peripheral_aresetn]
  connect_bd_net -net util_ad9361_divclk_reset_peripheral_reset [get_bd_pins util_ad9361_adc_pack/reset] [get_bd_pins util_ad9361_dac_upack/reset] [get_bd_pins util_ad9361_divclk_reset/peripheral_reset]
  connect_bd_net -net util_ad9361_divclk_sel_Res [get_bd_pins util_ad9361_divclk/clk_sel] [get_bd_pins util_ad9361_divclk_sel/Res]
  connect_bd_net -net util_ad9361_divclk_sel_concat_dout [get_bd_pins util_ad9361_divclk_sel/Op1] [get_bd_pins util_ad9361_divclk_sel_concat/dout]
  connect_bd_net -net util_ad9361_tdd_sync_sync_out [get_bd_ports tdd_sync_o] [get_bd_pins axi_ad9361/tdd_sync] [get_bd_pins util_ad9361_tdd_sync/sync_out]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_ad9361_adc_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_ad9361_dac_dma/m_src_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] -force
  assign_bd_address -offset 0x79020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9361/s_axi/axi_lite] -force
  assign_bd_address -offset 0x7C400000 -range 0x00001000 -target_address_space [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9361_adc_dma/s_axi/axi_lite] -force
  assign_bd_address -offset 0x7C420000 -range 0x00001000 -target_address_space [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9361_dac_dma/s_axi/axi_lite] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_gpreg/s_axi/axi_lite] -force
  assign_bd_address -offset 0x41600000 -range 0x00001000 -target_address_space [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_iic_main/S_AXI/Reg] -force
  assign_bd_address -offset 0x45000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_sysid_0/s_axi/axi_lite] -force


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


