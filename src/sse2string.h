/*
 *  SSE2 string routines library
 *  header file
 *
 *  $Revision: 1.1 $, $Date: 2007-08-28 20:31:31 $
 *
 *  Author: Wojciech Mu³a
 *  e-mail: wojciech_mula@poczta.onet.pl
 *  project page: http://www.republika.pl/wmula/sse_str/
 *
 *  License: BSD
 */
#ifndef __SSESTR_H_INCLUDED
#define __SSESTR_H_INCLUDED

#ifdef __pure__
#	undef __pure__
#endif

#ifdef __GNUC__
#	define __pure__ __attribute__((pure))
#else
#	define __pure__
#endif

#include <stddef.h>

/* string.h replacement */
extern size_t	sse2_strlen(const char* s) __pure__;
extern char*	sse2_strchr(const char* s, int c) __pure__;
extern char*	sse2_strrchr(const char* s, int c) __pure__;
extern int	sse2_strcmp(const char* s1, const char* s2) __pure__;


/* unsafe string.h functions, i.e. assert aligned pointers and
   do not prevent reads beyond program's address space */
extern int	sse2_strncmp_unsafe(const char* s1, const char* s1, size_t n) __pure__;

#endif
