---
layout: wiki
title: Lisp Grammar
published: true
date: 2021-02-27
parentURL: /wiki/comp-sci/lisp/
---

The basic grammar for Lisp, in BNF, may be written roughly as:

```abnf
s-expression = atom / "(" list ")"
list = blank / s-expression list

start = program
program = blank / start s-expression
```

Atoms are symbols, numbers, booleans, strings.

**Fact 1.** _This grammar is LL(1)._ (End of fact 1.)

We interpret the first element of a list as a function symbol or
operator, and function calls are encoded using lists. There are about a
half dozen "primitive functions" provided by Lisp to define new
functions, access list elements, and so on.