/* $Id: timeit.c,v 1.3 2007-08-29 14:42:29 wojtek Exp $ */
#include <sys/time.h>
#include <time.h>

#ifndef MAXITERS
#	define MAXITERS 200
#endif

struct timeval t1, t2;
int k, i, time1, time2, dt, best=1000000000;

#define TIMEIT(expression)					\
	for (i=0; i < MAXITERS; i++) {				\
		gettimeofday(&t1, NULL);			\
		k = cnt;					\
		while (k--)					\
			{expression;}				\
		gettimeofday(&t2, NULL);			\
		time1 = 1000000*t1.tv_sec + t1.tv_usec;		\
		time2 = 1000000*t2.tv_sec + t2.tv_usec;		\
		dt = time2 - time1;				\
		if (dt < best) best = dt;			\
	}							\
	printf("%d\n", best);

/* eof */
