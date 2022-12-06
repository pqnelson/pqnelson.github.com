---
layout: post
title: Lisp Compiler - Parser
published: true
draft: false
quote: "The force of mind is only as great as its expression; its depth only as deep as its power to expand and lose itself."
quoteSource: G.W.F. Hegel, §10 <i>Phenomenology of Spirit</i> (1807)
tags: [Lisp]
---

- [Project Statement](#project-statement)
  - [Background, Personal Motivation](#background-personal-motivation)
- [Design of System](#design-of-system)
  - [Architecture of an Interpreter](#architecture-of-an-interpreter)
  - [An "Object Model"](#an-object-model)
- [A Minimal Lisp](#a-minimal-lisp)
- [Object Model Implementation](#object-model-implementation)
  - [Symbol](#symbol)

# Project Statement

We will write an interpreter (first a tree-walker, then a virtual
machine) for a Lisp dialect. This is a bit of an experiment in literate
programming _and_ verified programming.

Here "literate progamming" is meant more in the sense of Knuth than
JavaDoc. Although Knuth wrote when the primary concern was performance
(and literate programming allowed writing more human-friendly code), we
have adopted readable coding conventions in the past couple decades.

"Verified programming" in the sense of [Hoare logic](https://en.wikipedia.org/wiki/Hoare_logic)
or [separation logic](https://en.wikipedia.org/wiki/Separation_logic).
Since we'll be working in C, the [ACSL](https://en.wikipedia.org/wiki/ANSI/ISO_C_Specification_Language)
will help establish correctness. Since we're working in C, we'll be
missing a lot of features other languages provide. But we can organize
our code similarly (instead of classes with methods, we'll have
`struct`s with functions).

The Lisp dialect is inspired by Common Lisp. All Lisps share a similar
kernel, but Common Lisp has its own quirks. Some features worth exploring:
- Implement a simple Lisp.
- Garbage collection
- Support vectors and hashmaps
- Reader macros
- Packages
- Optimizations like NaN-boxing (or tagged pointers)
- Classes and multimethods

The virtual machine is largely inspired by the Lisp Machine. A separate
series of questions concerning the virtual machine:
- How do we design the instruction set for a virtual machine?
  Ostensibly, a Lisp Machine's "macro instructions" are the ISA, but is
  there some criteria for design discussion to be had for a virtual
  machine's ISA?
- If we start with an SECD machine (or a CEK machine), how much
  modification is necessary to get to something like a Lisp machine?

## Background, Personal Motivation

I've been learning Common Lisp, which I find to be an exotic language.
But some of its features seem to be genetically related to earlier
dialects (like reader macros, or property lists). I'm curious abou how
such features are actually implemented.

# Design of System

There's two design procedures at play here: (1) the design of the
interpreter program in C, (2) the design of the Lisp dialect. The
advantage of Lisp is that the syntax is basically fixed, so we only need
to consider its semantics. For simplicity, we will build a call-by-value
Lisp interpreter.

## Architecture of an Interpreter

The design of an interpreter is straightforward, in the sense that, it
hasn't changed that much in the past 60 years.

![Interpreter architecture](/assets/lisp-interpreter-architecture.svg)

An input stream (either a file, or a string, or whatever) is given to
the lexical scanner, which produces tokens for the parser. The parser
then produces an abstract syntax tree. This is the main purpose of the
front end: produce an abstract syntax tree representation for a given
input source.

This abstract syntax tree is then transformed by some middle end. This
includes various forms of optimization, or program analysis. Usually,
when constructing a compiler (or interpreter), this part of the program
is omitted on the first iteration. First we get the interpreter working,
then we write optimizer routines and analysis subroutines. When we
return to the middle end, it will accept some abstract syntax tree and
produce some abstract syntax tree.

The back end then takes this abstract syntax tree, and either compile it
to some bytecode (or machine code) _or_ interpret it. A first pass at
designing and implementing a language may begin with the latter. Doing
so, we obtain also a reference implementation to compare our other
implementations against.

## An "Object Model"

We also need to design an "object model" (lacking a better phrase --- I
am borrowing the term from Pavlata's [The Ruby Object Model](http://www.atalon.cz/rb-om/ruby-object-model/)).
This is the basic data types offered to the programmer who wishes to use
our Lisp. We need to actually think about what primitive types to offer,
what primitive (built-in) functions to provide, and how to implement
them.

As we build our interpreter, we will add more types to our object model
and provide greater functionality.

# A Minimal Lisp

The basic problem before us now is to implement as minimal a "language"
possible. If we can parse S-Expressions into data structures, we can
then work with this later on. The design begins with as few "classes" as
possible, summarized in the following diagram:

![Classes involved in the front end](/assets/lisp-scanner.svg)

The Scanner class is instantiated when we have some input stream we're
trying to parse. Its instance produces Token objects on demand. This
standardizes the input stream, decomposing it into identifiers,
constants, punctuation, and so on.

The Parser class uses the Scanner instance to produce an abstract syntax
tree. The abstract syntax tree is encoded as an SExp object.

We do not intend to actually do any computation with this system. We
only intend to parse some input into an abstract syntax tree. And the
advantage of Lisp is that its abstract syntax tree _is_ its input
language (i.e., S-expressions). Thus it suffices to consider cons cells
and treat everything as a "symbol". We have the following "object model":

![Classes involved in the object model](/assets/lisp-scanner-object-model.svg)

The Cons class is a node in a linked list. The `car` refers to the value
at the node, and the `cdr` refers to the next node. This is the
convention, and sometimes it is broken (e.g., an association list is a
list whose values are Cons objects interpreted as "key-value" pairs).

# Object Model Implementation

We begin by building our type system. The metadata is tracked by a
common "object header" data structure. Most interpreted languages use
this strategy to collate metadata (citations below for Java, .NET,
Python, Ruby).

```c
typedef enum {
    SEXP_CONS,
    SEXP_SYMBOL
} SExpType;

struct SExp {
    SExpType type;
};
```

The `struct SExp` serves as the first field in every type in our object
model. It has a single important invariant: once its `type` has been
assigned, it is immutable.

## Symbol

The basic symbol data structure is a glorified string.

```c
struct Symbol {
    struct SExp header;
    char *name;
};
```

The idea is that pointers to a `Symbol` object in memory look like

![Pointer to a Symbol object](/assets/lisp-parser/symbol-data-structure.svg)

But the C standard let's us reinterpret any pointer to a `struct` be
freely interpreted as a pointer to its first element. We draw this
diagram reflecting the interpreted pointer as a `SExp` pointer:

![Pointer to a Symbol object interpreted as a SExp pointer](/assets/lisp-parser/symbol-inheritance.svg)

### Symbol Operations

We have to implement the boiler plate constructor, destructor, etc.
Later we may have to revisit the `symbol->name` allocation: right now,
we just point to the string given to us. We may want to copy the
string, and free it upon destroying the Symbol object.

```c
struct Symbol* symbol_new(char *name) {
    struct Symbol *symbol = malloc(sizeof(*symbol));
    // We should really handle if symbol is NULL
    symbol->header.type = SEXP_SYMBOL;
    symbol->name = name;
    return symbol;
}
```

The destructor takes a pointer to a pointer to a symbol. The reason
being, we should update the Symbol pointer to point to `NULL`.

```c
void symbol_free(struct Symbol **symbol) {
    if ((NULL == symbol) || (NULL == *symbol)) return;
    free(*symbol);
    *symbol = NULL;
}
```

## Cons Cells

The Cons data structure is a little more intricate. We allocate memory
for the header metadata, a pointer to its `car` object, and a pointer to
its `cdr` object. But we **do not** copy the car and cdr object: we
point to them. Well, more precisely, we will use double
pointers for the reason alluded to above in the Symbol destructor.

```c
struct ConsCell {
    struct SExp header;
    struct SExp **car,
                **cdr;
};
```

The constructor resembles the Symbol constructor. Following our
conventions that the "class" name prefixes the function, we call this
operation the `cons_new()` function. But I've added a macro to make the
code later on look more natural.

```c
struct ConsCell* cons_new(struct SExp **car, struct SExp **cdr) {
    struct ConsCell *cell = malloc(sizeof(*cell));
    cell->header.type = SEXP_CONS;
    cell->car = car;
    cell->cdr = cdr;
    return cell;
}

#define cons(car, cdr)    cons_new((car), (cdr))
```

Similarly, for now, the destructor will just destroy the cell, but not
recursively free its contents. Afterwards, it will update the cell to be
`NULL`.

```c
void cons_free(struct ConsCell **cell) {
    if ((NULL == cell) || (NULL == *cell)) return;
    free(*cell);
    *cell = NULL;
}
```

We really need some method of garbage collection here, otherwise the
cell's _contents_ linger around when we free the memory allocated for
the _pointers_ to those contents. It's like throwing away the _bag_
instead of the _chips_.

# References

- Symbolics [I-Machine Macroinstruction Set](http://www.bitsavers.org/pdf/symbolics/I_Machine/Macroinstruction_Set.pdf)
- Symbolics [I-Machine Architecture Specification](http://www.bitsavers.org/pdf/symbolics/I_Machine/I-Machine%20Architecture%20Specification.pdf),
  with a cover letter dated Dec 17, 1986
- [`stdbool.h`](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stdbool.h.html)
- [`stddef.h`](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stddef.h.html)
- [`stdint.h`](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stdint.h.html)

## Object System

- [Java Objects Inside Out](https://shipilev.net/jvm/objects-inside-out/)
- [Ruby Internals: Exploring the Memory Layout of Ruby Objects](https://www.rubyguides.com/2017/04/memory-layout-of-an-object/)
- CLR [Managed object internals](https://devblogs.microsoft.com/premier-developer/managed-object-internals-part-4-fields-layout/)
- Python [Common Object Structures](https://docs.python.org/3/c-api/structures.html)
