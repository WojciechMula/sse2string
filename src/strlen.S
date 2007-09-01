/*
 *  SSE2 string routines library
 *  implementation of strlen, strlen_unsafe
 *
 *  $Revision: 1.8 $, $Date: 2007-09-01 12:02:11 $
 *
 *  Author: Wojciech Mu³a
 *  e-mail: wojciech_mula@poczta.onet.pl
 *  project page: http://www.republika.pl/wmula/proj/sse2string/
 *
 *  License: BSD
 */

.text

.macro  FIND_NULL16        # locate null byte(s) in a 16-byte chunk
         movaps   (%eax), %xmm1     # load 16 bytes
         add      $16,    %eax      # advance address
         pcmpeqb  %xmm0,  %xmm1     # locate null byte(s)
         pmovmskb %xmm1,  %edx      # result -> bitmask
         test     %edx,   %edx      # any bit set?
.endm

#define L(name) .L_##name

.global sse2_strlen
.type   sse2_strlen, @function
.align  32
sse2_strlen:
         mov    4(%esp),  %eax      # get address
         pxor     %xmm0,  %xmm0     # xmm0 := packed_byte(0x00)

         test     $0x0f,  %eax      # is address aligned at 16-byte boundary?
         jz       L(aligned16)

         L(unaligned):
                  # address unaligned: we read 16-byte aligned chunk
                  # and mask lower bytes (before string beginning)
                  mov      %eax,   %edx
                  mov      $-1,    %ecx      # ecx := 0xffffffff
                  and      $~0xf,  %eax      # align address at 16-boundary
                  and      $0xf,   %edx      # edx := bytes to skip
                  btr      %edx,   %ecx
                  add      $1,     %ecx      # ecx := mask

                  FIND_NULL16
                  and      %ecx,   %edx      # mask result
                  jnz L(result16)

         L(aligned16):
                  test $0x10,  %eax          # is address aligned at 32-byte boundary?
                  jz   L(mainloop)

                  FIND_NULL16
                  jnz L(result16)


         .align 16
         L(mainloop):
                  movaps   (%eax), %xmm1     # load 32 bytes
                  movaps 16(%eax), %xmm2
                  add      $32,    %eax      # advanve address
                  pcmpeqb  %xmm0,  %xmm1     # locate '\0'
                  pcmpeqb  %xmm0,  %xmm2
                  por      %xmm1,  %xmm2     # join result
                  pmovmskb %xmm2,  %edx      # ... and create bitmask
                  test     %edx,   %edx      # is '\0' in 32-byte chunk?
                  jz       L(mainloop)

         # get length
         pmovmskb %xmm1,  %ecx
         test     %ecx,   %ecx
         jz       L(result16)
         L(result32):
                  bsf %ecx, %ecx
                  mov 4(%esp), %edx
                  lea -32(%eax, %ecx), %eax
                  sub %edx, %eax
                  ret
         L(result16):
                  bsf %edx, %edx
                  mov 4(%esp), %ecx
                  lea -16(%eax, %edx), %eax
                  sub %ecx, %eax
                  ret

#undef L
#define L(name) .L_unsafe##name

.global sse2_strlen_unsafe
.type   sse2_strlen_unsafe, @function
.align  32
sse2_strlen_unsafe:
         mov    4(%esp),  %eax      # get address
         pxor     %xmm0,  %xmm0     # xmm0 := packed_byte(0x00)

         .align 16
         L(mainloop):
                  movaps   (%eax), %xmm1     # load 32 bytes
                  movaps 16(%eax), %xmm2
                  add      $32,    %eax      # advanve address
                  pcmpeqb  %xmm0,  %xmm1     # locate '\0'
                  pcmpeqb  %xmm0,  %xmm2
                  por      %xmm1,  %xmm2     # join result
                  pmovmskb %xmm2,  %edx      # ... and create bitmask
                  test     %edx,   %edx      # is '\0' in 32-byte chunk?
                  jz       L(mainloop)

         # get length
         pmovmskb %xmm1,  %ecx
         test     %ecx,   %ecx
         jz       L(result16)
         L(result32):
                  bsf %ecx, %ecx
                  mov 4(%esp), %edx
                  lea -32(%eax, %ecx), %eax
                  sub %edx, %eax
                  ret
         L(result16):
                  bsf %edx, %edx
                  mov 4(%esp), %ecx
                  lea -16(%eax, %edx), %eax
                  sub %ecx, %eax
                  ret


# vim: ts=9 nowrap et
