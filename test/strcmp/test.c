#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sse2string.h>
#include "../timeit.c"

#define kB   *1024
#define SIZE (16 kB)
char buffer1[SIZE] __attribute__((aligned(4 kB)));
char buffer2[SIZE] __attribute__((aligned(4 kB)));

int sign(int x) {
	if (x < 0) return -1; else
	if (x > 0) return +1; else return 0;
}

int main(int argc, char* argv[]) {
	if (argc < 8) {
		printf("%s verbose offset1 offset2 nullpos1 nullpos2 iterations function\n", argv[0]);
		return 1;
	}

	int v    = atoi(argv[1]);

	int ofs1 = atoi(argv[2]);
	int ofs2 = atoi(argv[3]);

	int len1 = atoi(argv[4]);
	int len2 = atoi(argv[5]);

	int cnt  = atoi(argv[6]);
	int fun  = atoi(argv[7]);

	if (v) {
		printf("string 1 at %d, length %d, ", ofs1, len1-ofs1);
		printf("string 2 at %d, length %d: ", ofs2, len2-ofs2);
		if (fun == 0)
			printf("builtin function, will run %d times", cnt);
		else
		if (fun == 1)
			printf("SSE function, will run %d times", cnt);
		else
			printf("verification");
		putchar('\n');
	}

	char *text1 = &buffer1[ofs1];
	char *text2 = &buffer2[ofs2];
	memset(buffer1, 'a', sizeof(buffer1));
	memset(buffer2, 'a', sizeof(buffer2));
	buffer1[SIZE-1] = buffer1[len1] = 0;
	buffer2[SIZE-1] = buffer2[len2] = 0;

	int l1, l2;
	switch (fun) {
		case 0:
			TIMEIT(l1 = strcmp(text1, text2));
			break;
		case 1:
			TIMEIT(l2 = sse2_strcmp(text1, text2));
			break;
		default:
			l1 = strcmp(text1, text2);
			l2 = sse2_strcmp(text1, text2);
			if (sign(l1) != sign(l2)) {
				printf("error: result is %d, should be %d\n", l2, l1); 
				return 1;
			}
			else
			if (v)
				printf("ok, result is %d\n", l1);
	}
	return 0;
}

// vim: ts=4 sw=4 nowrap
