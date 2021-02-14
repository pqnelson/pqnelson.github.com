---
layout: wiki
title: Supergravity has no Purely Bosonic Solutions
published: true
date: 2015-08-01
parentURL: /wiki/sugra/
---
What this means is, in a sense, pure quantum general relativity
*cannot* arise as a limit from quantum super gravity.

**Theorem** (Pure Bosonic States Cannot Exist).
*Suppose we have a bosonic state $\Psi[e^{AA'}\_{a}]$, and suppose it is
Lorentz invariant. Then it cannot describe a physical state for $N=1$
supergravity.*

So, before we begin the proof, we recall that canonical $N=1$
supergravity has constraints for the supersymmetry. One of them we will
use, namely

\begin{equation}
\bar{S}\_{A'} = \epsilon^{abc}e\_{AA'a}\mathcal{D}\_{b}\psi^{A}\_{c} +
4\pi G\_{N}\hbar\psi^{A}\_{a}\frac{\delta}{\delta e^{AA'}\_{a}}
\end{equation}

where $\mathcal{D}\_{b}$ is the torsion-free covariant derivative.

Why not the other constraint for SUSY? Because it's of the form

\begin{equation}
S\_{A}\sim\mathcal{D}\_{j}\frac{\delta}{\delta\psi\_{jA}} + \frac{\delta}{\delta\psi_{jB}}(\mbox{some mess})^{ABj}.
\end{equation}

Observe for a purely bosonic solution, the functional derivatives with
respect to the gravitino variable will kill the wave functional
automatically. So it's trivially satisfied.

*Proof (Scaling Argument).*
We consider
\begin{equation}
I = \int\bar{\epsilon}(\vec{x})\left(\frac{1}{\Psi[e]}\bar{S}^{A'}\Psi[e]\right)\,\mathrm{d}^{3}x
\end{equation}
for an arbitrary continuous spinor test function
$\bar{\epsilon}(\vec{x})$. Observe the first term in $\bar{S}^{A'}$ acts
as a "constant", so we end up with
\begin{equation}
\frac{1}{\Psi[e]}\bar{S}^{A'}\Psi[e] = \epsilon^{abc}e\_{AA'a}\mathcal{D}\_{b}\psi^{A}\_{c} +
4\pi G\_{N}\hbar\psi^{A}\_{a}\frac{\delta\ln\Psi[e]}{\delta e^{AA'}\_{a}}.
\end{equation}
We replace $\bar{\epsilon}(\vec{x})$ with
$\bar{\epsilon}(\vec{x})\exp(-\phi(\vec{x}))$, and similarly
$\psi^{A}\_{a}(x)$ with $\psi^{A}\_{a}(x)\exp(\phi(\vec{x}))$. This
changes the integral to $I\to I+\Delta I$, where
\begin{equation}
\Delta I = -\int\epsilon^{abc}e\_{AA'a}\bar{\epsilon}^{A'}\psi^{A}\_{c}\partial_{b}\phi\,\mathrm{d}^{3}x.
\end{equation}
Observe $\Delta I$ is independent of the wave functional $\Psi[e]$. We
need $\Delta I$ to vanish, otherwise the constraint $\bar{S}^{A'}$
won't. But we can pick arbitrary $\bar{\epsilon}$, $\psi$, $\phi$,
such that $\Delta I\neq0$. This would imply $\bar{S}^{A'}\Psi[e]$ would
depend on $\psi^{A}\_{a}$, i.e., $\Psi[e]$ could not be purely bosonic.
(End of Proof)


*Remark 1.*
We did not use the hypothesis of Lorentz invariance for $\Psi[e]$. Is it
necessary, or can we drop it?

*Remark 2* ($N>1$?).
Observe we did not explicitly use the $N=1$ property anywhere in the
proof. Could this be generalized to other $N$? (Open research problem)

*Remark 3* (Scaling Argument Strategy).
The basic proof was to show a constraint $\hat{C}\Psi=0$ has its
integral $I=\int f(\vec{x})\hat{C}\Psi\,\mathrm{d}^{3}x$ vanish everywhere. Then
scaling some of the non-physical parameters in such a manner as to leave
the physics the same, we found $I\to I'\neq I$ --- a contradiction!

*Remark 4* ("Method of Characteristics" Proof Sketch).
We could have equally considered an infinitesimal $\bar{S}$
supersymmetry transformation $e^{A}\_{a}\to e^{A}\_{a}+\delta e^{A}\_{a}$
which leaves $\psi$ unchanged. Then we expand
$\Psi[e+\delta e,\psi]=\Psi[e]+\delta\Psi$.
But we may scale $\psi$ and $\bar{\epsilon}$ again, which leaves $\delta e$
invariant, and thus produces (in general) a different $\delta\Psi$. (We
interpret this as telling us $\Psi$ is not independent of $\psi$ in the
full configuration space of the theory.) This disputes the "method of
characteristics" D'Eath performed [3], namely that
D'Eath did not perform a complete analysis.

**References.**

1. Sean M. Carroll, Daniel Z. Freedman, Miguel E. Ortiz and Don N. Page,
   "Physical states in canonically quantized supergravity''.
   *Nucl. Phys. B* **423** (1994) 661--687.
   Eprint [arXiv:hep-th/9401155](http://arxiv.org/abs/hep-th/9401155)
2. Sean M. Carroll, Daniel Z. Freedman, Miguel E. Ortiz and Don N. Page,
   "Bosonic physical states in $N=1$ supergravity?"
   Eprint [arXiv:gr-qc/9410005](http://arxiv.org/abs/gr-qc/9410005).
3. Peter D. D'Eath,
   "Physical states in $N=1$ supergravity''.
   *Phys. Lett. B* **321** (1994) 368--371,
   [arXiv:hep-th/9304084](http://arxiv.org/abs/hep-th/9304084).
4. Claus Kiefer,
   *Quantum Gravity*. Third ed., Oxford Press (2012).
   See the end of section 5.3.6.
5. Paulo V. Moniz,
   *Quantum Cosmology: The Supersymmetric Perspective*.
   Volumes 1 and 2. Lecture notes in physics, vol 804. Springer, Berlin (2010)
   doi:10.1007/978-3-642-11575-2 and doi:10.1007/978-3-642-11570-7.
