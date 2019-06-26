import numpy.random as rand
import matplotlib.pyplot as plt
import numpy as np
import math

N = 1000

x = np.linspace(0, 9, num=N)

y_uni = rand.uniform(0, 10, N)
y_norm = rand.normal(4, 1.5, N)
y_triangle = rand.triangular(0, 4, 9, N)
y_expo = rand.exponential(4, N)

y_uni.sort()
y_norm.sort()
y_triangle.sort()
y_expo.sort()

#La loi normale est déjà triée de base

y = y_triangle

plt.plot(x, y)
y.sort()
plt.plot(x, y_uni)
plt.plot(x, y_norm)
plt.plot(x, y_triangle)
plt.plot(x, y_expo)
plt.xlabel("x")
plt.ylabel("y")
plt.title("y en fonction de x")

#plt.hist(y,20)
plt.show()

