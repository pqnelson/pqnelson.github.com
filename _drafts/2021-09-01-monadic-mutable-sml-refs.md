---
layout: post
title: Monadic Mutable Refs in Standard ML
published: false
draft: true
quote: "But in simple substances the influence of one monad over another is ideal only,..."
quoteSource: Leibniz, <i>Monadology</i> &sect;51 (1714)
tags: [Standard ML]
---

**Puzzle:** Given the `eqtype 'a ref` reference type in Standard ML,
equipped with the value lookup operation `(op !) : 'a ref -> a` and update
operation `(op :=) : 'a ref * 'a -> unit`, can we form a monadic structure
around it?
(End Puzzle)

I'm vaguely aware of
[`MutVar`](https://hackage.haskell.org/package/primitive-0.7.2.0/docs/Data-Primitive-MutVar.html)
in Haskell...but as we've seen with Monadic IO in Standard ML, the
Haskell constructs don't really translate to Standard ML: whereas
Haskell had `newtype IO a = IO (State# RealWorld -> (# State# RealWorld, a #))`,
Standard ML would have `type 'a IO = IO of unit -> 'a`.

(Arguably, we could simply identify `type RealWorld = unit`, since
`unit*'a` is isomorphic to `'a` as types. This is rather convoluted, but
an interesting observation.)

So what would a "monadic reference" look like in Standard ML?

# Warm up: IORef

We piggie back off the monadic IO from last time, and Wadler &
Peyton-Jones's [Imperative Functional Programming](https://www.microsoft.com/en-us/research/wp-content/uploads/1993/01/imperative.pdf)
(viz., section 5.3) to write:

```sml
abstype 'a IORef = REF of 'a ref
with
    (* newIORef : 'a -> ('a IORef) Job *)
    newIORef x = JOB (fn _ => REF (ref x))

    (* writeIORef : 'a IORef -> 'a -> unit Job *)
    writeIORef (REF var) x = JOB (fn _ => var := x)

    (* readIORef : 'a IORef -> 'a Job *)
    readIORef (REF var) = JOB (fn _ => !var)
end;
```

This gives us some intuition for mutable references and monads, namely:
the mutable reference is wrapped within a monad, and the read & write
operations need to appear within the monadic bind operation.

But it also gives us some sense of "Where to go", if we wanted to try to
port [`MutVar`](https://hackage.haskell.org/package/primitive-0.7.2.0/docs/Data-Primitive-MutVar.html)
to Standard ML.

# Attempt 1

Let's see if we can massage the definitions of the operations. We see
that `writeVar : 'a ref * 'a -> unit`, where
`writeVar var aVal = (var := aVal)`
is the attempted definition we want to massage. The first step is to use
the `~>` notation for impure functions, so we have
`writeVar : 'a ref * 'a ~> unit`.

We could try `writeVar : 'a ref -> ('a ~> unit)` which is isomorphic to
`writeVar : 'a ref -> 'a -> (unit ~> unit)`.

Similarly, for reading the value of a reference, we would have
`readVar : 'a ref -> 'a` defined by `readVar var = !var`. Is this impure?
Well, it simply reads the value associated with a reference, there are
no side-effects, so it's pure...ish...but let's try making this
`readVar : 'a ref -> (unit -> 'a)`.

We could attempt
```sml
infix 1 >> >>=
abstype 'a Job = JOB of unit -> 'a | VAR of 'a ref;
with
    (* exec : 'a Job -> 'a *)
    fun exec (JOB f)  = f ()
    (* return : 'a -> 'a Job *)
    fun return x      = JOB (fn _ => x)
    (* (>>=) : 'a Job * ('a -> 'b Job) -> 'b Job *)
    fun (JOB f) >>= q = JOB (fn _ => exec (q (f ())))
    fun readVar (
end

abstype 'a Var = VAR of 'a ref
with
    fun newVar x = VAR ref x;
    fun readVar (VAR x) = !x;
    fun writeVar (VAR x) y = (
end;
```

# Attempt 2

Let's try the following:

```sml
signature MUT_VAR = sig
    type 'a t;
    type 'a ref;

    val newVar : 'a -> ('a ref) t;
    val readVar : 'a ref -> 'a t;
    val writeVar : 'a ref -> 'a -> unit t;

    val run : 'a t -> a; (* breaks soundness *)
end sig
```

# Remaining Impurities Requiring Monadic Treatment

**Puzzle 1.** Come up with a monadic treatment of arrays. (Hint: see
Wadler and Peyton-Jones's "Imperative Functional Programming", section
6.1)



# References

- John Launchbury and Simpon Peyton Jones,
  "State in Haskell".
  [Eprint](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/state-lasc.pdf)
- Haskell
  [`Data.Primitive.MutVar`](https://hackage.haskell.org/package/primitive-0.7.2.0/docs/Data-Primitive-MutVar.html)
- [Primitive Haskell](https://www.fpcomplete.com/haskell/tutorial/primitive-haskell/),
  FP Complete blog post
- [Monads and value restriction in ML](https://stackoverflow.com/q/40192767/1296973),
  Stack Overflow thread
- Ömer Sinan Ağacan,
  [IORef and STRef under the hood](https://osa1.net/posts/2016-07-25-IORef-STRef-exposed.html),
  blog post dated July 25, 2016
-