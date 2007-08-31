include ../Makefile.inc

strlen: test.c
	gcc -o strlen -L$(LIBPATH) -I$(INCPATH) test.c -l$(LIBNAME)

verify: strlen
	sh verify.sh && touch verify

speedup: strlen 0-256 7-256 16-256 25-256 0-16k 7-16k 16-16k 25-16k

0-256:
	sh measure-short.sh 0
7-256:
	sh measure-short.sh 7
16-256:
	sh measure-short.sh 16
25-256:
	sh measure-short.sh 25
0-16k:
	sh measure-long.sh 0
7-16k:
	sh measure-long.sh 7
16-16k:
	sh measure-long.sh 16
25-16k:
	sh measure-long.sh 25
