---
layout: post
title: MYSTIC Challenge
published: false
draft: true
use_math: true
quote: "Stories are much tidier than real life. Stories have neat, happy endings, but all you ever really get is unfinished business."
quoteSource: Sandy Mitchell, <i>For the Emperor</i> (2003)
tags: [Automated Theorem Prover, Logic]
---

I've been reading a bit about the Hilbert programme, inspired by that
and [Make A Lisp](https://github.com/kanaka/mal), I thought I would
pitch a new challenge:

- Make
- Yourself a
- Simplified
- Toy
- Isabelle
- Clone

...or the MYSTIC challenge.

The outline of this blog post may broadly be partitioned into two
sections:

1. The "fluff": we review Hilbert's programme as the historical
   motivation for...well...all of modern mathematics. But it was
   articulated before computers could even be imagined. So what if we
   could use some tools from computer science (formal languages and
   grammars, compilers and interpreters, etc.) and apply them to
   Hilbert's programme?
2. The challenge itself: implement a proof assistant which might be
   viewed as an analogous counterpart of Hilbert's "finitary methods",
   and use it to formalize "real mathematics".

# Hilbert Programme

> A historian, however, has the perspective of hindsight, which, alas, cannot be said of the actual participants. So, rather than pointing an accusatory finger, with righteous cries of "how could they have been so stupid?" it behooves us more to shake our heads in pity as we contemplate our forebears' blind stumbling into the very brink of destruction.
> 
> --- Sandy Mitchell, _For the Emperor_ (2003)

At the close of the 19th century, the entire universe was threatened:
the very foundations of mathematics appeared to be inconsistent.

Recall Euclid's geometry is presented as a set of
[axioms](https://www.math.brown.edu/tbanchof/Beyond3d/chapter9/section01.html).
We should recall specifically its fifth axiom: given a
line $\ell$ and a point $P$ not on $\ell$, we can construct a line
$\ell'$ passing through $P$ and parallel to $\ell$.

[Lobachevsky](https://en.wikipedia.org/wiki/Nikolai_Lobachevsky) in
1829, and [Bolyai](https://en.wikipedia.org/wiki/J%C3%A1nos_Bolyai) in
1833, proved there are infinitely many lines $\ell'$ passing through $P$
which are parallel to $\ell$. This challenged the status of an "axiom"
as a "self-evidently true proposition".

If this fifth axiom of Euclid could be "wrong", this begs the question:
what about the consistency of mathematics as a whole? Could we end up
deducing a contradiction? Euclid's axioms are (or were) intuitive
appealing and straightforward, but if one of them could be wrong...what
hope would a more complicated mathematical theory (like differential
calculus) have for being consistent?

This was the setting when our hero, David Hilbert, came along. In his
1904 talk "On the foundations of geometry and arithmetic", he outlined
the sketch of his plan which Hilbert began in earnest around the end of
World War 1 (_c._ 1918). The plan of attack was to give these concerns
the old "one, two buckle-my-shoe":

**Step 1: Formulate mathematics axiomatically.** Treat "classical mathematics"
(i.e., all mathematics formulated using classical logic) as an axiomatic
system. 

David Hilbert reformulated the notion of the "axiomatic method" as
mathematicians now recognize it: we introduce some "primitive notions"
which are undefined terms, which should satisfy some "axioms", and then
we will deduce theorems _syntactically_ from the axioms. That is to say,
we should adhere to a [formalist position](https://plato.stanford.edu/entries/formalism-mathematics/). Cynics
castigated this approach as a "meaningless manipulation of symbols", but
this was only so we could then treat a theorem and its proof 
_as a finite mathematical object_. 

We should also take a step back and admire something here: Hilbert
invented [proof theory](https://plato.stanford.edu/entries/proof-theory/) in this first step. This study of "syntactic proofs"
didn't exist until Hilbert [developed](https://plato.stanford.edu/entries/proof-theory-development/) as just one mere _component_ of his
programme. 

**Step 2: Use "finitary methods" to prove the consistency of axiomatic
systems.**  Now, there were multiple different philosophical
perspectives on the crisis in the foundations of mathematics, and they
all radically disagreed with how to proceed. David Hilbert said (if I
may paraphrase his argument), "Look, let us take the 'greatest common
divisor' of all these philosophical perspectives and use it to prove the
consistency of axiomatic systems. That way, everyone is forced to agree
with the results of classical mathematics."

The "greatest common divisor" among all the different approaches to
the foundations of mathematics was interpreted later on as [finitism](https://en.wikipedia.org/wiki/Finitism),
but Hilbert spoke of "finitary methods". Towards this end, Hilbert
invented [epsilon calculus](https://plato.stanford.edu/entries/epsilon-calculus/) and used it to prove various results in
mathematical logic.

The exact implementation details was to use some fragment of arithmetic
(now generally agreed to be [primitive recursive
arithmetic](https://en.wikipedia.org/wiki/Primitive_recursive_arithmetic)
or "PRA" for short)
and to encode a way to prove results concerning axiomatic systems using
PRA alone.

Well, there's an old saying about curiosity and murdering felines. And
the cat-killing-bastard Kurt Godel proved in 1931 that it's impossible
to prove the consistency of any axiomatic system along the lines that
David Hilbert hoped to accomplish. The Hilbert programme unraveled in
light of these results, and the rest is history.

## Caution: A "Comic-Book" History

As I have presented the history of the Hilbert programme, it is more of a
"comic book history" than a rigorous piece of historical
scholarship. 

For one thing, Hilbert never stated "I have a research programme, and
here it is: ...", so the entire notion of a single coherent "Hilbert programme" is arguably post-hoc
and unjustified.

Further, the discussion of "finitary methods" in Hilbert's writings and
lecture notes are vague. Perhaps there are more lecture notes which are
not translated (or even yet-to-be-discovered) which outlines more fully
what Hilbert meant by the term.

I downplayed the heroic efforts of Hilbert's colleagues,
David Ackermann and Paul Bernays, who played pivotal roles in Hilbert's
post-WW1 work.

Despite all this, the "mythology" I presented is not terribly
unreasonable as a presentation of events. But I want to stress that it
is a mythology, and the interested reader should peruse Richard Zach's
articles for serious scholarship on the subject.

## Reflections on Impact

I cannot deny the audacity, cleverness, and even _romantic_ aspects to
Hilbert's programme.

Bourbaki took Hilbert's epsilon calculus as their foundations, and
worked entirely using Hilbert's axiomatic method (see my [rational reconstruction](http://pqnelson.github.io/assets/notebk/bourbaki-commentary.pdf)
of Bourbaki's foundations for the details). This basically altered the
course of mathematics forever.

The failure of Hilbert's programme has not deterred logicians from
taking inspiration from it, thinking about it along similar lines.
Soloman Feferman's 
["What rests on what? The proof-theoretic analysis of mathematics"](https://math.stanford.edu/~feferman/papers/whatrests.pdf) (1993) is one such example.

But we should also recognize that Hilbert was working 30 years before
electronic computers came about, about 40 years before formal grammar
and programming languages emerged, and that a lot of Hilbert's programme
could be anachronistically recast using notions from computer
science. That's what motivated my thinking behind this challenge...

# Isabelle

> And Now for Something Completely Different...
> 
> --- Monty Python (1971)

[Isabelle](https://isabelle.in.tum.de/) is a proof assistant which could be viewed as a generalization
to some aspects of Hilbert's programme:

1. If we change Hilbert's programme from "axiomatizing classical
   mathematics" to "axiomatizing ~~classical~~ mathematics", then the
   analogous counterpart to "finitary methods" is a generic engine for
   foundations of mathematics (a.k.a., a [logical framework](https://en.wikipedia.org/wiki/Logical_framework)).
   This is precisely what Isabelle is designed for!
2. Isabelle is a fragment of intuitionistic HOL, and [HOL light](https://github.com/jrh13/hol-light)
   is arguably the proof assistant with the smallest [kernel](https://github.com/jrh13/hol-light/blob/master/fusion.ml) which could
   be checked by hand.
3. Isabelle's "metalogic" is sufficiently weak, arguably weaker than
   $\lambda\Pi$ and significantly weaker than the
   calculus-of-constructions. This makes it stay faithful to the
   motivation of using finitary methods in Hilbert's programme.

Among other reasons, while reading up on Hilbert's programme, I was
inspired to think about Isabelle as a sort of "Hilbert programme 2:
Electric Boogaloo", which led me to this MYSTIC challenge.

## Step 1: Basic structure of Isabelle as Lambda Calculus

Isabelle's system is basically a simply typed $\lambda$ calculus with
one primitive type and type variables. In pidgin Haskell, it looks like:

```haskell
data Type = Prop
          | TyVar String
          | TyFun Type Type
```

The terms are free variables, bound variables, constants, lambda
abstractions, and applications. There are dozens (if not [1001 ways](https://jesper.sikanda.be/posts/1001-syntax-representations.html))
to encode bounded variables. [Locally nameless variables](https://boarders.github.io/posts/locally-nameless/)
are among the most popular, so that might work. In pidgin Haskell, we
would expect something like:

```haskell
data Term = Var -- implementation dependent
          | Const String Type
          | Abs Term Term -- also implementation dependent
          | App Term Term
```

There are several primitive terms in the metalogic with the following
"meta-types" (in Haskell, they are terms of type `Term` specifically
using `Const "term" (...)`, but I'm writing down the `Type` using
familiar notation):

- `(==>) : Prop -> (Prop -> Prop)` is implication in the metalogic
- `(==) : (a -> Prop) -> Prop` is equality in the metalogic, used for
  definitions, usually denoted "$\equiv$" on paper
- `(!!) : a -> (a -> Prop)` is the universal quantifier in the
  metalogic typically denoted "$\bigwedge$" on paper

## Step 2: Implement an LCF Kernel

To make this a proof assistant, we can use the LCF approach (which
Isabelle also takes). This defines an abstract type `thm` and provides
ways to combine them together (inference rules) or construct them from
terms (axioms).

There are 14 inference rules for Isabelle's metalogic. You can find them
in, e.g.,

- Lawrence Paulson,
  "The Foundation of a Generic Theorem Prover".
  [arXiv:cs/9301105](https://arxiv.org/abs/cs/9301105), 37 pages

The pidgin code for this has at least the following Standard ML signature:

```sml
signature KERNEL = sig
    (* abstract types *)
    type thm;
    type Type; (* from step 1 *)
    type Term; (* from step 1 *)

    (* public facing *)
    val prop_type : Type;
    
    (* constructors *)
    val mk_var : string -> Type -> Term;
    val mk_const : string -> Type -> Term;
    (* etc. *)
    
    (* accessors *)
    val dest_var : Term -> (String, Type);
    val dest_const : Term -> (String, Type);
    (* etc. *)
    
    (* predicates *)
    val is_var : Term -> bool;
    val is_const : Term -> bool;
    (* etc. *)
    
    (* inference rules and axioms *)
    val REFL : Term -> thm;
    val TRANS : thm -> thm -> thm;
    (* etc. *)
end
```

Then implement a Standard ML structure for it (or whatever the analogous
thing would be in your chosen programming language).

This "step" can take a weekend to do fully.

Desiderata:

- Make the kernel as small as possible.
- The `thm` is a natural fit for a monad (if your
  programming language supports monads)
- Don't worry about tracking definitions for the time being.

# References

## Hilbert Programme

- Richard Zach,
  "Hilbert's Program Then and Now".
  [arXiv:math/0508572](https://arxiv.org/abs/math/0508572), 43 pages; summarized by Zach in [Stanford Encyclopedia of Philosophy article](https://plato.stanford.edu/entries/hilbert-program/)

### Finitary Methods

- Jeremy Avigad,
  "The computational content of classical arithmetic".
  [arXiv:0901.2551](https://arxiv.org/abs/0901.2551), 16 pages;
  discusses PRA's encoding of logic further.
- Richard Zach,
  "The Practice of Finitism: Epsilon Calculus and Consistency Proofs in Hilbert's Program"
  [arXiv:math/0102189](https://arxiv.org/abs/math/0102189), 44 pages.

## About Isabelle

- Lawrence Paulson,
  "Natural Deduction as Higher-Order Resolution".
  [arXiv:cs/9301104](https://arxiv.org/abs/cs/9301104), 22 pages
- Lawrence Paulson,
  "The Foundation of a Generic Theorem Prover".
  [arXiv:cs/9301105](https://arxiv.org/abs/cs/9301105), 37 pages
- Lawrence Paulson,
  "Isabelle: The Next 700 Theorem Provers".
  [arXiv:cs/9301106](https://arxiv.org/abs/cs/9301106), 24 pages
- Tobias Nipkow, Simon Roßkopf,
  "Isabelle's Metalogic: Formalization and Proof Checker".
  [arXiv:2104.12224](https://arxiv.org/abs/2104.12224), 18 pages. 
  - For all the bells-and-whistles which accumulated over time
- Lawrence Paulson,
  "".
  [arXiv:]()
  
## Other proof assistants

- Mark Adams,
  "HOL Zero's Solutions for Pollack-Inconsistency". 
  In _Proceedings of the 7th International Conference on Interactive Theorem Proving_, Volume 9807 of Lecture Notes in Computer Science, pages 20-35. Springer, 2016. 
  [Eprint](http://proof-technologies.com/papers/hzsyntax_itp2016.html)
- Ramana Kumar,
  "Self-compilation and self-verification".
  Tech report UCAM-CL-TR-879, February 2016, [eprint](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-879.html)