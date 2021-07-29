---
layout: post
title: Monadic IO in Standard ML
published: true
draft: false
quote: "The Monad, of which we shall here speak, is nothing but a simple substance, which enters into compounds."
quoteSource: Leibniz, <i>Monadology</i> (1714)
tags: [Standard ML]
---

As a Haskeller learning Standard ML, I wondered: could one write
exclusively "pure" Standard ML? There are a lot of practical reasons why
you would want to _avoid_ this, which I'll get to later, but right now
it _seems_ like we should be able to do something like Monadic
input/output in Standard ML.

# Puzzle: Impure Currying

For the time being, suppose we can distinguish "pure functions" (written
generically as `f : a -> b`) from "impure functions" (written
generically as `f : a ~> b`). We know we can curry pure functions, that
is, we have an isomorphism of types

```sml
('a, 'b) -> 'c == 'a -> ('b -> 'c)
```

Naively, we may hope to curry impure functions similarly

```sml
naive: ('a, 'b) ~> 'c == 'a ~> ('b ~> 'c)
```

But if `f : ('a,'b) ~> 'c` and `curryF` is its curried form, then is
`curryF val_a` going to trigger any side effects? 

No! It's not until a second argument is supplied to `curryF` will impure
side effects be triggered. This suggests the correct form should be

```sml
('a, 'b) ~> 'c == 'a -> ('b ~> 'c)
                 (*  ^^ pure *)
```

So far so good, right? Well, what does this have to do with monadic IO?

# Deriving an IO Type

We see that `('a, unit)` is isomorphic to `'a`. (This isomorphism is
unique up to unique isomorphism, just using the universal properties of
the product object.) Plugging in `'b = unit` to the Currying isomorphism
for impure functions:

```sml
('a, unit) ~> 'c == 'a -> (unit ~> 'c)
```

Then using the isomorphism of `('a, unit)` with `'a` on the left-hand
side gives us

```sml
'a ~> 'c == 'a -> (unit ~> 'c)
```

which gives us an isomorphism of an impure function type on the left,
with a pure function on the right. We just christen the `unit ~> 'c`
type as `IO 'c` (or, in Standard ML, it would be 
`type 'c IO = IO of unit -> 'c`).

# We want Monads!

Where are the `>>=` and `return` functions? Where are the monads? Where
are the snowdens of yesteryear?

We can implement monadic IO in a straightforward manner, using the
result of Gordon's 1994 PhD thesis (table 9.1). Well, we patch his code
so it works:

```sml
infixr 1 >> >>=
abstype 'a Job = JOB of unit -> 'a
with
    fun exec (JOB f)  = f ()
    fun return x      = JOB (fn _ => x)
    fun (JOB f) >>= q = JOB (fn _ => exec (q (f ())))
    fun getStr n      = JOB (fn _ => TextIO.inputN(TextIO.stdIn, n))
    fun putStr s      = JOB (fn _ => print s)
end

fun p >> q  =  p >>= (fn _ => q);

fun gettingLine s =
    getStr 1 >>= (fn c => if c = "\n"
                          then return(s)
                          else gettingLine (s^c));

val getLine = gettingLine "";

val main =
    putStr "First name: " >> getLine >>= (fn first =>
    putStr "Second name: " >> getLine >>= (fn second =>
    putStr ("Hello "^first^" "^second^"\n")));

(* exec main; *)
```

**Exercise 1.** Implement this monadic IO as a `struct`.
(End of Exercise 1)

# Conclusion: "More Monads! More Monads!"?

I'm mulling over how to approach monadic coding in Standard ML. One of
the reasons I'm doing this in Standard ML is, well, there's an austere
beauty to Standard ML that I find in Lisp: Standard ML is a "bare bones"
language which allows you to grow around. 

But now that I've coded up monadic I/O (or, more precisely, have
summarized the work others have done), I'm not sure how profitable it
would be to continue investigating monads in Standard ML. It's a bit of
a parlor game: amusing but useless.

From the perspective of Standard ML, the only other impure effect which
needs to be wrapped in a monad would be references...or something. I
imagine this would be done with of Haskell's `IORef`, `STRef`, and
ultimately `MutVar` primitive.

On the other hand, for monads, I imagine the only interesting monads
worth implementing would be `State` and `ST`, but I also could be
pursuaded that `Functor` and `Applicative` would be fun.

**Remark** (As a Parlor Game...)**.**
I do think it is _fun_ trying to implement Haskell concepts in Standard
ML, just to better understand the concept. I'm not sure it's worth doing
for production stuff. This "growing a Haskell" is a curious challenge,
but one like sudoku: I don't imagine it ever being useful in real life.

There may be further monads worth playing with, or creating a hierarchy
of monad modules.
(End of Remark)

# Appendix: Should we be Pure in Standard ML?

There's some folklore suggesting there's performance hits if we try
being pure in a call-by-value language. Pippenger first published this
result using a small Lisp.

Bird and friends cleared this up, that lazy languages do not experience
similar performance hits.

Together, these papers have been heralded as the alpha and omega on the
subject of pure functional programming: it is performant only in lazy
languages. 

- N.Pippenger, "Pure versus impure Lisp".
  _ACM Trans. Program. Lang. Syst._ **19**, 2 (1997) pp.223--238;
  [Semantic Scholar](https://www.semanticscholar.org/paper/Pure-versus-impure-Lisp-Pippenger/c86b16a0905ccfd54180c8f5e9d2f87b35769949)
- Bird and friends, [More haste, less speed: lazy versus eager evaluation](https://www.cs.ox.ac.uk/richard.bird/online/BirdJonesDeMoor1997More.pdf) (1997)

# References

- Andrew Gordon,
  "Functional Programming and Input/Output".
  Ph.D. Thesis, Cambridge, 1994; [eprint](https://www.microsoft.com/en-us/research/publication/functional-programming-input-output/)
- Philip Wadler,
  "How to Declare an Imperative".
  [Eprint](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.91.3579&rep=rep1&type=pdf)
  - Also see Chi's [answer](https://stackoverflow.com/a/51772273/1296973) on stackoverflow, which inspired the more
    explicit derivation using `~>` impure function types

## Monads in Standard ML

- Robert Harper, [Of Course ML Has Monads!](https://existentialtype.wordpress.com/2011/05/01/of-course-ml-has-monads/)
- Michael Sullivan has [implemented monads](https://github.com/msullivan/sml-util/blob/master/hacks/monad.sml)
  using Standard ML modules, following Harper's blog post.
- Stefan Kahrs,
  "First-Class Polymorphism for ML".
  In: Sannella D. (eds) _Programming Languages and Systems — ESOP '94_. 
  ESOP 1994. Lecture Notes in Computer Science, vol 788. Springer,
  Berlin, Heidelberg. https://doi.org/10.1007/3-540-57880-3_22 Eprint.
  - This is particularly interesting, an overlooked article which
    explicitly gives an example of a monad in Standard ML in section 2.
- Mads Sig Ager, Olivier Danvy, Jan Midtgaard,
  "A Functional Correspondence between Monadic Evaluators and Abstract Machinesfor Languages with Computational Effects".
  [BRICS preprint](https://www.brics.dk/RS/03/35/BRICS-RS-03-35.pdf), 34
  pages; implements monads in Standard ML.
- Yutaka Nagashima, Liam O'Connor,
  "Close Encounters of the Higher Kind Emulating Constructor Classes in Standard ML".
  [arXiv:1608.03350](https://arxiv.org/abs/1608.03350), 3 pages;
  - Implements Applicative, Monad, etc., in Standard ML. The code is [available](https://www.isa-afp.org/browser_info/current/AFP/Proof_Strategy_Language/files/Constructor_Class.ML.html) with some [instances](https://www.isa-afp.org/browser_info/current/AFP/Proof_Strategy_Language/files/Instantiation.ML.html). (It was discussed on a [blog](https://keens.github.io/blog/2016/10/10/smldemonado/), if you can read Japanese...also see [PreML](https://github.com/br0ns/PreML) for do-notation in Standard ML.)
