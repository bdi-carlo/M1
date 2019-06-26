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
#include <sys/wait.h>

#define NB_PHILO 2
#define CLE 12

int s;

void P( int sem, int num ){
	struct sembuf Op_P[2];

	Op_P[0].sem_num = num;
	Op_P[0].sem_op = -1;
	Op_P[0].sem_flg = 0;

	Op_P[1].sem_num = ((num+1)%NB_PHILO);
	Op_P[1].sem_op = -1;
	Op_P[1].sem_flg = 0;

	if( semop(sem, Op_P, 2) == -1 ){
		perror("Pb semop");
		exit(-1);
	}
}

void V( int sem, int num ){
	struct sembuf Op_V[2];

	Op_V[0].sem_num = num;
	Op_V[0].sem_op = 1;
	Op_V[0].sem_flg = 0;

	Op_V[1].sem_num = ((num+1)%NB_PHILO);
	Op_V[1].sem_op = 1;
	Op_V[1].sem_flg = 0;

	if( semop(sem, Op_V, 2) == -1 ){
		perror("Pb semop");
		exit(-1);
	}
}

int philo( unsigned short i ){
	int nbSpaghettis = 2;

	while( nbSpaghettis > 0 ){
		sleep(1);

		// penser
		printf("Philo %i: Je pense\n", i);
		sleep(2);

		// P(Si) + P(Si+1%N)
		P(s, i);
		printf("Philo %i: J'ai pris les fourchettes %i et %i\n", i, i, (i+1)%NB_PHILO);

		int val1, val2;
		if( (val1 = semctl(s, i, GETVAL)) == -1 ){
			printf("Pb semctl\n");
			exit(-1);
		}
		if( (val2 = semctl(s, (i+1)%NB_PHILO, GETVAL)) == -1 ){
			printf("Pb semctl\n");
			exit(-1);
		}
		/*printf("\tFourchette n°%i --> %i\n\tFourchette n°%i --> %i\n", i, val1, (i+1)%NB_PHILO, val2);
		printf("Philo %i: Je prends les fourchettes n°%i et n°%i\n", i, i, (i+1)%NB_PHILO);*/

		// manger
		nbSpaghettis--;
		printf("Philo %i: Je suis en train de manger\n", i);
		sleep(4);

		// V(Si) + V(Si+1%N)
		V(s, i);

		printf("Philo %i: Jai mange et j'ai repose les fourchettes, il me reste %i spaghettis\n", i, nbSpaghettis);
	}

	exit(0);
}

int main(){
	int i;

	// Création ensemble de sémaphores du nombre de philos
	if( (s = semget(CLE, NB_PHILO, IPC_CREAT | 0666)) == -1 ){
		printf("Pb semget\n");
		exit(-1);
	}

	// Initialisation des sémaphores à 1
	for( i=0 ; i < NB_PHILO ; i++ ){
		semctl(s, i, SETVAL, 1);
	}

	// Verif
	/*for( i=0 ; i < NB_PHILO ; i++ ){
		int val = semctl(s, i, GETVAL);
		printf("Semaphore n°%i --> %i\n", i, val);
	}*/

	// Création des philosophes en parrallèle
	for( i=0 ; i < NB_PHILO ; i++ ){
		sleep(1);
		switch(fork()){
			case 0:
				philo(i);
				exit(0);
				break;
		}
	}

	// Attente de tous les fils
	for( i=0 ; i < NB_PHILO ; i++ )
		wait(0);

	semctl(s, 0, IPC_RMID, 0);
}
