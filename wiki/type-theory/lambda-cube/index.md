---
layout: wiki
title: Lambda Cube
published: true
date: 2016-01-17
parentURL: /wiki/type-theory/
---

The Lambda Cube are a series of successive refinements applied to
simply-typed lambda calculus. In ASCII art, we have something like the
following: 

<pre>
   λω-------λΠω
   /|      /|
  / |     / |
λ2--|---λΠ2 |
 | λ<u>ω</u>----|--λΠ<u>ω</u>
 | /     | /
 |/      |/
<a style="text-decoration:none;" title="Simply Typed Lambda Calculus" href="/wiki/type-theory/lambda-cube/simply-typed-lambda-calculus">λ→</a>-------λΠ
</pre>

The "floor model" is `λ→`, the simply-typed lambda calculus.
We have the following different "dimensions" to the lambda cube:

- `λ2`, a.k.a. "System F", allows for polymorphism (c.f., Pierce _TAPL_ ch.23)
- <code>λ<u>ω</u></code> allows for types depending on types (or "type
  operators" and "kinding", c.f. Pierce's _TAPL_ ch.29), and 
- `λΠ` allows for types depending on terms (a.k.a., dependent types,
  c.f., David Aspinall and Martin Hofmann's "Dependent Types" --- ch.2
  in _Advanced Topics in Types and Programming Languages_, ed. Benjamin
  C. Pierce).

The other vertices are obtained mixing these "basis calculi" together in
a "compatible" manner. For example, `λω` combines type operators and
System F (c.f., Pierce's _TAPL_, ch.30). Or `λΠω`, otherwise known as
the "Calculus of Constructions" (also discussed briefly in Aspinall and
Hofmann's article) combines `λω` with dependent types.

# References

- Benjamin C. Pierce,
  _Types and Programming Languages_.
  MIT Press, 2002.
  Implements type checkers for 6 of the vertices of the lambda cube, in
  Standard ML. Very pedagogical, beautifully done.
- Benjamin C. Pierce, ed.,
  _Advanced Topics in Types and Programming Languages_.
  MIT Press, 2005.
