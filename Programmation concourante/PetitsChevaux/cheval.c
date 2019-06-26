/* Benjamin Di Carlo */
#include <stdio.h>
#include <stdlib.h>
#include <sys/msg.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>

#include <commun.h>
#include <liste.h>
#include <piste.h>

static struct sembuf Op_P = {0 , -1 , 0};
static struct sembuf Op_V = {0 , 1 , 0};

static void P( int semId ){
	semop( semId, &Op_P, 1 );
}

static void V( int semId ){
	semop( semId, &Op_V ,1 );
}

static void PInd( int semId, int ind ){
	struct sembuf Op_Pind = {ind, -1, 0};
	semop( semId, &Op_Pind, 1 );
}

static void VInd( int semId, int ind ){
	struct sembuf Op_Vind = {ind, 1, 0};
	semop( semId, &Op_Vind, 1 );
}

int
main( int nb_arg , char * tab_arg[] )
{

  int cle_piste ;
  piste_t * piste = NULL ;

  int cle_liste ;
  liste_t * liste = NULL ;

  char marque ;

  booleen_t fini = FAUX ;
  booleen_t gagne = FAUX;
  piste_id_t deplacement = 0 ;
  piste_id_t depart = 0 ;
  piste_id_t arrivee = 0 ;

  cell_t cell_cheval ;

  elem_t elem_cheval ;

  /*-----*/

  if( nb_arg != 4 )
    {
      fprintf( stderr, "usage : %s <cle de piste> <cle de liste> <marque>\n" , tab_arg[0] );
      exit(-1);
    }

  if( sscanf( tab_arg[1] , "%d" , &cle_piste) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise cle de piste (%s)\n" ,
	       tab_arg[0]  , tab_arg[1] );
      exit(-2);
    }


  if( sscanf( tab_arg[2] , "%d" , &cle_liste) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise cle de liste (%s)\n" ,
	       tab_arg[0]  , tab_arg[2] );
      exit(-2);
    }

  if( sscanf( tab_arg[3] , "%c" , &marque) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise marque de cheval (%s)\n" ,
	       tab_arg[0]  , tab_arg[3] );
      exit(-2);
    }

	// Récupération de la piste et de la file
	int shmidPiste;
	if( (shmidPiste = shmget( cle_piste, PISTE_LONGUEUR*sizeof(cell_t), 0 )) == -1 ){
		printf("Pb sur shmget piste\n");
		exit(-1);
	}
	if( (piste = shmat( shmidPiste, 0, 0 )) == (int *)-1 ){
		printf("Pb sur shmat piste\n");
		exit(-2);
	}
	int shmidListe;
	if( (shmidListe = shmget( cle_liste, LISTE_MAX*sizeof(elem_t), 0 )) == -1 ){
		printf("Pb sur shmget liste\n");
		exit(-1);
	}
	if( (liste = shmat( shmidListe, 0, 0 )) == (int *)-1 ){
		printf("Pb sur shmat liste\n");
		exit(-2);
	};

	// Récupération de leur sémaphore respective
	int semPiste; 
	if( (semPiste = semget( cle_piste, PISTE_LONGUEUR, 0 )) == -1 ){
		printf("Pb semget piste");
		exit(-3);
	}
	int semListe;
	if( (semListe = semget( cle_liste, 1, 0 )) == -1 ){
		printf("Pb semget liste");
		exit(-3);
	}
	
  /* Init de l'attente */
  commun_initialiser_attentes() ;

  /* Init de la cellule du cheval pour faire la course */
  cell_pid_affecter( &cell_cheval  , getpid());
  cell_marque_affecter( &cell_cheval , marque );

  /* Init de l'element du cheval pour l'enregistrement et création de son sémaphore pour le protéger */
  elem_cell_affecter(&elem_cheval , cell_cheval ) ;
  elem_etat_affecter(&elem_cheval , EN_COURSE ) ;
	elem_sem_creer(&elem_cheval);

  /*
   * Enregistrement du cheval dans la liste mais en protégeant la liste
   */

	P(semListe);
	liste_elem_ajouter(liste, elem_cheval);
	V(semListe);

  while( ! fini )
    {
      /* Attente entre 2 coup de de */
      commun_attendre_tour() ;

      /*
       * Verif si decanille
       */
		if( elem_decanille(elem_cheval) ){
			fini = VRAI;

			// Si il est decanille alors on l'enlève de la liste on détruit son sémaphore et c'est terminé pour lui
			P(semListe);
			int ind;
			liste_elem_rechercher(&ind, liste, elem_cheval);
			liste_elem_supprimer(liste, ind);
			V(semListe);
			elem_sem_detruire(&elem_cheval);

			exit(0);
		}

		/*
		 * Sinon il peut jouer
		 */

    	/*
       * Avancee sur la piste
       */

      /* Coup de de */
      deplacement = commun_coup_de_de() ;
#ifdef _DEBUG_
      printf(" Lancement du De --> %d\n", deplacement );
#endif

      arrivee = depart+deplacement ;

      if( arrivee > PISTE_LONGUEUR-1 ){
			  arrivee = PISTE_LONGUEUR-1 ;
			  fini = VRAI ;
			  gagne = VRAI;
			}

      if( depart != arrivee ){

				// On verrouille d'abord notre cheval car sa situation va changer
				elem_sem_verrouiller(&elem_cheval);

			  /*
			   * Si case d'arrivee occupee alors on decanille le cheval existant
			   */
				// On verrouille la case concernée de la piste
				PInd( semPiste, arrivee );
				if( piste_cell_occupee(piste, arrivee) ){
						cell_t cellChevalDeca;
						piste_cell_lire(piste, arrivee, &cellChevalDeca);
						elem_t elemChevalDeca;
						elem_cell_affecter(&elemChevalDeca, cellChevalDeca);

						// On decanille et on l'efface de sa case
						elem_sem_verrouiller(&elemChevalDeca);
						int indDeca;
						P(semListe);
						liste_elem_rechercher(&indDeca, liste, elemChevalDeca);
						liste_elem_decaniller(liste, indDeca);
						V(semListe);
						piste_cell_effacer(piste, arrivee);
						elem_sem_deverrouiller(&elemChevalDeca);
				}

			  /*
			   * Deplacement: effacement case de depart, affectation case d'arrivee
			   */
				// On verrouille la case de départ également
				PInd( semPiste, depart );
				// On l'efface
				piste_cell_effacer(piste, depart);
				// Deverouillage case de depart
				VInd( semPiste, depart );

				commun_attendre_fin_saut();
				// Et on affecte le cheval sur sa nouvelle case
				piste_cell_affecter(piste, arrivee, cell_cheval);
				// Deverouillage case d'arrivee
				VInd( semPiste, arrivee );

				//Deverouillage du cheval
				elem_sem_deverrouiller(&elem_cheval);

		#ifdef _DEBUG_
			  printf("Deplacement du cheval \"%c\" de %d a %d\n",
				 marque, depart, arrivee );
		#endif


			}
      /* Affichage de la piste  */
      piste_afficher_lig( piste );

      depart = arrivee ;
    }
    
    if( gagne == VRAI )
		printf( "Le cheval \"%c\" A FRANCHIT LA LIGNE D ARRIVEE\n" , marque );

  /*
   * Suppression du cheval de la liste et de la piste
   */
   	PInd( semPiste, arrivee );
   	piste_cell_effacer(piste, arrivee);
   	VInd( semPiste, arrivee );
   	
  	P(semListe);
  	int ind;
	liste_elem_rechercher(&ind, liste, elem_cheval);
	liste_elem_supprimer(liste, ind);
	V(semListe);
	elem_sem_detruire(&elem_cheval);
  
  exit(0);
}
