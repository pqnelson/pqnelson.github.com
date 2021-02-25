---
layout: wiki
title: Hoare Logic
published: true
date: 2021-02-14
parentURL: /wiki/comp-sci/
---

Hoare logic is a way to formalize the semantics of a simple
[imperative programming language](./imperative-language) (resembling
Algol or Pascal). It suffices to consider Booleans and integers are the
only data types, with the basic arithmetical operators and relational
operators as the only given operations. There are four types of statements:
1. Assignment `V := E`
2. Sequence `S1; S2`
3. Conditional `if B then C1 else C2`
4. Loops `while B do C`

We can describe the state of the computer in terms of what variables
have been declared and what values they have at a given point in
executing the program. More importantly, we can describe a class of
states using propositions.

Hoare logic tells us how each statement in the imperative language
transforms the state of the computer. We use the notation `{P} C {Q}`
to write `P` and `Q` are logical formulas (propositions) involving
program variables, intuitively describing the state _before_ and _after_
the statement `C` is executed. And we can use formal logic to create a
calculus for deriving valid Hoare triples.

Consequently, if we can derivate annotations for consecutive statements
`C1; C2` with assertions `{P} C1 {Q}; {Q'} C2 {R}` and can prove `Q`
implies `Q'`, then we establish _partial correctness_ for the program.
By "partial correctness", we mean, "If the program terminates, then it
computes the desired quantity correctly." Thus we have an assembly line
of assertions.

# References

- Mike Gordon's [lecture notes](https://www.cl.cam.ac.uk/archive/mjcg/HL/)
- Krzysztof R. Apt, Ernst-Ruediger Olderog,
  "Fifty years of Hoare's Logic".
  [arXiv:1904.03917](https://arxiv.org/abs/1904.03917), 79 pages
- Boro Sitnikovski
  "Tutorial on implementing Hoare logic for imperative programs in Haskell".
  [arXiv:2101.11320](https://arxiv.org/abs/2101.11320), 9 pages