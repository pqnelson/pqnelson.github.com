---
layout: post
title: How much does an array access cost?
published: true
draft: false
quote: "Thank goodness we don't have only serious problems, but ridiculous ones as well."
quoteSource: E.W.Dijkstra, EWD475 (1982)
tags: [Assembly]
---

**Puzzle:** How many CPU cycles are needed to access an array element?
For simplicity, suppose it's a one-dimensional array, and we're
accessing a valid element within the bounds of the array. (End of
Puzzle)

I'm going to walk through the derivation.

# What CPUs to Benchmark?

We will focus on CPUs still used today, but not any historic
curios. Broadly, the architectures examined are:

1. OpenPOWER (POWER 9)
2. x86-64
3. Sparc64
4. ARM

## Caveat: Other Timing Considerations

I'm only looking at the CPU cycles spent for access an array element. In
practice, the CPU caches chunks of RAM, and performance depends on
whether we're accessing a cached chunk or an uncached address.

# How to Benchmark?

I'm going to compile a simple C function:

```c
double access(double array[], int n) {
    double result;
    result = array[n];
    return result;
}
```

This will be compiled to assembly code for the targetted CPU, and we'll
add up the latencies for each instruction. This gives us the total
number of CPU cycles for accessing the array.

# CPU Cycle Cost

## ARM Cortex-A72

For ARM, I decided to use the CPU which Raspberry Pi 4 has: [Cortex-A72](https://en.wikipedia.org/wiki/ARM_Cortex-A72).
(Note to future, forgetful, me: This is ARMv8-A architecture.)
The assembly code using "hard floats":

```armasm
@ access.c:10:     result = array[n];
	.loc 1 10 19
	ldr	r3, [r7]	@ n.0_1, n
	lsl	r3, r3, #3	@ _2, n.0_1,
	ldr	r2, [r7, #4]	@ tmp115, array
	add	r3, r3, r2	@ _3, tmp115
@ access.c:10:     result = array[n];
	.loc 1 10 12
	ldrd	r2, [r3]	@ tmp116, *_3
	strd	r2, [r7, #8]	@ tmp116,,
```

I'm using `arm-linux-gnueabihf-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0`
to compile to assembly. The compiler flags `arm-linux-gnueabihf-gcc -O0 -mcpu=cortex-a72 -S -c -g -fverbose-asm -mfloat-abi=hard access.c -o access-arm.s`.

The CPU cycles for the instructions (according to the
[software optimization documentation](https://developer.arm.com/documentation/uan0016/a)):
- `add` costs 1 cycle
- `ldr` costs 4 cycles without offset, 5 cycles with offset
- `lsl` costs between 1 and 2 cycles
- `ldrd` costs 4 cycles

Altogether, an array access costs 4+(1--2)+5+1+4 = 15--16 cycles.
Floating-point addition (`vadd`) costs 4 cycles, so an array access on
ARM costs 4 addition operations.

## POWER 9

The POWER 9 assembly code:

```
 # access.c:10:     result = array[n];
	.loc 1 10 19
	lwa 9,136(31)	 # n, _1
	sldi 9,9,3	 #, _2, _1
	ld 10,128(31)	 # array, tmp128
	add 9,10,9	 # _3, tmp128, _2
 # access.c:10:     result = array[n];
	.loc 1 10 12
	lfd 0,0(9)	 # *_3, tmp129
	stfd 0,56(31)	 # result, tmp129
```

This is from `powerpc64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0`.
The exact command was `powerpc64-linux-gnu-gcc -O0 -mcpu=power9 -S -c -g -fverbose-asm access.c -o access-power9.s`

Appendix A of the [POWER9 Processor's User Manual](https://openpowerfoundation.org/?resource_lib=power9-processor-users-manual)
 gives us the following latencies:

- `add` costs 2 cycles
- `ld` costs 4 cycles
- `lfd` costs 4 cycles
- `lwa` costs either 2 or 4 cycles
- `sldi` costs 2 cycles(?)
- `dadd` (double-precision floating-point addition) costs 12 cycles

Hence an array access costs 14-16 cycles, which is approximately the
cost of a floating-point addition operation.

## Sparc64 M8

The latest Sparc64 CPU is the M8. GCC compiles this to:

```
! access.c:10:     result = array[n];
	.loc 1 10 19
	ld	[%fp+2183], %g1	! n, tmp116
	sra	%g1, 0, %g1	! tmp116, _1
	sllx	%g1, 3, %g1	! _1,, _2
	ldx	[%fp+2175], %g2	! array, tmp117
	add	%g2, %g1, %g1	! tmp117, _2, _3
! access.c:10:     result = array[n];
	.loc 1 10 12
	ldd	[%g1], %f8	! *_3, tmp118
	std	%f8, [%fp+2039]	! tmp118, result
```

I'm using `sparc64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0`
for my compiler. The compiler flags used were `sparc64-linux-gnu-gcc -O0 -mcpu=m8 -S -c -g -fverbose-asm access.c -o access-sparc64.s`.

The instruction latencies aren't available for M8, but
for [M7, appendix A](https://www.oracle.com/technetwork/server-storage/sun-sparc-enterprise/documentation/sparc-architecture-supplement-3093429.pdf)
gives us:

- `add` costs 1 cycle
- `fadd` costs 11 cycles
- `ld` costs 1 cycle(?)
- `ldd` costs 1 cycle
- `ldx` costs 1 cycle
- `sra` costs 1 cycle
- `sllx` costs 1 cycle
- `std` costs 1 cycle (but this is used for assigning `result`, not
  accessing the array)

Altogether, we get 6 cycles for array access, compared to 11 cycles for
floating-point addition. So an array access on Sparc64 M8 costs about
half a floating-point addition.

## x86-64

For my own computer, which has an Intel(R) Core(TM) i5-4440S CPU @ 2.80GHz,
the assembly code produced (with intel assembly syntax):

```assembly
# access.c:10:     result = array[n];
	.loc 1 10 19
	mov	eax, DWORD PTR -28[rbp]	# tmp87, n
	cdqe
	lea	rdx, 0[0+rax*8]	# _2,
	mov	rax, QWORD PTR -24[rbp]	# tmp88, array
	add	rax, rdx	# _3, _2
# access.c:10:     result = array[n];
	.loc 1 10 12
	vmovsd	xmm0, QWORD PTR [rax]	# tmp89, *_3
	vmovsd	QWORD PTR -8[rbp], xmm0	# result, tmp89
```

Using GCC version `gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0`, with
compiler flags `gcc -O0 -march=native -masm=intel -S -c -g -fverbose-asm access.c -o access-x86.s`.

Consulting Agner's [instruction tables](https://www.agner.org/optimize/instruction_tables.pdf),
for Haswell architecture:
- `add` costs 1 cycle
- `cdqe` costs 1 cycle
- `lea` costs 3 cycles (since it's relative-address)
- `mov` costs 2 cycles
- `vmovsd` (an AVX instruction) is also called `movsd`, and costs 3 cycles

Floating-point addition `fadd` costs 3 cycles. Altogether, an array
access costs 2+1+3+2+1+3 = 12 cycles, or the equivalent of 4
floating-point addition operations.

## Summary

How much does an array access cost on each of these architectures
compared to adding together two double-precision numbers?

- ARM: 1 array access costs 4 floating-point addition operations
- POWER 9: 1 array access costs 1 floating-point addition operation
- SPARC: 1 array access costs 0.5 floating-point addition operations
- x86-64: 1 array access costs 4 floating-point addition operations

What heuristic should be used? Well, the honest answer: it depends on
your computer.

But if you want a number, take the geometric mean of these numbers since
they vary over different orders of magnitude. We'd find 1 array access
is approximately the cost of `pow(2,3/4)` (or about 1.68179)
floating-point addition operations.

# Caveats and Short-Comings

## Oversight 0: No optimizations

I have not enabled any optimizations to the compiler. The results are
drastically different when optimized, for example, using the `-O3` flag:
- ARM compiles to a single instruction (comparable to a
  floating-point addition operation);
- POWER 9 boils down to a `sldi` instruction (roughly `1/8` the cost of
  a single floating-point addition);
- SPARC compiles to a single `sllx` and `ldd` operation (2 cycles,
  costing about `2/11 = 0.18` floating-point additions);
- x86 becomes a single `movsx` instruction (comparable to a
  floating-point addition operation).

The _proportions_ between the architectures doesn't change (ARM and
x86-64 costs about an order-of-magnitude more CPU cycles than POWER and
SPARC).

## Oversight 1: Only one compiler used

I've used only a single compiler. I'm not sure Intel's C Compiler would
produce the same results as GCC's compiler, or if Clang would do
something different.

## Oversight 2: Caching and RAM Access Time

The first major caveat is that CPU caching has not been considered, nor
has RAM access time. But really, we just assumed the block containing
the array element has already been cached. If this is not the case, then
we'd have to add the time it'd take for the CPU to cache the block of
RAM containing the array element.

The latency numbers for memory lookup depends on the CPU, but an
heuristic:
- L1 cache reference costs 1 cycle
- L2 cache reference costs 10 cycles
- RAM memory lookup costs 100 cycles

If these seem suspiciously nice numbers, that's because they are:
they're order-of-magnitude estimates. I'm unaware of any suitably
general model of paging and caching which works for the _all_ of the
CPUs surveyed. Now that I think of it, the only models of such things
occur in toy models of assembly languages, and are generally ignored in
higher-level algorithms texts.

Further, if memory loads were a concern, then it's unique to each
problem: there's no silver bullet here. If I'm working on a matrix
multiplication algorithm, then the memory loading optimizations I'd use
probably won't carry over to finite-volume methods.

# Conclusion

Memory load operations (usually in the form of array accesses) ought to
be tracked when evaluating a numerical algorithm, but their cost depends
on the computer architecture **and** with an eye towards cache costs (at
least, if caching _could_ be an issue).

The current fashion is to suppose there are two levels of memory (fast
and slow). If `f` is the number of floating-point operations (say, the
number of equivalent floating-point addition operations), and `m` is the
number of memory elements moved from slow to fast memory, then use the
**"Computational Intensity"** ratio `q = f/m` to compare numerical algorithms (c.f., [UCSB CS267](https://sites.cs.ucsb.edu/~tyang/class/240a13w/slides/lecture01_introduction.pdf),
[UCSB CS140](https://sites.cs.ucsb.edu/~gilbert/cs140/notes/ComputationalIntensityOfMatMul.pdf),
[Colare](https://www.fe.infn.it/u/ecalore/calcoloParallelo/computational-intensity.pdf),
[Demmel](https://people.eecs.berkeley.edu/~demmel/ma221_Fall14/Lectures/Lecture_07.txt),
[Dongarra](http://www.netlib.org/utk/people/JackDongarra/WEB-PAGES/SPRING-2008/Lect07.pdf)
).
For `q`, larger is better.

**Remark.** I know, `f` is supposed to be FLOPS, but if you convert the
arithmetic operations into equivalent addition operations, then the two
differ by a constant. The resulting ratio would be off by a factor,
which is irrelevant when comparing ratios.
(End of remark)

There are various ways to gain insight juggling FLOPs against memory
accesses, usually by using the [roofline model](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2008/EECS-2008-134.pdf).
At this point, however, it seems that optimizing further _is_
computer-specific, and usually requires specialized tools.

# Appendix: Motivation

I'm collating my notes on numerical analysis, and I was always taught to
study the performance of a numerical algorithm by counting the number of
floating-point addition, subtraction, multiplication, and division
operations. Modern CPUs have approximately the same number of cycles
spent for addition, subtraction, and multiplication operations...but
nearly 10 times more cycles on division operations. This conversion
factor gives us a "common denominator" for comparing performance.

But classic texts on numerical linear algebra noted we should account
for memory load operations (which could slow down a linear algebra
algorithm). While I can count the number of memory load operations, this
got me thinking: how many cycles are spent on a memory load operation
compared to floating-point addition?
