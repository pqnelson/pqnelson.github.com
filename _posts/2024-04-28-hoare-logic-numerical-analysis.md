---
layout: post
title: Hoare Logic for Numerical Analysis
published: false
use_math: true
draft: true
quote: "Surely, we compute only when everything else fails, when mathematical theory cannot deliver an answer in a comprehensive, pristine form and thus we are compelled to throw a problem onto a number-crunching computer and produce boring numbers by boring calculations. This, I believe, is nonsense."
quoteSource: Arieh Iserles, <i>A First Course in the Numerical Analysis of Differential Equations</i> (2009)
tags: [Numerical Analysis, Hoare Logic]
---

Broadly speaking, design-by-contract implements Hoare logic in an actual
programming language, and I want to consider whether it is plausible to
implement numerical analysis code using design-by-contract techniques.

# Case Study: Squareroot

I will be using C for my programming language and
[ACSL](https://frama-c.com/html/acsl.html) for my assertion
language. The toy problem we will study will be the square root of a
number, computing $\sqrt{x}$ for $x\in\mathbb{R}$ non-negative $x\geq0$.

We can use Newton's method (a.k.a., the Babylonian method). If we know
that $x_{0}^{2}\leq x\leq (x_{0}+1)^{2}$, then $x_{0}$ is our initial
guess for the squareroot. Then we compute
$(x_{0}+\varepsilon)^{2}\approx x_{0}^{2}+2x_{0}\varepsilon=x$, which we
can solve for $\varepsilon=(x-x_{0}^{2})/(2x_{0}$ and this gives us
$x_{1}=x_{0}+\varepsilon$ (the next iteration). This gives us a sequence
of real numbers $x_{0}$, $x_{1}$, $x_{2}$, ..., which converges to
$\sqrt{x}$.

We can use the
[`frexp`](https://pubs.opengroup.org/onlinepubs/009696899/functions/frexp.html)
function 
to extract the exponent of `x=m2^{n}` where $1\leq m<2$ and
$n\in\mathbb{Z}$ then use this to approximate $x_{0}=2^{\lfloor n/2\rfloor}$ 
to get the correct order-of-magnitude estimate for the squareroot.