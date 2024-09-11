---
layout: post
title: Introduction to Automated Theorem Provers
published: true
quote: "Not having heard of it is not as good as having heard of it. Having heard of it is not as good as having seen it. Having seen it is not as good as knowing it. Knowing it is not as good as putting it into practice. Learning arrives at putting it into practice and then stops..."
quoteSource: Xun Kuang, <i>Xunzi</i> (3rd century BC?)
tags: [Automated Theorem Prover]
---

"How do I get started with automated theorem provers?"

This question pops up every month or so, and I thought I'd write an
answer in one place (because I end up repeating the answer).

The guiding philosophy is to learn the _theory_ and _implementation_
simultaneously.

We could think of a theorem prover as a sort of "interpreter" based on a
foundations of mathematics. There are three main camps to the
foundations of mathematics: first-order logic + set theory, type theory,
and higher-order logic.

# Terminology

Before we get started, let's just clarify some terminology. Some random
people on the internet insist "automated theorem provers" differ from
"proof checkers" by having some "automation". This vague claim lacks any
basis in reality.

A **"proof assistant"** is a computer program the user interacts with to
construct or verify a proof.

Many, but not all, proof assistants expect user input in the form of
**"tactics"** which manipulate the proof obligations (the claims left to
be proven). Such proof obligations are generically referred to as
**"goals"**.

The **"proof engine"** interacts with the user via tactics, and informs the
user of any remaining goals. Then, under the hood, the proof engine uses
automation to construct a **"proof object"** which is then
checked by a small **"proof checker"**.

(Caution: I am being a bit generous with my notion of "proof
objects". Some foundations (type theory) have a particular notion with
a specific technical meaning. I'm just referring to any object in
memory used during a proof checking procedure as a "proof object".)

This is the schematic idea underlying automated theorem provers, more or
less. There are variations on this theme. Sometimes there is no clear
cut distinction between the proof engine and the checker, they're blurred
into a giant monolithic program.

I drew these terminological distinctions from:

- H. Geuvers,
  [Proof assistants: History, ideas and future](https://www.ias.ac.in/article/fulltext/sadh/034/01/0003-0025).
  _Sadhana_ **34** no.1 (2009) 3--25.

## Judgments and Inference Rules

A formal system may be formulated in terms of judgments and rules of
inference, and we're trying to pretend a foundation of mathematics is a
formal system, so we need some level of familiarity with "judgments" and
"rules of inference".

These concepts trace back as far as Frege's _Begriffsschrift_, though they
are most clearly articulated in Per Martin-Löf's 1983 lectures:

- Per Martin-Löf,
  [On the Meanings of the Logical Constants and the Justification of Logical Laws](http://archive-pml.github.io/martin-lof/pdfs/Meanings-of-the-Logical-Constants-1983.pdf).

Usually a "judgment" is an n-ary relation in the metalanguage, whose
meaning is specified by an inductive definition using rules of
inference. The notion of an inductive definition was first introduced
in:

- Peter Aczel,
  "An Introduction to Inductive Definitions".
  _Studies in Logic and the Foundations of Mathematics_, vol. 90, 1977,
  pp. 739--782. [Eprint](https://doi.org/10.1016/S0049-237X(08)71120-0).

This is paywalled, so a free-but-terse introduction to inductive
definitions may be found in:

- Thierry Coquand and Peter Dybjer,
  "Inductive Definitions and Type Theory: An Introduction".
  Section 3, [Eprint](http://www.cse.chalmers.se/~peterd/papers/ESSLLI94.pdf)

An honorable mention is:

- Robert Harper,
  _Practical Foundations for Programming Languages_.
  Cambridge University Press.
  
Harper's focus is more on reasoning about programming languages, but he
introduces the notions of "judgment" and "rule of inference" in the
first few chapters of his book.

A proof assistant is then just a computer program which assists us in
chaining inference rules together to form correct proofs.

# Getting Started

The first book I recommend reading:

- John Harrison, _Handbook of Automated Reasoning and Practical Logic_.
  Cambridge University Press, 2009.

But it, read it, and work through it. Implement your own version of
his code in a different statically-typed functional programming
language.

(I always recommend the reader should pick a language like Haskell, F#,
or Standard ML, then implement the same algorithms yourself. This is a
good strategy to learn from the literature, try to implement it yourself
from scratch using a different programming language than the book uses.)

Harrison implements quite a few algorithms in OCaml, and in chapter 6
implements an LCF-style prover for a Hilbert proof system atop
first-order logic.

The only minor qualms I have is that:
1. Harrison is more bullish on model theory than me. But that's like
   saying, "He's a vegetarian". 
2. There are a few times where I wish Harrison would add a couple
   sentences explaining where we're heading. 

As a supplement to chapter 3 of Harrison, I highly recommend:

- Chin-Liang Chang, Richard Char-Tung Lee,
  _Symbolic Logic and Mechanical Theorem Proving_.
  Academic Press, 1973.

Chang and Lee focus on the resolution algorithm and several optimizations
of it. Harrison does an alright job explaining it, but I like seeing a
complementary explanation alongside Harrison's.

A few honorable mentions:

- Jean H Gallier,
  _Logic For Computer Science: Foundations of Automatic Theorem Proving_.
  Second ed, Dover books, 2015.
- Melvin Fitting,
  _First-Order Logic and Automated Theorem Proving._
  Second ed, Springer, 1996.

Gallier's book discusses various algorithms for theorem provers working
on first-order logic, using pidgin Pascal pseudocode.

Fitting's book is a graduate-level presentation of similar material.

## Further Logic Reading

If the reader is unfamiliar with mathematical
logic, I can recommend a few books to brush up on it.

- Raymond Smullyan's _First-order logic_ (Dover, 1995) explains
  tableaux method in a very intuitive manner. This is the best book I
  know of on the subject.  It's **absolutely necessary** to read this
  to understand the tableaux method.
- Mendelson's _Introduction to Mathematical Logic_ is the standard
  textbook, implicitly framed in some Hilbert proof calculus. It
  formalizes NBG set theory. One problem with this book is that it
  fails to adequately distinguish the metatheory from the object theory,
  leading to horrible confusion.
  
  It might be worth referring to Heinz-Dieter Ebbinghaus, Jörg Flum,
  and Wolfgang Thomas's _Mathematical Logic_ (even the second edition)
  to balance Mendelson.
- Prawitz's _Natural Deduction_ is (quite literally) the textbook on
  natural deduction.
- Van Dalen's _Logic and Structure_ is decent introduction to proof
  theoretic aspects of logic.
- Kunen's _Foundations of Mathematics_ is quite honest about the
  foundations of Mathematics. Following the tradition laid down by
  [Hilbert's programme](https://plato.stanford.edu/entries/hilbert-program/), Kunen works with a finitary metatheory, uses it
  to formalize first-order logic, then introduces ZFC set
  theory. Kunen acknowledges we're not done yet: we need to use ZFC to
  introduce first-order logic once more, then use this new logic to
  construct a _new_ axiomatic set theory (which is where
  Mathematicians believe they work at). This four tiered foundation
  sounds insane, but it honestly is what Platonists think they're
  doing when operating as a Working Mathematician.
  
  Coincidentally, if you _just_ want to skip ahead to the fourth tier
  and work with this "_new_ axiomatic set theory" to formalize
  Mathematics, you will also need the third tier (the logic
  constructed using ZFC set theory) for the proofs. This is how
  Bourbaki started the _Elements of Mathematics_ in their very first
  volume: here's the logic, here's the set theory, now go
  have fun. How did we get there? Don't worry about, just take them
  and go.

Note we could also view proof assistants as a sort of "digital Hilbert
programme", where the "finitary metatheory" has been replaced by a
programming language.

## Set Theory reading?

As far as the axioms of set theory, they are almost all variations of
ZFC. Some include classes (NBG, MK, etc.).

If we want to do category theory, then we need some way to iterate
this procedure of "We have a notion of a collection Coll, we need the
collection of all Coll so we form a new notion Coll+. But now we need
the collection of all Coll+, so we form a new notion Coll++..." ---
this is precisely Tarski--Grothendieck set theory (= ZFC + axiom that
for any set there exists a Grothendieck universe containing it).

Without Tarski--Grothendieck set theory, we would run into problems
trying to formalize Kan extensions (and other stuff).

But since everything is a variation on ZFC, we could refer the curious
reader to:

- Thomas Jech,
  _Set Theory: The Third Millennium Edition_.
  Springer, 1997.

It might be a fun exercise to implement a proof assistant using
first-order logic plus set theory, which allows the user to allow or
deny the use of certain axioms. If a proof exists which does not use,
say, the axiom of choice, then there is a way to provide it. When the
user denies the axiom of choice, and tries to use a theorem which
requires the axiom of choice, then an error is raised.

This could allow investigating Feferman universes versus Grothendieck
universes (versus Tarski universes), predicative versus impredicative,
intuitionistic versus classical, etc. etc. etc.

For a review of the set theory needed for category theory, see:

- Mike Shulman,
  "Set theory for category theory".
  [arXiv:0810.1279](https://arxiv.org/abs/0810.1279), 39 pages.

# Type Theory Foundations

There are other foundations of mathematics besides logic. Type theory is
the other major family of foundations. Basically, type theory is lambda
calculus plus some additional structure. A good introduction which takes
the approach of adding structure iteratively:

- Benjamin Pierce, _Types and Programming Language_

Pierce's book is written for computer scientists interested in using
type theory in programming language theory. I think it beautifully
introduces a good fragment of the lambda cube, which coincides with
several different foundations of mathematics. But since the applications
to the foundations of mathematics is not explicit, this connection may
be too subtle to be appreciated.

A follow-up which focuses on applying the lambda cube to the foundations
of mathematics, specifically formal proofs, is:

- Rob Nederpelt, Herman Geuvers,
  _Type Theory and Formal Proof: An Introduction_.
  Cambridge University Press, 2014.
  
The focus in Nederpelt and Geuvers is specifically _formal proof_ in the
sense of theorem provers.

## Logical Frameworks

I would also recommend, after reading Pierce's book, reading:

- David Aspinall and Martin Hofmann,
  "Dependent Types".
  Chapter 2 of Pierce's _Advanced Types and Programming Languages_.

Dependent types give us sufficient power to create a "logical
framework"...a sort of language we can use to describe any logical
system. This uses a profound connection called the Curry-Howard
Isomorphism. 

Loosely, the Curry-Howard isomorphism comes in several flavors. For
logical frameworks, propositions are represented by types. An
implication connective is represented by a dependents type (a
generalization of the function type), _modus ponens_ is encoded by
function application. Other type operators encode other logical
connectives, and type theory gives us basic rules of inference for free.
(It turns out logical frameworks can encode _any_ logic we want.)

There are two major logical frameworks I think are worth looking into
further: LF and Automath.

### LF

Also called Edinburgh LF, this is the more recent of the two. It was
introduced in the paper:

- Robert Harper, Furio Honsell, Gordon Plotkin,
  "A Framework for Defining Logics".
  [Eprint](http://homepages.inf.ed.ac.uk/gdp/publications/Framework_Def_Log.pdf), 1993.

This is a bit involved, and some of it confusing (e.g., there is a
lambda abstraction for types, but this is never used). The basic idea is
to provide a formal language to describe logic. Judgments are
represented as types, and rules of inference are functions. A proof is
then a program. (The Twelf theorem prover implements these ideas.)

A couple gentler review articles:

- Frank Pfenning,
  "Logical Frameworks---A Brief Introduction."
  [Eprint](https://www.cs.cmu.edu/~fp/papers/mdorf01.pdf), 2002.
- Frank Pfenning,
  "Logical Frameworks".
  In Alan Robinson and Andrei Voronkov (eds.), 
  _Handbook of Automated Reasoning_, chapter 17, pages 1063–1147.
  Elsevier Science and MIT Press, 2001.
  [Eprint](https://www.cs.cmu.edu/~fp/papers/handbook00.pdf)

As I said, the original formulation of LF was rather baroque, with parts
of it not even used. What's trickier is we need to work with "canonical forms".
There's a version of LF where substitution then produces canonical forms
for us, simplifying life. This was presented as "Canonical LF" in the
paper:

- Robert Harper and Daniel R. Licata,
  "Mechanizing Metatheory in a Logical Framework".
  _J. Functional Programming_ **17** no.4-5 (2007) 613--673,
  [Eprint](https://www.cs.cmu.edu/~rwh/papers/mech/jfp07.pdf)

This paper also gives an example of using Twelf to formalize the
semantics of a programming language.

### Automath

I would also recommend, for the intrepid reader, another book:

- R.P. Nederpelt, J.H. Geuvers, R.C. de Vrijer,
  _Selected Papers on Automath_.
  Elsevier, 1994.

This is the selected papers of Nick de Bruijn, who invented the Automath
proof checker back in the '60s. It's one of the earliest programmes on
formalizing mathematics. Automath is the first logical framework
invented. De Bruijn independently discovered the Curry-Howard
isomorphism, and describes it quite beautifully in a number of articles
contained in the book.

Freek Wiedijk has implemented Automath in portable C and has some
examples of foundations formalized in Automath:

- Wiedijk's [Automath page](https://www.cs.ru.nl/F.Wiedijk/aut/index.html)
- [Automath Restaurant](https://www.cs.ru.nl/~freek/zfc-etc/) associated
  to the paper [Is ZF a hack?](https://www.cs.ru.nl/~freek/zfc-etc/zfc-etc.pdf)

This can be related to more modern type theories, which is done in the
article:

- Herman Geuvers, Rob Nederpelt,
  "Characteristics of de Bruijn's early proof checker Automath".
  _Fundamenta Informaticae_ **185** no.4 (2022)
  [arXiv:2203.01173](https://arxiv.org/abs/2203.01173)

One word of caution, though, Automath is based on a lambda-typed lambda
calculus, which is rather esoteric now. Most of the dependently-typed
lambda calculi use Pi types. A simple lambda-typed lambda calculus is
introduced in:

- Philippe de Groote,
  "Defining λ-Typed λ-Calculi by Axiomatizing the Typing Relation".
  In: Enjalbert P., Finkel A., Wagner K.W. (eds) _STACS 93. STACS 1993_.
  LNCS, vol 665. Springer, Berlin, Heidelberg, pp 712-723.

## Calculus of Constructions

The "highest corner" of the lambda cube is called the calculus of
constructions. Pierce's TAPL is a decent introduction to it.

Instead of merely "encoding" a logic (as a logical framework does), the
calculus of constructions handles a "deep embedding" of logics. 

As for _implementing_ a theorem prover based on it, a good paper:

- A. Asperti, W. Ricciotti, C. Sacerdoti Coen, E. Tassi,
  [A compact kernel for the calculus of inductive constructions](http://matita.cs.unibo.it/PAPERS/sadhana.pdf),
  73 pages.

The famous theorem prover based on the Calculus of Constructions is, of
course, Coq. For its foundations and usage, see:

- Pierre Castéran and Yves Bertot,
  _Interactive Theorem Proving and Program Development: Coq’Art: The Calculus of Inductive Constructions_.
  Springer, 2004.

## Homotopy Type Theory (briefly)

This is the new kid on the block, invented some time around 2006 (though
its origins can be dated back to the days of yore, i.e., 1998).
Initially HoTT (as Homotopy Type Theory is called) used Coq as its
preferred theorem prover, then Lean took over.

The theory underpinning HoTT is rather complicated. The simplest
version: when we have an equality `t=u`, we have a proposition. The
Curry-Howard correspondence encodes this as a type. HoTT replaces this
equality with a slightly weaker equivalence relation. As far as I can
tell, a type is viewed as a topological space, and the weaker
equivalence relation is encoded as a claim of homotopic equivalence.

I'm brusing a bit under the rug here. For example, this is _book equality_
or _judgemental equality_ which gives us a proposition `t=u`, as
opposed to _definitional equality_ which defines the identifier `t` to
be `u`. This distinction is critical in the calculus of constructions
(it was first introduced in Automath by Nick de Bruijn). HoTT replaces
'book equality' with another notion of equivalence.

There are still some difficulties with HoTT, and despite the hype I'm
not certain it's the panacea its advocates claim. (The difficulties
surrounding HoTT have to do with models of it, cubical set theory, which
I'm certain will be ironed out in the coming years.) I've yet to see any
paper discuss explicitly _how_ HoTT simplifies theorem prover
implementations, or is a boon. There is a _vast_ literature on HoTT, so
I can't say such a paper doesn't exist: I just haven't found it yet.

In fact, the only proof assistant which appears to explore HoTT seems
to be the [1Lab](https://1lab.dev/) experiment using [Agda](https://wiki.portal.chalmers.se/agda/pmwiki.php).

At the time I wrote this initially, the only book on
the topic of HoTT was [the HoTT book](https://homotopytypetheory.org/book/). 
There have been a couple books introduced more recently, for example:

- Egbert Rijke,
  _Introduction to Homotopy Type Theory_.
  Cambridge University Press, also available at
  [arXiv:2212.11082](https://arxiv.org/abs/2212.11082); 359 pages in
  the PDF. **This is the best introduction I can recommend.**
- Marc Bezem, Ulrik Buchholtz, Pierre Cagne, Bjørn Ian Dundas, and 
  Daniel R. Grayson,
  _The Symmetry Book_.
  [Latest draft PDF](https://unimath.github.io/SymmetryBook/book.pdf)
  clocks in around 240 pages.
  
  I dislike some aspects of this book --- for example, a "type" is
  **just** a "label", it is ***NOT*** a set. Calling a term `t` of
  type `T` an "element of `T`" is insane, especially since we can have
  `Element` be a type operator (which happens in, e.g., Mizar's soft
  type system).
  
  Just skim until section 2.5 and you'll be fine. You're not reading
  this to learn type theory, you're reading this to learn HoTT and
  specifically the representation theory of groups as formalized in HoTT.

# Higher Order Logic

The third family of foundations of mathematics, higher order logic, may
be thought of in terms of type theory (second-order lambda calculus with
base types `prop` and `indiv` for propositions and non-logical
constants, a predicate is then a term of type `indiv -> prop` or more
generally `a -> prop` for any type `a`, a quantifier is a term of type 
`(a -> prop) -> prop` eating in a predicate and producing a proposition).

An introduction to second-order logic:

- Steward Shapiro,
  _Foundations without Foundationalism: A Case for Second-order Logic_.
  Oxford University Press, 1991.

It's rather eye-opening how mathematicians implicitly work in some
fragment of second-order logic, and Shapiro provides several damning
examples.

Another presentation of higher-order logic from the category theory
perspective may be found in:

- J. Lambek, PJ Scott,
  _Introduction to Higher-Order Categorical Logic_.
  Cambridge University Press, 1989.

For a "no nonsense" presentation of higher-order logic _and_
first-order logic in a Hilbert proof calculus, see:

- Peter B Andrews,
  _An Introduction to Mathematical Logic and Type Theory: To Truth Through Proof_.
  Second ed., Springer, 2002.

HOL Light is based on a slight variant of this presentation. John
Harrison has put a lot of his [publications
online](https://www.cl.cam.ac.uk/~jrh13/papers/index.html), and a good chunk are
related to his HOL Light prover.

As far as implementation, there is the classic (but out-of-print and
horribly expensive) book:

- MJC Gordon and TF Melham (eds.),
  _Introduction to HOL: A Theorem Proving Environment for Higher Order Logic_.
  Cambridge University Press, 1993.

Some of it has been revised and maintained for current HOL
implementations as the [HOL Documentation](http://hol.sourceforge.net/documentation.html).

## Metalogical frameworks

Note that HOL forms a "metalogical framework" --- logical frameworks
allowed us to define a logic and emulate reasoning with that
logic. But how would we be able to prove things like "Logic _A_ has
property _P_"? A logical framework cannot do this.

This might not sound exciting, but it's useful to prove _formally_
things about a logic. Like soundness.

In fact, [CakeML](https://cakeml.org/) seems to be using this aspect
of HOL to prove the correctness of its implementation, as well as
various other "niceness properties" of its language and toolchain. 

## HOL as a logical framework

Every metalogical framework is a logical framework with some extra
power.

But we can use a _fragment_ of intuitionistic HOL to form a logical
framework. This is precisely what
[Isabelle](https://isabelle.in.tum.de/)'s Pure is: a fragment of
intuitionistic higher-order logic suitable for formalizing other logics.

When we implement logic X in Isabelle, we refer to the implementation
as "Isabelle/X".

It's great for things like exploring the design space of proof
assistants and the foundations of mathematics.

# Changelog

It's been a while since I first wrote this --- I wrote it initially as
a response to some questions on a forum, then some emails, and just
decided to cobble them all together into a post. But times change, and
parts of this post need revising as life moves along.

I guess I should probably keep a log of the amendments made.

- <span><time datetime="2024-09-11">2024 September 11</time> --- added more
  references in the logic section, added book references in HoTT,
  noted the difference between book equality and definitional
  equality, mentioned HOL as logical and metalogical frameworks.
  Thanks to Geoffrey Churchill for the reference to the _Symmetry Book_
  and reminding me to update this post to link to Rijke's book.</span>
