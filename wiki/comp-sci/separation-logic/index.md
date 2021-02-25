---
layout: wiki
title: Separation Logic
published: true
date: 2021-02-14
parentURL: /wiki/comp-sci/
---

Hoare logic limited focus to a simple imperative language without memory
management. Separation logic extends Hoare logic to include reasoning
about pointers and memory. We model the heap as an infinite array of
memory cells, indexed by non-negative integers called **"Addresses"** or
"locations". Further, we add the following types of commands for
handling pointers and memory:

1. `<var> := alloc(<exp>, ..., <exp>)` allocates `n` consecutive memory
   cells holding the values produced from the given expressions, and
   assigns the value of `<var>` the address of the leading memory cell
2. `dispose(<exp>)` evaluates the expression given, interprets it as a
   memory address, and
   - if the memory address is valid and has been assigned and has not
     yet been freed, then it frees the one single cell at that location
   - otherwise, a memory fault occurs, the program aborts, and all
     memory cells allocated by the program are freed.
3. `V := [E]` will evaluate expression `E`, treat it as a memory
   address, look up the contents of memory at that address, copy
   that value and assign it to the variable `V`
4. `[E] := E'` will evaluate `E` as a memory location, then set its
   contents to the value produced by evaluating the expression `E'`.



# References
- John C. Reynolds, [Separation Logic: A Logic for Shared Mutable Data Structures](https://www.cs.cmu.edu/~jcr/seplogic.pdf)
- Abhishek Kr Singh, Raja Natrajan,
  "An Outline of Separation Logic".
  [arXiv:1703.10994](https://arxiv.org/abs/1703.10994), 20 pages