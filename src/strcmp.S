/*
 *  SSE2 string routines library
 *  implementation of strcmp
 *
 *  $Revision: 1.5 $, $Date: 2007-08-28 20:36:06 $
 *
 *  Author: Wojciech Mu³a
 *  e-mail: wojciech_mula@poczta.onet.pl
 *  project page: http://www.republika.pl/wmula/sse_str/
 *
 *  License: BSD
 */

.text

.macro  COMPARE16 load     # compare 16 bytes
         # load = {movaps, movups}
         \load    (%esi),  %xmm0
         \load    (%edi),  %xmm1
         add      $16,     %esi
         add      $16,     %edi

         pcmpeqb  %xmm0,   %xmm1    # equal chars
         pcmpeqb  %xmm7,   %xmm0    # null byte(s)
         pandn    %xmm1,   %xmm0    # 0x00 at pos. of null(s)/char(s)
         pmovmskb %xmm0,   %eax
         xor $0x0000ffff,  %eax
.endm


.macro   COMPARE32 load    # compare 32 bytes
         # load = {movaps, movups}
         \load    (%esi),  %xmm0
         \load  16(%esi),  %xmm2
         \load    (%edi),  %xmm1
         \load  16(%edi),  %xmm3
         add      $32,     %esi
         add      $32,     %edi

         pcmpeqb  %xmm0,   %xmm1    # equal chars
         pcmpeqb  %xmm2,   %xmm3
         pcmpeqb  %xmm7,   %xmm0    # null bytes
         pcmpeqb  %xmm7,   %xmm2
         pandn    %xmm1,   %xmm0    # join results
         pandn    %xmm3,   %xmm2
         pand     %xmm0,   %xmm2

         pmovmskb %xmm2,   %eax     # result -> bitmask
         xor $0x0000ffff,  %eax
.endm

/*
In order to handle unaligned addresses and prevent from read
above process address space function have to p

Offset on a page, i.e. the lowest 12 bits of addresses, is considered:

	+-----------+-----------+---------+---------+
	|      \ s1 | unaligned | 16-byte | 32-byte |
	|     s2 \  |           |         |         |
	+-----------+-----------+---------+---------+
	| unaligned |     A     |    B    |    C    |
	+-----------+-----------+---------+---------+
	|   16-byte |     D     |    E    |    F    |
	+-----------+-----------+---------+---------+
	|   32-byte |     G     |    H    |    I    |
	+-----------+-----------+---------+---------+

Function handle several cases:

1. L_aligned32_32 (case I): 
   both offsets at 32-byte boundary

2. L_aligned16_32 (cases F, H):
   one offset at 16-byte boundary, another at 32-byte boundary

3. L_aligned16_16 (case E):
   both offsets at 16-byte boundary -- we process just one 16-byte
   chunk, then offsets are aligned at 32-byte boundary, and thus
   case I is reached

4. L_offsets_equal:
   both offsets are unaligned or aligned at 16-byte boundary,
   but equal -- we can proces unaligned bytes, then case E is
   reached, and finally case I is processed

5. L_unaligned (cases A, B, C, D, G):
   one or both offsets are unaligned
*/


.global sse2_strcmp
.type   sse2_strcmp, @function
.align  32
sse2_strcmp:
         pxor     %xmm7,   %xmm7

         # load s1 (%esi) and s2 (%edi)
         mov      %esi,    %eax
         mov      %edi,    %ecx
         mov      4(%esp), %esi
         mov      8(%esp), %edi
         push     %eax
         push     %ecx

         test     $0x1f,   %esi
         jnz      .L_tests
         test     $0x1f,   %edi
         jnz      .L_tests
    
    # both offsets at 32-byte boundary
    .L_aligned32_32:
         COMPARE32 movaps
         jz  .L_aligned32_32
         jmp .L_result32

    # choose proper case
    .L_tests:
         mov      %esi,    %ecx
         mov      %edi,    %edx
         and      $0xfff,  %ecx
         and      $0xfff,  %edx
         cmp      %ecx,    %edx
         je       .L_offsets_equal

         test     $0xf,    %esi
         jnz      .L_unaligned
         test     $0xf,    %edi
         jz       .L_aligned16_32

    # one or both offsets unaligned
    .L_unaligned:
         mov      %esi,    %ecx
         mov      %edi,    %edx
         and      $0xfff,  %ecx     # get offsets
         and      $0xfff,  %edx  
         cmp      %edx,    %ecx
         cmovb    %edx,    %ecx     # ecx - max offset

         xor      $0xfff,  %ecx     # ecx := 4096 - ecx
         add      $1,      %ecx     # ... i.e. offset to end of page

         .L_process_1:
                  test     $0x00f,  %ecx
                  jz       .L_process_16a
                  sub      $1,      %ecx

                  mov      (%esi),  %al
                  add      $1,      %edi
                  add      $1,      %esi
                  cmp    -1(%edi),  %al
                  jne      .L_result_1
                  test     %al,     %al
                  jnz      .L_process_1
                  .L_result_1:
                          movzx -1(%edi),    %edx
                          movzx -1(%esi),    %eax
                          sub       %edx,    %eax
                          pop       %edi
                          pop       %esi
                          ret

         .L_process_16a:
                  test     $0x010,  %ecx
                  jz       .L_process_32a
                  sub      $0x10,   %ecx

                  COMPARE16 movups
                  jnz      .L_result16
         .L_process_32a:
                  test     $0xfe0,  %ecx
                  jz       .L_unaligned
                  sub      $0x020,  %ecx

                  COMPARE32 movups
                  jz       .L_process_32a
                  jmp      .L_result32

    # one offset at 16-byte, another at 32-byte boundary
    .L_aligned16_32:
         mov      %esi,    %ecx
         mov      %edi,    %edx
         and      $0xff0,  %ecx     # get offsets
         and      $0xff0,  %edx  
         cmp      %edx,    %ecx
         cmovb    %edx,    %ecx     # ecx - max offset

         xor      $0xff0,  %ecx     # ecx := 4096 - ecx
         add      $1,      %ecx     # ... i.e. offset to end of page

         .L_process_16b:
                  test     $0x010,  %ecx
                  jz       .L_process_32b
                  sub      $0x10,   %ecx

                  COMPARE16 movaps
                  jnz      .L_result16
         .L_process_32b:
                  test     $0xfe0,  %ecx
                  jz       .L_unaligned
                  sub      $0x20,   %ecx

                  COMPARE32 movaps
                  jz       .L_process_32b
                  jmp      .L_result32

    .L_offsets_equal:
         and      $0xf,    %ecx     # really unaligned?
         jz       .L_aligned16_16   # ... no, both aligned at 16-byte

         and      $0xfffffff0, %esi # ... yes, so align both addresses
         and      $0xfffffff0, %edi
         mov      $0xffffffff, %edx # ... and create bitmask
         btr      %ecx,    %edx
         add      $1,      %edx

         COMPARE16 movups
         and      %edx,    %eax     # mask result
         jnz      .L_result16
    
    # both offsets at 16-byte boundary
    .L_aligned16_16:
         COMPARE16 movaps
         jnz      .L_result16
         jmp      .L_aligned32_32

    
    # results
    .L_result32:  # result from COMPARE32 (unrolled loop)
         pmovmskb %xmm0,   %ecx
         xor $0x0000ffff,  %ecx
         jz       .L_result16
         bsf      %ecx,    %eax
         movzbl -32(%edi, %eax), %edx
         movzbl -32(%esi, %eax), %eax
         sub      %edx,    %eax
         pop      %edi
         pop      %esi
         ret
    .L_result16:  # result from COMPARE16
         bsf      %eax,    %eax
         movzbl -16(%edi, %eax), %edx
         movzbl -16(%esi, %eax), %eax
         sub      %edx,    %eax
    .L_end:
         pop      %edi
         pop      %esi
         ret


# vim: ts=9 nowrap et
