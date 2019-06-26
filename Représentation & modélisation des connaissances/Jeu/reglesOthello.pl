%DI CARLO BENJAMIN
%PROUTEAU THIBAULT
%fichier principal jeu.pl lancer le prédicat lanceMenu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Le jeu d othello
%   -> regles.pl : module de modelisation des regles du jeu.
%
% Dependances :
%   -> othello.pl : module principal qui charge tous les modules necessaires au deroulement du jeu.
%   -> representation.pl : module de représentation du jeu (affichage, manipulation de la grille, etc).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% gestion des directions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% indiquer la direction selon la position par rapport à la case en cours C :
%  1  2  3
%  8  C  4
%  7  6  5
% ce qui donne en se servant de succnum et succ alpha :
% Predicat : caseSuivante/3
% Usage : caseSuivante(Direction,Case,CaseSuivante)

caseSuivante(1,[Colonne,Ligne],[ColonneSuiv,LigneSuiv]):-
	succAlpha(ColonneSuiv,Colonne),
	succNum(LigneSuiv,Ligne),!.

caseSuivante(2,[Colonne,Ligne],[Colonne,LigneSuiv]):-
	succNum(LigneSuiv,Ligne),!.

caseSuivante(3,[Colonne,Ligne],[ColonneSuiv,LigneSuiv]):-
	succAlpha(Colonne,ColonneSuiv),
	succNum(LigneSuiv,Ligne),!.

caseSuivante(4,[Colonne,Ligne],[ColonneSuiv,Ligne]):-
	succAlpha(Colonne,ColonneSuiv),!.

caseSuivante(5,[Colonne,Ligne],[ColonneSuiv,LigneSuiv]):-
	succAlpha(Colonne,ColonneSuiv),
	succNum(Ligne,LigneSuiv),!.

caseSuivante(6,[Colonne,Ligne],[Colonne,LigneSuiv]):-
	succNum(Ligne,LigneSuiv),!.

caseSuivante(7,[Colonne,Ligne],[ColonneSuiv,LigneSuiv]):-
	succAlpha(ColonneSuiv,Colonne),
	succNum(Ligne,LigneSuiv),!.

caseSuivante(8,[Colonne,Ligne],[ColonneSuiv,Ligne]):-
	succAlpha(ColonneSuiv,Colonne),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicat : leCoupEstValide/3
% Usage : leCoupEstValide(Camp,Grille,Coup) verifie qu il n y a rien dans
%         la case et que le pion va entoure des pions adverses
% ce qui est equivalent a leCoupEstValide/4 en decomposant le coup en ligne/colonne
leCoupEstValide(Camp,Grille,[Colonne,Ligne]):-
	caseDeGrille(Colonne,Ligne,Grille,-),
	lePionEncadre(_Direction,Camp,Grille,[Colonne,Ligne]),!.


% Predicat : lePionEncadre/4
% Usage : lePionEncadre(Direction,Camp,Grille,Case) verifie qu il existe
%	  un pion adverse dans une des directions autour du pion
%     utilise la question 8 pour les direction

lePionEncadre(Direction,Camp,Grille,Case):-
    % on verifie la valeur de la direction
	member(Direction,[1,2,3,4,5,6,7,8]),
	% on parcourt la case suivante dans une direction donnee
	caseSuivante(Direction,Case,[ColonneSuiv,LigneSuiv]),
	% on cherche si il y a un adversaire dans cette position
	campAdverse(Camp,CampAdv),
	caseDeGrille(ColonneSuiv,LigneSuiv,Grille,CampAdv),
	% on regarde si il y a bien un pion a 'nous' dans la case suivante
	caseSuivante(Direction,[ColonneSuiv,LigneSuiv],Case3),
	trouvePion(Direction,Camp,Grille,Case3),!.


% Predicat : trouvePion/4
% Usage : trouvePion(Direction,Camp,Grille,Case) verifie que le pion adverse
%            est bien entoure de l autre cote par un pion du Camp

trouvePion(_Direction,Camp,Grille,[Colonne,Ligne]):-
	caseDeGrille(Colonne,Ligne,Grille,Camp),!.

trouvePion(Direction,Camp,Grille,[Colonne,Ligne]):-
	campAdverse(Camp,CampAdv),
	caseDeGrille(Colonne,Ligne,Grille,CampAdv),
	caseSuivante(Direction,[Colonne,Ligne],CaseSuiv),
	trouvePion(Direction,Camp,Grille,CaseSuiv).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  --> placer le pion ou on veut jouer
%%%  --> retourner les autres pions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicat : placePionDansLigne/4
% Usage : placePionDansLigne(NomCol,Val,LigneDep,LigneArr) est satisfait si LigneArr
%         peut etre obtenue a partir de LigneDep en jouant le coup valide qui consiste
%         a mettre la valeur Val en NomCol, NumLig.
%	  On suppose donc que le coup que l on desire jouer est valide.

placePionDansLigne(a,Val,[_|SuiteLigneDep],[Val|SuiteLigneDep]):-!.

placePionDansLigne(NomCol,Val,[Tete|SuiteLigneDep],[Tete|SuiteLigneArr]):-
	succAlpha(Predecesseur,NomCol),
	placePionDansLigne(Predecesseur,Val,SuiteLigneDep,SuiteLigneArr).


% Predicat : placePionDansGrille/5
% Usage : placePionDansGrille(NomCol,NumLig,Val,GrilleDep,GrilleArr) est satisfait
%         si GrilleArr est obtenue a partir de GrilleDep dans laquelle on a joue
%         Val en NomCol, NumLig, et cela etant d autre part un coup valide.

placePionDansGrille(NomCol,1,Val,[Ligne1|SuiteGrille],[Ligne2|SuiteGrille]):-
	placePionDansLigne(NomCol,Val,Ligne1,Ligne2),!.

placePionDansGrille(NomCol,NumLig,Val,[Ligne1|SuiteGrilleDep],[Ligne1|SuiteGrilleArr]):-
	succNum(Predecesseur,NumLig),
	placePionDansGrille(NomCol,Predecesseur,Val,SuiteGrilleDep,SuiteGrilleArr).



% Predicat : mangePion/5
% Usage : mangePion(Direction,Camp,Grille,GrilleArr,Case) retourne les pions entoures

mangePion(Direction,_Camp,Grille,Grille,Case):-
	not(caseSuivante(Direction,Case,_CaseSuiv)),!.

mangePion(Direction,Camp,Grille,Grille,Case):-
	caseSuivante(Direction,Case,CaseSuiv),
	not(trouvePion(Direction,Camp,Grille,CaseSuiv)),!.

mangePion(Direction,Camp,Grille,Grille,Case):-
	caseSuivante(Direction,Case,[Colonne,Ligne]),
	caseDeGrille(Colonne,Ligne,Grille,Camp),!.

mangePion(Direction,Camp,Grille,GrilleArr,Case):-
	caseSuivante(Direction,Case,[Colonne,Ligne]),
	trouvePion(Direction,Camp,Grille,[Colonne,Ligne]),
	campAdverse(Camp,CampAdv),
	caseDeGrille(Colonne,Ligne,Grille,CampAdv),
	placePionDansGrille(Colonne,Ligne,Camp,Grille,GrilleProv),
	mangePion(Direction,Camp,GrilleProv,GrilleArr,[Colonne,Ligne]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  --> placer le pion ou on veut jouer
%%%  --> retourner les autres pions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Predicat : joueLeCoupDansGrille/4
% Usage : joueLeCoupDansGrille(Camp,Coups,Grille,GrilleArr) place le pion
%         Camp dans la Grille, retourne les pions entoures puis rend
%         la Grille d arrivee GrilleArr

joueLeCoupDansGrille(Camp,[Colonne,Ligne],Grille,GrilleArr):-
        leCoupEstValide(Camp,Grille,[Colonne,Ligne]),
	placePionDansGrille(Colonne,Ligne,Camp,Grille,_Grille0),
	mangePion(1,Camp,_Grille0,_Grille1,[Colonne,Ligne]),
	mangePion(2,Camp,_Grille1,_Grille2,[Colonne,Ligne]),
	mangePion(3,Camp,_Grille2,_Grille3,[Colonne,Ligne]),
	mangePion(4,Camp,_Grille3,_Grille4,[Colonne,Ligne]),
	mangePion(5,Camp,_Grille4,_Grille5,[Colonne,Ligne]),
	mangePion(6,Camp,_Grille5,_Grille6,[Colonne,Ligne]),
	mangePion(7,Camp,_Grille6,_Grille7,[Colonne,Ligne]),
	mangePion(8,Camp,_Grille7,GrilleArr,[Colonne,Ligne]),!.

lanceMoteurHH(Grille,ListeCoups,o):-
	% le joueur1 commence, on lui associe les pions 'x'
	% et on ajoute l information a la base de fait
	retractall(campJoueur1(_X)),
	asserta(campJoueur1(x)),
	campJoueur1(CampJ1),campJoueur2(CampJ2),
	% calcul du score actuel
	score(Grille,CampJ1,ScoreJ1),
	score(Grille,CampJ2,ScoreJ2),
	% on recupere le nom de chaque joueur pour afficher son score
	nomJoueur1(J1),nomJoueur2(J2),
	write(J1),write(' a '),write(ScoreJ1),writeln(' point(s)'),
	write(J2),write(' a '),write(ScoreJ2),writeln(' point(s)'),
	% lance le moteur de jeu pour 'x'
	moteurH1H2(Grille,ListeCoups,CampJ1),!.


/* Lance le moteur du joueur 2 */

lanceMoteurHH(Grille,ListeCoups,n):-
	% le joueur2 commence, on lui associe les pions 'x'
	% et on associe les 'o' au joueur 1
	retractall(campJoueur1(_X)),
	asserta(campJoueur1(o)),
	campJoueur1(CampJ1),campJoueur2(CampJ2),
	score(Grille,CampJ1,ScoreJ1),
	score(Grille,CampJ2,ScoreJ2),
	nomJoueur1(J1),nomJoueur2(J2),
	write(J1),write(' a '),write(ScoreJ1),writeln(' point(s)'),
	write(J2),write(' a '),write(ScoreJ2),writeln(' point(s)'),
	moteurH2H1(Grille,ListeCoups,CampJ2),!.

lanceMoteurHM(Grille,ListeCoups,o):-
	% le joueur1 commence, on lui associe les pions 'x'
	% et on ajoute l information a la base de fait
	retractall(campJoueur1(_X)),
	asserta(campJoueur1(x)),
	campJoueur1(CampJ1),campJoueur2(CampJ2),
	% calcul du score actuel
	score(Grille,CampJ1,ScoreJ1),
	score(Grille,CampJ2,ScoreJ2),
	% on recupere le nom de chaque joueur pour afficher son score
	nomJoueur1(J1),nomJoueur2(J2),
	write(J1),write(' a '),write(ScoreJ1),writeln(' point(s)'),
	write(J2),write(' a '),write(ScoreJ2),writeln(' point(s)'),
	% lance le moteur de jeu pour 'x'
	moteurH1H2(Grille,ListeCoups,CampJ1),!.

lanceMoteurHM(Grille,ListeCoups,n):-
	% l'ordinateur commence
	retractall(campJoueur1(_X)),
	asserta(campJoueur1(x)),
	campJoueur1(CampJ1),campJoueur2(CampJ2),
	% calcul du score actuel
	score(Grille,CampJ1,ScoreJ1),
	score(Grille,CampJ2,ScoreJ2),
	nomJoueur1(J1),nomJoueur2(J2),
	write(J1),write(' a '),write(ScoreJ1),writeln(' point(s)'),
	write(J2),write(' a '),write(ScoreJ2),writeln(' point(s)'),
	moteurH1H2(Grille,ListeCoups,CampJ2),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Moteur du joueur 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Predicat: moteurH1H2/3
% Usage : moteurH1H2(Grille,ListeCoups,CampJ1) est le moteur de jeu du joueur 1
%

% cas : partie finie
moteurH1H2(Grille,[],CampJ1):-
	campJoueur1(CampJ1),
	moteurHHFin(Grille),!.

% cas : il n y a plus de coups disponibles pour aucun des joueurs - partie finie
moteurH1H2(Grille,ListeCoups,CampJ1):-
	ListeCoups \== [],
	campJoueur1(CampJ1),
	campJoueur2(CampJ2),
	not(testerCoup(ListeCoups,CampJ1,Grille)),
	not(testerCoup(ListeCoups,CampJ2,Grille)),
	moteurHHFin(Grille),!.

% cas : le joueur en cours n a plus de coups disponibles
moteurH1H2(Grille,ListeCoups,CampJ1):-
	nomJoueur1(J1),campJoueur1(CampJ1),campJoueur2(CampJ2),
	not(testerCoup(ListeCoups,CampJ1,Grille)),
	write('Vous devez passer votre tour '),write(J1),write(' ( '),write(CampJ1),writeln(' )'),
	moteurH2H1(Grille,ListeCoups,CampJ2).


% cas : cas general  - le joueur 1 doit jouer
moteurH1H2(Grille,ListeCoups,CampJ1):-
		% gerer l alternance des coups
	campJoueur1(CampJ1),campJoueur2(CampJ2),nomJoueur1(J1),nomJoueur2(J2),
	% verifier qu il y a bien des coups a jouer
	testerCoup(ListeCoups,CampJ1,Grille),
	% demander la saisie du coup
	write('A vous de jouer '),write(J1),write(' ( '),write(CampJ1),writeln(' )'),
	saisieUnCoup(NomCol,NumLig),
	% jouer le coup dans la grille et mettre a jour la grille
	joueLeCoupDansGrille(CampJ1,[NomCol,NumLig],Grille,GrilleArr),
	% afficher la nouvelle grille
	afficheGrille(GrilleArr),
	% afficher le score de chacun des joueurs
	score(GrilleArr,CampJ1,ScoreJ1),
	score(GrilleArr,CampJ2,ScoreJ2),
	write(J1),write(' a '),write(ScoreJ1),writeln(' point(s)'),
	write(J2),write(' a '),write(ScoreJ2),writeln(' point(s)'),
	write(J1),write(' a joue en ('),write(NomCol),write(','),write(NumLig),writeln(')'),
	% mettre a jour la liste des coups
	duneListeALautre(ListeCoups,[NomCol,NumLig],NouvelleListeCoups),
	% lancer le moteur pour l autre joueur
	moteurH2H1(GrilleArr,NouvelleListeCoups,CampJ2).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Moteur du joueur 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Predicat: moteurH2H1/3
% Usage : moteurH2H1(Grille,ListeCoups,CampJ2) est le moteur de jeu du joueur 2
% Comme si dessus pour le second joueur

moteurH2H1(Grille,[],CampJ2):-
	campJoueur2(CampJ2),
	moteurHHFin(Grille),!.

moteurH2H1(Grille,ListeCoups,CampJ2):-
	ListeCoups \== [],
	campJoueur1(CampJ2),
	campJoueur2(CampJ1),
	not(testerCoup(ListeCoups,CampJ2,Grille)),
	not(testerCoup(ListeCoups,CampJ1,Grille)),
	moteurHHFin(Grille),!.

moteurH2H1(Grille,ListeCoups,CampJ2):-
	nomJoueur2(J2),campJoueur1(CampJ1),campJoueur2(CampJ2),
	not(testerCoup(ListeCoups,CampJ2,Grille)),
	write('Vous devez passer votre tour '),write(J2),write(' ( '),write(CampJ2),writeln(' )'),
	moteurH1H2(Grille,ListeCoups,CampJ1).

moteurH2H1(Grille,ListeCoups,CampJ2):-
	campJoueur1(CampJ1),campJoueur2(CampJ2),nomJoueur1(J1),nomJoueur2(J2),
	testerCoup(ListeCoups,CampJ2,Grille),
	write('A vous de jouer '),write(J2),write(' ( '),write(CampJ2),writeln(' )'),
	saisieUnCoup(NomCol,NumLig),
	joueLeCoupDansGrille(CampJ2,[NomCol,NumLig],Grille,GrilleArr),
	afficheGrille(GrilleArr),
	score(GrilleArr,CampJ1,ScoreJ1),
	score(GrilleArr,CampJ2,ScoreJ2),
	write(J1),write(' a '),write(ScoreJ1),writeln(' point(s)'),
	write(J2),write(' a '),write(ScoreJ2),writeln(' point(s)'),
	write(J2),write(' a joue en ('),write(NomCol),write(','),write(NumLig),writeln(')'),
	duneListeALautre(ListeCoups,[NomCol,NumLig],NouvelleListeCoups),
	moteurH1H2(GrilleArr,NouvelleListeCoups,CampJ1),!.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Gestion des fins de parties
%%% Quand il n y a plus de cases libres ou jouables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Predicat : moteurHHFin/1
% Usage : moteurHHFin(Grille)

%% la partie est terminee et c est le joueur 1 qui gagne
moteurHHFin(Grille):-
		campJoueur1(CampJ1),campJoueur2(CampJ2),nomJoueur1(J1),nomJoueurJ2(J2),
	score(Grille,CampJ1,ScoreJ1),
	score(Grille,CampJ2,ScoreJ2),
	ScoreJ1 > ScoreJ2,
	writeln('La partie est terminee'),
	writeln('Bravo ' + J1 +' vous avez gagne cette partie !!!'),
	writeln('Voulez-vous une revanche, '),write(J2),writeln(' ? (o. pour OUI ou n. pour NON) : '),
	verifSaisie(Revanche),
	lanceRevancheHH(Revanche),!.


%% la partie est terminee et c est le joueur 2 qui gagne
moteurHHFin(Grille):-
	campJoueur1(CampJ1),campJoueur2(CampJ2),nomJoueur1(J1),nomJoueur2(J2),
	score(Grille,CampJ1,ScoreJ1),
	score(Grille,CampJ2,ScoreJ2),
	ScoreJ1 < ScoreJ2,
	writeln('La partie est terminee'),
	writeln('Bravo ' + J2 + 'vous avez gagne cette partie !!!'),
	write('Voulez-vous une revanche, '),write(J1),writeln(' ? (o. pour OUI ou n. pour NON) : '),
	verifSaisie(Revanche),
	lanceRevancheHH(Revanche),!.

%% la partie est terminee et il n y a pas de gagnant
moteurHHFin(Grille):-
	campJoueur1(CampJ1),campJoueur2(CampJ2),
	score(Grille,CampJ1,ScoreJ1),
	score(Grille,CampJ2,ScoreJ2),
	ScoreJ1 = ScoreJ2,
	writeln('La partie est terminee'),
	writeln('Vous etes aussi fort l un que l autre'),
	writeln('Voulez-vous faire une nouvelle partie ? (o. pour OUI ou n. pour NON) : '),
	verifSaisie(Revanche),
	lanceRevancheHH(Revanche),!.


% choix de la fin de partie
% Predicat : lanceRevancheHH/1
% Usage : lanceRevancheHH(Choix)

lanceRevancheHH(o):-
	afficheGrilleDep,
	grilleDeDepart(Grille),
	toutesLesCasesDepart(ListeCoups),
	nomJoueur1(J1),
	writeln(J1 +'voulez-vous commencer ? o. pour OUI ou n. pour NON : '),
	read(Commence),
	lanceMoteurHH(Commence,Grille,ListeCoups),!.

lanceRevancheHH(n):-
	tab(10),writeln('Ca sera peut-etre pour une prochaine fois !'),!.
