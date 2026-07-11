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

## My Scheme

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

### Categories

Some slips, like `5.6 Lie Group`, just start a category or subcategory.
These are quick summaries of the subject for myself.

<div style="padding-left:0.5em;margin-left:0.5em;border-left:1px dotted; font-size:smaller">
<strong>Addendum</strong> <time datetime="2026-07-11T10:24:31-0700">Jul 11, 2026 (10:24:31 AM)</time>.
After much thought, I realize I am misusing the word "category" here
for <strong>sections</strong>. I have written my thoughts about <a href="./categories-sections-tags.html">Categories,
Sections, and Tags</a> elsewhere.
</div>

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

## What did Luhmann do?

Curiously, Luhmann seems to have a rather different approach to ID
numbers. It's worth looking at the subtree rooted at [9/8](https://niklas-luhmann-archiv.de/bestand/zettelkasten/zettel/ZK_2_NB_9-8_V)
in his Zettelkasten.

Luhmann seems to develop a train of thought: 9/8, 9/8a, 9/8b, 9/8c,
..., 9/8j. This should be understood as something analogous to a
"Twitter thread", Luhmann wanted to say a number of things which
didn't fit on one card, so he wrote one thought per slip.

There is also some addendum to 9/8 as a subsequent, independent, train
of thought numbered 9/8.1, 9/8.2, 9/8.3. What is the reason for this
different ID numbering scheme of `<period> <number>` suffix? It is
unclear to me. In footnote 30 of Johan Schmidt's "Niklas Luhmann’s Card Index: Thinking Tool,  Communication Partner, Publication Machine", Schmidt writes (p.301):

> For reasons of clarity, the principle of numbering that Luhmann applied will be illustrated in simplified fashion. In addition to the sequence outlined below, there are also cards that are numbered using two consecutive numbers or letters (e.g., 1/1aa or 1/2,1). This pattern is a consequence of applying the described method of adding cards and inserting a card in an already existing sequence at a later point in time.

But there is also a "branch" off [9/8a](https://niklas-luhmann-archiv.de/bestand/zettelkasten/zettel/ZK_2_NB_9-8a_V)
as 9/8a1, 9/8a2.

### Luhmann's numbering scheme made a little more explicit

More abstractly, Luhmann numbering scheme seems to be simplified to
something like:

- 1/1 Card with notes
  - 1/1a Card containing notes referring to a concept/idea from card 1/1
  - 1/1b Continuation of notes from card 1/1a
    - 1/1b1 Card containing notes referring to a concept/idea from card 1/1b
    - 1/1b2 Continuation of notes from card 1/1b1
- 1/2 Continuation of notes from card 1/1

This is a simplified toy model from Johan Schmidt's "Niklas Luhmann’s Card Index: Thinking Tool, Communication Partner, Publication Machine" (p.301).

Did Luhmann always work this way? No. For example, there are two cards [9/9](https://niklas-luhmann-archiv.de/bestand/zettelkasten/zettel/ZK_2_NB_9-9_1_V)
or [9/9](https://niklas-luhmann-archiv.de/bestand/zettelkasten/zettel/ZK_2_NB_9-9_2_V)
which deal with either Systems Theory or Women's studies. Card [9/7](https://niklas-luhmann-archiv.de/bestand/zettelkasten/zettel/ZK_2_NB_9-7_V)
discusses Heraclitus. There doesn't seem to be any obvious
"continuation" of Heraclitus into 9/8, nor any obvious continuation of
Zettelkasten 9/8 into either Women's Studies 9/9 or Systems Theory 9/9.

The important thing is that this alternation between letters and
numbers offered Luhmann a branching mechanism, which allowed him to
discuss related topics. However, as we observed with `9/8.1` as a
branch off `9/8`, it was insufficient as _the only_ branching
mechanism. (Schmidt reports there are branches like `1/2aa`, too.)

There are some days I think Luhmann's scheme is superior, because it
forces you to think carefully about what you're writing. Sometimes
giving the user too much power is a bad thing, giving the user too
many ways to "branch" off can be bad (it leads to "analysis paralysis").

# References

- [Folgezettel Formalized](https://forum.zettelkasten.de/discussion/comment/13422/#Comment_13422)
- J. Schmidt, “Niklas Luhmann‘s Card Index: Thinking Tool,
  Communication Partner, Publication Machine”, _Forgetting
  Machines. Knowledge Management Evolution in Early Modern Europe_,
  A. Cevolini, ed., Library of the written word, vol. 53, 1. Auflage.,
  Leiden: Brill, 2016,
  pp.289-311. [Eprint](https://pub.uni-bielefeld.de/record/2942475)
- J. Schmidt, “Niklas Luhmann’s Card Index: The Fabrication of
  Serendipity”, _Sociologica_, vol. 12, 2018, pp. 53-60. 
  [Eprint](https://pub.uni-bielefeld.de/record/2942471)