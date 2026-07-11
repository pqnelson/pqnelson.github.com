---
layout: wiki
title: Links - Zettelkasten
published: true
date: 2021-11-31
parentURL: /wiki/note-taking/zettelkasten/
---

When I refer to other parts of my Zettelkasten, I use "links" (i.e., I
write in red ink the parenthesized ID of the referenced slip). This is
the mechanical description of _constructing_ links. But when would I
want to do this?

Well, if we think of the Zettelkasten as a brain, and each slip as a
neuron, a link is when two neurons are connected.

Now, I'm a mathematician, this may be overkill: do I really need to
backlink to "Real Numbers" everytime I say something like "Let _x_ be a
real number"? This is a judgment call. For something as elementary as
"real number" (which is ingrained in us since elementary school), I
would say no.

What about "vector space"? "Basis"? "Spanning set"?

Well, I would say, "It depends."

If this were in the category of linear algebra, I would say, "No,
because it's the subject of the thread, or very near adjacent to it."

On the other hand, in my subcategory of representation theory of Lie
algebras, I tend to err on the side of back-linking.

## Examples where links work

I discussed some examples where links produced meaningful results in
[Brain as metaphor](brain-metaphor.md). My experience has taught me
that "obvious links" have value, because _following_ the links leads
to surprises (useful insights).

I discussed on the referenced page three examples, which I quickly
summarize as:

1. I took notes on "time in economics", adding `Time (economics)`,
   `Logical time`, `Mechanical time`, and `Historical time` to my
   Zettelkasten. Here "historical time" refers to the entropic arrow
   of time familiar in physics, so in the contents of `Historical time`
   when I discuss "entropic arrow of time", I link both to
   `Entropy` and `arrow of time`.
   
   At the same time, taking notes on Brouwer's `First act Intuitionism`
   I need to discuss Brouwer's interpretation of "_a priori_ Intuition
   of time". Ah, which "time" are we talking about? My Zettelkasten is
   familiar with at least three distinct notions of time in
   economics. I link to `time (Economics)` which then traces to
   `Entropy` and the arrow of time. Connecting `Entropy` with
   Brouwer's Intuitionism is meaningful, useful, novel --- hence
   surprising.
2. I am writing about Dan Ingalls's paper "Design Principles of Smalltalk"
   which treats Smalltalk as the medium of communication for a
   dialogue between the programmer and the computer. This leads to
   slips like `Smalltalk (programming language)`, `Dialogue with computer`
   (which links to `Dialogue`, and I then update `Dialogue` to
   "backlink" to `Dialogue with computer`), and `Computer has body and mind`.
   However, `Dialogue` links to `Communication`, which links to
   `Autopoiesis`. This leads to the intriguing connection between
   programming and autopoiesis, which I have not seen anyone discuss.
3. Extending the previous example, a `proof assistant` facilitates
   dialogue between the user and computer, concerning formalizing
   Mathematics within a foundations of Mathematics. You literally
   engage in a `Dialogue with computer` in the manner discussed in the
   design principles of Smalltalk.
   
   Moreover, Brouwer thought this dialogue was a mental activity,
   which has been interpreted as suggesting Intuitionism was a
   solipsistic view of Mathematics. But thinking about `proof assistant`
   as a participant in the dialogue gives a fresh perspective on
   `Intuitionism`. One I have not seen adequately discussed, except
   perhaps [Paul Lorenzen](https://en.wikipedia.org/wiki/Paul_Lorenzen)'s
   work.

By "wandering" the links, we end up with meaningful insights which are
surprising. Each of the links are "obvious" (`Dialogue` links with
`Dialogue with computer` and vice-versa, `Intuitionism` discusses "_a priori_ 
Intuition of time" and so it links with `Time`, and so on). Nothing is
surprising when making the links. _Chasing_ the links produces
insights.

That's the "serendipity" of the Zettelkasten. Consequently, the
"essence" of Luhmann's Zettelkasten can boil down to two essential
ingredients:

1. Permanent ID numbers for notes (where each note discusses one idea), and
2. Links/references using those permanent ID numbers.

It takes some experiment (trial-and-error) to figure out "how much"
writing constitutes "one idea". 

## Special Cases Calling for Links, Back-Links

### Generalization of Existing Concepts

I wrote my Zettelkasten as if it were an intelligent-but-ignorant
undergraduate who didn't take much math in secondary school.
Consequently, I introduced linear algebra in multi-staged, cyclical
manner: elementary linear algebra tries to solve systems of equations.
When I wrote it, my colleague only knew elementary algebra (there are
numbers, variables, and functions...oh, and we pretend there is a
"number" called "i" which is the square-root of negative one). When I
defined a vector space in this setting, it was restricted implicitly to
be over the real numbers.

Later, in my discussion of intermediate linear algebra, this would
roughly correspond to the "first genuine undergraduate math course". I
introduced a notion of a "field of numbers", and then a "vector space
over a field". In a remark to the definition of a vector space over a
field, I remarked how it generalizes our earlier notion (linked back to
the earlier notion), and discussed how.

Then, I went back to the earlier definition of a vector space, and at
the bottom write in parentheses "(This is generalized to other number
systems later `<link>`". I **did not** close the parentheses, because I
had the foresight to realize I would generalize it further to "modules
over rings", but it would be entirely valid to have closed the parentheses.
