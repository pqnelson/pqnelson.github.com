---
layout: wiki
title: Quantum Field Theory
published: true
date: 2015-08-29
parentURL: /wiki/
---

Quantum Field theory is a framework for constructing quantum models of
fields or particles. We use the
[Wigner classification](./wigner-classification.html) to specify
the "species" of particles allowable.

There are three basic "paradigms" or "sub-frameworks" one can use: the
Heisenberg picture (which every textbook starts with), the functional
Schrodinger picture (which almost no textbook discusses), and the path
integral approach. We can translate from one sub-framework to another,
and they're all equivalent. But some sub-frameworks can answer certain
questions easier than others.

The general algorithm is:

0. Pick the particles or fields you are interested in.
0. Write down the Lagrangian, which consists of the kinetic terms and the
   interaction terms.
  0. The kinetic terms are just the "free field" Lagrangian, one for
     each particle or field.
  0. The interaction term determines the interactions, in the sense that
     each factor represents a distinct particle necessary for the
     interaction.
0. Determine the Feynman rules.
0. Compute the correlation functions.
0. ???
0. Profit!!!

Each step is fairly involved, and could easily require several review
papers to do them justice. If we're working with a "canonical"
(Hamiltonian) sub-framework, we need to do a couple more steps to handle
gauge symmetries properly.

**References.**

There are a lot of references on quantum field theory, and I could spend
the rest of my life writing a survey of literature. I'll just cite the
books I like.

0. Brian Hatfield,
   *Quantum Field Theory of Point Particles and Strings*.
   Westview Press. Despite the title, roughly 70% of the book is on
   vanilla quantum field theory (only the last 30% of the book covers
   string theory). Be sure to re-derive everything from scratch, to
   avoid the typos.
0. Steven Weinberg,
   *Quantum Theory of Fields*.
   The only way to understand Weinberg is to rewrite him in a grocery
   list of logical points.
