---
layout: post
title: Notes on Automated Theorem Proving, Part I - Propositional Logic
published: true
quote: "Logic, like grammar, appears in two different aspects or values. It is one thing for him who comes to it for the first time, but it is another thing for him who comes back to it from the sciences. He who begins the study of grammar finds in its forms and laws dry abstractions, arbitrary rules. On the other hand, he who has mastered a language and at the same time has a comparative knowledge of other languages, he alone can make contact with the spirit and culture of a people through the grammar of its language. Similarly, he who approaches this science at first finds in logic an isolated system of abstractions which, confined within itself, does not embrace within its scope the other knowledges and sciences."
quoteSource: GWF Hegel, <em>Science of Logic</em> &sect;70
---

**Introduction.**
I will be starting a series on my endeavor to implement an automated
theorem prover. In this article, we will implement an automated theorem
prover for classical propositional logic. In the next article we will
begin exploring first-order ("predicate") logic, again classical.

If the reader does not know propositional logic, I strongly urge the
reader to consult Elliot Mendelson's *Introduction to Mathematical
Logic* (or something similar) for details...because I will give a
comical overview of the bare bones necessary to ask questions. No
pretension of completeness here!

All the code is available on
[github](https://github.com/pqnelson/surak), checkout `v0.0.2` for the
code relevant to this post.

**1. Overview of Propositional Logic.** 
We have some
[formula](http://en.wikipedia.org/wiki/Propositional_formula), built up
from propositional variables and logical operators ("and", "or", "not",
etc.). We have some
[valuations](http://en.wikipedia.org/wiki/Valuation_%28logic%29), which
evaluate the propositional formula as either true or false. (Think of a
valuation as picking one particular row of a truth table.)

A propositional formula is said to be a
["**Tautology**"](http://en.wikipedia.org/wiki/Tautology_(logic)) or
*Valid* if it is always true in every valuation (for example "*A* or not
*A*", we have two possible valuations: (i) *A* is false, in which case
the proposition evaluates to "false or true", i.e., true; (ii) *A* is
true, in which case the proposition evaluates to "true or false", i.e.,
true).

A propositional formula is said to be
["**Satisfiable**"](http://en.wikipedia.org/wiki/Satisfiability) if
there is at least one valuation which makes it true.

A propositional formula is said to be "**Unsatisfiable**" (or a
*Contradiction*) if there are no valuations which make it true.

The basic questions we ask ourselves is "Given a propositional formula,
is it a tautology? Is it satisfiable? Is it unsatisfiable?"

The challenge here is, the naive way to answer "A formula is a
tautology" is to check all possible valuations. If there are `n`
propositional variables in the formula, that's `2^n` possible
valuations. We have an
[NP-Complete Problem](http://en.wikipedia.org/wiki/Boolean_satisfiability_problem)!

**Remark.** Observe that a formula `f` is satisfiable if and only if `f`
is not unsatisfiable.

Also, a formula `f` is a tautology if and only if `not f` is unsatisfiable.

Although all tautologies are satisfiable formulas, not all satisfiable
formulas are tautologies...just as all trout are fish, but not all fish
are trout. (End of Remark)

## A Vanilla Automated Theorem Prover for Propositional Logic

**2. Abstract Syntax Tree.**
The basic data structure we'll work with is a `Formula`, which is either
true `T`, false `F`, a propositional variable, or something involving a
logical operator among formulas. A propositional variable is represented
as `PropVar` just an alias for a string.

```haskell
type PropVar = String --- Proposition variables are strings

data Formula = F
             | T
             | Atom PropVar
             | Not Formula
             | And Formula Formula
             | Or Formula Formula
             | Implies Formula Formula
             | Iff Formula Formula
               deriving (Show, Eq)
```

When we get to first-order logic, we will extend this to include quantifiers.

**Remark.**
If someone were curious what sort of syntax we should be supporting, I
would think the
[TPTP syntax](http://www.cs.miami.edu/~tptp/TPTP/SyntaxBNF.html) would
be best. But since that would distract us too much from the interesting
problem, so we leave it as an exercise for the reader ;) (End of Remark)

**3. Valuations.**
We need
[valuations](http://en.wikipedia.org/wiki/Valuation_%28logic%29), that
is, functions which evaluate an `PropVar` to be either `True` or
`False`. So we just create an alias:

```haskell
type Valuation = PropVar -> Bool
```

We will be modifying this in first-order logic to work with terms, but
for now evaluating a propositional variable is all we need.

**3.1. Getting All Atoms.**
So, we're going to have to exhaustively search all atoms. We need a
function `atoms` which will (i) eat in a formula, and (ii) produce a
list of the atoms in the formula without duplicates. We have

```haskell
rawAtoms :: Formula -> [PropVar]
rawAtoms f = case f of
  F           -> []
  T           -> []
  Atom x      -> [x]
  Not p       -> rawAtoms p
  And p q     -> (rawAtoms p) ++ (rawAtoms q)
  Or p q      -> (rawAtoms p) ++ (rawAtoms q)
  Implies p q -> (rawAtoms p) ++ (rawAtoms q)
  Iff p q     -> (rawAtoms p) ++ (rawAtoms q)

--- import qualified Data.List as Data.List
atoms :: Formula -> [PropVar]
atoms = Data.List.nub . rawAtoms
```

**4. Semantics.**
Now we come to the bread and butter of this thing: the `eval`
function. We should evaluate a `Formula` specifically in the context  of
a `Valuation`, and return `True` or `False`. This is done recursively,
exploring the arguments to the various logical operations "in the
obvious way":

```haskell
eval :: Formula -> Valuation -> Bool
eval f v = case f of
  F           -> False
  T           -> True
  Atom x      -> v x
  Not p       -> not (eval p v)
  And p q     -> (eval p v) && (eval q v)
  Or p q      -> (eval p v) || (eval q v)
  Implies p q -> not (eval p v) || (eval q v)
  Iff p q     -> (eval p v) == (eval q v)
```

**5. The Main Player.**
We now almost have enough to begin asking whether a function is a
tautology or not (or satisfiable, or not). We first introduce a function
which exhaustively checks all valuations. It takes in a `subfn` (which
for us is just `eval fm` curried), a valuation it resorts to `v` when
all else fails, and a set of atoms `ats`.

This function recursively calls itself, popping one atom at a time, and
considering both the case the popped atom is true...and when it is
false. When its all out of atoms, it begins to call the `subfn` on the
given valuation `v`.

```haskell
onAllValuations :: (Valuation -> Bool) -> Valuation -> [PropVar] -> Bool
onAllValuations subfn v ats = case ats of
  []   -> subfn v
  p:ps -> let v' t q = if q == p then t else v q in
          (onAllValuations subfn (v' False) ps)
          && (onAllValuations subfn (v' True) ps)
```

Great, now we can begin asking if something is a tautology or not. That
amounts to asking if `onAllValuations (eval fm)` is `True` for an
arbitrary initial valuation (so why not pick `(const False)`?) on all
the atoms in the formula.

Unsatisfiability is simply the case the negation of a given formula is a
tautology. Satisfiability is when a formula is not unsatisfiable.

```haskell
isTautology :: Formula -> Bool
isTautology fm = onAllValuations (eval fm) (const False) (atoms fm)

isUnsatisfiable :: Formula -> Bool
isUnsatisfiable fm = isTautology (Not fm)

isSatisfiable :: Formula -> Bool
isSatisfiable fm = not (isUnsatisfiable fm)
```

This is a horribly inefficient way to implement satisfiability, I
think. Why? Well, it depends on the formula. There are a lot of tricks
to transform the formula to put it in some canonical form. Transforming
the formula into a logically equivalent one turns out to improve
performance quite a bit.

## Conclusion

We've got the moving parts for the automated theorem prover done. All
that's left is to write a parser (not relevant at the moment), and
perhaps some REPL-type code for interactive sessions.

But the code is horribly inefficient. [Next time](http://pqnelson.github.io/2015/02/09/automated-thm-ii-normal-forms.html), we will consider
various different canonical forms for the propositional formulas to
increase performance.

# References
1. Laurence Edward Day,
   "Implementing a Propositional Logic Theorem Prover in Haskell".
   Undergraduate dissertation (2010)
   [eprint](http://www.cs.nott.ac.uk/~led/papers/led_bsc_dissertation.pdf)
2. John Harrison,
   *Handbook of Practical Logic and Automated Reasoning*.
   Cambridge University Press, 2009.
3. Elliot Mendelson,
   *Introduction to Mathematical Logic*.
   Chapman and Hall, 5th ed., 2009.
4. Prof. Dr. Erika Ábrahám
   [Lectures on Decision Procedures](http://www.decision-procedures.org/slides/),
   specifically propositional logic satisfiability.
