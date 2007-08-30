/*
 *  SSE2 string routines library
 *  implementation of strrchr, strrchr_unsafe
 *
 *  $Revision: 1.6 $, $Date: 2007-08-30 21:18:41 $
 *
 *  Author: Wojciech Mu³a
 *  e-mail: wojciech_mula@poczta.onet.pl
 *  project page: http://www.republika.pl/wmula/sse2string/
 *
 *  License: BSD
 */

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

#define L(name) .L_##name

.global sse2_strrchr
.type   sse2_strrchr, @function
.align  32
sse2_strrchr:
         # %eax - address, # %edx - char
         pxor     %xmm7,   %xmm7      # xmm7 := packed_byte(0x00)

         # populate char, i.e. xmm6 := pakced_byte(al)
#ifdef SSESTR_IMUL_POPULATE
         movzx  8(%esp),   %eax     # load char
         imul $0x01010101, %eax, %eax
         movd     %eax,    %xmm6
         pshufd   $0x00,   %xmm6, %xmm6
#else
#ifdef SSESTR_SSE3_POPULATE
         movd   8(%esp),   %xmm6    # load char
         pshufb   %xmm7,   %xmm6
#else
         movzbl 8(%esp),   %eax     # load char
         mov      %al,     %ah
         mov      %eax,    %edx
         shl      $16,     %edx
         or       %edx,    %eax
         movd     %eax,    %xmm6
         pshufd   $0x00,   %xmm6, %xmm6
#endif /* SSESTR_SSE3_POPULATE */
#endif /* SSESTR_IMUL_POPULATE */

         mov     4(%esp),  %eax     # load address
         push     %ebx              # save ebx, esi, edi
         push     %esi
         push     %edi
         xor      %edi,    %edi

         test     $0xf,    %eax     # is address aligned at 16-byte boundary?
         jz       L(aligned)

    L(unaligned):
         mov      %eax,    %edx
         and      $~0xf,   %eax     # align address

         mov      $-1,     %ebx     # bytes to mask
         and      $0xf,    %edx
         btr      %edx,    %ebx
         add      $1,      %ebx     # ebx - bitmask

         BASIC_STEP16               # find null(s)/char(s)
         and      %ebx,    %ecx     # mask char(s) positions
         and      %ebx,    %edx     # mask null(s) positions
         jnz      L(result)         # ... any nulls? exit
         test     %ecx,    %ecx     # any chars?
         jnz      L(update)         # ... update position

    .align 16
    L(aligned):
         BASIC_STEP16               # find null(s)/char(s)

         test     %edx,    %edx     # null byte?
         jnz      L(result)         # ... yes, exit

         test     %ecx,    %ecx     # char found?
         jz       L(aligned)        # ... no, continue
         L(update):
         mov      %ecx,    %edi     # ... yes, save bitmask
         mov      %eax,    %esi     # ... and base address,
         jmp      L(aligned)        # ... continue

    L(result):
         test     %ecx,    %ecx
         jz       L(return)
         bsf      %edx,    %edx     # null's position
         xor      %ebx,    %ebx
         bts      %edx,    %ebx     # mask bytes to first null occurence
         sub      $1,      %ebx
         and      %ebx,    %ecx     # any char found?
         jz       L(return)         # ... no

         bsr      %ecx,    %ecx     # ... yes, get position of last char
         lea  -16(%eax, %ecx), %eax # ... and calulcate address
         pop      %edi
         pop      %esi
         pop      %ebx
         ret
    L(return):
         xor      %eax,    %eax     # set NULL address
         test     %edi,    %edi 
         jz       L(end)
         bsr      %edi,    %edi
         lea  -16(%esi, %edi), %eax
    L(end):
         pop      %edi
         pop      %esi
         pop      %ebx
         ret


#undef L
#define L(name) .L_unsafe##name

.global sse2_strrchr_unsafe
.type   sse2_strrchr_unsafe, @function
.align  32
sse2_strrchr_unsafe:
         # %eax - address, # %edx - char
         pxor     %xmm7,   %xmm7      # xmm7 := packed_byte(0x00)

         # populate char, i.e. xmm6 := pakced_byte(al)
#ifdef SSESTR_IMUL_POPULATE
         movzx  8(%esp),   %eax     # load char
         imul $0x01010101, %eax, %eax
         movd     %eax,    %xmm6
         pshufd   $0x00,   %xmm6, %xmm6
#else
#ifdef SSESTR_SSE3_POPULATE
         movd   8(%esp),   %xmm6    # load char
         pshufb   %xmm7,   %xmm6
#else
         movzbl 8(%esp),   %eax     # load char
         mov      %al,     %ah
         mov      %eax,    %edx
         shl      $16,     %edx
         or       %edx,    %eax
         movd     %eax,    %xmm6
         pshufd   $0x00,   %xmm6, %xmm6
#endif /* SSESTR_SSE3_POPULATE */
#endif /* SSESTR_IMUL_POPULATE */

         mov     4(%esp),  %eax     # load address
         push     %ebx              # save ebx, esi, edi
         push     %esi
         push     %edi
         xor      %edi,    %edi

    .align 16
    L(aligned):
         BASIC_STEP16               # find null(s)/char(s)

         test     %edx,    %edx     # null byte?
         jnz      L(result)         # ... yes, exit

         test     %ecx,    %ecx     # char found?
         jz       L(aligned)        # ... no, continue
         L(update):
         mov      %ecx,    %edi     # ... yes, save bitmask
         mov      %eax,    %esi     # ... and base address,
         jmp      L(aligned)        # ... continue

    L(result):
         test     %ecx,    %ecx
         jz       L(return)
         bsf      %edx,    %edx     # null's position
         xor      %ebx,    %ebx
         bts      %edx,    %ebx     # mask bytes to first null occurence
         sub      $1,      %ebx
         and      %ebx,    %ecx     # any char found?
         jz       L(return)         # ... no

         bsr      %ecx,    %ecx     # ... yes, get position of last char
         lea  -16(%eax, %ecx), %eax # ... and calulcate address
         pop      %edi
         pop      %esi
         pop      %ebx
         ret
    L(return):
         xor      %eax,    %eax     # set NULL address
         test     %edi,    %edi 
         jz       L(end)
         bsr      %edi,    %edi
         lea  -16(%esi, %edi), %eax
    L(end):
         pop      %edi
         pop      %esi
         pop      %ebx
         ret

# vim: ts=9 et
