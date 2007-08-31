LIBPATH=../../src/
LIBNAME=sse2string
INCPATH=../../src/

results: results.tar.gz

results.tar.gz:
	tar -czf $@ str*/*256 str*/*16k *.gnuplot Makefile

PICS=strlena.png strlenb.png	\
     strchra.png strchrb.png	\
     strrchra.png strrchrb.png	\
     strcmpaa.png strcmpab.png	\
     strcmpua.png strcmpub.png

plots: $(PICS)

strlena.png:
	sh plot1.gnuplot strlen
strlenb.png:
	sh plot2.gnuplot strlen
strchra.png:
	sh plot1.gnuplot strchr
strchrb.png:
	sh plot2.gnuplot strchr
strrchra.png:
	sh plot1.gnuplot strrchr
strrchrb.png:
	sh plot2.gnuplot strrchr

strcmpua.png:
	sh strcmpua.gnuplot strcmp
strcmpub.png:
	sh strcmpub.gnuplot strcmp
strcmpaa.png:
	sh strcmpaa.gnuplot strcmp
strcmpab.png:
	sh strcmpab.gnuplot strcmp
