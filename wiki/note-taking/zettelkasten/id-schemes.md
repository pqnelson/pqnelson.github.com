---
layout: wiki
title: ID Schemes - Zettelkasten
published: true
date: 2021-11-31
parentURL: /wiki/note-taking/zettelkasten/
---

There are many different ways to assign ID numbers to slips in one's
Zettelkasten. This seems to be the subject of _Folgezettel_, but I don't
know German well, so I cannot adequately say.

# My Scheme

An ID in my scheme consists of two components: the category part, and
the thread part. They are separated by a `/`. There is at most one slash
in an ID number in my scheme.

The formal grammar looks like:

```
<ID> ::= <category id>
      | <category id> "/" <thread id>

<category id> ::= <number>
               | <number> "." <category id>

<thread id> ::= <number>
             | <number> <lowercase letter> <thread id>
```

## Categories

Some slips, like `5.6 Lie Group`, just start a category or subcategory.
These are quick summaries of the subject for myself.

Later I include
links to other places where results are generalized or related (e.g.,
later I have a discussion of finite groups in `5.3.4 Finite Group Theory`
which includes extensive discussions of groups of Lie type `5.3.4.4
Finite Lie groups` --- then I make a note of this on `5.6 Lie Group` to
the effect of "This discusses Lie groups over Fields of characteristic
0, for finite fields see `(5.3.4.4)`"; and on `5.3.4.4` I note something
like "Lie groups `(5.6)` specialized to finite fields").

My top-level categories and sub-categories are:

1. Zettelkasten
2. System and Method
3. Computer Science
4. Symbolic Math
   1. Elementary Algebra
   2. Differential Calculus in Single Variable
   3. Integral Calculus
   4. Series
   5. Vectors
   6. Multivariable Calculus
   7. Vector Calculus
5. Abstract Algebra
   1. Linear Algebra
      1. Elementary Linear Algebra (start with systems of equations,
         then matrices, discusses a lot of matrix algebra, then vector
         spaces)
      2. Intermediate Linear Algebra (start with field axioms and the
         abstract definition of a vector space, then linear
         transformations & operators, etc.)
      3. Advanced Linear Algebra (modules over rings, etc.)
   2. Number Theory
   3. Group Theory
   4. Category Theory
   5. Rings and Fields
   6. Lie groups
6. Analysis
   1. Real Analysis
   2. Complex Analysis
   3. Numerical Analysis
   4. Fourier Analysis
   5. Partial Differential Equations
7. Geometry and Topology
   1. Point-set topology
   2. Differential topology
8. Foundations of Math
   1. Naive Set Theory
   2. First-order logic
   3. Axiomatic Set theory
   4. Type theory
   5. Higher-Order logic
9. Theorem provers
   1. Automath
   2. LCF
   3. Coq


## Threads

Like most mathematicians, my notes on mathematics may be viewed as a
thread of concepts (definitions). Any results about a concept are a
branch off the concept.

- 6.2 Differential Topology
- 6.2.1 Manifold
- 6.2.1/1 Defn: Chart
- 6.2.1/2 Defn: Compatible Charts
- 6.2.1/3 Defn: Atlas
- 6.2.1/3a1 Ex: Atlas for `S^2` [brief example, thread of 1 slip]
- 6.2.1/4 Defn: Compatible Atlas
- 6.2.1/5 Defn: Smooth Structure
- 6.2.1/5a1 Rmk: Defn using Equivalence Relation [thread of remarks]
- 6.2.1/5a2 Rmk: Convenient fiction [continuing thread of remarks]
- 6.2.1/5a3 Rmk: Existence not guaranteed [last item in thread of remarks]
- 6.2.1/5b1 Prop: Smooth structure is proper set [thread of properties]
- 6.2.1/6 Defn: Manifold
- 6.2.1/6a1 Ex: Euclidean space [thread of examples]
- 6.2.1/6a2 Ex: n-Sphere [thread of examples, continued]
- 6.2.1/6a3 Ex: Projective space [thread of examples, continued]
- 6.2.1/6a4 Ex: Grassmannian [thread of examples, continued]
- 6.2.1/6a5 Non-ex: uncountable unions [thread of examples, last entry]
- 6.2.1/7 Orientations, Orientable Manifold
- 6.2.1/7a1 Ex: Euclidean Space Orientable
- 6.2.1/7a2 Ex: n-Sphere
- 6.2.1/7a3 Non-Ex: Projective space in even-dimensions
- 6.2.1/7a4 Ex: Projective space in odd-dimensions
- 6.2.1/8 Defn: Product manifold
- 6.2.1.1 Smooth Maps and Functions
- 6.2.1.1/1 Defn: Smooth Map
- 6.2.1.1/1a1 Ex: Identity map
- 6.2.1.1/1a2 Ex: Projection map
- 6.2.1.1/1a3 Ex: Coordinates (Local function)
- 6.2.1.1/1b1 Prop: Composite of Smooth Maps is Smooth Map
- 6.2.1.1/2 Defn: Diffeomorphism
- 6.2.1.1/2a1 Rmk: Homeomorphisms are not always Diffeomorphisms
- 6.2.1.1/3 Defn: Embedding
- 6.2.1.1/4 Defn: Immersion

# References

- [Folgezettel Formalized](https://forum.zettelkasten.de/discussion/comment/13422/#Comment_13422)
