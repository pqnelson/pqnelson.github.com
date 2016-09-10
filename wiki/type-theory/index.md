---
layout: wiki
title: Type Theory
published: true
date: 2016-01-17
parentURL: /wiki/
---

Type theory, I will caricature, is an _approach to present_ a formal
language plus its
[operational semantics](https://en.wikipedia.org/wiki/Operational_semantics).
It could be thought of as a method of _analyzing_ a formal language.

The basic building blocks in this manner of analyzing languages are
"[terms](https://en.wikipedia.org/wiki/Term_(logic))" and "types". Each
term has a type, specified by a "typing relation" usually written as
`<term> : <type>`.

**Definition.**
A term `t` is **"typable"** (or _well typed_) if there is some `T` such
that `t : T`.
(End of Definition)

A "good language" has, for any given well-typed term `t`, a unique type
`T` such that `t : T`. This property (uniqueness of type) is called
"Uniticity of Types".

Other properties we want for a language:

- **Progress:** A well-typed term is not stuck (either it is a value or it
  can take a step according to the evaluation rules).
- **Preservation:** If a well-typed term takes a step of evaluation, then
  the resulting term is also well-typed.

Type theory (in practice, for programmers and the foundations of math
alike) amounts to an "add-on" to lambda calculus, in the sense that it
adds power to an underlying computational model...and lambda calculus
is the easiest one to work with. So simply-typed lambda calculus is the
"floor model" for type theory. The possible additions form the core of
the [lambda cube](/wiki/type-theory/lambda-cube/).

There are two "routes" to type theory enlightenment: (1) as a
foundations of mathematics, and (2) for programming languages. And when
one attains supreme perfect enlightenment, one realizes the [non-duality
of these paths](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence).

In practice, most type checkers and proof assistants have
[definitions](/wiki/type-theory/definitions), which are seldom discussed
in the literature. They are very similar to judgments, but introduce
constants and "macros" (abbreviations depending on parameters).

# References

- Benjamin C. Pierce,
  _Types and Programming Languages_.
  MIT Press (2002). Probably the best introduction to the Lambda Cube,
  oriented towards programmers.
- Rob Nederpelt and Herman Geuvers,
  _Type Theory and Formal Proof: An Introduction_.
  Cambridge University Press (2014).
  An excellent introduction for mathematicians to the lambda cube, and
  specifically focuses on how type theory applies to the foundations of
  mathematics.
- Herman Geuvers,
  "Introduction to Type Theory".
  Lecture notes,
  [eprint](http://www.cs.ru.nl/~herman/onderwijs/provingwithCA/paper-lncs.pdf)
  (2008), 57 pages.
