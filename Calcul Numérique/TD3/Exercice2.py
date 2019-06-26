import numpy.random as rand
import matplotlib.pyplot as plt
import numpy as np
import math
import scipy.io.wavfile as wavfile

N = 1000

fs, stereo = wavfile.read("td3.wav")

mono = stereo[:,0]/np.max(stereo)
t = np.linspace(1, float(mono.size/fs), num=mono.size)

"""
plt.plot(t, mono)
plt.xlabel("temps (s)")
plt.ylabel("signal")
plt.title("y en fonction de x")
plt.show()
"""

bruit = rand.uniform(-0.05, 0.05, mono.size)
normal = rand.normal(0, 0.01, mono.size)

"""
plt.plot(t, normal)
plt.xlabel("temps (s)")
plt.ylabel("signal")
plt.title("y en fonction de x")
plt.show()
"""

