.DEFAULT_GOAL := help

help:
	$(info arguments:)
	$(info * result - gather results from subdirectories (results.tar.gz is created))
	$(info * plots - make plots of results)

results: results.tar.gz

results.tar.gz:
	tar -czf $@ str*/*256 str*/*16k *.gnuplot Makefile

PICS=strlena.png strlenb.png	\
     strchra.png strchrb.png	\
     strrchra.png strrchrb.png	\
     strcmpaa.png strcmpab.png	\
     strcmpua.png strcmpub.png	\
     strncmpa.png strncmpb.png

plots: $(PICS)

strlena.png strchra.png strrchra.png:
	sh plot1.gnuplot $(subst a.png,,$@)

strlenb.png strchrb.png strrchrb.png:
	sh plot2.gnuplot $(subst b.png,,$@)

strcmpua.png strcmpub.png strcmpaa.png strcmpab.png:
	sh $(subst .png,,$@).gnuplot strcmp

strncmpa.png strncmpb.png:
	sh $(subst .png,,$@).gnuplot strncmp
