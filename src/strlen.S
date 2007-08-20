.text

.global sse2_strlen
.type   sse2_strlen, @function
.align  32
sse2_strlen:
	mov    4(%esp),  %eax	# get address
	pxor     %xmm0,  %xmm0	# xmm0 := packed_byte(0x00)
	
	test     $0x0f,  %eax	# is address aligned at 16-byte boundary?
	jz       .L_aligned16

	.L_unaligned:
		mov      %eax,   %edx
		mov      $-1,    %ecx	# ecx := 0xffffffff
		and      $~0xf,  %eax	# align address at 16-boundary
		and      $0xf,   %edx	# ebx := bytes to skip
		btr      %edx,   %ecx
		add      $1,     %ecx	# ecx := mask

		movaps	 (%eax), %xmm1
		add      $16,    %eax
		pcmpeqb  %xmm0,  %xmm1
		pmovmskb %xmm1,  %edx
		xor $0x0000ffff, %edx
		and      %ecx,   %edx	# mask result
		jnz .L_result16
		
	.L_aligned16:
	test $0x10,  %eax		# is address aligned at 32-byte boundary?
	jz   .L_mainloop
	
		movaps	 (%eax), %xmm1
		add      $16,    %eax
		pcmpeqb  %xmm0,  %xmm1
		pmovmskb %xmm1,  %edx
		xor $0x0000ffff, %edx
		jnz .L_result16


	.align 16
	.L_mainloop:
		movaps   (%eax), %xmm1
		movaps 16(%eax), %xmm2
		add      $32,    %eax
		pcmpeqb  %xmm0,  %xmm1
		pcmpeqb  %xmm0,  %xmm2
		por      %xmm1,  %xmm2
		pmovmskb %xmm1,  %edx
		xor $0x0000ffff, %edx
		jz       .L_mainloop

	# calculate length
	pmovmskb %xmm0,  %ecx
	test     %ecx,   %ecx
	jz       .L_result16
	.L_result32:
		bsf %ecx, %ecx
		mov 4(%esp), %edx
		lea -32(%eax, %ecx), %eax
		sub %edx, %eax
		ret
	.L_result16:
		bsf %edx, %edx
		mov 4(%esp), %ecx
		lea -16(%eax, %edx), %eax
		sub %ecx, %eax
		ret


# vim: ts=8 sw=8 tw=0 nowrap noexpandtab
