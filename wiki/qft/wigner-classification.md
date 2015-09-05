---
layout: wiki
title: Wigner Classification
published: true
date: 2015-08-29
---

This is a long-ish post (apologies), but it consists of several
steps. We're working in the mostly-pluses metric signature. So what's
the roadmap?

Basically, a particle in quantum field theory is a unitary irreducible
representation of the Poincare group, characterized by a half-integer
spin $j$ and a non-negative real number "mass" $m\geq0$. How will we see this?

First, we examine the irreducible representations of the "infinitesimal"
proper, orthochronous Lorentz group, and find in 3+1 dimensions it is
isomorphic (as a Lie algebra) to two copies of su(2). This lets us
classify the "species" of particles by spin.

Next, we look at the Poincare symmetries (i.e., Lorentz boosts plus
spacetime translations). We find its unitary irreducible representations
are parametrized by half-integer "spin" and non-negative mass-squared.

## Lie Algebras

### Lorentz Algebra

We only care about proper orthochronous Lorentz transformations, i.e.,
the subgroup $\Lambda\in\mathrm{ISO}(1,3)\subset\mathrm{O}(1,3)$ such
that $\det(\Lambda)=+1$ and ${\Lambda^{0}}\_{0}=+1$. We can write any
element of this group as
\begin{equation}
{\Lambda^{\mu}}\_{\nu} = {\exp\left(\frac{-\mathrm{i}}{2}\omega\_{\kappa\lambda}M^{\kappa\lambda}\right)^{\mu}}\_{\nu}
\end{equation}
where $\omega\_{\kappa\lambda}=-\omega\_{\lambda\kappa}$ are "rotation
angles" (real constants parametrizing the symmetry). The indices *are
not* spacetime indices, but refer to the Lorentz symmetry, and
$M^{\kappa\lambda}$ is an indexed family of matrices (fix a value of
$\kappa$ and $\lambda$, and you get a 4-by-4 matrix). Specifically, we
have
\begin{equation}
(M^{\kappa\lambda})\_{\mu\nu} = \mathrm{i}(\delta^{\kappa}\_{\mu}\delta^{\lambda}\_{\nu}-\delta^{\kappa}\_{\nu}\delta^{\lambda}\_{\mu})
\end{equation}
which satisfy the Lorentz algebra's commutator relationship:
\begin{equation}
[M^{\kappa\lambda},M^{\rho\sigma}]=\mathrm{i}(\eta^{\lambda\rho}M^{\kappa\sigma}
-\eta^{\kappa\rho}M^{\lambda\sigma}-\eta^{\lambda\sigma}M^{\kappa\rho}+\eta^{\kappa\sigma}M^{\lambda\rho}).
\end{equation}

**Remark 1.**
We can work with
$M^{[\kappa\lambda]}=(M^{\kappa\lambda}-M^{\lambda\kappa})/2$ instead
of $M^{\kappa\lambda}$, since the $\omega\_{\kappa\lambda}$ parameters
form an antisymmetric matrix. We denote the antisymmetric matrix
obtained from $M$ by $\widetilde{M}$.

**Remark 2.**
We're interested in *representations* of a Lie algebra, which typically
examines a Lie algebra morphism from our particular algebra to
endomorphisms on a vector space. Lets consider a few we'll be working with.

**Example 1.**
The representation with $\widetilde{M}=0$ is the trivial representation.

**Example 2.**
If we consider the Dirac Gamma matrices
$\\{\gamma^{\mu},\gamma^{\nu}\\}^{\alpha}\_{\beta}=2\eta^{\mu\nu}\delta^{\alpha}\_{\beta}$,
then the Dirac representation is given by
\begin{equation}
\widetilde{M}^{\kappa\lambda}=\gamma^{\kappa\lambda}=\frac{\mathrm{i}}{4}[\gamma^{\kappa},\gamma^{\lambda}].
\end{equation}

### Isomorphic to two copies of su(2)

We rewrite the generators in a non-covariant basis. (This will make
classifying all the irreducible representations easier.) The generators
of the Lorentz algebra are
\begin{equation}
L^{i} = \frac{1}{2}\epsilon^{ijk}M\_{jk}
\end{equation}
for spatial rotations, and 
\begin{equation}
K^{i} = M^{0i}
\end{equation}
for Lorentz boosts. We define
\begin{equation}
\vec{J}\_{\pm} = \frac{1}{2}(\vec{L}\pm\mathrm{i}\vec{K}).
\end{equation}
We see the commutation relations become
\begin{equation}
[J^{i}\_{\pm}, J^{j}\_{\pm}] = \mathrm{i}\epsilon^{ijk}J^{k}\_{\pm}
\end{equation}
and all others vanish. But look, this is 2 copies of the Lie algebra
su(2). (More precisely, it is sl(2, **C**).)

The punchline, however, is:

> Each irreducible representation of so(1, 3) is characterized by a pair
> of half-integers $(j\_{+}, j\_{-})$.

We have a table of common "families" for particles (in most QFT
textbooks, they focus on particles of spin 1 or less...because they're
renormalizable): 

| $(j\_{+}, j\_{-})$ | Name of Field                       | Dimension of Rep |
|--------------------|-------------------------------------|------------------|
| (0, 0)             | Scalar                              | 1                |
| (1/2, 0)           | Left-handed Weyl Spinor             | 2                |
| (0, 1/2)           | Right-handed Weyl Spinor            | 2                |
| (1, 0)             | (Imaginary) Self-dual 2-form        | 3                |
| (0, 1)             | (Imaginary) Anti-self-dual 2-form   | 3                |
| (1/2, 1/2)         | Vector (gauge field)                | 4                |
| (1/2, 1)           | Left-Handed Rarita-Schwinger field  | 6                |
| (1, 1/2)           | Right-Handed Rarita-Schwinger field | 6                |
| (1, 1)             | Graviton (spin-2 field)             | 9                |


### Poincare Algebra

Lets consider Lorentz transformations *plus* spacetime translations,
i.e., the Poincare group. The algebra changes by adding a generator
$P^{\mu}$ for spacetime translations. We find additional commutator
relations
\begin{equation}
[M^{\kappa\lambda}, P^{\mu}]=
\mathrm{i}(\eta^{\kappa\mu}P^{\lambda}-\eta^{\mu\lambda}P^{\kappa})
\end{equation}
and
\begin{equation}
[P^{\mu}, P^{\nu}]=0.
\end{equation}

**Definition** (Wigner)**.**
A **"Particle"** is a positive-energy unitary irreducible representation
of the Poincare algebra.
(End of definition)

**Remark.**
Recall for spacetime translations, $P^{\mu}$ is the energy-momentum
four-operator. So $P^{0}$ is the energy. The positive energy condition
merely restricts the spectrum of $P^{0}$ to be entirely positive.
(End of Remark)

**Definition.**
The **"Pauli-Lubanski Vector"** is an element of the Poincare algebra
defined by
\begin{equation}
W\_{\mu} = \frac{-1}{2}\epsilon\_{\mu\nu\kappa\lambda}M^{\nu\kappa}P^{\lambda}
\end{equation}
where $\epsilon\_{0123}=-1$.
(End of Definition)

**Exercise 1.**
Work out $[W\_{\mu}, P^{\nu}]$, $[W\_{\mu}, M^{\kappa\lambda}]$, $[W\_{\mu}, W\_{\nu}]$.

**Exercise 2.**
Prove or find a counter-example: $W^{\mu}W\_{\mu}$ commutes with all
elements of the Poincare algebra. (Hint: work out the commutation
relations with the generators of the algebra.)

**Proposition.**
The operators $C\_{1}:=-P^{\mu}P\_{\mu}$ and $C\_{2}:=W^{\mu}W\_{\mu}$
are Casimir operators for the Poincare algebra, i.e., they commute with
all the generators.
(End of Proposition)

The eigenvalues of the Casimir operator characterize a particle. The
eigenvalue $m^{2}$ of $C\_{1}$ is called the mass-squared.

# References

- Ritger Boels and Felix Brümmer,
  "Introduction to Supersymmetry and Supergravity, or Supersymmetry in
  12954 minutes". Lecture notes for DESY course, Winter term 2012-2013,
  [pdf](http://www.desy.de/~fbruemme/SUSY/SUSY.pdf)
- Norbert Straumann,
  "Unitary Representations of the inhomogeneous Lorentz Group and their Significance in Quantum Physics".
  [arXiv:0809.4942](http://arxiv.org/abs/0809.4942), 20 pages.
- Steven Weinberg, *Quantum Theory of Fields*. Volume I, chapter 2.
