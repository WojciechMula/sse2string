/*
 *  SSE2 string routines library
 *  implementation of unsafe strncmp
 *
 *  $Revision: 1.7 $, $Date: 2007-09-06 11:43:13 $
 *
 *  Author: Wojciech Mu³a
 *  e-mail: wojciech_mula@poczta.onet.pl
 *  project page: http://www.republika.pl/wmula/proj/sse2string/
 *
 *  License: BSD
 */

.code32
.text

.global sse2_strncmp_unsafe
.type   sse2_strncmp_unsafe, @function
.align  32
sse2_strncmp_unsafe:
         mov    4(%esp),  %ecx      # s1
         mov    8(%esp),  %edx      # s2
         mov   12(%esp),  %eax      # n 

         pxor     %xmm2,  %xmm2     # xmm2 := packed_byte(0x00)
         push     %ebx
         push     %edi
         mov      %eax,    %edi

         cmp      $16,     %eax     # n < 16
         jl       .L_16less
         and      $~0x0f,  %eax     # (n / 16) * 16
         
    .align 16
    .L_mainloop:
         movaps   (%ecx),  %xmm0
         movaps   (%edx),  %xmm1
         add      $16,     %ecx
         add      $16,     %edx
         pcmpeqb  %xmm0,   %xmm1    # compare strings
         pcmpeqb  %xmm2,   %xmm0    # locate '\0'
         pandn    %xmm1,   %xmm0 
         pmovmskb %xmm0,   %ebx
         xor $0x0000ffff,  %ebx
         jnz      .L_result16

         sub      $16,     %eax
         jnz      .L_mainloop

    .L_16less:
         and      $0xf,    %edi     # n % 16
         jz       .L_end

         movaps   (%ecx),  %xmm0
         movaps   (%edx),  %xmm1
         add      $16,     %ecx
         add      $16,     %edx
         pcmpeqb  %xmm0,   %xmm1    # compare strings
         pcmpeqb  %xmm2,   %xmm0    # locate '\0'
         pandn    %xmm1,   %xmm0 
         pmovmskb %xmm0,   %ebx
         sub      $1,      %edi
         btr      %edi,    %ebx     # reset bit before end of string
         xor $0x0000ffff,  %ebx
         jnz      .L_result16
    .L_end:
         movzbl -16(%edx, %edi, 1), %edx
         movzbl -16(%ecx, %edi, 1), %eax
         pop      %edi
         pop      %ebx
         sub      %edx,    %eax
         ret

    .L_result16: 
         bsf      %ebx,    %ebx
         movzbl -16(%edx, %ebx, 1), %edx
         movzbl -16(%ecx, %ebx, 1), %eax
         pop      %edi
         pop      %ebx
         sub      %edx,    %eax
         ret

# vim: ts=9 nowrap et
