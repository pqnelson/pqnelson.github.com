---
layout: default
title: Elements of Programming
type: home
quote: "...Elegance is not a dispensable luxury but a quality that decides between success and failure."
quoteSource: E. W. Dijkstra, <a href="http://www.cs.utexas.edu/~EWD/transcriptions/EWD12xx/EWD1284.html">EWD1284 <tt>[cs.utexas.edu]</tt></a>
---
Or, Alex Nelson's working notes for programming.

You probably have come here by accident, as there's really not much I
have published worth reading.

Paraphrasing Wittgenstein, a good guide will take you through the more
important streets more often than he takes you down side streets; a bad
guide will do the opposite. In programming pedagogy, I'm a rather bad guide.
Instead of trying to write some self-contained [Bourbaki-esque](http://en.wikipedia.org/wiki/Bourbaki)
programming site, I'll just cover problems I'm currently facing in...whatever it
is I do.

I also have a [wiki](./wiki/) of random notes on math and
science, and an [org notebook](./org-notes/) experiment to see if I like
org-mode. They're mildly polished, but not presentable in papers. More
polished materials may appear in my [notebook](./notebk/).

Send your angry emails to me at `PQNELSON AT GMAIL DOT REMOVE THIS DOT
COM`.

(See also the [posts by tags](/tags/).)

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>, posted {{ post.date | date:"%-d %B %Y" }}
    </li>
  {% endfor %}
</ul>
