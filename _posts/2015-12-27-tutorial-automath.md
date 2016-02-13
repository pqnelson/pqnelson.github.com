---
layout: post
title: Tutorial — Automath
published: true
quote: "True education is a kind of never ending story — a matter of continual beginnings, of habitual fresh starts, of persistent newness."
quoteSource: JRR Tolkien, Apocryphal
category: Automath
tags: [Automated Theorem Prover]
permalink: /automath/tutorial
parentURL: /automath/
---

I've been studying the history of theorem provers (I intend to write a
post summarizing the amazing history), and I've been stuck on
Automath. It's a peculiar langauge that closely resembles assembly code,
but has idiosyncratic notions. I'll try to unravel the basics of
Automath in this post, and walkthrough some example code snippets.

# The Basics

**1. Lines.**
We should think of a program (or "text") in Automath as a sequence of
statements (or "lines"). A statement consists of two parts: (a) the
context part, and (b) the body ("meat and potatoes") of the line.

**1.1. Context.**
The "context" is a misleading term, since it suggests something
different in modern languages than in Automath. It is similar to
[variable scope](https://en.wikipedia.org/wiki/Scope_%28computer_science%29),
but combined with
[named parameters](https://en.wikipedia.org/wiki/Named_parameter).

Syntactically, each line starts with:

- a `*` (indicating we're continuing to work in the given context/scope),
- a `<symbol> *` (indicating we're working with specific symbols as named parameters, while continuing to work in the given context), or
- neither of these (indicating we're starting a new scope/context).

**1.2. Body.**
There are three types of lines we can have:

1. Definitions or Abbreviations, which define a new function or constant
   `<fn_identifier> : <type> := <body>`.
2. Variable introduction (or "EB lines"), indicated by the assignment
   `<var_identifier> : <type> := ---` or `<var_identifier> : <type> := EB` or `<var_identifier> : <type> := 'eb'`.
3. Declaring new types or constants as primitive notions (or "PN
   lines"), indicated by `<identifier> : <type> := PRIM` or `<identifier> : <type> := PN`.

**Caution:** We have chosen to stick with the convention `<term> : <type>`
and `<type> : <kind>`, but Automath allows us to place the
type assignment _anywhere_ after the variable, i.e., we could write
`<identifier> := <body> : <type>` just as easily as
`<identifier> : <type> := <body>`. Either convention is valid Automath
code, but since nowadays the convention is `<term> : <type>` and
`<type> : <kind>`, we stick with that. (End of Cautionary Remark)

**1.3. Syntax.**
The syntax for a line varies slightly, because the specification was
mildly free-form. (It was the '60s, after all.) But the basic format
looks like:

<div class="highlight-rouge">
<pre class="highlight">
<code><span class="c1"># This is a comment</span>
  <span class="kr">*</span> <span class="kt">nat</span> : <span class="kr">TYPE</span> := <span class="nf">PN</span> <span class="c1"># Define a new type called "nat"</span>
  <span class="kr">*</span>   <span class="kt">1</span> : <span class="kr">nat</span>  := <span class="nf">PN</span> <span class="c1"># Define a new constant "1" in nat</span>
  <span class="kr">*</span>   <span class="kt">x</span> : <span class="kr">nat</span>  := <span class="nf">---</span> <span class="c1"># Define a new variable "x" in nat</span></code>
</pre>
</div>

I've highlighted in blue the new variable introduced, or the new entity
being defined.

The `*` at the beginning of each line tells us "This line continues to
use the previous line's context". This means that previous definitions,
variables, etc., are all "in scope".

**1.4. Functions.**
Defining functions requires variables to be in the context. That is to
say, we treat the context as a "queue" of parameters, and we specify the
"endpoint" in the stack to refer to a slice (from the start to the
endpoint) as the parameters for the given function.

<div class="highlight-rouge">
<pre class="highlight">
<code><span class="c1"># To define a function, we need a variable explicitly in context.</span>
<span class="c1"># We have introduced "x" as a variable natural number, so we can</span>
<span class="c1"># use "x"--and all variables defined before it--as the function parameter.</span>
x <span class="kr">*</span> <span class="kt">successor</span> : <span class="kr">nat</span> := <span class="nf">PN</span> <span class="c1"># Define a new function called "successor"</span>
  <span class="kr">*</span> <span class="kt">2</span>         : <span class="kr">nat</span> := successor(1) <span class="c1"># Define a new term "2" defined as calling "successor" on "1"</span>
  <span class="kr">*</span> <span class="kt">3</span>         : <span class="kr">nat</span> := successor(2) <span class="c1"># Define a new term "3"</span></code>
</pre>
</div>

This is rather subtle, because it's unlike any modern programming language.
We can use a more modern approach, and use lambda abstractions to
specify the parameters for the routine. We can introduce this alternate
approach, consider the following snippet:

<div class="highlight-rouge">
<pre class="highlight">
<code><span class="c1"># The "successor" function is still in context, thanks to asterisk.</span>
<span class="c1"># Function composition is done by hand, e.g., the following.</span>
x <span class="kr">*</span> <span class="kt">plustwo</span> : <span class="kr">nat</span> := successor(successor) <span class="c1"># Define a new function called "plustwo"</span>
  <span class="kr">*</span> <span class="kt">succfun</span> : <span class="kr">[x:nat]nat</span> := [x:nat]successor(x) <span class="c1"># Define a new function via lambda abstraction</span>
  <span class="kr">*</span> <span class="kt">3alt</span>    : <span class="kr">nat</span> := <2>succfun <span class="c1"># Define a new term "3alt" via lambda calculus' "apply"</span></code>
</pre>
</div>

Notice that we have `λ x:type . body` become `[x:type] body`, and `apply f x`
become `<x>f`. This is quirky Automath notation. Also observe, for
`succfun`, its type is a function-type, hence its type is `[x:nat]nat`.

**1.5. Remark (Context).**
The context for a line is the "function parameters" needed for that
line. Furthermore, if we introduce a variable into context, something like

<div class="highlight-rouge">
<pre class="highlight">
<code>  <span class="kr">*</span>         <span class="kt">x</span> : <span class="kr">nat</span>  := <span class="nf">---</span> <span class="c1"># Define a new variable "x" in nat</span>
x <span class="kr">*</span> <span class="kt">successor</span> : <span class="kr">nat</span> := <span class="nf">PN</span> <span class="c1"># Define a new function called "successor"</span></code>
</pre>
</div>

This is equivalent to the following:

<div class="highlight-rouge">
<pre class="highlight">
<code>  <span class="kr">*</span> [x:nat] <span class="kt">successor</span> : <span class="kr">nat</span> := <span class="nf">PN</span> <span class="c1"># Define a new function called "successor"</span></code>
</pre>
</div>

That is to say, a variable introduction line `* x : nat := ---` is the
same as writing `[x:nat]`. 

**1.6. Remark (Types).**
There is some subtlety here, because we can have ["dependent types"](https://en.wikipedia.org/wiki/Dependent_type). That
is to say, we have lambda expressions `[x:t]body` which takes in a term,
and produces a type. Why would this be useful?

The textbook example is to eliminate bounds checking for lists. The
not-so-textbook-example is to make sure that deductions are
sensible. Lets investigate this latter example more fully.

But we should note, we're not working in the "lambda cube". We don't
have a dependent product type, `Π x:type . body`, because we have a
lambda-typed lambda calculus.

# First Order Logic

**2.**
First-order logic is probably the next interesting system to look at,
and exemplifies a lot of the syntax & semantics of Automath.

**2.0.1. Reference.**
I'm borrowing this section's code from Freek Wiedijk's
[Automath restaurant](https://www.cs.ru.nl/~freek/zfc-etc/). Specifically,
the [ZFC](https://www.cs.ru.nl/~freek/zfc-etc/zfc.aut) code.

**2.1. Types.**
We have several basic parts for first-order logic: propositions, proofs
of propositions, and terms. We treat these as primitive notions.

<div class="highlight-rouge">
<pre class="highlight"><code>  <span class="kr">*</span>           <span class="kt">prop</span> : <span class="kr">TYPE</span> := <span class="nf">PRIM</span>
  <span class="kr">*</span> [a:prop] <span class="kt">proof</span> : <span class="kr">TYPE</span> := <span class="nf">PRIM</span>
  <span class="kr">*</span>           <span class="kt">term</span> : <span class="kr">TYPE</span> := <span class="nf">PRIM</span></code></pre></div>

We have a variable `a:prop` available to our disposal.

**2.2. First-Order Logic, Connectives and Quantifiers.**
We need to continue introducing relevant connectives and
quantifiers. The "bare minimum" amounts to a modest 5 definitions, but
we'll also introduce "luxury goods" like the existential quantifier &
other connectives.

<div class="highlight-rouge">
<pre class="highlight"><code>  <span class="kr">*</span>                <span class="kt">false</span> : <span class="kr">prop</span> := <span class="nf">PRIM</span>
<a id="definition-imp"></a>a <span class="kr">*</span>         [b:prop] <span class="kt">imp</span> : <span class="kr">prop</span> := <span class="nf">PRIM</span>
  <span id="forall-defn" class="kr">*</span> [p:[z:term]prop] <span class="kt">for</span> : <span class="kr">prop</span> := <span class="nf">PRIM</span>
</code></pre></div>

Some points worth observing here:

1. `imp` is a function expecting two parameters, `a` and `b`. When
   supplied, and called, the term `imp(a,b)` corresponds to the logical
   statement "_a_ implies _b_".
2. The `for` function is the universal quantifier. We call it as
   `for([z:term]<z>predicate)`, which should translate intuitively as
   "for each _z_, the predicate on _z_ holds."
3. We have two "queues" of parameters, namely `a:prop, b:prop` and
   `p:[z:term]prop`. When defining functions, we need to specify a
   variable before the `*` asterisk, which will signal to Automath to
   find the queue with the variable, and select the sublist from the
   head of the queue to the symbol given. (So, `a *` would tell Automath
   to look in the `a:prop, b:prop` queue, take the symbols from the head
   of the list until it gets to `a`, and inclusively use that as the
   parameters for the given function.)

**2.2.1. Luxury Connectives.**
We have the following "luxury connectives" and quantifiers. First, the 
connectives, which are really just abbreviations...in the sense that we
can rewrite them in terms of `imp` and `false`.

<div class="highlight-rouge">
<pre class="highlight"><code>a <span class="kr">*</span> <span class="kt">not</span> : <span class="kr">prop</span> := imp(a,<span class="kr">false</span>)
b <span class="kr">*</span> <span class="kt">and</span> : <span class="kr">prop</span> := not(imp(a,not(b)))
b <span class="kr">*</span>  <span class="kt">or</span> : <span class="kr">prop</span> := imp(not(a),b)
b <span class="kr">*</span> <span class="kt">iff</span> : <span class="kr">prop</span> := and(imp(a,b),imp(b,a))
</code></pre></div>

**2.2.2. Luxury Quantifiers.**
The two luxury quantifiers we can work with are the existential
quantifier, and its variant the uniquen existential quantifier. We can
implement these using an equality predicate on terms. We implement
existial quantification via [negating universal quantification](https://en.wikipedia.org/wiki/Universal_quantification#Negation).

<div class="highlight-rouge">
<pre class="highlight"><code>  <span class="kr">*</span> [x:term][y:term] <span class="kt">eq</span> : <span class="kr">prop</span> := <span class="nf">PRIM</span>
<span class="c1"># "p" refers to the parameters used in <a class="c1" href="#forall-defn">"forall"</a></span>
p <span class="kr">*</span> <span class="kt">ex</span> : <span class="kr">prop</span> := not(for([z:term]not(&lt;z&gt;p)))
p <span class="kr">*</span> <span class="kt">unique</span> : <span class="kr">prop</span> :=
      for([z:term]imp(&lt;z&gt;p,for([z':term]imp(&lt;z'&gt;p,eq(z,z')))))
p <span class="kr">*</span> <span class="kt">ex_unique</span> : <span class="kr">prop</span> := and(ex,unique)
</code></pre></div>

**2.3. Proof System.**
We need to actually implement some proof system. The most popular
version, natural deduction, requires us to define _introduction_ and
_elimination_ rules of inference for each primitive connective and
quantifier in our logic. We really have just one primitive connective
(`imp`), and one primitive quantifier (`for`)...and for classical logic,
one additional rule for the law of the excluded middle.

<div class="highlight-rouge">
<pre class="highlight"><code><span class="c1"># Rules of inference for implication, i.e., <a class="c1" href="https://en.wikipedia.org/wiki/Natural_deduction#Hypothetical_derivations">hypothetical derivations</a></span>
b <span class="kr">*</span> [_:[_1,proof(a)]proof(b)] <span class="kt">imp_intro</span> : <span class="kr">proof(imp(a,b))</span> := <span class="nf">PRIM</span>
b <span class="kr">*</span> [_:proof(imp(a,b))][_1:proof(a)] <span class="kt">imp_elim</span> : <span class="kr">proof(b)</span> := <span class="nf">PRIM</span> <span class="c1"># AKA Modus Ponens</span>

<span class="c1"># Rules of inference for universal quantification</span>
p <span class="kr">*</span> [_:[z,term]proof(&lt;z&gt;p)] <span class="kt">for_intro</span> : <span class="kr">proof(for(p))</span> := <span class="nf">PRIM</span>
p <span class="kr">*</span> [_:proof(for(p))][z:term] <span class="kt">for_elim</span> : <span class="kr">proof(&lt;z&gt;p)</span> := <span class="nf">PRIM</span>

<span class="c1"># Law of the excluded middle</span>
a <span class="kr">*</span> [_:proof(not(not(a)))] <span class="kt">classical</span> : <span class="kr">proof(a)</span> := <span class="nf">PRIM</span>
</code></pre></div>

If we were being 100% careful, we should also have rules of inference
for equality introduction and elimination. This is actually a good
exercise for the reader, who can cheat easily with the links supplied.

# Propositions as Types

**3.1. Curry-Howard Correspondence.**
We can invoke the [Curry-Howard Correspondence](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence) (well, in truth, de
Bruijn did a lot of work on this independent of Howard, and at about the
same time). What to do? Well, we had only one kind `TYPE` in our system
so far. We introduce a second kind `PROP`.

If `foo : PROP`, we can consider `foo` as a proposition. If further, we
have `bar : foo`, then we interpret `bar` as establishing the truth of
`foo`. (I.e., `bar` is the "proof" of `foo`.)

**3.2. Implication.**
Let `alpha : PROP` and `beta : PROP`. If we have some construction
establishing the truth of `alpha`, and from it establish the truth of
`beta`, then we have `alpha` _implies_ `beta`. Hence implication may be
viewed as a _function_ of the "proofs" of `alpha` to the proofs of
`beta`.

We can represent implication as a type-valued function `[x:alpha]beta :
PROP`. Compare this to our <a href="#definition-imp">definition</a>
which treated implication as `[a:prop][b:prop] imp : prop := PN`.

Why bother with this newfangled version? We can implement _modus ponens_
as function application! That is, if we have `proof_of_alpha : alpha`
and `proof_of_alpha_implies_beta : [x:alpha]beta`, then we can construct
`<proof_of_alpha>proof_of_alpha_implies_beta` to get a proof of `beta`.

**3.3. Universal Quantification.**
In like manner, if we have `alpha:TYPE`, and `beta:PROP`, then
we identify `[x:alpha]beta` with the proposition "For all `x` in
`alpha`, the proposition `beta` holds." We get this fragment of
first-order logic _for free_ in Automath.

**3.4. Negation.**
As we have seen in our system from section 2, we need to introduce
`false` as a primitive notion to get negation. Otherwise statements like
"`alpha` is not of type `beta`" remain unspeakable.

But that's not the end of the story for negation: we need some suitable
axioms. Classical mathematicians will impose the double negation
law. Intuitionistic mathematicians will impose the absurdity law (for
any proposition `alpha`, from `false` infer `alpha`).

So, in this form, negation looks like: for `alpha:PROP` we have
`not(alpha)` defined as `[x:alpha] false`. Or in Automath code:

<div class="highlight-rouge">
<pre class="highlight"><code>      <span class="kr">*</span> <span class="kt">alpha</span> : <span class="kr">PROP</span> := <span class="nf">PRIM</span>
alpha <span class="kr">*</span>   <span class="kt">not</span> : <span class="kr">PROP</span> := [x:alpha]<span class="kr">false</span></code></pre></div>

**3.5. Reinterpreting lines: assumptions, axioms, and theorems (oh my).**
We now have a logical interpretation of all three types of lines.

1. Variable introduction lines `a * x : sigma := ---` are
   **assumptions** "let `sigma` hold" (or more accurately "let `x` be a
   proof of `sigma`).
2. Primitive notion lines `a * p : sigma := PRIM` are **axioms** or
   axiom schemas (by the dependence on the variables contained in the
   context `a`).
3. Definition lines `a * def : sigma := body` are **theorems**. Here the
   `body` "proves" the proposition `sigma` from the assumptions in the
   context `a`.

# "Quasi-Expressions"

**4.**
So far we have been working with `AUT-68`, the first version of
Automath. It has many strengths, but like most alpha-versions it has a
few shortcomings. We could only have lambda abstractions on terms and
types, but not kinds. That is to say, we could not have something like
`[x:foo]TYPE`. We could shrug and say "Who cares?" But it vastly
simplifies the logical framework we just established if we allow such
things.

When such things are allowed, we have "quasi-expressions". Thus we get
the second edition of Automath, `AUT-QE` (where `QE` stands for, yep,
"quasi-expression").

**4.1. Definition of Quasi-Expressions.**
We consider kinds of the form `[x:alpha]...[x':alpha'] TYPE` or
`[x:alpha]...[x':alpha'] PROP`, where `alpha`, ..., `alpha'` are
arbitrary types. Such kinds are called **"Quasi-Expressions"**.

We can consider, for example, an arbitrary type-valued function on
`alpha` introduced by the following code snippet:

<div class="highlight-rouge">
<pre class="highlight"><code>a <span class="kr">*</span> <span class="kt">f</span> : <span class="kr">[x:alpha]TYPE</span> := ---</code></pre></div>

**4.2. So What?**
We can have arbitrary `PROP`-valued functions in AUT-QE. I.e., a
`PROP`-valued function over `alpha` is nothing but a _predicate_ over
`alpha`. That's pretty nifty. Further, we could consider the following snippet:

<div class="highlight-rouge">
<pre class="highlight"><code>a <span class="kr">*</span> <span class="kt">relation</span> : <span class="kr">[x:nat][y:nat]PROP</span> := ---</code></pre></div>

This defines an arbitrary binary predicate (or, as the identifier suggests, a
_binary relation_) on the natural numbers.

**4.3. No, really, so what?**
Another bonus, if we recall our discussion of [LCF Tactics]({% post_url 2015-11-28-lcf %}),
which transformed goals until we've proven the desired proposition, we
also had to add some postcondition checking the sequence of tactics
really proved the desired proposition. In other words, there is danger
of _invalid tactics_ in LCF, which we desperately want to avoid.
(We don't want to prove an invalid proposition!)

What can we do? Well, we can use a logical framework to avoid this problem.
Basically, the validity of the representation of the derivations
("tactics") becomes an _internal_ property, while being _decidable_ for free.
In other words, we get _judgments as types_. See Pfenning's
[paper](http://www.cs.cmu.edu/~fp/papers/handbook01.pdf) for a review of
this.

**Example.** If we are still not convinced about this, we should
consider the following [gist](https://gist.github.com/pqnelson/f5e914449c8490cc9dab#file-zfc-aut)
describing the ZFC axioms,
which has 11 fewer primitive notions in AUT-QE than in AUT-68.
(End of Example)

# References

## On Automath

- R.P. Nederpelt, J.H. Geuvers, R.C. de Vrijer,
  _Selected Papers on Automath_.
  North Holland, 1994.
- [Automath Archive](http://www.win.tue.nl/automath/) many original papers are here!
- Philippe de Groote,
  [Defining lambda-Typed lambda-Calculus by Axiomatizing the Typing Relation](http://www.loria.fr/~degroote/papers/stacs93.pdf),
  pdf, 12 pages.
- Freek Wiedijk's [Automath Page](http://www.cs.ru.nl/F.Wiedijk/aut/index.html)
  and [Automath restaurant](https://www.cs.ru.nl/~freek/zfc-etc/).

...and that's the entire active community.

## Other References

- Frank Pfenning,
  "Logical Frameworks".
  Chapter 17 of _Handbook of Automated
  Reasoning_. [Eprint](http://www.cs.cmu.edu/~fp/papers/handbook01.pdf),
  85 pages.
