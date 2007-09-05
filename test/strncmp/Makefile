include ../Makefile.inc

strncmp: test.c
	gcc -o strncmp -L$(LIBPATH) -I$(INCPATH) test.c -l$(LIBNAME)

verify: strncmp
	sh verify.sh && touch verify

clean:
	$(RM) strncmp

RESULTS=256 16383

cleanresults:
	for f in $(RESULTS); do mv $$f $$f.bak; done

speedup: strncmp $(RESULTS)

256:
	sh measure-short.sh $@

16383:
	sh measure-long.sh $@
