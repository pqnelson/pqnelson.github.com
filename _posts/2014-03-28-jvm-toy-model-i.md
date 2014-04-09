---
layout: post
title: Toy Model of the JVM, Part I
published: true
quote: "Truth...is much too complicated to allow anything but approximations."
quoteSource: John von Neumann, "The Mathematician" (1947)
---

**Contents**

* [Introduction](#intro)
* [First Model](#first-model)
  * [Stack Machine](#stack-machine)
    * [Structure of an "Instruction"](#instruction-structure)
  * [Frames](#frames)
  * [Minimal Instruction Set](#minimal-inst-set)
    * [Generic Instruction](#generic-instruction)
    * [Interpreter](#interpreter)
* [References](#references)

<a name="intro" />
# Introduction

Java 8 has introduced many neat functional features, like lambda
expressions. I wondered if Clojure could use these features. But it
required learning quite a bit about the Java Virtual Machine.

Studying the JVM is a fool's errand (OpenJDK's HotSpot has over 250,000
lines of code and nearly 1500 C/C++ files), so I thought instead I would
study a number of [toy models](http://en.wikipedia.org/wiki/Toy_model). 
Each would buildoff the previous one, elaborating various aspects of the
JVM's architecture.

*Remark.* It turns out there's a vast literature on the subject of
*formally modeling* the JVM. I have combed through selected references,
mostly the works of J. Strother Moore, when examining the inner workings
of the JVM. Dr Moore has written several "toy models" himself, and has
taught a course on it. His works have been cited below. (End of Remark)

<a name="first-model" />
# First Model

Our first approximation will be a simple single-threaded interpreter
with eight operations. But it will mirror a simple stack machine.

We will implement a `(step instruction environment)` function, which
evaluates the given `instruction` within the `environment`. For the JVM,
the `environment` is really the state of the machine (and this will be a
single frame for our purposes).

This will suffice for our first approximation to the JVM.

<a name="stack-machine" />
## Stack Machine

The JVM is a stack machine, with a reverse-Polish notation instruction
set. So lets set up a minimal collection of stack functions:

```clojure
;; Stacks
(defn push [obj stack] ...)
(defn top [stack] ...)
(defn pop [stack] ...)
```

<a name="instruction-structure" />
### Structure of an "Instruction"

The Java Virtual Machine "interprets" its own bytecode, which is
remniscent of assembly. I should be careful and note the term
"interpret" is used poetically, not literally: the JVM actually compiles
the bytecode to native code. Well, it's complicated, but lets not get
tied up with these irrelevant subtleties.

The bytecode basically amounts to a sequence of instructions.

Each instruction, written as an S-expression, looks like
`(op-code & args)` where there may be up to three operands. For example:

```clojure
(def toy-code '((iload 0)
                (iconst 1)
                (isub)
                (ifeq 14)
                (iload 0)
                (iconst 1)
                ...
                (halt)))
```

We have helper functions to access various parts of the instruction:

```clojure
(defn third [coll] (nth coll 2 nil))
(defn fourth [coll] (nth coll 3 nil))
  
;; Instructions
(def op-code first)
(def arg1    second)
(def arg2    third)
(def arg3    fourth)
```

<a name="frames" />
## Frames

The call stack is a list of frames treated as a stack. For our immediate
purposes, we will have only one frame and thus neglect difficulties
arising from a call stack.

**Definition.** A "frame" consists of four components: (i) the program
counter (or `pc`), (ii) the local variable table, (iii) the local stack, and 
(iv) the `program` or ordered list of instructions. (End of Definition)

We represent this as a record `(defrecord Frame [pc locals stack program])`.
And a frame for a toy program might look like:

```clojure
;; toy frame instance
{:pc 2                ; program counter, which line of the program we're on
 :locals {1 -32}      ; local variable dictionary
 :stack [3 2 6]       ; the stack of values
 :program '((ifeq 16) ; the bytecode as an s-expression
            (iload 0)
            (iconst 1)
            (isub)
            (ifeq 14)
            (iload 0)
            (iconst 1)
            (halt))}
```

Specifically, a [program counter](http://en.wikipedia.org/wiki/Program_counter) 
is a natural number that keeps track of the "next instruction" to
run. The next instruction refers specifically to an instruction in the
"program component". 

We have a `(next-inst frame)` function to get the next instruction from
the frame. We will assume this concept is well-defined.

The `stack` is the local memory for the frame, not the local variable
dictionary. The variable dictionary is `locals`. 

*Remark.* We part from the JVM slightly, and our local variables are
referenced by symbolic names rather than positions. BUT the beauty of
clojure allows us to use symbolic names instead as the key. (End of Remark)

<a name="minimal-inst-set" /> 
## Minimal Instruction Set

I take a subset of the Java bytecode, for the sake of simplicity. I'll
add more as I need more commands. For now, I will merely note the 8 or 9
commands and how the stack transforms. Unless otherwise noted, the
program counter always increments by 1.

Also, the stack transforms as `before -> after` with the top-most items
to the right `bottom, middle, top`.

**ILOAD.** Takes one parameter `(iload n)`. Push the value `val` of a
local variable `n` onto the stack, so the stack transforms as `... ->
..., val`.

**ICONST.** Takes one parameter `(iconst c)`. Push the constant `c` onto
the stack, which transforms as `... -> ..., c`.

**IADD.** Adds two integers. Takes no parameters `(iadd)`. 
So the stack transforms as 
`..., x, y -> ..., r` where `r = x+y`. Both `x` and `y` must be
integers. The values are popped from the stack. Their sum is then pushed
onto the stack.

**ISUB.** Subtract two integers. Takes no parameters `(isub)`. 
The stack transforms as `..., x, y -> ..., r` where `r = x - y`. 
The values `x` and `y` are popped from the stack, and `r` is pushed back
onto the stack. 

**IMUL.** Multiply two integers. Takes no parameters `(imul)`.
The stack transforms as  `..., x, y -> ..., r` where `r = x*y`. The
values `x` and `y` are popped from the stack, and `r` is pushed back
onto the stack. 

**ISTORE.** Stores a value into a local variable `n`. Takes one
parameter `(istore n)`. The stack transforms as `..., val -> ...`. The
value `val` on top of the stack is removed and stored into the local
variable `n`.

**GOTO.** Takes one parameter `(GOTO n)` and jumps by `n`. Execution
proceeds at offset `n` from this instruction, where `n` may be positive
or negative. The target address must be in the current program.

**IFEQ.** Takes one parameter `(IFEQ n)`. The stack transforms as 
`..., val -> ...`. Execution proceeds at offset `n` from this
instruction if `val` is 0, and at the next instruction otherwise. It
also pops the value `val` from the stack.

<a name="generic-instruction" /> 
### Generic Instruction

Given a generic op-code `op`, we have a function `eval-op` which updates
the frame accordingly. (The structure of this sort of function should
remind one of
[SICP's Metacircular Evaluator](http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-25.html#%_chap_4),
specifically the `eval` function which takes the line of code and the
environment as its parameters.) We have

```clojure
;;;; from toy-jvm.frame
(defn modify [frame & {:as args}]
  (map->Frame (merge frame args)))

;;;; from toy-jvm.instruction
(defn eval-op [inst frame]
  (modify frame
    ; other transformations here
    ))
```

Since we have many operations, we have to define two functions for each
op-code, namely: (i) a predicate `op?` which tests if a symbol is equal to
the given op-code, and (ii) a function `eval-op` which actually emulates
the operation.

In the spirit of "Don't Repeat Yourself", we introduce a macro that
expands into defining these two functions. In pseudocode:

```clojure
(defmacro defop [name args & changes]
  (defn eval-name [args]
    (modify frame changes))
  (defn name? [op-code#]
    (if (opcode? op-or-inst#)
      (= op-or-inst# name)
      (= (util/op-code op-or-inst#) name))))
```

This allows us to write more elegant interpreter code.

<a name="interpreter"> 
### Interpreter

We interpret one instruction at a time. We have a function `(step ...)`,
which takes a frame and executes the "next instruction". In pseudocode: 

```clojure
(defn step [frame]
  (let [inst (next-inst frame)]
    (cond
      (op? inst) (eval-op inst frame)
      ;; ...
      :else (eval-halt inst frame))))
```

Note we are a bit sloppy, because a valid program would look like:

```clojure
(def *pi*
  '((iconst 0)   ;  0
    (istore 1)   ;  1  j = 0
    (iconst 1)   ;  2
    (istore 2)   ;  3  k = 1
    (iload 0)    ;  4 loop:
    (ifeq 16)    ;  5  if n=0, goto exitj
    (iload 0)    ;  6
    (iconst 1)   ;  7
    (isub)       ;  8
    (ifeq 14)    ;  9  if n=1, goto exitk
    (iload 0)    ; 10
    (iconst 1)   ; 11
    (isub)       ; 12
    (istore 0)   ; 13  n=n-1
    (iload 2)    ; 14  save k on stack
    (iload 1)    ; 15
    (iload 2)    ; 16
    (iadd)       ; 17
    (istore 2)   ; 18  k=j+k
    (istore 1)   ; 19  j= saved k
    (goto -16)   ; 20  goto loop
    (iload 1)    ; 21 exitj: return j
    (halt)       ; 22
    (iload 2)    ; 23 exitk: return k
    (halt)))     ; 24
```

We have to translate this to a frame, which we do:

```clojure
(defn load-program [raw-code]
  (make-frame 0 {} [] raw-code))
```

The interpreter then interprets a frame, running `n` steps:

```clojure
(defn run [frame n]
  (try
    (loop [state frame
           k n]
      (if (zero? k)
        state
        (recur (step state) (dec k)))
    (catch Exception e (println "Exception: " (.getMessage e))))))
```

# Conclusion

We implemented a simple stack machine, which operates on 8 or 9
opcodes taken from the Java bytecode. 

All our source code is available on 
[GitHub](https://github.com/pqnelson/toy-jvm), checkout the tag
`model-one`. 

<a name="references" />
# References

1. The [Java 8 VM Specifications](http://docs.oracle.com/javase/specs/jvms/se8/html/index.html)
2. J Strother Moore's [Formal Model of the JVM](https://www.cs.utexas.edu/users/moore/classes/cs378-jvm/index.html)
   Course CS378 at the University of Texas at Austin
3. Hanbing Liu, 
   "Formal Specification and Verification of a JVM and its Bytecode Verifier"
   Doctoral Thesis (2006)
   [Eprint](http://www.lib.utexas.edu/etd/d/2006/liuh22941/liuh22941.pdf),
   332 pages, pdf.
4. J. Strother Moore and George Porter, "An Executable Formal Java
   Virtual Machine Thread Model". In *Java Virtual Machine Research and
   Technology Symposium (JVM '01)*, USENIX, April, 2001. 
   [Eprint](http://www.cs.utexas.edu/users/moore/publications/m4/model.ps.gz)
5. J. Strother Moore, Robert Krug, Hanbing Liu, George Porter,
   "Formal Models of Java at the JVM Level: A Survey from the ACL2 Perspective".
   In *Workshop on Formal Techniques for Java Programs*, 2001.
   [Eprint](http://cseweb.ucsd.edu/~gmporter/papers/formaljvm-ecoop01.pdf), 10 pages.
