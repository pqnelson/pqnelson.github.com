---
layout: post
quote: "A building is not finished when its foundation is laid; and just as little, is the attainment of a general notion of a whole the whole itself. When we want to see an oak, we are not satisfied to be shown an acorn instead. In the same way science, the crowning glory of a spiritual world, is not found complete in its initial stages."
quoteSource: GWF Hegel, &sect;12 <em>Phenomenology of Spirit</em> (1807)
title: Automated Theorem Proving, The Davis Putnam Algorithm
published: true
tags: [Automated Theorem Prover, Logic, Backtracking]
---

# Introduction

So, finding out if a given formula is satisfiable is...hard. But it's
the core of the program we're writing. Today, we'll discuss a method to
determine if a formula is satisfiable, namely the Davis-Putnam
algorithm.

It consists of three steps:

1. Transform the input to conjunctive normal form.
2. Apply Simplification Rules
3. Splitting.

But look, step 1 (the preprocessing step) blows up exponentially...as we
saw [last time](http://pqnelson.github.io/2015/02/09/automated-thm-ii-normal-forms.html).

This time, we will figure out how to avoid this problem introducing
"Definitional CNF" for the preprocessing step.

Then we will introduce and discuss the Davis-Putnam algorithm. This
corresponds to `v0.1.2` of the [code](https://github.com/pqnelson/surak).

# Definitional Conjunctive Normal Form

The basic idea is to introduce new variables corresponding to
subformulas. The textbook example is `And (Or p (And q (Not r))) s`
which is transformed to:

```haskell
(And (Iff p1 (And q (Not r)))
     (And (Iff p2 (Or p p1))
          (And (Iff p3 (And p2 s))
               p3)))
```

This is clearly equisatisfiable, but since we have these extra variables
`p1`, `p2`, `p3`, we have too much freedom. This extra freedom denies us
the ability to say these formulas are equivalent (just choose one of
these new variables in the wrong way). Indeed, if we run it
through our automated theorem prover, we find:

```haskell
textbookDefCNFTest :: () -> String
textbookDefCNFTest _ =
  testToStr (Iff (And (Or p (And q (Not r))) s)
                 (And (Iff p1 (And q (Not r)))
                      (And (Iff p2 (Or p p1))
                           (And (Iff p3 (And p2 s))
                                p3))))
  where p = Atom "p"
        q = Atom "q"
        r = Atom "r"
        s = Atom "s"
        p1 = Atom "p1"
        p2 = Atom "p2"
        p3 = Atom "p3"
             
main :: IO ()
main = putStrLn $ textbookDefCNFTest ()
-- prints "[The formula] is false
```

But they're equisatisfiable, so it's safe for this as a preprocessing
step for equisatisfiability testing.

We then plug this into the "vanilla" `toCNF` function (or something
similar).

## Implementation

The basic design to convert a formula into definitional conjunctive
normal form is to use `Trip`'s:

```haskell
-- | A triple tracking the formula to be transformed,
-- definitions made so far (as a dictionary, well 'Data.Map'),
-- and the current variable index counter.
type Trip = (Formula, Map Formula (Formula, Formula), Int)
```

We transform this triple (transform the formula, augment the definition
dictionary, and increment the index counter) in a recursive function
`mainCNF` which calls `defstep`. This `defstep` does the real work, and
recursively calls `mainCNF` until the formula is in definition CNF.

```haskell
-- | Iteratively transform a formula, represented as a 'Trip', into
-- set-based definitional conjunctive normal form.
mainCNF :: Trip -> Trip
mainCNF (trip@(fm, _, _)) = case fm of
  And p q -> defstep And (p, q) trip
  Or p q  -> defstep Or (p, q) trip
  Iff p q -> defstep Iff (p, q) trip
  _       -> trip
```

This seems like a bad idea, since trampolines are generally "bad
form". Alas, I know no better way to handle this.

```haskell
-- | Takes a binary connective, an ordered pair of formulas, and a 'Trip'
-- then transforms this into another 'Trip'
defstep :: (Formula -> Formula -> Formula) -> (Formula, Formula) -> Trip -> Trip
defstep op (p, q) (_, defs, n) =
  let (fm1, defs1, n1) = mainCNF (p, defs, n)   --- recur on arguments of 
      (fm2, defs2, n2) = mainCNF (q, defs1, n1) --- the binary connective
      fm' = op fm1 fm2 --- apply op to the transformed arguments
  in case Map.lookup --- lookup
          fm'        --- the formula fm'
          defs2 of   --- in the dictionary from mainCNF called on q
      Just (v, _) -> (v, defs, n2) --- if it's found, return it
      Nothing -> (v, Map.insert fm' (v, Iff v fm') defs2, n3) --- otherwise
        where (v, n3) = makeProp n2 --- add it to the dictionary, return it
```

The `defstep` function does quite a bit of work, which basically keeps
track of the definitions in the dictionary component of `Trip`. It
updates the running formula to reflect this, and increments the index
counter as needed.

We have a brief aside on helper functions. One, `maybeRead`, gets a
string and returns a `Maybe` gadget &mdash; if something went wrong, it's
`Nothing`; otherwise it's `Just [result]`. We use this to figure out the
greatest variable index:

```haskell
-- | Return whichever is larger of the argument n, or all possible m
-- such that the string argument s is pfx followed by the string corresponding
-- to m, if any:
maxVarIndex :: String -> String -> Int -> Int
maxVarIndex pfx s n =
  let m = length pfx
      l = length s
  in if l <= m || take m s /= pfx
     then n
     else let s' = take (l-m) (drop m s)
          in case maybeRead s'
             of Nothing -> n
                Just n' -> max n n'
```

The subtle details of this function are not terribly important at the
moment.

Now, we use `mainCNF` to transform a `Formula` to definitional
conjunctive normal form, *à la* set based representation. We slightly
generalize the procedure to do this to let us pass in an arbitrary
`(Trip->Trip)` function (why be constrained to one particular choice?).

```haskell
-- | Transform the clauses to definitional CNF, and return the set-based
-- representation of the given formula.
mkDefCNF :: (Trip -> Trip) -> Formula -> [[Formula]]
mkDefCNF fn fm =
  let fm' = toNENF fm
      n = 1 + foldr (maxVarIndex "p_" . show) 0 (atoms fm')
      (fm'', defs, _) = fn (fm', Map.empty, n)
      --- recall dict entry is something like "(fm', (v, Iff v fm'))"
      deflist = map (snd . snd) --- project out the definitions "Iff v fm'"
                    (Map.toList defs) --- from all dictionary entries
  in Set.unions $ simpCNF fm'' : map simpCNF deflist
```

Then we use this set-based representation of the definitional CNF to
construct the `Formula` representation:

```haskell
toDefCNF :: Formula -> Formula
toDefCNF fm = foldlConj             --- turn the list of clauses into a Formula
              $ map foldrDisj       --- turn the clauses into Formulas
              $ mkDefCNF mainCNF fm --- transform to set-based def CNF
```

This is the vanilla implementation just "following our nose".

## Optimization

But look, do we really need to worry if the formula looks like `(And p q)`?
Why not just go "as far as possible", and transform only when forced?

That is to say, if we consider the formula

```haskell
And (And p
         (And q
              (Implies (Or r s)
                       t)))
--- why not just transform (Implies (Or r s) t) ? That is, produce:
--- And (toCNF (Iff p1 (Implies (Or r s) t)))
---     (And (And p
---               (And q p1)))
```

We have some "pre-preprocessing" steps to avoid needlessly transforming
subformulas.

```haskell
subCNF :: (Trip -> Trip) -> (Formula -> Formula -> Formula)
          -> (Formula, Formula) -> Trip -> Trip
subCNF subfn op (p, q) (_, defs, n) =
  let (fm1, defs1, n1) = subfn (p, defs, n)
      (fm2, defs2, n2) = subfn (q, defs1, n1)
  in (op fm1 fm2, defs2, n2)
```

So, what happens? We recursively descend through disjunctions performing
the definitional transformation on the disjuncts:

```haskell
orCNF :: Trip -> Trip
orCNF trip@(fm, _, _) = case fm of
  Or p q -> subCNF orCNF Or (p, q) trip --- recursively call itself
  _      -> mainCNF trip                --- transform the disjuncts
```

In turn, we recursively descend through conjunctions calling `orCNF` on
the conjuncts

```haskell
andCNF :: Trip -> Trip
andCNF trip@(fm, _, _) = case fm of
  And p q -> subCNF andCNF And (p, q) trip
  _       -> orCNF trip
```

Now, we can transform a formula into the set-based definitional CNF
clauses by simply using `andCNF`. Or more precisely:

```haskell
defCNFClauses :: Formula -> [[Formula]]
defCNFClauses = mkDefCNF andCNF
```

Then we get a slightly optimized function converting a formula to
definitional conjunctive normal form

```haskell
-- | A slightly optimized way to convert a formula to definitional CNF.
toDefCNF :: Formula -> Formula
toDefCNF = foldlConj . map foldrDisj . defCNFClauses
```

**Exercise for Author:** I should probably do a more thorough algorithm
analysis of this version, but as I am tight on time at the moment...I
leave it as an exercise. But one for the author! (End of exercise)

# Davis-Putnam Algorithm

John Harrison points out (both in his lectures linked below, and his
*Handbook of Practical Logic*) there are two Davis-Putnam
algorithms: one from Davis and Putnam's "A Computing Procedure for
Quantification Theory" (*Journal of the ACM* **7** 3 (1960) 201-215),
the other from Davis, Logemann, and Loveland's "A Machine Program for
Theorem Proving" (*Comm. of the ACM* **5** 7 (1962) 394-397). Following
Harrison, we will follow the chronological route, and consider the
former paper first.

The basic outline of the procedure is:

1. Convert the input formula to CNF.
2. Apply simplification rules
3. The "resolution" rule.

**Remark.**
For what its worth, the later 1962 algorithm (which merits the name
"DPLL") simply replaced the "resolution" rule with something else.
(End of Remark)

As we have already seen how to convert a formula to conjunctive normal
form, lets consider the simplifying rules. Davis-Putnam uses the
set-based representation of the conjunctive normal form.

## Satisfiability-Preserving Transformations

There are two transformations on the sets of clauses:

1. The 1-literal rule (nowadays called ["Unit Propagation"](http://en.wikipedia.org/wiki/Unit_propagation)),
2. The affirmitive-negative rule (sometimes called the "Pure Literal rule").

### Unit Propagation

**Definition.** A **"Unit Clause"** is a clause that consists of a
single literal. (End of definition)

**Unit Propagation Algorithm.** If one of the clauses is a unit clause,
we can eliminate all instances of that literal and its negation without
affecting satisfiability. This can be seen easily in CNF, and removing
such literals preserves satisfiability. (End of Algorithm)

**Example.** Consider the list of clauses
`[Or a b, Or (Not a) c, Or (Not c) d, a]`. Look, the last entry is
`a`, a unit clause. Hence we see for this formula to be satisfiable,
we need `a` to be true.

We then eliminate it from every other clause. Why? Because look, `Or T x`
is equivalent to `x`. Then we can iterate this "unit propagation" and
deduce that `x` must be true. Hence iterating unit propagation in our
example, we have the following trace:

```haskell
    [Or a b, Or (Not a) c, Or (Not c) d, a]
--- swap "T" for "a" and simplify in all but the unit clause
    [     T,            c, Or (Not c) d, a]
--- "c" is now a unit clause, substitute in "T" for "c" and simplify:
    [     T,            c,            d, a]
--- "d" is now a unit-clause, but we're left with unit clauses, so we're done
```

We see how satisfiability is preserved along the way. **(End of Example)**

We can test for a unit clause quite simply:

```haskell
--- in src/DavisPutnam.hs

isUnitClause :: [Formula] -> Bool
isUnitClause (_:t) = null t
isUnitClause _     = False
```

This is the lazy way to do it. The naive way, check if the length is
equal to 1, won't work since `length` is `O(n)`. The clever way is to
check the tail is empty, and if there is no tail it must be empty input.

Now we implement the one literal rule:

```haskell
--- in src/DavisPutnam.hs

-- | The one literal rule for the Davis-Putnam algorithm.
oneLiteralRule :: [[Formula]] -> Maybe [[Formula]]
oneLiteralRule clauses = case find isUnitClause clauses of
                          Nothing -> Nothing
                          Just [u] -> Just (Set.image (Set.\\ [u']) clauses')
                            where u' = negate u
                                  clauses' = filter (notElem u) clauses
                          _ -> error "oneLiteralRule reached impossible state"
```

Too easy, right?

### The Affirmative-Negative Rule

**Algorithm.** If any literal occurs either *only positively* or *only
negatively*, then it can be removed without affecting
satisfiability. So eliminate all *clauses* containing such a literal. (End of Algorithm)

The implementation is another "follow your nose" approach

```haskell
--- in src/DavisPutnam.hs

affirmativeNegativeRule :: [[Formula]] -> Maybe [[Formula]]
affirmativeNegativeRule clauses =
  let (neg', pos) = Data.List.partition negative (Set.unions clauses)
      neg = map negate neg'
      posOnly = Set.difference pos neg
      negOnly = Set.difference neg pos
      pure = Set.union posOnly (map negate negOnly) --- pure literals
  in case pure of
      [] -> Nothing
      _ -> Just (filter                      --- filter out the
                 (null . Set.intersect pure) --- clauses not containing pure
                 clauses)                    --- literals
```

By construction, this will preserve satisfiability.

## Resolution

The basic scheme actually can be illustrated in a theorem.

**Theorem.** Given a literal `p`, separate a set of clauses `S` into
  those containing `p` only positively, those containing it only
  negatively, and those not containing it at all:

```haskell
S = [Or p C[i] | i <- [1..m]] ++ [Or (Not p) D[j] | j <- [1..n]] ++ S0
```

  where none of the `C[i]` or `D[j]` contain `p` or its negation, and if
  either `p` or `Not p` occurs in any clause in `S0` then they both do.

  Then `S` is satisfiable if and only if `S'` is, where

```haskell
S' = [Or C[i] D[j] | i <- [1..m], j <- [1..n]] ++ S0
```

(End of Theorem)

*Sketch of Proof.* Without loss of generality, we may assume `p` is
positive.

In one direction, we have to show any valuation `v` satisfying `S` must
also satisfy `S'`. We break this up into cases:

Case 1: `v(p) = False`. Then in the `Or p C[i]` clauses, we see `v C[i] =
True` for all `i`. So each `C[i]` is satisfied, and hence `Or C[i] D[j]`
would be satisfied too, for any `i` and `j`.

Case 2: `v(p) = True`. Then in the `Or (Not p) D[j]` clauses, we see `v D[j]`
must be `True` for all `j`. So each `D[j]` is satisfied. Hence `Or C[i] D[j]`
is satisfied by `v` for all `i` and `j`.

This concludes the proof in one direction.

The other direction requires a bit more work. Mostly it's the same
reasoning in reverse, we have `v` satisfy `S'`. Then it must satisfy all
`C[i]` or all `D[j]`. In the first case, we extend `v` to be
`v(p)=False`; and in the latter case, we extend `v` to be `v(p) = True`.
This sketches the other direction. (End of proof)

The implementation is a little sloppy but straightforward:

```haskell
--- in src/DavisPutnam.hs

resolveOn :: Formula -> [[Formula]] -> [[Formula]]
resolveOn p clauses =
  let p' = negate p
      (pos, notPos) = List.partition (elem p) clauses
      (neg, s0) = List.partition (elem p') notPos
      pos' = map (filter (/= p)) pos  --- the list of C[i]
      neg' = map (filter (/= p')) neg --- the list of D[j]
      res0 = [c `Set.union` d | c <- pos', d <- neg']
  in Set.union s0 (filter (not . trivial) res0)
```

We tried to be faithful to the notation used in our theorem.

We then have a crude heuristic

```haskell
--- in src/DavisPutnam.hs

findBlowup :: [[Formula]] -> Formula -> (Int, Formula)
findBlowup cls l = let m = length(filter (elem l) cls)
                       n = length(filter (elem (negate l)) cls)
                   in (m*n - m - n, l)
```

Where we want to minimize `m*n - m - n`. The resolution is built with
this in mind:

```haskell
--- in src/DavisPutnam.hs

resolutionRule :: [[Formula]] -> [[Formula]]
resolutionRule clauses =
  let pvs = filter isPositive (Set.unions clauses)
      (_, p) = Data.List.minimum $ map (findBlowup clauses) pvs
  in resolveOn p clauses
```

## The Davis-Putnam Algorithm

We arrive at the center-piece of the Davis-Putnam algorithm, namely, the
algorithm itself! What happens? Well, we first iteratively try unit
propagation until it won't work, then we try the affirmative-negative
rule and recurse until it won't work. At last we use the resolution rule, 
then recursion takes us back to step 1.

We treat the empty clause as `True`, and the clause containing the empty
set as `False`. These are the "base conditions" when we bail out of
recursion.

```haskell
--- in src/DavisPutnam.hs

dp :: [[Formula]] -> Bool
dp [] = True
dp clauses =
  if [] `elem` clauses
  then False
  else case oneLiteralRule clauses of
        Just clauses' -> dp clauses'
        Nothing -> case affirmativeNegativeRule clauses of
                    Just clauses' -> dp clauses'
                    Nothing -> dp(resolutionRule clauses)
```

We can then use this to test for satisfiability and validity:

```haskell
dpSat :: Formula -> Bool
dpSat = dp . defnfs

dpValidity :: Formula -> Bool
dpValidity fm = not $ dpSat (Not fm)
```

Lo and behold, this turns out to be somewhat better than the naive approach!

## The DPLL Algorithm

The DPLL algorithm modifies the resolution rule, opting for a "splitting
rule" instead. What happens?

Well, if neither unit propagation nor the affirmative-negative rule can
be applied, then some literal `p` is chosen. We then check if `Clauses
++ [p]` is satisfiable, or `Clauses ++ [(Not p)]` is satisfiable...by
recursively using the DPLL algorithm on it.

We need some heuristic for picking which literal to use. Again, a
quick-and-dirty heuristic might be the literal that shows up the most:

```haskell
frequencies :: [[Formula]] -> Formula -> (Int, Formula)
frequencies clauses p = let m = length $ filter (elem p) clauses
                            n = length $ filter (elem (Not p)) clauses
                        in (m+n, p)
```

We sort using `m+n` as the primary key, then lexicographically on `p` (an
inadvertent artifact). But the DPLL algorithm is just what we had
before, 

```haskell
-- | Return all literals that occur in the formula, negated literals are
-- transformed to be positive.
getLiterals :: [[Formula]] -> [Formula]
getLiterals clauses = let (pos,neg) = Data.List.partition isPositive
                                      $ Set.unions clauses
                      in Set.union pos (map negate neg)

dpll :: [[Formula]] -> bool
dpll [] = True
dpll clauses = if [] `elem` clauses then False else
                 case oneLiteralRule clauses of
                  Just clauses' -> dpll clauses'
                  Nothing -> case affirmativeNegativeRule clauses of
                    Just clauses' -> dpll clauses'
                    Nothing -> --- NEW STUFF FOR DPLL!!
                      let pvs = filter isPositive (Set.unions clauses)
                          lcounts = map (frequencies clauses) pvs 
                          (_, p) = List.maximum lcounts
                      in dpll (Set.insert [p] clauses)
                         || dpll (Set.insert [(negate p)] clauses)
```

In our definitions for `isTautology`, etc., we can use `dpll` instead of
`dp`...if we want to use the `dpll` algorithm instead, that is.

### Optimizations

There are two possible optimizations we can make:
[Conflict-Driven Clause Learning](http://en.wikipedia.org/wiki/Conflict-Driven_Clause_Learning)
and [Backjumping](http://en.wikipedia.org/wiki/Backjumping).

Well, there is low hanging fruit in determining better heuristics for
splitting. We leave this as an exercise for the reader ;)

#### Lemma: Iterative DPLL

This isn't an optimization *per se*, but it is necessary for many modern
optimizations. We could use a trail to keep track of the guesses we make. We
introduce some data structure to keep track of what we do:

```haskell
data TrailMix = Deduced | Guessed deriving (Eq, Ord)

type Trail = (Formula, TrailMix)

--- The following are just for simplifying the code
type Clauses = [[Formula]]
type Clause = [Formula]

--- Return the atom in the literal
litAbs :: Formula -> Formula
litAbs (Not p) = p
litAbs fm = fm
```

We will keep track of a list of `Trail` values. Just a warning: for
speed, we have a `Trail` use a companion `Map Formula Formula` to keep
track of which literals we've worked with so far (checking membership is
`O(log N)`, nice).

We want to filter our clauses to remove literals in the trail. This is a
simple `map (filter blah)` type function:

```haskell
-- | Updates the clauses to remove negated literals which do not belong to
-- the trail, as specified by the map.
removeTrailedNegLits :: Map.Map Formula Formula -> Clauses -> Clauses
removeTrailedNegLits m = map (filter (not . (`Map.member` m) . negate))
```

We also want to generate, for each clause, a list `[Maybe Formula]`
which is `Nothing` if the literal is in the trail, and `Just c` if it's
not.

```haskell
-- | Given a 'Map.Map Formula Formula', and a list '[Formula]',
-- for each element in our list, check if it's a member of the map;
-- if so, map it to 'Just fm', otherwise map it to 'Nothing'.
maybeInclude :: Map.Map Formula Formula -> [Formula] -> [Maybe Formula]
maybeInclude m (c:cls) = if Map.member c m
                         then Nothing : maybeInclude m cls
                         else Just c : maybeInclude m cls
maybeInclude _ [] = []
```

The last thing we'd like to think about are the undefined units, well,
the units not in the trail.

```haskell
-- | Get all the units from the clauses which are undefined according
-- to our dictionary.
undefinedUnits :: Map.Map Formula Formula -> Clauses -> [Formula]
undefinedUnits m = Set.unions . map (catMaybes . maybeInclude m)
```

We clean up the clauses, "subpropagate" as apparently the literature
calls it, to be consistent with the trail. If there are no undefined
unit literals, then we're at the end of the trail.

If we have some undefined literals, we can extend the trail with
them. So why not extend the trail as far as possible? This is the task
relegated to subpropagation. Indeed, subpropagation returns the updated
clauses and trail.

```haskell
-- | We keep track of the trail history in the @Map.Map Formula Formula@
-- parameter, the given clause is the first parameter, and the @[Trail]@
-- stars as itself.
unitSubpropagate :: (Clauses, Map.Map Formula Formula, [Trail])
                    -> (Clauses, Map.Map Formula Formula, [Trail])
unitSubpropagate (cls, m, trail) =
  let cls' = removeTrailedNegLits m cls
      newunits = undefinedUnits m cls'
  in if null newunits
     then (cls', m, trail)
     else let trail' = foldr (\l t -> (l, Deduced):t) trail newunits
              m' = foldr (\l mp -> Map.insert l l mp) m newunits
          in unitSubpropagate (cls', m', trail') --- recursion very important!!
```

Now our unit propagation ([recall](#unit-propagation) attempts to get
rid of all "units", or single literals) should take advantage of this
subpropagation:

```haskell
-- | Unit propagation using the newfangled 'Trail'.
btUnitPropagation :: (Clauses, [Trail]) -> (Clauses, [Trail])
btUnitPropagation (cls, trail) =
  let m = foldr (\(l,_) mp -> Map.insert l l mp) Map.empty trail
      (cls', _, trail') = unitSubpropagate (cls, m, trail)
  in (cls', trail')
```

**Caution:** Generating the `m` with `foldr` may actually be expensive
time-wise. I'm sure there's a smarter way to handle this situation, I
just don't know it. (End of Caution, back to recklessness)

The iterative DPLL then takes advantage of this backtracking unit
propagator "in the obvious way". We actually don't need the
affirmative-negative rule, since backtracking handles things quite well.

We have two helper functions, first when we get a **"Conflict"** or an
unsatisfiable result, we can `backtrack` the trail until we last took a
guess. This is simply:

```haskell
backtrack :: [Trail] -> [Trail]
backtrack ((_, Deduced):tt) = backtrack tt
backtrack tt = tt
```

But we also have to get all the literals unassigned to the trail, which
is simply a set difference:

```haskell
-- | All the literals in the clauses not yet assigned to the trail yet.
unassigned :: Clauses -> [Trail] -> [Formula]
unassigned cls trail = Set.difference
                       (Set.unions (Set.image (Set.image litAbs) cls))
                       (Set.image (litAbs . fst) trail)
```

Then the iterative DPLL algorithm becomes a straightforward
[backtracking](http://en.wikipedia.org/wiki/Backtracking) algorithm.

```haskell
-- | The DPLL algorithm with backtracking.
dpli :: Clauses -> [Trail] -> Bool
dpli cls trail =
  let (cls', trail') = btUnitPropagation (cls, trail)
      hasConflict = elem []
  in if hasConflict cls'                          --- if we get the empty clause
     then case backtrack trail of                 --- backtrack until
           (p, Guessed):tt                        --- we guessed last
             -> dpli cls ((negate p, Deduced):tt) --- and guess again!
           _ -> False                             --- unless we can't
     else case unassigned cls trail' of           --- otherwise
           [] -> True   --- it's satisfiable if there are no unassigned literals
           ps -> let (_, p) = Data.List.maximum
                              $ map (frequencies cls') ps
                 in dpli cls ((p, Guessed):trail') --- recur with the next
                                                   --- best guess
```

#### Backjumping, Conflict-Driven Clause Learning

The first optimization scheme presents itself:
[backjumping](http://en.wikipedia.org/wiki/Backjumping). The basic
problem is we walked too far down the wrong road, but eventually found
something important. Our algorithm will exhaustively walk back, until we
get back to the right track. That's a fool's errand, and a huge waste of
time.

Instead, we could jump back immediately with what we've got. Well, jump
back a few more places than we'd normally allow:

```haskell
backjump :: Clauses -> Formula -> [Trail] -> [Trail]
backjump cls p trail =
  case backtrack trail of
   (q, Guessed):tt -> let (cls', trail') = btUnitPropagate (cls, (p,Guessed):tt)
                      in if [] `elem` cls'
                         then backjump cls p tt
                         else trail
   _ -> trail
```

Then we can add a **"Conflict Clause"** to the overall formula, which is
just negating the conjunction of the decision literals in the
trail. This trick (adding conflict clauses to our problem) is called
**"Learning"**.

```haskell
guessedLiterals :: [Trail] -> [Trail]
guessedLiterals ((p, Guessed):tt) = (p, Guessed):guessedLiterals tt
guessedLiterals ((_, Deduced):tt) = guessedLiterals tt
guessedLiterals [] = []

-- | DPLL with backjumping.
dplb :: Clauses -> [Trail] -> Bool
dplb cls trail =
  let (cls', trail') = btUnitPropagation (cls, trail)
      hasConflicts = ([] `elem`)
  in if [] `elem` cls'                             --- if there are conflicts
     then case backtrack trail of 
           (p, Guessed):tt ->                      --- and we can backtrack 
             let trail'' = backjump cls p tt       --- we use our newfangled
                 declits = guessedLiterals trail'' --- backjumping algorithm!
                 conflict = Set.insert (negate p)
                            (Set.image (negate . fst) declits)
             in dplb (conflict:cls) (Set.insert (negate p, Deduced) trail'')
           _ -> False
     else case unassigned cls trail' of            --- otherwise iterate
           [] -> True                              --- exactly like we did
           ps -> let (_,p) = Data.List.maximum     --- before, recursively
                             $ map (frequencies cls') ps
                 in dplb cls ((p, Guessed):trail')
```

There is a vast literature on this subject, which I do not think I could
even hope to scratch.

# Conclusion

We have just introduced the definitional CNF, which is a slicker way to
get a formula in conjunctive normal form.

Then we introduced the Davis-Putnam algorithm, which recursively
transformed a set of clauses until we ended up with either (i) an empty
list of clauses, or (ii) a contradictory clause appeared. In the former
case, it terminated with `True` &mdash; the given set of clauses *are*
satisfiable; whereas the latter case clearly resulted in `False`, the
clauses are unsatisfiable.

We then introduced a modified version, tweaking only the third
step. This is the DPLL algorithm.

Next time, we'll move on to first order logic (huzzah). We might have
some aside on using Binary Decision Diagrams. As far as I can tell (and
I may very well be wrong!), Binary Decision Diagrams just present a new
presentation of the same problem, but no "big wins".

For the sake of completeness, I mention there exists a method called
[Stålmarck's method](http://www.csc.kth.se/~jakobn/research/mastersthesis.pdf),
but won't examine it because it's patented...and I'm no lawyer (with my
luck, I'll accidentally break some law, and serve time for learning how
things work &mdash; only in America!).

# References

- John Harrison,
  *Handbook of Practical Logic and Automated Reasoning*.
  Cambridge, 2009.
- Andreas Nonnengart and Christoph Widenbach,
  "Computing Small Clause Normal Form".
  In *Handbook of Automated Reasoning*
  (Alan Robinson and Andrei Voronkov, eds.),
  Elsevier Science, 2001, pp 335-367
- Donald Knuth,
  *The Art of Computer Programming*.
  Volume 4, [Fascicles 6A](http://www-cs-faculty.stanford.edu/~uno/fasc6a.ps.gz)
  "A (Partial) Draft of Section 7.2.2.2: Satisfiability". (A "mere" 260 pages!)
  
## Definitional CNF
- "Can someone please explain 3-CNF for me?"
  [Math.SX](http://math.stackexchange.com/q/56369)
- Hasan Amjad,
  "LCF-Style Propositional Simplification with BDDs and SAT Solvers".
  Eprint [citeseerx](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.93.6675&rep=rep1&type=pdf),
  In *Theorem Proving in Higher Order Logics*
  (Otmane Ait Mohamed, César Munoz, Sofiène Tahar, eds.)
  Lecture Notes in Computer Science, Volume 5170, 2008, pp 55-70 [doi:10.1007/978-3-540-71067-7_9](http://dx.doi.org/10.1007/978-3-540-71067-7_9)
- G.S. Tseitin
  "On the complexity of derivation in propositional calculus".
  In: (J. Siekmann, G. Wrightson, eds.)
  *Automation Of Reasoning: Classical Papers On Computational Logic,
  Vol. II, 1967-1970*, pp. 466–483. Springer, Heidelberg (1983)
- Barry Watson,
  "Conjunctive Normal Form (CNF)".
  Computational Logic Notes, [webpage](http://barrywatson.se/cl/cl_definitional_cnf.html).

## Davis-Putnam Algorithm
- "How does the DPLL algorithm work?" [Thread on SO](http://stackoverflow.com/q/12547160)
- John Harrison, "A Survey of Automated Theorem Proving".
  Lectures 28-29 September 2013 given at Computer Science Club at POMI Academy of Sciences.
  Lecture 1, [22:16](http://youtu.be/Nydg-N83VYc?t=22m16s)
- H. Zhang and M. Stickel,
  "An efficient algorithm for unit-propagation".
  In *Proceedings of the Fourth International Symposium on Artificial Intelligence and Mathematics* (1996).
  [Eprint](http://www.cfdvs.iitb.ac.in/download/Docs/verification/papers/sat/original-papers/aim96.pdf)

## Changelog
Mar  8, 2015: Fixed typos.

Feb 27, 2015: Added some more explanation in the comments.

Feb 15, 2015: Initial version.
