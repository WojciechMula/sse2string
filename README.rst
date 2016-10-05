================================================================================
            String functions implemented with SSE2 instructions
================================================================================

Some functions from ``string.h`` implemented using SSE2 instructions.

Following functions are available: ``strlen``, ``strchr``, ``strrchr``,
``strcmp``.  There are also unsafe counterparts, including ``strncmp``.
Unsafe variants assume aligned pointers and do not care about possible
read outside the process' address space.

Full description in Polish: http://0x80.pl/proj/sse2string/index.html
(Google translate does pretty good translation into English.)
