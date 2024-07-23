SD ?=
SD_MSG := "ERROR: SD is not set. Please provide the path to your SD card mount directory."

all: base pynq sdimg dtbo

base:
	$(MAKE) -C ./boards/e200/base/antsdre200 ADI_IGNORE_VERSION_CHECK=1
	cp ./boards/e200/base/antsdre200/antsdre200.runs/impl_1/system_top.bit ./boards/e200/base/base.bit
	mkdir -p ./boards/e200/petalinux_bsp/hardware_project/ && cp ./boards/e200/base/antsdre200/antsdre200.sdk/system_top.xsa ./boards/e200/petalinux_bsp/hardware_project/base.xsa
	cp ./boards/e200/base/antsdre200/antsdre200.gen/sources_1/bd/system/hw_handoff/system.hwh ./boards/e200/base/base.hwh
	python3 ./boards/e200/notebooks/hwh_patch.py -f ./boards/e200/base/base.hwh
	
pynq/kernel:
	rm -rf ./PYNQ/boards/e200
	cp -r ./boards/e200 ./PYNQ/boards
	$(MAKE) -C ./PYNQ/sdbuild BOARDS=e200 boot_files

pynq:
	rm -rf ./PYNQ/boards/e200
	cp -r ./boards/e200 ./PYNQ/boards
	$(MAKE) -C ./PYNQ/sdbuild BOARDS=e200

sdimg:
	$(MAKE) -C ./e200_boot_gen sdimg

dtbo:
	$(MAKE) -C ./PYNQ-PRIO/device_tree_overlays BOARDS=e200

sd:
	@[ "${SD}" ] || ( echo $(SD_MSG); exit 1 )
	sudo cp -f ./e200_boot_gen/build_sdimg/BOOT.bin $(SD)/PYNQ
	sudo cp -f ./boards/e200/utils/boot.py $(SD)/PYNQ
	sudo mkdir -p $(SD)/root/home/xilinx/jupyter_notebooks/base
	sudo cp -f ./boards/e200/base/base.bit $(SD)/root/home/xilinx/jupyter_notebooks/base
	sudo cp -f ./boards/e200/base/base.hwh $(SD)/root/home/xilinx/jupyter_notebooks/base
	sudo cp -f ./boards/e200/base/pl.dtbo $(SD)/root/home/xilinx/jupyter_notebooks/base
	sudo cp -f ./boards/e200/base/notebooks/pynq_iio.ipynb $(SD)/root/home/xilinx/jupyter_notebooks/base
	
clean: clean/base clean/pynq

clean/base:
	$(MAKE) -C ./boards/e200/base/antsdre200 clean
	rm -rf ./boards/e200/base/base.bit
	rm -rf ./boards/e200/base/base.hwh
	rm -rf boards/e200/petalinux_bsp/hardware_project/base.xsa

clean/pynq:
	$(MAKE) -C ./PYNQ/sdbuild clean

clean/sdimg:
	$(MAKE) -C ./e200_boot_gen clean