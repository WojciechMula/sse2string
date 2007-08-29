/* $Id: timeit.c,v 1.1 2007-08-29 14:15:49 wojtek Exp $ */
#include <sys/time.h>
#include <time.h>

#ifndef MAXITERS
#	define MAXITERS 200
#endif

struct timeval t1, t2;
int n, i, time1, time2, dt, best=1000000000;

#define TIMEIT(expression)					\
	for (i=0; i < MAXITERS; i++) {				\
		gettimeofday(&t1, NULL);			\
		n = cnt;					\
		while (n--)					\
			{expression;}				\
		gettimeofday(&t2, NULL);			\
		dt = timeval2int(t2) - timeval2int(t1);		\
		if (dt < best) best = dt;			\
	}							\
	printf("%d\n", best);

/* eof */
