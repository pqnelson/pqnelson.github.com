---
layout: post
title: Pattern Matching in Lisp
published: true
draft: false
quote: "A mathematician, like a painter or a poet, is a maker of patterns. If his patterns are more permanent than theirs, it is because they are made with ideas."
quoteSource: GH Hardy, <i>A Mathematician's Apology</i> (1941)
tags: [Lisp]
---


# Patterns and Rules

Pattern matching is done by using **"Rules"**. A "rule" consists of
three elements:

1. A "pattern" to match against.
2. Some optional extra conditions.
3. A "skeleton" which tells a rewrite-system what to do with the matches.

The pattern specifies the class of expressions it matches. Patterns
contain constants and pattern variable which indicate arbitrary elements
or _segments_ (sequences of elements). A pattern variable matching a
single element is prefixed by a single question mark, and segment
variables matching multiple elements are prefixed by two question marks:
`(? pattern)` and `(?? segment)`.

We can further refine our pattern matching using predicates. For
example, if we want to match a single element which is a pattern, we
would write `(? n numberp)` (or, in Scheme, something like
`(? n number?)`).

We say a rule is **"Applicable"** to an expression if the rule's pattern
matches the provided expression.

Once a rule is applicable, we _instantiate_ the skeleton to create an
expression with the matched subexpressions.

## Examples

Sussman and Harold report roughly 30 rules suffice for an algebraic
simplifier. An example rule might be:

```lisp
( (* (?? x) (? z zerop) (?? y)) ; pattern
  nil                           ; extra conditions
  0)                            ; skeleton
```

It tells us, whenever we multiply something by zero, we replace it by zero.
We can encode the law of logarithms as:

```lisp
( (log (* (? x) (? y) (?? zs)))            ; pattern
  nil                                      ; extra conditions
  (+ (log (? x)) (log (* (? y) (?? zs))))) ; skeleton
```

Replacing squares of cosines by squares of sines are handled by the
rule:

```lisp
( (expt (cos (? x)) (? n at-least-two?)) ; pattern
  nil                                    ; extra conditions
  (* (expt (cos (? x)) (? (- n 2)))      ; skeleton
     (- 1 (expt (sin (? x)) 2))) )
```

An example using extra conditions requires non-negative factors in
squareroots to factor them out:

```lisp
( (sqrt (* (? x) (? y) (?? ys)))              ; pattern
  (and sqrt-factor-simplify?                  ; extra conditions
       (non-negative-factors x y 'free-var))
  (* (sqrt (? x)) (sqrt (* (? y) (?? ys)))) ) ; skeleton
```

If either `(? x)` or `(? y)` match a negative factor, it's caught in the
`(non-negative-factors x y 'free-var)` subexpression (and then bound to
`'free-var`). This pattern will fail to match if we have "turned off"
`sqrt-factor-simplify?`, or if either `(? x)` or `(? y)` are negative
factors.

# Basic Implementation

The idea is for a `match` function to accept a pattern and an
expression, then produce either a dictionary of bindings (to encode what
pattern & segment variables match which subexpressions) or the `:fail`
symbol, upon success or failure (respectively).

Assuming success, we have a `substitute-in` function to take a rule
skeleton and a dictionary of bindings, then use the skeleton as a
blueprint for a new expression (replacing the pattern variables with
their bound values).

Sounds good? Great, let's dissect these functions at bit further.

## Matching Patterns Against an Expression

There are several cases we need to consider:

1. If we have failed, we should set the dictionary to `:fail`, and bail
   out.
2. If the pattern is a pattern variable, then we should check the
   expression matches the pattern variable (relative to whether we've
   already bound the variable in our dictionary). This is handled by
   a `match-element` helper function.
3. If the pattern is just some constant, then...well, we're nearly done!
   So check the expression is the same constant. If so, return the
   dictionary; otherwise, we've failed, and return `:fail` instead of a
   dictionary.
4. If the pattern is a segment variable, we delegate the messy work to
   a `match-segment` helper function.
5. If the pattern is a list --- some complicated S-expression --- which
   is our default case, we form `new-bindings` trying to match the head
   of the pattern with the head of the expression. Unless `new-bindings`
   is a `:fail`-ure, we recursively `match` on the rest of the pattern
   against the rest of the expression.

This is the simplest, straightforward implementation of the intuition
underlying pattern matching as we've described it.

The most complicated routine among these are the `match-segment` helper
function. This boils down to checking if the segment variable has
already been bound in our attempt; if so, we check the previous binding
to the current subexpression. If the current situation fits the previous
binding, then we recursively call `match` on the rest of the pattern and
remaining part of the expression with the same dictionary.

If the segment variable is "fresh" (not written down in our dictionary),
then we need to search for new bindings. This amounts to looping through
prefix subexpressions, iteratively trying to match this leading
subexpression to the segment variable, then testing if we can
successfully move on with the rest of the pattern. This is a depth-first
search, which successively backtracks to expand the segment-variable's
match. Upon the first success with matching the smallest prefix to the
segment variable _and_ the rest of the pattern to the remaining part of
the expression, we return these bindings. And if we've exhausted all
possibilities, we return `:fail`. (This messy iterative "check each
prefix until success or death" is handled by `try-segment-bindings`.)

Everything else is fairly straightforward, and when the dust settles the
`match` routine gives us bindings or bitter `:fail`. What do we do with
the bindings?

## Substitution, Hydrating the Rule Skeleton

We then take our bindings and substitute the values for the associated
variables into the skeleton. This recursively is handled:

1. If the skeleton is `nil`, return `nil`.
2. If the skeleton is a pattern variable `(? x)`, return the associated
   value bound to it in our dictionary.
3. If the skeleton is a list, well, we have several subcases:
   - If the skeleton looks like `((?? x) . e2)` a segment variable
     followed by some prefix, then we concatenate (a) the value
     associated to it with (b) the substitution of the rest of the
     skeleton `e2` with the dictionary bindings (Recursion!).
   - Special macros can be handled here (for example `(:EVAL (stuff))`
     or `((:SPLICE (stuff)) remainder)`).
   - Otherwise the skeleton looks like `(e1 . e2)`, so we just create a
     list formed by cons'ing (a) the substitution of `e1` with the
     bindings from the dictionary to (b) the substitution of `e2` with
     the bindings. (Recursion!)
4. In all other cases, we just return the skeleton itself.

In other words, this is a straightforward implementation of a
substitution algorithm. There is some room for novelty, as noted by
using "special macros" like `:SPLICE` or `:EVAL` (the latter
particularly handy with a simplifier for symbolic algebra).

# Full Implementation, Parting Words

There are a few full implementations, probably the most complete may be
found in [SCMUTILS](https://groups.csail.mit.edu/mac/users/gjs/6946/refman.txt).
I've implemented [one](https://github.com/pqnelson/auto-pse/blob/master/src/match.lisp)
for my problem solving environment (with some [algebraic simplification rules](https://github.com/pqnelson/auto-pse/blob/master/src/simplify.lisp)).

The only caveats worth mentioning are, well, we've been assuming that
we've been working with S-expressions. What happens if we have used CLOS
or structures for subexpressions? We can't iterate through the
constituents of a CLOS object with `car` and `cdr` anymore. This
requires either rewriting the code, or using some multimethod instead of
`car` and `cdr`. (We must have some convention about the ordering of
constructor arguments and order of presentation of constituents, for
this scheme to work.)

# References

- Gerald Sussman,
  "Structure and Interpretation of Computer Programming Course"
  [Lecture 4A](https://youtu.be/amf5lTZ0UTc). This was not contained in
  the book, alas.
- Harold Abelson and Gerald Jay Sussman,
  "Lisp: A Language for Stratified Design".
  MIT AI Memo AIM-986, August 1987.
  [Eprint](https://dspace.mit.edu/handle/1721.1/6064).
- Kenneth D. Forbus and Johan de Kleer,
  _Building Problem Solvers_.
  MIT Press, 1993. Available [online](https://www.qrg.northwestern.edu/bps/readme.html).
  See pp. 46 et seq. in the print book (pp. 64 et seq. of the PDF).
- Peter Norvig,
  _Paradigms of Artificial Intelligence Programming_.
  Morgan Kaufmann Publisher, 1992.
  [Chapter 6](https://github.com/norvig/paip-lisp/blob/master/docs/chapter6.md)
-