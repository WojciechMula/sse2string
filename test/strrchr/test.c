#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sse2string.h>
#include "../timeit.c"

#define kB   *1024
#define SIZE (16 kB)
char buffer[SIZE] __attribute__((aligned(4 kB)));

int main(int argc, char* argv[]) {
	if (argc < 8) {
		printf("%s verbose offset char1pos char2pos nullpos iterations function\n", argv[0]);
		return 1;
	}

	int v	= atoi(argv[1]);
	int ofs	= atoi(argv[2]);
	int p1 	= atoi(argv[3]);
	int p2 	= atoi(argv[4]);
	int len = atoi(argv[5]);
	int cnt = atoi(argv[6]);
	int fun = atoi(argv[7]);

	if (v) {
		printf("string at %d, length %d, chars at %d and %d: ", ofs, len-ofs, p1-ofs, p2-ofs);
		if (fun == 0)
			printf("builtin function, will run %d times", cnt);
		else
		if (fun == 1)
			printf("SSE function, will run %d times", cnt);
		else
			printf("verification");
		putchar('\n');
	}

	int c = 'X';

	char *text = &buffer[ofs];
	memset(buffer, 'a', sizeof(buffer));
	buffer[p1] = buffer[p2] = c;
	buffer[SIZE-1] = buffer[len] = 0;

	char *l1, *l2;
	switch (fun) {
		case 0:
			TIMEIT(l1 = strrchr(text, c));
			break;
		case 1:
			TIMEIT(l2 = sse2_strrchr(text, c));
			break;
		default:
			l1 = strrchr(text, c);
			l2 = sse2_strrchr(text, c);
			if (l1 != l2) {
				printf("error: result is 0x%08x, should be 0x%08x\n",
				       (unsigned int)l2, (unsigned int)l1); 
				return 1;
			}
			else
			if (v)
				printf("ok, result is 0x%08x\n", (unsigned int)l1);
	}
	return 0;
}

// vim: ts=4 sw=4 nowrap
