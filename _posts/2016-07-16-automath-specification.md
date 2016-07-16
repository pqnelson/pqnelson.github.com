---
layout: post
title: Language Specification — Automath
published: true
quote: "Walking on water and developing software from a specification are easy if both are frozen."
quoteSource: Edward V. Berard, <i>Essays on object-oriented software engineering</i> (1993)
category: Automath
tags: [Automated Theorem Prover]
permalink: /automath/specification
parentURL: /automath/
---

**Overview.**
We will attempt to formulate the language specification for AUT-QE
without type inclusion (and, by eliminating quasi-expressions,
AUT-68). First we will develop the syntax in a slight variant of
[ABNF](https://en.wikipedia.org/wiki/Augmented_Backus%E2%80%93Naur_Form). Second
we will formulate denotational semantics. Third we will review
operational semantics for the underlying λ-typed λ-calculus, what de
Groote calls λ<sup>λ</sup>. We leave as an exercise for the reader
formalizing this in Coq.

# Syntax

**1.1. Input Encoding.**
There is no specific restriction on the encoding, it may be ASCII,
Unicode, or some other encoding, providing we can distinguish three
character classes: (1) numeral digits, (2) punctuation, (3)
"letters". This is used loosely, as we expect, e.g., ideograms (think:
Chinese, Kanji, etc.) should be considered "letters", and exotic
punctuation we might find in classical Chinese would be considered
"punctuation".

**1.2. Identifiers.**
An Automath identifier consists of 1 or more characters which may be a
"letter", a "numeric digit", underscore `_`, backspace (in C it's `\b`,
in ASCII and Unicode it is code point `0x08`), a backquote
<code>&#96;</code>, or a single quote `'`.

<pre class="highlight"><span></span>&lt;<span class="nc">identifier</span> <span class="nc">character</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">letter</span>&gt;
                         | &lt;<span class="nc">number</span>&gt;
                         | &lt;<span class="nc">backspace</span>&gt;
                         | &lt;<span class="nc">backtick</span>&gt;
                         | <span class="l">&quot;_&quot;</span>
                         | <span class="l">&quot;&#39;&quot;</span>

&lt;<span class="nc">backtick</span>&gt; ::<span class="o">=</span> %<span class="o">0</span><span class="nc">x60</span>
&lt;<span class="nc">backspace</span>&gt; ::<span class="o">=</span> %<span class="o">0</span><span class="nc">x08</span>

&lt;<span class="nc">identifier</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">identifier</span> <span class="nc">character</span>&gt;
               | &lt;<span class="nc">identifier</span>&gt; &lt;<span class="nc">identifier</span> <span class="nc">character</span>&gt;
</pre>

**1.3. Input Program ("Books").**
The Automath checker expects input from flat files, and the input has
historically been referred to as "books". (Compared to, say, C---which
would have called it a "program" instead of a "book".) The analogy is
made to physically tangible books, which consist of lines. (Just as a C
program consists of statements.)

<pre class="highlight">
&lt;<span class="nc">book</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">blank</span>&gt;
         | &lt;<span class="nc">book</span>&gt; &lt;<span class="nc">line</span>&gt;
         | &lt;<span class="nc">book</span>&gt; <span class="l">&quot;;&quot;</span>
</pre>

**1.4. Statements ("Lines").** 
A line is analogous to a "statement" in imperative programs. Automath
lines either define a function, or assist in defining a function. In
this light, we can specify the components and their function:

0. *Automath Context*: The named parameters for a function are indicated
   by the "Automath Context" part of the line. These are analogous to
   "stacks of named parameters", and the context part is just the last
   identifier on the stack (sometimes referred to as the "indicator string").
0. *Identifier Part*: The identifier of the definition (the
   _definiendum_, if you will).
0. *Category Part*: Specifies the type of the entity being defined.
0. *Body*: The body of the definition (the _definiens_, if you will).

We also have three types of lines:

0. _Expansion Block_: Since the named parameters are assembled as a
   stack, we have lines which assist in "pushing" a new named
   parameter. This is done in an expansion block line.
0. _Primitive Notions_: Automath gives us nothing, so we need to
   introduce new types and constants as "builtins" to the mathematical
   theory being developped. This is handled in primitive notion lines.
0. _Function Definitions_: The bulk of the work lies in defining
   functions, which is done in abbreviation or function definition
   lines. Constants are seen as functions with zero parameters.

The grammar of a line looks like the following:

<pre class="highlight">
<span class="c1">; &lt;ESTI&gt; &lt;expression&gt; is the component telling us the type of the definition</span>
&lt;<span class="nc">ESTI</span>&gt; ::<span class="o">=</span> <span class="l">&quot;&#39;E&#39;&quot;</span> | <span class="l">&quot;_&quot;</span> &lt;<span class="nc">backspace</span>&gt; <span class="l">&quot;E&quot;</span> | <span class="l">&quot;;&quot;</span> | <span class="l">&quot;:&quot;</span>

<span class="c1">; &lt;assign&gt; &lt;expression&gt; tells us the body of the line</span>
&lt;<span class="nc">assign</span>&gt; ::<span class="o">=</span> <span class="l">&quot;:=&quot;</span> | <span class="l">&quot;=&quot;</span>

&lt;<span class="nc">PN</span>&gt; ::<span class="o">=</span> <span class="l">&quot;PRIM&quot;</span> | <span class="l">&quot;&#39;prim&#39;&quot;</span> | <span class="l">&quot;PN&quot;</span> | <span class="l">&quot;&#39;pn&#39;&quot;</span> | <span class="l">&quot;???&quot;</span>
&lt;<span class="nc">primitive</span> <span class="nc">notion</span> <span class="nc">line</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">context</span>&gt; &lt;<span class="nc">identifier</span>&gt; &lt;<span class="nc">assign</span>&gt; &lt;<span class="nc">PN</span>&gt; &lt;<span class="nc">ESTI</span>&gt; &lt;<span class="nc">expression</span>&gt;
                          | &lt;<span class="nc">context</span>&gt; &lt;<span class="nc">identifier</span>&gt; &lt;<span class="nc">ESTI</span>&gt; &lt;<span class="nc">expression</span>&gt; &lt;<span class="nc">assign</span>&gt; &lt;<span class="nc">PN</span>&gt;

<span class="c1">; Expansion blocks are for pushing a named parameter onto the context</span>
&lt;<span class="nc">EB</span>&gt; ::<span class="o">=</span> <span class="l">&quot;EB&quot;</span> | <span class="l">&quot;&#39;eb&#39;&quot;</span> | <span class="l">&quot;---&quot;</span>
&lt;<span class="nc">EB</span> <span class="nc">line</span>&gt; ::<span class="o">=</span>  &lt;<span class="nc">context</span>&gt; &lt;<span class="nc">identifier</span>&gt; &lt;<span class="nc">assign</span>&gt; &lt;<span class="nc">EB</span>&gt; &lt;<span class="nc">ESTI</span>&gt; &lt;<span class="nc">expression</span>&gt;
            | &lt;<span class="nc">context</span>&gt; &lt;<span class="nc">identifier</span>&gt; &lt;<span class="nc">ESTI</span>&gt; &lt;<span class="nc">expression</span>&gt; &lt;<span class="nc">assign</span>&gt; &lt;<span class="nc">EB</span>&gt;

&lt;<span class="nc">definition</span> <span class="nc">line</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">context</span>&gt; &lt;<span class="nc">identifier</span>&gt; &lt;<span class="nc">assign</span>&gt; &lt;<span class="nc">expression</span>&gt; &lt;<span class="nc">ESTI</span>&gt; &lt;<span class="nc">expression</span>&gt;
                    | &lt;<span class="nc">context</span>&gt; &lt;<span class="nc">identifier</span>&gt; &lt;<span class="nc">ESTI</span>&gt; &lt;<span class="nc">expression</span>&gt; &lt;<span class="nc">assign</span>&gt; &lt;<span class="nc">expression</span>&gt;

&lt;<span class="nc">line</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">primitive</span> <span class="nc">notion</span> <span class="nc">line</span>&gt;
         | &lt;<span class="nc">EB</span> <span class="nc">line</span>&gt;
         | &lt;<span class="nc">definition</span> <span class="nc">line</span>&gt;

</pre>

**1.5. Symbols and Module System ("Paragraphs").**
Identifiers are used in definitions, symbols are used for
references. What's the difference? Well, Automath has a module system,
and referring to an identifier defined inside a module requires
specifying the module's identifier too (in C++, we have to write
`std::cout` to specify we want `cout` from `std` and not, say,
`logger`).

Automath modules are called "paragraphs", keeping up with the
analogy to physical books, and are opened by new lines starting with a
`+` symbol (and closed on a newline with `--`). To cite an identifier
defined in a paragraph, we have to write `identifier"paragraph_id"`.

Part of the contract with a line is the identifier being defined must be
free: it is not used in the current paragraph. If it is not a free
variable, then an error is thrown and the program terminates.

<pre class="highlight">
&lt;<span class="nc">symbol</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">identifier</span>&gt;
           | &lt;<span class="nc">identifier</span>&gt; <span class="k">DQUOTE</span> &lt;<span class="nc">identifier list</span>&gt; <span class="k">DQUOTE</span>

<span class="c1">; Used to specify the paragraph</span>
&lt;<span class="nc">identifier</span> <span class="nc">list</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">empty</span>&gt;
                    | &lt;<span class="nc">identifier</span>&gt;
                    | &lt;<span class="nc">identifier</span> <span class="nc">list</span>&gt; <span class="l">&quot;.&quot;</span> &lt;<span class="nc">identifier</span>&gt;
                    | &lt;<span class="nc">identifier</span> <span class="nc">list</span>&gt; <span class="l">&quot;-&quot;</span> &lt;<span class="nc">identifier</span>&gt;

&lt;<span class="nc">par</span> <span class="nc">open</span>&gt; ::<span class="o">=</span> <span class="l">&quot;+&quot;</span> &lt;<span class="nc">identifier</span>&gt;

<span class="c1">; &quot;--&quot; closes the current paragraph</span>
&lt;<span class="nc">par</span> <span class="nc">close</span>&gt; ::<span class="o">=</span> <span class="l">&quot;-&quot;</span> &lt;<span class="nc">identifier</span>&gt;
              | <span class="l">&quot;--&quot;</span>

</pre>
              
**1.6. Automath Context.**
A context is a stack of named parameters. The idea is we might want
something like an "indexed family of types". Some examples might
include: "Let _G_ be a group, and _S_ a set. A 'group action' consists
of a function...", we would have `G:Group, S:Set` be the context in the
line defining a group action. So to specify a group action, we first
need to identify (a) which group we're working with, and (b) which set
we're working with.

There's nothing in, say, C++ we can compare this to...because it is unique
to mathematics. One stab at it might be in an object oriented language,
to have the constructor of a `GroupAction` class have a constructor of
the form `GroupAction(Group G, Set S)`.

In category theory, this is remarkably similar to the notion of a
[generalized element](https://ncatlab.org/nlab/show/generalized+element).
This perspective is vindicated when examining the
[denotational semantics](#denotational-semantics-context) for contexts.

With the group action example, in Automath we might have something like
the following sequence of lines:

- `* Group : Type := PN` groups are primitive notions
- `* Set : Type := PN` so are sets
- `* G:Group := ---` Let _G_ be a group.
- `G * S:Set := ---` Let _S_ be a set.
- `S * GroupAction:Type := PN` Then a group action is a primitive notion

And we can continue specifying its properties.

In "real" type theory, we use a turnstile to separate the context from a
statement, writing something like "Γ ⊢ t:T". But in Automath, we write
`Γ * t:T` because no one thought `|-` looks more like a turnstile than
`*`. Further, Automath writes only the top element of the stack, and
calls it the _"Indicator String"_. 

<pre class="highlight">
&lt;<span class="nc">turnstile</span>&gt; ::<span class="o">=</span> <span class="l">&quot;*&quot;</span> | <span class="l">&quot;@&quot;</span>

&lt;<span class="nc">context</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">empty</span>&gt;
            | &lt;<span class="nc">turnstile</span>&gt;
            | &lt;<span class="nc">symbol</span>&gt; &lt;<span class="nc">turnstile</span>&gt;
</pre>
            
**1.7. Expressions.**
Automath's expressions boil down to a lambda-typed lambda calculus,
meaning a lambda expression can produce either a term or a type. Quirks
in the notation should be noted, however: lambda abstractions are
denoted `[x:type] body`, and applications are `<x>f` instead of `f(x)`
or `f x`.

One cautionary note: we described contexts as a stack of parameters
needed to specify a type. (So to specify a group action, we first need
to specify the group and the set acted upon.) Once we have identified
these parameters, we get a type. This is "instantiation" in Automath,
and would be identified by writing `GroupAction(group, set)`. This is
_distinct_ from application in lambda calculus, since no lambda
expressions are involved.

<pre class="highlight">
&lt;<span class="nc">expression</span>&gt; ::<span class="o">=</span> <span class="l">&quot;TYPE&quot;</span> | <span class="l">&quot;&#39;type&#39;&quot;</span>
               | <span class="l">&quot;PROP&quot;</span> | <span class="l">&quot;&#39;prop&#39;&quot;</span>
               | &lt;<span class="nc">symbol</span>&gt;
               | &lt;<span class="nc">instantiation</span>&gt;
               | &lt;<span class="nc">abstraction</span>&gt;
               | &lt;<span class="nc">application</span>&gt;

<span class="c1">; instantiation related grammar</span>
&lt;<span class="nc">instantiation</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">symbol</span>&gt; <span class="l">&quot;()&quot;</span>
                  | &lt;<span class="nc">symbol</span>&gt; <span class="l">&quot;(&quot;</span> &lt;<span class="nc">expression</span> <span class="nc">list</span>&gt; <span class="l">&quot;)&quot;</span>

&lt;<span class="nc">expression</span> <span class="nc">list</span>&gt; ::<span class="o">=</span> &lt;<span class="nc">expression</span>&gt;
                    | &lt;<span class="nc">expression</span> <span class="nc">list</span>&gt; <span class="l">&quot;,&quot;</span> &lt;<span class="nc">expression</span>&gt;

<span class="c1">; lambda abstrations</span>
&lt;<span class="nc">abstraction</span>&gt; <span class="o">=</span> <span class="l">&quot;[&quot;</span> &lt;<span class="nc">identifier</span>&gt; &lt;<span class="nc">comma</span>&gt; &lt;<span class="nc">expression</span>&gt; <span class="l">&quot;]&quot;</span> &lt;<span class="nc">expression</span>&gt;
&lt;<span class="nc">comma</span>&gt; <span class="o">=</span> <span class="l">&quot;,&quot;</span> | <span class="l">&quot;:&quot;</span>

<span class="c1">;  application </span>
&lt;<span class="nc">application</span>&gt; <span class="o">=</span> <span class="l">&quot;&lt;&quot;</span> &lt;<span class="nc">expression</span>&gt; <span class="l">&quot;&gt;&quot;</span> &lt;<span class="nc">expression</span>&gt;
</pre>

**1.8. Comments.**
The last syntactic component of the grammar, comments. There are one
line comments and multi-line comments, which will be ignored by
Automath. We are a little sloppy with the grammar here, with the
understanding `<multiline comment>` is arbitrary text which does not
contain `}`, and `<text>` is arbitrary text which does not contain a
carriage return of any sort.

<pre class="highlight">
&lt;<span class="nc">comment</span>&gt; ::<span class="o">=</span> <span class="l">&quot;#&quot;</span> &lt;<span class="nc">text</span>&gt; &lt;<span class="nc">newline</span>&gt;
            | <span class="l">&quot;{&quot;</span> &lt;<span class="nc">multiline</span> <span class="nc">comment</span>&gt; <span class="l">&quot;}&quot;</span>
</pre>

# Denotational Semantics

**2.0.** The basic game plan is:  we show Automath has a denotational
semantic functor `〚...〛` whose image is a lambda-typed lambda calculus.
(The next section discusses what lambda-typed lambda calculus _is_,
specifically its operational semantics.)

We adjust Automath slightly to write out the entire context rather than
just the "indicator string" (i.e., the "top" of the context "stack").

**Remark.**
This denotational semantic presentation works for AUT-QE-NTI (AUT-QE
with _no type inclusions_). Type inclusion breaks the semantics in a bad
and unpleasant way. It might be worth-while to consider examining
"sub-kinding" instead of type inclusion, i.e., treat `[x:T]type` as a
"subtype" of `type`.
(End of Remark)

<a name="denotational-semantics-context" />

**2.1. Contexts.**
We have an inductive construct for the context.
The base case is `〚⊢ t:T〛: 1 →〚T〛`, and the inductive rule is
`〚Γ ⊢ t:T〛:〚Γ〛→〚T〛` where `〚Γ〛` expands out to the product of
types in the context. So:

- `〚c_1:T_1 ⊢ t:T〛:〚T_1〛→〚T〛`,
- `〚c_1:T_1, c_2:T_2 ⊢ t:T〛:〚T_1〛×〚T_2〛→〚T〛`,
- etc.

**2.2. Lambda Calculus.**
A lambda expression _is_ a morphism. We would have, for example,

- `〚⊢ (λx:nat,y:nat . x+y) : nat × nat -> nat〛: 1→Hom(ℕ×ℕ,ℕ)`

describe addition as a function: it's a morphism acting on 2 natural
numbers, and produces a natural number. This is represented by the
indicator function which picks out that particular morphism. More
generally,

- `〚⊢ (λx:T . b) : T -> T'〛: 1→Hom(〚T〛,〚T'〛)`

and with a general context we have

- `〚Γ ⊢ (λx:T . b) : T -> T'〛:〚Γ〛→ Hom(〚T〛,〚T'〛)`

Likewise lambda-calculus "application" amounts to an [evaluation map](https://ncatlab.org/nlab/show/evaluation+map)
in the ambient category.

# Operational Semantics

**3.0.**
I am...going to punt most of this, because Dr. de Groote has already
done a lot of hard work in his paper cited below. So showing soundness,
strong normalization, etc., we will simply assume.

**3.1. Definition: λ-Expressions.**
The set _E_ of λ-expressions is inductively defined as follows:

0. The constant τ ∈ _E_
0. If _x_ is a variable, then _x_ ∈ _E_
0. If _x_ is a variable and _A_, _B_ ∈ _E_,
   then (λ _x_ : _A_. _B_) ∈ _E_
0. If _A_, _B_ ∈ E, then (_A_ _B_) ∈ _E_.

**Remark.**
The constant τ is analogous to `Type` in other type theories, or
Barendregt's `*`.

**3.2. Definition: λ-Kinds.**
The set _K_ of λ-kinds is defined inductively as follows:

0. The constant κ ∈ _K_
0. If _x_ is a variable, _A_ ∈ _E_, and _B_ ∈ _K_,
then (λ _x_ : _A_. _B_) ∈ _K_

**3.3. Typing Contexts.**
A typing context is a sequence of declarations
_x_ : _A_ where _x_ is a variable, and _A_∈_E_.
Any context _Γ_, _x_ : _A_ is such that

0. the variable _x_ is not declared in _Γ_
0. all the variables occuring free in the _A_ are declared in _Γ_.

**3.4. Typing Judgments.**
We define the notion of well-typed λ-expressions by providing a proof
system to derive typing judgments of the shape

- _Γ_ ⊢ _A_ : _B_

where _Γ_ is a typing context, and _A_, _B_ are λ-expressions. Although
_A_ and _B_ are in the same syntactic categories, we may sometimes refer
to _A_ as a "term" and _B_ as a "type" for convenience.

**Remark.**
We also have a similar judgement where _B_ is a λ-kind. Strictly
speaking, the two types of judgements are _different_. Nevertheless, we
abuse notation, and make no distinction between them.

**3.5. Beta Reduction.**
Since this is a lambda-calculus at heart, we have beta reduction
indicated by &rarr;<sub>β</sub>. Taking its reflexive, transitive,
symmetric closure, we get beta-conversion denoted =<sub>β</sub>.

**3.6. Proof System.**
Let _Γ_ be a typing context, _A_ be a λ-expression, and _B_ be either a
λ-kind or a λ-expression. A typing judgment of λ<sup>λ</sup> is an
expression of the form

- _Γ_ ⊢ _A_ : _B_

derivable according to the following proof system:

<ul>
<item>
<table>
<tbody>
  <tr style="border-top: 0px;">
    <th style="border-width: 0px 0px 1px 0px; border-bottom: 1px solid black;">
      &nbsp;
    </th>
    <th rowspan="2" style="border: 0px;">
      Constant
    </th>
  </tr>
  <tr>
    <td style="border: 0px;">
      ⊢ τ : κ
    </td>
  </tr>
</tbody>
</table> 
</item>

<item>
<table>
<tbody>
  <tr style="border-top: 0px;">
    <th style="border-width: 0px 0px 1px 0px; border-bottom: 1px solid black;">
      <i>Γ</i> ⊢ <i>A</i> : <i>B</i>
    </th>
    <th rowspan="2" style="border: 0px;">
      Variable
    </th>
  </tr>
  <tr>
    <td style="border: 0px;"><i>Γ</i>, <i>x</i>:<i>A</i> ⊢ <i>x</i>:<i>A</i></td>
  </tr>
</tbody>
</table>
</item>
<item>
<table>
<tbody>
  <tr style="border-top: 0px;">
    <th style="border-width: 0px 0px 1px 0px; border-bottom: 1px solid black;">
      <i>Γ</i>, <i>x</i>:<i>A</i> ⊢ <i>B</i> : <i>C</i>
    </th>
    <th rowspan="2" style="border: 0px;">
      Abstraction
    </th>
  </tr>
  <tr>
    <td style="border: 0px;">
      <i>Γ</i> ⊢ (λ<i>x</i>:<i>A</i>.<i>B</i>) : (λ<i>x</i>:<i>A</i>.<i>C</i>)
    </td>
  </tr>
</tbody>
</table> 
</item>
<item>
<table>
<tbody>
  <tr style="border-top: 0px;">
    <th style="border-width: 0px 0px 1px 0px; border-bottom: 1px solid black;">
      <i>Γ</i> ⊢ A : (λ<i>x</i>:<i>C</i>.<i>D</i>)
      &nbsp;&nbsp;&nbsp;&nbsp;
      <i>Γ</i> ⊢ <i>B</i>:<i>C</i>
    </th>
    <th rowspan="2" style="border: 0px;">
      Application
    </th>
  </tr>
  <tr>
    <td style="border: 0px;">
      <i>Γ</i> ⊢ (<i>A</i> <i>B</i>) : <i>D</i>[<i>x</i>:=<i>B</i>]
    </td>
  </tr>
</tbody>
</table> 
</item>
<item>
<table>
<tbody>
  <tr style="border-top: 0px;">
    <th style="border-width: 0px 0px 1px 0px; border-bottom: 1px solid black;">
      <i>Γ</i> ⊢ <i>A</i> : <i>B</i>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <i>Γ</i> ⊢ <i>C</i>:<i>D</i>
    </th>
    <th rowspan="2" style="border: 0px;">
      Weakening
    </th>
  </tr>
  <tr>
    <td style="border: 0px;">
      <i>Γ</i>, <i>x</i>:<i>C</i> ⊢ <i>A</i> : <i>B</i>
    </td>
  </tr>
</tbody>
</table> 
</item>
<item>
<table>
<tbody>
  <tr style="border-top: 0px;">
    <th style="border-width: 0px 0px 1px 0px; border-bottom: 1px solid black;">
      <i>Γ</i> ⊢ <i>A</i> : <i>B</i>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <i>Γ</i> ⊢ <i>C</i>:<i>D</i>
    </th>
    <th rowspan="2" style="border: 0px;">
      if <i>B</i> =<sub>β</sub> <i>C</i>; type conversion
    </th>
  </tr>
  <tr>
    <td style="border: 0px;">
      <i>Γ</i> ⊢ <i>A</i> : <i>C</i>
    </td>
  </tr>
</tbody>
</table> 
</item>
</ul>

Given some λ-expression _A_ and typing context _Γ_, we say the λ-expression
_A_ is "Well-typed" according to the context _Γ_ if and only if there
exists a λ-kind or λ-expression _B_ such that _Γ_ ⊢ _A_ : _B_.

Given some λ-expression _A_, we call _A_ a "Correct λ-expression of
λ<sup>λ</sup>" if and only if _A_ is well-typed according to the empty
context. 

**Remark 1.**
Observe, in the rule of application, we necessarily have _C_ be a
λ-expression (and hence _B_ is one, too). But _D_ may be a λ-kind or a
λ-expression.
(End of Remark)

**Remark 2.**
The abstraction rule of inference tells us that semantically parameters
in the context are "equivalent" (in a precise sense) to arguments in a
lambda abstraction. The difference is, to change from the `x:T * t:T' := body`
to a lambda expression requires us to make the type a lambda-type too:
`* [x:T]t : [x:T]T' := body` is the semantically equivalent line.
(End of Remark)

# References

- N.G. de Bruijn,
  "The Mathematical Language Automath, its Usage, and Some of its
  Extensions".
  In _Symposium on Automatic Demonstration_ (Eds. M Laudet, D Lacombe,
  and M Schuetzenberger), pp 29-61;
  and reprinted in _Selected Papers on Automath_, pp 73--100.
- N.G. de Bruijn,
  "A survey of the project Automath".
  In _To H.B. Curry: Essays on Combinatory Logic, Lambda Calculus and Formalism_
  (Eds. JP Selding and JR Hindley), pp 579--606.
  Also in _Selected Papers on Automath_, pp. 141--161
- Diederik T. van Daalen,
  "The Language Theory of Automath". PhD Thesis, [pdf](http://alexandria.tue.nl/extra3/proefschrift/PRF3B/8001697.pdf)
  1980.
- Philippe de Groote,
  "Defining λ-Typed λ-Calculi by Axiomatizing the Typing Relation".
  In:
  _10th Annual Symposium on Theoretical Aspects of Computer Science, STACS’93_,
  (Eds. P. Enjalbert, A. Finkel, and K.W. Wagner),
  _Lecture Notes in Computer Science_, Vol. 665, Springer-Verlag (1993), pp. 712-723.
  [Eprint](http://www.loria.fr/~degroote/papers/stacs93.pdf)
- Benjamin C. Pierce,
  _Types and Programming Languages_.
  MIT Press, 2002.
- I. Zandleven,
  "A Verifying Program for Automath".
  E1 in _Selected Papers on Automath_.
