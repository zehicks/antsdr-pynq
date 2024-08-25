import numpy as np
from collections import deque
import argparse
import matplotlib.pyplot as plt
from fpbinary import FpBinary, FpBinaryComplex, OverflowEnum, RoundingEnum
import filter_designer


def fi_fir(x_float, h_float, x_q=(1,15), h_q=(1,15), y_q=(1,15), M=1, real=False):
    """ Performs FIR filtering of an input sequence using the given FIR impulse response.
    Uses full-scale fixed-point arithmetic for all intermediate values

    Args:
        x (ArrayLike): Input data array
        h_float (ArrayLike): FIR impulse response represented in floating-point
        x_q (tuple[int]): Tuple of input data quantization (int_bits, frac_bits)
        h_q (tuple[int]): Tuple of impulse response quantization (int_bits, frac_bits)
        y_q (tuple[int]): Tuple of output data quantization (int_bits, frac_bits)
        M (int): Polyphase decimation factor
    """
    N = len(h_float) # filter length
    data_len = len(x_float) # data length
    
    # Parse quantization levels
    x_int_width = x_q[0]
    x_frac_width = x_q[1]
    h_int_width = h_q[0]
    h_frac_width = h_q[1]
    
    # Define accumulator width
    bit_growth = np.ceil(np.log2(np.sum(h_float)))
    accum_width = sum(x_q) + bit_growth
    out_frac_width = x_frac_width + h_frac_width - np.max([0, accum_width-sum(y_q)])

    # Convert input data to fixed-point
    x_float = np.concatenate((x_float, np.zeros(N-1))) # pad input data to flush filter taps
    x = []
    if not real:
        for val in x_float:
            x.append(FpBinaryComplex(int_bits=x_int_width, frac_bits=x_frac_width, value=val))
    else:
        for val in x_float:
            x.append(FpBinary(int_bits=x_int_width, frac_bits=x_frac_width, value=val))
    
    # Convert impulse response to fixed-point
    h = []
    for coef in h_float:
        h.append(FpBinary(int_bits=h_int_width, frac_bits=h_frac_width, signed=True, value=coef))

    # Reshape impulse response into polyphase components
    if M > 1:
        h = np.concatenate((h, np.zeros(M-(len(h) % M))))
        N = len(h) # padded filter length
    h_poly = np.reshape(h, newshape=(M, len(h)//M), order='F')
    
    # Create filter tapped delay lines for each phase
    z = []
    n_phases = h_poly.shape[0]
    for i in range(n_phases):
        z.append(deque(N//M*[FpBinary(int_bits=(x_int_width+h_int_width), frac_bits=(x_frac_width+h_frac_width), value=0)], maxlen=N//M))

    # Loop over all input values to calculate filter outputs
    if not real:
        y = np.zeros((N+data_len-1)//M, dtype=FpBinaryComplex)
    else:
        y = np.zeros((N+data_len-1)//M, dtype=FpBinary)
    
    y_idx = 0
    phase = 0
    for val in x:
        # Shift sample into filter tapped delay line for the current phase
        z[phase].appendleft(val)
        phase += 1

        # Calculate current filter output after a sample has been delivered to each phase
        if phase == M:
            accum = np.sum([np.dot(z[i], h_poly[i]) for i in range(n_phases)])
            y[y_idx] = accum.resize(y_q)
            y_idx += 1
            phase = 0

    return y, h


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Converts an FIR filter to fixed-point format")
    parser.add_argument('-fs', '--sampling_freq', nargs='?', default=1, type=float, help="Sampling frequency (Hz)")
    parser.add_argument('-fpass', '--passband_freq', default=0.3, type=float, help="Passband frequency (Hz)")
    parser.add_argument('-fstop', '--stopband_freq', default=0.4, type=float, help="Stopband frequency (Hz)")
    parser.add_argument('-apass', '--passband_ripple', default=1, type=float, help="Passband ripple (dB)")
    parser.add_argument('-astop', '--stopband_atten', default=40, type=float, help="Stopband attenuation(dB)")
    parser.add_argument('-n', '--order', nargs='?', default=None, type=float, help="Filter order")
    parser.add_argument('-M', '--decimation', nargs='?', default=2, type=float, help="Polyphase decimation factor")
    parser.add_argument('-xq', '--x_quant', nargs='?', default="1,15", type=str, help="Input signal quantization as a comma-separated list")
    parser.add_argument('-hq', '--h_quant', nargs='?', default="1,15", type=str, help="Coefficient quantization as a comma-separated list")
    parser.add_argument('-yq', '--y_quant', nargs='?', default="1,15", type=str, help="Output signal quantization as a comma-separated list")
    
    args = parser.parse_args()

    # Create tuple from quantization values
    xq = tuple([int(val) for val in args.x_quant.split(',')])
    hq = tuple([int(val) for val in args.h_quant.split(',')])
    yq = tuple([int(val) for val in args.y_quant.split(',')])

    # Create an FIR filter from the given parameters
    if args.order is None:
        h = filter_designer.fir_design_optimal(args.sampling_freq, args.passband_freq, args.stopband_freq, args.passband_ripple, args.stopband_atten)
    else:
        h = filter_designer.fir_design(args.sampling_freq, args.passband_freq, args.stopband_freq, args.passband_ripple, args.stopband_atten, args.order)
    
    # Quantize the filter and generate an impulse response
    x = np.arange(-1, 1, 0.1) + 1j*np.arange(-1, 1, 0.1)
    y, h_fi = fi_fir(x, h, xq, hq, yq, M=args.decimation)
    
    # Plot the floating-point and fixed-point magnitude responses together for comparison
    ax = filter_designer.plot_mag_response(h, args.sampling_freq, ax=None, show=False, label="Float", color="b", linestyle='-')
    filter_designer.plot_mag_response(h_fi, args.sampling_freq, ax=ax, label=f"Q({hq[0]},{hq[1]})", color='r', linestyle='--')