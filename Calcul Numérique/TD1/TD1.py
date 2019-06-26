#Exercice 1
#print("Exercice 1\n")
var_int = 1
type(var_int)
type(float(var_int))
bool(15641)
bool(None)
#print("valeur : ",var_int)
tab = [0,1,2,3,4]
tab[1]
#print(list(range(10,20,2)))

#Exercice 2
print("\nExercice 2\n")
#var = input("Saisir une valeur -> ")
#print("Vous avez saisi: ",var)

f = open("test.txt","r",encoding="utf-8")
print("Avant:")
for line in f :
    print(line)
f.close()

new = input("Saisir ce que vous voulez rajouter: ")
f = open("test.txt","a",encoding="utf-8")
f.write(new)
f.close()
f = open("test.txt","r",encoding="utf-8")
print("\nApres:")
for line in f :
    print(line)
f.close()
