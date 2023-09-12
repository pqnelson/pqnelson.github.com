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
`type 'c IO = IO of unit -> 'c`). Well, `IO` is reserved as a module
name, so let's call it `JOB` instead.

# We want Monads!

Where are the `>>=` and `return` functions? Where are the monads? Where
are the snowdens of yesteryear?

For simplicity, we'll just try to wrap around `print : string -> unit`
and `TextIO.inputN : TextIO.instream * int -> TextIO.vector`. These, uh,
don't look like they match the `unit -> 'c` signature we were hoping
for...so, what do we do?

The trick: think of `print : string ~> unit` which would have its type
be isomorphic to `string -> (unit ~> unit) = string -> unit JOB`. So we
can encode `print` as a monadic function `putStr : string -> unit JOB`.

Similarly, `inputN : TextIO.instream * int ~> TextIO.vector` would
have its type be isomorphic to (by Currying)
`int -> (TextIO.instream ~> TextIO.vector)`.
We see `TextIO.instream ~> TextIO.vector = TextIO.instream -> (unit ~> TextIO.vector)`.
Thus `inputN' : int -> TextIO.instream -> TextIO.vector JOB` is an
isomorphic Curried version; fixing the input stream to be `stdin` gives
us a `getStr : int -> TextIO.vector JOB` function.

Converting these impure functions into monadic counter-parts requires
similar "massaging" of type signatures to figure out how to implement them.

In this manner, we can implement monadic IO in a straightforward manner.
This is all found in the results of Gordon's 1994 PhD thesis (table
9.1). Well, we patch his code so it works:

```sml
infix 1 >> >>=
abstype 'a Job = JOB of unit -> 'a
with
    (* exec : 'a Job -> 'a *)
    fun exec (JOB f)  = f ()
    (* return : 'a -> 'a Job *)
    fun return x      = JOB (fn _ => x)
    (* (>>=) : 'a Job * ('a -> 'b Job) -> 'b Job *)
    fun (JOB f) >>= q = JOB (fn _ => exec (q (f ())))
    (* getStr : int -> TextIO.vector Job *)
    fun getStr n      = JOB (fn _ => TextIO.inputN(TextIO.stdIn, n))
    (* putStr : string -> unit Job *)
    fun putStr s      = JOB (fn _ => print s)
end

(* (>>) : 'a Job * 'b Job -> 'b Job *)
fun p >> q  =  p >>= (fn _ => q);

(* gettingLine : string -> string Job *)
fun gettingLine s =
    getStr 1 >>= (fn c => if c = "\n"
                          then return(s)
                          else gettingLine (s^c));

(* getLine : string Job *)
val getLine = gettingLine "";

val main : unit Job =
    putStr "First name: " >> getLine >>= (fn first =>
    putStr "Second name: " >> getLine >>= (fn second =>
    putStr ("Hello "^first^" "^second^"\n")));
(* exec main; *)
```

**Exercise 1.** Prove the `>>=` and `return` functions we just
implemented actually satisfies the monad laws.
(End of Exercise 1)

**Exercise 2.** Implement this monadic IO as a `struct`.
(End of Exercise 2)

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

# Haskell's Implementation of IO

Under the hood, Haskell follows a remarkably similar strategy. The
definition of `IO a` may be found in [GHC.Types](https://github.com/ghc/ghc/blob/b73c9c5face16cc8bedf4168ce10770c7cc67f80/libraries/ghc-prim/GHC/Types.hs#L233):

```haskell
{- |
A value of type @'IO' a@ is a computation which, when performed,
does some I\/O before returning a value of type @a@.
There is really only one way to \"perform\" an I\/O action: bind it to
@Main.main@ in your program.  When your program is run, the I\/O will
be performed.  It isn't possible to perform I\/O from an arbitrary
function, unless that function is itself in the 'IO' monad and called
at some point, directly or indirectly, from @Main.main@.
'IO' is a monad, so 'IO' actions can be combined using either the do-notation
or the 'Prelude.>>' and 'Prelude.>>=' operations from the 'Prelude.Monad'
class.
-}
newtype IO a = IO (State# RealWorld -> (# State# RealWorld, a #))
```

The `State# RealWorld` is effectively a unit type, but we cannot access
its values. Both `State#` and `RealWorld` are builtin primitive ops,
discussed in [primops.txt](https://github.com/ghc/ghc/blob/a7f9670e899bcbc87276446a1aac2304cade2b2f/compiler/GHC/Builtin/primops.txt.pp#L2759-L2769).

**Caution:** There is a lot of subtlety here surrounding `State#` and
the `RealWorld`. The `State# a` is not implemented at all under the
hood, it's just used to keep track of types. Arguably, `State# a` is
empty, but that is for deeply magical reasons and ought not be taken
_too_ seriously. (End of caution)

Compare this to our implementation in Standard ML, whic roughly looks
like:
```sml
(* Standard ML *)
datatype 'a IO = IO of unit -> 'a
```
Since `'a` is isomorphic to `unit * 'a`, we could write some code to
make the connections obvious:
```sml
(* Standard ML *)
type RealWorld = unit;
type 'a State' = unit;
datatype 'a IO = IO of RealWorld State' -> RealWorld State' * 'a;
```
So far, Haskell and Standard ML have isomorphic types.

The functions describing `IO a` as a monad are defined in [GHC.Base](https://github.com/ghc/ghc/blob/0619fb0fb14a98f04aac5f031f6566419fd27495/libraries/base/GHC/Base.hs#L1575-L1579)
as:

```haskell
-- Haskell
returnIO :: a -> IO a
returnIO x = IO (\ s -> (# s, x #))

bindIO :: IO a -> (a -> IO b) -> IO b
bindIO (IO m) k = IO (\ s -> case m s of (# new_s, a #) -> unIO (k a) new_s)
```

The Standard ML implementation is similar but far more convoluted than
the implementation we offered above. This is because we would have to
imitate the [ST monad](https://github.com/ghc/ghc/blob/541aedcd9023445b8e914d595ae8dcf2e799d618/libraries/base/GHC/ST.hs#L52) `type ST s a = ST (State# s -> (State# s, a))` monad with
the `RealWorld` thread. The relevant code would look like:

```sml
(* Standard ML *)

fun returnIO x = IO (fn s => (s, x));

fun bindIO (IO m) k =
    IO (fn s =>
           case m s of
               (new_s, a) => (unIO (k a)) new_s);

fun unIO (IO a) = a;
```

But if we wanted to actually rewrite the `abstype 'a Job` to imitate the
Haskell implementation, we would have:

```sml
(* Mock out the "State#" and "RealWorld". We use "State'" as the
identifier, since "State#" is not a valid SML identifier. *)
type 'a State' = unit;
type RealWorld = unit;

infix 1 >> >>=
abstype 'a Job = JOB of RealWorld State' -> RealWorld State' * 'a
with
    (* exec : 'a Job -> 'a *)
    fun exec (JOB f)  = let val (_, a) = f () in a end;

    (* return : 'a -> 'a Job *)
    fun return x      = JOB (fn s => (s, x))
    
    (* (>>=) : 'a Job * ('a -> 'b Job) -> 'b Job *)
    local fun unIO (JOB a) = a
    in fun (JOB m : 'a Job) >>= (k : 'a -> 'b Job)
           = JOB (fn s => case m s of
                              (new_s, a) => (unIO (k a)) new_s)
    end
    
    (* getStr : int -> TextIO.vector Job *)
    fun getStr n      = JOB (fn s => (s, TextIO.inputN(TextIO.stdIn, n)))
    
    (* putStr : string -> unit Job *)
    fun putStr str    = JOB (fn s => (s, print str))
end;
```

The rest of the code can be run without any changes.

**Exercise 4.** Prove the two implementations of the `abstype 'a Job`
are isomorphic.

**Exercise 5.** Implement `hPutStr : TextIO.outstream -> TextIO.vector -> unit Job`.

**Exercise 6.** Implement `hGetLine : TextIO.instream -> TextIO.vector Job`.

**Exercise 7.** Think about Haskell's [handles](https://github.com/ghc/ghc/blob/29bcd9363f2712524f7720377f19cb885adf2825/libraries/base/GHC/IO/Handle/Types.hs#L99-L140)
implementation, which is roughly the union of a [`Reader`](https://smlfamily.github.io/Basis/prim-io.html#SIG:PRIM_IO.reader:TY:SPEC)
and [`Writer`](https://smlfamily.github.io/Basis/prim-io.html#SIG:PRIM_IO.writer:TY)
(or perhaps [`instream`](https://smlfamily.github.io/Basis/stream-io.html#SIG:STREAM_IO.instream:TY)
and [`outstream`](https://smlfamily.github.io/Basis/stream-io.html#SIG:STREAM_IO.outstream:TY))
in Standard ML. What's the trade-offs involved in implementing your own
`handle` datatype in Standard ML?

**Remark.**
If you're interested in what this could look like using Standard ML
modules, I've written a [gist](https://gist.github.com/pqnelson/4ff12e27d822766bc0a9a9372a0ca166)
sketching out the implementation.
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
