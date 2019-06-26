%%DI CARLO BENJAMIN
%%PROUTEAU THIBAULT
%%general.pl généralisation d'une partie des prédicats
%fichier principal jeu.pl lancer le prédicat lanceMenu

testerCoup([[Colonne,Ligne]|Suite],Camp,Grille):- %%Tester le coup generique
	leCoupEstValide(Camp,Grille,[Colonne,Ligne]);
	testerCoup(Suite,Camp,Grille).

% Predicat : caseDeGrille(NumCol, NumLigne, Grille, Case).
% Satisfait si Case est la case de la Grille en position NumCol-NumLigne
caseDeGrille(NumColonne,NumLigne,Grille,Case):-
	ligneDeGrille(NumLigne,Grille,Ligne),
	caseDeLigne(NumColonne,Ligne,Case),!.

% Predicat : caseDeLigne(Col, Liste, Valeur).
% Satisfait si Valeur est dans la colonne Col de la Liste
caseDeLigne(a, [A|_],A).
caseDeLigne(Col, [_|Reste],Test) :-
  succAlpha(I, Col),
  caseDeLigne(I,Reste, Test).

% Predicat : ligneDeGrille(NumLigne, Grille, Ligne).
% Satisfait si Ligne est la ligne numero NumLigne dans la Grille
ligneDeGrille(1, [Test |_], Test).
ligneDeGrille(NumLigne, [_|Reste],Test) :- succNum(I, NumLigne),
		ligneDeGrille(I,Reste,Test).
