---
layout: wiki
title: Zettelkasten
published: true
date: 2021-01-31
parentURL: /wiki/note-taking/
---

# Workflow

**Step 0: Read the Book.** (Or article, or whatever.)

**Step 1: Take reading notes.** As you read, take notes in your own words.
I typically write this down on a quarter slip of printer paper (4.25
inch wide, 5.5 inch tall). Write only on one side of the paper, the
other side has the bibliographic information (author names, book/article
title, publisher, chapter or volume number, sections read, date
published, and then near the bottom the date I read it). I also use blue
highlighter to mark the side of the slip.

These reading notes will be stored in a shoe box. They form the basis
for all my permanent notes, my entries in the Zettelkasten.

**Step 2: Go for a walk.** Or cook a meal, or do somehing else, and let
the reading percolate for an hour or two (or more).

**Step 3: Write permanent notes.**
Using a quarter-slip of printer paper (5.5 inches across, 4.25 inches
tall --- approximately an A6-sized piece of paper using "landscape"
orientation), I usually write a terse summary or topic phrase on the
top-right corner. There is an ID written in a later step, written in the
top-left corner (more on that in a minute).

I write in a manner similar to "Twitter threads", i.e., a sequence of
atomic ideas. While writing slips, I can consult notes from step 1 or
previously written slips in my Zettelkasten. If I need to reference or
"link" to entries already existing in my Zettelkasten, I use red ink to
write in parentheses after making the connection explicit.

But it is very important that each slip has exactly one atomic idea, not
two, not three, not more than exactly one.

These will be stored in a separate shoe box, **not** the bibliography
shoe box. This separate shoe box (either metaphorical or literal) is
referred to as the Zettelkasten.

**Step 4: Continue or integrate.**
If I have finished a chapter in a book, section in a technical paper, or
maybe a section in a book, and I have assembled slips based on reading
the chapter, now I assign IDs to the slips. And if I have not finished
the section or chapter, I basically go back to step 0.

I also usually have some "guiding question" in mind which filters the
literature down. For example, right now, I am (a) trying to articulate
further the foundations of mathematics using set theory, and relatedly
(b) trying to explain to my Zettelkasten what "model theory" is in
general.

Adding notes to the Zettelkasten allows me to spark questions a
hypothetical intelligent colleague would ask, if this Zettelkasten were
the contents of my colleague's brain.

**Step 5: Store reading notes.**
I take a blue highlighter and across the "outward facing spine" draw a
blue line, then place the reading notes in a shoe box (or other storage
container exclusively for reading notes). The reading notes are
organized by author, year, title.

The IDs are more-or-less faithful to Luhmann's Zettelkasten. I have
top-level topics. For me, the first four top-level topics are based off
of what I am interested in at the moment, and they are:

1. Zettelkasten
2. System and Method
3. Computer Science
4. Mathematics

I then have sub-topics. These are organized as a thread "within" a
top-level topic. For "System and Method", the sub-topics I have are:

- 2/1 System
- 2/2 Method
- 2/3 Language

At times, I want to go further on a topic discussed on a card. I use
alphabetical letters appended to the ID to indicate a branch has
occurred. The ordering of branches is insignificant and could be
permuted. "System and Method" has sub-topics and branches:

- 2/1 System
- 2/1a Component [branch off of 2/1]
- 2/1b Environment [separate branch off 2/1]
- 2/1c Interaction [third branch off of 2/1]
- 2/2 Method
- 2/2a Scientific Methods
- 2/2b Method as Generalized Inference
- 2/2c Method as System
- 2/3 Language
- 2/3a Formal Language
- 2/3b Pattern Language
- 2/3c Language Game

Each branch itself is self-similar to a top-level topic, in the sense
that it starts a thread with numbers starting at 1 appended to the ID.
These, in turn, can have branches (which appends an alphabetical letter
to the ID number). For example,

- 2/2 Method
- 2/2a Scientific Methods
- 2/2a1 Empricism
- 2/2a1a Evidence [a branch elaborating something mentioned in 2/2a1]
- 2/2a1a1 Admissibility of Evidence [like top-level topics, this forms a thread]
- 2/2a1a2 Types of Evidence [another entry in the thread for branch 2/2a1a]
- 2/2a1a3 Absence of Evidence [continuing the thread for branch 2/2a1a]
- 2/2a1a4 Evidence of Absence
- 2/2a2 Popperianism [continuing the thread for branch 2/2a]
- 2/2a3 Paradigms [another thread in the 2/2a branch]
- 2/2a4 Research Programmes [and another]
- 2/2b Method as Generalized Inference
- 2/2b1 Rewriting rules
- 2/2c Method as System

The first topic, "Zettelkasten" is about the conventions I am trying to
adhere to when writing slips for my Zettelkasten: what color ink to use,
how to link two slips together, common patterns I've developed to
present information, etc.

The real strength is in linking slips from different fields together.
For example, "operational semantics" is a slip talking about how we can
give meaning to a programming language (basically, through an evaluation
relation presented as a bunch of inference rules). But it is how we give
meaning to one major foundations of mathematics, type theory. The other
major foundations of mathematics, logic, uses proof theory...which is
related to operational semantics. So I link the two together, noting for
operational semantics we have a proof system, then in red ink write
"(4/1c3)" [the ID number for proof theory]. Sometimes I write
"backlinks" (e.g., in this case, on the slip for proof theory, in the
lower left corner I would write in normal black ink the ID for
operational semantics, again in parentheses).

**Step 6: Use the Zettelkasten.**
If we adhere to the "Write one idea on a slip of paper, but no
more"-rule, then the Zettelkasten gives us fertile material to consult
when writing a paper. I take out the thread on a given topic, and look
at linked material, possibly taking them out as well, then I sit at my
desk, and write in pen on paper whatever comes to mind as I review the
topical material on these slips of paper.

I found, sadly by error, if I wrote too much on a slip, it leads to
worse writing. (I had too much content on my Zettel for "Formal
Grammar", and I believe my draft subsection on formal grammar suffered
because of this.)

# Choice of ID Numbering System

There are any number of ID numbering systems one could use. This
requires great consideration, and probably is the most subjective part
of the system.

## Directory/file metaphor

After further reading, I realize that Luhmann's IDs can be written in
two halves `<top-level-part> / <thread-part>` where:
- `<top-level-part> = <number> | <number> . <top-level-part>` intuitively
  corresponds to directories (or subdirectories, respectively)
- `<thread-part> = <number> | <number> <letter> | <number> <letter> <thread-part>`
  correspond to files containing one atomic idea.

I've written my notes using this method since starting to collate my
notes on math. The top-level part (or a fragment of it) looks like

1. Zettelkasten
2. System and Method
3. Computer Science
4. Symbolic Math
   1. Elementary Algebra
   2. Differential Calculus in Single Variable
   3. Integral Calculus
   4. Series
   5. Vectors
   6. Multivariable Calculus
   7. Vector Calculus
5. Abstract Algebra
   1. Linear Algebra
      1. Elementary Linear Algebra (start with systems of equations,
         then matrices, discusses a lot of matrix algebra, then vector
         spaces)
      2. Intermediate Linear Algebra (start with field axioms and the
         abstract definition of a vector space, then linear
         transformations & operators, etc.)
   2. Category Theory
6. Analysis
   1. Real Analysis
   2. Complex Analysis
   3. Fourier Analysis
   4. Partial Differential Equations
7. Geometry and Topology
8. Foundations of Math
   1. Naive Set Theory
   2. First-order logic
   3. Axiomatic Set theory
   4. Type theory
   5. Higher-Order logic

# Patterns

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