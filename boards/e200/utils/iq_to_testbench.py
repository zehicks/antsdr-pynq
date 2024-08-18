#!/usr/bin/python3

import numpy as np
import matplotlib.pyplot as plt
import argparse
import struct

def convert_iq(filename=None, out=None, length=None, tone_freqs=None, fs=None, trim=0, scale=1, debug=0):
    # Load file if given
    if filename is not None:
        IQ = np.fromfile(filename, dtype=np.int16)
        # Separate I and Q
        I = (IQ[::2]).tolist()
        Q = (IQ[1::2]).tolist()
    else:
        filename = "tones.dat"
        t = np.arange(0, 0.1, 1/fs)
        IQ = np.zeros(t.size, dtype=np.complex128)
        for f in tone_freqs:
            IQ += 32767*np.exp(1j*2*np.pi*f*t)
        I = np.real(IQ).astype(np.int16).tolist()
        Q = np.imag(IQ).astype(np.int16).tolist()

    if length is None:
        I = I[int(trim):]
        Q = Q[int(trim):]
    else:
        I = I[int(trim):int(trim)+length]
        Q = Q[int(trim):int(trim)+length]
        
    # Scale up
    I = [i * scale for i in I]
    Q = [q * scale for q in Q]
    
    if (debug):
        plt.plot(I)
        plt.show()
        
    # Write data to file for MATLAB/Python model, skip first sample for FPGA reset in testbench
    IQ = np.empty((len(I) + len(Q),), dtype=np.int16)
    IQ[0::2] = I[:length]
    IQ[1::2] = Q[:length]
    
    # Set out filename if given
    if out is None:
        out_filename = filename.split('/')[-1].split('.')[0]
    else:
        out_filename = out
    
    IQ_filename = "tb_" + out_filename + ".ic16"
    IQ_file = open(IQ_filename, 'wb')
    IQ_file.write(IQ)
    IQ_file.close()

    # Append leading 0 for FPGA reset in testbench
    I.insert(0, 0)
    Q.insert(0, 0)
    
    # Convert to  32-bit hex strings for testbench
    I_txt = "\n".join(int16_to_hex_string(sample) for sample in I)
    Q_txt = "\n".join(int16_to_hex_string(sample) for sample in Q)

    # Create out filenames
    I_filename = "tb_" + out_filename + "_I.hex"
    Q_filename = "tb_" + out_filename + "_Q.hex"

    # Write data
    I_file = open(I_filename, 'w')
    I_file.write(I_txt)
    I_file.close()

    Q_file = open(Q_filename, 'w')
    Q_file.write(Q_txt)
    Q_file.close() 
    print(f"Done converting {filename}")


def int16_to_hex_string(value):
    if value < 0:
        value += 2**16
    return f"{value:04X}"


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Converts interleaved complex short to hex for modelsim imput")
    parser.add_argument('-f', '--filename', nargs='?', default=None, type=str, help="IQ file name")
    parser.add_argument('-o', '--out', nargs='?', default=None, type=str, help="output file name")
    parser.add_argument('-p', '--parameters', nargs='?', default=None, type=str, help="Comma-separated list of tones, followed by the sample rate")
    parser.add_argument('-l', '--length', nargs='?', default=None, type=int, help="Number of samples to write")
    parser.add_argument('-t', '--trim', nargs='?', default=0, type=int, help="Number of leading samples to trim")
    parser.add_argument('-s', '--scale', nargs='?', default=1, type=float, help="Scale factor")
    parser.add_argument('-d', '--debug', action='store_true', help="Generate debug plot of signal")
    args = parser.parse_args()
    
    if args.parameters is not None:
        tone_freqs = [int(item) for item in args.parameters.split(',')]
        fs = tone_freqs.pop()
    else:
        tone_freqs = []
        fs = None
    
    convert_iq(args.filename, args.out, args.length, tone_freqs, fs, args.trim, args.scale, args.debug)
