include ../Makefile.inc

strcmp: test.c
	gcc -o strcmp -L$(LIBPATH) -I$(INCPATH) test.c -l$(LIBNAME)

verify: strcmp
	sh verify.sh && touch verify

OFFSETS=0 7 16 25
RESULTS256=$(foreach o1,$(OFFSETS),$(foreach o2,$(OFFSETS),$(o1)-$(o2)-256))
RESULTS16k=$(foreach o1,$(OFFSETS),$(foreach o2,$(OFFSETS),$(o1)-$(o2)-16k))

clean:
	$(RM) strcmp

cleanresults:
	for f in $(RESULTS256); do mv $$f $$f.bak; done
	for f in $(RESULTS16k); do mv $$f $$f.bak; done

speedup: strcmp $(RESULTS256) $(RESULTS16k)

0-0-256:
	sh measure-short.sh 0 0
0-7-256:
	sh measure-short.sh 0 7
0-16-256:
	sh measure-short.sh 0 16
0-25-256:
	sh measure-short.sh 0 25

7-0-256:
	sh measure-short.sh 7 0
7-7-256:
	sh measure-short.sh 7 7
7-16-256:
	sh measure-short.sh 7 16
7-25-256:
	sh measure-short.sh 7 25

16-0-256:
	sh measure-short.sh 16 0
16-7-256:
	sh measure-short.sh 16 7
16-16-256:
	sh measure-short.sh 16 16
16-25-256:
	sh measure-short.sh 16 25

25-0-256:
	sh measure-short.sh 25 0
25-7-256:
	sh measure-short.sh 25 7
25-16-256:
	sh measure-short.sh 25 16
25-25-256:
	sh measure-short.sh 25 25

0-0-16k:
	sh measure-long.sh 0 0
0-7-16k:
	sh measure-long.sh 0 7
0-16-16k:
	sh measure-long.sh 0 16
0-25-16k:
	sh measure-long.sh 0 25

7-0-16k:
	sh measure-long.sh 7 0
7-7-16k:
	sh measure-long.sh 7 7
7-16-16k:
	sh measure-long.sh 7 16
7-25-16k:
	sh measure-long.sh 7 25

16-0-16k:
	sh measure-long.sh 16 0
16-7-16k:
	sh measure-long.sh 16 7
16-16-16k:
	sh measure-long.sh 16 16
16-25-16k:
	sh measure-long.sh 16 25

25-0-16k:
	sh measure-long.sh 25 0
25-7-16k:
	sh measure-long.sh 25 7
25-16-16k:
	sh measure-long.sh 25 16
25-25-16k:
	sh measure-long.sh 25 25
