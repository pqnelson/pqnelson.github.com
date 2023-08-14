---
layout: wiki
title: Ideas for Posts
published: true
date: 2021-11-04
parentURL: /wiki/
---

This is some rather haphazard collection of ideas for posts.

# Making a Lisp Machine

I've written some about the [architecture of the I-Machine](/org-notes/comp-sci/lisp/machine/i/architecture.html)
and Peter Kogge's _The Architecture of Symbolic Computers_ asserts that
Lisp Machines are glorified [SECD Machines](/org-notes/comp-sci/abstract-machines/secd.html).
It would be interesting to do something like the following:

- Determine "How much to add" to an SECD machine before we get a Lisp
  Machine
- Write a compiler for a Lisp targetting SECD
- Write a virtual machine for SECD, and keep improving it until we get
  something resembling a Lisp Machine
  
This would be all just a toy model. Making it actually performant, well,
that would require a lot of dull work.

## SECD Machine

On a similar note, has anyone written _anything_ nice about SECD
machines? It seems like Landin introduced it, and that was
it. Afterwards, it's been rather coarse. Perhaps writing a literate
implementation of SECD would be a fun exercise?

I am aware of Danvy's [A Rational Deconstruction of Landin's SECD Machine](https://www.brics.dk/RS/03/33/).
It's nice, but after walking away from it for a while...I honestly don't
think I could reconstruct the SECD machine from my recollections alone.
(See also [arXiv:0811.3231](https://arxiv.org/abs/0811.3231).)

Maybe I should examine how Landin does it in his original article, "The
Mechanical evaluation of Expressions"...

## Making a (Common) Lisp

I've been playing with Common Lisp in my spare time on my Raspberry Pi,
it would be fun to [Make a Lisp](https://github.com/kanaka/mal) in the
Common Lisp dialect. This would be written in some suitably nice C. (I
guess this is just _Lisp in Small Pieces_...just done worse?)

This also would give me some minimal language (LISP!) to play with while
exploring design decisions other languages have made. Want a string pool
like Java? Experimenting with different garbage collectors?
Thinking about laziness? We can explore these!

# Standard ML Code

I've written a little about programming in Standard ML, and tinkered
with monads in Standard ML. I'd like to continue investigating monads by
implementing them in SML.