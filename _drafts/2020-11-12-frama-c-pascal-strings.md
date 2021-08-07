---
layout: post
title: Verifying Pascal Strings with Frama-C
published: false
draft: true
quote: "What has been said may also be expressed by saying that reason is purposive activity."
quoteSource: GWF Hegel, <i>Science of Logic</i> &sect;22 (1807)
tags: [C, Frama-C]
---

Initially, I wanted to learn if there were Hoare triples for ANSI C.
This led me down a rabbit hole, from separation logic to the ANSI C
Specification Language (ACSL) to Frama-C. But the tutorials for Frama-C
have been rather limited.

What I mean is, I learned to program C using a modular style similar to
[Phil's Guide to OO
ANSI-C](http://www.bolthole.com/OO-C-programming.html) or what's found
in David Hanson's _C Interfaces and Implementations_ (1996): define some `struct Foo`, have a
"constructor" function which invokes `malloc()`, a "destructor" invoking
`free()`, a bunch of accessor functions, mutator functions, etc.
So, uh, what's the Hoare triple for `malloc()`? And how, in Heaven's
name, do I work this damn Frama-C thing?

I'd like to work through the iterative process that worked for me. A
small toy-problem to work on: implementing a "Pascal String" data
structure in C.

# Basic Implementation

The only functions we'll implement (at least, to start) are the
constructor and destructor. The header declares them succinctly:

```c
// pascal_str.h
#ifndef PASCAL_STR_H
#define PASCAL_STR_H

struct PascalString {
    size_t length;
    char *buffer;
};

struct PascalString* PascalString_new(const char *str);
void PascalString_free(struct PascalString *str);

#endif /* PASCAL_STR_H */
```

I know it's bad style to not use opaque structs, i.e., I should have
instead written `typedef struct PascalString PString;` then in the C
file plopped the definition of the `struct PascalString`. But I feel
this is more pedagogical to place the struct definition in the header.

The constructor simply allocates the struct and the space to copy the
string argument passed to it.

```c
/* pascal_string.c */
#include <stdlib.h>
#include <string.h>

struct PascalString*
PascalString_new(const char *str) {
    /* danger: what about if malloc() returns NULL? */
    struct PascalString* pstr = malloc(sizeof(*pstr));
    /* if (NULL == pstr) return pstr; */

    size_t string_length = strlen(str);
    pstr->length = string_length;

    /* danger repeated: what about if malloc() returns NULL? */
    pstr->buf = malloc(string_length + 1);
    /* if (NULL == pstr->buf) free(pstr); else */
    strncpy(pstr->buf, str, string_length);

    return pstr;
}
```

This code already is quite cavalier: what happens if one of the
`malloc()` calls fails?

**Remark.** Linux can overcommit on memory, making `malloc()` "never fail".
Really, this just makes the function fail unexpectedly and in surprising
ways. See, e.g., [`malloc()` never fails, it just...explodes?](https://comp.lang.c.narkive.com/dOyy3O94/malloc-never-fails-it-just-explodes)
and [`malloc` never fails](https://scvalex.net/posts/6/). (End of Remark)

Since this allocates the buffer for a copy of the string, we need to
free it upon destruction.

```c
/* pascal_string.c (continued) */

void
PascalString_free(struct PascalString *pstr) {
    if (NULL == pstr) return;

    if (NULL != pstr->buf) {
        free(pstr->buf);
        pstr->buf = NULL;
    }

    free(pstr);
    pstr = NULL;
}
```

Nothing terribly fancy or complicated. We will get more complicated
later, but this suffices already.

# Frama-C

I'm using Frama-C 21.1 (Scandium) on Windows via the Linux Subsystem.
If we just try running in the console `$ frama-c -wp pascal_string.c`
(which runs the weakest precondition plugin for Frama-C on
`pascal_string.c`), we find surprisingly:

```
alex@PC:/mnt/c/src/PascalString$ frama-c -wp pascal_string.c
[kernel] Parsing pascal_string.c (with preprocessing)
[wp] Warning: Missing RTE guards
[wp] pascal_string.c:14: Warning:
  Cast with incompatible pointers types (source: __anonstruct_PascalString_1*)
     (target: sint8*)
[wp] FRAMAC_SHARE/libc/stdlib.h:405: Warning:
  Allocation, initialization and danglingness not yet implemented
  (\freeable(p))
[wp] FRAMAC_SHARE/libc/stdlib.h:411: Warning:
  Allocation, initialization and danglingness not yet implemented
  (freed: \allocable(\at(p,wp:pre)))
[wp] FRAMAC_SHARE/libc/__fc_string_axiomatic.h:284: Warning:
  Allocation, initialization and danglingness not yet implemented
  (\initialized{L}(s + (0 .. n - 1)))
[wp] FRAMAC_SHARE/libc/string.h:370: Warning:
  Allocation, initialization and danglingness not yet implemented
  (initialization: \initialized(\at(dest,wp:pre) + (0 .. \at(n,wp:pre) - 1)))
[wp] FRAMAC_SHARE/libc/stdlib.h:394: Warning:
  Allocation, initialization and danglingness not yet implemented
  (allocation: \fresh{Old, Here}(\at(\result,wp:post),\at(size,wp:pre)))
[wp] pascal_string.c:6: Warning:
  Cast with incompatible pointers types (source: sint8*)
     (target: __anonstruct_PascalString_1*)
[wp] pascal_string.c:31: Warning:
  Cast with incompatible pointers types (source: __anonstruct_PascalString_1*)
     (target: sint8*)
[wp] 2 goals scheduled
[wp] [Alt-Ergo 2.3.3] Goal typed_PascalString_free_call_free_2_requires_freeable : Failed
  Unknown error (Degenerated, 4 warnings)
[wp] [Alt-Ergo 2.3.3] Goal typed_PascalString_free_call_free_requires_freeable : Failed
  Unknown error (Degenerated)
[wp] Proved goals:    0 / 2
  Alt-Ergo 2.3.3:    0  (failed: 2)
alex@PC:/mnt/c/src/PascalString$
```

Apparently there are 2 goals, but we failed to satisfy either of them.
We need to run `frama-c-gui` to find out what they were, which saddens
me (I usually program on a laptop with no gui). We find
`PascalString_free()` has unsatisfied preconditions of `free()`. Namely,

```c
/* preconditions of free:
   requires freeable: (void *)ptr == \null || \freeable((void*)ptr);
 */
free(ptr);
```

What is `\freeable(ptr)` supposed to mean? Well, it means two conditions
are true:
1. `ptr` points to a dynamically allocated block of memory (i.e., a
   block created by `malloc()` or `calloc()` or something similar), and
2. `ptr` refers to the _base address_ of that block of memory.

So, uh, what's a "block of memory"? And when would a pointer _not_ refer
to the base address of a block of memory? I _think_ a "block of memory"
refers to "whatever `calloc()`, `malloc()`, or `realloc()` produces". We
_know_ from the [specification (section 2.7.1)](https://frama-c.com/download/acsl-1.15.pdf) that
"A block is characterized by its base address, which is the address of the declared object (the first declared object in case of an array declarator) or the pointer returned by the allocating function (when the allocation succeeds), and its length."
For us, if `PascalString *pstr` is a non-null result of
`PascalString_new` where we have instead:
```c
PascalString*
PascalString_contiguousNew(const char *str) {
  size_t string_length = strlen(str);
  PascalString* pstr = malloc(sizeof(*pstr) + string_length + 1);

  pstr->buf = pstr + sizeof(*pstr);
  strncpy(pstr->buf, str, string_length);

  pstr->length = string_length;

  return pstr;
}
```
...then `pstr->buf` would point to an address that is in
the _middle_ of a block `pstr + (0 .. sizeof(*pstr) + pstr->length)`.
Again, it's unclear to me why this is _one block_ and not _two blocks_,
but I'm probably being dense.

How did `PascalString_new()` fare? Well, besides similar unsatisfied
preconditions for `free()`, we have an additional set of preconditions
for `strncpy()`. In general:

```c
/* preconditions of strncpy:
requires valid_nstring_src: valid_read_nstring(src, length);
requires room_nstring: \valid(dest + (0 .. length - 1));
requires separation:
  \separated(dest + (0 .. length - 1), src + (0 .. length - 1));
 */
strncpy(dest, src, length);
```

## Checking for RTE (Run Time Errors)

We can ask Frama-C to insert checks for run-time errors (by adding the
`-wp-rte` flag). This changes the situation slightly, now there are 5
goals to prove, but we have 1 succeed automatically.

The new preconditions result in the following annotated source code for
`PascalString_new()`:

```c
PascalString *PascalString_new(char const *str)
{
  PascalString *tmp_0;
  PascalString *pstr = malloc(sizeof(*tmp_0));
  if ((PascalString *)0 != pstr) {
    /* preconditions of strlen:
       requires valid_string_s: valid_read_string(str); */
    size_t length = strlen(str);
    /*@ assert rte: mem_access: \valid(&pstr->length); */
    pstr->length = length;
    /*@ assert rte: mem_access: \valid(&pstr->buf); */
    pstr->buf = (char *)malloc((length + (size_t)1) * sizeof(char));
    /*@ assert rte: mem_access: \valid_read(&pstr->buf); */
    if ((char *)0 == pstr->buf) {
      /* preconditions of free:
         requires
           freeable: (void *)pstr == \null ∨ \freeable((void *)pstr); */
      free((void *)pstr);
      pstr = (PascalString *)0;
    }
    else {
      /* preconditions of strncpy:
         requires valid_nstring_src: valid_read_nstring(str, length);
         requires room_nstring: \valid(pstr->buf + (0 .. length - 1));
         requires
           separation:
             \separated(
               pstr->buf + (0 .. length - 1), str + (0 .. length - 1)
               ); */
      /*@ assert rte: mem_access: \valid_read(&pstr->buf); */
      strncpy(pstr->buf,str,length);
    }
  }
  return pstr;
}
```

The `assert rte: ...` comments are run-time exception checks (inserted
thanks to `-wp-rte`). The only precondition that seems ambiguous is
`valid_read_string`. What in heaven's name is _that_ supposed to be?

Its an internal predicate provided by Frama-C in its
[`__fc_string_axiomatic.h`](https://git.frama-c.com/pub/frama-c/-/blob/9abcd5658a298d7202883ec935dc475130a8c49a/share/libc/__fc_string_axiomatic.h#L280-281)
header. The predicate is defined as:

```c
/*@ //...
  @
  @ predicate valid_read_string{L}(char *s) =
  @   0 <= strlen(s) && \valid_read(s+(0..strlen(s)));
  @
  @ // ...
  @*/
```
