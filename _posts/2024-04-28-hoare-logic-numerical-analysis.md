---
layout: post
title: Hoare Logic for Numerical Analysis
published: true
use_math: true
draft: true
quote: "Surely, we compute only when everything else fails, when mathematical theory cannot deliver an answer in a comprehensive, pristine form and thus we are compelled to throw a problem onto a number-crunching computer and produce boring numbers by boring calculations. This, I believe, is nonsense."
quoteSource: Arieh Iserles, <i>A First Course in the Numerical Analysis of Differential Equations</i> (2009)
tags: [Numerical Analysis, Hoare Logic]
---

Broadly speaking, design-by-contract implements Hoare logic in an actual
programming language, and I want to consider whether it is plausible to
implement numerical analysis code using design-by-contract techniques.

# Case Study: Squareroot

I will be using C for my programming language and
[ACSL](https://frama-c.com/html/acsl.html) for my assertion
language. The toy problem we will study will be the square root of a
number, computing $\sqrt{x}$ for $x\in\mathbb{R}$ non-negative $x\geq0$.

We can use Newton's method (a.k.a., the Babylonian method). If we know
that $x_{0}^{2}\leq x\leq (x_{0}+1)^{2}$, then $x_{0}$ is our initial
guess for the squareroot. Then we compute
$(x_{0}+\varepsilon)^{2}\approx x_{0}^{2}+2x_{0}\varepsilon=x$, which we
can solve for $\varepsilon=(x-x_{0}^{2})/(2x_{0})$ and this gives us
$x_{1}=x_{0}+\varepsilon=(x+x_{0}^{2})/(2x_{0})$ (the next iteration). This gives us a sequence
of real numbers $x_{0}$, $x_{1}$, $x_{2}$, ..., which converges to
$\sqrt{x}$.

We can use the
[`frexp`](https://pubs.opengroup.org/onlinepubs/009696899/functions/frexp.html)
function 
to extract the exponent of `x=m2^{n}` where $1\leq m<2$ and
$n\in\mathbb{Z}$ then use this to approximate $x_{0}=2^{\lfloor n/2\rfloor}$ 
(or if $n$ is odd $x_{0}=2^{\lfloor n/2\rfloor}\sqrt{2}$ with $\sqrt{2}\approx1.4142135623730950488016887242096980785696$
precomputed and stored as a constant)
to get the correct order-of-magnitude estimate for the squareroot. The
contract for `frexp` may be given as:

``` c
/*@
    requires \is_finite(x) && \valid(exp);
    ensures \is_finite(\result);
    ensures 0.5 <= \result < 1.0;
    ensures x == \round_double(\NearestEven, \result * \pow(2, exp));
    assigns \result, *exp \from x;
*/
double frexp(double x, int *exp);
```

We could have used the [`ldexp`](https://pubs.opengroup.org/onlinepubs/009696899/functions/ldexp.html) function to specify how to relate the
constituent parts returned by `frexp` to the given double `x`.
Instead, we just used the ACSL built-in `\pow(a, b)` to give us $a^{b}$
as an exact real number.

We can write up the code for the Babylonian method, taking advantage of
the fact that we need only $\log_{2}(b)$ steps to get $b$
bits of accuracy (and double precision floats have $b=53\approx64=2^{6}$).

``` c
/*@
    requires \isfinite(x);
    requires x >= 0.0;
*/
double sqrt_attempt(double x) {
    int exp = 0;
    const int MAX_ITER = 8;
    double mantissa = frexp(x, &exp);
    /*@assert x == \round_double(\NearestEven, mantissa * \pow(2, exp)); */
    double sqrt = 1.0;
    if (1 == exp % 2) {
        sqrt = 1.4142135623730950488016887242096980785696;
    }
    double TOLERANCE = ldexp(x, -53);
    /*@assert TOLERANCE = \round_double(\NearestEven, x * \pow(2,-53)); */

    sqrt = ldexp(sqrt, exp/2); // initial guess
    /*@ ghost double xs[MAX_ITER + 1];
                     xs[0] = sqrt; */
    /*@assert sqrt*sqrt <= x & x < \pow(2, exp+1); */
    for (int n=0; n < MAX_ITER; n++) {
        if (fabs((sqrt*sqrt) - x) < TOLERANCE) break;
        /*@ ghost xs[n+1] = 0.5*((x/xs[n]) + xs[n]); */
        sqrt = 0.5*((x/sqrt) + sqrt);
        /*@ assert sqrt == xs[n+1]; */
    }
    /* Assert somehow that xs is first MAX_ITER + 1 terms of Newton's method,
       and therefore must converge to sqrt(x), so given the initial guess
       of xs[0], the error must be within [error tolerance range].
    */
    return sqrt;
}
```

Note that $x_{n+1}=(x+x_{n}^{2})/(2x_{n})$ but also that
$x_{n+1}=((x/x_{n})+x_{n})/2$. These produce distinct (but related)
numerical methods. For example, division by 2 (or multiplying by `0.5`)
may be done exactly in floating-point arithmetic. If we denote by
$\mathtt{fl}(x)$ the floating-point number for $x$ rounded to nearest
with ties towards even, then we can use the standard model
of floating-point gives us different truncation errors for these terms:

1. $\mathtt{fl}((x+x_{n}^{2})/(2x_{n}))\approx ((x+x_{n}^{2})/(2x_{n}))(1+\varepsilon)^{3}$
  - $\mathtt{fl}(x_{n}^{2})=x_{n}^{2}(1+\varepsilon_{1})$
  - $\mathtt{fl}(x+x_{n}^{2}(1+\varepsilon_{1}))=(x+x_{n}^{2}(1+\varepsilon_{1}))(1+\varepsilon_{2})$
  - $\mathtt{fl}((x+x_{n}^{2}(1+\varepsilon_{1}))(1+\varepsilon_{2})/(2x_{n}))=((x+x_{n}^{2}(1+\varepsilon_{1}))/(2x_{n}))(1+\varepsilon_{2})(1-\varepsilon_{3})$
2. $\mathtt{fl}(((x/x_{n})+x_{n})/2)\approx\frac{1}{2}((x/x_{n})+x_{n})(1+\varepsilon)^{2}$
   - $\mathtt{fl}(x/x_{n})=(x/x_{n})(1-\varepsilon_{1})$
   - $\mathtt{fl}((x/x_{n})(1-\varepsilon_{1})+x_{n})=((x/x_{n})(1-\varepsilon_{1})+x_{n})(1+\varepsilon_{2})$
   - division by two is exact, so it doesn't affect the relative
     truncation error.

In general, fewer truncation errors are preferable.

We can improve performance by:
1. Moving the `ldexp(...)` function call to the penultimate step of the
   function, so we compute the squareroot of the mantissa.
2. Using the initial guess based on the Taylor series expansion for
   $\sqrt{\frac{1}{2}+x}\approx(1 + x - x^{2}/2)/\sqrt{2}$, which would
   have an absolute error of approximately 0.05.

Let's refactor out this logic into its own subroutine for determining
the initial guess for the squareroot of $x$:

```c
/*@
  requires 0.5 <= mantissa && mantissa < 1;
  ensures fabs(\result*\result - mantissa) < 0.05;
 */
static double sqrt_init_guess(double mantissa) {
    double x = mantissa - 0.5;
    double invSqrt2 = 0.707106781186547524400844362104849039;
    /* @ghost double QuadraticTaylorPolynomialApproximation(double y) {
       return invSqrt2*(1 + y*(1 - 0.5*y));
       }
    */
    /* @fact [?] exists xi st 0 <= xi < 0.5
       && TaylorPolynomial(sqrt(0.5 + x), x, 0, 3)
          == QuadraticTaylorPolynomialApproximation(x) + xi*xi*xi/(2*sqrt(2))
       && xi*xi*xi/(2*sqrt(2)) <= pow(0.5,4)/sqrt(2) < 0.442;
    */
    /* @assert \result == QuadraticTaylorPolynomialApproximation(x); */
    return invSqrt2*(1 + x*(1 - 0.5*x));
}
```

**Exercise:** Can we use the linear approximation to the squareroot
instead of the quadratic approximation? Would this cost us an extra
iteration of Newton's method? (End of exercise)

We can then rewrite the squareroot algorithm to be:

```c
/*@
    requires \isfinite(x);
    requires x >= 0.0;
    ensures \abs(\result - \sqrt(x)) <= \sqrt(x)*\pow(2,-53);
*/
double sqrt(double x) {
    int exp = 0;
    const int MAX_ITER = 8;
    double mantissa = frexp(x, &exp);
    /*@assert 0.5 <= mantissa && mantissa < 1; */
    /*@assert x == \round_double(\NearestEven, mantissa * \pow(2, exp)); */
    double sqrt_m = sqrt_init_guess(mantissa);
    /*@assert \abs(sqrt_m*sqrt_m - mantissa) < 0.05; */
    sqrt_m = sqrt_iter(mantissa, sqrt_m); // refactor out the iterative loop to
                                          // its own function
    /*@assert \abs(sqrt_m - \sqrt(mantissa)) < \pow(2,-53); */
    double sqrt = 1.0;
    if (1 == exp % 2) {
        sqrt = 1.4142135623730950488016887242096980785696;
        /*@assert \abs(sqrt - \sqrt(2)) <= \sqrt(2)*\pow(2,-53); */
    }
    /*@assert \abs(\result - \sqrt(x)) <= \sqrt(x)*\pow(2,-53);
    return ldexp(sqrt*sqrt_m, exp/2);
}
```

**Exercise:** When we have $x=m2^{2e+1}$ we compute `sqrt_m` to
approximate $\sqrt{m}$ and store $\sqrt{2}$ as the initial value of
`sqrt`, then compute `sqrt*sqrt_m` as the mantissa for the
solution. What are the error bounds for the result? [Hint: use triangle inequality.]
If it is less than desired precision, how can we recover the desired precision? (End of exercise)

The iterative loop is then its own function, which we can write as:

```c
/*@
  requires \abs(init_guess*init_guess - x) < 0.05
  requires 0.5 <= x && x < 1;
  requires 0.5*sqrt(2) <= init_guess && init_guess < 1;
  ensures \abs(\result - \sqrt(x)) < \pow(2,-53);
*/
static double sqrt_iter(double init_guess, double x) {
    int MAX_ITER = 3;
    /*@ghost double s[MAX_ITER + 1];
             real error[MAX_ITER + 1];*/
    /*@assert \abs(init_guess/\sqrt(x) - 1) < 0.05/\sqrt(x) < 0.025*\sqrt(2); */
    /*@assert \abs(init_guess/\sqrt(x) - 1) < \pow(2,-4); */
    double sqrt_m = 0.5*((x/init_guess) + init_guess);
    /*@ghost s[0] = 0.5*((x/init_guess) + init_guess);
             error[0] = s[0]/\sqrt(x) - 1; */
    /*@assert 0 <= error[0] && error[0] < \pow(\pow(2,-4), 2)/2; */
    /*@assert error[0] < \pow(2,-9); */
    /*@assert 0.5*sqrt(2) <= sqrt_m && sqrt_m < 1; */
    int i;
    for(i = 0; i < MAX_ITER; i++) {
         /*@ghost s[i+1] = 0.5*((x/s[i]) + s[i]); 
                  error[i+1] = s[i+1]/\sqrt(x) - 1; */
         /*@assert error[i+1] == error[i]*error[i]/(2*(1 + error[i])); */
         /*@assert error[i+1] <= error[i]*error[i]/2; */
         /*@assert error[i+1] < \pow(2, 1-5*\pow(2, i+1)); */
         sqrt_m = 0.5*((x/sqrt_m) + sqrt_m);
         /*@assert \exists real eps;
                       \abs(eps) < \pow(2, -53)
                       && sqrt_m == s[i+1]*(1 + i*eps); */
         /*@assert \abs(sqrt_m - \sqrt(x)) <= error[i+1]*\sqrt(x); */
         /*@assert \abs(sqrt_m - \sqrt(x)) < error[i+1]; */
    }
    /*@assert \abs(error[i+1]) < \pow(2, 1-5*\pow(2, i+1)); */
    /*@assert \abs(sqrt_m - \sqrt(x)) < \pow(2, -64); */
    return sqrt_m;
}
```

# Concluding Remarks

Alright, so this...actually works adequately as pidgin code. I'm not
certain the Frama-C tool will accept this input, but it communicates the
expectations at each step of the calculation.

However, this particular case study (calculating the squareroot of a
non-negative real number) is a rather simple task in numerical analysis.
We just wanted to consider a small "proof of concept" to see if Hoare
logic could ostensibly express the "mathematical state" to guarantee
correctness of the implementation.

**Puzzle:** Can we use Hoare logic to prove the correctness of numerical
linear algebra implementations? What about numerical differential
equations?
(End of Puzzle)

The difficulty with numerical linear algebra is that we would need to
use separation logic, since we are working with arrays allocated on the
heap, and we mutate them quite readily. Numerical partial differential
equations is even harder, since the proof assistant needs to know quite
a bit of analysis.

**Exercise:** Use [separation
logic](https://en.wikipedia.org/wiki/Separation_logic) or ACSL to prove
the correctness for some implementations of the [BLAS](https://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms)
routines. (End of exercise)

Perhaps someone has worked on this silently over the years, I could not
find anything in the literature. If you are aware of anyone who has
formalized Numerical Linear Algebra using separation logic, then please
email me with the details!