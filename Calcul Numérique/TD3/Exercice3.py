import numpy.random as rand
import matplotlib.pyplot as plt
import numpy as np
import math
import scipy.io.wavfile as wavfile

N = 10000

x = np.linspace(-2, 2, num=N)
norm = rand.normal(0, 1, N)
norm.sort()

plt.plot(x, norm)
#plt.hist(norm, bins=100, range=[-2,2])
plt.show()
