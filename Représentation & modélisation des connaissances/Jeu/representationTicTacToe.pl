%DI CARLO BENJAMIN
%PROUTEAU THIBAULT
%fichier principal jeu.pl lancer le prédicat lanceMenu
toutesLesCasesDepart([[a,1],[a,2],[a,3],[b,1],[b,2],[b,3],[c,1],[c,2],[c,3]]).

grilleDeDepart([[-,-,-],[-,-,-],[-,-,-]]).

% Predicat : afficheLigne/1
afficheLigne([A,B,C]) :-
	write(A), tab(3),
	write(B), tab(3),
	write(C), tab(3).


% Predicat : afficheGrille/1
afficheGrille([[A1,B1,C1],[A2,B2,C2],[A3,B3,C3]]) :-
	afficheLigne([A1,B1,C1]), nl,
	afficheLigne([A2,B2,C2]), nl,
	afficheLigne([A3,B3,C3]).

% Predicat : succNum/2
succNum(1,2).
succNum(2,3).

% Predicat : succAlpha/2
succAlpha(a,b).
succAlpha(b,c).

% Predicat : campJoueur2/1
% Usage : campJoueur2(CampJ2) est satisfait si CampJ2 est le camp du joueur 2
% Le campJoueur1 est defini dynamiquement en debut de jeu et peut etre modifie en fonction
% du choix des joueurs.
% Permet d associer le nom d un joueur, avec son numero et sa couleur
campJoueur2(CampJ2):-
	campJoueur1(CampJ1),
	campAdverse(CampJ1,CampJ2),!.
