%DI CARLO BENJAMIN
%PROUTEAU THIBAULT
%fichier principal jeu.pl lancer le prédicat lanceMenu

% Predicat : afficheCaseDeGrille(Colonne,Ligne,Grille) .
afficheCaseDeGrille(C,L,G) :- caseDeGrille(C,L,G,Case),write(Case).


% Predicat : leCoupEstValide/3
leCoupEstValide(C,L,G) :- caseDeGrille(C,L,G,-).


% Predicat : coupJoueDansLigne/4
% version bof
coupJoueDansLigneBof(a, Val, [-, X, Y], [Val, X, Y]).
coupJoueDansLigneBof(b, Val, [X, -, Y], [X, Val, Y]).
coupJoueDansLigneBof(c, Val, [X, Y, -], [X, Y, Val]).

% version recursive
coupJoueDansLigne(a, Val, [-|Reste],[Val|Reste]).
coupJoueDansLigne(NomCol, Val, [X|Reste1],[X|Reste2]):-
		succAlpha(I,NomCol),
		coupJoueDansLigne(I, Val, Reste1, Reste2).


% Predicat : coupJoueDansGrille/5
coupJoueDansGrille(NCol,1,Val,[A|Reste],[B|Reste]):- coupJoueDansLigne(NCol, Val, A, B).
coupJoueDansGrille(NCol, NLig, Val, [X|Reste1], [X|Reste2]):- succNum(I, NLig),
					coupJoueDansGrille(NCol, I, Val, Reste1, Reste2).

%  ?- coupJoueDansGrille(a,2,x,[[-,-,x],[-,o,-],[x,o,o]],V).
%  V = [[-,-,x],[x,o,-],[x,o,o]] ;
%  no



% Predicat : ligneFaite/2
%
% version bof
% ligneFaiteBof(x,[x,x,x]).
% ligneFaiteBof(o,[o,o,o]).
% ligneFaiteBof(-,[-,-,-]).
ligneFaite(Val, [Val]).
ligneFaite(Val, [Val|R]) :- ligneFaite(Val, R).


% Predicat : ligneExiste/3
% ?- ligneExiste(x,[[x,-,x],[x,x,x],[-,o,-]],V).
% V = 2 ;

ligneExiste(Val, [L1|_], 1) :- ligneFaite(Val, L1).
ligneExiste(Val, [_|R], NumLigne) :- succNum(I,NumLigne), ligneExiste(Val, R, I).


% Predicat : colonneExiste/3
colonneExiste(Val, [[Val|_],[Val|_],[Val|_]], a).
colonneExiste(Val, [[_|R1],[_|R2],[_|R3]], NomCol) :-
	succAlpha(I,NomCol),
	colonneExiste(Val, [R1,R2,R3], I).


% Predicats diagonaleDG/2 et diagonaleGD/2
diagonaleGD(Val, [[Val,_,_],[_,Val,_],[_,_,Val]]).
diagonaleDG(Val, [[_,_,Val],[_,Val,_],[Val,_,_]]).


% Predicat partieGagnee/2
partieGagnee(Val, G) :- ligneExiste(Val, G, _).
partieGagnee(Val, G) :- colonneExiste(Val, G, _).
partieGagnee(Val, G) :- diagonaleGD(Val, G).
partieGagnee(Val, G) :- diagonaleDG(Val, G).


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

campJoueur2(x).

campCPU(x).

campAdverse(x,o).
campAdverse(o,x).

joueLeCoup(Case, Valeur, GrilleDep, GrilleArr) :-
	coordonneesOuListe(Col, Lig, Case),
	leCoupEstValide(Col, Lig, GrilleDep),
	coupJoueDansGrille(Col, Lig, Valeur, GrilleDep, GrilleArr),
	nl, afficheGrille(GrilleArr), nl.

saisieUnCoup(NomCol,NumLig) :-
	writeln("entrez le nom de la colonne a jouer (a,b,c) :"),
	read(NomCol), nl,
	writeln("entrez le numero de ligne a jouer (1, 2 ou 3) :"),
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
moteurHH(Grille,_,Camp):-
	partieGagnee(Camp, Grille), nl,
	write('le camp '), write(Camp), write(' a gagne').

% cas gagnant pour le joueur adverse
moteurHH(Grille,_,Camp):-
	campAdverse(CampGagnant, Camp),
	partieGagnee(CampGagnant, Grille), nl,
	write('le camp '), write(CampGagnant), write(' a gagne').

% cas de match nul, plus de coups jouables possibles
moteurHH(_,[],_) :-nl, write('game over').

% cas ou joueur1 doit jouer
moteurHH(Grille, ListeCoups, Camp) :-
  campAdverse(AutreCamp, Camp),
  campJoueur2(AutreCamp),
  saisieUnCoup(Col,Lig),
	joueLeCoup([Col,Lig], Camp, Grille, GrilleArr),
  toutesLesCasesValides(Grille, ListeCoups, [Col, Lig], ListeCoupsNew),
	moteurHH(GrilleArr, ListeCoupsNew, AutreCamp).

% cas ou joueur2 doit jouer
moteurHH(Grille, ListeCoups, Camp) :-
  campJoueur2(Camp),
	saisieUnCoup(Col,Lig),
	joueLeCoup([Col,Lig], Camp, Grille, GrilleArr),
	toutesLesCasesValides(Grille, ListeCoups, [Col, Lig], ListeCoupsNew),
  campAdverse(AutreCamp, Camp),
	moteurHH(GrilleArr, ListeCoupsNew, AutreCamp).

% cas gagnant pour le joueur
moteurHM(Grille,_,Camp):-
	partieGagnee(Camp, Grille), nl,
	write('le camp '), write(Camp), write(' a gagne').

moteurHM(_,[],_) :-nl, write('game over').

% cas gagnant pour le joueur adverse
moteurHM(Grille,_,Camp):-
	campAdverse(CampGagnant, Camp),
	partieGagnee(CampGagnant, Grille), nl,
	write('le camp '), write(CampGagnant), write(' a gagne').

% cas ou l ordinateur doit jouer
moteurHM(Grille, [Premier|ListeCoupsNew], Camp) :-
	campCPU(Camp),
	joueLeCoup(Premier, Camp, Grille, GrilleArr),
	campAdverse(AutreCamp, Camp),
	moteurHM(GrilleArr, ListeCoupsNew, AutreCamp).

% cas ou c est l utilisateur qui joue
moteurHM(Grille, ListeCoups, Camp) :-
	campCPU(CPU),
	campAdverse(Camp, CPU),
	saisieUnCoup(Col,Lig),
	joueLeCoup([Col,Lig], Camp, Grille, GrilleArr),
	toutesLesCasesValides(Grille, ListeCoups, [Col, Lig], ListeCoupsNew),
	moteurHM(GrilleArr, ListeCoupsNew, CPU).
