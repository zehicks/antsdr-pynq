import fileinput
import argparse

def apply_patch(filename):
    with open(filename, 'r') as file:
        text = file.read()

    backup = text
    text = text.replace('<CONNECTION INSTANCE="sys_rgmii" PORT="mdio_gem_o"/>', '<CONNECTION INSTANCE="sys_rgmii" PORT="mdio_gem_i"/>')
    text = text.replace('<CONNECTION INSTANCE="sys_rgmii" PORT="mdio_gem_i"/>', '<CONNECTION INSTANCE="sys_rgmii" PORT="mdio_gem_o"/>', 1)
    text = text.replace('<PORT DIR="O" NAME="mdio_gem_i" SIGIS="undef" SIGNAME="sys_ps7_ENET0_MDIO_O">', '<PORT DIR="O" NAME="mdio_gem_i" SIGIS="undef" SIGNAME="sys_ps7_ENET0_MDIO_I">')
    text = text.replace('<PORT DIR="I" NAME="mdio_gem_o" SIGIS="undef" SIGNAME="sys_ps7_ENET0_MDIO_I">', '<PORT DIR="I" NAME="mdio_gem_o" SIGIS="undef" SIGNAME="sys_ps7_ENET0_MDIO_O">')
    text = text.replace('<CONNECTION INSTANCE="sys_ps7" PORT="ENET0_MDIO_I"/>', '<CONNECTION INSTANCE="sys_ps7" PORT="ENET0_MDIO_O"/>')
    text = text.replace('<CONNECTION INSTANCE="sys_ps7" PORT="ENET0_MDIO_O"/>', '<CONNECTION INSTANCE="sys_ps7" PORT="ENET0_MDIO_I"/>', 1)
    text = text.replace('<PORTMAP LOGICAL="MDIO_I" PHYSICAL="mdio_gem_o"/>', '<PORTMAP LOGICAL="MDIO_I" PHYSICAL="mdio_gem_i"/>')
    text = text.replace('<PORTMAP LOGICAL="MDIO_O" PHYSICAL="mdio_gem_i"/>', '<PORTMAP LOGICAL="MDIO_O" PHYSICAL="mdio_gem_o"/>')
    
    with open(filename+'.bak', 'w') as file:
        file.write(backup)

    with open(filename, 'w') as file:
        file.write(text)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--file', help='Input .hwh file to patch for PYNQ')
    args = parser.parse_args()

    apply_patch(args.file)