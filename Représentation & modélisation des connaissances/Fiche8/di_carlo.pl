/*************************************/
/**   jeu de tic-tactoe             **/
/*************************************/

% Predicat : afficheLigne/1
afficheLigne([A,B,C]) :-
	write(A), tab(3),
	write(B), tab(3),
	write(C), tab(3).
/*
?- afficheLigne([x,o,o]).
Affiche la liste sous forme de ligne
*/


% Predicat : afficheGrille/1
afficheGrille([[A1,B1,C1],[A2,B2,C2],[A3,B3,C3]]) :-
	afficheLigne([A1,B1,C1]), nl,
	afficheLigne([A2,B2,C2]), nl,
	afficheLigne([A3,B3,C3]).
/*
?- afficheGrille([[x,o,o],[x,-,o],[x,o,-]]).
Affiche les 3 lignes sous forme de grille de jeu
*/


% Predicat : succNum/2
succNum(1,2).
succNum(2,3).
/*
?- succNum(2,1).
?- succNum(2,3).
Renvoie vrai si l'argument 2 est le successeur de l'argument 1 entre 1 et 2 compris
*/


% Predicat : succAlpha/2
succAlpha(a,b).
succAlpha(b,c).
/*
?- succAlpha(c,b).
?- succAlpha(a,b).
Renvoie vrai si l'argument 2 est le successeur de l'argument 1 entre a et b compris
*/


% Predicat : ligneDeGrille(NumLigne, Grille, Ligne).
% Satisfait si Ligne est la ligne numero NumLigne dans la Grille
ligneDeGrille(1, [Test |_], Test).
ligneDeGrille(NumLigne, [_|Reste],Test) :- succNum(I, NumLigne),
		ligneDeGrille(I,Reste,Test).
/*
?- ligneDeGrille(2, [[x,o,o],[x,-,o],[x,o,-]], [x,-,o]). true
?- ligneDeGrille(2, [[x,o,o],[x,-,o],[x,o,-]], [x,-,-]). false
Si il n'y a pas de correspondance -> false
*/


% Predicat : caseDeLigne(Col, Liste, Valeur).
% Satisfait si Valeur est dans la colonne Col de la Liste
caseDeLigne(a, [A|_],A).
caseDeLigne(Col, [_|Reste],Test) :- succAlpha(I, Col),caseDeLigne(I,Reste, Test).
/*
?- caseDeLigne(a, [x,o,o], x). true
?- caseDeLigne(b, [x,o,o], x). false
*/


% Predicat : caseDeGrille(NumCol, NumLigne, Grille, Case).
% Satisfait si Case est la case de la Grille en position NumCol-NumLigne
caseDeGrille(C,L,G, Elt) :- ligneDeGrille(L,G,Res),caseDeLigne(C,Res,Elt).
/*
?- caseDeGrille(a,1,[[x,o,o],[x,-,o],[x,o,-]],x). true
?- caseDeGrille(a,1,[[x,o,o],[x,-,o],[x,o,-]],o). false
Simple vérification d'une case dans la grille
*/


% Predicat : afficheCaseDeGrille(Colonne,Ligne,Grille) .
afficheCaseDeGrille(C,L,G) :- caseDeGrille(C,L,G,Case),write(Case).
/*
?- afficheCaseDeGrille(a,1,[[x,o,o],[x,-,o],[x,o,-]]). x
?- afficheCaseDeGrille(a,4,[[x,o,o],[x,-,o],[x,o,-]]). false
Affiche une case dans la grille si en dehors de la grille alors false
*/


% Predicat : leCoupEstValide/3
leCoupEstValide(C,L,G) :- caseDeGrille(C,L,G,-).
/*
?- leCoupEstValide(a,1,[[x,o,o],[x,-,o],[x,o,-]]). false
?- leCoupEstValide(b,2,[[x,o,o],[x,-,o],[x,o,-]]). true
Vérifie si on peut jouer à la case correspondante
*/


% Predicat : coupJoueDansLigne/4
% version bof : on enum�re toutes les possibilites
coupJoueDansLigneBof(a, Val, [-, X, Y], [Val, X, Y]).
coupJoueDansLigneBof(b, Val, [X, -, Y], [X, Val, Y]).
coupJoueDansLigneBof(c, Val, [X, Y, -], [X, Y, Val]).



% version recursive
coupJoueDansLigne(a, Val, [-|Reste],[Val|Reste]).
coupJoueDansLigne(NomCol, Val, [X|Reste1],[X|Reste2]):-
		succAlpha(I,NomCol),
		coupJoueDansLigne(I, Val, Reste1, Reste2).
/*
Joue un coup de la valeur Val dans la ligne à la bonne colonne et renvoie true si il a pu jouer false sinon
*/


% Predicat : coupJoueDansGrille/5
coupJoueDansGrille(NCol,1,Val,[A|Reste],[B|Reste]):- coupJoueDansLigne(NCol, Val, A, B).
coupJoueDansGrille(NCol, NLig, Val, [X|Reste1], [X|Reste2]):- succNum(I, NLig),
					coupJoueDansGrille(NCol, I, Val, Reste1, Reste2).
/*
Joue un coup de la valeur Val dans la grille au bon endroit, si c'est à la première ligne on fais juste appel à coupJoueDansLigne
*/
%  ?- coupJoueDansGrille(a,2,x,[[-,-,x],[-,o,-],[x,o,o]],V).
%  V = [[-,-,x],[x,o,-],[x,o,o]] ;
%  no



% Predicat : ligneFaite/2
%
% version bof : le jeu ne pourra pas �tre etendu � des cases 4*4, etc...
% ligneFaiteBof(x,[x,x,x]).
% ligneFaiteBof(o,[o,o,o]).
% ligneFaiteBof(-,[-,-,-]).
ligneFaite(Val, [Val]).
ligneFaite(Val, [Val|R]) :- ligneFaite(Val, R).
/*
?- ligneFaite(x,[x,x,x]). true
?- ligneFaite(-,[x,x,x]). false
?- ligneFaite(x,[-,x,x]). false
Vérifie si la ligne est bien composée entierement de la valeur Val
*/


% Predicat : ligneExiste/3
% ?- ligneExiste(x,[[x,-,x],[x,x,x],[-,o,-]],V).
% V = 2 ;
ligneExiste(Val, [L1|_], 1) :- ligneFaite(Val, L1).
ligneExiste(Val, [_|R], NumLigne) :- succNum(I,NumLigne), ligneExiste(Val, R, I).
/*
Renvoie le n° de ligne dans V où la ligne est faite avec la valeur Val si aucune ligne faite false
*/


% Predicat : colonneExiste/3
colonneExiste(Val, [[Val|_],[Val|_],[Val|_]], a).
colonneExiste(Val, [[_|R1],[_|R2],[_|R3]], NomCol) :-
	succAlpha(I,NomCol),
	colonneExiste(Val, [R1,R2,R3], I).
/*
?- colonneExiste(x,[[x,-,x],[x,x,x],[-,o,-]],a). false
?- colonneExiste(x,[[x,-,x],[x,x,x],[x,o,-]],a). true
Vérifie si la colonne NomCol est faite de Val
*/


% Predicats diagonaleDG/2 et diagonaleGD/2
diagonaleGD(Val, [[Val,_,_],[_,Val,_],[_,_,Val]]).
diagonaleDG(Val, [[_,_,Val],[_,Val,_],[Val,_,_]]).
/*
?- diagonaleGD(x,[[x,-,x],[-,x,x],[-,o,x]]). true
?- diagonaleGD(x,[[x,-,x],[-,x,x],[-,o,-]]). false
Vérifie la diagonale gauche-droite ou droite-gauche si elle faite de la valeur Val
*/


% Predicat partieGagnee/2
partieGagnee(Val, G) :- ligneExiste(Val, G, _).
partieGagnee(Val, G) :- colonneExiste(Val, G, _).
partieGagnee(Val, G) :- diagonaleGD(Val, G).
partieGagnee(Val, G) :- diagonaleDG(Val, G).
/*
Vérifie à l'aide des 4 derniers prédicats si la partie est gagnée ou non
*/


% ?- partieGagnee(x, [[-,-,x],[-,o,-],[x,o,o]]).
% no
% ?- partieGagnee(x, [[-,-,x],[-,x,-],[x,o,o]]).
% yes --> diagonale
% ?- partieGagnee(o,[[o,-,-],[o,-,-],[o,-,-]]).
% yes --> colonne
% ?- partieGagnee(b,[[b,b,b],[g,z,t],[e,t,y]]).
% yes --> ligne



% coordonneesOuListe(NomCol, NumLigne, Liste).
% ?- coordonneesOuListe(a, 2, [a,2]). vrai.
coordonneesOuListe(NomCol, NumLigne, [NomCol, NumLigne]).
/*
Permet à partir d'une liste de coordonnées d'avoir la ligne d'un côté et la colonne de l'autre
*/


% duneListeALautre(LC1, Case, LC2)
% ?- duneListeALautre([[a,1],[a,2],[a,3]], [a,2], [[a,1],[a,3]]). est vrai
duneListeALautre([A|B], A, B).
duneListeALautre([A|B], C, [A|D]):- duneListeALautre(B,C,D).


% toutesLesCasesValides(Grille, LC1, C, LC2).
% Se verifie si l'on peut jouer dans la case C de Grille et que la liste
% LC1 est une liste composee de toutes les cases de LC2 et de C.
% Permet de dire si la case C est une case ou l'on peut jouer, en evitant
% de jouer deux fois dans la meme case.
toutesLesCasesValides(Grille, LC1, C, LC2) :-
	coordonneesOuListe(Col, Lig, C),
	leCoupEstValide(Col, Lig, Grille),
	duneListeALautre(LC1, C, LC2).

toutesLesCasesDepart([[a,1],[a,2],[a,3],[b,1],[b,2],[b,3],[c,1],[c,2],[c,3]]).

grilleDeDepart([[-,-,-],[-,-,-],[-,-,-]]).

campCPU(x).


campAdverse(x,o).
campAdverse(o,x).

joueLeCoup(Case, Valeur, GrilleDep, GrilleArr) :-
	coordonneesOuListe(Col, Lig, Case),
	leCoupEstValide(Col, Lig, GrilleDep),
	coupJoueDansGrille(Col, Lig, Valeur, GrilleDep, GrilleArr),
	nl, afficheGrille(GrilleArr), nl.
/*
Joue le coup de Valeur à la Case depuis la GrilleDep pour mettre le résultat dans GrilleArr
*/


saisieUnCoup(NomCol,NumLig) :-
	nl, writef("entrez le nom de la colonne a jouer (a,b,c) :"),
	read(NomCol), nl,
	writef("entrez le numero de ligne a jouer (1, 2 ou 3) :"),
	read(NumLig),nl.

%saisieUnCoupValide(Col,Lig,Grille):-
%	saisieUnCoup(Col,Lig),
%	leCoupEstValide(Col,Lig,Grille),
%	writef('attention, vous ne pouvez pas jouer dans cette case'), nl,
%	writef('reessayer SVP dans une autre case'),nl,
%	saisieUnCoupValide(Col,Lig,Grille).


% Predicat : moteur/3
% Usage : moteur(Grille,ListeCoups,Camp) prend en parametre une grille dans
% laquelle tous les coups sont jouables et pour laquelle
% Camp doit jouer.


% cas gagnant pour le joueur
moteur(Grille,_,Camp):-
	partieGagnee(Camp, Grille), nl,
	write('le camp '), write(Camp), write(' a gagne').

% cas gagnant pour le joueur adverse
moteur(Grille,_,Camp):-
	campAdverse(CampGagnant, Camp),
	partieGagnee(CampGagnant, Grille), nl,
	write('le camp '), write(CampGagnant), write(' a gagne').

% cas de match nul, plus de coups jouables possibles
moteur(_,[],_) :-nl, write('game over').

% cas ou l'ordinateur doit jouer
moteur(Grille, [Premier|ListeCoupsNew], Camp) :-
	campCPU(Camp),
	joueLeCoup(Premier, Camp, Grille, GrilleArr),
	campAdverse(AutreCamp, Camp),
	moteur(GrilleArr, ListeCoupsNew, AutreCamp).

% cas ou c'est l'utilisateur qui joue
moteur(Grille, ListeCoups, Camp) :-
	campCPU(CPU),
	campAdverse(Camp, CPU),
	saisieUnCoup(Col,Lig),
	joueLeCoup([Col,Lig], Camp, Grille, GrilleArr),
	toutesLesCasesValides(Grille, ListeCoups, [Col, Lig], ListeCoupsNew),
	moteur(GrilleArr, ListeCoupsNew, CPU).


% Predicat : lanceJeu/0
% Usage :  lanceJeu permet de lancer une partie.

lanceJeu:-
   grilleDeDepart(G),
	toutesLesCasesDepart(ListeCoups),
	afficheGrille(G),nl,
   write('L\'ordinateur est les x et vous �tes les o.'),nl,
   write('Quel camp doit debuter la partie ? '),read(Camp),nl,
	toutesLesCasesDepart(ListeCoups),
	moteur(G,ListeCoups,Camp).

testQ19(LC2) :- toutesLesCasesValides([[-,-,x],[-,o,-],[x,o,o]], [-,-,x], [a,1], LC2).

/*

-3-

-4-
Si l'on veut un jeu de 4x4 on doit modifier:
  * afficheLigne et afficheGrille et donc rajouter un champ  chaque fois
  * succNum et succAlpha afin de rajouter un indice sur chaque
*/
