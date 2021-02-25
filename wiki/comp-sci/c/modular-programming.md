---
layout: wiki
title: Modular Programming in C
published: true
date: 2021-02-14
parentURL: /wiki/comp-sci/c/
---

The basic idea is, when we want to create a new "class", we create the
interface first in the header.

```c
/* foo.h */
#ifndef FOO_H /* header guards */
#define FOO_H /* to avoid loading the header twice */

typedef struct Foo Foo; /* opaque pointer declaration */

Foo* foo_new(int id, char *name);
void foo_free(Foo *foo);
void foo_print(Foo *foo, FILE *stream);
/* other "methods" declared here */

#endif /* FOO_H */
```

Any documentation should be in the header, and programmers who want to
use the data structure should be able to do so referring only to the
header file.

The implementation is "private", hidden away to a `.c` file. The
declaration of the structure is placed there as well:

```c
/* foo.c */
#include <stdlib.h>
#include <string.h>
#include "foo.h"

struct Foo {
    int id;
    char *name;
    size_t name_length;
};
```

# Boilerplate Functions that should be provided

The bare minimum necessary functions are a constructor function (for
allocating new objects), and destructor functions (for freeing up
memory).

The nice-to-have functions include testing for equality (since `==`
tests for pointer equality), printing an object to a stream, possibly a
hashing function.

## Constructor/Factory

Depending on one's perspective, we have a constructor or a factory
function, and this is the only way to create new `Foo` objects.

```c
/* foo.c */
Foo* foo_new(int id, char *name) {
    Foo *foo = malloc(sizeof(*foo));
    if (NULL == foo) { /* malloc() failed */
        abort();
    }
    foo->id = id;
    foo->name_length = strlen(name);
    foo->name = malloc(1 + foo->name_length);
    if (NULL == foo->name) { /* malloc() failed */
        free(foo);
        abort();
    }
    memcpy(foo->name, name, foo->name_length);
    return foo;
}
```

We need to be careful to handle memory allocation failures, although
rare on modern computers. Well, we should also be careful to avoid
`malloc(0)` because it is implementation dependent and unintuitive ---
instead we should check the `foo->name_length` is positive, and in the
case when it is zero simply assign `NULL` to `foo->name`.

## Destructor

Dual to constructing new objects, we need to free them from memory.

```c
/* foo.c */

void foo_free(Foo *foo) {
    if (NULL == foo) return;

    if (NULL != foo->name) free(foo->name);
    free(foo);
}
```

We may be tempted to set the pointer to `NULL`, but it won't propagate.
Instead, we'd need to pass a _reference_ to the pointer to the `Foo`
object in memory. So we could do this as follows:

```c
/* foo.c */

void foo_free(Foo **foo) {
    if ((NULL == foo) || (NULL == *foo)) return;

    if (NULL != (*foo)->name) free((*foo)->name);
    free(*foo);
    *foo = NULL;
}
```

This requires a bit more work, and updates one single pointer to the
object in memory (not all pointers pointing to that object in memory).
If we want to propagate out freeing an object from memory, we'd need to
use double pointers.