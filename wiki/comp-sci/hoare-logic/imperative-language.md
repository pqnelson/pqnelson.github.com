---
layout: wiki
title: Imperative Language - Hoare Logic
published: true
date: 2021-02-14
parentURL: /wiki/comp-sci/hoare-logic/
---

Hoare logic works with an Algol-like language (later texts used
Pascal-like syntax). I'm going to make explicit the syntax and semantics
of the language in this note, so I won't repeat myself over and over. As
a compromise, I'm going to use Free Pascal's syntax for
[statements](https://www.freepascal.org/docs-html/ref/refch13.html#x157-17900013)
and
[expressions](https://www.freepascal.org/docs-html/ref/refch12.html#x141-16300012).

For simplicity, we will focus on integer and Boolean expressions. In
EBNF, the grammar would look like:

```ebnf
expression = int-expr | bool-expr ;

int-expr = integer
         | "(" int-expr ")"
         | int-expr int-bin-op int-expr
         | "-" int-expr ;

int-bin-op = "+" | "-" | "*" | "/"
           | "=" | "<>" | "<" | "<=" | ">" | ">=" ;

integer = ["-"] NONZERO-DIGIT {DIGIT} | "0" ;
NONZERO-DIGIT = "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
DIGIT = "0" | NONZERO-DIGIT ;

bool-expr = "True" | "False"
          | "(" bool-expr ")"
          | "Not" bool-expr
          | bool-expr bool-bin-op bool-expr ;

bool-bin-op = "and" | "or" | "xor" | "=" | "<>" ;
```

The statements are:

```ebnf
statement = assignment | if-else | while-do | compound-statement ;

assignment = identifier ":=" expression ;

if-else = "If" bool-expr "then" statement "else" statement ;

while-do = "While" bool-expr "do" statement ;

compound-statement = "begin" statement ";" {statement ";"} "end" ;
```

The semantics are, well, defined by Hoare logic itself.

# Operational Semantics

If we consider an associative array from identifiers (variables) to
their current values (i.e., we can specify the current state), then we
may define the operational semantics for our language. We will write
`s[x:=v]` for extending the state `s` by the following steps:
1. If `s` contains `x`, then update its value to be `v`
2. If `s` does not contain `x`, then extend it by adding the entry
   associating `v` to `x`

The statements have the following semantics:
- **Assignment.** If in state `s` the expression `e` evaluates to value
  `v`, then the assignment statement `x := e` updates the state to
  `s[x := v]`.
- **Sequence.** If in state `s` the statement `c1` transforms the state
  to `s'`, then the sequence of statements `c1; c2` becomes statment
  `c2` evaluated in state `s'`.
- **If true.** Suppose, in state `s`, the Boolean expression `b`
  evaluates to `True`, and that the statement `c1` transforms state `s`
  into state `s'`. Then in state `s`, the statement
  `If b then c1 else c2` transforms the state `s` into state `s'` (i.e.,
  it amounts to executing the "true" branch).
- **If false.** Suppose, in state `s`, the Boolean expression `b`
  evaluates to `False`, and that the statement `c2` transforms state `s`
  into state `s'`. Then in state `s`, the statement
  `If b then c1 else c2` transforms the state `s` into state `s'` (i.e.,
  it amounts to executing the "false" branch).
- **While false.** Suppose, in state `s`, the Boolean expression `b`
  evaluates to `False`. Then in state `s` executing the statement
  `while b do c` does not alter the state of the computer (i.e., the
  body of the loop is not executed, there is no iteration).
- **While true.** Suppose, in state `s`, the Boolean expression `b`
  evaluates to `True`; and suppose statement `c` transforms state `s`
  into `s'`. We also assume that, when executing the loop
  `while b do c` in state `s'` that it will terminate in state `s''`.
  Then in state `s` executing the statement
  `while b do c` transforms the computer to be in state `s''`.

# References
- Kasper Svendesn, "Hoare Logic and Model Checking".
  Cambridge University Slides 2016,
  [PDF](https://www.cl.cam.ac.uk/teaching/1617/HLog+ModC/slides/lecture2-4.pdf)
- Abhishek Kr Singh, Raja Natrajan,
  "An Outline of Separation Logic".
  [arXiv:1703.10994](https://arxiv.org/abs/1703.10994)