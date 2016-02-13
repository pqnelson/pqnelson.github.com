---
layout: post
published: true
title: Automated Theorem Proving, Prolegomena on Propositional Logic
quote: "Logic: The art of thinking and reasoning in strict accordance with the limitations and incapacities of the human misunderstanding."
quoteSource: Ambrose Bierce, <em>The Devil's Dictionary</em> (1911)
tags: [Automated Theorem Prover, Logic]
---

# Introduction

I will basically review propositional logic at lightning speeds, just to
make certain I've discussed important aspects of propositional
logic. Later I will write a sequel post for first-order logic.

Logic, as a language, has three components:

**1. Syntax.** The notation & syntax tree for a formula, so something
like `p ∧ ¬q` really is a tree that looks like:

```
  ∧
 / \
p   ¬
     \
      q
```

**2. Semantics.** The *meaning* of a formula, which for logic is
typically `True` or `False`.

**3. Proof Theory.** How to prove statements, usually starting with
  *axioms* and arriving at true statements using *inference rules*.

# Syntax

We have some propositional variables _p_, _q_, etc. If a formula
consists of a single propositional variable (e.g., the formula "_p_"),
then it is **"Atomic"**. We take `T` and `F` to be true and false, respectively.

We also have some connectives like `¬` (not), `∧` (and), `∨` (or),
`⇒` (material implication), `⇔` (if and only if), listed in that
order of precedence. So some formula like `¬p ∧ q ∨ r ⇒ s ⇔ t` should
be read as `((((¬p) ∧ q) ∨ r) ⇒ s) ⇔ t`. 

Now, we are discussing a language (logic) in English. But English is
also a language. We call English (our discussion of logic) a
**"Metalanguage"** and logic the **"Object Language"**. (If we were
learning Russian, and asked each other -- in English -- questions about
pronunciation of Russian vocabulary, then English would be the
metalanguage which facilitates our discussion of Russian, the object
language.) 

# Semantics

Since propositional logic is a language, we can note that each formula
should have some meaning (either 1 for true, or 0 for false) depending
on the meaning of the propositional variables it contains. The meaning
can be determined using the usual truth tables, e.g.,

| p | q |    ¬p |  p ∧ q  |  p ∨ q | p ⇒ q       | p ⇔ q   |
|---|---|-------|---------|--------|-------------|---------|
| 0 | 0 | 1     | 0       | 0      | 1           | 1       |
| 0 | 1 | 1     | 0       | 1      | 1           | 0       |
| 1 | 0 | 0     | 0       | 1      | 0           | 0       |
| 1 | 1 | 0     | 1       | 1      | 1           | 1       |

So now, we can say two formulas are logically equivalent if they have
the same truth table. For example, `p ⇒ q` has the same truth table as
`¬p ∨ q`, and `p ⇔ q` has the same truth table as `(p ⇒ q) ∧ (q ⇒ p)`.

But, wait, weren't we using `T` and `F` for true and false? What's up
with the 0 and 1? Well, we are using `T` and `F` in the language as
*symbols* denoting the truth-values 1 and 0, respectively. So `T` and
`F` belong to syntax, while 1 & 0 belong to semantics.

## Interpretations
**Definition.** An **"Interpretation"** (or *truth-assignment*) for a
set of formulas is a function from its set of propositional symbols to
`{0, 1}`.

An interpretation **"Satisfies"** a formula if the formula evaluates to
1 under the interpretation.

A set _S_ of formulas is:

1. **"Valid"** (or a *tautology*) if every interpretation for _S_ satisfies every formula in _S_. (Every interpretation results in 1)
2. **"Satisfiable"** (or *consistent*) if there is some interpretation
  for _S_ which satisfies every formula. (At least one interpretation
  results in 1)
3. **"Unsatisfiable"** (or *inconsistent*) if it is not
   satisfiable. (Every interpretation results in 0)

The set of formulas _S_ then **"Entails"** _p_ if every interpretation
that satisfies all formulas of _S_ also satisfies _p_; we write _S_ ⊨ _p_.

Formulas _p_ and _q_ are **"Equivalent"**, _p_ ≅ _q_, if _p_ ⊨ _q_ and
_q_ ⊨ _p_. (End of Definitions)

Observe _S_ ⊨ _p_ if and only if _S_ ∪ {¬_p_} is inconsistent.

Furthermore, if _S_ is inconsistent, then _S_ ⊨ _p_ for any _p_. (You
may hear people claim "We can deduce anything from a contradiction";
well, this is an example of it.)

We have ⊨ _p_ (or perhaps technically {} ⊨ _p_) if and only if _p_ is
valid (or equivalently ¬_p_ is inconsistent).

**Remark 1** (Notational Conventions)**.**
When _S_ consists of a single formula, we will write _p_ ⊨ _q_ instead
of {_p_} ⊨ _q_. (End of Remark)

**Remark 2** (On ≅ and ⊨ symbols)**.**
We should also note the symbols ≅ and ⊨ belong to the metalanguage. So
they are not logical connectives, just relations between formulas. They
therefore have the lowest precedence, since something like ¬_p_ ∨ _q_ ≅ _r_
could only mean (¬_p_ ∨ _q_) ≅ _r_ since ¬_p_ ∨ (_q_ ≅ _r_) would make
no sense &mdash; (_q_ ≅ _r_) is not a valid formula! (End of remark)

### Examples: Tautologies, Contradictions, Satisfiable Formulas

We have some propositions which are always true, e.g., ¬_p_ ∨ _p_, _p_ ⇒ _p_,
and so on. These are tautologies.

In general, if _A_ is a valid formula, then ¬_A_ is unsatisfiable.

If a formula is neither valid nor unsatisfiable, then it must be
satisfiable.

## Equivalences

We have _A_ ⇔ _B_ and _A_ ≅ _B_ be different kinds of assertions. The
first, _A_ ⇔ _B_, refers to one fixed interpretation, whereas the second 
_A_ ≅ _B_ holds for all interpretations. But ⊨ _A_ ⇔ _B_ means precisely
the same thing as _A_ ≅ _B_. We stress *both are metalanguage statements*
saying _A_ ⇔ _B_ is a tautology.

Likewise _A_ ⊨ _B_ and _A_ ⇒ _B_ are different kinds of assertions,
although ⊨ _A_ ⇒ _B_ and _A_ ⊨ _B_ mean the same thing. The formula
_A_ ⇒ _B_ is a tautology if and only if _A_ ⊨ _B_.

### Adequacy

So, every statement involving _n_ propositional variables generates a
corresponding Boolean-valued function of _n_ arguments. The arguments
and values of the function are `T` and `F`. Logically equivalent forms
generate the same truth function (after all, they have the same truth
table!).

**Proposition** (Mendelson 1.5)**.**
Every Boolean-valued function is generated by a statement form involving
the connectives ¬, ∧, and ∨.
(End of Proposition)

Basically, this says any formula in propositional calculus is equivalent
to one constructed using ¬, ∧, and ∨.

**Definition.** The set of connectives _S_ is called **"Adequate"** if
given any arbitrary formula _A_, we may form a logically equivalent
formula using only the connectives from _S_. (End of Definition)

**Example.** Bourbaki's system uses ¬ and ∨ as their basic connectives,
from which they generate everything else. (End of Example)

**Example.** Henry Sheffer's "A set of five independent postulates for
Boolean algebras, with application to logical constants" (*Trans. of the
AMS* **14** (1913) 481–488, JSTOR [1988701](http://www.jstor.org/stable/1988701)) showed that the connective _p_ ↑ _q_ defined as ¬ (_p_ ∧ _q_)
is an adequate connective. That is, we can reconstruct all others from
it. We see ¬ _p_ = _p_ ↑ _p_, and _p_ ∨ _q_ = (_p_ ↑ _p_) ↑ (_q_ ↑ _q_),
and then we recover our proposition which proves this is adequate. (End
of Example)

**Exercise.** Sheffer also showed the connective _p_ | _q_ defined as
¬ (_p_ ∨ _q_) is an adequate connective. (Russell and Whitehead picked
it up in their second edition of *Principia Mathematica*.) Show this is
in fact an adequate connective. (End of Exercise)

# Proof Systems

We determine if a proposition is a tautology or not by checking all
interpretations. This is a *semantic* approach.

The *syntactic* approach is a formal proof: generating theorems by
applying syntactic transformations of some kind. This can be done by
restricting the connectives to some adequate set, but most methods are
based on axioms and inference rules.

Efficiency is a problem. Since satisfiability for propositional logic is
an NP-complete problem, the runtime is usually exponential in the number
of atomic variables. There have been amazing advances in technology
with SAT solvers and [BDD](http://en.wikipedia.org/wiki/Binary_decision_diagram). But they still have an exponential worst-case runtime.

**Remark** (History)**.**
There are three different proof systems worth investigating: the Hilbert
system, natural deduction, and sequent calculus. We refer the reader to
the [Stanford Encyclopedia](http://plato.stanford.edu/entries/proof-theory-development/) for the history of these methods.
(End of Remark)

## Hilbert Systems

Hilbert systems provide rules for a minimal set of connectives. For
example, implication only. The other connectives are not considered
primitive, but are _defined_ in terms of implication:

- ¬_p_ := _p_ ⇒ `F`
- _p_ ∨ _q_ := ¬_p_ ⇒ _q_
- _p_ ∧ _q_ := ¬(¬_p_ ∨ ¬_q_)

Let _A_, _B_, _C_ be arbitrary formulas. We have three axioms:

1. _A_ ⇒ (_B_ ⇒ _A_)
2. (_A_ ⇒ (_B_ ⇒ _C_)) ⇒ ((_A_ ⇒ _B_) ⇒ (_A_ ⇒ _C_))
3. ¬¬_A_ ⇒ _A_

(Well, these are axiom schemes, since we have to substitute a given
formula for _A_...so these are describing *infinite sets of formulas*.)

We have a single rule of inference (above the vertical line, we write
down the premises; below the vertical line, the conclusion):

&nbsp;&nbsp;_A_<br />
<u>_A_ ⇒ _B_</u><br />
_B_.

This is the traditional *Modus Ponens* rule of inference. This rule of
inference with our three axioms can prove all tautologies of classical
propositional logic.

**Remark** (Soundness, Completeness in general)**.**
We expect, in general, our proof system to be **"Sound"**: every theorem
it generates must be valid.

We would like our proof system to also be **"Complete"**: it generates
*every* valid statement. This is harder to demonstrate and accomplish
for proof systems. (End of Remark)

**Summary.** So, a Hilbert system has a minimal set of adequate
connectives, a collection of axioms, and a few (possibly one) rules of
inference. It then generates all theorems by applying rules of inference
to the axioms or theorems in a mechanical manner.

Probably the most ambitious Hilbert system was Bourbaki's, but the most
thorough (as far as rigor) was Russell's *Principia Mathematica*...at
least, until electronic computers started formalizing mathematics.

## Natural Deduction

So, [Natural Deduction](http://en.wikipedia.org/wiki/Natural_deduction)
(see also Pfenning's
[notes](https://www.cs.cmu.edu/~fp/courses/atp/handouts/ch2-natded.pdf))
has three basic premises:

1. Judgements take place in some context;
2. Each logical connective is defined independent of the others;
3. Each connective is defined by *introduction* and *elimination* rules.

So, for example, the introduction rule for ∧-introduction describes how
to deduce _p_ ∧ _q_:

&nbsp;&nbsp;_p_&nbsp;&nbsp; <br />
<u>&nbsp;&nbsp;_q_&nbsp;&nbsp;</u> <br />
_p_ ∧ _q_

The ∧-elimination rule tells us what we can deduce from _p_ ∧ _q_, there
are two such rules:

<u>_p_ ∧ _q_</u><br />
_p_

And similarly

<u>_p_ ∧ _q_</u><br />
_q_

Observe, ⇒-elimination says what to deduce from _p_ ⇒ _q_, which is just
the usual _Modus Ponens_:

&nbsp;&nbsp;&nbsp;&nbsp;_p_ <br />
<u>_p_ ⇒ _q_</u><br />
_q_

In practice, this can get really messy really fast. I'll leave the
reader to peruse Pfenning's notes and Daniel Laboreo's
[Introduction to Natural Deduction](http://www.danielclemente.com/logica/dn.en.pdf)
for further reading.

## Sequent Calculus

Sequent calculus is similar in spirit to natural deduction. Again,
Pfenning's [notes](https://www.cs.cmu.edu/~fp/courses/atp/handouts/ch3-seqcalc.pdf)
are quite good, and recommended for the reader.

A **"Sequent"** has the form Γ ⊢ Δ where Γ ("the antecedent") and Δ
("the consequent") are finite sets of
formulas. For example _A_, _B_ ⊢ _C_, _D_ is true in a particular
interpretation if _A_ ∧ _B_ implies _C_ ∨ _D_.

**WARNING:** The "⊢" symbol is called the "turnstile" symbol, and one
reads the sequent "Γ ⊢ Δ" as "Γ proves/yields/entails Δ". One's intuition
should say "Hey, Δ is provable from the premises Γ".
(End of Warning)

A **"Basic Sequent"** is a sequent where the same formula appears "on
both sides", e.g., _p_, _B_ ⊢ _B_, _r_. The sequent is valid, since it's
of the form _p_ ∧ _B_ ⊢ _B_.

(Every basic sequent may be written as Γ ∪ {_A_} ⊢ Δ ∪ {_A_}, where _A_
is the common formula, and Γ has no formula in common with Δ.)

### "Backwards" Reasoning

We usually start with the antecedent and try to show one of the
consequents holds. How? By tracing backwards, using sequent rules to
reduce the consequents to simpler and simpler propositions, stopping
when one becomes trivial.

Why backwards? If we started with the antecedents, and tried generating
theorems, in practice we generate a lot of random theorems rather than
the ones desired.

### Rules of Inference

The rules of inference for sequent calculus are tricky, because they
come in two forms "left" and "right" (depending on which side of the
sequent's arrow Γ ⊢ Δ they act &mdash; left acts on Γ, the right act on
Δ). We also have logical rules (handling connectives) and structural
rules (which basically state the order of the premises do not matter). 

Right logical rules are analogous to natural deduction's introduction
rules; left logical rules correspond to elimination rules.

Let us construct a table of logical rules of inference, and not worry
too much about structural rules for now.

| Rule of Inference | Left Version | Right Version |
|-------------------|--------------|---------------|
| Negation          | <u>Γ ⊢ Δ, _A_</u><br />¬_A_, Γ ⊢ Δ  | <u>_A_, Γ ⊢ Δ</u><br />Γ ⊢ Δ, ¬_A_ |
| Conjunction       | <u>_A_, _B_ Γ ⊢ Δ</u><br />_A_ ∧ _B_, Γ ⊢ Δ | Γ ⊢ Δ, _A_<br /><u>Γ ⊢ Δ, _B_</u><br />Γ ⊢ Δ, _A_ ∧ _B_ |
| Disjunction       | _A_, Γ ⊢ Δ<br /><u>_B_, Γ ⊢ Δ</u><br />_A_ ∨ _B_, Γ ⊢ Δ | <u>Γ ⊢ Δ, _A_, _B_</u><br />Γ ⊢ Δ, _A_ ∨ _B_ |
| Implication       | Γ ⊢ Δ, _A_<br /><u>_B_, Γ ⊢ Δ</u><br />_A_ ⇒ _B_, Γ ⊢ Δ | <u>_A_, Γ ⊢ Δ, _B_</u><br />Γ ⊢ Δ, _A_ ⇒ _B_ |

### Axioms

The only axiom for sequential calculus is _A_ ⊢ _A_. For classical
logic, that's it. (For intuitionistic logic, that is also the only
axiom.)

**Remark.** One last remark about sequent calculus: if we restrict the
consequent to consist of a single proposition or formula, then we
recover natural deduction. That is to say, natural deduction is a
special case of sequent calculus; or sequent calculus is a generalized
version of natural deduction. (End of Remark)

# Conclusion

So, we've introduced the syntax and semantics of propositional logic,
and have reviewed the big three among proof calculi: Hilbert systems,
Natural Deduction, and Sequent calculus.

This should give the reader a nice foothold to understand quite a bit of
fundamentals for automated theorem provers. Next time, we will continue
working on our theorem prover, and won't touch theory again until we get
to first-order logic.

# References

- Nicolas Bourbaki,
  *The Theory of Sets*.
  Springer, 1968.
- W.M. Farmer,
  [Slides on Propositional Logic](http://imps.mcmaster.ca/courses/SE-2F03-05/slides/02-prop-logic.pdf)
  which discusses Hilbert systems and Natural deduction (among other things).
- Haim Gaifman,
  [A Hilbert Type Deductive System for Sentential Logic, Completeness and Compactness](http://www.columbia.edu/~hg17/ViewMathLogic/view1-deductive-system.pdf),
  lecture notes.
- Daniel Laboreo,
  [Introduction to Natural Deduction](http://www.danielclemente.com/logica/dn.en.pdf)
- Elliot Mendelson,
  *Introduction to Mathematical Logic*.
  Chapman and Hall, 5th ed., 2009. 
- Lawrence Paulson's
  [Lecture notes on Logic and Proof](http://www.cl.cam.ac.uk/teaching/1415/LogicProof/logic-notes.pdf)
- Frank Pfenning,
  [Lecture Notes on Automated Theorem Proving](https://www.cs.cmu.edu/~fp/courses/atp/handouts.html)
  for Carnegie-Mellon's 15-815 course.
- Alexander Sakharov,
  [Sequent Calculus Primer](http://sakharov.net/sequent.html)
- Encyclopedia of Math,
  [Sequent Calculus](http://www.encyclopediaofmath.org/index.php/Sequent_calculus)
