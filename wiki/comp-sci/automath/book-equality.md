---
layout: wiki
title: Automath
published: true
date: 2021-09-01
parentURL: /wiki/comp-sci/automath/
---

Book equality is defined in Jutting's encoding of Landau's 
_Foundations of Analysis_ as (lines 374--391 of `jutting/book/0`):

```
sigma@[s:sigma][t:sigma]
is:='prim':'prop'
s@refis:='prim':is(s,s)
p@[s:sigma][t:sigma][sp:<s>p][i:is(s,t)]
isp:='prim':<t>p
sigma@[s:sigma][t:sigma][i:is(s,t)]
symis:=isp([x:sigma]is(x,s),s,t,refis(s),i):is(t,s)
t@[u:sigma][i:is(s,t)][j:is(t,u)]
tris:=isp([x:sigma]is(x,u),t,s,j,symis(i)):is(s,u)
u@[i:is(u,s)][j:is(u,t)]
tris1:=tris(s,u,t,symis(u,s,i),j):is(s,t)
u@[i:is(s,u)][j:is(t,u)]
tris2:=tris(s,u,t,i,symis(t,u,j)):is(s,t)
sp@[i:is(t,s)]
isp1:=isp(symis(t,s,i)):<t>p
t@[n:not(is(s,t))]
symnotis:=th3"l.imp"(is(t,s),is(s,t),n,[x:is(t,s)]symis(t,s,x)):not(is(t,s))
```

Let's unpack this slowly.

## Definition of `is`

The `is` primitive notion encodes "book equality". 

```
sigma@[s:sigma][t:sigma]
is:='prim':'prop'
```

We read this as telling us that, in the context of `sigma : TYPE`, we
have `is` be a type parametrized by two `sigma` terms `s` and `t`.

## Axiom: Reflexivity

The next line tells us `is` is reflexive:

```
s@refis:='prim':is(s,s)
```