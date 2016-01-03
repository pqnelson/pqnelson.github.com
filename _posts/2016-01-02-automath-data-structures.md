---
layout: post
title: Data Structures — Automath
published: true
quote: "I will, in fact, claim that the difference between a bad programmer and a good one is whether he considers his code or his data structures more important. Bad programmers worry about the code. Good programmers worry about data structures and their relationships."
quoteSource: Linus Torvalds, <a href="https://lwn.net/Articles/193245/">Licensing of GIT</a> (2006)
category: Automath
tags: [Automated Theorem Prover]
permalink: /automath/data-structures
parentURL: /automath/
---

Lets examine the basic data structures underpinning Automath. This post
could be viewed as an "implementation in pseudocode". There will be many
pictures translating code snippets to "what we want under the hood".

Fortunately, there are really only a few aspects to the language:
statements ("lines"), expressions, and lastly paragraphs. We can start simple,
then incorporate more and more features.

- [Lines](#lines)
  - [Contexts](#contexts)
  - [Functions and Primitive Notions](#functions-and-primitive-notions)
- [Expressions](#expressions)
  - [Kinds](#kinds)
  - [Lambda Abstraction](#lambda-abstraction)
  - [Application](#application)
  - [Function Calls](#function-calls)
- [Paragraphs](#paragraphs)

# Lines

There are three types of lines in Automath:

0. Lines defining functions and constants
0. Lines introducing primitive notions ("builtins" for a given
   mathematical theory)
0. Lines expanding the context (named arguments for function declarations)

There's a basic structure underlying all these lines, which we'll
examine first. The sole purpose for lines: defining functions (the first
two cases listed), or specifying the parameters used in their definition
(the last case listed).

Consider the following snippet:

<div class="highlight"><pre><span class="o">*</span> <span class="nc">prop</span> <span class="o">:</span> <span class="kp">TYPE</span> <span class="o">:=</span> <span class="nf">PRIM</span>
<span class="o">*</span> [a:prop] <span class="nc">proof</span> <span class="o">:</span> <span class="kp">TYPE</span> <span class="o">:=</span> <span class="nf">PRIM</span>
<span class="o">*</span> <span class="nc">term</span> <span class="o">:</span> <span class="kp">TYPE</span> <span class="o">:=</span> <span class="nf">PRIM</span>
</pre></div>

We need to keep track of what has already been defined, which could be
done in a dictionary. The lines form a doubly linked list:

<img alt="Lines form a doubly-linked list" src="{{ site.url }}/assets/auto-ds-lines1.svg"
style="max-width:242px;" />

Alternatively, in a language like Go where this is seen as bad form, I
suppose we could use an array instead:

<img alt="Lines form an array" src="{{ site.url }}/assets/auto-ds-lines2.svg"
style="max-width:153px;" />

The only problem with the array approach is, well, we don't know how
many lines a file has _a priori_. And remember, a "line" isn't
necessarily a single line of the file, we could rewrite the entire
Automath program to be a single-line file.

**Punchline:** We need some kind of linear collection for `line`s. The
exact details are language-specific (duh), but we don't need to specify
anything so far except ordering the lines matters a great deal: the
introduction to the text must occur _before_ the end.

## Contexts

The code snippet we have considered is more complicated than it
appears. Why? Because it's really equivalent to the following:

<div class="highlight"><pre><span class="cm">{1}</span>   <span class="o">*</span> <span class="nc">prop</span> <span class="o">:</span> <span class="kp">TYPE</span> <span class="o">:=</span> <span class="nf">PRIM</span>
<span class="cm">{2}</span>   <span class="o">*</span> <span class="nc">a</span> <span class="o">:</span> <span class="kp">prop</span> <span class="o">:=</span> <span class="nf">---</span>
<span class="cm">{3}</span> <span class="nv">a</span> <span class="o">*</span> <span class="nc">proof</span> <span class="o">:</span> <span class="kp">TYPE</span> <span class="o">:=</span> <span class="nf">PRIM</span>
<span class="cm">{4}</span>   <span class="o">*</span> <span class="nc">term</span> <span class="o">:</span> <span class="kp">TYPE</span> <span class="o">:=</span> <span class="nf">PRIM</span>
</pre></div>

We see line 2 introduces a variable (it's an _expander block_ line),
which creates a new _stack_ of named parameters. For this particular
snippet, we have the following data structure representation:

<img alt="Context stack representation" src="{{ site.url }}/assets/auto-ds-lines3.svg"
style="max-width:356px;" />

To see this stack structure more explicitly, consider the following
snippet:

<div class="highlight"><pre><span class="c"># &gt;&gt;&gt; * [x:term][y:term] eq : prop := PRIM</span>
<span class="c"># expands to</span>
<span class="cm">{1}</span>   <span class="o">*</span> <span class="nc">x</span> <span class="o">:</span> <span class="kp">term</span> <span class="o">:=</span> <span class="nf">---</span>
<span class="cm">{2}</span> <span class="nv">x</span> <span class="o">*</span> <span class="nc">y</span> <span class="o">:</span> <span class="kp">term</span> <span class="o">:=</span> <span class="nf">---</span>
<span class="cm">{3}</span> <span class="nv">y</span> <span class="o">*</span> <span class="nc">eq</span> <span class="o">:</span> <span class="kp">prop</span> <span class="o">:=</span> <span class="nf">PRIM</span> 
</pre></div>

The EB lines (lines 1 and 2) carries with them a stack of identifiers
describing the implicit arguments. When `y` is placed into the context
of `eq`, it borrows the `y.args` field to determine the parameters
needed in defining the predicate.

The `y.args` field determines the named parameters used in defining
`eq : prop`. In a C/Blub language, this amounts to defining `prop
eq(term x, term y)` function.

<img alt="Context stack representation" src="{{ site.url }}/assets/auto-ds-lines4.svg"
style="max-width:407px;" />

**Why keep this list structure?** We could simplify things if we copy
the `args` into the function definition, and keep track of identifiers
and their types in some "dictionary" global variable (egads!). This has
the advantage of keeping things simple, using less memory, and less
complex. What could go wrong?

If we have a module system (which _is_ what paragraphs are designed
for!), then we have to prevent variable name collisions.

## Functions and Primitive Notions

So far we have discussed contexts in depth, but we have yet to
investigate functions and primitive notions. We adopt the convention
that constants are just functions with zero parameters.

The `body` is just an expression, which is the next topic of
discussion in the next section.

But a primitive notion doesn't have a body: it's _primitive_, after
all. It's just a "builtin function" for a given theory. Consequently,
the only thing distinguishing a primitive notion from a defined function
is whether the body is present or not.

In pseudocode, the metalanguage can test for such things as follows:

```java
boolean isPrimitive(Definition d) {
    return (d.body==null);
}
int arity(Definition d) {
    return d.args.length;
}
boolean isConst(Definition d) {
    return (arity(d)==0);
}
boolean isFunction(Definition d) {
    return (!isPrimitive(d) && !isConst(d));
}
```

This lets us use one data structure for two different types of lines!

**Lines only Define Functions, or Help us in the Process.**
This is one punchline we should note. Contexts are lines with an
`arglist` field, more or less. Functions are lines with a context
(specifying the named parameters for the function) and a body (telling
us what the function _does_). The body requires previously defined
entities, or contexts. The only reason we have contexts _is to specify
the parameters for functions_.

# Expressions

There's four or so expressions in Automath, and it's far simpler than
the complicated structure of lines and contexts. Why is this so? Because
Automath boils down to a typed lambda calculus, so we have lambda
abstractions and applications. But we also have function calls, since
lines just define functions. Morally, there is no _semantic_ difference
between lambda abstractions and function definitions.

We need to introduce new types, and have "families of types". How can we
make this more clear and rigorous? We need [kinds](https://en.wikipedia.org/wiki/Kind_%28type_theory%29), i.e., "types of
types". Automath has two: `PROP` for propositions, and `TYPE`
for...everything else. (AUT-68, under the hood, made `PROP=TYPE`; but
AUT-QE fixed this so they were no longer identical.)

But for our framework, we need a base `Expression` class.

```java
class Expression {
    String id;
};
```

## Kinds

We could implement this either as a pair of global variables (ugh!) or
as a factory method producing identical objects for a given kind. In
either event, the object in question must tell us (a) it's a kind, (b)
whether it's `TYPE` or `PROP`, and (c) have some identifier.

```java
class Kind extends Expression {
    String id; // "TYPE" or "PROP"
    int code; // = 0 for PROP, 1 for TYPE
};
```

Types are defined as primitive notions whose `type` refers to the
specific `Kind` in question.

## Lambda Abstraction

The Automath notation for Lambda Abstraction is `[x:type] body` instead
of the more common "λ x:type . body" we'd see in lectures and books.

Not only can Automath lambda expressions produce _values_ from input, we
can go further and produce _types_. That is to say, we can write
something like `[x:term]TYPE` to specify a function which, given some
term (say, `x0`), will produce a type. Although analogous to
[dependent product type](https://en.wikipedia.org/wiki/Dependent_type#Formal_definition),
there are subtle differences which we can only refer the interested
reader to the literature. For us, we'll just pretend they're "the same".

Sweeping all these subtle points under the rug, the basic structure of a
lambda abstraction would be:

```java
class LambdaAbstraction extends Expression {
    String variableId;
    Expression *variableType;
    Expression *body;
};
```

## Application

Since Automath just _checks_ expression, we don't have to worry about
the subtle problems of simplification. For example, in Python, `(lambda x: x+1) 2 => 3`.
But Automath would have us write `<2>[x:nat]Successor(x)` which is
semantically `Successor(2)`, and we can stop there...or go further, all
the way to the primitive notions in arithmetic since `2:=Successor(Successor(0))`.

At minimum, all we appear to need for `<x>f` is the function `f` and an
argument we'll apply to it `x`:

```java
// <x>f is represented by a pair of pointers
class Application extends Expression {
    Expression *fun; // f
    Expression *arg; // x
};
```

## Function Calls

We now have a list of arguments applied to a function, instead of a
single argument. I suppose we could just treat it as `f(x,y)=<<y>x>f` by
Currying. There is some subtlety here, since we don't want to call a
function with too many parameters, e.g. `eq(x,z,y)` should throw an
error.

At the same time, Automath allows a "shorthand" convention where, if we
call a function with too few parameters, the resulting expression is a
function of the remaining parameters needed. More precisely, Automath
takes the peculiar convention of treating the parameters as a stack, and
applying a function to a smaller list of arguments amounts to "popping"
the stack. So if we had a function `f(x,y,z)`, then we could construct a
function `g(x,y)` by simply passing in `z`: `g(x,y) = f(z)`.

In pseudocode, we would have

```java
Expression call(Definition fun, Expression[] args) {
    // precondition: arity must not be less than number of arguments
    assert(arity(fun)<args.length)

    if (arity(fun) == args.length) {
        return new Term(fun, args);
    }
    else {
        Expression[arity(fun)] paddedParameters = new Expression[arity(fun)];
        int numberUnfixedParameters = arity(fun)-args.length
        
        // Copy over the first 'arity(fun)-args.length' named parameters
        for(int i=0; i<numberUnfixedParameters; i++)
            paddedParameters[i] = fun.arguments()[i];
        
        // Copy over the arguments passed in
        for(int i=0; i<args.length; i++)
            paddedParameters[i+numberUnfixedParameters] = args[i]
        
        return new Term(fun, paddedParameters);
    }
}
```

# Paragraphs

This is the last thing we need to discuss before calling it a day:
paragraphs. They form a crude module system for Automath. We can have
them nested arbitrarily deep, we can re-open them later on, and we
expect it to behave like a running linear list of lines.

Lets give some examples of how this would look.

<div class="highlight"><pre>  <span class="o">*</span> <span class="nv">l0</span>
  <span class="o">*</span> <span class="nv">l1</span>
<span class="o">+</span> <span class="nv">p</span> <span class="c"># open paragraph p</span>
  <span class="o">*</span> <span class="nv">l2</span>
  <span class="o">*</span> <span class="nv">l3</span>
<span class="o">-</span> <span class="nv">p</span> <span class="c"># close paragraph p</span>
  <span class="o">*</span> <span class="nv">l4</span>
</pre></div>

This would amount to the following situation:

<img alt="Paragraphs as a linked list" src="{{ site.url }}/assets/auto-ds-par0.svg"
style="max-width:587px;" />

But to make things worse, we can re-open paragraphs that have been
previously closed. For example:

<div class="highlight"><pre>  <span class="o">*</span> <span class="nv">l0</span>
  <span class="o">*</span> <span class="nv">l1</span>
<span class="o">+</span> <span class="nv">p</span> <span class="c"># open paragraph p</span>
  <span class="o">*</span> <span class="nv">l2</span>
  <span class="o">*</span> <span class="nv">l3</span>
<span class="o">-</span> <span class="nv">p</span> <span class="c"># close paragraph p</span>
  <span class="o">*</span> <span class="nv">l4</span>
  <span class="o">*</span> <span class="nv">l5</span>
<span class="o">+*</span> <span class="nv">p</span> <span class="c"># reopen paragraph p</span>
  <span class="o">*</span> <span class="nv">l6</span>
  <span class="o">*</span> <span class="nv">l7</span>
<span class="o">-</span> <span class="nv">p</span> <span class="c"># close paragraph p again</span>
  <span class="o">*</span> <span class="nv">l8</span>
  <span class="o">*</span> <span class="nv">l9</span>
</pre></div>

Or graphically, we'd have the following situation (with the paragraph
linkage in red):

<img alt="Paragraphs as a linked list" src="{{ site.url }}/assets/auto-ds-par1.svg"
style="max-width:1162px;" />



# Concluding Remarks

We reviewed the basic statement structure in Automath, which amounted to
making definitions...or introducing parameters to be used in a definition.
Then we examined the basic expressions admitted, namely, function calls,
lambda abstractions, and applying a lambda abstraction to an expression.

Although the statement structure is fairly straightforward (after all,
there was only one "type" of statement), the expressions were far more
complicated. Implementation in a language not permitting inheritance or
pointer casting (e.g., Go) may prove challenging.

The only piece of machinery left to examine is how Automath checks
expressions for correctness, but this is remarkably simple type checking
(is the function passed the correct argument? Is the definition
coherent? Etc.). This is the subject for another topic of discussion,
however.


