---
layout: wiki
title: Lisp Language
published: true
date: 2021-02-27
parentURL: /wiki/comp-sci/
---

Lisp is the second oldest high-level language still in use (FORTRAN
beats it by a couple years).

The idea is, if we want to work with our own programming language with
some new features, then we can do so using Lisp macros. In this way,
Lisp may be seen as a "minimal programming language" where we have
already parsed the object language into the AST (which may be serialized
as S-expressions). Lisp's [grammar](./grammar) is quite succinct and
easily parsed.

# Playground for Compiler Writers

For programmers who want to write compilers or interpreters, Lisp serves
as a well-established object language for experiment. Before we can
write a Haskell++ compiler (or whatever), we should first make sure we
understand how to write a compiler. And writing a compiler for Lisp
simplified the front-end code considerably, which let's us get to the
exciting parts of type checking and whatnot.

We can also write a virtual machine for Lisp compilers to target. This
is what Peter Henderson's _Functional Programming: Application and Implementation_
(1980) does: write a Lisp compiler for a pure functional programming
language expressed using S-expressions, then compile it to SECD machine
bytecode.

_Remark._ Although there are a wide variety of abstract machines and
virtual machines which emerged over the years, of particular interest to
me is the prospect of using a Lisp Machine as the template for a virtual
machine. The documentation for Symbolics I-machines architecture is
[online](http://www.bitsavers.org/pdf/symbolics/I_Machine/I-Machine%20Architecture%20Specification.pdf), there are others to consider (Lisp Machines Inc., Xerox, Texas
Instruments, etc.). They all seem to share the same basic concepts, as I
understand them. (End of Remark)

# History

The history of Lisp may be found in the reviews:
- John McCarthy, "History of Lisp".
  [Eprint](http://jmc.stanford.edu/articles/lisp.html)
  of a presentation made at the ACM SIGPLAN History of Programming
  Conference in 1978.
- Richard P. Gabriel and Guy L. Steele,
  "The Evolution of Lisp".
  [Extended PDF](https://dreamsongs.com/Files/HOPL2-Uncut.pdf)
  of a paper in the proceedings
  _The Second ACM SIGPLAN History of Programming Languages Conference HOPL-IO_, April 1993.
  Picks up from where McCarthy's article left off.