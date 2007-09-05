.DEFAULT_GOAL := help

help:
	@echo arguments:
	@echo \* library - make library
	@echo \* speedup - test speedup of all functions
	@echo \* results - gather speedup results \& create plots
	@echo \* clean   - clean compiled files
	@echo \* cleanresults - just append .bak for all results files!

library:
	$(MAKE) -C src

speedup:
	$(MAKE) speedup -C test

results:
	$(MAKE) results -C test

clean:
	$(MAKE) clean -C src
	$(MAKE) clean -C test

cleanresults:
	$(MAKE) $@ -C test
