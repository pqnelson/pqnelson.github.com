---
layout: post
title: Baseball Cheat Sheet
published: true
quote: "Life's single lesson: that there is more accident to it than a man can ever admit to in a lifetime and stay sane."
quoteSource: Thomas Pynchon, <i>V.</i> (1963)
tags: [Baseball]
---

I found several papers by Jim Alberts, which had a nifty table of
probabilities and expected runs in a half-inning. At a recent game, I
recalled very few of them, so I put together a "cheat sheet" of
probabilities which may be useful in the future.

The data I am using is from 2011-2014. The data for American league (or
National league) teams is from games where both the visiting and home
teams are in the same league, from 2011-2014.

**Expected Runs for a given batter.** If a batter comes to plate, and you know
which bases have runners, and how many outs there are, here's the
table of expected runs for the batter:

| Outs | None  |   (1) |   (2) |   (3) | (1,2) | (1,3) | (2,3) | (1,2,3) |
|------|-------|-------|-------|-------|-------|-------|-------|---------|
| 0    | 0.441 | 0.750 | 0.936 | 0.867 | 1.171 | 1.091 | 1.298 | 1.356   |
| 1    | 0.225 | 0.420 | 0.479 | 0.456 | 0.599 | 0.541 | 0.751 | 0.708   |
| 2    | 0.071 | 0.125 | 0.125 | 0.115 | 0.152 | 0.156 | 0.197 | 0.155   |

For the National League:

| Outs | None  |   (1) |   (2) |   (3) | (1,2) | (1,3) | (2,3) | (1,2,3) |
|------|-------|-------|-------|-------|-------|-------|-------|---------|
| 0    | 0.426 | 0.724 | 0.905 | 0.839 | 1.126 | 1.055 | 1.198 | 1.291   |
| 1    | 0.218 | 0.409 | 0.475 | 0.451 | 0.577 | 0.547 | 0.762 | 0.674   |
| 2    | 0.069 | 0.121 | 0.122 | 0.116 | 0.140 | 0.148 | 0.203 | 0.154   |

For the American League:

| Outs | None  |   (1) |   (2) |   (3) | (1,2) | (1,3) | (2,3) | (1,2,3) |
|------|-------|-------|-------|-------|-------|-------|-------|---------|
| 0    | 0.456 | 0.775 | 0.973 | 0.911 | 1.230 | 1.132 | 1.401 | 1.455   |
| 1    | 0.231 | 0.427 | 0.490 | 0.459 | 0.625 | 0.549 | 0.755 | 0.745   |
| 2    | 0.072 | 0.127 | 0.130 | 0.113 | 0.157 | 0.163 | 0.204 | 0.159   |


**Expected Runs by End of Inning.** If you know which bases have
runners, and how many outs there are, then we have the following table
of expected runs by the end of the inning (a far more useful estimate):

| Outs | None  |   (1) |   (2) |   (3) | (1,2) | (1,3) | (2,3) | (1,2,3) |
|------|-------|-------|-------|-------|-------|-------|-------|---------|
| 0    | 0.483 | 0.794 | 1.199 | 1.612 | 1.474 | 1.955 | 2.313 | 2.520   |
| 1    | 0.387 | 0.706 | 1.019 | 1.407 | 1.266 | 1.682 | 1.959 | 2.154   |
| 2    | 0.372 | 0.633 | 0.946 | 1.004 | 1.064 | 1.259 | 1.362 | 1.509   |

If you know the team at bat is in the national league, you may use the
following table instead:

| Outs | None  |   (1) |   (2) |   (3) | (1,2) | (1,3) | (2,3) | (1,2,3) |
|------|-------|-------|-------|-------|-------|-------|-------|---------|
| 0    | 0.466 | 0.767 | 1.171 | 1.566 | 1.440 | 1.885 | 2.222 | 2.455   |
| 1    | 0.367 | 0.681 | 0.991 | 1.397 | 1.235 | 1.645 | 1.903 | 2.097   |
| 2    | 0.350 | 0.599 | 0.904 | 0.978 | 1.039 | 1.241 | 1.315 | 1.456   |

Likewise, for the American league:

| Outs | None  |   (1) |   (2) |   (3) | (1,2) | (1,3) | (2,3) | (1,2,3) |
|------|-------|-------|-------|-------|-------|-------|-------|---------|
| 0    | 0.502 | 0.821 | 1.234 | 1.696 | 1.526 | 2.051 | 2.400 | 2.642   |
| 1    | 0.407 | 0.729 | 1.059 | 1.427 | 1.304 | 1.736 | 2.042 | 2.230   |
| 2    | 0.391 | 0.661 | 0.988 | 1.047 | 1.085 | 1.292 | 1.404 | 1.589   |

The fact the American league has a higher expected-run table probably
lies in their designated hitter rule usage.
