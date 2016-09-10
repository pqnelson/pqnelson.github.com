---
layout: wiki
title: Definitions in Type Theory
published: true
date: 2016-09-09
parentURL: /wiki/type-theory/
---

**1. Syntax of a Definition in Type Theory.**
A definition has the following general format: `Γ ▹ a(x_1, ..., x_n) := E`
where:

- `Γ = x_1 : A_1, ..., x_n : A_n` is the context for the definition
- `a` is a constant suffixed with a parameter list, and
- `E` is the definiens (i.e., body of the definition).

The meaning of such an expression should be read "In the context `Γ`,
we define `a(x_1, ..., x_n)` as `E`."

_Remark 1_ (Notation).
The triangle `▹` plays an analogous role as the turnstile `⊢` in
separating the context from the statement.
(End of Remark) 

_Remark 2_ (Parameters).
Consider the definition of the derivative for a function, which
generically looks like "Let `x` be a point, `(a,b)` be an open interval
containing `x`, and  `f` be a function on `(a,b)` to the real
numbers. Then the derivative of `f` at `x` is ...". There are 3 parameters
here: the point `x` we evaluate the derivative at, the neighborhood
`(a,b)` of `x`, and the function `f` we are differentiating.

When we fix all 3 quantities, we get a well-defined term or
**"Instantiation"** of the definition. When we leave
various parameters unfixed, we get a family of terms.
(End of Remark)

_Remark 3_ (Constants). 
If we want to define a constant, then the context will be empty. We may
write either `a()` or just `a` for the constant, with the understanding
that it takes no parameters.
(End of Remark)

**2. Type Annotations.**
Since we are working in a typed environment (this is type theory, after
all), we need to add the type of the definiendum `a`. So the syntax for
a definition becomes `Γ ▹ a(x_1, ..., x_n) := M : N`.

**3. Any Judgment may be a Definition.**
Any judgment `Γ ⊢ M : N` may be represented as a definition
`Γ ▹ a(...) := M : N`.

**4. Definition.**
An **"Environment"** is a finite (empty or non-empty) ordered list of
definitions.

A symbol `a` is **"Fresh"** with respect to the environment `Δ` if no
definition in `Δ` has its definiendum be `a`.

We abuse notation, and if `Δ` is an environment and `D` a "fresh"
definition, then we write `Δ, D` for the new environment obtained by
appending `D` to `Δ`.

**5. Definition.**
A **"Judgment with Definitions"** (or _"Extended Judgment"_) is of the
form
`Γ; Δ ⊢ M : N`
where `Δ` is an environment, `Γ` a context, and `M`, `N` are
expressions.

**6. Rule for Introducing Definitions.**
Let `a` be a fresh name with respect to `Δ`, and
`D ≡ x_1 : A_1, ..., x_n : A_n ▹ a(...) := M : N`
be a definition. Then we introduce append a definition to the
environment with the following rule:

<table class="inference">
<tbody>
  <tr>
    <th>
      <code>Γ; Δ ⊢ K : L</code>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <code>x_1 : A_1, ..., x_n : A_n; Δ ⊢ K : L</code>
    </th>
    <th rowspan="2" style="border: 0px;">
      Definition
    </th>
  </tr>
  <tr>
    <td class="conclusion">
      <code>Γ; Δ, D ⊢ K : L</code>
    </td>
  </tr>
</tbody>
</table> 

**7. Rule for Instantiating a Definition.**
Let `a` be a constant,
`D ≡ x_1 : A_1, ..., x_n : A_n ▹ a(...) := M : N`, and
`Δ` an environment. Suppose `D ∈ Δ`. Then instantiating a definition is
given by the following rule:

<table class="inference">
<tbody>
  <tr>
    <th>
      <code>Γ; Δ ⊢ * : ◻</code>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <code>Γ; Δ ⊢ <b><i>U</i></b> : <b><i>A</i></b>[<b><i>x</i></b>:=<b><i>U</i></b>]</code>
    </th>
    <th rowspan="2" style="border: 0px;">
      Instantiation
    </th>
  </tr>
  <tr>
    <td class="conclusion">
      <code>Γ; Δ, D ⊢ a(<b><i>U</i></b>) : N[<b><i>x</i></b>:=<b><i>U</i></b>]</code>
    </td>
  </tr>
</tbody>
</table>

where we use bold italics to condense equality of lists, i.e.,
"<b><i>x</i></b> := <b><i>U</i></b>"
is short hand for `x_1:=U_1, ..., x_n:=U_n`, and so on.

_Remark 1._ The upper right-hand corner for this rule of inference
covers the case when there are no parameters in the definition.
(End of Remark)

_Remark 2._ The upper left-hand corner for this rule of inference covers
the case when there are `n>=1` parameters, and we attempt to set
`a(U_1, ..., U_n)`.
But if `x_2` depends on `x_1`, then we need to set `x_2:=U_2[x_1:=U_1]`,
and so on.
(End of Remark)

**8. Primitive Notions.**
When we have a primitive definition, like the constant "zero" in Peano
arithmetic, we assign the body of the definition to be a special
constant `⫫`.

_Remark_ (Instantiation, Delta Reduction).
When we replace the constant defined for its body, this is called "delta
reduction". For primitive definitions, we cannot do any delta
reductions...which justifies calling them "primitive". Instantiation may
be done, we just fix parameters to be certain terms. But we cannot
perform any delta reductions!
(End of Remark)

# References
- Herman Geuvers and Robert Nederpelt,
  _Type Theory and Formal Proof_.
  Cambridge University Press, 2014.
- Paula Severi and Erik Poll,
  "Pure Type Systems with Definitions".
  [Eprint](https://www.cs.ru.nl/E.Poll/papers/dpts.pdf)
- Fairouz Kamareddine, Twan Laan, Rob Nederpelt, 
  _A Modern Perspective on Type Theory_.
  Springer, 2005. Specifically Chapter 8 "Pure Type Systems with definitions".
