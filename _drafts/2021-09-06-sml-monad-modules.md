---
layout: post
title: Monads as Modules in Standard ML
published: false
draft: true
quote: "But in simple substances the influence of one monad over another is ideal only,..."
quoteSource: Leibniz, <i>Monadology</i> &sect;51 (1714)
tags: [Standard ML]
---

Last time, we [discussed the `IO` monad in Standard ML]({% post_url 2021-07-29-monadic-io-in-ml %})
using an `abstype`. This time, we'll see if we can repackage it using
Standard ML modules.

# Modules

Standard ML modules consist of signatures, structures, and functors. The
textbook analogy given:

- A structure is a "collection of values"
- Signatures are "types" of Structures
- Functors are "parametrized" Structures

And no: **Functors have nothing to do with category theory, it's just a
poorly chosen name.**

For us, we introduce a signature for monads, so we can say things like,
"If you give me a structure which implements the monad signature, then...".

```sml
(* in monad.sig *)

signature MONAD = sig
    type 'a m;

    val return : 'a -> 'a m;
    val bind : 'a m -> ('a -> 'b m) -> 'b m;
end;
```

Observe the first declaration in the signature, `type 'a m`, declares an
_abstract type_. We don't know how it's implemented, we don't know its
type constructors, we can't access anything about its internals.

We can recast the IO monad from last time as:

```sml
(* also in monad.sig *)

signature IO_MONAD =
sig
    include MONAD

    val exec : 'a m -> 'a;
    val >>= : 'a m * ('a -> 'b m) -> 'b m;
    val getStr : int -> TextIO.vector m;
    val putStr : string -> unit m;
end;
```

Now we can actually implement the IO monad as a structure:

```sml
structure Io : IO_MONAD =
struct
    datatype 'a m = JOB of unit -> 'a;

    fun return x = JOB (fn _ => x);
    fun exec (JOB f) = f ();
    fun bind (JOB f) q = JOB (fn _ => exec (q (f ())));
    fun ioM >>= q = bind ioM q;
    fun getStr n = JOB (fn _ => TextIO.inputN(TextIO.stdIn, n));
    fun putStr s = JOB (fn _ => print s);
end;
```

# Reader Monad

The `Reader` monad, in Haskell, should be thought of as `m = (->) r` for
the type constructor. This turns out to be the "correct" way of thinking
of it category theoretically: in an appropriate category `C`, and an
object `r`, the Reader monad is given by the internal hom-set
`[R,-] : C -> C`. (The "appropriate category" needs to be Cartesian
closed.)



# Monad Transformers as Functors

Let's review the notion of a monad transformer: given some monad as a
type constructor

We can treat monad transformers as functors which produce something
_more_ than a meagre monad:

```sml
signature MONAD_TRANSFORMER = sig
    include MONAD where type 'a m =
end;


```

Compare to Haskell's [`MonadTrans`](https://hackage.haskell.org/package/transformers-0.6.0.2/docs/Control-Monad-Trans-Class.html)
class.

[`StateT`](https://hackage.haskell.org/package/mtl-2.2.2/docs/Control-Monad-State-Lazy.html#g:3)

# References

- Sheng Liang, Paul Hudak, and Mark P. Jones,
  "Monad Transformers and Modular Interpreters".
  In _Conference Record of POPL'95: 22nd ACM SIGPLAN-SIGACT Symposium on Principles of Programming Languages_, San Francisco, CA, January 1995.
  [Eprint](https://web.cecs.pdx.edu/~mpj/pubs/modinterp.html); this
  appears to be the paper which first introduced "monad transformers".
- [Encode rank-2 polymorphism equivalent in SML](https://stackoverflow.com/q/24135774);
  Stackoverflow thread
- [Monads and value restriction in ML](https://stackoverflow.com/q/40192767/1296973),
  Stack Overflow thread
- Mark P. Jones,
  [Functional Programming with Overloading and Higher-Order Polymorphism](https://web.cecs.pdx.edu/~mpj/pubs/springschool.html).
  In _First International Spring School on Advanced Functional Programming Techniques, Baastad, Sweden_, Springer-Verlag Lecture Notes in Computer Science 925, May 1995.
