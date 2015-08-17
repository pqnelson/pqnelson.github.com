---
layout: post
title: Bernoulli Batters, Markov Coaches — Modeling Games by Plays
published: true
quote: "Ninety percent of this game is half-mental."
quoteSource: Yogi Berra, <i>What Time Is It? You Mean Now?</i> (2003)
tags: [baseball, stats]
---

**Abstract.** We review probability distributions related to discrete
"success-or-fail" trials ("coin flips"), and show how it applies to an
individual batter's plate appearance. We briefly discuss how to improve
approximating probabilities for a batter's success. Finally we introduce
Markov models, which lets us model games and make predictions.

**Contents**

- [Introduction](#introduction)
- [Mathematics First: Bernoulli and Geometric Distributions](bernoulli-and-geometric-distributions)
- [First Model: Ignore the Pither](#first-model)
  - [Scoring a Run](#scoring-a-run)
  - [Inadequacies of Ignorance](#inadequacies-of-ignorance)
- [Improving the Probability by Including the Pitcher](#include-pitcher)
  - [Basic Example](#basic-example)
- [Markov Model](#markov-model)
  - [Basic Structure of Transition Matrix](#basic-structure-of-transition-matrix)
  - [Expected Number of Runs](#expected-number-of-runs)
     - [Simplified Version](#simplified-version)
     - [Complicated Version](#complicated-version)
- [Predictions](#predictions)
  - [Angels vs Rangers](#laa-vs-txr)
  - [Oakland A's vs Mariners](#oak-vs-sea)
  - [Dodgers vs Mets](#lad-vs-met)
- [Conclusion](#conclusion)

<a name="introduction"></a>
# Introduction

We will model baseball as a series of interactions between batters and
pitchers. The batter will either hit the ball or strike out, just as a
flipping a coin results in either heads or tails. A game boils down to a
series of coin flips.

We will iteratively refine the model in question, starting with
something comically simple. But we can get arbitrarily complex, taking
into factors like the batter's age and abilities. Eventually, we will
produce a model simulating games—this is the so-called "Markov Chain"
model.

Again, we assume familiarity with probability theory at the level of my
[notes]({{ site.url }}/assets/probability.pdf).
The code related to this post can be found on [github](https://github.com/pqnelson/gambletron)
(checkout version `v0.2.0`).

<a name="bernoulli-and-geometric-distributions"></a>
# Mathematics First: Bernoulli and Geometric Distributions

##### Puzzle 1.
Given a coin which lands on heads with probability *p*, what
is it expected to land on? What is its variance (standard deviation
squared)?

*Solution.*
Well, lets denote the outcome of 1 for landing on heads, and 0 for
tails. Then the expected result of flipping a coin would be $p(1) +
(1-p)0 = p$. Does this look odd? Well, if *p* were small, meaning the
coin is loaded to always land tails most of the time, then we should
expect the outcome to be tails (i.e., closer to zero). If *p* were
large, then the expected outcome should be close to one (i.e., more
likely heads). So the expected outcome should be directly proportional
to *p*.

For the variance, there are two clever ways to compute it. One is to
consider the expected value of the outcome-squared minus the square of
the expected outcome: $v(X) = E(X^{2})-E(X)^{2}$. For the coin,
$E(X^2)=E(X)$, so we get the variance be $p-p^{2}=p(1-p)$. This is one
valid proof.

The other is to consider $E[(X-E(X))^2]$ where I use square brackets for
syntactic clarity. We know the expected outcome of a coin flip
$E(X)=p$, so we have $E[(X-E(X))^2]=E[(X-p)^2]$. The computation boils
down to similar considerations as before.
(End of Puzzle)

**Definition.**
The probability described by flipping a biased coin is called a
**"Bernoulli Distribution"**.
(End of Definition)

##### Puzzle 2.
Consider a coin that will be heads with probability *p*, and tails with
probability 1 - *p*. What's the probability of getting exactly 3 heads
in 5 flips? Equivalently, this is the probability of flipping exactly 2
tails in 5 flips.

**Notation.**
We write a string to indicate the "history" of the coin flips, read from
left to right. So "HT" is "First I got a heads, then I got a tails". The
history "THT" is "First a tails, then a heads, then a tails".
(End of Notation)

*Solution.*
We can draw a
[probability tree](https://www.mathsisfun.com/data/probability-tree-diagrams.html),
then find the paths describing the desired states. But that's hard to do
in HTML, so I will leave it for the reader! 

We can also use a combinatorial identity, since each flip is independent
of each other. We are considering permutations of the string "HHHTT",
since these are all the possible ways to get exactly 3 heads out of 5
flips. How many ways can we permute this? We can
[recall](https://en.wikipedia.org/wiki/Binomial_coefficient) the number
of ways to choose *k* items from *n* possibilities is the binomial
coefficient. The permutations of "HHHTT" are precisely choosing 3 heads
of 5 flips, or "5-choose-3".

We then have to note each permutation has the same probability, since
each flip is independent. The probability we flip HTHTH is the same as
HHHTT: $p^{3}(1-p)^{2}$ (the cube of the probability of heads, times the
square of the probability for tails). Combining it all together, the
probability of 3 heads given 5 flips is precisely

$$P(\mbox{3 heads}|\mbox{5 flips}) = {5\choose3}p^{3}(1-p)^{2} = 10p^{3}(1-p)^{2}.$$

This is the solution we sought. (End of puzzle)

**Definition.**
The probability described by flipping a varying number of *k* heads out
of a fixed number of *n* flips with the probability *p* of getting a
heads is the **"Binomial Distribution"**. Observe when *n* = 1, we
recover the Bernoulli distribution.

##### Puzzle 3.
If our loaded coin has probability *p* of landing on heads, how many
times do we have to flip before we get a heads?

*Solution.*
We have some self-similarity here, because each trial (coin flip) is
independent of each other. So the first flip is either a heads (and
we're done), or a tails (and we need to keep going). Generating the list
of outcomes, we have H, TH, TTH, TTTH, TTTTH, etc. The probability of
heads on the k-th flip would be

$$ P(k) = (1-p)^{k-1}p.$$

The expected outcome would be

$$ E(H) = \sum_{k=0} kP(k) = \sum_{k=1}k\cdot(1-p)^{k-1}p. $$

If we remember our calculus, this looks like the derivative of a
geometric series. This tells us

$$ E(H) = -p\frac{\mathrm{d}}{\mathrm{d}p}\frac{1}{1-(1-p)} = \frac{1}{p}. $$

The smaller the probability of getting a heads *p*, the longer it will
take. This makes intuitive sense, and concludes the puzzle.
(End of Puzzle)

**Definition.**
The probability described by flipping a biased coin until we succeed is
the **"Geometric Distribution"**.

##### Puzzle 4: Coupon Collector's Problem.
Wheaties has a sport's card in their cereal box. If there are *n*
different sports cards, how long will it take to collect all of them?

*Sketch of Solution.*
We need to rephrase the problem to take advantage of geometric
distributions. The probability of getting a new coupon given *j* coupons
is $p_{j+1} = (n-j)/n$, which *is* a geometric distribution. We can then
take the sum of the expected number of trials to succeed in getting
*j*=0, ..., *n* coupons.
(End of sketch)

##### Puzzle 5: Expected Number of Flips.
Suppose we flip a coin until we get 3 tails. How many heads should we
expect to flip? Assume the coin is heads with probability *p*.

(This puzzle is important because, well, 3 tails and you're out. We can
model a half-inning using this puzzle!)

*Solution.* We see the probability of flipping *k* heads for this
situation would be
$$
\Pr(k) = {k+3\choose k}p^{k}(1-p)^{3}.
$$
The expected number of heads would simply be
$$
E[H] = \sum\_{k=0}k\Pr(k) = \sum\_{k=0}k{k+3\choose k}p^{k}(1-p)^{3}.
$$
We can note
$$
\sum\_{k=0}k{k+3\choose k}p^{k}(1-p)^{3} = \frac{(1-p)^{3}p}{3!}\frac{\mathrm{d}^{4}}{\mathrm{d}p^{4}}\sum_{k=0}p^{k+3}
$$
where the 3! in the denominator comes from the binomial
coefficients. Using the geometric series, we find 
$$
E[H] = \frac{(1-p)^{3}p}{6}\frac{24}{(1-p)^{5}}=\frac{4p}{(1-p)^{2}}.
$$
If *p* = 0.3, for example, we would expect there to be about 2.44898
heads. (End of Puzzle)

**Definition.**
If we demand there are exactly *k* failures when considering a Bernoulli
trial ("flipping a coin"), while allowing a variable number of
successes, then the resulting probability distribution is called a
"[negative Bernoulli distribution](https://en.wikipedia.org/wiki/Negative_binomial_distribution)".
(End of Definition)

##### Folklore (Everything is a Coin Flip).
In probability, we can consider various different distributions. But
everything boils down to flipping coins at the end of the day. So,
really learn to love flipping coins, because that's all a probability
distribution *is* in some appropriate sense.
(End of Folklore)

<a name="first-model"></a>
# First Model: Ignore the Pitcher

Suppose we wanted to model a half-inning, i.e., the period of an inning
where one team is "at bat". The rules state the team keeps sending
batters to the plate until they receive 3 outs. What does this mean? We
keep performing "trials" until we get "3 failures".

**Lesson: Simplify.**
One lesson we must emphasize for pure mathematicians is *for the first
model, always make it simple.* Why not treat the batter hitting the ball
as a coin flip? Intentionally ignore other factors, and just use some
statistic which approximates "how often the batter hits the ball". We
can successively refine this model.
(End of lesson)

**Simplification:** We suppose the probability for a "trial" to
"succeed" (i.e., for the batter to hit the ball, and get on a base
safely) is independent of the pitcher. We also assume it is independent
of the batter. It depends only on the team. (End of Simplification)

This simplification is *wrong*, but helpful in simplifying a lot of
calculations.

Now, we will suppose the batter succeeds with probability *p*. How can
we approximate *p*? One crude method is
$$ p \approx \frac{(\mbox{Hits})+(\mbox{Walks})}{\mbox{Plate Appearances}}$$
For us, we will perform computations supposing $p=7/20$ (or 0.35).

**Observation.**
From Puzzle 5, we should expect there to be roughly 3.31 successes (well,
exactly 560/169, but who's counting?).
(End of Observation)

<a name="scoring-a-run" />
## Scoring a Run

We make a further approximation, based on Pankin's
[research](http://www.pankin.com/markov/sabr23.htm) from the early '90s,
we have the following aggressive behavior for runners:

- If the batter hits a single (i.e., makes it to first safely), then a
  runner on first will advance to second, and any runners on second or
  third advance home to score runs.
- If the batter hits a double (i.e., advances to second safely), then
  the runner on first advances to third, and any runners on second or
  third advance home to score runs.
- If the batter hits a triple, then runners on the bases score runs and
  the batter stays on third base.
- For a homerun, all runners and the batter score.

We can get arbitrarily technical, but this is good enough for now.

##### Example (Dummy Data).
Lets consider the *fictional* probability for the following events:

| Event             | Probability | Pr(Event &#124; Success) |
|-------------------|-------------|---------------------|
| Walked by Pitcher | 7.8%        | 39/175 = 22.2857%   |
| Hit a Single      | 21.2%       | 106/175 = 60.5714%  |
| Hit a Double      | 3.3%        | 33/250 = 9.42857%   |
| Hit a Triple      | 0.7%        |  7/250 = 2.8%       |
| Homerun           | 2.0%        | 2/25 = 8%           |

**Sanity Check.**
Observe when we add up the probabilities, we find the probabilities sum
to 35% or 7/20, i.e., the probability of success. This is good, because
it means the dummy data is consistent with our assumptions so far. Also
observe, since one of these events *describes* a success, the
conditional probability Pr(Event | Success) = Pr(Event)/Pr(Success).
(End of Sanity Check)

The problem statement now: given 3 successes (that's the expected number
for our model), what's the expected number of runs scored?

Although it sounds simple, this is not quite so. Why? Order matters: two
singles followed by a triple *is not* the same as a triple followed by
two singles. The first case results in 2 runs, the second case produces
a single run.

There are 5<sup>3</sup> = 125 different configurations, producing
different outcomes. The [code](https://gist.github.com/0f2dd93099635802a05e) for producing the expected number of runs
for a given sequence of plays is available online, but we'll produce a
summary table for the case of *n* plays (we want *n* = 3, of course):

| Number of Successful Plays *n* | Expected number of Runs |
|---------------------|-------------------------|
| 0 | 0 |
| 1 | 0.057142857 |
| 2 | 0.2670204 |
| 3 | 1.090936 |
| 4 | 2.090936 |

If this is the case, we would expect the number of runs at the end of
the game to be 9×1.090936 = 9.818424. But 9 runs per game is, well,
astoundingly large! What gives?

The answer is unsurprising: the data we were working with is too
generous. A more accurate table would be (drawing upon the average
values from 2014):


| Event             | Probability | Pr(Event &#124; Success) |
|-------------------|-------------|---------------------|
| Walked by Pitcher | 8.6%        | 86/315 = 27.30159%  |
| Hit a Single      | 15.7%       | 157/315 = 49.84127% |
| Hit a Double      | 4.4%        | 44/315 = 13.968255% |
| Hit a Triple      | 0.5%        | 1/63 = 1.5873071%   |
| Homerun           | 2.3%        | 23/315 = 7.3015876% |

But if we naively plug this into the program, we would get 1.17 runs per
half-inning...still too large! We need to also observe the probability
of success is now 31.5%, which means we'd expect 2.685279 successes per
half-inning (which amounts to 0.87352395 runs per half-inning,
or 7.86 runs per team in one game—still too large, but at least we're
approaching the average number of runs per game).

<a name="inadequacies-of-ignorance" />
## Inadequacies of Ignorance
We made a number of simplifying assumptions for this first model. But
this model demonstrates the basic nuts and bolts of what lays
ahead. Improving prediction amounts to optimizing the computation for
the probability of a play's success, and moreover the probability for
each outcome.

We never took into account anything *unique* about the batter. Put
another way, we assumed each batter was identical on a given team. So what?
The number of hits per game would be the same, in this instance. To get
a more realistic model, we need to modify the probability of success to
vary. Factors we could incorporate may include the
[home advantage](https://en.wikipedia.org/wiki/Home_advantage), the
pitcher's abilities, the individual batter's abilities, etc.

As I said, refining this model amounts to making more accurate estimates
of *p*, the probability of success when the batter's at plate. Just to
stress again, the basic model where we *consider different histories,
the probability & runs scored for a given history, use the expected
number of runs* underpins the entire approach. People call this method
the "Markov Chain" model.

<a name="include-pitcher" /> 
# Improving the Probability by Including the Pitcher

So, our basic model is correct (an inning at least 3 coin flips), but the
probability of success crucially depends on the pitcher. We can use a
variation of the [Log5 model](https://en.wikipedia.org/wiki/Log5) to
determine the probability of success from the characteristics of the
hitter *and* the pitcher. More precisely, we use the [Odds Ratio method](https://en.wikipedia.org/wiki/Odds_ratio),
which—to the best of my knowledge—Dan Levitt [first applied](http://www.baseballthinkfactory.org/btf/scholars/levitt/articles/batter_pitcher_matchup.htm)
to baseball batting. (Of course, Bill James *invented* the Log5 method,
but James applied it to whether a team would win a game.)

<a name="basic-example" />
# Basic Example
I'll borrow the basic examples from
[elsewhere](http://sbs-baseball.com/theory.txt).

**Hitter Statistics.**
Suppose we have a hitter, [Buck Bokai](http://en.memory-alpha.wikia.com/wiki/Buck_Bokai), with the following statistics:

|            |   AB | Hits | 2B  | 3B |  HR | BB  | K   | AVG  |
|------------|------|------|-----|----|-----|-----|-----|------|
| Buck Bokai | 3720 | 1087 | 251 | 48 | 174 | 441 | 631 | .292 |

We have the plate appearances (PA) for Bokai be PA = AB + BB
= 4161. If we wanted to be more precise, we would have included sacrifice
hits (SH + SB) and hit by pitch (HBP)...but these are normally small in
comparison to at bats and balls. We can use these statistics to estimate
the probabilities

| Signal                 | Formula     | Statistic              |
|------------------------|-------------|------------------------|
| Probability of walk    | HBB = BB/PA | 0.10598414             |
| Probability of Single  | H<sub>1</sub> = (Hits - (2B + 3B + HR))/PA | 0.14756069 |
| Probability of Double  | H<sub>2</sub> = 2B/PA | 0.06032204   |
| Probability of Triple  | H<sub>3</sub> = 3B/PA | 0.011535688  |
| Probability of Homerun | H<sub>4</sub> = HR/PA | 0.04181687   |
| Combined Probability   | H<sub>comb</sub>      | 0.36721942   |

The probability of making an out would simply be
1-0.36721942=0.63278055, ignoring rounding errors.

**Pitcher Statistics.**
Now suppose we have a pitcher, [Eddie Newsom](http://en.memory-alpha.wikia.com/wiki/Eddie_Newsom), with the following
statistics:

|              |  [IP](https://en.wikipedia.org/wiki/Innings_pitched)  | Hits | HR | BB | [K](https://en.wikipedia.org/wiki/Strikeout)  |
|--------------|------|------|----|----|----|
| Eddie Nesom |  200 | 210  | 15 | 50 | 80 |

So the pitcher threw 200 innings, which would be roughly 600 batters
faced. We can be *more* precise, computing the batters faced as also
including those on base as determined by the BB and "Hits"
statistic. Then we may compute the probability for the following events

| Signal                 | Formula                 | Statistic   |
|------------------------|-------------------------|-------------|
| Batters Faced          | BF = (IP×3) + Hits + BB | 860         |
| Probability of Homerun | P<sub>4</sub> = HR/BF   | 0.017441861 |
| Probability of hit     | P<sub>h</sub> = H/BF    | 0.23255815  |
| Probability of Walk    | PBB = BB/BF             | 0.058139537 |

We modify the table, to only include a subset of all possible
statistics.

**League Averages.**
We also need to compute the league averages for all the various pitcher
statistics. Using the 2014 team statistics, we find 

| League Average  | Formula                | Statistic   |
|-----------------|------------------------|-------------|
| Batters Faced   | LABF = IPOuts + H + BB |      186456 |
| Walk            | LABB = BB/LABF         | 0.075192004 |
| Hit             | L<sub>h</sub> = H/LABF | 0.22308213  |
| Homerun         | LHR = HR/LABF          | 0.022450337 |

**Remark (Doubles and Triples).**
We should, ideally, expand this table to include the number of doubles
and triples. We can compute this using the number of doubles and triples
from the batting table. With this data, we can approximate the number of
doubles and triples our pitcher (in our case, Eddie Newsom) allowed by
multiplying P<sub>h</sub> by the ratio of L2B/LABF (the total number of
doubles allowed in the league, by the total number of batters faced in
the leage) or L3B/LABF, respectively.
(End of Remark)

**Computing the Probability.**
Now that we have all these statistics assembled, we can compute the
probability the hitter will hit the ball. We multiply the action we're
interested in, say the hitter hitting the ball H<sub>comb</sub>, by the
ratio of the pitcher's corresponding statistic to the league's average:
P<sub>h</sub>/L<sub>h</sub>. This gives us some pseudo-Bayesian prior on
the hitter hitting the ball. We have

$$\Pr(H) = \frac{H\_{\text{comb}}(P\_{h}/L\_{h})}{H\_{\text{comb}}(P\_{h}/L\_{h})+(1-H\_{\text{comb}})(1-P\_{h})/(1-L\_{h})}$$

Or Pr(H)=0.3950259, slightly higher than H<sub>comb</sub>. ("Does this
make sense?" Well, the pitcher is slightly below average, so it stands
to reason the batter would perform slightly better.) Observe the
basic structure of the probability is

$$\Pr(\mbox{event}) = \frac{\begin{pmatrix}\mbox{Percent of times}\\\\ \mbox{Event
Occurs}\end{pmatrix}}{\begin{pmatrix}\mbox{Percent of times}\\\\ \mbox{Event
Occurs}\end{pmatrix}+\begin{pmatrix}\mbox{Percent of times}\\\ \mbox{Event
Does NOT Occur}\end{pmatrix}}$$

This is a common and recurring form that we use to compute probabilities.

<a name="markov-model" />
# Markov Model

We can use this to figure out the expected number of runs. As this is
more a proof-of-concept than a rigorous implementation, we will simplify
various aspects. The basic scheme would be to write out a probability
tree of all the various "histories", then add up the product of the
probability of a given history times its score (if we think of the score
as a 2-dimensional vector space, i.e., we can add scores
"component-wise").

The only problem is this approach suffers from combinatorial explosion,
and eventually we'll have histories which contribute negligibly to the
expected runs. We'll need a "pruning" method to make sure we keep only
the "significant" histories.

It turns out the batting order is significant only when predicting the
runs per season, and it's on the order of magnitude of 5.5 runs per
season (roughly 1% relative error).

As per the possible combinatorial explosion from the number of
histories, we can avoid this. We represent a half-inning by a collection
of 21 row vectors, each representing the possible number of runs (from 0
to 20 inclusive). There are 25 possible states, represented by the
runners on base (8 possibilities: 0, 1, 2, 3, 12, 13, 23, 123), and the
number of outs (0, 1, 2, 3). However, we ignore the runners when there
are 3 outs, which gives us 3×8+1=25 possible configurations.

When a player hits the ball, he or she "evolves" the state of the
game. We can represent this "evolution" by a
[transition matrix](https://en.wikipedia.org/wiki/Stochastic_matrix)
whose entries $(T)\_{ij} = p\_{i,j}=\Pr(j|i)$ are the probabilities of
evolving from state *i* to state *j*.

Computing the [geometric series](https://en.wikipedia.org/wiki/Neumann_series) $I+T+T^{2}+T^{3}+\dots$ for the
transition matrix $T$ (and identity matrix $I$) amounts to computing
$(I-T)^{-1}$. Hence we avoided combinatorial explosion, computations
taking longer than the lifetime of the universe, with linear algebra.

There are several not-so-obvious issues with this model: how do we
compute the expected number of runs? How do we populate the components
of the transition matrix $T$? How do we handle "each player has their
own transition matrix"?

<a name="basic-structure-of-transition-matrix" />
## Basic Structure of Transition Matrix

So, we will consider the basic structure of the transition matrix. The
exact details are rather mundane, and can be found in the
`gambletron.batting` code.

Whenever discussing the transition matrix, we should be clear about the
states. We specifically have 25 states, specifically 1 "absorption
state" (&lowast;, 3 outs) which ends the half-inning for the team, and
the remaining 24 are described by the ordered pair `(runners on base,
number of outs)`.

The transition matrix can be written in block form as
$$
T = \begin{pmatrix}
A\_{0} & B\_{0} & C\_{0} & D\_{0}\\\\
0      & A\_{1} & B\_{1} & E\_{0}\\\\
0      & 0      & A\_{2} & F\_{0}\\\\
0      & 0      & 0      & 1
\end{pmatrix}
$$
where the $A$, $B$, $C$ matrices are 8×8 block matrices, the $D$, $E$,
$F$ are 8×1 column matrices.

The $A$ blocks represent events which *do not* increase the number of
outs, the $B$ blocks are events increasing the number of outs by one,
the $C$ block describe events which increases the outs by 2, and the
remaining blocks describe events which take us to the "absorption state"
where the team has 3 outs.

The first 8 columns indicate the transition to states with 0 outs, the
next 8 columns indicate the transition to states with 1 out, the next 8
columns are for transitions to the states with 2 outs, and the last
column is for transitions to the state with 3 outs. So the 
$D_{0}$ vector is the probability to go from zero outs to 3 outs.

**Simplification.** We assume that the batter's behaviour does not
depend on the state of the game *except when making sacrifice
bunts/hits*. Consequently, $A\_{0}=A\_{1}=A\_{2}$, and the $B$ matrices
are similar except $B\_{1}$ takes into consideration the sacrifice
bunts/hits.
(End of Simplification)

We populate the $A$ matrix with the various probabilities:
$$
A = \left(\begin{smallmatrix}
\Pr(HR) & \Pr(W)+\Pr(1B) & \Pr(2B) & \Pr(3B) & 0 & 0 & 0 & 0\\\\
\Pr(HR) & 0 & 0 & \Pr(3B) & \Pr(W)+\Pr(1B) & 0 & \Pr(2B) & 0\\\\
\Pr(HR) & \Pr(1B) & \Pr(2B) & \Pr(3B) & \Pr(W) & 0 & 0 & 0\\\\
\Pr(HR) & \Pr(1B) & \Pr(2B) & \Pr(3B) & 0 & \Pr(W) & 0 & 0\\\\
\Pr(HR) & 0 & 0 & \Pr(3B) & \Pr(1B) & 0 & \Pr(2B) & \Pr(W)\\\\
\Pr(HR) & 0 & 0 & \Pr(3B) & \Pr(1B) & 0 & \Pr(2B) & \Pr(W)\\\\
\Pr(HR) & \Pr(1B) & \Pr(2B) & \Pr(3B) & 0 &  0 & 0 & \Pr(W)\\\\
\Pr(HR) & 0 & 0 & \Pr(3B) & \Pr(1B) & 0 & \Pr(2B) & \Pr(W)
\end{smallmatrix}\right)
$$
Where Pr(1B)=(Number of Singles)/PA, etc. The only caveat here is, if we
do use exotic figures like grounded into double play (GIDP) and
sacrifice hits or bunts, then we need to modify PA to include them. For
computational purposes, we just populate the matrix with the number of
singles, or doubles, or GIDP, or whatever...then normalize the row (in
the sense of making sure each row of the matrix sums to 1). This is
important, we want the transition matrix to have probabilities add up to
1.

The $B$ matrix is similarly defined as $B\_{0}=\Pr(Out)I\_{8}$, simply the
diagonal matrix whose entries are the probability of an out. The
$B\_{1}$ matrix has a perturbation due to the bunts and sacrifice hits,
which may be considered negligible if desired.

**Remark.**
Observe nothing we did, so far, cannot be computed for a single
batter. That's the plan: each batter gets their own transition matrix.
We can even populate the matrix with relevant probabilities. If we knew
the player was on the home-team, we could restrict our probabilities to
be conditional $\Pr(-\mid\mbox{Home})$. Similarly, if we knew the
weather, we could further refine our probabilities.

We now have to wonder about the ordering of transition matrices, i.e.,
the batting order. We also have yet to discuss how to get runs from the
transition matrix, too.
(End of Remark)

<a name="expected-number-of-runs" />
## Expected Number of Runs

There appears to be two different schemes for computing the expected
number of runs. One appears to be a simplified version of the other, so
we will divide our attention to examine the simple model, then the
complicated one.

<a name="simplified-version" />
### Simplified Version

Following [Tesar](https://www.edsolio.com/media/2/265/files/Tesar_FinalDraft.pdf), we consider a half-inning. The first question we ask
is "How many batters will come up during the half-inning?" Once we have
this, we can compute the expected number of runs "in the obvious way".

We can use the idea of
[Absorbing Chains](https://en.wikipedia.org/wiki/Absorbing_Markov_chain)
to estimate the number of batters that will come to the plate for a
half-inning. We take the 24-by-24 submatrix of the transition matrix
(eliminating the 25th column and 25th row):
$$
Q = \begin{pmatrix}
A\_{0} & B\_{0} & C\_{0}\\\\
0      & A\_{1} & B\_{1}\\\\
0      & 0      & A\_{2}\\\\
\end{pmatrix}
$$
The "fundamental matrix" is $E=(I-Q)^{-1}$. If we know the state of the
game corresponds to row $i$, then the expected number of batters to come
to plate before the half-inning is over is $\sum\_{j}E\_{i,j}$.

So for one half-inning, from start to finish, the expected number of
batters to come to plate is given by taking the first row of $E$, then
summing up its components. Once we know the expected number of batters
to come to plate, we know the expected number of plays. We can compute
the expected number of runs given the expected number of plays.

Tesar's approach is simpler. Construct a vector $\vec{r}$ whose
components are the probability in state *i* a single run will be
scored. Given this, Tesar takes the fundamental matrix and transforms
this vector to get the expected number of runs given the state of the
game. Intuitively this makes sense: $E$ represents how many batters are
likely to come up before the half-inning is up, $\vec{r}$ represents the
probability a run will be scored for any given batter. Their product
$E\vec{r}$ would give us the expected number of runs for the
half-inning, where each component describes a different state. The first
entry $(E\vec{r})_{0}$ would describe the expected number of runs in a
half-inning.

**There is a serious error here.**
With Markov chains, as we are using them (i.e., following Bukiet,
Harold, and Palacios—as Tesar follows them, too), the transition matrix
acts on row vectors on the right. Tesar should have written either
$\vec{r}^{T}E$ or $E^{T}\vec{r}$. The fact Tesar was able to obtain a
reasonable result boils down to numerological accident, than careful
analysis.
(End of discussion on Error)

But, to quote Thucydides, "We bless your simplicity, but do not envy
your folly." This model is *too* simple. While it works great for
estimating the average number of runs per game, it doesn't seem to
adequately capture the situation we're interested in: who will win a
given game, and what will the score be?

<a name="complicated-version" />
### Complicated Version

For simplicity, we will suppose our team has 9 batters with transition
matrices $T\_{1}$, ..., $T\_{9}$. These are the full 25×25 transition
matrices. We will sketch the algorithm presented in Bukiet, Harold, and
Palacios.

##### For a Single Half-Inning.
For a single half-inning, we start with the state vector $u\_{(0)}$ which
has its only nonzero component be its first entry, which is set to
unity. That is, $u\_{(0)}=(1,0,\dots,0)$. Observe it is a row vector, and
the subscript indicates how many batters have come up so far. We have
$u\_{(n+1)}=u\_{(n)}T\_{n}$ where the subscript on the transition matrix is
taken modulo the number of players (i.e., it cycles through all the
players).

The state vector $u\_{n}$ gives us the probability distribution of
states after *n* batters have come to the plate. Consequently, if we
[add up its components](http://mathworld.wolfram.com/L1-Norm.html)
$\\|u\_{n}\\|_{L^{1}}=1$ we get the probabilities must
add up to unity.

*Are we done yet?* No, we need to keep track of how many runs have
occurred. What to do? Well, we could just keep track of it
mentally. This would be tedious and impossible to automate.

We could use a matrix $U\_{(n)}$ to keep track of the number of
runs. The rows of the matrix indicate the number of runs that have
occurred. For simplicity, the original authors limited focus to a maximum of
20 runs per inning (since the probability more than 20 runs occurring in
a single inning is incredibly rare, this is "good enough"), or 21 rows.
When a run occurs, we simply move the probability from that
component (of the given row) down appropriately one row. When 2 runs
occur, we move the component down 2 rows.

To be explicit, we write $T=P\_{0}+P\_{1}+P\_{2}+P\_{3}+P\_{4}$ where
$P\_{j}$ is the components describing *j* runs have occurred. So
$P\_{4}$ has nonzero components when the bases are loaded, and the
batter hits a homerun. (Or, more rarely, if 4 errors have occurred.)
For determining if *j* runs have occurred, we refer the reader to
Appendix A of
[Tesar](https://www.edsolio.com/media/2/265/files/Tesar_FinalDraft.pdf). 

Then we have
$$
U\_{(n+1)}(\mbox{row }j) = \sum\_{k=0}^{4}U\_{(n)}(\mbox{row }j-k)P\_{k}
$$
If $j-k<0$, we simply use the zero row vector.

Iterating this "many times" (until the probability of 3 outs is, e.g.,
at least 99%), we get the final matrix $U\_{(\infty)}$
whose 25th column gives the probability distribution for the runs that
half-inning. We can compute the expected number of runs easily, once
given the probability distribution.

##### For an Entire Game.
Once we have the half-inning done, the rest of the game should be a
straightforward generalization: just use 9 times as many rows in these
$U\_{(n)}$ matrices, right? Each inning consists of a 21-row submatrix,
and once a 3-out state has been reached, "move" the contents to the
start of the next inning (21 rows down, because we use the rows to keep
track of the runs we *must* move the contents down proportionally). Keep
iterating until the probability there are 27 outs is at least 99.9%, and
you've got the probability distribution for the runs per inning in the
25th column of the resulting matrix.

The expected number of runs can be found by examining the last inning
(i.e., the last 21 rows of $U\_{(\infty)}$). We obtain the probability
distribution for the runs at the end of the game. Again, we suppose
there are at most 20 runs per side, which appears valid. The last time a
team had more than 20 runs was when the Phillies defeated the Cubs 23-22
in ten innings on May 17, 1979.

### Probability of Winning the Game
So, for a given team, the 25th column in the last 21 rows forms a vector
denoted $S(\mathrm{Team})$. The probability a team will win is given by
the probabilities it scores more runs than the other team:
$$
\Pr(\mbox{Team 1 wins}) = \sum^{20}\_{i=1}S(\mbox{Team 1})\_{i}\sum^{i-1}\_{j=0}S(\mbox{Team 2})\_{j}
$$
The probability the game goes to overtime is given by the probability
the two teams score the same number of runs
$$
\Pr(\mbox{Overtime}) = \sum^{20}\_{i=1}S(\mbox{Team 1})\_{i}S(\mbox{Team 2})\_{i}
$$
What to do about overtime?

One solution is to ignore it as negligible. (Probably a good idea for a
"first pass".) But one possible solution is to modify "Tennis odds" to
extrapolate the runs scored in overtime, which then allows us to modify
our equations to include an extra term for the case when the game goes
to overtime:
$$
\Pr(\mbox{Team 1 Wins}) = \Pr\begin{pmatrix}\mbox{Team 1 Wins}\\\\
\mbox{Without Overtime}\end{pmatrix}
+ \Pr(\mbox{Overtime})\Pr\begin{pmatrix}\mbox{Team 1 Wins}\\\\
\mbox{The Extra Inning}\end{pmatrix}
$$
It turns out that it's just as quick to compute the extra inning's
distribution, which we treat as just one inning from scratch. This is
far from accurate, but it works.

<a name="predictions" />
# Predictions

The part everyone is waiting for, the predictions.

<a name="laa-vs-txr" />
### Anaheim Angels vs Texas Rangers

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Prediction: .<a href="https://twitter.com/Angels">@Angels</a> 3 vs .<a href="https://twitter.com/Rangers">@Rangers</a> 4 for today&#39;s game.</p>&mdash; Alex Nelson (@anelson_unfold) <a href="https://twitter.com/anelson_unfold/status/617777898376658944">July 5, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The
[final score](http://mlb.mlb.com/mlb/gameday/index.jsp?gid=2015_07_05_anamlb_texmlb_1&partnerId=LR_gameday#game=2015_07_05_anamlb_texmlb_1,game_state=Wrapup,game_tab=play-by-play)
was Angels 12 - Rangers 6.

<a name="oak-vs-sea" />
### Oakland A's vs Seattle Mariners

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Prediction: .<a href="https://twitter.com/Athletics">@Athletics</a> 4 vs .<a href="https://twitter.com/Mariners">@Mariners</a> 2 for today&#39;s game.</p>&mdash; Alex Nelson (@anelson_unfold) <a href="https://twitter.com/anelson_unfold/status/617779244794392577">July 5, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The [final score](mlb_oakmlb_1&partnerId=LR_gameday#game=2015_07_05_seamlb_oakmlb_1,game_state=Wrapup,game_tab=play-by-play) was Oakland 1 - Mariners 2.

<a name="lad-vs-met" />
### LA Dodgers vs NY Mets

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">.<a href="https://twitter.com/Dodgers">@Dodgers</a> 3 vs .<a href="https://twitter.com/Mets">@Mets</a> 3 for today&#39;s game, projected to have an extra inning which Dodgers will win due to home advantage.</p>&mdash; Alex Nelson (@anelson_unfold) <a href="https://twitter.com/anelson_unfold/status/617780656630689792">July 5, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The [final score](http://mlb.mlb.com/mlb/gameday/index.jsp?gid=2015_07_05_nynmlb_lanmlb_1&partnerId=LR_gameday#game=2015_07_05_nynmlb_lanmlb_1,game_state=Wrapup,game_tab=play-by-play)
New York Mets 8 - LA Dodgers 0.

<a name="conclusion" />
# Conclusion

We discussed the basic idea behind the Bernoulli trial, applied the
concept to individual plays, and found the Markov chain was a natural
extension of this idea. We discussed how to improve the probabilities by
taking the pitcher into account, as compared to the league average.

We implemented the Markov model, which can be found on [github](https://github.com/pqnelson/gambletron)
(checkout version `v0.2.0`) but used naive probabilities for simplicity. 
We could improve our predictions using various techniques discussed
earlier (e.g., take into account the pitcher, or organized the batters
into an optimal batting order) or if we had more precise statistics
(batting stats for away games, for home games, etc.). This requires
another data source, however.

The low hanging fruit for us: picking an optimal batting order. Now that
we have a rudimentary Markov chain model, we can easily determine the
optimal batting order. But that's the topic for another time.

# References

- D.B. Schmidt, [Basic Theory of Operation: Hitting vs Pitching -- the First Step](http://sbs-baseball.com/theory.txt)
- Dan Levitt, [The Batter/Pitcher Match Up](http://www.baseballthinkfactory.org/btf/scholars/levitt/articles/batter_pitcher_matchup.htm)
- Tom Tango [The Odds Ratio Method ](http://www.insidethebook.com/ee/index.php/site/comments/the_odds_ratio_method/)

## Batting Order Optimization

- James Sokol,
  [A Robust Heuristic for Batting Order Optimization Under Uncertainty](http://www2.isye.gatech.edu/~jsokol/boouu.pdf),
  (pdf) 18 pages.

## Probability Batter will Hit the Ball

- Dan Levitt, [The Batter/Pitcher Match Up](http://www.baseballthinkfactory.org/btf/scholars/levitt/articles/batter_pitcher_matchup.htm)
- D.B. Schmidt, [Basic Theory of Operation: Hitting vs Pitching -- the First Step](http://sbs-baseball.com/theory.txt)
- Steve Staude, [Adjusting Linear Weights for Extreme Environments](http://www.fangraphs.com/blogs/adjusting-linear-weights-for-extreme-environments/)
- Steve Staude, [Linear Weights + BaseRuns = Good](http://www.fangraphs.com/blogs/linear-weights-baseruns-good/)
- Steve Staude, [Team-Specific Hitter Values by Markov](http://www.fangraphs.com/blogs/team-specific-hitter-values-by-markov/)
- Steve Staude, [More Fun with Markov: Custom Run Expectancies](http://www.fangraphs.com/blogs/more-fun-with-markov-custom-run-expectancies/)
- Tom Tango [The Odds Ratio Method ](http://www.insidethebook.com/ee/index.php/site/comments/the_odds_ratio_method/)
- Tom Tango, [Weighting of OBP relative to SLG](http://tangotiger.com/index.php/site/comments/weighting-of-obp-relative-to-slg), 2013

## Markov Chain Models

- Mark D. Pankin,
  [Markov Chain Models: Theoretical Background](http://www.pankin.com/markov/theory.htm)
  and [Baseball as a Markov Chain](http://www.pankin.com/markov/intro.htm)
- Bruce Bukiet, Eliottee Harold, and Jose Luis Palacios,
  [A Markov Chain Approach to Baseball](http://m.njit.edu/~bukiet/Papers/ball.pdf) (pdf, 22 pages)
  Although not the first people to apply Markov models to baseball, they
  were the first to publish a paper about it; you'll find everyone cites
  this paper when discussing Markov models in baseball...demonstrating
  the importance of publishing even folklore results.
- Adam Sugano,
  [A Player Based Approach to Baseball Simulation](http://statistics.ucla.edu/theses/uclastat-dissertation-2008:6),
  Ph.D. Thesis.
- Joel S. Sokol,
  [An Intuitive Markov Chain Lesson from Baseball](http://isye.umn.edu/courses/ie5112/mc/sokol.pdf) (pdf, 9 pages)
- Naomi Tesar,
  [Estimating Expected Runs Using a Markov Model for Baseball](https://www.edsolio.com/media/2/265/files/Tesar_FinalDraft.pdf)
  (pdf, 13 pages)

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    extensions: ["tex2jax.js"],
    jax: ["input/TeX", "output/HTML-CSS"],
    tex2jax: {
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
      processEscapes: true
    },
    "HTML-CSS": { availableFonts: ["TeX"] }
  });
</script>
<script type="text/javascript"
    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
