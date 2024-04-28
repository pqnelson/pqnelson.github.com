---
layout: post
title: Verifying Hardware with Isabelle/HOL
published: true
draft: false
quote: "I have bought this wonderful machine—a computer. Now I am rather an authority on gods, so I identified the machine—it seems to me to be an Old Testament god with a lot of rules and no mercy."
quoteSource: Joseph Campbell, <i>The Power of Myth</i> (1988)
tags: [Isabelle,Automated Theorem Prover]
---

There are several ways to formalize hardware in a proof assistant. I'm
interested in how to do it with Isabelle/HOL, but I'm sure it's not too
hard to make it work in another proof assistant.

The basic strategy is to formalize a hardware implementation using NAND
gates, formalize the machine language as an abstract machine, then prove
every program in machine code evaluates "the same way" on both machines.

I have [formalized](https://github.com/pqnelson/isabelle-nand2tetris)
the combinational circuitry of a simple ALU in Isabelle/HOL, and these
are some notes about the basic ideas how we formalize computer hardware.

# Logic Gates as Logical Relations

Historically, the first successful approach to formalizing real world
hardware was Anthony Fox's formalization of ARM 6 in HOL. Fox's
ingenuity boils down to the slogan: "A logic gate is a logical relation
of its inputs and outputs". (To be fair, Mike Gordon realized this in
the 1980s, see the bibliography for references, but Fox was the first to
formalize an actual CPU.) 
For example, the switch model of CMOS has:

```isabelle
definition PTran :: "bool × 'a × 'a ⇒ bool" where
  "PTran = (λ(g,a,b). (~g --> a = b))"

definition NTran :: "bool × 'a × 'a ⇒ bool" where
  "NTran = (λ(g,a,b). (g --> a = b))"
  
definition Power :: "bool ⇒ bool" where
  "Power p = (p = True)"

definition Ground :: "bool ⇒ bool" where
  "Ground p = (p = False)"
```

This is so general that we could allow `PTran` to work on _signals_ `a`
and `b`, or on whatever we'd want.

We combine circuits `L[in, out]` and `R[in, out]` by `EX x. L[in, x] ∧ R[x, out]`.
That is to say, we have a wire `x` which connects the output of `L` to
the input of `R`, and this is modeled as yet another logical
relation. 
This produces a third circuit `C[in, out]` modeled as a logical relation
of signals.

**Remark.** There is nothing specifically forcing us to use higher-order
logic. We could have ostensibly used first-order logic, formalizing CMOS
circuits in Mizar for example. But Isabelle/HOL is the industry
standard.
(End of Remark)

This compositionality allows us to prove properties concerning
constituent components, and use them to deduce results concerning the
larger module.

**Example 1.** Here's an example implementing a NAND gate using P-mos and N-mos
transistors, with simple boolean-valued wires:

```isabelle
definition "PTran = (λ(g,a,b). (g ∧ ~b) ∨ (~g ∧ (a = b)))"

definition "NTran = (λ(g,a,b). (~g ∧ ~b) ∨ (g ∧ (a = b)))"

definition "Power p ≡ (p = True)"

definition "Ground p ≡ (p = False)"

definition "Join ≡ (λ(i1,i2,out). (out = (i1 ∨ i2)))"

definition 
 "NAND a b out ≡ EX w1 w2 w3 w4 w5 w6 w7.
    Power(w1) ∧
    PTran (a, w1, w2) ∧
    PTran (b, w1, w3) ∧
    Join(w2,w3,w4) ∧
    Join(w4,w5,out) ∧
    NTran(a, w6, w5) ∧
    NTran(b, w7, w6) ∧
    Ground(w7)"
```

We should then prove our NAND gate implementation with CMOS transistors
works, which is a simple enough proof by cases:

```isabelle
lemma "NAND a b out <--> (out <--> ¬(a ∧ b))"
  apply (case_tac a; case_tac b)
  apply (simp add: NAND_def PTran_def NTran_def Ground_def Power_def Join_def; fastforce)+
  done
```

**Example 2.** I've been working with simple models of circuits as Boolean constants,
but we could use signals and wires, writing something like:

```isabelle
type_synonym time = nat
type_synonym voltage = bool
type_synonym wire = "time ⇒ voltage"

definition Low :: ‹voltage ⇒ bool› where
"Low v = (v = True)"

definition High :: ‹voltage ⇒ bool› where
"High v = (v = False)"

definition "PTran = (λ(g,a,b). ∀t. ((High (g t) ∧ Low (b t)) ∨ (Low (g t) ∧ (a t = b t))))"

definition "NTran = (λ(g,a,b). ∀t. ((Low (g t) ∧ Low (b t)) ∨ (High (g t) ∧ (a t = b t))))"

definition "Power p ≡ ∀t. High (p t)"

definition "Ground p ≡ ∀t. Low (p t)"

definition Join :: "wire * wire * wire ⇒ bool" where
  "Join ≡ (λ(i1,i2,out). ∀t. ((out t) = max (i1 t) (i2 t)))"
```

**Example 3.** Or if we wanted to measure the actual voltage, we could do something
like:

```isabelle
type_synonym time = nat
type_synonym voltage = nat
type_synonym wire = "time ⇒ voltage"

definition Low :: ‹voltage ⇒ bool› where
"Low v = (v = 0)"

definition High :: ‹voltage ⇒ bool› where
"High v = (¬(v = 0))"

definition "PTran = (λ(g,a,b). ∀t. ((High (g t) ∧ Low (b t)) ∨ (Low (g t) ∧ (a t = b t))))"

definition "NTran = (λ(g,a,b). ∀t. ((Low (g t) ∧ Low (b t)) ∨ (High (g t) ∧ (a t = b t))))"

definition "Power p ≡ ∀t. High (p t)"

definition "Ground p ≡ ∀t. Low (p t)"

definition 
  "Join ≡ (λ(i1,i2,out). ∀t. ((out t) = max (i1 t) (i2 t)))"
```

The definition of `NAND a b out` remains the same in either case, amazingly
enough. Proving that the defining property of NAND is satisfied by this
implementation is much more difficult. One way is simple:

```isabelle
lemma NAND_impl_implies_spec: "NAND a b out -->
    (∀t. (High (out t) = (¬(High (a t) ∧ High (b t)))))"
  apply (simp add: NAND_def PTran_def NTran_def Ground_def Power_def Join_def)
  by (metis High_def Low_def max_nat.eq_neutr_iff)
```

The other way is nontrivial, and requires some clever lemmas.

But the illustration is clear: we compose these implementations together
to get larger and larger units. This would allow us to model the
entire CPU's implementation, and we could prove that it satisfies some
specification. 

# Combinational Circuits

We can take advantage, for combinational circuits only, of the fact that
a logical relation `L[in_1, ..., in_N, out]` describes a function if for
each different `in_1`, ..., `in_N` there exists a unique value
`out`. Combinational circuits (like NAND gates, half-adders, full
adders, all the way up to the ALU) satisfy this property.

We could therefore describe combinational circuits using functions in
HOL (and I did this!), rather than using logical relations. However,
this fails to carry over for sequential circuits (like RAM, CPU
registers, etc.). For sequential circuits, we must fall back on relying
upon the usual strategy modeling them as logical relations.

**Puzzle 1.** Can we formalize a floating-point unit using Isabelle/HOL
in a clear, pedagogically satisfying manner? Can we make it adhere to
the IEEE-754 standard? Can we _prove_ it adheres to the IEEE-754
Standard?
(End of Puzzle 1)

# References

- Mike Gordon,
  "Hardware verification by formal proof".
  Tech Report 74, published August 1985; 6 pages. [Eprint](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-74.html).
- Mike Gordon,
  "Why higher-order logic is a good formalisation for specifying and verifying hardware".
  Tech Report 77, published September 1985; 28 pages. [Eprint](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-77.html).
- Albert Camilleri, Mike Gordon, Tom Melham,
  "Hardware verification using higher-order logic".
  Tech Report 91, published September 1986; 25 pages.
  [Eprint](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-91.html).
- Mike Gordon's [Specification and Verification 2](https://www.cl.cam.ac.uk/archive/mjcg/Lectures/SpecVer2/SpecVer2.html)
  
## For ARM6
  
Anthony Fox describes his work doing this for ARM 6 in a series of
Technical Reports:

- Anthony Fox,
  "An Algebraic Framework for Modelling and Verifying Microprocessors
  using HOL".
  [UCAM-CL-TR-512](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-512.pdf),
  2001
- Anthony Fox,
  "A HOL specification of the ARM instruction set architecture".
  [UCAM-CL-TR-545](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-545), 2001
- Anthony Fox,
  "Formal verification of the ARM6 micro-architecture".
  [UCAM-CL-TR-548](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-548.pdf), 2002

This approach allows us to formulate statements about sequential logic
gates, since we'd just relate the output of the gate as `out(t + 1)` and
relate it to the output from the previous time step `out t` as well as
the other inputs at time `t`.