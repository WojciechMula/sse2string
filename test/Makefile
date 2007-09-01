.DEFAULT_GOAL := help

help:
	$(info arguments:)
	$(info * result - gather results from subdirectories (results.tar.gz is created))
	$(info * plots - make plots of results)

results: results.tar.gz

results.tar.gz:
	tar -czf $@ str*/*256 str*/*16k *.gnuplot Makefile strncmp/16383

PICS=strlena.png strlenb.png	\
     strchra.png strchrb.png	\
     strrchra.png strrchrb.png	\
     strcmpaa_s.png strcmpaa_l.png	\
     strcmpuu_s.png strcmpuu_l.png	\
     strcmpua_s.png strcmpua_l.png	\
     strcmpe_s.png strcmpe_l.png

plots: $(PICS)

strlena.png strchra.png strrchra.png:
	sh plot1.gnuplot $(subst a.png,,$@)

strlenb.png strchrb.png strrchrb.png:
	sh plot2.gnuplot $(subst b.png,,$@)

strcmpaa_s.png:
	sh strcmp_s.gnuplot strcmp $@ 0 0 0 16 16 0 16 16
strcmpuu_s.png:
	sh strcmp_s.gnuplot strcmp $@ 7 25 25 7
strcmpua_s.png:
	sh strcmp_s.gnuplot strcmp $@ 0 7 0 25 16 7 16 25 7 0 7 16 25 0 25 16
strcmpe_s.png:
	sh strcmp_s.gnuplot strcmp $@ 7 7 25 25

strcmpaa_l.png:
	sh strcmp_l.gnuplot strcmp $@ 0 0 0 16 16 0 16 16
strcmpuu_l.png:
	sh strcmp_l.gnuplot strcmp $@ 7 25 25 7
strcmpua_l.png:
	sh strcmp_l.gnuplot strcmp $@ 0 7 0 25 16 7 16 25 7 0 7 16 25 0 25 16
strcmpe_l.png:
	sh strcmp_l.gnuplot strcmp $@ 7 7 25 25

strncmpa.png strncmpb.png:
	sh $(subst .png,,$@).gnuplot strncmp
