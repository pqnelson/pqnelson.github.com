---
layout: post
title: Lineups and Pitchers, Observations on Markov Chains
published: true
quote: "It's tough to make predictions, especially about the future."
quoteSource:  Yogi Bera, Apocryphal
tags: [Baseball, Statistics]
---

**Executive Summary.**
We discuss the impact of the lineup and pitcher on predicting game outcomes.

**Contents**

- [Lineup Matters](#lineup-matters)
  - [Determining the Lineup](#determining-lineup)
- [Predictions](#lineup-matters-predictions)
  - [Cleveland Indians vs Anaheim Angels (August 3, 2015)](#cleveland-anaheim-8-3-2015)
  - [Cleveland Indians vs Minnesota Twins (August 8, 2015)](#cleveland-minnesota-8-8-2015)
  - [Baltimore Orioles vs Anaheim Angels (August 8, 2015)](#baltimore-anaheim-8-8-2015)
- [Including the Pitcher is Hard, but is it Necessary?](#include-the-pitcher)
  - [Case Study: Orioles Pitcher for August 7, 2015](#case-study-orioles)
  - [Case Study: Minnesota Pitcher for August 8, 2015](#case-study-minnesota)
- [References](#references)

# Introduction

So, [last time]({% post_url 2015-07-05-bernoulli-batters-markov-coaches %})
the Markov chain model was introduced and we made some 
predictions. Unfortunately, those predictions were off. What happened?!
Well, it turns out that the lineup matters significantly.

Furthermore, when batting, roughly 40% of the outcome is due to the
pitcher, and 60% due to the batter. Adam Sugano discovered this
relationship statistically for the 2001-2006 seasons (and confirmed it
with the 1987 season) in section 3.3.1 _et seq._ of his doctoral
thesis. So neglecting the pitcher ignores nearly half the battle.

**Moral:** If the reader has been perusing the previous posts on
modeling baseball, we hope the moral comes across quite clear: the first
few models will be terrible. But the point is to figure out 
_why they're wrong_, 
then improve. _Do not be discouraged with initial failures._
(End of Moral)

<a name="lineup-matters" />

# Lineup Matters

Consider the following 9 players: David DeJesus, Kole Calhoun, Mike
Trout, Albert Pujols, David Murphy, Erick Aybar, Conor Gillaspie,
Johnny Giavotella, and Chris Iannetta﻿. There are many superstitions
about how to order them into a lineup, but would it really matter for a
Markov model?

Lets consider all possible lineups (that is 9! = 362,880
possibilities). What are the expected number of runs in the Markov model?
It would take 3 weeks of solid computing to find out, so instead I
considered permutations of the first 6 or so positions.

Permuting the first 4 positions produces an expected number of runs
between 4.55 and 4.58, and a random sample of 120 lineups (of all 362k
possibilities) has the lowest scoring lineup be 4.45 runs scored by
Giavotella, Murphy, DeJesus, Gillaspie, Aybar, Iannetta, Trout, Calhoun,
Pujols; the highest scoring lineup be 4.58 runs scored by Pujols,
Iannetta, Calhoun, Trout, Murphy, DeJesus, Gillaspie, Aybar,
Giavotella.

If we started pulling from the inactive roster, things get horribly
worse. But that's because we're using skewed probabilities in the Markov
chain. So we shouldn't be surprised when someone inactive is placed in a
Markov chain, and the results are garbage.

<a name="determining-lineup" />

## Determining the Lineup

There is no definitive way to generate the correct lineup, but we may
guess based on the recent lineups for a given team. These may be found
on the [ESPN page](http://espn.go.com/mlb/teams) for each team, found
under their roster. Strong regularities may be found (e.g., J Rollins
always starts for the LA Dodgers, followed by E Hernandez).

Since we only have 2014 data (and pre-2014 data), we have some ambiguity
when fresh rookies are in the lineup. We use 2014 league average as a
proxy for the fresh rookies' statistics (if our job depended on it, we
could enter the 2015 data into the prediction and use that instead).

<a name="lineup-matters-predictions" />

# Predictions

<a name="cleveland-anaheim-8-3-2015" />

## Cleveland Indians vs Anaheim Angels (August 3, 2015)

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Prediction for tomorrow&#39;s game: .<a href="https://twitter.com/Indians">@Indians</a> 3.7844 runs VS .<a href="https://twitter.com/Angels">@Angels</a> 4.7573. Angels win with home-team advantage.</p>&mdash; Alex Nelson (@anelson_unfold) <a href="https://twitter.com/anelson_unfold/status/627982753238138880">August 2, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The outcome [Angels 5, Indians 4](http://mlb.mlb.com/mlb/gameday/index.jsp?gid=2015_08_03_clemlb_anamlb_1&partnerId=LR_wrap#game=2015_08_03_clemlb_anamlb_1,game_state=Wrapup,game_tab=box).
We see that Garrett Richards performed superbly, with the probability a
hitter would hit the ball being 21.05% in this game. Since this was so
close to the league average, the naive Markov model worked well.

So, the problem was just the lineup. Huzzah, huzzah, I'll just throw
back my legs and pollute my britches with delight...

<a name="cleveland-minnesota-8-8-2015" />

## Cleveland Indians vs Minnesota Twins (August 8, 2015)

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Prediction for tomorrow&#39;s game: .<a href="https://twitter.com/Indians">@Indians</a> 3.6933 vs .<a href="https://twitter.com/Twins">@Twins</a> 3.83678, Minnesota will win...if it could be called a victory...</p>&mdash; Alex Nelson (@anelson_unfold) <a href="https://twitter.com/anelson_unfold/status/629859693272264705">August 8, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Final score [Cleveland 17, Minnesota 4](http://mlb.mlb.com/mlb/gameday/index.jsp?gid=2015_08_08_minmlb_clemlb_1&partnerId=LR_gameday#game=2015_08_08_minmlb_clemlb_1,game_state=Wrapup,game_tab=box).
D'oh! What happened? Did Cleveland draft Mutant Atomic Supermen? No, it
appears that Minnesota's pitchers were not up to scratch.
Santana had a hit probability of 61.5% (his career stats average suggest
23% more likely), for example, and Graham had a 50% probability.


<a name="baltimore-anaheim-8-8-2015" />

## Baltimore Orioles vs Anaheim Angels (August 8, 2015)

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Prediction for tomorrow&#39;s game: .<a href="https://twitter.com/Angels">@Angels</a> 4.5614 vs .<a href="https://twitter.com/Orioles">@Orioles</a> 3.7763659</p>&mdash; Alex Nelson (@anelson_unfold) <a href="https://twitter.com/anelson_unfold/status/629868850297765888">August 8, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

But really, the score was [Orioles 5, Angels 0](http://mlb.mlb.com/mlb/gameday/index.jsp?gid=2015_08_08_balmlb_anamlb_1&partnerId=LR_gameday#game=2015_08_08_balmlb_anamlb_1,game_state=Wrapup,game_tab=box).
Jimenez was on fire, his career stats suggest an OBPA of about 26.655%,
but in the game a mere 7.4% of batters hit the ball.

<a name="include-the-pitcher" />

# Including the Pitcher is Hard, but is it Necessary?

The Markov model has a serious flaw, in that it does not take into
account the pitcher. (The Cleveland vs Minnesota game should convince us
how important a factor the pitcher _is_ in a game!) Sadly, we cannot
simply compose the transition matrix with a "pitcher modification"
matrix under most circumstances because
[the derivation](/2015/07/05/bernoulli-batters-markov-coaches.html#include-pitcher)
does not allow for it.

(One trick is to rewrite this in a geometric series, Taylor expand to a
couple orders, and you get some factor correcting the
probabilities. Take the denominator _HP/L_ + (1 - _H_)(1 - _P_)/(1 - _L_)
add and subtract by (1 - _H_)_P_/_L_, rewriting it as _P/L_ + (1 -
_H_)((1 - _P_)/(1 - _L_) - _P/L_), divide the top and bottom by _P/L_,
and _voila!_ you have the denominator look like 1 - _X_. Observe _X_ is
of the order 0.01, which means a quadratic approximation is quite
good. That's one possibility to consider. This may cause problems for
_P_ &gt; 6/7 or _P_ &lt; 1/7, only the latter has happened in this
millenium...but there's still time.) 

## Addendum: Bayesian Testing Pitcher Performance

I have written a [post]({% post_url 2017-11-22-bayesian-testing-pitchers %})
giving a more intuitive approach to testing pitcher performance, using
Bayesian inference while treating the pitcher's success or failure like
a "coin flip". Bayesian inference provides a rigorous way to bound the
"bias" of the coin (or, for us, the successfulness of the pitcher) based
on previous trials.

<a name="case-study-orioles" />

## Case Study: Orioles Pitcher for August 7, 2015

**Does this even matter?** Well, if we ran the Markov model on the
August 7th game for Anaheim Angels vs Baltimore Orioles, then we should
expect the score to be Angels 4.5614 vs Orioles 3.7763659 for the Angels
lineup (i) David DeJesus, (ii) Kole Calhoun, (iii) Mike Trout, (iv)
Albert Pujols, (v) David Murphy, (vi) Erick Aybar, (vii) Conor
Gillaspie, (viii) Johnny Giavotella, (ix) Chris Iannetta﻿. But
[when this happened](http://mlb.mlb.com/mlb/gameday/index.jsp?gid=2015_08_07_balmlb_anamlb_1&partnerId=LR_box#game=2015_08_07_balmlb_anamlb_1,game_tab=box,game_state=Wrapup)
the score was Angels 8, Orioles 4.

What happened?! Orioles pitcher Gausman was having an off-day. 
_Could we have predicted this?_ 
Lets see, we'll compare the 2014 league average to
Gausman's career stats:
	
|                         |  IP     | Hits  | HR   | BB   | K     |
|-------------------------|---------|-------|------|------|-------|
| Kevin Gausman (Career)  | 214.1   | 213   | 22   | 65   | 181   |
| Gausman (2015)          | 53.1    | 51    | 7    | 14   | 44    |
| 2014 League Avg         | 21798.7 | 20962 | 2151 | 7017 | 18588 |

This produces the relevant probabilities:

|                 Signal | Gausman (Career) | Gausman (2015) | 2014 League Average |
|------------------------|------------------|----------------|---------------------|
| Batters Faced          | 920.3            |  224.3         | 93375               |
| Probability of Hit     | 23.144627%       |  22.737405%    | 22.449264%          |
| Probability of Homerun | 2.3905247%       |  3.1208204%    | 2.3036145%          |
| Probability of Walk    | 7.062914%        |  6.241641%     | 7.51486%            |

Observe Kevin Gausman's career statistics are close to the league
average, as are his 2015 statistics. (Note: the statistics were obtained
on 8 August 2015, at 12:04PM (PST), so they are probably out of date
already.)

**Problem:** Clearly the pitcher's performance was responsible for the
Angels scoring an abnormal number of runs, and the pitcher's previous
average performance does not allow for this. In particular, for the game
in question, Gausman faced 17+9+2=28 batters and had a probability of
getting a hit about 32.142857%, much higher than the league
average. (His other statistics for that game were within 1% or less of
the league average.) 

**Confidence Intervals.**
Perhaps it could be explained statistically? Well, if we use the
[Wilson confidence interval](https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval#Wilson_score_interval),
we can determine what would be statistically feasible. The idea is to
consider the batter hitting the ball as a "failure" for the pitcher, and
the batter struck out as a "success" for the pitcher. Hey! It's a
"coin-flip" (Bernoulli trial).

We can apply the central limit theorem when we have 30 or more data
points for the pitcher. We happen to have several hundred, so we're
golden. Then we may approximate the probability of failure as being
normally distributed within some range. (For 30 or fewer data points,
the Wilson score is a great approximation &mdash; and it converges to
the binomial score as the number of data points increases.)

**Intuitive Picture.**
The confidence interval tells us, with 95% confidence (or more if
desired), the "mean" and the margin of error for the sample size.

**When can we use the confidence inteval?**
The rule of thumb is _np_ &gt; 5 and _n_(1 - _p_) &gt; 5. For us, _n_ is
about 920, and _p_ is about 23%, we're golden. (More generally, if 15%
&lt; _p_ &lt; 85%, then _n_ &gt; 40 is the heuristic...but any _n_ &gt; 33
works as well for such _p_.)

**How do we use it?**
Well, we want to suggest that Gausman sucked with statistical
significance. How we do this, using confidence intervals, is construct
one interval for his performance during the game. Then we construct
another based on his career (or his 2015 stats, whichever). _If the two
intervals do not overlap_, then we may say "Gausman did indeed suck with
statistical significance specified by the intervals".

If the two intervals overlap, well, then Gausman may or may not suck
with statistical significance...the test tells us little, in this
case. Or more precisely, it tells us "Perform more tests!"

**What does it say?**
Well, the wilson confidence interval tells us we should expect the
probability a batter will hit the ball (when Gausman pitches based on
his 2015 data) 23.1255% ± 5.4438486%
with 95% confidence. To be more precise, when we drop a Gaussian about
23.1255%, 95% of the Gaussian lies within 5.44% of 23.1255%.

But the Wilson score for the game has _p_ = 9/28. It produces an
interval centered at 34.2972% ± 16.363955%, since the number of trials
is so small and our confidence is so "large". (The reader should confirm
that we _can_ perform a confidence interval using the data from the game.)

As odd as it sounds, we cannot "reject the null hypothesis", i.e., although
Gausman did not perform up to par (by our subjective/intuitive
standards, it "feels" like he sucked), statistically he did not.
I am not happy about this: I want to flip the table over, and blame one
person squarely for screwing up my predictions. But that's emotion. The
cold hard facts indicate the Gausman _really did_ just _slightly_ below
his usual best.

(Emotionally, there are two ways to respond: (a) reject statistics as
baloney, (b) blame the other pitchers for screwing up my predictions! I
choose (b).)

**Exercise for the Reader.**
Perform a similar analysis for Brian Matusz and Brad Brach, since they
are responsible for 3 runs.

**Another Exercise for the Reader.**
Show my emotional response is invalid, i.e., the other pitchers also did
adequately given their past performance history. Then find someone who
we _can_ blame for the outcome.

**Moral of the Story.**
The moral for this particular case study: random variations cause
serious and observable differences in outcomes. And, in this example,
the random variations were not surprising (they _were_ within a standard
deviation of past behavior).

**Puzzle.** In these "unsurprising" scenarios, where
"routine" randomness completely changes the outcome, how can we (a)
determine who is most probable to win? And (b) communicate that the
randomness can completely change the outcome?

One step towards a solution may be to consider using
[Fuzzy Markov Chains](https://upcommons.upc.edu/bitstream/handle/2099/3616/buckley.pdf?sequence=1). 

<a name="case-study-minnesota" />

## Case Study: Minnesota Pitcher for August 8, 2015

We find for [Ervin Santana](http://m.mlb.com/player/429722/ervin-santana)
his pitching stats are:

|                  |  IP     | Hits  | HR   | BB   | K     |
|------------------|---------|-------|------|------|-------|
| Santana (Career) | 1924.1  | 1871  | 253  | 605  | 1534  |
| Santana (2015)   | 41.2    | 44    | 8    | 16   | 27    |
| 2014 League Avg  | 21798.2 | 20962 | 2151 | 7017 | 18588 |

Using Santana's career stats, we see that Santana has faced
(3×1924)+1+1871+605=8249 batters, and has had 22.681538% of batters hit
his pitches. The corresponding confidence interval is 22.694254% ±
0.9035812%, for his entire career.

**Confidence Interval for the Game.** We see, for this game, Santana
faced 17 batters, of which 10 successfully hit the ball. So we have a
confidence interval 57.197193% ± 21.19175% (using a 95% confidence). But
look: the lower end point for this interval is 36% (rounding down),
whereas the upper interval for Santana's entire career is 24% (rounding
up). Hence we may state _with 95% confidence, Santana sucked at pitching
with statistically significance in this game compared to what his career
suggests._

**Compared to this year's performance.**
We can likewise construct the confidence interval for Santana's
performance this year. From simple arithmetic, we find it 24.31708% ±
6.0958176%. This is puzzling: the upper end point is 31% (rounding up),
which again implies _with 95% confidence, Santana sucked at pitching with
statistical significance in this game compared to his career this year._

**What should we have expected?**
Well, if Santana were well rested (etc.), we should have expected about
a quarter as many runs and no home runs. That is to say, we should have
expected 2.1067379 runs when facing 18 batters...which would have put us
somewhere in the 5th inning.

**Why is this happening?**
Well, Santana used performance enhancing drugs and was
[suspended for 80 games](http://hardballtalk.nbcsports.com/2015/07/04/twins-move-trevor-may-to-the-bullpen-to-make-room-for-ervin-santana/), 
and since he has returned his performance has been statistically
significantly worse (as we have seen). There appears to be some
correlation, unsurprisingly negative, between these two events.

_We cannot say one caused the other._ It could be lurking factors, like
Santa wasn't practicing during the 80-game period, or his wife has cancer
and he's distracted & worried, or he was in a car accident, etc. Experts
have some plausible [explanations](http://www.twincities.com/sports/ci_28637088/brian-murphy-twins-ervin-santana-wilting-heat-expectations).

**What could we do?**
Even if we factored in the pitcher's behaviour to our Markov model, we
still could not have predicted the 17-4 outcome. Why? Because we have
2014 data for the pitchers, but it appears (if we learn one thing from
Santana's contribution to the outcome) we must use the most recent data
for the starting pitcher.

We could consider using a weighted or exponential
[moving average](https://en.wikipedia.org/wiki/Moving_average), weighing
the more recent performance more than historical performance. 

<a name="references" />

# References

- James Buckley and Esfandiar Eslami,
  [Fuzzy Markov Chains: Uncertain Probabilities](https://upcommons.upc.edu/bitstream/handle/2099/3616/buckley.pdf?sequence=1).
- Adam Sugano,
  [A Player Based Approach to Baseball Simulation](http://statistics.ucla.edu/theses/uclastat-dissertation-2008:6),
  Ph.D. Thesis.

## Pitchers

- Frank Firke, [Uncertainty and Pitching Statistics](http://clownhypothesis.com/2014/03/07/uncertainty-and-pitching-statistics/)
- Pizza Cutter, [On the reliability of pitching stats](https://statspeakmvn.wordpress.com/2008/01/06/on-the-reliability-of-pitching-stats/)
- Graham MacAree(?), [Sample Size](http://www.fangraphs.com/library/principles/sample-size/)

## Lineup

- Sky Kalkman, [Optimizing Your Lineup By The Book](http://www.beyondtheboxscore.com/2009/3/17/795946/optimizing-your-lineup-by)

