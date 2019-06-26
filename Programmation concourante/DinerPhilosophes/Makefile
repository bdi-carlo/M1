opt = -g -Wall -D_DEBUG_

fich_obj_philo = philo.o

philo : philo.c
	gcc ${opt} -o philo philo.c

#commun.o : commun.c commun.h 
#	gcc $(opt) commun.c -o commun.o

clean : 
	rm -f *.o 
	rm philo

all :  philo
