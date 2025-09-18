---
layout: post
title: Tutorial on CWEB
use_math: true
quote: "Life seems to go in letter writing, and I'm beginning to think that the proper definition of 'Man' is 'an animal who writes letters'."
quoteSource: Lewis Carroll, <i>The Letters of Lewis Carroll</i> vol. II p.663 (1979)
tags: [Literate Programming]
---

This is a tutorial on using CWEB to take a pre-existing C program or
code base, and transform it into a literate program. Specifically with
the goal of _reading_ a program, so this translation process is part
of "active reading".

Wayne Sewell's _Weaving a Program: Literate Programming in WEB_
discusses this as well, but for Knuth's earlier WEB toolkit instead of
CWEB. 

The basic idea with CWEB is that you will be writing a program in a
CWEB file (ending in `.w` file extension). This will be an amalgam of
prose written in plain TeX, and code written in C.

For an example of the result of this process, see, e.g., my [literate MoscowML](https://github.com/pqnelson/literate-mosml).

# Basic Terminology and Markup of CWEB

Before continuing on, I want to review the terminology and markup used
by CWEB. We will deviate slightly from what is found in the CWEB
manual.

All the markup commands begins with a `@` character. If you want to
write `@` for some reason, then you need to write it twice `@@` for
CWEB to interpret it as such.

**Concept 0: CWEB files.**
CWEB files are written as plain text in a file with a `.w` file
extension. 

**Concept 1: sections.**
You will be working in discrete units of writing called
**"sections"**, which are numbered paragraphs. A section consists of:
1. A text part, written in plain TeX, which is commentary about the
   code; and
2. A code part, which is the actual C code.

You can have a section which consists just of text but no code. You
can have a section which consists of code but no text.

A section starts by writing `@ ` on a new line. The space after the
`@` is important.

Named sections have a bold sentence after the paragraph number and they do not start with `@ `, but instead `@* `. These can
form a hierarchy: `@** ` starts a "part", `@* ` starts a section, `@*1 `
starts a "subsection", `@*2 ` starts a "subsubsection", and so
on. Note that:
1. `@*` is a synonym for `@*0`
2. Only `@**`, `@*`, and `@*1` starts on a new page.
3. These appear on the table of contents differently, but look the
   same to the reader of the PDF.

**Concept 2: code part.**
The code part begins in one of three different ways:

1. You can have a "named code chunk", which usually starts on its own newline
   as `@<Name of code chunk@>= ...`. This is useful for grouping "a
   bunch of statements" together "as if" they were a single statement.
   You can insert the contents of a named code chunk in **any** other
   code chunk by inserting `@<Name of code chunk@>`. Think of this as
   macro expansion: CTANGLE will just copy/paste the contents of the
   named chunk wherever it is used.
   
   Note: if you have multiple named code chunks with the same name,
   spread across multiple sections, then CWEB interprets this as
   "continuing the same named chunk".
2. In CWEB, you can specify the `.c` or `.h` file "as if" it were a
   named code chunk (for the purposes of starting the code chunk) by
   writing `@(my_c_file.c@>= ...`. This is useful for projects with
   multiple code files.
   
   Like named code chunks, if you have multiple `@(my_c_file.c@>= ...`
   spread across multiple sections, then CWEB will just append later
   instances onto the original.
3. You can **continue the previous code chunk** by writing `@c `.
   
**Concept 3: including multiple files.**
You can spread out the discussion into multiple CWEB files, and
include them in a "master index" file (say `main.w` --- sometimes it
is useful to name it after the program studied, e.g., if we were
studying SQLite, then `sqlite.w`). Schematically,
this looks like: 

```
@i chapter0.w

@i chapter1.w

@i chapter2.w

% etc...

@** Index.
```

**Concept 4: indexing.**
You can add entries to the index by writing `@^New index entry@>`
(usually best to place these on a new line), or if you want to format
it specially `@:Sort key}{Printed key@>` where the `Printed key` may
contain arbitrary TeX macros.

Actually, now that we are on that topic, you should remember to
conclude your `main.w` file with `@** Index.` since CWEB (when
extracting the TeX) will just append the index to the `.tex` file.
Adding this `@** Index.` will cluster the index entries to a named
section.

# Carving up a program

Now you should have the basic idea of what CWEB markup looks like, if
you are going to take an existing program and translate it into CWEB,
then the basic steps look like the following:

0. Getting started
   0. Pick an object of study, i.e., a program you want to transcribe
      into CWEB. We will call this "the object program".
   1. Create a new directory somewhere for your CWEB translation and
      commentary, say `~/lit/`.
1. Copy/paste a file's contents
   1. Pick a `.c` or `.h` file in the original program being studied, 
      say `foo.c`.
   2. Create a corresponding `~/lit/foo.w` file for the translation and
      commentary.
   3. Copy/paste the contents of `foo.c` into a section `@ @(foo.c@>=`.
      Some people prefer to have a "skeleton" or "template" for C files
      like 
      ```
      @ @(foo.c@>=
      @<Include header files for {\tt foo.c}@>
      
      @<Code for {\tt foo.c}@>
      
      @ @<Include header files for {\tt foo.c}@>=
      
      @ @<Code for {\tt foo.c}@>=
      % copy/paste everything here
      ```
      and then moving the `#include` directives to the relevant code chunk.
2. Break up the file from one CWEB section into multiple CWEB
   sections.
   0. You should have one giant named code chunk at this point. That's
      unfortunate. We will break it up into multiple code chunks.
   1. For each function in the C code, insert before it `@ @(foo.c@>=`
      so the function appears in a separate section. Go through the
      entire file and do this.
   2. Return to the top of the file. If you want, you can separate out
      the headers included into their own section or not.
   3. If a structure is defined in this file, they should be separated
      out into their own section.
   4. If global variables (or static variables) are defined in this
      file, they may warrant their own section.
3. For each function in the file, break up each function into named
   code chunks.
   1. Personally, I strive to break up a function into not more than 4
      statements and named chunks. (Working memory seems to be best
      for not more than 4 things.)
   2. Sometimes it's easier to just find "natural" grouping of
      code. For example,
      ```c
void digest_results(void *results, size_t result_size) {
  /* stuff */
  for (int i = 0; i < result_size; i++) {
          /* code to validate the results */
  }
  /* more stuff */
}
      ```
      It would be natural to carve out the loop into a named code
      chunk like `@<Validate results for digestion@>`, even though
      that might be part of a larger code chunk `@<Check soundness of results@>`
      (or whatever)
4. At this point, you should have a better understanding of the code
   than before. It may even be far more readable than initially. Now
   you should write annotations in TeX.
   1. You may want to group the file's contents into a section, in
      which case it should be given a section name at the very top of
      the `foo.w` file and a summary of what's going on.
   2. Some projects in C have historically grouped **all** their data
      structures into one giant header file, and the implementation of
      each data structure's operations appear in separate files. 
      
      You
      may want to move the data structure definition to the `.w` file
      containing the implementation of the operations for the data
      structure. This minimizes the distance between definition and
      usage for the reader, making it easy to remember (and/or
      consult) the definition.
      
      Similarly, some people have a `.h` file for each `.c` file, to
      contain the public facing functions. You may want both of them
      to reside in the same `.w` file.
   3. The commentary should be more than a "play-by-play" of the
      code. I could give vague platitudes like "Focus on the 'why' not
      the 'how'", but that would not help anyone. You're doing this to
      study the source code, so ask yourself what would help "Past You"
      understand the code better/faster and write that down.
   
Note that in practice, steps 3 and 4 are mixed together, since you
tend to gain a better understanding of a function as you break it up
into named code chunks.

# Extracting the TeX

Now you can extract the `.tex` file using CWEAVE. A crude Makefile
would look like:

```Makefile
FILE=main
WEAVE=cweave
TEX=pdftex

all:
	$(WEAVE) $(FILE).w - $(FILE)
	$(TEX) $(FILE)
	$(TEX) $(FILE)
```

This means running `make` will generate the PDF for the commentary
with prettyprinted code.

At this point, you should comfortably enter a loop transcribing the
code, carving it up, annotating it with commentary, and producing a
PDF. 

Extracting the code is also possible, but it will produce mangled
(nearly unreadable) code. You would just use `ctangle`, but that's
probably best left for another day.

# Suggestions and Tips

## Use TeX Macros

In your `main.w` file, the first line should be `\include{macros}`
which allows the extracted TeX to use the definitions found in
`macros.tex`.

It's useful to have your own tex macros for a variety of reasons.

For example, you could support a "poor man's LaTeX" with:

```tex
% The use of `\bgroup` and `\egroup` is to make the static site
% generator happy, you can replace them with braces
\def\texttt#1{\bgroup\tt #1\egroup}
\def\textbf#1{\bgroup\bf #1\egroup}
\def\textit#1{\bgroup\it #1\egroup}
\def\textsl#1{\bgroup\sl #1\egroup}
```

There are ways to support environments, etc., but you might want to
build the macros as they are needed. For including diagrams, consider
using [Metapost](https://tug.org/docs/metapost/mpman.pdf), and then add a line:

```tex
% macros.tex
\input{epsf}
```

Then you can use `\centerline{\epsfbox{path/to/image.eps}}` to include the graphics.

## Inline code

If you want to use an "inline code snippet" (e.g., "First, we want to
look at the `inode_bitmap` table for the entry."), then you can delimit
the inline code snippet with `|...|` (so we would write, `First, we
want to look at the |inode_bitmap| table for the entry.`)

## Name code chunks as commands

Most of the named code chunks will be used in functions. For such
named code chunks, use imperative commands: "Sort the array", "Search
for needle in the haystack", "Lookup the inode", "Yield to the next process",
etc.

The only exception to this rule would be if you choose to provide a
"skeleton" or "template" to a file like

```
@ @(file.c@>=
@<Include headers for {\tt file.c}@>@;

@<Functions for {\tt file.c}@>@;
```

Personally, I don't like such an approach, since it doesn't clarify or
illuminate anything.

## Using code chunks as commands

Sepifically, this means that they should end in a semicolon when used
as a command:

```
void sort(void *array, (int)(*compare)(void*,void*)) {
  @<Sort the left half of the array@>;
  @<Sort the right half of the array@>;
  @<Merge the two sorted halfs together@>;
}
```

## Use C Macros to clarify expressions

The original WEB introduced macros (since Pascal did not have macros)
to clarify expressions. C has macros, so you can use them to clarify
expressions. 

Depending on how complicated the expression is, you can use a named
code chunk. For example,

```
@ This is a typical function.

@c
void do_stuff(char *string, size_t str_size) {
  if @<Invalid input |string|@> {
    @<Handle invalid input |string|@>;
  }
  @<Default case for the function@>;
}
```

The `@;` is used as a "phantom semicolon", telling CWEAVE to format
things "as if" it were a real semicolon.

# Limitations of CWEB

## C Style imposed upon us

Note that CWEB imposes the following style upon us: we cannot use
`struct Foo` as a type in a function parameter (since CWEB expects
`struct` to appear only when defining a structure). So you need to do
the following: 

```c
typedef struct {
  /* ... */
} Foo;
```

For structures like linked lists which need a pointer to the structure
being defined as a field, we remind the reader that the following is
valid (which is what Knuth does):

```c
typedef struct LinkedList {
  struct LinkedList *cdr;
  int car;
} LinkedList;
```

Or even something like:

```c
/* in the header file, or wherever */
typedef struct LinkedList LinkedList;

struct LinkedList {
  LinkedList *cdr;
  int car;
}
```

## Maximum number of sections

The CWEAVE program, which extracts a `.tex` file from CWEB files, has
a builtin maximum number of sections (2000 by default, texlive
increases this to 4000). If you want/need more sections, then you will
have to modify CWEAVE section 17 `#define max_sections 2000` to, say,
`#define max_sections 65535` and recompile CWEAVE.

Furthermore, CWEAVE uses an unsigned 16-bit number
to track the current section number, which means it can handle 65535
sections at most (in theory). Even if you number every individual
paragraph, this should be sufficient for most novels.

But if you wanted **even more**, then you can either (a) change
section 3 of CWEAVE modifying the
definition of `typedef uint16_t sixteen_bits` to 
`typedef uint32_t sixteen_bits`, or (b) add to section 3 of CWEAVE the
`typedef uint32_t thirty_two_bits` and modify the declaration in
section 10 of `extern sixteen_bits section_count;` to `extern
thirty_two_bits section_count;` (and possibly a few other changes
somewhere). 

This would give you a maximum limit of 4,294,967,295 (more than 4.29
billion) numbered sections. Even if you made each word its own
numbered section, this would suffice.

But you should only really cross this bridge when you get there. TeX
the program needed 1380 sections.