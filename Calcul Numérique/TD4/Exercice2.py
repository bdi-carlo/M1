from math import *
import matplotlib.pyplot as plt
import numpy as np

albert = np.random.randint(0, high=100)

def user():
    bertrand = -1
    while bertrand != albert:
        bertrand = int(input("Albert: Guess my number Bertrand :) -> "))
        if bertrand < albert:
            print("Trop petit")
        elif bertrand > albert:
            print("Trop grand")
    print("Bien joue Bertrand :D")

def autoAlea():
    nb =  0
    min = 0
    max = 100
    bertrand = -1
    while bertrand != albert:
        bertrand = np.random.randint(min, high=max)
        if bertrand < albert:
            min = bertrand
        elif bertrand > albert:
            max = bertrand
        nb += 1
    print("Bertrand a gagne en %i coups!" % (nb))
    return nb

def autoMilieu():
    nb =  0
    min = 0
    max = 100
    bertrand = -1
    print(albert)
    while bertrand != albert:
        bertrand = int((min+max)/2)
        if bertrand < albert:
            min = bertrand
        elif bertrand > albert:
            max = bertrand
        nb += 1
    print("Bertrand a gagne en %i coups!" % (nb))
    return nb

#ln(x) + x² = 0
#Ensemble de défitinion = [0;+∞]
#Solutions évidentes:
#

def fonction(x):
    return (np.log(x) + x**2)

def monotonie(inf, sup):
    res = fonction(inf)*fonction(sup)
    '''if res <= 0:
        print("Il existe f(x) = 0 dans [", inf, ";", sup, "]")
    else:
        print("Il n'existe pas f(x) = 0 dans [", inf, ";", sup, "]")
    '''
    return res

def dichotomie(precision):
    n, a, b = 0, 0, 1000

    while b-a > precision:
        m = (a+b)/2
        if monotonie(a, m) <= 0:
            b = m
        else:
            a = m
        n += 1
        #print(n, ":", a, b, b-a)

    print(a , "< solution <", b, "\nn =>", n)

def main():
    dichotomie(0.001)

main()
