# PYNQ image for AntSDR

This repository has been forked from `https://github.com/MicroPhase/antsdr-pynq`.  See the MicroPhase repository for the original documentation.

## PYNQ Image

The MicroPhase PYNQ image was extended to include PYNQ packages for Analog Devices IIO.  This image will install IIO, the IIO Python bindings, and IIOD to allow remote connections to the RFIC.

### Makefile

To rebuild the PYNQ image using Vivado 2022.1, run `make all`.

To create a bootable SD card from the image, run `make sd SD=</PATH/TO/YOUR/SD/CARD>`.  The SD card should have two partitions: one called `PYNQ` for the boot files, and the other called `root` for the root filesystem.

## Overlays

The base overlay (`./boards/e200/base`) is provided to run the default MicroPhase Pluto SDR compatible system.  The base overlay can be rebuilt by running `make base`.

An overlay template is also provided in the `./boards/e200/template` directory.  This overlay directory can be copied to create a new overlay.  The template block diagram provides an empty component called `overlay` in the receive data stream to allow custom signal processing logic to be inserted.  The `overlay` component provides a wrapper for both channels of IQ data streams.  The clock for this subsystem runs at four times the request sample rate from the IIO software interface.  

### Makefile

Once an overlay bitstream has been generated, the required PYNQ files can be created by running `make ol OL=<YOUR OVERLAY DIRECTORY NAME>`.

## Testbench

The `template` overlay Vivado project also includes a skeleton for a testbench (`tb_overlay.v`) for verification of your signal processing IP.  The testbench must be modified to include the correct clock period, sample clock period, and IQ source files.

### IQ Files

The testbench expects one file for each I and Q data stream.  The files must contain hex string data representing 16-bit signed integers, with one sample per line.  A utility is provided in `./boards/e200/utils/iq_to_testbench.py` for generating these hex files.
