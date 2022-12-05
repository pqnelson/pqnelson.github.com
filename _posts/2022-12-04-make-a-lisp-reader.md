---
layout: post
title: Make a Lisp (Reader)
published: true
draft: false
quote: "A reader lives a thousand lives before he dies."
quoteSource: George R.R. Martin, <i>A Dance with Dragons</i> (2011)
tags: [Lisp]
---

I've been tinkering with making a lisp. Although we can use a regex to
tokenize the input stream, we would lose information (like line number)
which helps inform the user they have a bug in their code. My first
reaction was to write a Scanner to tokenize the input stream, then a
parser to form the Lisp data.

In fact, [I did this](https://github.com/pqnelson/mal/tree/6b5e968b0d11483aba880d1897d2dfed932558b4/wol).
Although I tested every flow possible for the Scanner and Parser, it was
an inelegant solution --- a "kludge".

I remember Common Lisp supported some exotic gadget called a "Reader
Macro". Perhaps they could help in this situation?

# The Naive Read Table

**Algorithm 1: "Naive" Read Using a Read Table.**
The naive read table ("draft negative one", if you will) consists of a
simple workflow, given an input stream:

1. Read a character from the input stream.
2. Is it an EOF character? If so, throw an error. Otherwise continue to
   the next step.
3. Is it whitespace? If so, go back to step one. Otherwise go to next step.
4. Start accumulating the characters to form a token (which will be discussed
   in a separate algorithm, for clarity), then interpret it as Lisp
   data. Return this data as the result.

(End of Algorithm 1)

We can sketch this algorithm out using a flowchart:

![Flowchart describing naive Lisp reader algorithm](/assets/LispReader-naive.svg)

**Algorithm 2: Accumulate yourself a token.**
We will continue reading one character at a time from our input stream,
until we encounter a whitespace character or we have exhausted the input
stream. At that point, we will take our "token in progress" and return
it to the user.
(End of Algorithm 2)

But this isn't terribly exciting, it's a simple lexer. The pidgin code
for such a thing would look like:

```java
public class NaiveReadTable {
    public(source) {
        // create a pushback reader with an 8-byte buffer
        this.source = new PushbackReader(source, 8);
        this.finished = false;
    }

    boolean isFinished() {
        if (!finished && (/* check if nothing is left in this.source */)) {
             this.finished = true;
        }
        return this.finished;
    }

    public Object read() {
        while (true) {
            if (this.isFinished()) return null;

            char next = this.source.nextChar();
            if (Character.isWhitespace(next)) {
                continue;
            } else {
                /* push `next` back into the reader, and then */
                return buildToken();
            }
        }
    }

    public Object buildToken() {
        StringBuffer buf = new StringBuffer();
        while(/* there's still some non-whitespace char to read */) {
            buf.append(this.source.nextChar());
        }
        return buf.toString();
    }
}
```

Of course, Java being Java, the [actual code](https://github.com/pqnelson/LispReader/blob/master/src/main/java/com/github/pqnelson/NaiveReadTable.java) requires a few more
details, but this is the essential idea of the naive reader algorithm.

# Reader Macros

The trick is to introduce a new data structure, a `ReaderMacro`. If we
were using Java 17, it would be a [functional interface](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/function/package-summary.html) of the form:

```java
import java.io.Reader;

interface ReaderMacro {
    public Object apply(Reader stream, ReadTable table);
}
```

What good is this? Well, we modify Algorithm 1 to now invoke reader
macros as we encounter characters to which they are bound. We
unfortunately have some freedom here with where we place this step.
Common Lisp appears to roughly place it _after_ skipping whitespace,
something like the following flow chart:

![Flowchart describing Common Lisp's reader algorithm](/assets/LispReader-cl.svg)

The disadvantage of this approach is that, well, consider the following
scenario: we want to keep track of the line number. Using this approach,
we have to hardcode it into the reader algorithm.

However, if we check for reader macros _before_ checking for whitespace,
then we could create a macro bound to `\n` which will increment the
line counter for us.

That is to say, we will need to use the algorithm summed up in the
following flow chart:

![Flowchart describing our Lisp Reader's read algorithm](/assets/LispReader.svg)

In either case, the reader class is modified to schematically look like:

```java
public class ReadTable {
    public(source) {
        this.source = new PushbackReader(source, 8);
        this.finished = false;
        // New!!!
        this.macroBindings = new Map<char, ReaderMacro>();
    }

    public addMacro(char symbol, ReaderMacro macro) {
        this.macroBindings.put(symbol, macro);
    }

    boolean isFinished() { /* same as before... */ }

    public Object read() {
        while (true) {
            if (this.isFinished()) return null;

            char next = this.source.nextChar();

            if (this.macroBindings.contains(next)) {
                ReaderMacro macro = this.macroBindings.get(next);
                return macro.apply(this.source, this);
            } else if (Character.isWhitespace(next)) {
                continue;
            } else {
                /* push `next` back into the reader, and then */
                return buildToken();
            }
        }
    }

    Object buildToken() {
        StringBuffer buf = new StringBuffer();
        while(/* there's still some non-whitespace char to read */) {
            if (/* the char is bound to a macro */) {
                this.source.unread(charReadIn);
                // Now the top of the stream is the char bound to a
                // ReaderMacro, which will be invoked next time the
                // `Reader::read()` method is invoked
                break;
            }
            buf.append(this.source.nextChar());
        }
        return buf.toString();
    }
}
```

The `ReaderMacro` will be supplied with its necessary input reader and
Lisp reader upon invocation, so there's no need for complicated factory
builders (or whatever design pattern could fit the bill).

Let us write unit tests to make sure this works as expected. We have a
simple `LineNumberCounter` reader macro, and then test it out:

```java
    /* ReadTableTest.java */
    @Test
    public void newlineMacroReaderTest() {
        ReadTable r = new ReadTable("    \t\n    \n\n\t\n\n  d");
        LineNumberCounter counter = new LineNumberCounter();
        r.addMacro('\n', counter);
        r.read();
        int expected = 6;
        assertEquals(expected, counter.getLine());
    }
```

And the exciting results:

```
[INFO]
[INFO] Results:
[INFO]
[ERROR] Failures:
[ERROR]   ReadTableTest.newlineMacroReaderTest:74 expected: <6> but was: <2>
[INFO]
```

Err, wait, what happened? Well, in the `ReadTable::read()` method, we
_always_ returned the result of the ReaderMacro, regardless of what it
might be (more specifically, we returned `null` when we should have kept
reading!). Let us remedy this:

```java
// ReadTable.java
    public Object read() {
        while (true) {
            if (this.isFinished()) return null;

            char next = this.source.nextChar();

            if (this.macroBindings.contains(next)) {
                ReaderMacro macro = this.macroBindings.get(next);
                // BUGFIX
                Object result = macro.apply(this.source, this);
                if (null != result) return result;
            } else if (Character.isWhitespace(next)) {
                continue;
            } else {
                /* push `next` back into the reader, and then */
                return buildToken();
            }
        }
    }
```

And it works as expected. Great!

# The Power of Reader Macros

We have seen one example where Reader Macros are useful. (In fact, we
could have had the `LineNumberCounter` class register
[`IntConsumer`](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/function/IntConsumer.html)
callbacks, which are invoked when the line number increments, for
example.)

What good is this besides an exercise in abstraction?

Well, we can assemble lists using reader macros alone. We have one macro
bound to `)` to recognize it as a single-character token. Additionally, we have
an `AccumulatorReaderMacro` which builds a list of read values until a
specific token is encountered, then the `AccumulatorReaderMacro` returns
the list of values.

In pidgin Java, the code looks like
```java
class AccumulatorReaderMacro implements ReaderMacro {
    private final String stopToken;

    public AccumulatorReaderMacro(final String delimiter) {
        this.stopToken = delimiter;
    }

    @Override
    public Object apply(Reader stream, AbstractReadTable table) {
        if (table.isFinished()) return null;

        ArrayList<Object> coll = new ArrayList<>();

        while (!table.isFinished()) {
            final Object entry = table.read();

            if (this.stopToken.equals(entry)) {
                break;
            }

            coll.add(entry);
        }

        return coll;
    }
}
```

Realistically, I believe we should throw an `IOException` if the
underlying stream has ended before we found the `stopToken`.

Now we can turn any `ReadTable` instance into a fairly decent Lisp
reader by binding `'('` to a `new AccumulatorReaderMacro(")")`, and
binding the `')'` to a single character tokenizing reader macro. Is it
really that simple?

Why ask when we can unit test!

```java
    @Test
    public void nestedNestedListTest() {
        String test = "(foo (eggs (scrambed (stuff) suggests) but) and spam)";
        ReadTable r = new ReadTable(test);
        r.addMacro(')', new SingleCharReaderMacro(")"));
        r.addMacro('(', new AccumulatorReaderMacro(")"));

        ArrayList<Object> tmp = new ArrayList<>();
        ArrayList<Object> inner = new ArrayList<>();
        inner.add("stuff");
        tmp.add("scrambed");
        tmp.add(inner);
        tmp.add("suggests");
        inner = tmp;
        tmp = new ArrayList<>();
        tmp.add("eggs");
        tmp.add(inner);
        tmp.add("but");

        ArrayList<Object> expected = new ArrayList<>();
        expected.add("foo");
        expected.add(tmp);
        expected.add("and");
        expected.add("spam");

        assertEquals(expected, r.read());
    }
```

The test succeeds with flying colors.

Want to implement a hashmap delimited by braces (like Clojure)? You can
do it with reader macros!

**Exercise 1:** Sketch out the code for a `ReaderMacroTransformer` which
will take a `ReaderMacro`, then transform the output somehow. Arguably,
we could imagine this summed up in a method
`ReaderMacro ReaderMacroTransformerFactory(Function<Object,Object> transformOutput, ReaderMacro)`,
which will compose the functions together producing a `ReaderMacro`
instance. What properties would we like these `ReaderMacroTransformer`
gadgets to satisfy?

Dually, could we "precompose" by a function? That is, could we
"transform" the `(Reader r, ReadTable t)` into another pair `(Reader r', ReadTable r')`
before it is applied to the `ReaderMacro`? When would this be useful?
(End of Exercise 1)

**Exercise 1, Part (ii):** Write a `ReaderMacroTransformer` which will
take an `AccumulatorReaderMacro` and form a `HashMap` from the list,
interpreting the list as a sequence of `key-value` pairs.
(End of Exercise 1.ii)

**Exercise 2:** Prove or find a counter-example, `ReaderMacros` form a
functor. Does it form a monad?
(End of Exercise 2)

**Exercise 3:** How can we modify the design of the `SingleCharReaderMacro`
class to guarantee it is bound in the Lisp Reader to the supplied character?
(End of Exercise 3)

**Exercise 4:** If the `AccumulatorReaderMacro` finds the Lisp Reader is
finished _before_ the closing delimiter is found, then it will return
the collection of values being accumulated. Is this a good design choice
or not? If not, what should we do instead? If it is good design, then
how do we indicate a list is runaway [i.e., not closed with a matching parentheses]?
(End of Exercise 4)

**Exercise 5:**
Change the code to use the `LineNumberCounter` with the
`AccumulatorReaderMacro` to track the starting line of the accumulated
values, for runaway lists (or maps or vectors or whatever).
(End of Exercise 5)

# Conclusion

We have sketched out how to implement a Lisp Reader using reader macros.
Of course, Lisp is a self-cannabilizing language: it will become
increasingly tempting to use the metalanguage [i.e., Java code] for a
Lisp anonymous function as the Reader Macro. This is a natural "next
step", but there is also power in preventing the user of the Lisp
interpreter from writing their own Reader Macros.

Also, we only examined the interesting moving parts of the Lisp Reader.
If we wanted to use this in an actual Lisp interpreter, we would need to
change the `read()` function to also encode the result as a Lisp value.
Right now, we're just returning the lexeme ("string fragment").

All the code is [available on github](https://github.com/pqnelson/LispReader).

# References

- _Common Lisp The Language_, specifically [Chapter
  22](https://www.cs.cmu.edu/Groups/AI/html/cltl/clm/node186.html#SECTION002600000000000000000)
  discusses the lisp reader in detail.