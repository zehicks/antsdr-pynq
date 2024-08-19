#!/usr/bin/python3

import numpy as np
import scipy.signal as sig
import matplotlib.pyplot as plt
import argparse
import struct

def convert_iq(in_file=None, out_file=None, out_dir=None, waveform=None, length=None, params=None, fs=None, trim=0, scale=1, debug=0):
    # Load file if given
    if in_file is not None:
        IQ_in = np.fromfile(in_file, dtype=np.complex64)

    # Generate chirp
    elif waveform == 'chirp':
        in_file = "chirp.dat"
        if length is None:
            t = np.arange(0, 0.1, 1/fs)
        else:
            t = 0 + np.arange(0, length) * 1/fs
        print(t.size)
        f = np.linspace(params[0], params[1], t.size)
        IQ_in = np.exp(1j*2*np.pi*f*t)
        print(f"Generated chirp of duration {t[-1]} seconds")
    
    # Generate tones
    elif waveform == 'tone':
        in_file = "tones.dat"
        if length is None:
            t = np.arange(0, 0.1, 1/fs)
        else:
            t = 0 + np.arange(0, length) * 1/fs
        IQ_in = np.zeros(t.size, dtype=np.complex64)
        for f in params:
            IQ_in += np.exp(1j*2*np.pi*f*t)
        print(f"Generated tones of duration {t[-1]} seconds")

    I = np.real(IQ_in)
    Q = np.imag(IQ_in)
    
    # Trim IQ file
    if length is None:
        I = I[int(trim):]
        Q = Q[int(trim):]
        length = I.size
    else:
        I = I[int(trim):int(trim)+length]
        Q = Q[int(trim):int(trim)+length]

    # Set output filename if given
    if out_file is None:
        out_filename = in_file.split('/')[-1].split('.')[0]
    else:
        out_filename = out_file
        
    # Convert to full-scale int16
    I = float_to_int16(I)
    Q = float_to_int16(Q)

    # Scale down
    I = np.right_shift(I, 4)
    Q = np.right_shift(Q, 4)
    I = np.right_shift(I, scale)
    Q = np.right_shift(Q, scale)

    # Append leading 0 for FPGA reset in testbench
    np.insert(I, 0, 0)
    np.insert(Q, 0, 0)
    
    # Debug plot
    if (debug):
        plt.figure()
        plt.plot(I)
        plt.title("Scaled int16")
        plt.show()
    
    # Write data to binary file for MATLAB/Python model
    IQ_interleaved = np.empty((2*length,), dtype=np.int16)
    IQ_interleaved[0::2] = I[:length]
    IQ_interleaved[1::2] = Q[:length]
    
    IQ_filename = out_dir + "/" + "tb_" + out_filename + ".ic16"
    IQ_outfile = open(IQ_filename, 'wb')
    IQ_outfile.write(IQ_interleaved)
    IQ_outfile.close()
    
    # Convert to 16-bit hex strings for testbench input
    I_txt = "\n".join(int16_to_hex_string(sample) for sample in I)
    Q_txt = "\n".join(int16_to_hex_string(sample) for sample in Q)

    # Create hex output filenames
    I_filename = out_dir + "/" + "tb_" + out_filename + "_I.hex"
    Q_filename = out_dir + "/" + "tb_" + out_filename + "_Q.hex"

    # Write hex data
    I_file = open(I_filename, 'w')
    I_file.write(I_txt)
    I_file.close()

    Q_file = open(Q_filename, 'w')
    Q_file.write(Q_txt)
    Q_file.close() 
    print(f"Done converting {in_file}")


def float_to_int16(floats):
    floats = np.array(floats).astype(np.float32)
    min = np.min(floats)
    max = np.max(floats)
    norm = (floats - min) / (max - min)

    int16_max = 2**15-1
    int16_min = -2**15
    
    scaled = norm * (int16_max - int16_min) + int16_min
    clipped = np.clip(scaled, int16_min, int16_max)
    int16 = clipped.astype(np.int16)
    
    return int16


def int16_to_hex_string(value):
    if value < 0:
        value += 2**16
    return f"{value:04X}"


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Converts interleaved complex short to hex for modelsim imput")
    parser.add_argument('-if', '--input_file', nargs='?', default=None, type=str, help="Input IQ file")
    parser.add_argument('-w', '--waveform', nargs='?', default=None, type=str, help="Waveform type, from {tone, chirp}")
    parser.add_argument('-wp', '--waveform_params', nargs='?', default=None, type=str, help="Comma-separated list of tones or chirp start/stop, followed by the sample rate")
    parser.add_argument('-of', '--output_file', nargs='?', default=None, type=str, help="output file name")
    parser.add_argument('-od', '--output_dir', nargs='?', default=None, type=str, help="output directory")
    parser.add_argument('-l', '--length', nargs='?', default=None, type=int, help="Number of samples to write")
    parser.add_argument('-t', '--trim', nargs='?', default=0, type=int, help="Number of leading samples to trim")
    parser.add_argument('-s', '--scale', nargs='?', default=1, type=float, help="Scale factor, given as number of places to left-shift starting from 12 bits")
    parser.add_argument('-d', '--debug', action='store_true', help="Generate debug plot of signal")
    args = parser.parse_args()
    
    if args.waveform_params is not None:
        waveform_params = [int(item) for item in args.waveform_params.split(',')]
        fs = waveform_params.pop()
    else:
        waveform_params = []
        fs = None
    
    convert_iq(args.input_file, args.output_file, args.output_dir, args.waveform, args.length, waveform_params, fs, args.trim, args.scale, args.debug)
