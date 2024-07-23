import subprocess
from pynq import Overlay

ol = Overlay("/home/xilinx/jupyter_notebooks/base/base.bit", dtbo="/home/xilinx/jupyter_notebooks/base/pl.dtbo")
subprocess.run(["systemctl", "restart", "iiod"])