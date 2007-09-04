ARCH=sse2string.tar.gz
ARCH_ALL=sse2string-all.tar.gz

DIR=../sse2string

arch: $(ARCH) $(ARCH_ALL)

$(ARCH): $(DIR)/src/*.S
	tar -czf $(ARCH) $(DIR)/src/*.S

$(ARCH_ALL): $(DIR)/src/*.S
	tar -czf $(ARCH_ALL) \
	$(DIR)/src/*.S \
	$(DIR)/test/*.gnuplot \
	$(DIR)/test/*.c \
	$(DIR)/test/Makefile \
	$(DIR)/test/str*/*.c \
	$(DIR)/test/str*/*.sh \
	$(DIR)/test/str*/Makefile \

$(DIR)/src/*.S:

clean:
	$(RM) $(ARCH) $(ARCH_ALL)
