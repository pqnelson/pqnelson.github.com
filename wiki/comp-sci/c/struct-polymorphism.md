---
layout: wiki
title: Struct Polymorphism
published: true
date: 2021-02-14
parentURL: /wiki/comp-sci/c
---

If we want to implement an interpreter (for example), and we want some
kind of "object model" where everything is an `struct Object*`, then we
need some way to emulate polymorphism.

For the sake of simplicity, our simple emulator has `struct Cons` cells
(pairs of pointers to objects), and `struct Int` for integer values.

# Approach 1: Naive

One approach is to make the layout of the structs begin the same way as
the `struct Object`:

```c
enum ObjectType {
    TYPE_CONS,
    TYPE_INT
};

struct Object {
    enum ObjectType type;
};

struct Cons {
    enum ObjectType type;
    struct Object *car, *cdr;
};

struct Int {
    enum ObjectType type;
    int value;
};
```

Given a pointer to an Int object, which is just the address of the start
of the object, we could re-interpret it as a pointer to an Object struct
in memory.

## Breaks with Pragma Pack

The only problem is if this is if some of the structs are pragma packed
whereas other structs are not...for example, if `struct Object` is
packed and not neatly aligned, but neither `struct Cons` nor `struct Int`
are:

```c

enum ObjectType {
    TYPE_CONS,
    TYPE_INT
};

enum {
    GC_WHITE = 0,
    GC_BLACK = 1,
    GC_GREY = 2
}

#pragma pack(1)
struct Object {
    enum ObjectType type;
    int mark : 2;
};

#pragma pack()
struct Cons {
    enum ObjectType type;
    int mark : 2;
    struct Object *car, *cdr;
};

struct Int {
    enum ObjectType type;
    int mark : 2;
    int value;
};
```

Adding a bit-field for tri-color marking in garbage collection messes
everything up. Of course, to me, this seems kind of contrived, but I
could imagine writing an emulator where we have no choice in the bit
layout for some objects.

# Approach 2: Object headers

The next approach is to use an "object header" field in the `struct Int`
and `struct Cons` declarations:

```c
enum ObjectType {
    TYPE_CONS,
    TYPE_INT
};

struct Object {
    enum ObjectType type;
};

struct Cons {
    struct Object header;
    struct Object *car, *cdr;
};

struct Int {
    struct Object header;
    int value;
};
```

The memory layout, conceptually, could be drawn diagrammatically as:

![Memory layout of struct polymorphism](/assets/memory-1.svg)

We can cast a `struct Cons` pointer as a pointer to a `struct Object`,
which would point to the start of the `header` field of the Cons object.
This works in C99 and up, because [the standard states](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf):

> § 6.7.2.1, par. 13
>
> Within a structure object, the non-bit-field members and the units in
> which bit-fields reside have addresses that increase in the order in
> which they are declared. A pointer to a structure object, suitably
> converted, points to its initial member (or if that member is a
> bit-field, then to the unit in which it resides), and vice versa.
> There may be unnamed padding within a structure object, but not at its
> beginning.

(This also holds in C89, see § 3.5.2.1, paragraph 7 or so.) Unlike the
first approach, this is portable and standards-compliant.

But we can go the other way, downcasting a pointer to an Object in
memory to a pointer to a Cons (assuming the pointer really points to a
Cons in memory). This interprets the ensuing bytes as fields of the Cons
object.

## Aside on History of Terminology

The notion of an "object header" may be traced back as far as the '80s
in Lisp Machines, which used the notion to describe the memory layout of
stuff in memory. It's a mistake to think it stems from Java, or some
other object-oriented language from the '90s or naughts. For one
reference, see the internal Symbolics
[documentation](http://www.bitsavers.org/pdf/symbolics/I_Machine/I-Machine%20Architecture%20Specification.pdf)
about the architecture of the I-machine, just for one citation.

# Approach 3: Use C11

Using C11, we can use anonymous structs as the first member of the
struct. The memory layout looks like the results from approach 2, but we
can access the fields of the anonymous struct directly.

```c
enum ObjectType {
    TYPE_CONS,
    TYPE_INT
};

enum {
    MARK_WHITE = 0,
    MARK_BLACK,
    MARK_GREY
};

struct Object {
    enum ObjectType type;
    int mark : 2;
};

struct Cons {
    struct Object;
    struct Object *car, *cdr;
};

struct Int {
    struct Object;
    int value;
};

bool int_is_marked(struct Int *integer) {
    if (NULL == integer) return false;
    return MARK_WHITE != integer->mark;
}
```

The only disadvantage is that C11 is not as universally supported among
compilers, which may be a concern if portability is a goal.