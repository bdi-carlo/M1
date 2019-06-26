couleur(vert).
couleur(jaune).
couleur(rouge).

coloriage(C1,C2,C3,C4) :-
couleur(C1), couleur(C2), C1 \= C2,
couleur(C3), C1 \= C3, C2 \= C3,
couleur(C4), C1 \= C4, C3 \= C4.

/* Plus efficace en testant dès que les couleurs sont instanciées */

menu :-
    write('                          '),nl,
    write('   1. choisir une couleur à une position  '),nl,
    write('   2. coloriage automatique  '),nl,
    write('                          '),nl,
    write('===>'),nl,
    read(X), choice(X).
    
    choice(1) :- write('A faire'),nl.
    
    choice(2) :- coloriage(C1,C2,C3,C4), write(C1 ), write(C2 ), write(C3 ), write(C4 ), nl.
    	
