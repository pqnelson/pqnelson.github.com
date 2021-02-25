---
layout: wiki
title: Malloc - Separation Logic
published: true
date: 2021-02-14
parentURL: /wiki/comp-sci/separation-logic/
---

The [POSIX spec for `malloc()`](https://pubs.opengroup.org/onlinepubs/9699919799/functions/malloc.html)
tells us its signature is `void *malloc(size_t size)` and has
implementation-dependent behaviour when `size = 0`. We could offer a
simple, standardized, wrapper around it:

```c
/*@ behavior zero_requested:
  @   assumes size == 0;
  @   ensures \result == \null;
  @ behavior cannot_allocate_request:
  @   assumes nonzero: size > 0;
  @   assumes cannot_allocate: !is_allocable(size);
  @   exits \exit_status != EXIT_SUCCESS;
  @ behavior default:
  @   assumes default_nonzero: size > 0;
  @   assumes can_allocate: is_allocable(size);
  @   ensures allocation: \fresh(\result, size);
  @ complete behaviors;
  @ disjoint behaviors;
  @*/
void* alloc(size_t size) {
    void *result = NULL;
    if (size == 0) {
        //@ assert \null == result;
    } else {
        result = malloc(size);
        //@ assert (result == \null) || (\fresh(\result, size));
        if (NULL == result) {
            abort();
            //@ assert exits \exit_status != EXIT_SUCCESS;
        }
        //@ assert \fresh(\result, size);
    }
    return result;
}
```

We borrow the contract for [`abort()`](https://github.com/Frama-C/Frama-C-snapshot/blob/20.0/share/libc/stdlib.h#L457-L462)
and [`malloc()`](https://github.com/Frama-C/Frama-C-snapshot/blob/20.0/share/libc/stdlib.h#L387-L403).
