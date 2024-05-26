---
layout: post
title: Retrocomputing Projects for the Bored and Insane
published: true
quote: "Stories are much tidier than real life. Stories have neat, happy endings, but all you ever really get is unfinished business."
quoteSource: Sandy Mitchell, <i>For the Emperor</i> (2003)
tags: [Retrocomputing]
---

I've been accumulating some ideas which would be neat but consume too
much time for me to actually do.

If you are working on this, or know anyone who has done what I've asked,
drop me an email me: I'd love to learn more about it!

# Lisp Machine on Raspberry Pi

Looking at the Symbolics I-machine, write suitable microcode for a
Raspberry Pi to turn it into a Lisp machine. After all, the original
Lisp Machines were microcoded atop a RISC processor.

Bitsaver has [a few](http://www.bitsavers.org/pdf/symbolics/I_Machine/)
documents concerning the I-machine, which may be useful.

Write a series of blog posts ("Lisp Machine in Small Pieces"?)
explaining the implementation of such a thing.

Kogge remarked the Lisp machine was little more than an SECD machine. He
was right, but this is a natural starting point for expository purposes.

# FORTRAN II Compiler

The original FORTRAN I Compiler has been lost to the sands of time. But
the FORTRAN II Compiler has been preserved, printed and bound in three
volumes stored at the Smithsonian. (See the [Computer Museum
page](https://www.softwarepreservation.org/projects/FORTRAN/) on FORTRAN
I and II.) Unfortunately, the FORTRAN II compiler is written entirely in
assembly code for the IBM-704.

Fortunately, Donald Knuth's MIX computer is remarkably similar to the IBM-704.

Translate FORTRAN II into MIX assembly code. Present it in LaTeX (or
pure TeX) as a series of "algorithms" and "programs" as Donald Knuth
does it in _The Art of Computer Programming_ with commentary alongside
the assembly code. 

# Space Cadet Mechanical Keyboard

Figure out a way to create a mechanical keyboard replica of the famous
Space Cadet.

Or, failing that, a UNIX Keyboard (like the Sun keyboard).

# MIX implementation

I know there is a verilog implementation of the MIX computer (as
documented in Donald Knuth's _The Art of Computer Programming_). But
think about some clever ways to implement a punchcard reader using, I
don't know, hole punched index cards.

Also think about the other peripherals which are not readily available
(e.g., magnetic tape). What are some faithful approximations to them
which we can build at home?

If you're really feeling spicy, consider proving the correctness of the
verilog implementation using Isabelle/HOL's verilog library.

Most importantly, write a series of blog posts documenting your progress!