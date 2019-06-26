%DI CARLO BENJAMIN
%PROUTEAU THIBAULT
%fichier principal jeu.pl lancer le prédicat lanceMenu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%On load que les prédicats nécessaires au lancement
lanceMenu:-
	menuPrincipal,
	consult(jeu),!.

%%Menu du choix du jeu
menuPrincipal:-
	tab(8),writeln('Menu Principal, Choisissez un Jeu'),
	tab(8),writeln('--------------'),
	tab(6),writeln('1 - Othello Homme VS Homme'),
	tab(6),writeln('2 - Othello Homme VS Machine'),
	tab(6),writeln('3 - Tic Tac Toe Homme VS Homme'),
	tab(6),writeln('4 - Tic Tac Toe Homme VS Machine'),
	tab(6),writeln('0 - Quitter'),
	saisieChoix(Choix),
	consult(general),
	lanceChoix(Choix),!.

%%Ajout des regles de l'othello
lanceChoix(1):-
	consult(reglesOthello),consult(representationOthello),
	% recupere le nom des joueurs et l ajoute dans la BF
	saisieNomJoueur1,
	saisieNomJoueur2,
	% affiche la grille de depart
	afficheGrilleDep,
	grilleDeDepart(Grille),
	% initialise tous les coups disponibles au depart
	toutesLesCasesDepart(ListeCoups),
	nomJoueur1(J1),
	writeln(J1 +' voulez-vous commencer ? o. pour OUI ou n. pour NON : '),
	read(Commence),
	% lance le moteur humain contre humain
	lanceMoteurHH(Grille,ListeCoups, Commence),!.

%%Pas encore disponible
lanceChoix(2):-
	writeln('Bientot dans la nouvelle mise à jour! Revenez vite!'),!.


%Load les predicats pour le tictactoe HH
lanceChoix(3):-
	consult(reglesTicTacToe),consult(representationTicTacToe),
	grilleDeDepart(G),
	toutesLesCasesDepart(ListeCoups),
	afficheGrille(G),nl,
	writeln("Joueur 2 est les x et vous etes les o."),
	writeln("Quel camp doit debuter la partie ? "),read(Camp),
	toutesLesCasesDepart(ListeCoups),
	moteurHH(G,ListeCoups,Camp),!.

%%Load les predicats pour le tictactoe HO
lanceChoix(4):-
	consult(reglesTicTacToe),consult(representationTicTacToe),
	grilleDeDepart(G),
	toutesLesCasesDepart(ListeCoups),
	afficheGrille(G),nl,
	writeln("Ordinateur est les x et vous etes les o."),
	writeln("Quel camp doit debuter la partie ? "),read(Camp),
	toutesLesCasesDepart(ListeCoups),
	moteurHM(G,ListeCoups,Camp),!.

%%%Quitte le Jeu
lanceChoix(0):-
	tab(10),writeln('A tres bientot...'),!.

saisieChoix(Choix):-
	writeln('Choisissez une option (sans oublier le point) : '),
	read(Choix).

saisieNomJoueur1:-
	writeln('Entrez le nom du Joueur 1 (sans oublier le point) : '),
	read(J1),
	% Supprime le nom du joueur 1 s il y en avait deja un dans la base de fait :
	%  - retract(P) : recherche une clause dans la base de connaissances qui s unifie avec P
	%        et l efface
	%  - retractall(P) : enleve toutes les clauses qui s unifient a P.
	retractall(nomJoueur1(_X)),
	% Rajoute le nouveau nom du joueur dans la base de fait :
	%  - assert(P) : permet d ajouter P a la base de faits, peut etre ecrit n importe ou
	%  - asserta(P) : ajoute en debut de base
	%  - assertz(P) : ajoute en fin de base
	asserta(nomJoueur1(J1)),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicat : saisieNomJoueur2
% Usage : saisieNomJoueur2 enregistre le nom du joueur 2
saisieNomJoueur2:-
	writeln('Entrez le nom du Joueur 2 (sans oublier le point) : '),
	read(J2),
	retractall(nomJoueur2(_X)),
	asserta(nomJoueur2(J2)),!.

saisieOrdi:-
	retractall(nomJoueur2(_X)),
	asserta(nomJoueur2("Ordinateur")),!.
