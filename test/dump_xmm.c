#include <stdint.h>
#include <stdio.h>

void dump_xmm(int i) {
	static uint8_t buffer[16];
	int k;
	switch (i) {
		case 0: asm("movups %%xmm0, (%0)" : : "r" (buffer)); break;
		case 1: asm("movups %%xmm1, (%0)" : : "r" (buffer)); break;
		case 2: asm("movups %%xmm2, (%0)" : : "r" (buffer)); break;
		case 3: asm("movups %%xmm3, (%0)" : : "r" (buffer)); break;
		case 4: asm("movups %%xmm4, (%0)" : : "r" (buffer)); break;
		case 5: asm("movups %%xmm5, (%0)" : : "r" (buffer)); break;
		case 6: asm("movups %%xmm6, (%0)" : : "r" (buffer)); break;
		case 7: asm("movups %%xmm7, (%0)" : : "r" (buffer)); break;
		default:
			return;
	}
	
	printf("xmm%d=", i);
	
	for (k=15; k >= 0; k--)
		printf("%02x", buffer[k]);
	printf(", \"");

	for (k=0; k < 16; k++)
		if (buffer[k] >= 32 && buffer[k] < 128)
			printf("%c", buffer[k]);
		else
			printf("\\%02x", buffer[k]);
	printf("\"\n");
}
