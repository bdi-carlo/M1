#-*- coding: utf-8 -*-

#ma_chaine = "Hello World"
#print(ma_chaine)

def q2():
    f = open("dico.txt","r",encoding="utf-8")
    n = int(input("Nombre de ligne à afficher? "))
    for i in range(0, n) :
        print(f.readline().strip())

def AfficherLigne(line):
    i=0
    f = open("dico.txt","r",encoding="utf-8")
    while i < int(line):
        l = f.readline()
        i+=1
    f.close()
    return l.split(";")

def StockerLigne(line, dicPron):
	l = AfficherLigne(line)
	dicPron[l[0]] = l[2].split("\n")[0]
	return dicPron

def AfficherPron(m, dicPron):
    if(m in dicPron):
        print(dicPron[m])
    else:
        print(m, "n'est pas dans le dictionnaire.")

def AfficherMots(p, dicPron):
    liste = []
    nb = 0

    for i in dicPron:
        if dicPron[i] == p:
            liste.append(i)
            nb += 1

    print(liste)
    print("Il y a", nb, "mots qui se prononcent:", p)

def main():
    dic = dict()

    StockerLigne(2, dic)
    StockerLigne(1, dic)
    StockerLigne(10, dic)
    StockerLigne(7318, dic)
    #print("Dictionnaire\n", dic)

    AfficherMots(" k u l e", dic)

if __name__ == "__main__":
    main()
