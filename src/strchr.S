/*
 *  SSE2 string routines library
 *  implementation of strchr
 *
 *  $Revision: 1.9 $, $Date: 2007-08-30 20:56:33 $
 *
 *  Author: Wojciech Mu³a
 *  e-mail: wojciech_mula@poczta.onet.pl
 *  project page: http://www.republika.pl/wmula/sse_str/
 *
 *  License: BSD
 */

.text

.macro FIND_POSITION16 # locate null bytes or chars in a sequence of 16 bytes
         movaps   (%eax),  %xmm2    # load 16 chars
         add      $16,     %eax
         movaps   %xmm2,   %xmm3    # copy them, then
         pcmpeqb  %xmm0,   %xmm2    # ... find null byte(s)
         pcmpeqb  %xmm1,   %xmm3    # ... find char(s)
         por      %xmm2,   %xmm3    # ... join results,
         pmovmskb %xmm3,   %edx     # and finally return a bitmask
.endm

.global sse2_strchr
.type   sse2_strchr, @function
.align  32
sse2_strchr:
         pxor     %xmm0,   %xmm0    # xmm0 := packed_byte(0x00)

         # xmm1 := packed_byte(char)
#ifdef SSESTR_IMUL_POPULATE
         movzbl   8(%esp),     %eax
         imul     $0x01010101, %eax
         movd     %eax,    %xmm1
         pshufd   $0x00,   %xmm1, %xmm1
#else
#ifdef SSESTR_SSE3_POPULATE
         movd     8(%esp), %xmm1
         pshufb   %xmm0,   %xmm1
#else /* straightforward method to populate byte */
         movzbl   8(%esp), %eax
         mov      %al,     %ah
         mov      %eax,    %ecx
         shl      $16,     %ecx
         or       %ecx,    %eax
         movd     %eax,    %xmm1
         pshufd   $0x00,   %xmm1, %xmm1
#endif // SSESTR_SSE3_POPULATE
#endif // SSESTR_IMUL_POPULATE

         mov      4(%esp), %eax     # load address
         test     $0xf,    %eax     # is address aligned at 16-byte boundary?
         jz       .L_aligned16

         .L_unaligned:
                  mov      %eax,   %edx
                  mov      $-1,    %ecx      # ecx := 0xffffffff
                  and      $~0xf,  %eax      # align address at 16-boundary
                  and      $0xf,   %edx      # ebx := bytes before
                  btr      %edx,   %ecx      #        ... string's beginning
                  add      $1,     %ecx      # ecx := mask

                  FIND_POSITION16            # locate \0 or char
                  and      %ecx,   %edx      # mask result
                  jnz .L_result16

         .L_aligned16:
         # is address aligned at 32-byte boundary?
         test $0x10,  %eax
         jz   .L_mainloop

                  FIND_POSITION16            # locate \0 or char
                  test     %edx,    %edx
                  jnz      .L_result16


         .align 16
         .L_mainloop:
                  movaps   (%eax),  %xmm2    # load 32 chars
                  movaps 16(%eax),  %xmm3
                  add      $32,     %eax
                  movaps   %xmm2,   %xmm4    # copy them
                  movaps   %xmm3,   %xmm5
                  pcmpeqb  %xmm0,   %xmm2    # locate \0 bytes
                  pcmpeqb  %xmm0,   %xmm3
                  pcmpeqb  %xmm1,   %xmm4    # locate chars
                  pcmpeqb  %xmm1,   %xmm5
                  por      %xmm4,   %xmm2    # join result
                  por      %xmm5,   %xmm3
                  por      %xmm2,   %xmm3
                  pmovmskb %xmm3,   %edx     # and get bitmask
                  test     %edx,    %edx
                  jz       .L_mainloop

         # return result
         pmovmskb %xmm2,  %ecx
         test     %ecx,   %ecx
         jz       .L_result16
         .L_result32:
                  bsf    %ecx, %ecx
                  lea    -32(%eax, %ecx), %edx   # address of byte \0 or char
                  xor    %eax, %eax              # eax := NULL
                  cmpb   $0x00, (%edx)           # 
                  cmovne %edx, %eax              # eax := address (if char)
                  ret
         .L_result16:
                  bsf    %edx, %edx
                  lea    -16(%eax, %edx), %edx
                  xor    %eax, %eax
                  cmpb   $0x00, (%edx)
                  cmovne %edx, %eax
                  ret



.global sse2_strchr_unsafe
.type   sse2_strchr_unsafe, @function
.align  32
sse2_strchr_unsafe:
         pxor     %xmm0,   %xmm0    # xmm0 := packed_byte(0x00)

         # xmm1 := packed_byte(char)
#ifdef SSESTR_IMUL_POPULATE
         movzbl   8(%esp),     %eax
         imul     $0x01010101, %eax
         movd     %eax,    %xmm1
         pshufd   $0x00,   %xmm1, %xmm1
#else
#ifdef SSESTR_SSE3_POPULATE
         movd     8(%esp), %xmm1
         pshufb   %xmm0,   %xmm1
#else /* straightforward method to populate byte */
         movzbl   8(%esp), %eax
         mov      %al,     %ah
         mov      %eax,    %ecx
         shl      $16,     %ecx
         or       %ecx,    %eax
         movd     %eax,    %xmm1
         pshufd   $0x00,   %xmm1, %xmm1
#endif // SSESTR_SSE3_POPULATE
#endif // SSESTR_IMUL_POPULATE

         mov      4(%esp), %eax     # load address
         .align 16
         .L_mainloop:
                  movaps   (%eax),  %xmm2    # load 32 chars
                  movaps 16(%eax),  %xmm3
                  add      $32,     %eax
                  movaps   %xmm2,   %xmm4    # copy them
                  movaps   %xmm3,   %xmm5
                  pcmpeqb  %xmm0,   %xmm2    # locate \0 bytes
                  pcmpeqb  %xmm0,   %xmm3
                  pcmpeqb  %xmm1,   %xmm4    # locate chars
                  pcmpeqb  %xmm1,   %xmm5
                  por      %xmm4,   %xmm2    # join result
                  por      %xmm5,   %xmm3
                  por      %xmm2,   %xmm3
                  pmovmskb %xmm3,   %edx     # and get bitmask
                  test     %edx,    %edx
                  jz       .L_mainloop

         # return result
         pmovmskb %xmm2,  %ecx
         test     %ecx,   %ecx
         jz       .L_result16
         .L_result32:
                  bsf    %ecx, %ecx
                  lea    -32(%eax, %ecx), %edx   # address of byte \0 or char
                  xor    %eax, %eax              # eax := NULL
                  cmpb   $0x00, (%edx)           # 
                  cmovne %edx, %eax              # eax := address (if char)
                  ret
         .L_result16:
                  bsf    %edx, %edx
                  lea    -16(%eax, %edx), %edx
                  xor    %eax, %eax
                  cmpb   $0x00, (%edx)
                  cmovne %edx, %eax
                  ret


# vim: et ts=9
