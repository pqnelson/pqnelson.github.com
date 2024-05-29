---
layout: post
title: What even is "literate programming"?
published: true
draft: false
quote: "Reading maketh a full man; conference a ready man; and writing an exact man."
quoteSource: Francis Bacon, <i>Meditationes sacræ</i> (1597)
tags: [Literate Programming]
---

There are more hot takes on "literate programming" than I'd care to
enumerate, so I'd like to focus on trying to figure out what Donald
Knuth means by the term "literate programming". What is it? When is it
useful? How do I do "literate programming"?

I try to answer these questions with what I've learned about 
"literate programming" (in Knuth's sense) over the past few years.

# Knuth's Original Intent?

I contend that Knuth originally intended literate programming to be used
for top-down discussions, combined with programming willy-nilly
(top-down, bottom-up, or any other orientation one desires).

It's important to bear in mind the context when Knuth came up with this
approach (around 1974, according to a dated letter Knuth sent de
Marneffe). Structured programming has become accepted as "the" way to
program, which brought with it top-down design as "the" way to approach
a problem. But enough time has passed since the publication of
_Structured Programming_ by Dijkstra, Hoare, and friends, to have
accumulated experience with its shortcomings. 

The appeal of top-down programming speaks for itself: we understand
things by analyzing them into components and how these components relate
to each other. But doing this in practice...well, in the 1970s, this led
to needless ritual and some code bloat thanks to the cookie-cutter
template [Harlan Mills](https://en.wikipedia.org/wiki/Harlan_Mills)
turned it into. Mills argued the top-down design was a corollary to
structured programming, so we were all forced to live with it 
_as Mills described top-down design_: carve up a program into
subprograms which were implemented as subroutines. Then iterate this
step until you've got a functioning program.

I think that Knuth wanted to retain certain elements of top-down
programming, namely the ability to decompose a "chunk" of code into
constituents and discuss the relationship between them. But without
being tied to introducing a subroutine for each constituent of a
decomposition, whether it made sense or not (as was the fad of 1970s cargo-cult structured programming).

What leads me to think along this line of reasoning is that Knuth states in the [`WEB` manual](https://tug.ctan.org/info/knuth-pdf/web/webman.pdf) that, among the influences for
literate programming,

> (3) The top-down style of exposition encouraged by `WEB` was of course
> chiefly influenced by Edsger Dijkstra's essays on structured
> programming in the late 1960s. The less well known work of
> Pierre-Arnoul de Marneffe ["Holon programming: A survey," Univ. de
> Liege, Service Informatique, Liege, Belgium, 1973; 135 pp., [eprint](https://github.com/holon-scribe/holon-programming/)] also had a
> significant influence on the author as `WEB` was being formulated.
> (4) Edwin Towster has proposed a similar style of documentation in
> which the programmer is supposed to specify the relevant data
> structure environment in the name of each submodule ["A convention for
> explicit declaration of environments and top-down refinement of data,"
> _IEEE Trans. on Software Eng._ **SE–5** (1979), 374–386, [doi:10.1109/TSE.1979.234205](https://doi.org/10.1109/TSE.1979.234205)]; this
> requirement seems to make the documentation a bit too verbose,
> although experience with `WEB` has shown that any unusual control
> structure or data structure should definitely be incorporated into the
> module names on psychological grounds.

(Note: I have added link to Marneffe's paper and DOI link to Towster's
paper for ease of reference.)

This reveals more than it may seem:

1. Literate programming focuses on top-down exposition (whatever that means);
2. Looking at Towster's article, it's clear he organizes a program using
   [chunking](https://en.wikipedia.org/wiki/Chunking_(psychology)),
   even calling the sections/nodes "chunks" which forms a tree-like
   structure, which has code as its terminal nodes.
   
The relevant part of Towster's paper seems to be from the second page:

> Every node of the tree is a "chunk" with a "chunk name" that stands
> for the declarations at the terminal nodes of its subtree. The
> programmer need not conceive of the terminal nodes before coding
> begins, only the topmost nodes of the tree, as needed to functionally
> describe the data in the topmost modules of the program. Additional
> nodes are created and attached to the tree as programming proceeds,
> with descendant nodes representing the data used in implementing the
> data structure described by their ancestor nodes. The tree is thus
> developed top-downwards (from root to terminal nodes) as the program
> is being written.

This is all well and fine, but how does someone actually write a
literate program? Knuth doesn't say, and the closest I could find is in
Wayne Sewell's book _Weaving a Program: Literate Programming in Web_
(1989) which Knuth wrote a foreward for (and so, I guess, endorsed the
strategies Sewell suggests). Chapter 3 of Sewell's book gives us
explicitly a "how to" tutorial in section 1:

- First write the problem statement as the first chunk.
- Then outline the "skeleton" of the program in the second section using
  named code chunks as pseudocode to be filled in later.
- Then do a sort of _quick sketch_ adding more named chunks of code,
  outlining the design further in commentary, and each _quick sketch_ is
  then recursively outlined using named chunks of code as a sort of
  pseudocode outline of ideas.
- Importantly, all the while, you are delaying the "write actual code"
  work as much as possible. The idea is that you are trying to get the
  design working, the problem fleshed out, and using the named code
  chunks for pseudocode.
- Rearrange the chunks into an order that makes sense for your
  reader. You have this freedom because WEB and CWEB are "order independent",
  so think hard about what makes sense for the reader to readily absorb
  your program and its structure.
- Then weave it into a PDF, look at it, make sure it makes sense and the
  program does what you want.
- Then write the code.

If this is accurate to how Knuth envisions literate programming, then I
never would have guessed it in a million years.

# Examples of Literate Programming

Knuth gives us examples of literate programming, but I want to look at
examples from other people.

David R. Hanson's _C Interfaces and Implementations: Techniques for Creating Reusable Software_
(Addison-Wesley Professional, 1996)
is often cited as one, but it is rather stale as a literate program.
The named code chunks are unimaginative boiler-plate names, like
"<Include files for `foo.c`>" or `<my_module.h>`.

David R. Hanson and Christopher Fraser's
_Retargetable C Compiler, A: Design and Implementation_ (Addison-Wesley
Professional, 1995) is another example cited as a literate program, but
it is a _post hoc_ literate program: the C compiler was written first,
and years later this commentary was built around it.

I would argue the only example of a successful literate program is Bob
Nystrom's [Crafting Interpreters](https://craftinginterpreters.com/contents.html),
and I'm not sure that Nystrom was even aware of the notion of "literate
programming" when he wrote his book. He wrote a blog post
[Crafting _Crafting Interpreters_](https://journal.stuffwithstuff.com/2020/04/05/crafting-crafting-interpreters/)
about his experience and approach. In particular, what jumps out at me
is the observation:

> After a few months, it was all there. Every single line of code for
> the entire book. A complete list of chapters. And I hadn’t written a
> single word of prose. In theory, “all” that remained was writing some
> text to explain the code I had already written along with some
> pictures. But, for me at least, English is a much more taxing language
> to write than C or Java. I had all of the difficult work ahead of me,
> and all of the fun was done.

In other words, Bob Nystrom wrote the code and the list of chapters,
revised the code quite heavily, made sure the "chapter dependencies"
were linear, all before writing any prose. This is in direct conflict
with the advice given by Meyers's book.

I was really curious about specific advice Nystrom had to offer about
literate programming, so I emailed him for any wisdom he could share
with me. The recommendations:
1. Have simple code, because the more complicated the code, the more
   complicated the explanations.
2. Avoid large-scale cyclic dependencies, minimize "forward declarations"
   of concepts. I took this to mean that ideally in chapter _N_, you
   should rely on everything from previous chapters and nothing from
   future chapters. In particular, this means you should build your
   program using bottom-up coding.
3. Explain things top/down at the chapter or section level. If you code
   bottom-up, readers don't understand why you're doing it. This
   requires explaining to them the big picture, which motivates the code.
4. Edit, edit, edit. Both the code and the prose, you can never edit too
   much.
   
Again, I never would have guessed this in a million years if I just read
Donald Knuth's articles alone.

# When do you want "literate programming"?

Tl;dr: if you want to preserve knowledge, then literate programming is a
good fit.

(There may be other cases when literate programming is a good fit, but
this is the one use-case where it definitely works well.)

The times when I have done something like literate programming boil down
to instances like numerical analysis, where I have some derivation of
the algorithm from mathematics, and that doesn't fit well as a comment.
I also don't want to throw away the derivation ("future me" may forget
how it was done).

Bob Nystrom's book is literally about preserving his knowledge about,
well, crafting interpreters.

Even the books I cited by Hanson are about preserving knowledge, either
about a particular C compiler, or about particular programming practices
in C.

Arguably, Knuth's use of WEB for TeX and Metafont was to preserve
knowledge about the intended algorithms for typesetting, to make sure
the code actually implements them.

What even made me think about investigating literate programming further
was an attempt to collate and preserve knowledge related to the
implementation of proof assistants ("theorem provers").

It's a bit of a stretch to conclude, "Therefore, if you want to preserve
some knowledge intimitely tied to your program, then use literate
programming", because we have a sample size of N=4 or so. But it is the
only commonality they all share.

But now that I'm thinking about it, in my post on 
[retrocomputing project ideas]({% post_url 2024-05-26-retrocomputing-projects %}),
the ideas where I asked to write a blogpost series or book about it, well,
that was because it was preserving some kind of knowledge. Many of those
ideas were natural candidates for literate programming (in my mind as I
wrote it).

# Problems with Literate Programming

All problems with literate programming boil down to the trade-off
between pedagogy and programming.

When programming, it's not uncommon to write a function that's "good
enough for now", and revise it later. This is impossible to adequately
do in literate programming. It happens a lot more with explanations, and
you see this in _Crafting Interpreters_ where Nystrom refactors portions
of code into new functions. This is impossible to adequately do in
Knuth's WEB (or CWEB) approach.

Unit testing is not supported one bit in WEB, but you can cobble
something together in CWEB. I have a hard time imagining writing a
program without any unit tests at all, but it "goes against the grain"
of literate programming. This is probably something more to do with
Knuth's personal philosophy than literate programming as a whole. We
could easily imagine a situation where TDD is used in literate
programming, the tests are written before the function, and so on.

Explaining what you're doing is hard, in general. Asking programmers to
explain what they're doing is hard (because _giving explanations_ is hard). 

With git, some have adopted the convention to have a one-line summary
for the changes, and then provide quite a bit of context for the changes
in the commit log. This defeats the purpose of literate programming
quite a bit (the explanations are there, in the commit!). But revisions
to a literate program were seen by Knuth as analogous to _errata_ for a
book (there are "changefiles" for WEB programs which are modeled after
_errata_), which is farthest from the contemporary usage.

Probably the biggest hindrance to literate program today is that no one
cares about preserving knowledge. Silicon Valley tech-bros don't care
about the humanities and believe that knowledge could never be lost
(and, even if knowledge were lost, who cares anyways?).

# How to write a literate program?

The big unresolved question I have lingering on my mind is: 
_How do I write a Knuth-style literate program?_

This is hard, because it boils down to 
_How do I write well in computer science?_

Here's one strategy:
You pick your audience (usually a programmer competent in whatever
programming language you are using), you state your problems, you state
the solutions, and then you implement it. Easy, right?

"State the problem" itself is a struggle, unless it's a well understood
domain. Entire papers have been dedicated to stating a problem, and
refining the problem statement.

"State the solution" simplifies the discussion of design decisions, the
tradeoffs considered and weighed, the different alternative
solutions. Again, entire books have been written on this subject
_just for sorting_. And we're assuming that the design space is well
understood enough for entertaining a discussion, sometimes we just have
a few possibilities which are later viewed as "entirely the wrong way to
look at things".

But we're getting ahead of ourselves, we'll find that even picking the
tool and organizing our content are highly nontrivial affairs.

## Picking your tool

It depends on your programming language.
- If you're writing in Pascal, then WEB is probably the best tool to help
  write a literate programming
- For C, use CWEB
- For anything else, I suppose use NOWEB.

The difficult that crops up is there are so few tools for literate
programming that you may have to roll your own. (Dare I say, you could
write a _literate program_ for literate programming?)

This forces you to consider your writing style. Knuth originally
intended writing a linear sequence of (a) code chunks with optional
commentary, and (b) commentary without code chunks ("propositions"?).
This was enumerated for ease of reference, but it makes for awkward
reading nowadays. Is this still the best way to organize a literate
program? 

What about pretty printing and syntax highlighting? Knuth took heavy
inspiration from the ACM's typesetting of ALGOL for prettyprinting code
chunks. Is this still wise? What about modern conventions using
different colors for keywords, and teletype font for the code? What
makes more sense now?

I don't know, there's an argument for thinking of a program along the
lines of an extension to mathematics (so variables would be italicized,
for example, as in mathematics). But you need to dedicate serious time
to pondering it, and the only way to really make progress is by
experimenting with examples.

## Organizing your content

As I mentioned with picking your tool, organizing your content is half
the battle for writing _in general_. Paul Halmost once remarked (as
dutifully noted in Knuth and friends's _Mathematical Writing_) that the
two anchors for a writer are:
1. Do organize your material.
2. Don't confuse your reader.

In mathematics, we can organize our material as a linear sequence of
enumerated propositions, definitions, examples, theorems, and
remarks. Charles Wells called this the "labeled style" of mathematical
prose. It works well in mathematics, but it is viewed as old-fashioned
now (Euler did it, Arthur Besse did it, but even Bourbaki abandoned this
style).

Can we add to the "species" of enumerated propositions something like a
"code chunk" and call it a day?

I think this is what Knuth does in his _Art of Computer Programming_. 
The "Algorithm" environment acts as an extended discussion and
commentary for parts of the assembly code, which are presented in the
"Program" environments.

But is this the best way when you carve out "subchunks"? Wouldn't it
make sense to write something like:

> **27. Parse expression.** We check that we have a valid token, then 
> work through a trie. But we just skip whitespace and comments, since
> they don't affect the AST. We initially try guessing the token is a
> number, then fallback to a reserved keyword, and when all else fails we
> call it an identifier.
>
> ```rust
> fn parse(&mut self) -> Token {
>     <Check for errors>
>     <Skip whitespace and comments>
>     <Try parsing for a number>
>     <Try parsing for a reserved keyword>
>     <Default to an identifier>
> }
> ```
>
> **27.1. Checking for errors.** [Note the number is now reflecting this
> is a "subchunk" of item 27.] We do the following: blah blah blah...
>
> ```rust
> // code for error checking omitted
> ```
>
> **27.2. Skipping comments and whitespace.** [Again, this is the second
> constituent to chunk 27, so it is numbered 27.2] This boils down to
> skipping whitespace, then checking if we have a comment. If we encounter
> a comment, skip it until the end of the line, and try skipping
> whitespace again.
>
> ```rust
> while self.skip_whitespace() && self.skip_comment() {}
> ```
>
> **27.2.1. Skipping whitespace.** This needs to be a Boolean-valued
> function, and it's straightforward.
>
> ```rust
> fn skip_whitespace(&mut self) -> bool {
>     let mut result = false;
>     while self.advance().is_whitespace() {
>         result = true;
>     }
>     return result;
> }
> ```
>
> **27.2.2. Skipping comments.** If we encounter a comment, we skip to the
> end of the line.
>
> ```rust
> fn skip_comment(&mut self) -> bool {
>     let result = self.is_comment();
>     if result {
>          self.skip_to_end_of_line();
>     }
>     return result;
> }
> ```
>
> **27.2.3. Skipping until end of line.** We skip everything until we get
> to a newline character. This will be consumed by the `skip_whitespace()`
> function in the next iteration, which will handle updating the line
> counter in the `advance()` function.
>
> ```rust
> fn skip_to_end_of_line(&mut self) {
>     while '\n' != self.peek() {
>         self.advance();
>     }
> }
> ```

This is all pidgin code, but the organization is there: these are all
elucidating steps in a particular function defined in chunk 27. Does
this make it more or less readable? Are we being merciful or cruel to
the reader?

There is a certain logic to this organizational scheme of subchunks, but
it requires putting a pause on working through the rest of the chunk 27
(which strains the reader's attention considerably). And the code is so
self-documenting, do we really need 27.2? Couldn't we just insert that
into the code directly?

Is there a limit to the "depth" of subchunks? While writing 27.1, 27.2,
27.2.1, 27.2.2, all seem fine, what about 27.3.1.1.1.1.1.1? Where is the
line drawn between ease of organization for the author, and ease of
reading for the reader?

These considerations should be seriously weighed, but are obviously
orthogonal to programming.

**Remark.** In general, it appears that anything beyond a depth of three
or four numbers is too much for humans to juggle. This is why Knuth's
_Art of Computer Programming_ limits itself to a depth of 4, why Alan
U. Kennington's [Differential Geometry Reconstructed](http://www.geometry.org/tex/conc/dgstats.php) limits itself to
a depth of 3. (End of Remark)

## Writing the code first or last?

I believe Bob Nystrom wrote the code for _Crafting Interpreters_
hand-in-hand with the outline of the book, revised the code and outline
iteratively, and once the code was finished _only then_ did he start
the prose, then iteratively revised the code and the prose. He made it
work. 

David Hanson and Chris Fraser wrote the code first, then hastily
assembled prose around it. In Hanson and Fraser's C Compiler book, there
are portions where the authors admit to forgetting why certain portions
of the code were the way it was, stating that the time lapse between
coding and exposition was quite a while, and only vaguely recalling a
bug on SPARC architectures.  I don't think Hanson and Fraser enjoyed the
same degree of success as Nystrom.

Wayne Sewell wrote the prose and design first, editing this, iterating
these two steps until it was satisfactory. The code was written last.
Perhaps this works well, perhaps not, but it earned the endorsement of
Donald Knuth.

The key step in writing is _rewriting_ (arguably this is true for
writing as well as programming), which is difficult to do with literate
programming. The commentary could become stale and/or irrelevant if you
write the prose first (as Sewell suggests). So you either have to write
the code first, or you have to iteratively design little-by-little as
Sewell recommends.

The goal in writing is to write for the reader. This is hard even under
the best circumstances. Rewriting literate programs enjoys the worst
aspects of both rewriting prose and rewriting code. We seldom see people
blend prose with code because it's hard to pull off successfully.

This is because you need to revise **both** the code and the prose
simultaneously, which is difficult to juggle. Otherwise you end up with
_post hoc_ explanations (like Hanson and Fraser published) or
unmotivated code with unseemly kludges.

# What are you trying to do?

This is the question which you should really be asking yourself when
considering literate programming as a solution, because it's the
question to be asked when looking at any proposed solution. What are you
trying to accomplish?

Doubtless the answer is to write something worth reading, but are you
really going to need it?

If you really think you need literate programming, then experiment with
it. Write a "small vignette" with different styles. Implement a simple
data structure (a weight-balanced tree?), try doing so in as many
different styles as possible.

The difficulty is that you are writing _for a reader_, not for your own
edification. What clearly communicates the concepts as well as the code?
Could _you_ reproduce your code in a different language after reading
your literate program? If not, you probably have not succeeded in
writing a literate program.

You're going to fail, and that's normal. You just need to exhaust the
space of failure in new and different ways, until you're doomed to
succeed.

Even then, the techniques you've acquired may not generalize to
other situations. Writing a literate program for an interpreter in C is
quite different from, say, writing a literate program for an optimized
implementation of BLAS [a standardized linear algebra library] in
assembly code.

**Remark.** Writing assembly code used to be an art back in the
1950s. Good assembly code had a running commentary explaining the big
picture of what was going on. You can see examples of this in Knuth's
_Art of Computer Programming_, when he uses MIXAL it is exemplary
assembly code from the 1950s. This is completely different from writing
good C or Java or Julia. So the choice of programming language greatly
impacts what literate programming looks like when you weave it into TeX,
that is, when you present it in human readable form.
(End of Remark)

But this seems to be the real strategy behind learning how to write a
literate program: figure out a small sample of the sort of program
you're going to implement, exhaustively try as many different ways to
write a literate program for your small sample problem, and keep failing
as differently as possible each time.

# Closing Remarks

Like any tool, there is a time and place for using literate
programming. Unfortunately no one really knows when and where this would
be useful.

For myself, my interest has stemmed from trying to write a literate
program for expository purposes, for preserving knowledge which is on
the verge of being lost. This began before Kevin Buzzard starting
hawking Lean like a used car salesman, before this cargo-cult thinking
seeped into the mathematical community, before being incorrigible and
loudly-and-proudly-ignorant became admirable instead of despicable. Now
it seems pointless to write such a book, since Buzzard's disciples would
eagerly toss it into the bonfire --- Lean is the alpha and omega for
them, all else is heresy which must be expunged from memory and record.

But now I have a lot of knowledge I feel compelled to share, and no
identifiable outlet for sharing it. This is probably why I'm writing
this post, literate programming was part of the manuscript idea, and I
learned a lot about it (as well as other people's hot takes). Perhaps
it's a good idea, or the germ of one which just requires more
experimentation. Someone may wish to learn more about it, and it'd be a
shame to hide what I've learned.

W. Somerset Maugham once allegedly quipped, "There are three rules for
writing a novel. Unfortunately, no one knows what they are." The same
could be said for literate programming. The successful examples of
literate programming all followed contradictory rules (e.g., "write the code
first", "write the code last") and even following the same dictums lead
to drastically different outcomes (compare Hanson & Fraser with Nystrom).

Perhaps there is no royal road to literate programming, you just need to
be honest enough to identify when your writing fails, and the courage to
start over with a clean rewrite.