---
layout: post
title: Automated Theorem Proving, Part 2 - Normal Forms
published: true
quote: "Nobody realizes that some people expend tremendous energy merely to be normal."
quoteSource: Albert Camus, Notebook IV in <em>Notebooks: 1942-1951</em>
---

# Introduction

So [last time](http://pqnelson.github.io/2015/01/15/automated-thm.html)
we created a simple automated theorem prover for classical propositional
calculus. It boiled down to a simple tableau method (i.e., it basically
"looked at the rows of truth tables" to determine things). We found this
was horribly inefficient.

Today, we'll start thinking about one method addressing efficiency:
[normal forms](http://en.wikipedia.org/wiki/Canonical_form). Spoiler
alert: normal forms only make the efficiency problem manifest, it
doesn't really *solve* the problem.

At any rate, we'll start introducing normal forms by restricting the
connectives to `Not` (applied to atomic propositions only), `Or`, and
`And` ("negation normal form"). Then we'll refine this to work with
conjunctions of clauses ("conjunctive normal form"). Then we'll ~~lose
all hope to go on with life~~ consider the efficiency gains.

All the code is available on
[github](https://github.com/pqnelson/surak), checkout `v0.0.3` for the
code relevant to this post.

# Negation Normal Form

**Definition.** A **"Literal"** is either (i) an atomic proposition, or
(ii) the negation of an atomic proposition. (End of Definition)

So for example, `And p q` is not a literal, since it's composite. But
`p` is a literal, since it's atomic. `Not (Not p)` is not a literal,
although `Not p` is one. Although `Not (Not p)` is logically equivalent
to `p`, it is different syntactically.

**Definition.** A formula is in **"Negation Normal Form"** if it
consists of: (i) literals, (ii) conjoined formulas each of which are in
negation normal form, (iii) the disjunction of formulas in negation
normal form. (End of definition)

So we could write a grammar for it:

```haskell
--- Not real code! Just illustrating the grammar
Literal = Atom PropVar
        | Not (Atom PropVar)

NnfFormula = Literal
           | And NnfFormula NnfFormula
           | Or NnfFormula NnfFormula
```

Well, we'll at least implement a predicate testing if a formula is a
literal or not:

```haskell
isLiteral :: Formula -> Bool
isLiteral (Atom _) = True
isLiteral (Not (Atom _)) = True
isLiteral _ = False
```

**Puzzle.** How to implement a transformation of any given formula to
  negation normal form?

### Helper Functions

So, we have a simplification procedure...well, a pair of procedures (to
avoid infinite recursion).

```haskell
simplifyProp' :: Formula -> Formula
simplifyProp' fm = case fm of
  Not F       -> T
  Not T       -> F
  Not (Not p) -> p
  And _ F     -> F
  And F _     -> F
  And p T     -> p
  And T q     -> q
  Or _ T      -> T
  Or T _      -> T
  Or F p      -> p
  Or p F      -> p
  Implies F _ -> T
  Implies _ T -> T
  Implies p F -> Not p
  Iff p T     -> p
  Iff T p     -> p
  Iff F F     -> T
  Iff p F     -> Not p
  Iff F p     -> Not p
  _           -> fm

-- | Simplifies various logical structures, avoids double negatives, etc.
-- Necessary as a first step to get a formula in NNF.
simplifyProp :: Formula -> Formula
simplifyProp fm = case fm of
  Not p       -> simplifyProp' (Not (simplifyProp p))
  And p q     -> simplifyProp' (And (simplifyProp p) (simplifyProp q))
  Or p q      -> simplifyProp' (Or (simplifyProp p) (simplifyProp q))
  Implies p q -> simplifyProp' (Implies (simplifyProp p) (simplifyProp q))
  Iff p q     -> simplifyProp' (Iff (simplifyProp p) (simplifyProp q))
  _           -> fm
```

### Implementation

We only really have to transform `Implies` and `Iff` type
statements. But we have to do it recursively, to make sure we transform
*all* such connectives.

```haskell
toNNF' :: Formula -> Formula
toNNF' fm = case fm of
  And p q           -> And (toNNF' p) (toNNF' q)
  Or p q            -> Or (toNNF' p) (toNNF' q)
  Implies p q       -> Or (toNNF' (Not p)) (toNNF' q)
  Iff p q           -> Or (And (toNNF' p) (toNNF' q))
                          (And (toNNF' (Not p)) (toNNF' (Not q)))
  Not (Not p)       -> toNNF' p
  Not (And p q)     -> Or (toNNF' (Not p)) (toNNF' (Not q))
  Not (Or p q)      -> And (toNNF' (Not p)) (toNNF' (Not q))
  Not (Implies p q) -> And (toNNF' p) (toNNF' (Not q))
  Not (Iff p q)     -> Or (And (toNNF' p) (toNNF' q))
                          (And (toNNF' (Not p)) (toNNF' (Not q)))
  _                 -> fm

toNNF :: Formula -> Formula
toNNF = toNNF' . simplifyProp
```

We also need to add some simplification logic. The best case is when the
input formula is already in negation normal form. What's the worst case?

## Exponential Cost in Memory

Let `p` and `q` be atoms. We see `Iff p q` expands to `Or (And p q) (And
(Not p) (Not q))`. This is a tree with four leaves, and 3 nodes (the
`Or` and 2 `And`'s).

**Claim.** In the formula `Iff p1 (Iff p2 (Iff ... pn))` with `n` atoms,
when transformed to negation normal form results in a tree with `~2^n`
leaves. More precisely, there are a total of `A(n)` atoms which obeys
the recursion relation `A(n) = 2*(1 + A(n-1))` with `A(2) = 4`.

*Proof.* By induction.

*Base Case.* For `n=2`, we have `Iff p q` expand into the tree

```
               Or 
             /   \
           /       \
         /           \
      And            And
    /     \         /   \
   p       q    Not p    Not q
```

Observe this has `2p + 2q` atoms, if we treat `p` and `q` as formal
variables in a generating function.

Suppose `q` is `Iff p2 p3`. Well, by our base case, this removes 1 atom
from each branch but adds 8 total

```
               Or 
             /   \
           /       \
         /           \
      And            And
    /     \         /   \
   p      Or    Not p    Not (Iff p2 p3)
         /  \
      And    --And---
     /  \      /     \
    p2   p3  Not p2  Not p3
```

This results in `2*(p + 2(p2 + p3))` which is precisely 10 nodes
(setting `p=p2=p3=1`). If we ignore the negations, this looks like:

```
               Or 
             /   \
           /       \
         /           \
      And            (mirror)
    /     \
   p      Or
         /  \
      And    --And
     /  \      / \
    p2   p3  p2   p3
```

If we now substitute in `p3 = Iff p3 p4`, we see then that as a
polynomial we have `2(p + 2(p2 + 2(p3 + p4)))`. Thus we get `2(1 + 2(1 +
2(1 + 1))) = 2+2^2+2^4` atoms.

*Inductive Hypothesis.* Suppose `A(n) = 2(1 + A(n-1))`.

*Inductive Case.* We have the syntax tree for `Iff q (Iff p1 (Iff ... pN))`
look like:

```
     Or
    /  \
  And  (mirror)
 /   \
q    (Iff p1 .. pN)
```

Using the inductive hypothesis on `(Iff p1 (Iff .. pN))` that it
consists of `A(n)` atoms, we then get `A(n+1) = 1 + 1 + A(n) + A(n) =
2(1 + A(n))`. This concludes the proof. (End of proof)

**Exercise.** Consider the function `f(x) = \sum^{\infty}_{n=1} A(n) x^{n}`.
What is the generating function equal to?

**Moral of the Story.** The worst case for a formula's memory cost when
transformed to negation normal form is on the order of `2^n` when the
original formula consisted of `n` atoms. (I.e., it's an exponential cost
in memory; i.e., bad.)

## Exponential Cost in Computation

We have a conservation law, at least with converting a formula to
negation normal form; it's a "Conservation of Misery" law. We can trade
the exponential memory cost for an exponential amount of computation.

What to do? We simply don't walk into the `Iff` trap, i.e., we have a
modified normal form that allows `Iff`s while pushing negation down to
the atoms. So this grammar would look like:

```haskell
NenfFormula = Literal
            | And NenfFormula NenfFormula
            | Or NenfFormula NenfFormula
            | Iff NenfFormula NenfFormula
```

And we also use a tautology like `Iff (Not (Iff p q)) (Iff (Not p) q)`
to help push negation down to the atom-level.

### Implementation

Now, we have our implementation:

```haskell
toNENF' :: Formula -> Formula
toNENF' fm = case fm of
  Not (Not p)       -> toNENF' p                         --- we don't have
  Not (And p q)     -> Or (toNENF' p) (toNENF' q)        --- simplification
  Not (Implies p q) -> And (toNENF' p) (toNENF' (Not q)) --- called recursively
  Not (Iff p q)     -> Iff (toNENF' p) (toNENF' (Not q)) --- so we need these
  And p q           -> And (toNENF' p) (toNENF' q)
  Or p q            -> Or (toNENF' p) (toNENF' q)
  Implies p q       -> Or (toNENF' (Not p)) (toNENF' q)
  Iff p q           -> Iff (toNENF' p) (toNENF' q)
  _                 -> fm

toNENF :: Formula -> Formula
toNENF = toNENF' . simplifyProp
```

# Disjunctive and Conjunctive Normal Forms

**Definition.** A **"Clause"** is a formula consisting of literals
`or`'d together. (End of Definition)

We can further restrict negation normal form by demanding we work with
clauses. Or go even farther, insisting `Or`'s *only* occur in clauses,
then a generic formula would look like `(And Clause1 (And Clause2 (And
... ClauseN)))`.

**Definition.** A formula is in **"Conjunctive Normal Form"** if it
consists of clauses conjoined together. (End of definition)

What's so great about this?

**Theorem.** A formula in conjunctive normal form is a tautology if and
only if each clause is a tautology. (End of theorem)

*Proof.* Obvious. Look, if any one of the clauses were not a tautology,
the formula couldn't be a tautology. And if the formula is a tautology,
and it is of the form `(And p q)`, then `p` and `q` must be
tautologies. Conjunctive normal form then says `p` is just `(Or L1 (Or
L2 (Or ... Ln)))`. For this to be a tautology, then both `L1` and `(Not
L1)` must be in the clause. This can be checked quickly. (End of Proof)

**Puzzle.** Given a list of literals, how quickly can we determine if
every atomic proposition and its negation live in the list? (End of puzzle)

So, we can see, this conjunctive normal form is ideal for determining
validity.

## Disjunctive Normal Form
### De Morgan, the Hero

We should probably note that there is a remarkably similar normal form
here called the **"Disjunctive Normal Form"**. Here, the formula looks
like

```haskell
--- not real code!
DnfClause = Literal
          | And DnfClause DnfClause

DnfFormula = DnfClause
           | Or DnfClause DnfClause
```

We can related disjunctive normal form to conjunctive normal form *by
negating one* and mapping all atoms to their dual (i.e., negate them too).

So, in other words, pseudo-Haskell code:

```haskell
CnfFormula = Not (mapAtoms (\x -> Not (Atom x)) DnfFormula)
```

We'd have to simplify it quite a bit.

### Helper Functions

Unfortunately, we have a number of helper functions for converting a
formula to disjunctive normal form.

We have helpers to collect a list of formulas, and iteratively join them
together using either `And` or `Or`. These are basically `foldl And` or
`foldr Or`, more or less.

```haskell
-- | Given a list of formulas, apply `foldl And T` to them to get a single
-- formula.
--
-- >>> foldlConj [(Atom "a"), (Atom "b"), (Atom "c")]
-- And (And (And T (Atom "c")) (Atom "b")) (Atom "a")
foldlConj :: [Formula] -> Formula
foldlConj [] = T
foldlConj (f:fs) = And (foldlConj fs) f

-- | Given a list of formulas, apply `foldr Or F` to them to get a single
-- formula.
--
-- >>> foldrDisj [(Atom "a"), (Atom "b"), (Atom "c")]
-- Or (Atom "a") (Or (Atom "b") (Or (Atom "c") F))
foldrDisj :: [Formula] -> Formula
foldrDisj fms = foldr Or F fms
```

We also have a function to collect a list of valuations satisfying some
property. This is a close cousin to our earlier `onAllValuations` from
the first toy model.

```haskell
-- | Get all valuations which satisfy some property 'subfn'
allValuationsSatisfying :: (Valuation -> Bool) -> Valuation -> [PropVar] -> [Valuation]
allValuationsSatisfying p v [] = [v | p v]
allValuationsSatisfying p v (a:pvs) =
  allValuationsSatisfying p ((a |-> False) v) pvs
  ++ allValuationsSatisfying p ((a |-> True) v) pvs
```

So, given a list of propositional variables, we want to conjoin literals
formed from them (i.e., either the propositional variable or its
negation) according to which satisfies the given valuation.

```haskell
-- | Given a list of propositional variables and a fixed valuation 'v', map
-- the propositional variables through 'if eval (Atom _) v then (Atom
-- _) else (Not (Atom _))', the 'foldlConj' the resulting formulas all
-- together 
makeLiterals :: [PropVar] -> Valuation -> Formula
makeLiterals ats v = foldlConj (map ((\p -> if eval p v then p else Not p)
                                     . Atom)
                                ats)
```

### Implementation

We have a "follow your nose" implementation. Select the valuations
satisfying the formula, map `makeLiterals` over it, and collect the
results into an iterated disjunction.

```haskell
toDNF :: Formula -> Formula
toDNF fm = let ats = atoms fm
               satVals = allValuationsSatisfying (eval fm) (const False) ats
           in foldrDisj            --- 'foldr Or F' together the result of
               (map                --- mapping 
                (makeLiterals ats) --- into a list of literals determined by
                satVals)           --- all rows in the truth table
```

But will this really work? Well...we form one clause which matches
exactly one given row of the truth table (and is `False` for any other
valuation), then we collect these clauses disjunctively...i.e., say "If
this row holds and no others, or this row holds and no others, or etc.,
then we have precisely something logically equivalent to the given formula."

This suffers from the horribly exponential explosion problem,
however. We can't drop the "Mission Accomplished" banner quite yet.

### Transforming a formula to Disjunctive Normal Form

The naive implementation `toDNF` really sucked. We can try applying
various transformations to get a formula into disjunctive normal form,
similar to what we did with `toNENF`. We can try using the tautologies

```
(Iff (And p (Or q r))
     (Or (And p q)
         (And p r)))
(Iff (And (Or p q)
          r)
     (Or (And p r)
         (And q r)))
```

We introduce the `distrib` function describing these transformations:

```haskell
-- | Distributes 'And' over 'Or' in formulas
distrib :: Formula -> Formula
distrib (And p (Or q r)) = Or (distrib (And p q)) (distrib (And p r))
distrib (And (Or p q) r) = Or (distrib (And p r)) (distrib (And q r))
distrib fm = fm
```

Lets see how it behaves on `And (Or p1 p2) (Or p3 p4)`:

```
distrib And (Or p1 p2) (Or p3 p4)
-> Or (distrib (And (Or p1 p2) p3)) (distrib (And (Or p1 p2) p4))
-> Or (Or (And p1 p3) (And p2 p3)) (Or (And p1 p4) (And p2 p4))
```

But look, now given a formula in negation normal form, we may convert it
to disjunctive normal form by iteratively applying `distrib` to it:

```haskell
nnfToDNF :: Formula -> Formula
nnfToDNF (And p q) = distrib (And (nnfToDNF p) (nnfToDNF q))
nnfToDNF (Or p q) = Or (nnfToDNF p) (nnfToDNF q)
nnfToDNF fm = fm
```

## Set Based Implementation

These implementations converting a formula to DNF really, well, are not
optimal. Perhaps if we represent each clause as a set of literals, then
a proposition in disjunctive nromal form may be represented as a list of
of lists of literals `[[Literal]]`.

We also have to make sure that we get rid of clauses which are subsumed
in others. Suppose we have a clause `And p (And q r)`, and another
clause `And p r`. Clearly the first "contains" the other, in the sense
if `Implies (And p (And q r)) (And p r)` is a tautology.

Once we have our "distinct" clauses, we just reconstruct the disjunctive
normal form for the formula.

### Helper Functions

This is the straw that broke the camel's back. I decided to implement my
own `Set` utilities. So `setify` will take a given list, and produce an
ordered list of unique elements from the original.

We can then consider the helper function which applies a function `f` to
all pairs of elements from two given lists:

```haskell
allPairs :: Ord c => (a -> b -> c) -> [a] -> [b] -> [c]
allPairs f xs ys = Set.setify [f x y | x <- xs, y <- ys]
```

Set-builder notation really is quite nifty.

I also added a `negate` function which logically negates the given
formula. Well, it will transform `(Not fm)` into `fm`, and for any other
formula just prepend it with `(Not ...)`.

```haskell
--- import Prelude hiding (negate)
negate :: Formula -> Formula
negate (Not fm) = fm
negate fm = Not fm
```

The last helper function I needed was to test if a given DNF clause was
"trivial" or not. What do I mean? Well, in DNF we have our formula look
like `Or C1 (Or C2 (Or ...))` where each clause is `(And L1 (And L2 (And
...)))`. But if a clause has `(And p (And (Not p) (And ...)))`, we can
throw it away since it's a contradiction (i.e., unsatisfiable).

```haskell
isDnfClauseTrivial :: [Formula] -> Bool
isDnfClauseTrivial literals =
  let (pos, negs) = Data.List.partition isPositive literals
  in Set.intersect (map negate negs) pos /= []
```

### Implementation

We first have a function that takes the clauses and filters out the
subsumed clauses. We want `Or (And p q) (And p (And r q))` to become
`(And p (And r q))`, for efficiency.

```haskell
subsume :: [[Formula]] -> [[Formula]]
subsume cls = filter (\cl -> not (any (`Set.isProperSubset` cl) cls)) cls
```

Given a formula in negation normal form, we want to convert it to a
nested list of literals. Not just any nested list, but one which is in
disjunctive normal form.

```haskell
-- | Given a formula in NNF, convert it to a list of clauses, where each
-- clause is represented as a list of literals.
pureDNF :: Formula -> [[Formula]]
pureDNF fm = case fm of
  And p q -> Set.setify $ allPairs Set.union (pureDNF p) (pureDNF q)
  Or p q  -> Set.union (pureDNF p) (pureDNF q)
  _       -> [[fm]]
```

Great, so now given a formula, simply turn it to negation normal form,
then feed it to `pureDNF` to get a nested list of literals. From there,
remove the trivial clauses, and `subsume` the nontrivial ones. We'll end
up with a list of clauses, none of which are subsumed in any other.

```haskell
simpDNF :: Formula -> [[Formula]]
simpDNF F = []
simpDNF T = [[]]
simpDNF fm = (subsume . filter (not . isDnfClauseTrivial) . pureDNF . toNNF) fm
```

We just have to map each `[Formula]` clause to iteratively collect the
literals conjoined together, then iteratively conjoin the clauses `Or`'d
together.

```haskell
-- | Determines the DNF using sets, then collects the clauses by
-- iteratively joining them 'Or'-d together.
toDNF :: Formula -> Formula
toDNF fm = foldrDisj (map foldlConj (simpDNF fm))
```

## Uh... Conjunctive Normal Form?

I'm getting to it! Disjunctive normal form is great for testing
satisfiability, but Conjunctive normal form really shines when testing
for validity.

We can go through a similar song and dance for converting a formula to a
list of literals, and so on, or we could consult our good friend de
Morgan. De Morgan lets us use what we've done for disjunctive normal
form, and we have a few functions left over to polish the conversion up:

```haskell
pureCNF :: Formula -> [[Formula]]
pureCNF = map (map negate) . pureDNF . toNNF . negate

simpCNF :: Formula -> [[Formula]]
simpCNF F = []
simpCNF T = [[]]
simpCNF fm = let cjs = filter (not . isDnfClauseTrivial) (pureCNF $ toNNF fm)
             in filter (\c -> not $ any (`Set.isProperSubset` c) cjs) cjs

toCNF :: Formula -> Formula
toCNF fm = foldlConj (map foldrDisj (simpCNF fm))
```

# Conclusion

So, we've gone through negation normal form (which converts `Implies`
and `Iff` into `And`'s and `Or`'s while negating only atoms). We saw
this blew up exponentially...which is always bad.

We then tried finding conjunctive normal form and disjunctive normal
form. The situation did not really improve greatly, which is a pity. But
as previously noted, there is a conservation of misery here.

Next time I think we'll possibly discuss one last normal form
(definitional conjunctive normal form). After that, the next big thing
to talk about is the Davis-Putnam method.

# References
1. Donald Knuth,
   *The Art of Computer Programming*.
   Vol 4A, Addison-Wesley, 2014.
2. John Harrison,
   *Handbook of Practical Logic and Automated Reasoning*.
   Cambridge University Press, 2009.
3. Anatoli Degtyarev and Andrei Voronkov,
   "Inverse Methods".
   In *Handbook of Automated Reasoning* (Alan J.A. Robinson and Andrei
   Voronkov,eds.) vol. 1, 2001. See pp. 203 et seq.
4. G.S. Tseitsin,
   "On the complexity of derivation in propositional calculus".
   In *Structures in Constructive Mathematics and Mathematical Logic,
   Part II* (A.O. Slisenko, ed.), Seminars in Mathematics. Steklov
   Mathematical institute, 1968. Pp. 115-125.
