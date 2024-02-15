---
layout: post
title: Get started quick with Isabelle
published: true
draft: false
quote: "Mathematics offers a common language across borders. It is a real joy."
quoteSource: Alice Fialowski, <i>Women in Mathematics Throughout Europe. A Gallery of Portraits</i> (2016)
tags: [Isabelle,Automated Theorem Prover]
---

There's a lot of old and antiquated documentation, tutorials, etc.,
about Isabelle which is out of date. Here is yet another one, 
which works for Isabelle2023.

# Installation

[Installing](https://isabelle.in.tum.de/installation.html) Isabelle is
extraordinarily simple: just download Isabelle, and add it to
your path environment variable. Or you could just invoke
`path/to/Isabelle2023/Isabelle2023` directly to get Isabelle's jEdit,
and `path/to/Isabelle2023/bin/isabelle` for the tool to create
new projects, compile documentation, etc.

# Getting Started

Isabelle is a logical framework, which means it implements deductive
systems. Unlike, say, Automath, Isabelle uses a fragment of
intuitionistic higher-order logic. (This coincides with the spirit of
Hilbert's programme, using an intuitionistic and finitistic metatheory.)

The terminology used in Isabelle is that there is the "metalogic" called
"Pure", and then there is the "object logic" (HOL, FOL, ZF, type theory,
etc.) which is implemented in Isabelle. The implementation is called
"Isabelle/X" where X = HOL, FOL, ZF, etc.

There are several ways to approach using (or studying) Isabelle:
- We could implement an object logic
- We could use one of the already implemented object logics to formalize
  something 
- Etc.

The most developed object logic with sophisticated tools is
Isabelle/HOL. "Morally" HOL = functional programming language + logic.
If you thought Haskell was pure, then Isabelle/HOL is the uncut stuff.

***If you are a programmer***, then you probably want to work with
Isabelle/HOL as a programming language. Gerwin Klein and Tobias Nipkow's
_Concrete Semantics_ studies the semantics of a simple imperative
programming language using Isabelle/HOL; it's a great introduction,
[has a website](http://concrete-semantics.org/) with useful things like slides from lectures, and is
legally and freely available [online](http://concrete-semantics.org/concrete-semantics.pdf).

## Your first theorem

Getting more to the point, suppose you have `~/src/hack/` be the
directory for your exciting new project. You can populate it with all
the relevant subdirectories by running:

```
alex@avocado:~/src/hack/$ ~/src/Isabelle2023/bin/isabelle mkroot -A "Alex Nelson" .

Initializing session "hack" in "/home/alex/src/hack"
  creating "ROOT"
  creating "document/root.tex"

Now use the following command line to build the session:

  isabelle build -D .

alex@avocado:~/src/hack$ ls
document  ROOT

alex@avocado:~/src/hack$ mkdir hack
```

Now you can open up Isabelle/jEdit by running the command:

```
alex@avocado:~/src/hack$ ~/src/Isabelle2023/Isabelle2023
```

Create a new file `~/src/hack/hack/hack.thy` which starts a new "theory"
file, which is an Isabelle file. Then copy/paste the following into it:

```isabelle
theory hack
  imports Main
begin

end
```

This is the template for all Isabelle files. The `imports` tells
Isabelle which theories to import --- `Main` refers to the main
libraries in Isabelle/HOL.

Now, to double check that everything is working fine, try the following
theorem proving concatenating lists is associative:

```isabelle
theorem list_app_assoc: "(xs @ ys) @ zs = xs @ (ys @ zs)"
  apply auto
  done
```

Just copy/paste this somewhere after `begin` but before `end`. If
everything works, then you'll get in the output tab something like:

```
theorem list_app_assoc: (?xs @ ?ys) @ ?zs = ?xs @ ?ys @ ?zs
```

Again, you'll probably want to work through the _Concrete Semantics_
book to get up to speed in Isabelle/HOL. There is some loose coding
conventions which may be found:

- [Coding conventions](https://isabelle.systems/conventions/)

## Documenting your code

Documentation is really important, if only to remember what you were in
the middle of doing. This can be done writing:

```isabelle
text \<open>
This is an example of some comments I am writing. When I build the
documentation, this will be extracted and pretty-printed in LaTeX.
\<close>
```

The `\<open>` and `\<close>` will be pretty-printed in jEdit as
cartouches (the funny angled braces `‹` and `›`, respectively).

Depending on what you're doing, the level of documentation will vary. It
has sadly become conventional to have just header documentation for your
theory file, when formalizing mathematics or programming with
Isabelle/HOL. I don't know how I feel about this, but my feelings are
probably irrelevant anyways.

The entire implementation of Isabelle has a fairly literate
[documentation](https://isabelle.in.tum.de/dist/Isabelle2023/doc/implementation.pdf) 
assembled from the `text` blocks of the code implementation.

## Example Projects

Consider implementing a proof assistant using Isabelle/HOL.

- Alexander Birch Jensen, John Bruntse Larsen, Anders Schlichtkrull, and Jørgen Villadsen,
  "Programming and Verifying a Declarative First-Order Prover in Isabelle/HOL".
  Eprint [PDF](https://backend.orbit.dtu.dk/ws/portalfiles/portal/149476669/AIComm.pdf), 21 pages.
  [Github repo](https://github.com/logic-tools/sml-handbook) for the code.
- Jørgen Villadsen, Anders Schlichtkrull and Andreas Halkjær From,
  "A Verified Simple Prover for First-Order Logic".
  _Proceedings of the 6th Workshop on Practical Aspects of Automated Reasoning (PAAR 2018_
  http://ceur-ws.org/Vol-2162/
  [Github code](https://github.com/logic-tools/simpro), see especially [Proven.thy](https://github.com/logic-tools/sml-handbook/blob/master/code/SML/Proven.thy)

Consider implementing a different axiomatization of set theory, like
Morse-Kelley or helping with the NBG formalization.

- [NBG/HOL](https://github.com/ioannad/NBG_HOL)

Consider formalizing a purely functional programming using Isabelle/HOL,
and you could implement an "abstract machine" (virtual machine) for
it. Then you could prove properties about its semantics and whatnot.

# Examples Implementing new Logics

I'm not going to implement an object logic here, because that could
easily take an entire masters or doctoral thesis. But here are a few
papers which do exactly that:

- Joshua Chen,
  "An Implementation of Homotopy Type Theory in Isabelle/Pure".
  Master's thesis, [arXiv:1911.00399](https://arxiv.org/abs/1911.00399)
- Tobias Nipkow, Simon Roßkopf,
  "Isabelle's Metalogic: Formalization and Proof Checker".
  [arXiv:2104.12224](https://arxiv.org/abs/2104.12224), 18 pages. 
  This formalizes Isabelle's "Pure" metalogic in Isabelle/HOL!
  
# Further reading

The documentation is always a good place to turn when you need help, but
the proofassistants stackexchange (and the Isabelle zulip chat) are also
good.

- [Isabelle's documentation](https://isabelle.zulipchat.com/)
- [Proofassistants.stackexchange](https://proofassistants.stackexchange.com/)
- [Zulipchat](https://isabelle.in.tum.de/documentation.html) for Isabelle