#!/usr/bin/python3

import numpy as np
import matplotlib.pyplot as plt
import argparse
import struct

def convert_iq(filename=None, out=None, length=None, tone_freqs=None, fs=None, trim=0, scale=1, debug=0):
    # Load file if given
    if filename is not None:
        IQ_in = np.fromfile(filename, dtype=np.complex64)
        I_in = np.real(IQ_in)
        Q_in = np.imag(IQ_in)
    else:
        filename = "tones.dat"
        t = np.arange(0, 0.1, 1/fs)
        IQ = np.zeros(t.size, dtype=np.complex128)
        for f in tone_freqs:
            IQ += 32767*np.exp(1j*2*np.pi*f*t)
        I = np.real(IQ).astype(np.int16).tolist()
        Q = np.imag(IQ).astype(np.int16).tolist()

    # Set output filename if given
    if out is None:
        out_filename = filename.split('/')[-1].split('.')[0]
    else:
        out_filename = out
    
    # Trim IQ file
    if length is None:
        length = IQ.size
        I = I_in[int(trim):]
        Q = Q_in[int(trim):]
    else:
        I = I_in[int(trim):int(trim)+length]
        Q = Q_in[int(trim):int(trim)+length]
        
    # Convert to full-scale int16
    I = float_to_int16(I)
    Q = float_to_int16(Q)

    # Scale down
    I = np.left_shift(I, 4)
    Q = np.left_shift(Q, 4)
    I = np.left_shift(I, scale)
    Q = np.left_shift(Q, scale)

    # Append leading 0 for FPGA reset in testbench
    np.insert(I, 0, 0)
    np.insert(Q, 0, 0)
    
    # Debug plot
    if (debug):
        plt.plot(I)
        plt.show()
    
    # Write data to binary file for MATLAB/Python model
    IQ_interleaved = np.empty((2*length,), dtype=np.int16)
    IQ_interleaved[0::2] = I[:length]
    IQ_interleaved[1::2] = Q[:length]
    
    IQ_filename = "tb_" + out_filename + ".ic16"
    IQ_outfile = open(IQ_filename, 'wb')
    IQ_outfile.write(IQ_interleaved)
    IQ_outfile.close()
    
    # Convert to 16-bit hex strings for testbench input
    I_txt = "\n".join(int16_to_hex_string(sample) for sample in I)
    Q_txt = "\n".join(int16_to_hex_string(sample) for sample in Q)

    # Create hex output filenames
    I_filename = "tb_" + out_filename + "_I.hex"
    Q_filename = "tb_" + out_filename + "_Q.hex"

    # Write hex data
    I_file = open(I_filename, 'w')
    I_file.write(I_txt)
    I_file.close()

    Q_file = open(Q_filename, 'w')
    Q_file.write(Q_txt)
    Q_file.close() 
    print(f"Done converting {filename}")


def float_to_int16(floats):
    floats = np.array(floats).astype(np.float32)
    min = np.min(floats)
    max = np.max(floats)
    norm = (floats - min) / (max - min)
    int16 = (np.round(norm * (2**15-1)) - (2**14)).astype(np.int16)
    return int16


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
    parser.add_argument('-s', '--scale', nargs='?', default=1, type=float, help="Scale factor, given as number of places to left-shift starting from 12 bits")
    parser.add_argument('-d', '--debug', action='store_true', help="Generate debug plot of signal")
    args = parser.parse_args()
    
    if args.parameters is not None:
        tone_freqs = [int(item) for item in args.parameters.split(',')]
        fs = tone_freqs.pop()
    else:
        tone_freqs = []
        fs = None
    
    convert_iq(args.filename, args.out, args.length, tone_freqs, fs, args.trim, args.scale, args.debug)
