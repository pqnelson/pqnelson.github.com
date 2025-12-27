---
layout: post
title: Poor Man's LaTeX
use_math: true
quote: "Yes! in the poor man's garden grow,<br>
Far more than herbs and flowers,<br>
Kind thoughts, contentment, peace of mind,<br>
And joy for weary hours."
quoteSource: Mary Howitt, <i>The Poor Man's Garden</i> (1871)
tags: [LaTeX]
---

**Problem:** I want to write some manuscript in LaTeX, but I am
worried about its longevity. (Try compiling a LaTeX file from the
early 1990s, or even using some popular packages from a decade ago,
and you'll experience a lot of breaking changes.) How can I insulate
myself from these pain points?

**Solution:** Implement an approximation of LaTeX in plain TeX (a
"[poor man's](https://www.merriam-webster.com/dictionary/poor%20man's) LaTeX"), since plain TeX is built with longevity in mind.

**What is this page about?** This is a review of the "major
components" of the [implementation.](https://github.com/pqnelson/Poor-Man-s-LaTeX)

## Poor Man's LaTeX

### Toggling "@" as a letter

The first macros we need allow us to toggle `@` as a "letter" or as an
"other" character.

The rest of the implementation will treat `@` as a letter.

```tex
\def\makeatletter{\catcode`\@11\relax}

\def\makeatother{\catcode`\@12\relax}

\makeatletter
```

### Testing if a macro is undefined

This is a common enough occurrence that LaTeX has provided an
`\@ifundefined{test}{true-branch}{false-branch}` macro. The
implementation is fairly straightforward:

{% raw %}
```tex
\def\@ifundefined#1#2#3{%
  \expandafter\ifx\csname#1\endcsname\relax%
    #2%
  \else%
    #3%
  \fi}
```
{% endraw %}

### Macros needed for URL package

We also can implement the macros needed to call `\usepackage{url}`.

When the user invokes `\usepackage`, it's the same as `\input` after
invoking `\makeatletter`.

Ostensibly, we should "restore" `@` to be an "other" character, but
this runs into problems if you have _previously_ invoked
`\makeatletter` before `\usepackage`. The "correct" solution would be
to have a counter which is incremented each time `\makeatletter` has
been called, and is decremented each time `\makeatother` has been
called; when the counter is zero, it restores the correct catcode for
`@`. But this is too heavy weight for my purposes.

```tex
%%%
%%% Macros needed to make URL package to work
%%%
\def\@namedef#1{\expandafter\def\csname#1\endcsname} % needed for URL package
\newcount\@tempcnta % needed for url.sty

% HACK: this allows you to \usepackage for some packages
\let\protect\relax
\let\ProcessOptions\relax
\def\DeclareOption#1#2{}
\def\@makeother#1{\catcode`#112\relax}
\def\usepackage#1{\makeatletter
  \input #1.sty}
```

### Logos

There are a large number of logos in LaTeX --- things like `\LaTeX`,
`\BibTeX`, and so on. We can refer to
[`tugboat-plan`](https://ctan.org/pkg/tugboat-plain.) for inspiration
(specifically the `tugboat.cmn` file).

There are multiple ways for implementing the `\LaTeX` macro, I just
picked one which suited me. The commented out version may be more to
the reader's tastes.

I've only implemented 5 logos, I don't really need any more.

{% raw %}
```latex
\newdimen\z@ \z@=0pt % can be used both for 0pt and 0

\def\LaTeX{L\kern-.26em \raise.6ex\hbox{\sevenrm A}%
   \kern-.15em\TeX}%

\def\AMSTeX{$\cal A\kern-.1667em \lower.5ex\hbox{$\cal M$}%
   \kern-.125em S$-\TeX}
\def\BibTeX{{\rm B\kern-.05em {\sevenrm I\kern-.025em B}%
   \kern-.08em T\kern-.1667em \lower.7ex\hbox{E}%
   \kern-.125emX}}
\font\mflogo = logo10
\def\MF{{\mflogo META}{\tenrm \-}{\mflogo FONT}}
\def\MP{{\mflogo META}{\tenrm \-}{\mflogo POST}}

% hack to make \sbox work
\def\color@begingroup{\begingroup}
\def\color@setgroup{\color@begingroup}
\def\color@endgroup{\endgraf\endgroup}
\long\def\sbox#1#2{\setbox #1\hbox {\color@begingroup #2\color@endgroup}}
```
{% endraw %}

### Environments

The most important part of LaTeX, for me, is the environments --- the
`\begin{foo}...\end{foo}` macros. This requires some subtle macro-ology. 

First, we need to recall that plain TeX uses `\end` for ending the
document. So we store its current meaning in a `\@@end` macro. The
double `@` is intended to mean the macro is private, and we hope no
one will use it.

We will also need to patch the `\bye` macro to make it use `\@@end`
instead.

```tex
%%%
%%% Environments
%%%

% Redefine \bye to use \@@end, so we can redefine \end
\let\@@end\end
\def\bye{\par\vfill\supereject\@@end}
```

Now, "under the hood", LaTeX expands `\begin{foo}` into `\foo`, and
`\end{foo}` into `\endfoo`. Coincidentally, if you wanted a custom
environment in LaTeX which does something crazy with arguments, you
can accomplish it by `\def\foo#1#2#3...{...}` and an accompanying
`\def\endfoo{...}` (you always need the `\def\endfoo{...}`, even if
it's an empty `\def\endfoo{}`).

This is more or less correct, but environments also wrap its contents
in a group (so any local definitions are ignored once the environment
ends).

We also have a special `@ignore` flag to tell TeX to ignore the spaces
after the end of the environment, but let's stick a pin in the code
implementing the `\@ignoretrue` and `\@ignorefalse` macros.

```tex
\long\def\begin#1{\begingroup\csname#1\endcsname}

\long\def\end#1{\csname end#1\endcsname\endgroup%
  \if@ignore\@ignorefalse\noindent\ignorespaces\fi}
```

Then the `\newenvironment{foo}{begin foo code}{end foo code}` can be
provided, which just defines new global macros `\foo` and `\endfoo`
with their implementation being given as the second and third
arguments.

```tex
\def\newenvironment#1#2#3{ %
  \expandafter\gdef\csname #1\endcsname{#2}%
  \expandafter\gdef\csname end#1\endcsname{#3}%
}
```

We should mention the `\@ignoretrue` and `\@ignorefalse` don't use the
"default" macro for `\newif` tokens. This is dangerous _in general_,
but since we're doing it once for a specialized purpose...well, it's
not terrible.

```tex
% \newif\if@ignore\@ignorefalse does not define things properly
\def\@ignorefalse{\global\let\if@ignore\iffalse}
\def\@ignoretrue {\global\let\if@ignore\iftrue}
\@ignorefalse
```

Lastly, we also have the "primitive"
`\begin{document}...\end{document}` environment, which just wraps its
contents in a group, and then once it's done it invokes `\bye` to end
the document.

```tex
% `\enddocument` needs to have an \endgroup to fix
% "semi simple group (level 1) entered at line N (\begingroup)"
\def\document{\begingroup}
\def\enddocument{\endgroup\par\bye}
```

### Counters, labels, and references

There are three tightly coupled subsystems which we should discuss
jointly: counters (intuitively "variables which store integer
values"), labels (intuitively "macros which store the current value of
the current counter"), and references (which recalls the value stored
in a label).

In plain TeX, there are "counter registers" --- essentially variables
which are counters. These are **different** than counters in LaTeX,
which give a small wrapper around counter registers. The identifiers
used in LaTeX for counter registers are prefixed with `c@`.

We have to patch things up a little for LaTeX-style counters to work
in plain TeX, but `\newcounter{myCounter}` replicates the desired
behaviour.

{% raw %}
```tex
%%%
%%% Counters
%%%
% HACK: TeX defines "\newcount" to be outer, which breaks \@definecount
% so we just remove the "\outer" prefix
\def\newcount{\alloc@0\count\countdef\insc@unt}

\def\@empty{}

% Constructs `\cl@<counter>` which is of the form `\@elt <counter1>
% \@elt <counter-2> ... \@elt <counter-N>`
\def\@definecounter#1{\expandafter\newcount\csname c@#1\endcsname
  \setcounter{#1}{0} % initialize <counter> to zero
  % propagating effects of incrementing <counter> to "slave counters"
  % handled with cl@<counter>
  \global\expandafter\let\csname cl@#1\endcsname\@empty
  % printing the value of the counter handled by "\the<counter>" macro
  \expandafter
  \gdef\csname the#1\expandafter\endcsname\expandafter
     {\expandafter\number\csname c@#1\endcsname}
}

\let\newcounter\@definecounter
```
{% endraw %}

To make things trickier, LaTeX also allows the user to "number within"
a counter. For example, we frequently want the equation numbers in a
book to look like `chapter.equation`. When we start a new chapter, the
equation number resets to zero. More generally, when a counter (like
the chapter number) is
incremented, we should propagate any "resets" needed to other counters
(like the equation number, or the section number, or the subsection
number, or...).

{% raw %}
```tex
% TODO: support "\theH<counter>"?
\def\stepcounter#1{%
    \expandafter\global\expandafter\advance\csname c@#1\endcsname by1%
    \begingroup% propagate reset
      \let\@elt\@stpelt%
      \csname cl@#1\endcsname%
    \endgroup%
}

% @stpelt{<counter>} sets <counter> equal to -1, then invokes
% \stepcounter{<counter>} to propagate resetting
\def\@stpelt#1{%
  \setcounter{#1}{-1}%
  \stepcounter{#1}%
}
```
{% endraw %}

We increment a counter using `\stepcounter{counter}` if we don't want
to use it for a label, or `\refstepcounter{counter}` if we want to use
it with a label. Usually the user wants `\refstepcounter`.

The `\refstepcounter` will (1) invoke `\stepcounter`, then (2) set the
`\@currentcounter` global variable to the printed form of the counter.

The `\stepcounter` will increment the associated counter register,
then propagate any necessary resets.

The `\refstepcounter` is comparatively straightforward:

{% raw %}
```tex
\def\@currentcounter{}

\def\refstepcounter#1{%
  \stepcounter{#1}%
  \xdef\@currentcounter{\csname the#1\endcsname}%
}
```
{% endraw %}

Labels essentially define an internal macro storing the current result of
`\the<counter>`. These internal macros are prefixed with `r@`.

There have been times when I wanted to do something with the label, so
I added a "hook" mechanism.


{% raw %}
```tex
\def\labelhook#1{}

\def\label#1{%
  \expandafter\ifx\csname r@#1\endcsname\relax\else%
    \message{Label already defined: #1}%
  \fi%
  % The "r@foo" macros should look like "\def\r@foo{{<\thefoo>}{\thepage}}".
  % The "\noexpand" are inserted to keep "{" and "}" from expanding
  \expandafter\xdef\csname r@#1\expandafter\endcsname\expandafter{%
    \expandafter\noexpand{\@currentcounter\noexpand}%
    \noexpand{\folio\noexpand}%
  }%
  \labelhook{#1}%
\ignorespaces}
```
{% endraw %}

When we want to refer to a counter, we either want the stored "printed
label" of the counter (i.e., `\the<counter>`) or the page where the
counter was printed. When we invoke `\ref{label}`, we get the former;
and `\pageref{label}` gives us the latter.

We also want to warn the user about `\ref{undeclared-label}`.

{% raw %}
```tex
\def\undefinedrefhandler#1{\message{Warning: reference #1 on page \folio undefined}{\bf??}}
\let\defaultundefinedrefhandler\undefinedrefhandler

\def\ref#1{%
  \ifx\csname r@#1\endcsname\relax%
    \undefinedrefhandler{#1}%
  \else%
    \expandafter\expandafter\expandafter\@firstoftwo\csname r@#1\endcsname%
  \fi}

\def\eqref#1{(\ref{#1})}

\def\pageref#1{%
  \ifx\csname r@#1\endcsname\relax%
    \message{Warning: reference #1 on page \folio undefined}%
  \else%
    \expandafter\expandafter\expandafter\@secondoftwo\csname r@#1\endcsname%
  \fi}
```
{% endraw %}

The user may wish to just "assign a value to a counter", and this is
handled with the `\setcounter{<counter>}{<newvalue>}` macro.

{% raw %}
```tex
\def\setcounter#1#2{
    \expandafter\global\csname c@#1\endcsname=#2
}
```
{% endraw %}

Now, the code for "propagating counter resets" is a bit subtle because
it requires implementing a linked list of dependent counters.

{% raw %}
```tex
% linked list operations
\def\@cons#1#2{\begingroup\let\@elt\relax\xdef#1{#1\@elt #2}\endgroup}
\def\@car#1#2\@nil{#1}
\def\@cdr#1#2\@nil{#2}

% \@addtoreset{<foo>}{<bar>} will reset <foo> when <bar> is stepped
\def\@addtoreset#1#2{\expandafter\@cons\csname cl@#2\endcsname {{#1}}}

% ASSUME: #1 and #2 are both counters
\def\@removefromreset#1#2{
  \begingroup
    \expandafter\let\csname c@#1\endcsname\@removefromreset
    \def\@elt##1{%
      \expandafter\ifx\csname c@##1\endcsname\@removefromreset
      \else
        \noexpand\@elt{##1}%
      \fi}%
    \expandafter\xdef\csname cl@#2\endcsname
      {\csname cl@#2\endcsname}%
  \endgroup%
}
```
{% endraw %}

Prettyprinting the counters is the last thing we need to worry
about. These are straightforward wrappers around TeX primitive or
analogous functions.

{% raw %}
```tex
%% Pretty printing counters
\def\arabic#1{\expandafter\number\csname c@#1\endcsname}

\def\roman#1{\expandafter\romannumeral\csname c@#1\endcsname}

\def\@slowromancap#1{\ifx @#1\else \if i#1I\else \if v#1V\else \if x#1X\else \if l#1L\else \if c#1C\else \if d#1D\else \if m#1M\else #1\fi \fi \fi \fi \fi \fi \fi \expandafter \@slowromancap \fi}
\def\@Roman#1{\expandafter\@slowromancap\romannumeral#1@}
\def\Roman#1{\expandafter\@Roman\csname c@#1\endcsname}

\def\@alph#1{\ifcase #1\or a\or b\or c\or d\or e\or f\or g\or h\or i\or j\or k\or l\or m\or n\or o\or p\or q\or r\or s\or t\or u\or v\or w\or x\or y\or z\else \@ctrerr \fi}
\def\alph#1{\expandafter\@alph\csname c@#1\endcsname}

\def\@Alph#1{\ifcase #1\or A\or B\or C\or D\or E\or F\or G\or H\or I\or J\or K\or L\or M\or N\or O\or P\or Q\or R\or S\or T\or U\or V\or W\or X\or Y\or Z\else \@ctrerr \fi}
\def\Alph#1{\expandafter\@Alph\csname c@#1\endcsname}

% TODO: fnsymbol unimplemented

\def\value#1{\csname c@#1\endcsname}
```
{% endraw %}

### Math related macros

Equation environments are useful. These are essentially an environment
which increments the equation counter, starts a displaystyle math
mode, prints the equation number, and ignores any trailing whitespace.

{% raw %}
```tex
%%%%
%%%% Math related stuff
%%%%

%%
%% Equation environments
%%
\let\normalfont\rm
\let\normalcolor\relax
\@definecounter{equation}
\def\equation{$$\refstepcounter{equation}}
\def\endequation{\eqno \hbox{\@eqnnum}$$\@ignoretrue}
\def\@eqnnum{{\normalfont \normalcolor (\theequation)}}

\expandafter\def\csname equation*\endcsname{%
  \relax\ifmmode
      \@badmath
  \else
      \ifvmode
         \nointerlineskip
         \makebox[.6\linewidth]{}%
      \fi
      $$%                   %  amsthm tries to patch this and expects a $
                            %  will be adjusted when amsthm changes
  \fi
}
\expandafter\def\csname endequation*\endcsname{%
   \relax\ifmmode
      \ifinner
         \@badmath
      \else
         $$
      \fi
   \else
      \@badmath
   \fi
   \ignorespaces\@ignoretrue
}%
```
{% endraw %}

Fractions and `\stackrel` are the only other math macros I use, and
their implementation are straightforward.


{% raw %}
```tex
%% fractions
\def\frac#1#2{{\begingroup#1\endgroup\over#2}}

\def\stackrel#1#2{\mathrel{\mathop{#2}\limits^{#1}}}
```
{% endraw %}

### Test if next character matches

LaTeX supports "optional arguments" to a macro by placing the optional
arguments in brackets `\foo[optional arg]{required arg}`. Under the
hood, it tests if the next character is `[` or not, and evaluates
specific macros depending on which one is encountered.

The `\@ifnextchar` implementation is black magic, and I won't spend
much time explaining it.

The `\@ifstar` macro is another useful LaTeX macro whose
implementation I won't dwell too much on.

{% raw %}
```tex
%%%
%%% @ifnextchar
\long\def\@firstoftwo#1#2{#1}
\long\def\@secondoftwo#1#2{#2}

\let\og@colon\:
\def\:{\let\@sptoken= } \:  % this makes \@sptoken a space token
\def\:{\@xifnch} \expandafter\def\: {\futurelet\@let@token\@ifnch}
\let\:\og@colon

\def\@ifnch{%
  \ifx\@let@token\@sptoken
    \let\reserved@c\@xifnch
  \else
    \ifx\@let@token\reserved@d
      \let\reserved@c\reserved@a
    \else
      \let\reserved@c\reserved@b
    \fi
  \fi
  \reserved@c}

\long\def\@ifnextchar#1#2#3{%
  \let\reserved@d=#1%
  \def\reserved@a{#2}%
  \def\reserved@b{#3}%
  \futurelet\@let@token\@ifnch%
}

\def\@ifstar#1{\@ifnextchar*{\@firstoftwo{#1}}}
```
{% endraw %}

### Fonts

LaTeX has a sophisticated family of macros for font management. We
won't reproduce it, because I'm lazy. But we have a bunch of font
families loaded up, namely:

{% raw %}
```tex
%% Fonts
\font\tensc=cmcsc10 % caps and small caps
\font\twelverm=cmr12
\font\eightrm=cmr8
\font\sixrm=cmr6 \font\fiverm=cmr5
\font\eighti=cmmi8
\font\ninei=cmmi9  \skewchar\ninei='177
\font\eighti=cmmi8  \skewchar\eighti='177
\font\sixi=cmmi6  \skewchar\sixi='177

\font\tenbi=cmmib10  \skewchar\tenbi='177
\font\ninebi=cmmib9  \skewchar\ninebi='177

\font\ninesy=cmsy9  \skewchar\ninesy='60
\font\eightsy=cmsy8  \skewchar\eightsy='60
\font\sixsy=cmsy6  \skewchar\sixsy='60

\font\tenbsy=cmbsy10  \skewchar\tenbsy='60
\font\sevenbsy=cmbsy7  \skewchar\sevenbsy='60
\font\fivebsy=cmbsy5  \skewchar\fivebsy='60

\font\elevenex=cmex10 scaled\magstephalf
\font\nineex=cmex9
\font\eightex=cmex8
\font\sevenex=cmex7

\font\ninebf=cmbx9
\font\eightbf=cmbx8
\font\sixbf=cmbx6

\font\tenthinbf=cmb10
\font\ninethinbf=cmb10 at 9.25pt
\font\eightthinbf=cmb10 at 8.5pt

\font\twelvett=cmtt12  \hyphenchar\twelvett=-1  % inhibit hyphenation in tt
\font\tensltt=cmsltt10  \hyphenchar\tensltt=-1
\font\ninett=cmtt9  \hyphenchar\ninett=-1
\font\ninesltt=cmsltt10 at 9pt  \hyphenchar\ninesltt=-1
\font\eighttt=cmtt8  \hyphenchar\eighttt=-1
\font\seventt=cmtt8 scaled 875  \hyphenchar\seventt=-1

\font\ninesl=cmsl9
\font\eightsl=cmsl8

\font\nineit=cmti9
\font\eightit=cmti8

\font\eightss=cmssq8
\font\eightssi=cmssqi8
\font\sixss=cmssq8 scaled 800
\font\tenssbx=cmssbx10
```
{% endraw %}

Then we have an "approximation" to LaTeX's `\footnotesize` macro. This
is hardcoded to 10-point being the "normal font size".

{% raw %}
```tex
\def\footnotesize{\def\rm{\fam0\eightrm}%
  %\clearance=3.9125 pt
  \textfont0=\eightrm \scriptfont0=\sixrm \scriptscriptfont0=\fiverm
  \textfont1=\eighti \scriptfont1=\sixi \scriptscriptfont1=\fivei
  \textfont2=\eightsy \scriptfont2=\sixsy \scriptscriptfont2=\fivesy
  \textfont3=\eightex \scriptfont3=\sevenex \scriptscriptfont3=\sevenex
  \def\it{\fam\itfam\eightit}%
  \textfont\itfam=\eightit
  \def\sl{\fam\slfam\eightsl}%
  \textfont\slfam=\eightsl
  \def\bf{\fam\bffam\eightbf}%
  \textfont\bffam=\eightbf \scriptfont\bffam=\sixbf
   \scriptscriptfont\bffam=\fivebf
  \def\tt{\fam\ttfam\eighttt}%
  \let\sltt=\error
  \textfont\ttfam=\eighttt
  \def\oldstyle{\fam\@ne\eighti}%
  \normalbaselineskip=9pt
  \def\bigfences{\textfont3=\nineex}%
  \let\big=\eightbig
  \let\Big=\eightBig
  \let\bigg=\eightbigg
  \let\Bigg=\eightBigg
  \setbox\strutbox=\hbox{\vrule height7pt depth2pt width\z@}%
  \setbox0=\hbox{$\partial$}%\setbox\ush=\hbox{\rotu0}%
  %\bitmapsize=8pt
  \let\adbcfont=\sixrm
  \let\mc=\sevenrm % for slightly smaller caps
  \let\boldit=\error
  \let\ii=\eightii
  \def\MF{{\manfnt opqr}\-{\manfnt stuq}}%
  \normalbaselines\rm}
```
{% endraw %}

Then we have `\emph` which toggles italicizing the font or
not. Strictly speaking, it just switches between italic and upright
font, without caring about font weight (bold or not) or any other font
family (sans serif, teletype, etc.).

A more robust version would account for these situations, I suppose,
but that would require more work than I'd care to implement.

{% raw %}
```tex
%%%
%%% Font commands

%% Poor man's \emph
\newif\if@emph \@emphfalse
\def\em{\toggle@emph\if@emph\it\else\rm\fi} 
\def\toggle@emph{\if@emph\@emphfalse\else\@emphtrue\fi}
\def\emph#1{{\em #1\/}}
```
{% endraw %}

Then we have commands which just change the font, things like
`\textsc`, `\textit`, `\textsl`, `\textbf`, `\texttt`, and so on.

{% raw %}
```tex
% usual font manipulations
\def\textsc#1{{\tensc #1}}
\def\textit#1{{\it #1\/}}
\def\textsl#1{{\sl #1\/}}
\def\textbf#1{{\bf #1}}
\def\texttt#1{{\tt #1}}
\def\textrm#1{{\rm #1}}
\def\mathcal#1{{\cal #1}}

\font\sften=cmss10
\font\sfseven=cmss7
\font\sffive=cmss5
\newfam\sffam
\textfont\sffam=\sften
\scriptfont\sffam=\sfseven
\scriptscriptfont\sffam=\sffive
\def\sf{\fam\sffam\sften}
\def\textsf#1{{\sf#1}}

\def\text#1{{\rm #1}}

% KLUDGE for old style numbers
\def\oldstylenums#1{\ifmmode{\oldstyle #1}\else${\oldstyle #1}$\fi}
```
{% endraw %}

### Title page

This should probably be moved into the poor man's book macros, but the
`\title{...}`, `\author{...}`, and `\date{...}` macros are provided
here.

The titlefont is just sans-serif bold at 29.85984 point.

The title page is just the title, author, and date (if any), followed
by any "addenda" the user may wish to include. For example, I include
the date and time the document was compiled as the addenda.

{% raw %}
```tex
%%%
%%% Title
%%%
\def\title#1{\gdef\@title{#1}}
\def\author#1{\gdef\@author{#1}}
\long\def\date#1{\gdef\@date{#1}}
% magstep5 = 2.48832 times larger
% so 12pt magstep5 = 29.85984pt
\font\titlefont=cmssbx12 scaled\magstep5 % ~ cmssbx25

\def\@maketitleaddenda{}
\def\@maketitle{\vskip2em%
  %% \edef\@@title{\uppercase{\@title}}
  %% \centerline{\foofont \@@title}%
  \centerline{\titlefont \@title}%
  \vskip1.5em\centerline{\twelverm\@author}% author
  \ifx\@date\relax\else\vskip 1em\centerline{\twelverm \@date }\par\fi% date
  \vskip 1.5em%
}
\def\maketitle{\@maketitle
  \mbox{ }\par
  \gdef\@maketitle{}
  \mbox{ }\vfill
  \@maketitleaddenda
  \eject}

\def\mbox#1{\leavevmode\hbox{#1}}
```
{% endraw %}

### Aligned equations

These macros are taken straight from `amstex` (or `amsmath`).

{% raw %}
```tex
%%%
%%% aligned, taken from amstex.tex
%%%
\def\strut@{\copy\strutbox@}
\newbox\strutbox@

\newif\ifinany@
\def\Let@{\relax\iffalse{\fi\let\\=\cr\iffalse}\fi}
\def\aligned{\null\,\vcenter\aligned@}
\def\vspace@{\def\vspace##1{\crcr\noalign{\vskip##1\relax}}}
\def\aligned@{\bgroup\vspace@\Let@
 \ifinany@\else\openup\jot\fi\ialign
 \bgroup\hfil\strut@$\m@th\displaystyle{##}$&
 $\m@th\displaystyle{{}##}$\hfil\crcr}
\def\endaligned{\crcr\egroup\egroup}
```
{% endraw %}

We also have the `center` environment, which is just `\centering` its contents.

{% raw %}
```tex
\def\center{\centering}
\def\endcenter{}
```
{% endraw %}

### Lists

There are two list environments implemented:

1. `itemize` for unordered lists
2. `enumerate` for ordered lists

The enumerate environment assumes the reader is not nesting them, for
simplicity. 

{% raw %}
```tex
%%
%% Lists
%%
%\newenvironment{itemize}{\def\item{\par}}{\par}
\def\itemize{\smallbreak%
  %\advance\leftskip\parindent%
  %\def\item{\par\noindent$\bullet$\enspace\@ignoretrue\ignorespaces}%
  \def\@item[##1]{\par\noindent\hang\textindent{##1}}%
  \def\@@item{\@item[$\bullet$]}%
  \def\item{\@ifnextchar[\@item\@@item}%\par\noindent\hang\textindent{$\bullet$}}%
}
\def\enditemize{\@ignoretrue\smallbreak}%\noindent\ignorespaces}

\newcounter{enumi}
\def\enumerate{\smallbreak\setcounter{enumi}{0}%
  \def\item{\par\refstepcounter{enumi}\noindent\hang\textindent{(\theenumi)}}%
}
\def\endenumerate{\@ignoretrue\smallbreak}%\noindent}
```
{% endraw %}

### Graphics

The last thing we do is use the `epsf.tex` macros for graphics. This
is a "poor man's" approximation to LaTeX's `graphicx.sty`.

{% raw %}
```tex
% graphics
\input epsf
\def\includegraphics{\epsfbox}

\makeatother
\endinput % pmlmac.tex
```
{% endraw %}

## Poor Man's Book Class

Building on top of the previous "poor man's LaTeX", we have some
macros responsible for chapters, sections, table of contents, and
other things.

We start with the miscellaneous font families which I needed to
use. Fonts like fraktur and blackboard bold.

{% raw %}
```tex
% blackboard bold https://tex.stackexchange.com/a/156303/14751
\newfam\bbbfam
\font\bbbten=msbm10
\font\bbbseven=msbm7
\font\bbbfive=msbm5
\textfont\bbbfam=\bbbten
\scriptfont\bbbfam=\bbbseven
\scriptscriptfont\bbbfam=\bbbfive
\def\bbb{\fam=\bbbfam}
\def\mathbb#1{{\bbb#1}}

% fraktur
\newfam\frakfam
\font\frakten=eufm10
\font\frakseven=eufm7
\font\frakfive=eufm5
\textfont\frakfam=\frakten
\scriptfont\frakfam=\frakseven
\scriptscriptfont\frakfam=\frakfive
\def\frak{\fam=\frakfam}
\def\mathfrak#1{{\frak#1}}
```
{% endraw %}

### Table of Contents

The `\chapter`, `\section`, and `\subsection` commands will write to
the `\tocfile` new entries as they are encountered.

Therefore TeX needs to run twice in order for the table of contents to be
accurately updated.

{% raw %}
```tex
%%
%% Table of contents

\def\tableofcontents{\begingroup\openin15=toc.tex
  \ifeof15\else\input{toc.tex}\fi\endgroup}

\newwrite\tocfile
\immediate\openout\tocfile={toc2.tex}

\immediate\write\tocfile{\noexpand\chapter*{Contents}\noexpand\begingroup}

\def\contentsline#1#2#3#4{\csname l@#1\endcsname {#2}{#3}}

\def\addcontentsline#1#2#3#4{\toks0={{#1}{#2}{#3}{#4}}%
\immediate\write\tocfile{\noexpand\contentsline\noexpand{#1\noexpand}\noexpand{#2\noexpand}\noexpand{#3\noexpand}\noexpand{#4\noexpand}}}

\def\l@chapter#1#2{\line{\rm#2\diamondleaders\hfil\hbox to 2em{\hss#1}}}
\def\l@section#1#2{\line{\qquad\rm#2\diamondleaders\hfil\hbox to 2em{\hss#1}}}

% horizontal dots between entry name and page number in ToC
\countdef\counter=255
\gdef\diamondleaders{\global\advance\counter by 1
  \ifodd\counter \kern-10pt \fi
  \leaders\hbox to 20pt{\ifodd\counter \kern13pt \else\kern3pt \fi
    .\hss}}

\def\thepage{\folio}

% HACK: make sure to flush the \tocfile before ending TeX
\def\bye{\immediate\write\tocfile{\noexpand\endgroup}%
  \immediate\closeout\tocfile%
  \par\vfill\supereject\@@end}
```
{% endraw %}

### Sections

The book has "front matter" (like the preface, foreward, table of
contents, etc.) and "main matter". We provide the `\frontmatter` and
`\mainmatter` macros to toggle between these two situations.

{% raw %}
```tex
%%
%% Sections
%%
\newif\iffront\frontfalse
\let\og@advancepageno\advancepageno
\def\frontmatter{\def\folio{\romannumeral\pageno}\fronttrue\gdef\thesection{\arabic{section}}}

\def\mainmatter{\global\frontfalse\gdef\thesection{\thechapter.\arabic{section}}\gdef\advancepageno{\og@advancepageno\gdef\folio{\number\pageno}
\global\let\advancepageno\og@advancepageno}}
```
{% endraw %}

Then we have chapters, sections, and subsections. I am trying to keep
the "depth" as minimal as possible. It seems humans generically
can't handle anything beyond three "layers" of complexity.

The subsections are just alphanumerics tacked onto the end of the
section number (like "3.2A" is the first
subsection of chapter 3 section 2).

Equations are numbered within each chapter.

{% raw %}
```tex
\newcounter{chapter}
\newcounter{section}
\newcounter{subsection}
\@addtoreset{section}{chapter}
\@addtoreset{subsection}{section}
\def\thesection{\thechapter.\fi\arabic{section}}
\def\thesubsection{\thesection\Alph{subsection}}
% number equations within each chapter
\@addtoreset{equation}{chapter}
\def\theequation{\thechapter.\arabic{equation}}
```
{% endraw %}

Now for the `\chapter{name}`, `\section{name}`, and
`\subsection{name}`, I am just following Knuth's _Art of Computer Programming_
style since I have no better alternative.

Starred chapters are un-numbered, but otherwise look "the same" as
unstarred chapters.

Importantly, chapters start on a new page. If the user wants to print
this out, usually chapters start on recto pages (and they should
probably test if the page number is even or odd to skip another page
if needed).

{% raw %}
```tex
\font\sectiontitlefont=cmssbx10 scaled\magstep2

\def\s@chapter#1{\vfill\eject%\refstepcounter{chapter}
    \leftline{\twelvess \spaceskip=10pt \def\\{\kern1pt}\phantom{Chapter}}
    \vskip 4pc
    \rightline{\sectiontitlefont #1}
    \def\\{}
    \ifx\rhead\omitrhead\else{\ninepoint\xdef\rhead{\uppercase{#1}}}\fi
    \addcontentsline{chapter}{\thepage}{\hbox to 1.5em{\hfil}\enspace #1}{}%
    \vskip 2pc plus 1 pc minus 1 pc
}

\def\@chapter#1{\vfill\eject\iffront\else\refstepcounter{chapter}\fi
    \leftline{\twelvess \spaceskip=10pt \def\\{\kern1pt}\iffront\phantom{Chapter}\else Chapter \thechapter\fi}
    \vskip 4pc
    \rightline{\sectiontitlefont #1}
    \def\\{}
    \ifx\rhead\omitrhead\else{\ninepoint\xdef\rhead{\uppercase{#1}}}\fi
    \addcontentsline{chapter}{\thepage}{\hbox to 1.5em{\hfil\iffront\else\thechapter\fi}\enspace #1}{}%
    \vskip 2pc plus 1 pc minus 1 pc
}

\def\chapter{\@ifstar\s@chapter\@chapter}
```
{% endraw %}

Sections can be "starred" (with `\starit\section{name}`) to indicate
they are optional.

Moreover, if there's less than 2 inches left on the page, we should
just skip to the next page to start a new section. It's unpleasant to
have the section title on one page, and the first paragraph of that
section on the next page.

Subsections are just sections with a different counter. So we refactor
out the common code to `\common@section{name}{counter used}`.

{% raw %}
```tex
\def\starred{}
\def\starit{\def\starred{\llap{*}}}

\newif\ifrunon\runonfalse 
\newdimen\spaceleft

% if there's less than 2 inches left on the page, just skip to the
% next page to start the section
\def\sectionbreak{%
  \spaceleft=\vsize%
  \advance\spaceleft by-\pagetotal%
  \ifdim\spaceleft<2in%
    \vfill\eject%
  \else%
    \bigbreak%\vskip 2pc plus 1pc minus 5pt%\vskip 1 cm plus 1 pc minus 5 pt%
  \fi%
}

\def\common@section#1#2{%\mark{\currentsection \noexpand\else #1}
  \sectionbreak%
    \refstepcounter{#2}%
    %% \ifrunon \runonfalse\vskip 1 cm plus 1 pc minus 5 pt
    %% \else \vfill\eject
    %%   {\output{\setbox0=\box255}\null\vfill\eject} % set \topmark for sure
    %% \fi
    %\tenpoint
    \leftline{\tenssbx\starred\csname the#2\endcsname. \uppercase{#1}}
    \addcontentsline{section}{\thepage}{\starred\csname the#2\endcsname\enspace #1}{}%
    \def\starred{}%
    \mark{#1\noexpand\else #1}%
    \def\currentsection{#1}%
    %{\ninepoint\xdef\rhead{\uppercase{#2}}}
    \nobreak\smallskip\noindent}

\def\section#1{\common@section{#1}{section}}
\def\subsection#1{\common@section{#1}{subsection}}
```
{% endraw %}

### Mathematical Proofs

We have `\begin{proof}...\end{proof}` environments for Mathematical
proofs. These will insert some vertical space, have `Proof.` or `Proof
(optional text).` in small caps, and conclude with a QED symbol flush
right (and then some small vertical spacing).

{% raw %}
```tex
%% Poor man's amsthm proof environment
\def\@addpunct#1{\ifnum \spacefactor >\@m \else #1\fi}
\def\openbox{\leavevmode
  \hbox to.77778em{%
  \hfil\vrule
  \vbox to.675em{\hrule width.6em\vfil\hrule}%
  \vrule\hfil}}
\def\qedsymbol{\openbox}

% Knuth's taocpmac.tex uses the following for his qedsymbol equivalent:
\def\slug{\hbox{\kern1.5pt\vrule width2.5pt height6pt depth1.5pt\kern1.5pt}}
% This one looks a little better...
\def\slugg{\hbox{\kern1.25pt\vrule width3pt height6pt depth1.5pt\kern1.25pt}}

% \def\qedsymbol{\sluggg}

\def\qed{%
  \leavevmode\unskip\penalty9999 \hbox{}\nobreak\hfill
  \quad\hbox{\qedsymbol}%
}

\let\QED@stack\@empty
\let\qed@elt\relax

\newtoks\@temptokena

\def\pushQED#1{%
  \toks@{\qed@elt{#1}}\@temptokena\expandafter{\QED@stack}%
  \xdef\QED@stack{\the\toks@\the\@temptokena}%
}

\def\popQED@elt#1#2\relax{#1\gdef\QED@stack{#2}}
\def\popQED{%
  \begingroup\let\qed@elt\popQED@elt \QED@stack\relax\relax\endgroup
}
\def\proofname{Proof}
% knuth uses \it for his proofheadfont
\def\proofheadfont{\tensc}

\def\x@proof[#1]{\pushQED{\qed}\smallbreak%\par
  %\ifdim\lastskip<\medskipamount \removelastskip\penalty55\medskip\fi%\medskip%
  \noindent{\proofheadfont #1\@addpunct{.}} \ignorespaces%
}
\def\@proof{\x@proof[\proofname]}

\def\proof{\@ifnextchar[\x@proof\@proof}
\def\endproof{\popQED}
```
{% endraw %}

### Random odds and ends

We have some notation like `\implies` and `\impliedby` as macros.

We also have situations where, in a list environment, we are
enumerating properties or axioms satisfied by a mathematical
gadget. This is handled by `\property{Commutativity of addition}`.

We also have `\arXiv{2508.02305}` for printing the arXiv number of a
preprint.

And we have a crude `\mathbf` approximation

{% raw %}
```tex
% \iff is defined to be "\;\Longleftrightarrow\;"
%\def\;{\mskip\thickmuskip}
%\thickmuskip=5mu plus 5mu, 5mu = 5/18 of an em
\ifx\implies\@undefined
  \def\implies{\;\Longrightarrow\;}
\fi
\ifx\impliedby\@undefined
  \def\impliedby{\;\Longlefhtarrow\;}
\fi

\def\property#1{\item\textsc{#1\@addpunct{:}}\ \ignorespaces}

\usepackage{url}

\def\arXiv#1{\texttt{arXiv:#1}}

\def\mathbf#1{\textbf{#1}}

\makeatother
\endinput % pmbook
```
{% endraw %}

## Concluding remarks

This is all you really need to get going with a minimal working
approximation to LaTeX in plain TeX.

Does it have all the batteries included? No, of course not.

Will it work in a century? Yes, that I can guarantee.
