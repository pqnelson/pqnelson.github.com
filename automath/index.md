---
layout: post
title: Automath Notes
published: true
quote: "[A] living language depends equally on the 'legends' which it conveys by tradition. … [Constructed languages] are dead, far deader than ancient unused languages, because their authors never invented any legends... "
quoteSource: JRR Tolkien, Letter to Mr Thompson (1956)
---

[Nicolaas Govert de Bruijn](https://en.wikipedia.org/wiki/Nicolaas_Govert_de_Bruijn)
invented Automath in 1967, and worked on it over the next 20
years. (Work ended when de Bruijn retired, since he was the fire
powering the Automath engine.) It amounts to a glorified typed-lambda
calculus, and can rightly be considered the "assembly language" of
mathematics.

Currently, the only working interpreter for Automath may be found on
Freek Wiedijk's
[site](http://www.cs.ru.nl/F.Wiedijk/aut/index.html). It's quite fast
compared to modern theorem provers, but provides zero
automation. (Another reason why "assembly language" is an apt metaphor.)

<ul>
{% for post in site.categories.Automath %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>, posted {{ post.date | date:"%-d %B %Y" }}
    </li>
{% endfor %} 
</ul>
