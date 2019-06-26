#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#define NB_EXPR 13
#define VRAI 1
#define FAUX 0
#define DEBOG 1

void attendre();
void tirage_aleatoire(int* a, int* b, int* c);
void expert(int a, int b, int c, int pion1, int pion2);
void maj_modele_apprenant(int choix, int pion_joueur);
void afficher_modele_apprenant();
void conseil(int choix);
int saisie_choix_joueur(int a,int b, int c);
void tour_joueur(int* pion_joueur,int* pion_west);
void tour_west(int* pion_joueur,int* pion_west);

/* Jeu WEST */

/* Caract�ristiques d'un d�placement possible */
typedef struct{
	int val_expr;		/* Valeur de l'expression */
	int nouv_posit;		/* Nouvelle position joueur */
	int nouv_posit_adv;	/* Nouvelle position adversaire */
	int ville;			/* Usage d'une ville */
	int raccourci;		/* Usage d'un raccourci */
	int collision;		/* Usage d'une collision */
} t_deplact;

/* Tableau des d�placements possibles */
t_deplact table[NB_EXPR];

/* Indice du meilleur d�placement */
int meilleur;

/* Maximums atteignables (plus grand nombre, plus grande
distance et plus grand delta) */
int max_nombre,max_distance,max_delta;

/* Modele de l'apprenant A COMPLETER */
typedef struct{
	int nb_tours_jouer;
	int nb_meilleurs;
	int nb_strat_nbMax;
	int nb_strat_distanceMax;
	int nb_strat_deltaMax;
	int conseil_donner_avant;

	// [expert utilise, user utilise pas quand expert l'utilise]
	int diffRaccourci[2];
	int diffVille[2];
	int diffCollision[2];

	char rejouer;
} t_modele;

t_modele modele_appr = {0, 0, 0, 0, 0, FAUX, {0,0}, {0,0}, {0,0}, 'n'};


/*--------------------------------------------------------*/

void attendre(){
/* Pause entre deux tours de jeu */
	char rc;
	printf("Tapez entree pour continuer ");
	scanf("%c",&rc);
}

void tirage_aleatoire(int* a, int* b, int* c){
/* Tire au hasard trois nombres:
	a compris entre 1 et 3
	b compris entre 0 et 4
	c compris entre 1 et 7
*/
	*a=rand()%3+1;
	*b=rand()%5;
	*c=rand()%7+1;
}

void expert(int a, int b, int c, int pion1, int pion2){
/* Calcule tous les d�placements possibles de pion1
	en fonction des trois chiffres tir�s au hasard */

	int i;
	int nouv_posit_pion2;

	table[1].val_expr = a*b+c;
	table[2].val_expr = a*c+b;
	table[3].val_expr = c*b+a;
	table[4].val_expr = (a+b)*c;
	table[5].val_expr = (a+c)*b;
	table[6].val_expr = (c+b)*a;
	table[7].val_expr = a*b-c;
	table[8].val_expr = a*c-b;
	table[9].val_expr = c*b-a;
	table[10].val_expr = a+b-c;
	table[11].val_expr = a+c-b;
	table[12].val_expr = c+b-a;

	for(i=1;i<NB_EXPR;i++){
		/* Le pion avance du nombre de cases donn� par
		l'expression form�e avec les trois chiffres,
		sans reculer au-del� de la case de d�part	*/
		if(pion1+table[i].val_expr > 0)
			table[i].nouv_posit=pion1+table[i].val_expr;
		else
			table[i].nouv_posit=0;

		/* Cas de d�passement de l'arriv�e : retour arri�re */
		if(table[i].nouv_posit>70)
			table[i].nouv_posit=140-table[i].nouv_posit;

		/* Cas des raccourcis en cases 5, 25 et 44*/
		if(table[i].nouv_posit==5){
			table[i].nouv_posit = 13;
			table[i].raccourci=VRAI;
		}
		else if(table[i].nouv_posit==25){
			table[i].nouv_posit = 36;
			table[i].raccourci=VRAI;
		}
		else if(table[i].nouv_posit==44){
			table[i].nouv_posit = 54;
			table[i].raccourci=VRAI;
		}
		else
			table[i].raccourci=FAUX;

		/* Cas des villes: on passe � la suivante*/
		if(table[i].nouv_posit%10==0 && table[i].val_expr!= 0 && table[i].nouv_posit!=70 && table[i].nouv_posit!=0){
			table[i].nouv_posit+=10;
			table[i].ville=VRAI;
		}
		else
			table[i].ville=FAUX;


		/* Cas de collision avec l'autre pion :
		   il est renvoy� deux villes en arri�re */
		if(table[i].nouv_posit==pion2 && !table[i].ville && table[i].val_expr!= 0){
			nouv_posit_pion2 = pion2-pion2%10-10;
			if(nouv_posit_pion2 < 0)
				nouv_posit_pion2 = 0;
			table[i].nouv_posit_adv = nouv_posit_pion2;
			table[i].collision=VRAI;
		}
		else{
			table[i].nouv_posit_adv = pion2;
			table[i].collision=FAUX;
		}
}

	/* Calcul du maximum possible
		- pour la valeur de l'expression (max_nombre)
		- pour la distance parcourue (max_distance)
		- pour la distance entre les deux pions (max_delta)
	*/
	max_nombre = table[1].val_expr;
	max_distance = table[1].nouv_posit - pion1;
	max_delta = table[1].nouv_posit - table[1].nouv_posit_adv;
	meilleur = 1;

	for(i=2;i<NB_EXPR;i++){
		if(table[i].val_expr > max_nombre)
			max_nombre = table[i].val_expr;
		if(table[i].nouv_posit-pion1> max_distance)
			max_distance = table[i].nouv_posit-pion1;
		if(table[i].nouv_posit - table[i].nouv_posit_adv> max_delta){
			max_delta = table[i].nouv_posit - table[i].nouv_posit_adv;
			if(table[meilleur].nouv_posit!=70)
				meilleur = i;
		}
		/* Un coup gagnant est toujours le meilleur */
		if(table[i].nouv_posit==70)
			meilleur = i;
	}
}

void maj_modele_apprenant(int choix, int pion_joueur){
/* Mise � jour du mod�le du joueur apr�s son tour de jeu */
	modele_appr.nb_tours_jouer += 1;
	if( table[choix].val_expr == max_delta )
		modele_appr.nb_strat_deltaMax += 1;
	if( table[choix].val_expr == max_distance )
		modele_appr.nb_strat_distanceMax += 1;
	if( table[choix].val_expr == max_nombre )
		modele_appr.nb_strat_nbMax += 1;

	// Calcul modèle différentiel pour chacun des concepts
	if( choix == meilleur )
		modele_appr.nb_meilleurs += 1;

	if( table[meilleur].ville ){
		modele_appr.diffVille[0] += 1;
		if( table[choix].ville )
			modele_appr.diffVille[1] += 1;
	}
	if( table[meilleur].raccourci ){
		modele_appr.diffRaccourci[0] += 1;
		if( table[choix].raccourci )
			modele_appr.diffRaccourci[1] += 1;
	}
	if( table[meilleur].collision ){
		modele_appr.diffCollision[0] += 1;
		if( table[choix].collision )
			modele_appr.diffCollision[1] += 1;
	}
}

void afficher_modele_apprenant(){
/* Affichage du mod�le du joueur en fin de partie*/
	printf("\n>> Voici un recapitulatif de ta game: ");
	printf("\n\tNombre de tours joues: %i", modele_appr.nb_tours_jouer);
	printf("\n\tNombre de choix parfaits: %i", modele_appr.nb_meilleurs);
	/*printf("\n\tNombre de strategies nombre max: %i", modele_appr.nb_strat_nbMax);
	printf("\n\tNombre de strategies distance max: %i", modele_appr.nb_strat_distanceMax);
	printf("\n\tNombre de strategies delta max: %i", modele_appr.nb_strat_deltaMax);*/
	printf("\n\tVilles empruntees expert/toi: %i/%i", modele_appr.diffVille[0], modele_appr.diffVille[1]);
	printf("\n\tRaccourcis empruntes expert/toi: %i/%i", modele_appr.diffRaccourci[0], modele_appr.diffRaccourci[1]);
	printf("\n\tCollisions effectuees expert/toi: %i/%i\n", modele_appr.diffCollision[0], modele_appr.diffCollision[1]);
}

void conseil(int choix){
/* Affiche un conseil si le joueur a fait un mauvais choix */

	// (6) Ne pas intervenir avant que le joueur est découvert le jeu -> Le joueur doit avoir déjà fait quelques tours de découverte
	if( modele_appr.nb_tours_jouer >= 0 ){

		// (7) Féliciter le joueur lorsqu'il joue bien
		if( choix == meilleur )
			printf(">> Super tu as fais le meilleur choix possible !\n");

		int rejouer = FAUX;
		// (4) Si le joueur peut gagner mais qu'il ne le fait pas on l'interrompt et on le fait rejouer
		if( table[meilleur].nouv_posit == 70 && table[choix].nouv_posit != 70 ){
			printf(">> Fais attention tu pourrai gagner ...\n");
			rejouer = VRAI;
		}
		else{

			// (1) Si le joueur a loupé un concept qu'il aurait du utiliser et qu'il ne l'utilise pas souvent on le conseil sur ce concept
			// (2) Donner un exemple meilleur que celui du joueur
			if( (table[meilleur].ville && !table[choix].ville && (modele_appr.diffVille[1]/modele_appr.diffVille[0])<0.25) || (table[meilleur].raccourci && !table[choix].raccourci && (modele_appr.diffRaccourci[1]/modele_appr.diffRaccourci[0])<0.25) || (table[meilleur].collision && !table[choix].collision && (modele_appr.diffCollision[1]/modele_appr.diffCollision[0])<0.25) ){
				// (5) Ne pas intervenir 2 fois de suite
				if( modele_appr.conseil_donner_avant == FAUX ){
					if( table[meilleur].ville )
						printf(">> Tu aurais pu utiliser le passage par la ville en utilisant le choix: %i tu serais aller sur la case: %i\n   Cela t'aurais permis d'aller jusqu'a la prochaine ville et d'y etre en securite.\n", meilleur, table[meilleur].nouv_posit);
					else if( table[meilleur].raccourci )
						printf(">> Tu aurais pu utiliser le passage par un raccourci en utlisant le choix: %i tu serais aller sur la case: %i\n   Cela t'aurais permis d'avancer d'un plus grand nombre de cases.\n", meilleur, table[meilleur].nouv_posit);
					else
						printf(">> Tu aurais pu utiliser la collision en utilisant le choix: %i tu serais aller sur la case: %i\n   Cela t'aurais permis d'envoyer ton adversaire à la ville précédente.\n", meilleur, table[meilleur].nouv_posit);

					rejouer = VRAI;
					modele_appr.conseil_donner_avant = VRAI;
				}
				else
					modele_appr.conseil_donner_avant = FAUX;
			}
		}

		// (3,8) Le joueur peut rejouer après un conseil
		if( rejouer ){
				printf(">> Veux-tu rejouer pour te corriger (o/n) ? ");
				scanf("%c%*c",&modele_appr.rejouer);
		}

	}
}

int saisie_choix_joueur_avec_total(int a,int b, int c){
/* Saisie de l'expression choisie par le joueur
	� partir des trois nombres tir�s au hasard */

	int choix;

	do
	{
		printf(" 1: %i*%i+%i (%i)  7: %i*%i-%i (%i)\n",a,b,c,a*b+c,a,b,c,a*b-c);
		printf(" 2: %i*%i+%i (%i)  8: %i*%i-%i (%i)\n",a,c,b,a*c+b,a,c,b,a*c-b);
		printf(" 3: %i*%i+%i (%i)  9: %i*%i-%i (%i)\n",c,b,a,c*b+a,c,b,a,c*b-a);
		printf(" 4: (%i+%i)*%i (%i)  10: %i+%i-%i (%i)\n",a,b,c,(a+b)*c,a,b,c,a+b-c);
		printf(" 5: (%i+%i)*%i (%i)  11: %i+%i-%i (%i)\n",a,c,b,(a+c)*b,a,c,b,a+c-b);
		printf(" 6: (%i+%i)*%i (%i)  12: %i+%i-%i (%i)\n",c,b,a,(c+b)*a,c,b,a,c+b-a);
		printf("Choisis une expression (entre 1 et 12): ");
		scanf("%i%*c",&choix);

	}while(choix<1 || choix>NB_EXPR-1);

	return choix;
}

int saisie_choix_joueur_sans_total(int a,int b, int c){
/* Saisie de l'expression choisie par le joueur
	� partir des trois nombres tir�s au hasard */

	int choix;

	do
	{
		printf(" 1: %i*%i+%i  7: %i*%i-%i\n",a,b,c,a,b,c);
		printf(" 2: %i*%i+%i  8: %i*%i-%i\n",a,c,b,a,c,b);
		printf(" 3: %i*%i+%i  9: %i*%i-%i\n",c,b,a,c,b,a);
		printf(" 4: (%i+%i)*%i  10: %i+%i-%i\n",a,b,c,a,b,c);
		printf(" 5: (%i+%i)*%i  11: %i+%i-%i\n",a,c,b,a,c,b);
		printf(" 6: (%i+%i)*%i  12: %i+%i-%i\n",c,b,a,c,b,a);
		printf("Choisis une expression (entre 1 et 12): ");
		scanf("%i%*c",&choix);

	}while(choix<1 || choix>NB_EXPR-1);

	return choix;
}

void tour_joueur(int* pion_joueur,int* pion_west){
/* Tour de jeu du joueur */

	int a,b,c;
	int choix;

	int pion_joueur_init = *pion_joueur;
	int pion_west_init = *pion_west;

	tirage_aleatoire(&a,&b,&c);
	printf("Nombres : %i %i %i\n",a,b,c);

	/* Saisie de l'expression choisie par le joueur */
	if (DEBOG)
		choix = saisie_choix_joueur_avec_total(a,b,c);
	else
		choix = saisie_choix_joueur_sans_total(a,b,c);

	/* Calcul de tous les d�placements possibles
	pour comparaison avec le choix du joueur */
	expert(a,b,c,*pion_joueur,*pion_west);

	/* Mise � jour du mod�le de l'apprenant */
	maj_modele_apprenant(choix,*pion_joueur);


	/* D�placement du pion du joueur*/
	printf("Ton expression vaut %i\n",table[choix ].val_expr);
	*pion_joueur += table[choix ].val_expr;
	if(*pion_joueur<0)
		*pion_joueur=0;
	if(*pion_joueur>70)
		*pion_joueur=140-*pion_joueur;
	printf("Ton pion avance en %i\n",*pion_joueur);

	if(table[choix].raccourci){
		printf("Tu tombes sur un raccourci\n");

		if(*pion_joueur==5)
			*pion_joueur = 13;
		else if(*pion_joueur==25)
			*pion_joueur = 36;
		else if(*pion_joueur==44)
			*pion_joueur = 54;

		printf("Ton pion avance en %i\n",*pion_joueur);
	}

	if(table[choix].ville){
		printf("Tu tombes sur une ville et tu passes a la suivante\n");
		*pion_joueur += 10;
		printf("Ton pion avance en %i\n",*pion_joueur);
	}

	if(table[choix].collision){
		printf("Ton pion arrive sur la meme case que moi\n");
		*pion_west = table[choix].nouv_posit_adv;
		printf("Mon pion recule en %i\n",*pion_west);
	}

	/* Donner un conseil au joueur s'il a mal jou� */
	conseil(choix);

	/* On rejoue si l'utilisateur l'a souhaité après un conseil */
	if( modele_appr.rejouer == 'o' ){
		modele_appr.rejouer = 'n';

		// Retour aux positions de bases
		*pion_joueur = pion_joueur_init;
		*pion_west = pion_west_init;

		printf("\nTu es en %i\n", *pion_joueur);
		/* Saisie de l'expression choisie par le joueur */
		if (DEBOG)
			choix = saisie_choix_joueur_avec_total(a,b,c);
		else
			choix = saisie_choix_joueur_sans_total(a,b,c);

		/* D�placement du pion du joueur*/
		printf("Ton expression vaut %i\n",table[choix ].val_expr);
		*pion_joueur += table[choix ].val_expr;
		if(*pion_joueur<0)
			*pion_joueur=0;
		if(*pion_joueur>70)
			*pion_joueur=140-*pion_joueur;
		printf("Ton pion avance en %i\n",*pion_joueur);

		if(table[choix].raccourci){
			printf("Tu tombes sur un raccourci\n");

			if(*pion_joueur==5)
				*pion_joueur = 13;
			else if(*pion_joueur==25)
				*pion_joueur = 36;
			else if(*pion_joueur==44)
				*pion_joueur = 54;

			printf("Ton pion avance en %i\n",*pion_joueur);
		}

		if(table[choix].ville){
			printf("Tu tombes sur une ville et tu passes a la suivante\n");
			*pion_joueur += 10;
			printf("Ton pion avance en %i\n",*pion_joueur);
		}

		if(table[choix].collision){
			printf("Ton pion arrive sur la meme case que moi\n");
			*pion_west = table[choix].nouv_posit_adv;
			printf("Mon pion recule en %i\n",*pion_west);
		}
	}

}

void tour_west(int* pion_joueur,int* pion_west){
/* Tour de jeu de l'ordinateur */

	int a,b,c;

	tirage_aleatoire(&a,&b,&c);
	printf("Nombres : %i %i %i\n",a,b,c);

	/* Calcul de tous les d�placements possibles
	ainsi que du meilleur (strat�gie "delta maximum") */
	expert(a,b,c,*pion_west,*pion_joueur);

	/* Deplacement du pion de West */

	printf("Je choisis l'expression : ");
	switch(meilleur)
	{
		case 1 : printf("%i*%i+%i\n",a,b,c); break;
		case 2 : printf("%i*%i+%i\n",a,c,b); break;
		case 3 : printf("%i*%i+%i\n",c,b,a); break;
		case 4 : printf("(%i+%i)*%i\n",a,b,c); break;
		case 5 : printf("(%i+%i)*%i\n",a,c,b); break;
		case 6 : printf("(%i+%i)*%i\n",c,b,a); break;
		case 7 : printf("%i*%i-%i\n",a,b,c); break;
		case 8 : printf("%i*%i-%i\n",a,c,b); break;
		case 9 : printf("%i*%i-%i\n",c,b,a); break;
		case 10 : printf("%i+%i-%i\n",a,b,c); break;
		case 11 : printf("%i+%i-%i\n",a,c,b); break;
		case 12 : printf("%i+%i-%i\n",c,b,a); break;
	}
	printf("Mon expression vaut %i\n",table[meilleur].val_expr);

	*pion_west += table[meilleur].val_expr;
	if(*pion_west>70)
		*pion_west=140-*pion_west;
	printf("Mon pion avance en %i\n",*pion_west);

	if(table[meilleur].raccourci){
		printf("Je tombe sur un raccourci\n");

		if(*pion_west==5)
			*pion_west = 13;
		else if(*pion_west==25)
			*pion_west = 36;
		else if(*pion_west==44)
			*pion_west = 54;

		printf("Mon pion avance en %i\n",*pion_west);
	}

	if(table[meilleur].ville){
		printf("Je tombe sur une ville et je passe a la suivante\n");
		*pion_west += 10;
		printf("Mon pion avance en %i\n",*pion_west);
	}

	if(table[meilleur].collision){
		printf("Mon pion arrive sur la meme case que toi\n");
		*pion_joueur = table[meilleur].nouv_posit_adv;
		printf("Ton pion recule en %i\n",*pion_joueur);
	}
}

/*--------------------------------------------------------*/

int main(){

	/* Position des pions sur le parcours et scores*/
	int pion_joueur, score_joueur=0;
	int pion_west,	score_west=0;

	/* Pour jouer une autre partie */
	char reponse;

	/* Initialisation du tirage pseudo-al�atoire */
	srand(time(0));

	//modele_appr.diffVille = [0,0]

	/* D�but du jeu */
	do{
		pion_joueur=0;
		pion_west = 0;
		do{
			printf("\nA ton tour de jouer! ");
			printf("Tu es en %i\n",pion_joueur);
			tour_joueur(&pion_joueur,&pion_west);
			attendre();

			if(pion_joueur<70){
				printf("\nA mon tour de jouer! ");
				printf("Je suis en %i\n",pion_west);
				tour_west(&pion_joueur,&pion_west);
				attendre();
			}
		}
		while(pion_joueur<70 && pion_west<70);

		/* Fin de partie */
		if(pion_joueur==70){
			score_joueur++;
			printf("\nBravo, tu as gagne!\n");
		}
		else{
			score_west++;
			printf("\nJ'ai gagne!\n");
		}

		printf("Joueur : %i, ",score_joueur);
		printf("West : %i\n",score_west);
		printf("Veux-tu jouer une autre partie (o/n) ? ");
		scanf("%c%*c",&reponse);
	}while(reponse!='n');

	afficher_modele_apprenant();

}
