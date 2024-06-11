---
layout: post
title: MYSTIC Challenge
published: true
draft: false
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

I downplayed the heroic efforts of Hilbert's colleagues, Wilhelm
Ackermann and Paul Bernays, who played pivotal roles in Hilbert's
post-WW1 work. And Hilbert lavishly praises their contribution quite
explicitly in his papers, lectures, etc.

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

# MYSTIC Challenge

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

Well, since Isabelle is an intuitionistic fragment of HOL, I suppose you
could call this the _HOL-bert program_ ([you're welcome, Stanley!](https://youtu.be/dQw4w9WgXcQ?feature=shared)).

Alternatively, you could look to
[ACL2](https://www.cs.utexas.edu/~moore/acl2/) as an example of a
theorem prover based on PRA + induction up to $\varepsilon_{0}$ (making
it as strong as Peano arithmetic), and use that as the metalanguage for
implementing a proof assistant for classical mathematics.

There are countless variations to the basic challenge, each interesting
in their own way. I'm going to outline the basic steps in building an
LCF proof assistant, point to references in the literature for more
detail for the reader, and leave most of it up to you. (If I did too
much, it spoils the fun...)

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

I am tempted to follow a lot of HOL Light's design decisions, to make
the kernel as minimal as possible (even if that makes the resulting
proof assistant a little slow).

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

For a full tutorial on this step alone, the reader may consult Jon
Sterling's [LCF Sequent Calculus Example](https://github.com/jonsterling/lcf-sequent-calculus-example/tree/master)
and Michael Norrish's [slides](https://www.cse.unsw.edu.au/~kleing/teaching/thprv-04/slides/slides-HOL4.pdf)
about HOL more generally.

Desiderata:

- Make the kernel as small as possible. 
- Can you prove the kernel is sound? This might be a good fit for
  literate programming if you're doing it by hand. Alternatively, you
  could use the code generation feature of Coq (or HOL or...) to make
  your kernel, and prove in Coq (respectively HOL, or...) that your code
  is sound.
- The `thm` is a natural fit for a monad (if your
  programming language supports monads).
- Don't worry about tracking definitions in this step, it's coming up shortly.

## Additional Steps

At this point you have a small LCF prover for an intuitionistic fragment
of HOL. Here are some further steps you can follow:

**Step 3: Definitions.** You need to be able to add definitions of
simple constants $c = t$ where $c$ is a new constant term symbol and $t$
is a closed term. 

HOL Light implements definitions as an
association list, which is just a global variable. Freek Wiedijk's
"Stateless HOL" ([arXiv:1103.3322](https://arxiv.org/abs/1103.3322))
modified the structure of HOL Light to a more purely functional
approach, passing along the definitions as a parameter.

Things to ponder:

- Can you treat definitions monadically?
- If you're going to support typeclasses ("ad hoc polymorphism"), how will
  your implementation of definitions handle it?
- If you're using ML, can you treat definitions in MYSTIC as a new `val`
  definition in ML code? How do you link it to a running MYSTIC instance
  to make the program interactive?

Some references for some backstory:
- Rob Arthan,
  "On Definitions of Constants and Types in HOL".
  _Journal of Automated Reasoning_ **56** (2016) 205–219
  doi:[10.1007/s10817-016-9366-4](https://doi.org/10.1007/s10817-016-9366-4)
- Ms. Molly Stewart-Gallus,
  [Do you need a Hilbert style Epsilon operator for definitions in set theory?](https://proofassistants.stackexchange.com/q/1349/14)
  Proof Assistants Stackexchange thread, 30 April 2022.
- Dominic P. Mulligan,
  "Mosquito: an implementation of higher-order logic (Rough diamond)".
  [Eprint pdf](https://dominicpm.github.io/publications/mulligan-mosquito-2013.pdf), for more about purely functional implementations of
  HOL and handling of defintions. I have [backed up the code](https://github.com/pqnelson/mosquito).

**Step 4: Inductive types and definitions.** These are helpful for
reasoning about object languages. Following Tom Melham's brilliant
insight to use the Tarski-Knaster theorem, every HOL system follows
suite. 

Some references may be useful on this subject:

- Thomas F. Mehlam,
  "Automating recursive type definitions in higher order logic".
  UCAM-CL-TR-146, September 1988, [Eprint](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-146.html).
- Thomas F. Melham,
  "A Package for Inductive Relation Definitions in HOL". _Proceedings Of The 1991 International Workshop On The Hol Theorem Proving System And Its Applications_, 1991, [PDF](https://www.cs.ox.ac.uk/tom.melham/pub/00596299.pdf)
- Stefan Berghofer and Markus Wenzel,
  "Inductive datatypes in HOL — lessons learned in Formal-Logic Engineering".
  In _TPHOLs 1999_.
  [Eprint PDF](https://files.sketis.net/papers/datatype-TPHOLs99.pdf)

**Step 5. Higher-order resolution.**
Consider implementing resolution in the metalogic for reasoning about
the object logic. You could also implement tableaux methods, if you
want, but higher-order resolution has the advantage of failing faster
than first-order resolution. Gilles Dowek advocates using it for trying
to find out if a theory is consistent or not, and now you've built a
tool which allows you to explore this claim!

- Gilles Dowek,
  "What do we know when we know that a theory is consistent?".
  [arXiv:2305.10012](https://arxiv.org/abs/2305.10012), 6 pages. 

## Subsequent projects

There's many ways to develop the toy model we've built together. Here
are some ways which spring to mind...

**Project 1: Parser and Printer.** So far, you will have been constructing
everything in the "object logic" by hand manually. This is tedious at
the best of times. Isabelle implements an Earley parser for the "object
logic" (see &sect;8.4.5 "Ambiguity of parsed expressions" of the
Isabelle/Isar manual). If you don't know what an Earley parser is, it's
roughly 
\begin{equation}
\begin{pmatrix}\mbox{Earley}\\\ \mbox{Parser}\end{pmatrix}
=
\begin{pmatrix}\mbox{Recursive}\\\ \mbox{Descent}\\\ \mbox{Parser}\end{pmatrix}
+\begin{pmatrix}\mbox{Dynamic}\\\ \mbox{Programming}\end{pmatrix}
\end{equation}

If you've made it a Lispy-like syntax for the
"object logic", you might not want to do this step, but it's always fun
writing parsers and prettyprinters. 

- Freek Wiedijk,
  "Pollack-Inconsistency".
  [PDF](https://www.cs.ru.nl/~freek/pubs/rap.pdf), 17 pages.
  + Discusses the dangers of inconsistency from a faulty printer/parser implementation
- Mark Adams,
  "HOL Zero's Solutions for Pollack-Inconsistency". 
  In _Proceedings of the 7th International Conference on Interactive Theorem Proving_, Volume 9807 of Lecture Notes in Computer Science, pages 20-35. Springer, 2016. 
  [Eprint](http://proof-technologies.com/papers/hzsyntax_itp2016.html)
  + HOL Zero takes great pains to parse and print terms to avoid
    so-called "Pollack-Inconsistency", which may be worth examining if
    you decide to implement a parser and printer

**Project 2: Declarative Proof Steps.**
Isabelle has Isar, which is nice for its purposes, but there is really
little better than Mizar for formalizing mathematics. [Mizar](http://mizar.org/) was designed
intentionally as a formal language for how _working mathematicians_
actually do mathematics. Study the design space here for declarative
proof steps, and experiment with what works and what doesn't.

Some references might be useful:

- Freek Wiedijk, 
  "Mizar Light for HOL Light".
  _TPHOLs 2001_, [PDF](https://www.cs.ru.nl/F.Wiedijk/mizar/miz.pdf)
- Freek Wiedijk, 
  "A Synthesis of the Procedural and Declarative Styles of Interactive Theorem Proving".
  _Logical Methods in Computer Science_ **8** no.1 (2012) 1-26,
  [PDF](https://www.cs.ru.nl/F.Wiedijk/miz3/miz3.pdf);
  [arXiv:1201.3601](https://arxiv.org/abs/1201.3601).
- Markus Wenzel, 
  "Isabelle/Isar — a versatile environment for human-readable formal proof documents". 
  PhD thesis, Institut für Informatik, TU München, 2002. [Pdf](https://mediatum.ub.tum.de/doc/601724/601724.pdf)

**Project 3: Formalize mathematics.**
Mathematicians use an amalgam of foundations in practice. It's actually
approximately a linear combination of 
a "soft type system" + set theory + a fragment of HOL (for schemes).
Try different ways to implement this as an "object logic" in your MYSTIC
assistant. 

Isabelle/Mizar was built to study this design space, and this design space
is still feels underinvestigated.

A second approach: Kevin Buzzard insists mathematicians _really_ must
change how they do mathematics, and write _Principia Mathematica_ style
proofs using Buzzard's preferred foundations. I'm not sure that's the right
approach (reinventing the Hindenburg seldom works).

A third, better, approach would be to think about inventing a Java-like "input
language" which can compile to any foundations you like. ("Write once,
run anywhere" was the motto for Java, it seems like the right approach
to formalizing mathematics.) What would be a suitable Java-like language
for formalizing mathematics which resembles how mathematicians _actually work_?

Mario Carneiro has been working on something similar to this third line
of attack, where he has "compiled" Lean to Metamath Zero (and HOL to
Metamath Zero). One difference worth drawing attention to: Carneiro has
been trying to use Metamath as the "JVM" for mathematics, rather than
looking for a "Java language" of mathematics.

- Freek Wiedijk,
  "Mizar's Soft Type System".
  [Eprint pdf](https://www.cs.ru.nl/~freek/mizar/miztype.pdf)
- Isabelle/Mizar project
  + Cezary Kaliszyk and Karol Pąk,
    "Isabelle Import Infrastructure for the Mizar Mathematical Library".
    CICM 2018, [PDF](https://alioth.uwb.edu.pl/~pakkarol/articles/CKKP-CICMMKM18.pdf)
  + Cezary Kaliszyk and Karol Pąk,
    "Semantics of Mizar as an Isabelle Object Logic".
    _Journal of Automated Reasoning_ **63** no.1 (2019)
    doi:[10.1007/s10817-018-9479-z](https://doi.org/10.1007/s10817-018-9479-z)
  + Karol Pąk's [publications page](https://alioth.uwb.edu.pl/~pakkarol/publications.php)
    has many other papers concerning Isabelle/Mizar
- Mario Carneiro,
  "Metamath Zero: The Cartesian Theorem Prover".
  [arXiv:1910.10703](https://arxiv.org/abs/1910.10703)
  - "Conversion of HOL Light proofs into Metamath".
    [arXiv:1412.8091](https://arxiv.org/abs/1412.8091), 14 pages.

**Project 4: Ouroboros-ify it.** 
Formalize a statically-typed functional programming language using your
proof assistant, implement it, verify the implementation, and use this
to re-implement your MYSTIC proof assistant.

This is a bit of a joke, of course, but it is a fascinating project to
consider. [CakeML](https://cakeml.org/) is working towards realizing such a project, and still
has a bit of a ways to go.

One step towards this end might suffice: add "code generation" support
for your proof assistant.

- Florian Haftmann,
  "Code generation from Isabelle/HOL theories".
  [PDF](https://isabelle.in.tum.de/doc/codegen.pdf), 54 pages.
- Lars Richard Hupel,
  "Verified Code Generation from Isabelle/HOL".
  PhD thesis, Universität München, [PDF](https://lars.hupel.info/pub/phd-thesis_hupel.pdf)
- Ramana Kumar,
  "Self-compilation and self-verification".
  Tech report UCAM-CL-TR-879, February 2016,
  [eprint](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-879.html)
  + Kumar is a member of the CakeML project, which attempts to create a
    self-compiling and self-verifying proof assistant.
- [CakeML publications](https://cakeml.org/publications.html)
  for more about this sort of project.

# Concluding Remarks

There are a lot of different ways to go about this "use computers to
rationally reconstruct Hilbert's programme in terms of proof assistants"
series of projects. I've only outlined a few, which seemed to fit the
Isabelle project like a glove.

Doubtless, there are many other possible variations, approaches,
constraints, designs, and machinations that I haven't even thought of!

But drop me an email (`pqnelson at gmail`). Did you make it to the end? 
Were there any steps which were just too big? Did you wish I added more
information anywhere? Less information? Are you filled with murderous
rage because of how frustrating the whole endeavor was? Let me know, I'd
like to iteratively improve this with your help.

> We have come a long way together, dear readers. We have scaled the
> Himalayas [...]. We have stood on Philosophy's roof. You could see your
> house from there. No surprise; you could have made Philosophy your
> home! Your patience, fortitude, and courage are deeply
> appreciated. You never grumbled or complained. Okay, maybe once or
> twice, but I didn't hear. [...]
> 
> And if, peradventure, you suspect that you were already able to [do
> this] on your own and didn't need this book...well, then it served its
> purpose. Dorothy always had the power to go back to Kansas. Toto too?
> Toto too.
> 
> J. M. Fritzman, _Hegel_ (2014)

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