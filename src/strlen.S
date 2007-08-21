/*
 *  SSE2 string routines library, $Revision: 1.3 $, $Date: 2007-08-21 21:44:40 $
 *  implementation of strlen
 *
 *  Author: Wojciech Mu³a
 *  e-mail: wojciech_mula@poczta.onet.pl
 *  project page: http://www.republika.pl/wmula/sse_str/
 *
 *  License: BSD
 */

.text

.macro  FIND_NULL16
         movaps   (%eax), %xmm1     # load 16 bytes
         add      $16,    %eax      # advance address
         pcmpeqb  %xmm0,  %xmm1     # locate null bytes
         pmovmskb %xmm1,  %edx      # result -> bitmask
         test     %edx,   %edx      # any bit set?
.endm

.global sse2_strlen
.type   sse2_strlen, @function
.align  32
sse2_strlen:
         mov    4(%esp),  %eax      # get address
         pxor     %xmm0,  %xmm0     # xmm0 := packed_byte(0x00)

         test     $0x0f,  %eax      # is address aligned at 16-byte boundary?
         jz       .L_aligned16

         .L_unaligned:
                  # address unaligned: we read 16-byte aligned chunk
                  # but mask lower bytes (before string start)
                  mov      %eax,   %edx
                  mov      $-1,    %ecx      # ecx := 0xffffffff
                  and      $~0xf,  %eax      # align address at 16-boundary
                  and      $0xf,   %edx      # ebx := bytes to skip
                  btr      %edx,   %ecx
                  add      $1,     %ecx      # ecx := mask

                  FIND_NULL16
                  and      %ecx,   %edx      # mask result
                  jnz .L_result16

         .L_aligned16:
                  test $0x10,  %eax          # is address aligned at 32-byte boundary?
                  jz   .L_mainloop

                  FIND_NULL16
                  jnz .L_result16


         .align 16
         .L_mainloop:
                  movaps   (%eax), %xmm1
                  movaps 16(%eax), %xmm2
                  add      $32,    %eax
                  pcmpeqb  %xmm0,  %xmm1
                  pcmpeqb  %xmm0,  %xmm2
                  por      %xmm1,  %xmm2
                  pmovmskb %xmm2,  %edx
                  test     %edx,   %edx      # is null in 32-byte chunk?
                  jz       .L_mainloop

         # calculate length
         pmovmskb %xmm1,  %ecx
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


# vim: ts=9 nowrap et
