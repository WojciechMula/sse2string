LIB=libsse2str.a

LIBOPTS=
ifeq ($(MAKECMDGOALS),imul)
LIBOPTS=-DSSESTR_IMUL_POPULATE
endif

ifeq ($(MAKECMDGOALS),sse3)
LIBOPTS=-DSSESTR_SSE3_POPULATE
endif

library: $(LIB)
imul: $(LIB)
sse3: $(LIB)

$(LIB): *.o
	ar cr $(LIB) $?
	ranlib $(LIB)

%.o: %.S
	gcc $(LIBOPTS) -c $?

clean:
	$(RM) *.o
	$(RM) $(LIB)
