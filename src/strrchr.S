.text

.macro  BASIC_STEP16       # process 16 bytes
         movaps   (%eax),  %xmm0    # load 16 bytes
         add      $16,     %eax     # advance address
         movaps   %xmm0,   %xmm1    # copy bytes

         pcmpeqb  %xmm7,   %xmm0    # find null byte(s)
         pcmpeqb  %xmm6,   %xmm1    # find char(s)

         pmovmskb %xmm0,   %edx     # mask for null byte(s)
         pmovmskb %xmm1,   %ecx     # mask for char(s)
.endm

.global sse2_strrchr
.type   sse2_strrchr, @function
.align  32
sse2_strrchr:
         # %eax - address, # %edx - char
         pxor     %xmm7,   %xmm7      # xmm7 := packed_byte(0x00)


         # populate char, i.e. xmm6 := pakced_byte(al)
#ifdef SSESTR_IMUL_POPULATE
         movzx  8(%esi),   %eax     # load char
         imul $0x01010101, %eax, %eax
         movd     %eax,    %xmm6
         pshufd   $0x00,   %xmm6, %xmm6
#else
#ifdef SSESTR_SSE3_POPULATE
         movd   8(%esi),   %xmm6    # load char
         pshufb   %xmm0,   %xmm6
#else
         mov    8(%esi),   %al      # load char
         mov      %al,     %ah
         mov      %eax,    %edx
         shl      $16,     %edx
         or       %edx,    %eax
         movd     %eax,    %xmm6
         pshufd   $0x00,   %xmm6, %xmm6
#endif /* SSESTR_SSE3_POPULATE */
#endif /* SSESTR_IMUL_POPULATE */

         mov    12(%esi),  %eax     # load address
         push     %ebx              # save ebx
         xor      %eax,    %ebx     # and set NULL address

         test     $0xf,    %eax     # is address aligned at 16-byte boundary?
         jz       .L_aligned

    .L_unaligned:
         mov      %eax,    %edx
         and      $0xf,    %eax     # align address

         mov      $-1,     %ebx     # bytes to mask
         and      $~0xf,   %edx
         btr      %edx,    %ebx
         add      $1,      %ebx     # ebx - bitmask

         BASIC_STEP16               # find null(s)/char(s)
         and      %ebx,    %ecx     # mask char(s) positions
         and      %ebx,    %edx     # mask null(s) positions
         jnz      .L_result         # ... any nulls? exit
         test     %ecx,    %ecx     # any chars?
         jnz      .L_update         # ... update position

    .L_aligned:
         BASIC_STEP16               # find null(s)/char(s)

         test     %edx,    %edx     # null byte?
         jnz      .L_result         # ... yes, exit

         test     %ecx,    %ecx     # char found?
         jnz      .L_aligned        # ... yes
         .L_update:
         bsr      %ecx, %ecx        # ... find pos. of last char
         lea  -16(%eax, %ecx), %ebx # ... update address (ebx)
         jmp      .L_aligned        # ... and continue

    .L_result:
         bsf      %edx,    %edx     # null's position
         xor      %eax,    %eax
         bts      %edx,    %eax     # mask bytes to first null
         and      %eax,    %ecx
         jz       .L_return

         bsr      %ecx,    %ecx     # position of last char
         lea  -16(%eax, %ecx), %eax
         pop      %ebx
         ret
    .L_return:
         mov      %ebx,    %eax     # save result
         pop      %ebx
         ret


# vim: ts=9 et
