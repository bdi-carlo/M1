import numpy as np
import matplotlib.pyplot as plt
import math
from scipy.io import wavfile

a = 1.5
om = 0
fo = 990
Fe = 1000
Te = 1/Fe

n = np.arange(Fe)
#print (n)
#print (n.dtype)
#print (n.ndim)

t = n.copy()/Fe
#t = np.linspace(0,1,100)
#print (t)

#print (np.where(t==0.5))

x = a*np.sin(2*np.pi*fo*t + om)

plt.plot(t,x)
#plt.stem(t,x)
plt.xlabel("temps (s)")
plt.ylabel("amplitude (UA)")
plt.xlim(0.05, 0.250)
plt.show()

#N1 -> 0.1 		- 0.1
#N2 -> 0.0033 	- 0.003
#N3 -> 0.002	- 0.002
#N4 -> 0.00101	- 0.1

#wavfile.write("sign1", x, Fe)
