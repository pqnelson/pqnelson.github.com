---
layout: post
title: Delete in Red-Black Trees
published: false
draft: true
use_math: true
quote: "A fool sees not the same tree that a wise man sees."
quoteSource: William Blake, <i> The Marriage of Heaven and Hell</i> (1793)
tags: []
---

I want to talk about Stefan Kahrs's delete method for persistent Red-Black trees
(specifically, the ["untyped" version](https://www.cs.kent.ac.uk/people/staff/smk/redblack/Untyped.hs)). 
This requires reviewing inserting elements into a persistent Red-Black tree.

There are very few discussions of Kahrs' method, but I am indebted to
Tobias Nipkow's book [Functional Data Structures and Algorithms](https://functional-algorithms-verified.org/)
for proving properties about persistent Red-Black trees using Isabelle/HOL.

For brevity, I'm just going to drop the "persistent" adjective, and
call things "Red-Black trees".

## Red-Black Trees

Red-Black trees are introduced by fiat as "some binary search tree"
where each node has an "extra bit of information: its color (either
Red or Black)". Schematically, in Standard ML,

```sml
signature RED_BLACK_TREE = sig
  type value;
  val compare : value * value -> order;
  
  datatype Color = Red | Black;
  datatype Tree = Leaf
                | Node of Color * Tree * value * Tree;
  
  (* snip *)
end;
```

We will use the term "Red node" to refer to a node whose color is Red
(and similarly "Black node" refers to a node whose color is Black).

**Notation.**<br>
We will write:
1. $\mathtt{Leaf}$ for `Leaf` in equations
2. $\langle\mathtt{Black},\ell,x,r\rangle$ for `Node(Black,l,x,r)` in equations
3. $\langle\mathtt{Red},\ell,x,r\rangle$ for `Node(Red,l,x,r)` in equations

Furthermore, if we want to discuss generic nodes in a binary tree, we
will write $\langle \ell,x,r\rangle$ to refer to them in equations.
<br>(End of notation)

**Definition.**<br>
We will inductively define the <dfn>Black Height</dfn> of a Red-Black
tree as a non-negative integer $bh(t)\in\mathbb{N}_{0}$ defined by the
rules:

1. $bh(\mathtt{Leaf}) = 0$
2. $bh(\langle\mathtt{Black},\ell,x,r\rangle)=1+\max(bh(\ell),bh(r))$
3. $bh(\langle\mathtt{Red},\ell,x,r\rangle)=\max(bh(\ell),bh(r))$

(End of Definition)

Further, a valid Red-Black tree satisfies four invariants:

1. The root of the tree is Black.
2. The empty tree is considered "Black" (so that the empty tree is a
   valid Red-Black tree).
3. **Red Invariant:** No Red node has a Red child. An immediate
   corollary: no Red node has a Red parent.
4. **Black Invariant:** The Black height of the left subtree is equal
   to the Black height of the right subtree; and, moreover, the left
   and right subtrees both satisfy the Black invariant.
   
When a Red-Black tree satisfies these four invariants, we will call it
a <dfn>Valid</dfn> Red-Black tree.

Usually the discussion ends here, cryptically, without discussing the
importance of the color. I want to discuss the importance of colors,
but first we need to discuss a few notions and introduce a few terms.

**Definition.**<br>
Let $C$ be a color. We can define the operation of <dfn>Painting</dfn>
a Red-Black tree the color $C$ by cases as:

1. Painting the empty tree produces the empty tree unchanged (since it
   does not have a color)
2. Painting the node $\langle C', \ell, x, r\rangle$ produces the node
   $\langle C, \ell, x, r\rangle$ with the desired color $C$.

(End of Definition)

**Definition.**<br>
We will call a Red-Black tree <dfn>Infrared</dfn> if its root node is
Red and the only possible Red invariant violation occurs at the root
node (i.e., the root node can have Red children).

We will call a Red-Black tree <dfn>possibly-Infrared</dfn> if painting
the tree Black produces a valid Red-Black tree. That is to say, it's
either Infrared 
_or_ it violates only the "root is Black" invariant (but satisfies
both the Red and Black invariants)
_or_ it's Valid.
<br>(End of Definition)

## Chiral 2-4 Trees

So...what's up with these colors?

We could make the analogy to "parasites" and "hosts". A "parasite"
feeds off of a host, but never off another parasite. A host has two
sides for parasites. This is precisely the situation we have with Red
nodes ("parasites") and Black nodes ("hosts").

A more _visual_ way to think of Red-Black trees is as a sort of 2-4
tree (or a [2-3-4 Tree](https://en.wikipedia.org/wiki/2%E2%80%933%E2%80%934_tree)).
This is not quite an isomorphism (a 3-node corresponds to two distinct
Red-Black subtrees, which kills the dream of an isomorphism). We
_want_ an isomorphic description because then it's just a "change of notation"
describing "the same thing".

We can recover an isomorphic description of Red-Black trees using
<dfn>Chiral 2-4 Trees</dfn> where we have left-3-nodes and right-3-nodes.

Specifically, we have right-3-nodes correspond to the following
Red-Black tree:

![Right 3-node as Red-Black tree](/assets/rbt/img-2.png)

The left-3-nodes correspond to the following Red-Black tree:

![Left 3-node as Red-Black tree](/assets/rbt/img-1.png)

The "crossed out box" indicates a vacant spot for a Red child, and the
"left"/"right" prefix indicates which spot the Red child lives.

A 4-node then corresponds to a Black node whose children are both Red
nodes. 

Then:
- A Red node corresponds to left and right data elements in a node.
- A Black node corresponds to the "center element" of a node.
- The Black height of a Red-Black tree is equal to the height of the
  corresponding chiral 2-4 tree.
- The Red-invariant is automatically satisfied by the chiral 2-4 tree
  description.
- The Black-invariant asserts the chiral 2-4 tree is a "complete tree"
  (i.e., the leaves of the chiral 2-4 tree all live at "the same
  level", in the sense that they all have the same depth).

You might hope therefore we could "import" the delete algorithm for
2-4 trees to apply to Red-Black trees (that was my hope,
initially). Perhaps this could give us something _nearly_ correct for
a delete algorithm for Red-Black trees, but it is not the same as
Kahrs's delete algorithm. I discuss this further in the appendix to
this article.

## Drawing Red-Black Trees

I am going to draw Red-Black trees in a way resembling 2-4 trees,
since the Red nodes are "extensions" ("parasites") to Black
nodes. For a Black node `b` with Red children `a` and `b` would be
drawn as:

![Example of a "node" in a Red-Black tree diagram](/assets/rbt/img-3.png)

The only time when I draw edges, its child node will _almost always_ be a
Black node.

The exceptions will be when we "pun" the usage of Red nodes to track
"overflow" upon insertion, and "underflow" upon deletion, requiring
rebalancing the Red-Black tree using tree rotations.

## "Smart" constructors

Look, I'm lazy, so I will be abbreviating constructors for Red and
Black nodes as:

```sml
(* "smart" constructors *)
fun R l x r = Node (Red, l, x, r);
fun B l x r = Node (Black, l, x, r);
```

## Inserting Elements into a Red-Black Tree

The basic strategy, if we draw out a Red-Black tree, and try inserting
a new value into the Red-Black tree, then the algorithm works as
follows:

1. **Downward phase:** We search to find where to place the new value.
2. Then we insert the new value as a **Red** node.
3. **Upward phase:** We rotate the parent Black node to restore the
   Red-Black invariants, producing a possibly-infrared Red-Black tree.
4. We paint the root node of the resulting tree Black (to recover a
   valid Red-Black tree).

In Okasaki's <cite class="book">Functional Data Structures</cite>,
this is the approach he takes. In pidgin Standard ML, the "upward phase"
is handled by the `balanceL` and `balanceR` functions in:

```sml
(* right rotations to rebalance the tree *)
fun balanceL (Node (Red, Node (Red, t1, a, t2), b, t3)) t4
    = R (B t1 a t2) b (B t3 c t4)
 | balanceL (Node (Red, t1, a, Node (Red, t2, b, t3))) c t4
    = R (B t1 a t2) b (B t3 c t4)
 | balanceL t1 a t2 = R t1 a t2;

(* left rotations to rebalance the tree *)
fun balanceR t1 a (Node (Red, t2, b, (Node (Red, t3, c, t4))))
    = R (B t1 a t2) b (B t3 c t4)
 | balanceR t1 a (Node (Red, (Node (Red, t2, b, t3)), c, t4))
    = R (B t1 a t2) b (B t3 c t4)
 | balanceR t1 a t2 = R t1 a t2;

fun insert x t =
  let
    fun ins Leaf = R Leaf x Leaf (* default case: insert a red node *)
     |  ins (Node(Black,l,a,r)) = (case compare(x,a) of
                                    LESS => balanceL (ins l) a r
                                  | EQUAL => B l a r
                                  | GREATER => balanceR l a (ins r))
     |  ins (Node(Red,l,a,r)) = (case compare(x,a) of
                                  LESS => balanceL (ins l) a r
                                | EQUAL => R l a r
                                | GRATER => balanceR l a (ins r));
  in
    (case (ins t) of
      (Node(_,l,a,r)) => B l a r
    | Leaf => B Leaf x Leaf) (* impossible *)
  end;
```

When the value `x` is not in the Red-Black tree, the `insert`
algorithm will insert it as a Red node. This possibly violates the
Red-invariant, which is why we need the `balanceL` and `balanceR`
functions. 

## Deleting from Binary Search Trees and Red-Black Considerations

Borrowing terminology from Tobias Nipkow's book, there are two
strategies to delete an element from a binary search tree when we want
to delete $x$ from the node $\langle\ell,x,r\rangle$:

1. Delete-by-replacement: pick the in-order successor $y$, surgically
   "remove" it from the right subtree $r$ to give us a new subtree
   $r'$ such that $y\notin r'$, then return $\langle\ell,y,r'\rangle$
2. Delete-by-join: we merge (or <dfn>Join</dfn>) the subtrees $\ell$
   and $r$ to produce the replacement for the node.

(Note: for delete-by-replacement, we could equally pick the in-order
predecessor $w$ for the replacement, modifying the left subtree
containing it $\ell$ to become $\ell'$.)

For Red-Black trees, we need an "upward phase" for Black nodes to
rebalance (otherwise we might violate some of the Red-Black tree
invariants).

Kahrs's method is a delete-by-join for Red-Black trees.

## General Template for Delete in Red-Black Trees

The basic skeleton for deleting an element in a Red-Black tree
requires helper functions:

- `del : value -> Tree -> Tree` deletes a specific value from a
  Red-Black tree, producing a possibly-infrared Red-Black tree
- `baldL : Tree -> value -> Tree -> Tree` for rebalancing after
  deleting from a left Black child-node
- `baldR : Tree -> value -> Tree -> Tree` for rebalancing after
  deleting from a right Black child-node
- `fuse : Tree -> Tree -> Tree` refers to "some way" to _fuse_ the
  left subtree and right subtree together (either by replacement, or
  by joining).

The basic skeleton with stubs looks like:

```sml
fun fuse l r = (* to be determined *);

fun baldL l x r = (* to be determined *);

fun baldR l x r = (* to be determined *);

(* Get the color of the node. A leaf is considered "black" *)
fun color Leaf = Black
 |  color (Node(c,_,_,_)) = c;

(* del : value -> Tree -> Tree

Produces a possibly-infrared Red-Black tree, which does not contain
the specified value.
*)
fun del x Leaf = Leaf
 |  del x (Node(_,l,a,r)) 
      = (case compare(x,a) of
          LESS => let val l' = del x l
                  in if Leaf <> l andalso Black = color l
                     then baldL l' a r
                     else Node(R, l', a, r)
                  end
          EQUAL => fuse l r
          GREATER => let val r' = del x r
                     in if Leaf <> r andalso Black = color r
                        then baldR l a r'
                        else Node(R, l, a, r')
                     end);
```

What contracts do we want/need for these functions?

When we `t' = del x t` for a Red-Black tree `t` satisfying both the Red and
Black invariants, we would want `t'` to satisfy the Black invariant
(at the very least).

If `Red = color t`, then we would want the result of deleting a value
to produce a Red-Black tree of the same Black-height, i.e., `bh t' = bh t`.

If `Black = color t`, then we would want to _decrease_ the Black
height of the result by one, i.e., `bh t' = (bh t) - 1`.

**Specification for `del`:**
Let `t` be a Red-Black tree satisfying the Red and Black invariants.
Let `t' = del x t`.
Then:
1. `t'` satisfies the Black invariant; and
2. If `t` is a Black node, then $bh(t')=bh(t)-1$ and `t'` is
   possibly-infrared; and
3. If `t` is a Red node, then $bh(t')=bh(t)$ and `t'` satisfies the
   Red invariant. 

We can immediately infer a specification for `fuse`:

**Specification for `fuse`:**
Let `l` and `r` be Red-Black trees both satisfying the Red and Black
invariants. Let `t'' = fuse l r`. If $bh(\ell)=bh(r)$, then:

1. `t''` satisfies the Black invariant, and also $bh(t'')=bh(\ell)=bh(r)$; and
2. `t''` is possibly-infrared; and
3. If `Black = color l` and `Black = color r`, then `t''` satisfies
   the Red invariant.

These requirements follow from the corresponding consequences of the
specification for `del`.

## Graphical Notation

We can draw these operations using a graphical notation. I am inspired
by Lyn Turbak's notes on [2-3 trees](https://www.cs.emory.edu/~cheung/Courses/253/Syllabus/Trees/Docs/Turbak=2-4-trees.pdf).

For example, `del v t` can be drawn as:

![Notation for `del v t`](/assets/rbt/notation-0.png)

When the color of a node does not matter, we will write it as a dashed box.

For `baldL l x r`, we indicate this by the "bubble" (or "trail mix"):

![Notation for `baldL l x r`](/assets/rbt/notation-1.png)

Simiarly, `baldR l x r` has the "bubble" (or "trail mix") on the right
leg:

![Notation for `baldR l x r`](/assets/rbt/notation-2.png)

Last, for `fuse l r`, we indicate this by writing a double bar
connecting the triangles:

![Notation for `fuse l r`](/assets/rbt/notation-3.png)

## Downward phase

When we try to perform `del x t`, what we do depends on the structure
of `t`. We will use the notation for a non-empty Red-Black tree whose
root node is colored Black:

![Notation for non-empty tree with Black root node](/assets/rbt/notation-4.png)

Similarly, for a Red-Black tree (subtree) whose root node is colored
Red:

![Notation for non-empty tree with Red root node](/assets/rbt/notation-5.png)

Now we will suppose $w\lt x\lt y$ for the sake of discussion. We have
the following downward rules.

When we are deleting `v` from a tree `Node(_,l,x,r)` with `v < x` and
`color l = Black` (and `l` is not a Leaf), we drop a piece of trail
mix on the left leg of `x`, and continue trying to delete in the left subtree:

![Diagram for `del v (Node (_,l,x,r))`](/assets/rbt/downward-rule-0.png)

When the `color l = Red`, then no trail mix is left behind:

![Diagram for `del v (Node (_,l,x,r))`](/assets/rbt/downward-rule-1.png)

Similarly for `del y t`, we move down the right subtree. When the
right subtree is Black-rooted and non-empty, i.e.,
`del y (Node (_, l, x, r))` with `color r = Black` and `r` is not a Leaf:

![Diagram for `del y (Node (_,l,x,r))`](/assets/rbt/downward-rule-2.png)

For `del y (Node (_,l,x,r))` when the right sub-tree `r` is not a Leaf
and `color r = Red`, we do not leave behind any trail mix and just
recurse down the right subtree:

![Diagram for `del y (Node (_,l,x,r))`](/assets/rbt/downward-rule-3.png)

When we have `del x (Node (_,l,x,r))`, we will simply return `fuse l r`:

![Diagram for `del x (Node (_,l,x,r))`](/assets/rbt/downward-rule-4.png)

Last, when trying to delete something from a Leaf, we just return the
Leaf; i.e., `del x Leaf = Leaf`:

![Diagram for `del x Leaf`](/assets/rbt/downward-rule-5.png)

**What remains to be done?**

- We need to give the algorithm for `fuse l r`
- We need to work out the rules for the upward rebalancing. The trail
  mix ("bubbles") tell us when we need to rebalance the tree below it.

## Deriving `baldL`

We can examine the implementation of `baldL` from looking at a few
well-chosen examples. This gives us `baldR` by swapping "left" with "right".

Consider the following Red-Black tree (where we focus on the left
subtree, and pretend the right subtree is valid and abstracted away):

![Motivating example of deleting a node in a Red-Black tree diagram](/assets/rbt/img-4.png)

Suppose we want to delete the node containing `a`. If we just
"naively" do this, then we end up with the following (invalid)
Red-Black tree:

![Removing node 'a' from the previous example](/assets/rbt/img-5.png)

This is invalid because the leaves are not on the same level anymore
(i.e., we violated the Black invariant).

There are two possible valid Red-Black trees obtainable from juggling
the subtree rooted at `e` around. The first possibility is just a
single left rotation:

![One possible subtree](/assets/rbt/img-6.png)

And the second possibility is a double left rotation:

![The other possible subtree](/assets/rbt/img-7.png)

It's left as an exercise to the reader to verify these are the only
possible subtrees which are themselves valid Red-Black trees.

Ah, for _valid_ Red-Black trees, these are the only choices. What
about for infrared Red-Black trees? The reader can verify that the
only infrared trees are these two, but with the root nodes painted
Red.

**It is conventional to use Infrared trees to indicate "underflow" has
occurred, to flag that re-balancing must occur.** Towards that end, we
should consider these possibilities with the root nodes painted Red.

But we have two possibilities, which one should we choose?

If we have a more general situation, the `m`-rooted tree 

## Appendix: 2-3 and 2-4 Tree Delete Does Not Translate to Red-Black Trees
