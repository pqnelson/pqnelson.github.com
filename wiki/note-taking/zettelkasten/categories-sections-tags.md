---
layout: wiki
title: Categories, Sections, Tags - Zettelkasten
published: true
date: 2025-01-15
parentURL: /wiki/note-taking/zettelkasten/
---

There's a lot of bad advice about "categories" and "tags" in a
Zettelkasten. I thought it'd be a good time to process these notions.

The tl;dr is: "category" is a technical term with a lot of baggage.
People misinterpret the advice "Don't use categories" as "Be
disorganized" (which is bad).
Organization is fine, sections ("folders") are fine, categories are
weird, tags make sense for electronic Zettelkastens (but tags are
weird to me).

## History of Tags and Categories

The "modern" notion of a tag appears to originate around 2003 with the (now
defunct) website
[Delicious](https://en.wikipedia.org/wiki/Delicious_(website)), which
allowed users to store bookmarks and tag them (e.g., "recipes",
"news", "programming", etc.). This was then adapted to tagging
pictures on the website [Flickr](https://en.wikipedia.org/wiki/Flickr)
around 2004. Then it metastasized to blogs and other things.
Tags are used to classify things.

The notion of a "category" dates back at least to Aristotle, but its
modern incarnation seems difficult to track down. Importantly they
have a [subsumptive hierarchy](https://www.isko.org/cyclo/hierarchy)
(automobiles are a subcategory of vehicles; humans are a subcategory
of animals; etc.). But the recent use of categories is rather
difficult to trace. They just appeared one day on blogs.

The practical difference is that a "thing" (blog post, link, picture,
etc.) can have multiple tags, but at most one category. Further, the
general consensus is that categories can form a _taxonomic_ hierarchy, but tags
are "flat" (there are no "parent tags").

Note:

1. This is not an exhaustive list of possibilities. For example, you
   could also have "sections" as a way to cluster a bunch of things
   together. A section is neither a "tag" (since a slip would belong
   to exactly one section) nor a "category" (since sections are not
   based on a subsumptive relationship). Doubtless there are other
   mechanisms you could invent, discover, or steal from other places.
2. This isn't even mutually exclusive: you can have _both_ tags _and_
   categories in blogging software, for example.

When would you use a tag or a category? There is contradictory advice,
and no general consensus. It's wildly subjective. "Follow your heart"!

## In a Zettelkasten

These notions only really make sense in a _digital_ Zettelkasten, as
an "induced" notion constructed by analogy to other digital mediums
(like blogs).

**1. Sections.** For a paper Zettelkasten, the notion of a
***section*** _could_ have some analogous incarnation with the ID
naming conventions along the lines of (in pseudo-BNF notation):

```ebnf
id = section separator slip-id
separator = "/"

section = number
         | number section-separator section
section-separator = "."

slip-id = number
        | number letter
        | number letter slip-id

nonzero-digit = 1 | 2 | ... | 9
digit = 0 | nonzero-digit
number = nonzero-digit
       | number digit
```

This, more or less, coincides with my scheme.

**2. Categories.** If you decide to treat subsections in a subsumptive
manner, then you have accidentally invented "categories" (or some
manner of hierarchy).

**3. Tags.** The only way I could imagine something analogous to a
"tag" in a paper Zettelkasten would be a card entitled with the tag
name, whose contents are just links to other slips.

(Curiously, Luhmann did something like this, according to Johan
Schmidt's "Niklas Luhmann's Card Index: The Fabrication of
Serendipity" section 5.)

Perhaps there are other ways, but I could not imagine any good
alternatives.

## Emergent Categories versus Predetermined Categories

Scott Scheper in his book on Zettelkastens instructs readers to
prepopulate their Zettelkasten with categories following a Dewey
decimal-like system. This amounts to writing slips of paper with the
category name, and an ID number, but nothing else until needed. I
refer to this style of categories as **"Predetermined"** categories.

This creates a lot of superfluous slips of paper which takes up a lot
of space, requires a lot of time, and fails to accomplish anything.
Actually, as I read it, Luhmann was critical of such an approach, but
I digress.

There are two clear alternatives:

1. Reject categories altogether. You'll find this on a lot of blog
   posts: just write random thoughts on slips of paper, throw them in
   a box, shake it up, and you'll somehow pour out magical ideas.
   
   I believe this stems from a misunderstanding of Luhmann's thoughts
   on categories.
2. Add categories only as needed, as **sections**. For example, the
   first thing I started writing about with my Zettelkasten: notes
   about the Zettelkasten method and observations from my
   experiences. Therefore, it makes sense to cluster these together,
   which is handled by prefixing these notes's IDs with `1/` to
   indicate they are all "belonging" to the topic `1. Zettelkasten`.
   
   When I wanted to write about notes related to "System and Method"
   (admittedly rather broad), these had a coherent theme distinct from
   what already existed in my Zettelkasten. Therefore, I introduced a
   new slip `2. System and Method`, as well as `2.1. System`
   and `2.2. Method`. I only did this once I wrote something about
   systems of communication, language, formal language, different
   methods of analysis and composition, and so on. They were all
   related to the same theme, but the theme did not fit anywhere in my
   nascent Zettelkasten. Thus I added a new category and two
   subcategories.

Now, Luhmann appears to have several topics firmly in mind when he
began his second Zettelkasten, but it is unclear to me whether he
_prepopulated_ his second Zettelkasten with the topics he wanted to
discuss or if he added them as needed. But this was after his
experience with his first Zettelkasten.

## Uncategorized Zettelkastens

Now, as I said, a lot of blogs vehemently argue that categories "go
against the spirit of Zettelkastens", are unproductive, or some other
similar claim. Where does this notion come from?

Luhmann writes in his [Communicating with Slip Boxes](https://zettelkasten.de/communications-with-zettelkastens/):

> Knowledge theory has given up the assumption of “privileged
> concepts” that function as axiomatic foundations to control the
> logical value of other concepts or propositions. [7] Similarly, you
> must give up the assumption that there are privileged places, notes
> of special and knowledge-ensuring quality. Each note is just an
> element that gets its value from being a part of a network of
> references and cross-references in the system.
> 
> Footnote [7]: Cf. Richard Rorty, _Der Spiegel der Natur: Eine Kritik
> der Philosophie_, dt. Übers. Frankfurt 1981, p.185 ff. [Comment by
> Sascha: Richard Rorty, _Philosophy and the Mirror of Nature_, 1979]

The footnote is missing in the [earlier translation by Manfred Kuehn](https://luhmann.surge.sh/communicating-with-slip-boxes),
and it reveals quite a bit about Luhmann's _intent_.
Luhmann alludes to the Aristotlean notion of "first principles",
propositions from which we can deduce "all knowledge" by simple logic
alone. (Coincidentally, this is what Rorty discusses at length in the
cited text.)

In this light, the discussion of "priviliged places" has a different
inflection, a meaning quite different than "using categories".

This resembles the Confucian and pre-Confucian philosophical belief
that it's critically important to pick "the right name" for things,
because the name is intimitely connected to the thing's essence in
these philosophical schools.

But we now believe that a word's meaning stems from its _usage_, as
opposed to some metaphysical connection to the essence of its
referent. This "meaning from use" implicitly stipulates a word doesn't
appear in isolation, but in a larger context (a phrase, a sentence, a
paragraph, an essay, etc.) and critically _depends_ on being within a
context.

Analogously, when we integrate new slips into our Zettelkasten, these
new slips only really gain significance ("meaning", if you will) when
we _link to them_ from _pre-existing slips_. (Otherwise, there's no
path _to_ the new slips in the Zettelkasten.) For Luhmann's
Zettelkasten, this is critical: there are some "starting points" for
investigation, and --- like a "choose your own adventure" book ---
links for follow up investigation. If there's no path from any of
these starting points to the new slips, then they form a disconnected
subnetwork, which limits their usefulness.

**This was what Luhmann was talking about in the quoted passage!**
This is widely misunderstood by people quoting it.
Unfortunately, these people have advocated a potpourri of random notes
with no categories or clustering, with no coherent sense to them. This
is a mistake, in my experience.

## "Category" has weird metaphysical implications (apparently)

People seem to think (probably from Plato's influence) that there
exists some set of categories "out there", which already exist, and we
just need to...find them? Use them? I don't know, but this is
apparently how most people think when the notion of a "category" is
discussed.

_This_ sense of "category" **should not** be used when thinking about
organizing a Zettelkasten. _This_ sense of "category" is intimitely
connected to the epistemological notion of "first principles", which
Luhmann argued against in the quoted passage.

But that ***does not*** mean, "There should be no organization to a Zettelkasten."

This is what Christian Tietze means in his (inflammatorily titled)
post [Why Categories for Your Note Archive are a Bad Idea](https://zettelkasten.de/posts/no-categories/).




