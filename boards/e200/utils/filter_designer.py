# Adapted from https://github.com/tomverbeure/pdm/blob/d58bd3fa5f0d9449b1aaf5f70eee91fec940d670/modeling/tools/filter_lib.py

import numpy as np
import scipy.signal as sig
import matplotlib.pyplot as plt
import argparse

def to_dB(array):
    """ Converts an input amplitude array to decibels

    Args:
        array (ArrayLike): Input array of amplitude values

    Returns:
        ArrayLike: Output array of values in dB
    """
    with np.errstate(divide='ignore'):
        return 20 * np.log10(np.abs(array))


def fir_design(Fs, Fpass, Fstop, Ap, As, N):
    """ Generates an FIR low-pass filter impulse response based on the input filter parameters

    Args:
        Fs (float): Sampling frequency
        Fpass (float): Passband frequency
        Fstop (float): Stopband frequency
        Ap (float): Passband amplitude
        As (float): Stopband amplitude
        N (int): Filter order

    Returns:
        ArrayLike: Generated filter impulse response
    """
    bands = np.array([0, Fpass/Fs, Fstop/Fs, 0.5])

    err_pb = (1 - 10**(-Ap/20))/2 # passband error
    err_sb = 10**(-As/20) # stopband error

    w_pb = 1 / err_pb
    w_sb = 1 / err_sb
    
    # Filter impulse response
    h = sig.remez(
            N+1,          # Number of taps
            bands,        # Frequency bands
            [1, 0],       # Desired gain in passband and stopband
            [w_pb, w_sb]  # Band weighting
            )               
    
    # Filter magnitude response
    (w, H) = sig.freqz(h)
    
    # Get passband and stopband response characteristics
    Hp_min = min(np.abs(H[0:int(Fpass/Fs*2 * len(H))]))
    Hp_max = max(np.abs(H[0:int(Fpass/Fs*2 * len(H))]))
    Hs_max = max(np.abs(H[int(Fstop/Fs*2 * len(H)+1):len(H)]))
    
    Rp = 1 - (Hp_max - Hp_min)
    Rs = Hs_max

    return (h, w, H, Rp, Rs, Hp_min, Hp_max, Hs_max)


def fir_design_optimal(Fs, Fpass, Fstop, Ap, As, Nmin = 1, Nmax = 1000):
    """ Generates a minimum-order FIR low-pass filter for the given filter parameters

    Args:
        Args:
        Fs (float): Sampling frequency
        Fpass (float): Passband frequency
        Fstop (float): Stopband frequency
        Ap (float): Passband amplitude
        As (float): Stopband amplitude
        Nmin (int): Minimum filter order
        Nmax (int): Maximum filter order

    Returns:
        ArrayLike: Generated filter impulse response
    """
    for N in range(Nmin, Nmax):
        (h, w, H, Rp, Rs, Hp_min, Hp_max, Hs_max) = fir_design(Fs, Fpass, Fstop, Ap, As, N)
        if (-to_dB(Rp) <= Ap) and (-to_dB(Rs) >= As):
            return h
    return None


def plot_mag_response(h, Fs, ax=None, show=True, **kwargs):
    """ Plots a filter magnitude response

    Args:
        h (ArrayLike): Filter impuse response
        Fs (float): Sampling frequency
    """
    (w, H) = sig.freqz(h)
    
    if ax is None:
        _, ax = plt.subplots()
    
    ax.plot(w/np.pi/2*Fs, to_dB(H), **kwargs)
    ax.grid(True)
    ax.set_title(f"Magnitude Reponse\nN = {len(h)-1}")
    ax.set_xlabel("Frequency (Hz)")
    ax.set_ylabel("Magnitude (dB)")
    ax.set_xlim(0, Fs/2)
    if 'label' in kwargs:
        ax.legend()
    if show:
        plt.show()
    
    return ax


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Converts interleaved complex short to hex for modelsim imput")
    parser.add_argument('-fs', '--sampling_freq', nargs='?', default=1, type=float, help="Sampling frequency (Hz)")
    parser.add_argument('-fpass', '--passband_freq', type=float, help="Passband frequency (Hz)")
    parser.add_argument('-fstop', '--stopband_freq', type=float, help="Stopband frequency (Hz)")
    parser.add_argument('-apass', '--passband_ripple', type=float, help="Passband ripple (dB)")
    parser.add_argument('-astop', '--stopband_atten', type=float, help="Stopband attenuation(dB)")
    parser.add_argument('-n', '--order', nargs='?', default=None, type=float, help="Filter order")
    
    args = parser.parse_args()

    if args.order is None:
        h = fir_design_optimal(args.sampling_freq, args.passband_freq, args.stopband_freq, args.passband_ripple, args.stopband_atten)
    else:
        h = fir_design(args.sampling_freq, args.passband_freq, args.stopband_freq, args.passband_ripple, args.stopband_atten, args.order)
    
    plot_mag_response(h, args.sampling_freq)