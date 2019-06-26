from math import *
import matplotlib.pyplot as plt
import numpy as np

n = 100
def f(x):
    return 1/np.sqrt(1+x**2)

L = np.linspace(0 , 1 ,n, endpoint=False)

fct = []
for i in L:
    fct.append(f(i))

'''
pyplot.scatter([0, 1, 2, 3, 4], [0, 2.4, 4.2, 5.6, 8.2],
           c = ['cyan', 'skyblue', 'blue', 'navy', 'black'],
           s = [110, 90, 70, 50, 30],
           marker = 'o', edgecolors = 'none')
pyplot.plot([0, 4], [0, 8], color = 'red', linestyle = 'solid')
'''

def q3():
    plt.scatter(L, fct, marker='+', c='skyblue')
    plt.plot(L, fct, color='red', linestyle='solid')
    plt.show()

def rect(f, n):
    R = 0
    t = 0
    h = 1/n
    while t < 1: #on arrive à h
        R = R+h*f(t)
        t = t+h
    return R

def trap(f, n):
    T = 0
    h = 1/n
    L = np.linspace(0, 1, n, endpoint=False) #sans le dernier element
    # ou L=np.linspace(0,1,n+1)[:-1]

    for t in L:
        T = T+(f(t)+f(t+h))*h/2
    return T

def simps(f,n):
    S = 0
    h = 1/n
    L = np.linspace(0,1,n, endpoint=False) #sans le dernier element
    for t in L:
        S = S+(f(t)+4*f(t+h/2)+f(t+h))*h/6
    return S


npTrap = np.trapz(fct, L)


for k in range(7):
    approx = simps(f, 10**k)
    print("k=%i, I_approx=%f" % (k, approx))

#q3()
