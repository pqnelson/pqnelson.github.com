---
layout: wiki
title: Simply-Typed Lambda Calculus
published: true
date: 2016-01-17
parentURL: /wiki/type-theory/lambda-cube/
---

## Grammar

There are 4 categories of expressions for simply-typed lambda calculus:
terms, values, types, and contexts. Values are terms that "cannot be
evaluated any further", they're as "simple" as possible. Contexts are
used for making typing judgments, assertions regarding the type of a term.

"Pure" simply-typed lambda calculus has no base types. That is, the only
types allowed are function-types.

The syntax for simply-typed lambda calculus has the following structure:

```
t ::=        -- terms:
      x      -- variable
      λx:T.t -- abstraction
      t t    -- application

v ::=        -- values:
      λx:T.t -- abstraction values

T ::=        -- types:
      T→T    -- type of functions

Γ ::=        -- contexts:
      ∅      -- empty context
      Γ, x:T -- term variable binding
```

## Evaluation `t ⟶ t'`

I am endeavouring to use &#10230; for evaluation, and <tt>&rarr;</tt>
for function types. Formally, it is a binary relation, and when we have
"<tt>t</tt> ⟶ <tt>t'</tt>" we state "the evaluation <dfn>statement</dfn>
(or <dfn>judgment</dfn>) <tt>t</tt> ⟶ <tt>t'</tt> is
<dfn>derivable</dfn>." For simply-typed lambda calculus, it is the
'smallest' one which satisfies three properties.

The first two describe how application "commutes" with evaluation,
specifically "on the left" (E-App1) and "on the right" (E-App2)

<table class="inference">
<tbody>
  <tr>
    <th>
      <tt>t<sub>1</sub></tt> &#10230; <tt>t'<sub>1</sub></tt>
    </th>
    <th rowspan="2" style="border: 0px;">
    (E-App1)
    </th>
  </tr>
  <tr>
    <td class="conclusion">
      <tt>t<sub>1</sub> t<sub>2</sub></tt> &#10230; <tt>t'<sub>1</sub> t<sub>2</sub></tt>
    </td>
  </tr>
</tbody>
</table>

<table class="inference">
<tbody>
  <tr>
    <th>
      <tt>t<sub>2</sub></tt> &#10230; <tt>t'<sub>2</sub></tt>
    </th>
    <th rowspan="2" style="border: 0px;">
    (E-App2)
    </th>
  </tr>
  <tr>
    <td class="conclusion">
      <tt>t<sub>1</sub> t<sub>2</sub></tt> &#10230; <tt>t<sub>1</sub> t'<sub>2</sub></tt>
    </td>
  </tr>
</tbody>
</table>

We also have the hallmark of lambda calculus, beta reduction. This tells
us how to substitute a value for a bound variable in a
lambda-abstraction. Note the value <tt>v<sub>2</sub></tt> must be of
type <tt>T<sub>11</sub></tt> for this to work out, otherwise we cannot
evaluate the expression.

<table class="inference">
<tbody>
  <tr>
    <td class="conclusion">
      <tt>(λ x:T<sub>11</sub> . t<sub>12</sub>) v<sub>2</sub></tt> &#10230; <tt>[x &#8614; v<sub>2</sub>]t<sub>12</sub></tt>
    </td>
    <td style="border:0px;">
      (E-AppAbs)
    </td>
  </tr>
</tbody>
</table>

## Typing `Γ ⊢ t : T`

Typing statements involve a ternary-relation, the _typing relation_,
which is written "infix" as `_ ⊢ _ : _`. The first slot is filled by a
typing context, the second by a term, and the last by a type.

Typing statements first force us to discuss the typing context. A typing
context is a sequence of variables and their types, and the "comma"
operator extends the context by "pushing" a new binding on the right. A
variable appears at most once in a typing context.

We have the property: a variable has whatever type we are currently
assuming it to have. Formally, if we write "<tt>x:T ∈ Γ</tt>" for "We
are assuming <tt>x</tt> has type <tt>T</tt> in the current context
<tt>Γ</tt>", then this property is represented by the typing rule:

<table class="inference">
<tbody>
  <tr>
    <th>
      <tt>x:T ∈ Γ</tt>
    </th>
    <th rowspan="2" style="border: 0px;">
    (T-Var)
    </th>
  </tr>
  <tr>
    <td class="conclusion">
      <tt>Γ ⊢ x:T</tt>
    </td>
  </tr>
</tbody>
</table>

Any variable that occurs must either be bound by a lambda-abstraction,
or appear in the typing context. If it appears in the typing context `x:T' ∈ Γ`,
then it may appear in the term `t` judged in the typing relation `Γ ⊢
t:T`. That is to say, to be more explicit, we may have `Γ ⊢ t(x):T`
where we indicate the possible dependence of `t` on `x` explicitly "as
if" it were a function.

For example, if we assume `b` is a `boolean`, then `not(b)` is
also a `boolean`. But `b` is a free variable in `not(b)` --- it's okay,
however, since it is in the typing context `Γ=b:boolean`. From this we
may assemble a lambda-abstraction, moving the `b:boolean` from the 
typing context to the variable bound in the lambda expression.

More generally, if our typing context is <tt>Γ, x:T<sub>1</sub></tt>,
and we have <tt>t<sub>2</sub>:T<sub>2</sub></tt> hold in this context,
then we may assemble a lambda-abstraction over `x`. 

<table class="inference">
<tbody>
  <tr>
    <th>
      <tt>Γ, x:T<sub>1</sub> ⊢ t<sub>2</sub>:T<sub>2</sub></tt>
    </th>
    <th rowspan="2" style="border: 0px;">
    (T-Abs)
    </th>
  </tr>
  <tr>
    <td class="conclusion">
      <tt>Γ ⊢ (λx:T<sub>1</sub>.t<sub>2</sub>) : T<sub>1</sub>&rarr;T<sub>2</sub></tt>
    </td>
  </tr>
</tbody>
</table>

The opposite property holds, if we're given a lambda abstraction of type
<tt>T<sub>11</sub> &rarr; T<sub>12</sub></tt> and we're given a term of
type <tt>T<sub>11</sub></tt>, then application produces a term of type
<tt>T<sub>12</sub></tt>.

<table class="inference">
<tbody>
  <tr>
    <th>
      <span>
        <tt>Γ ⊢ t<sub>1</sub>:T<sub>11</sub> &rarr; T<sub>12</sub></tt>,
      </span>
      <span style="margin-left:1.5em;">
        <tt>Γ ⊢ t<sub>2</sub>:T<sub>11</sub></tt>
      </span>
    </th>
    <th rowspan="2" style="border: 0px;">
    (T-App)
    </th>
  </tr>
  <tr>
    <td class="conclusion">
      <tt>Γ ⊢ (t<sub>1</sub> t<sub>2</sub>) : T<sub>12</sub></tt>
    </td>
  </tr>
</tbody>
</table>

## Properties

**Degeneracy.**
Pure simply-typed lambda calculus is "degenerate", in the sense that it
has no terms.

**Inversion Lemma.**

0. If `Γ ⊢ x:T`, then `x:T ∈ Γ`
0. If `Γ ⊢ λx:T . t : R` then `R = T→T'` for some `T'`, with `Γ, x:T ⊢ t:T'`.
0. If `Γ ⊢ t t' : R`, then there is some type `T` such that
   `Γ ⊢ t : T→R` and `Γ ⊢ t' : T`.

_Proof:_ Immediate from the definition of the typing relation. (End of Proof)

**Progress Theorem.**
Suppose `t` is a closed, well-typed term (i.e., we have `⊢ t : T` for
some type `T`).
Then either `t` is a value, or there is some `t'` with <code>t</code>
&#10230; <code>t'</code>.
(End of Theorem)

_Proof._ By induction typing derivations. We see (T-Var) cannot
contribute to this, nor can (T-Abs) --- both involve terms that cannot
be closed.

We are left with (T-App) as the only case we need to consider, where
<code>t = t<sub>1</sub> t<sub>2</sub></code>
with <code>⊢ t<sub>1</sub> : T<sub>11</sub> &rarr; T<sub>12</sub></code>
and <code>⊢ t<sub>2</sub> : T<sub>11</sub></code>.

The inductive hypothesis tells us either <code>t<sub>1</sub></code> is a
value, or <code>t<sub>2</sub></code> is a value (or both are values). We
must examine these cases each in turn.

- If <code>t<sub>1</sub></code> can take a step, then (E-App1) applies to `t`
- If <code>t<sub>2</sub></code> can take a step, then (E-App2) applies
  to `t`.
- If both <code>t<sub>1</sub></code> and <code>t<sub>2</sub></code> are
  values, then the inversion lemma tells us <code>t<sub>1</sub></code>
  takes the form <code>λx:T<sub>11</sub> . t<sub>12</sub></code>, hence
  (E-AppAbs) applies to `t`.

(End of Proof)

**Preservation Theorem.**
If `Γ ⊢ t:T` and <code>t</code> &#10230; <code>t'</code>,
then `Γ ⊢ t':T`.
(End of Theorem)

_Proof._ Again, by induction on a derivation of `Γ ⊢ t:T`.

- **Case** (T-Var):
- **Case** (T-Abs):
- **Case** (T-App):
