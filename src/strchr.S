.text

.global sse2_strchr
.type   sse2_strchr, @function
.align  32
sse2_strchr:
	# eax = adres, edx = bajt
	#mov    4(%esp),  %eax	# get address
	pxor     %xmm0,   %xmm0	# xmm0 := packed_byte(0x00)

	mov      %al,     %ah      # xmm1 := packed_byte(%al)
	mov      %eax,    %ecx
	shl      $16,     %ecx
         or       %ecx,    %eax
         movd     %eax,    %xmm1
         pshufd   $0x00,   %xmm1, %xmm1

	.L_unaligned:
		mov      %eax,   %edx
		mov      $-1,    %ecx	# ecx := 0xffffffff
		and      $~0xf,  %eax	# align address at 16-boundary
		and      $0xf,   %edx	# ebx := bytes to skip
		btr      %edx,   %ecx
		add      $1,     %ecx	# ecx := mask

		movaps	 (%eax), %xmm2
		add      $16,    %eax
                  movaps   %xmm2,   %xmm3
		pcmpeqb  %xmm0,  %xmm2
		pcmpeqb  %xmm1,  %xmm3
                  por      %xmm2,   %xmm3          
		pmovmskb %xmm3,  %edx
		and      %ecx,   %edx	# mask result
		jnz .L_result16
		
	.L_aligned16:
	test $0x10,  %eax		# is address aligned at 32-byte boundary?
	jz   .L_mainloop
	
		movaps	 (%eax), %xmm2
		add      $16,    %eax
                  movaps   %xmm2,   %xmm3
		pcmpeqb  %xmm0,  %xmm2
		pcmpeqb  %xmm1,  %xmm3
		pmovmskb %xmm3,  %edx
		xor $0x0000ffff, %edx
		jnz .L_result16


	.align 16
	.L_mainloop:
		movaps   (%eax),  %xmm2
		movaps 16(%eax),  %xmm3
		add      $32,     %eax
                  movaps   %xmm2,   %xmm4
                  movaps   %xmm3,   %xmm5
		pcmpeqb  %xmm0,   %xmm2
		pcmpeqb  %xmm0,   %xmm3
		pcmpeqb  %xmm1,   %xmm4
		pcmpeqb  %xmm1,   %xmm5
		por      %xmm4,   %xmm2
		por      %xmm5,   %xmm3
                  por      %xmm2,   %xmm3
		pmovmskb %xmm3,   %edx
		test     %edx,    %edx
		jz       .L_mainloop

	# calculate length
	pmovmskb %xmm0,  %ecx
	test     %ecx,   %ecx
	jz       .L_result16
	.L_result32:
		bsf    %ecx, %ecx
		lea    -32(%eax, %ecx), %edx
                  xor    %eax, %eax
                  cmpb   $0x00, (%edx)
                  cmovne %edx, %eax
		ret
	.L_result16:
		bsf    %edx, %edx
		lea    -32(%eax, %edx), %edx
                  xor    %eax, %eax
                  cmpb   $0x00, (%edx)
                  cmovne %edx, %eax
		ret

# vim: es, ts=9

