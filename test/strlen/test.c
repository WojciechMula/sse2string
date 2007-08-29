#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../timeit.c"

#define kB   *1024
#define SIZE (16 kB)
char buffer[SIZE] __attribute__((aligned(4 kB)));

int main(int argc, char* argv[]) {
	if (argc < 6) {
		printf("%s verbose offset nullpos iterations function\n", argv[0]);
		return 1;
	}

	int v	= atoi(argv[1]);
	int ofs	= atoi(argv[2]);
	int len = atoi(argv[3]);
	int cnt = atoi(argv[4]);
	int fun = atoi(argv[5]);

	if (v) {
		printf("string at %d, length %d: ", ofs, len-ofs);
		if (fun == 0)
			printf("builtin function, will run %d times", cnt);
		else
		if (fun == 1)
			printf("SSE function, will run %d times", cnt);
		else
			printf("verification");
		putchar('\n');
	}

	char *text = &buffer[ofs];
	memset(buffer, 'c', sizeof(buffer));
	buffer[SIZE-1] = buffer[len] = 0;

	int l1, l2;
	
	switch (fun) {
		case 0:
			TIMEIT(l1 = strlen(text))
			break;
		case 1:
			TIMEIT(l2 = sse2_strlen(text))
			break;
		default:
			l1 = strlen(text);
			l2 = sse2_strlen(text);
			if (l1 != l2) {
				printf("error: result is %d, should be %d\n", l2, l1); 
				return 1;
			}
			else
			if (v)
				printf("ok, result is %d\n", l1);
	}
	return 0;
}
