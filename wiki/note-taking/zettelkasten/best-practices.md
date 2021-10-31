---
layout: wiki
title: Best Practices - Zettelkasten
published: true
date: 2021-11-31
parentURL: /wiki/note-taking/zettelkasten/
---

# Patterns

## Species of Slip

There are different "species" of slips in the Zettelkasten, and this
varies person to person. For example, Luhmann had
[hubs](https://zettelkasten.de/posts/zettelkasten-hubs/) which served as
a sort of "table of contents" --- it lists links to relevant ideas/slips.

We could easily imagine, for a truly huge Zettelkasten, the usefulness
of hubs, and _hubs of hubs_. Quite a bit of hubbub may be avoided in
this manner.

### Math Specific Slip Species

My Zettelkasten is mostly mathematics and physics (and other hard
sciences). Consequently, there are several "mathematical registers"
which one may expect to find in a math text:
- Definition
- Theorem, proposition, lemma, corollary
- Proof
- Remark
- Example

The label of a slip includes this (e.g., "Defn: Lie Group",
"Ex: SU(3) [Lie Group]", "Thm. Closed Subsets of Lie Group are Lie",
etc.). Proofs are just "Pf: [claim to be proven]".

### "Link" slip

There is another type of slip I've found useful: a "Link" slip. I've
used this when I need to review the salient parts of a concept, germane
to the present discussion, but don't want to get bogged down in the
irrelevant details. **Or** I have the definition elsewhere, discussed in
much greater detail, and I don't want to repeat it all, but there are
some aspects worth emphasizing again.

For example, Clifford algebras are necessary for constructing spin
representations of Lie algebras. But I have a thorough discussion of
Clifford algebras elsewhere. So I have a slip "Link: Clifford Algebras"
which reviews the salient aspects of Clifford algebras for spinor
representations, with links to the full discussion elsewhere.

Or, another example, I have a rather healthy Zettelkasten, littered with
examples of mathematical gadgets. When I define a new concept, and I
want to use previously constructed examples, I have a link back to the
existing gadget. In some instances, this turns out to be a "hub", just a
sequence of links to existing gadgets.

## Defer writing IDs while working through a text

I often have used a [binder clip](https://en.wikipedia.org/wiki/Binder_clip)
to keep in one spot the permanent notes I've written while reading an
article (or book chapter). During this period, I **do not** write an ID
number on these slips.

Once I'm done with the article/chapter, I see if I can reorganize the
permanent notes in an intuitive manner.

Sometimes (e.g., when taking notes on untyped lambda-calculus), I defer
this process until I have finished reading several sources (e.g., three
chapters from Barendregt's book, a chapter from Pierce's _TAPL_, a
couple chapters from Nederpelt and Geuver's _Type Theory and Formal Proof_).

## Write as if the Zettelkasten were an intelligent collaborator

It helps to have an audience defined when writing, and when writing
permanent notes for the Zettelkasten, treat the kasten as if it were an
"intelligent but completely ignorant" collaborator or colleague. You
need to define some background knowledge (e.g., a high school
graduate-level understanding of stuff), otherwise you end up in an
infinite regress (which is bad).

## Thread of Examples for a definition

I've noticed, for math notes, I tend to make a definition part of a
thread; e.g., `5.2/1 Def. Category` is the definition of a category.
I tend to make a branch for a sequence of examples, e.g., `5.2/1a1 Set`,
`5.2/1a2 FinSet`, `5.2/1a3 Vect`, etc.

## Structured Proofs as a Branch off of a theorem

Similarly, theorems are part of a thread, e.g.,
`5.1.1/7 Fundamental Theorem of Algebra`. Its proof is then written like
a structured proof (in the sense of Lamport):

- `5.1.1/7a` is the outline/roadmap of the proof
- `5.1.1/7a1` is the first step (if it requires justification, it is
  placed in the branch `5.1.1/7a1a` in a recursive manner)
- `5.1.1/7a2` is the second step
- `5.1.1/7a3` is the third step
- ...and so on.

If I think/find a second proof, I place it in a second branch
`5.1.1/7b`, etc. (Seldom are there 26+ alternate proofs for a proposition.)

# Anti-Patterns

"Worst practices" to avoid.

## Using the Zettelkasten (or Bibliography Apparatus) as a Database

Don't just collect slips. The goal is to make connections (form links)
between disparate topics.

## Collecting Reading Notes without writing Permanent Notes

I've found that about 75% of reading notes are used to produce final
permanent notes, but sometimes I'm in such a rush I don't write final
notes for around 25% of reading notes. This is a symptom of failing to
adhere to the method.

## Treating Blank Reading Notes as "To Read" list

This clutters up the bibliography box. Instead of storing a "reading
list" using blank reading notes, store them in a computer file or
separate notebook or something.

At worst, if your reading list grows exponentially, you'll never find
anything in your bibliography apparatus.

## Forgetting to write notes while reading

The whole point is to digest what you're reading, to re-formulate it in
your own terms, to re-describe what has been published. These should be
/condensed/ reformulations of the material. (Sometimes this is
difficult to do, e.g., in math; we need to copy the definition of
unfamiliar terms.)

Then, later, examine how it relates to what exists in the Zettelkasten.

But skipping the "reading notes" is like trying to make coffee without
grounds (or tea without leaves): you literal lack the raw material to
make the finished product.

This is undesirable for several reasons:
- It makes citation to source material hard/impossible later (causing
  plagiarism)
- It increases the likelihood of entering erroneous notes into the
  Zettelkasten, if we misunderstand the source material
- We don't spend enough time asking questions about the material's
  assumptions and framing (so we don't end up with deep thoughts)
