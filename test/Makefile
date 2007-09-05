.DEFAULT_GOAL := help

help:
	@echo arguments:
	@echo \* result - gather results from subdirectories\; results.tar.gz is created
	@echo \* plots - make plots of results

FUNCTIONS=strlen strchr strrchr strcmp strncmp
.PHONY: $(FUNCTIONS) speedup results clean

speedup: $(FUNCTIONS)

$(FUNCTIONS):
	$(MAKE) speedup -C $@

results: results.tar.gz

results.tar.gz: speedup plots
	tar -czf $@ str*/*256 str*/*16k *.gnuplot Makefile strncmp/16383 *.png

PICS=strlena.png strlenb.png	\
     strchra.png strchrb.png	\
     strrchra.png strrchrb.png	\
     strcmpaa_s.png strcmpaa_l.png	\
     strcmpuu_s.png strcmpuu_l.png	\
     strcmpua_s.png strcmpua_l.png	\
     strcmpe_s.png strcmpe_l.png

clean:
	$(RM) $(PICS)
	$(RM) reults.tar.gz
	$(MAKE) clean -C strlen
	$(MAKE) clean -C strchr
	$(MAKE) clean -C strrchr
	$(MAKE) clean -C strcmp
	$(MAKE) clean -C strncmp

cleanresults:
	$(MAKE) $@ -C strlen
	$(MAKE) $@ -C strchr
	$(MAKE) $@ -C strrchr
	$(MAKE) $@ -C strcmp
	$(MAKE) $@ -C strncmp

plots: $(PICS)

# pics
strlena.png: strlen
	sh plot1.gnuplot $(subst a.png,,$@)
strchra.png: strchr
	sh plot1.gnuplot $(subst a.png,,$@)
strrchra.png: strrchr
	sh plot1.gnuplot $(subst a.png,,$@)

strlenb.png: strlen
	sh plot2.gnuplot $(subst b.png,,$@)
strchrb.png: strchr
	sh plot2.gnuplot $(subst b.png,,$@)
strrchrb.png: strrchr
	sh plot2.gnuplot $(subst b.png,,$@)

strcmpaa_s.png: strcmp
	sh strcmp_s.gnuplot strcmp $@ 0 0 0 16 16 0 16 16
strcmpuu_s.png: strcmp
	sh strcmp_s.gnuplot strcmp $@ 7 25 25 7
strcmpua_s.png: strcmp
	sh strcmp_s.gnuplot strcmp $@ 0 7 0 25 16 7 16 25 7 0 7 16 25 0 25 16
strcmpe_s.png: strcmp
	sh strcmp_s.gnuplot strcmp $@ 7 7 25 25

strcmpaa_l.png: strcmp
	sh strcmp_l.gnuplot strcmp $@ 0 0 0 16 16 0 16 16
strcmpuu_l.png: strcmp
	sh strcmp_l.gnuplot strcmp $@ 7 25 25 7
strcmpua_l.png: strcmp
	sh strcmp_l.gnuplot strcmp $@ 0 7 0 25 16 7 16 25 7 0 7 16 25 0 25 16
strcmpe_l.png: strcmp
	sh strcmp_l.gnuplot strcmp $@ 7 7 25 25

strncmpa.png strncmpb.png: strncmp
	sh $(subst .png,,$@).gnuplot strncmp
