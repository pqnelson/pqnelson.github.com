---
layout: post
title: Toy Object System
published: true
quote: "If the pros at Sun had had a chance to fix Java, the world would be a much more pleasant place. This is not secret knowledge. It’s just secret to this pop culture."
quoteSource: Alan Kay, "A Conversation with Alan Kay" <a href="http://queue.acm.org/detail.cfm?id=1039523">ACM Queue</a> <strong>2</strong> no.9 (2004)
tags: [Java Virtual Machine]
---

<a name="introduction" />

# Introduction

We will implement a toy object system that has the same overall
structure as the JVM's system "under the hood".

We do this in Clojure out of habit/simplicity/stubbornness.

(Well, it's because I want to illustrate how the JVM handles object
orientedness in a toy model. It's the next topic I'm covering in
my endless series "How does the JVM work?")

**Contents**

* [Introduction](#introduction)
* [Toy Object System](#toy-object-system)
  * [Creating a Class](#toy-creating-class)
  * [Creating Objects](#toy-creating-objects)
  * [Objects and State](#toy-objects-and-state)
  * [Methods](#toy-methods)
    * [Adding "This" functionality](#toy-adding-this)
  * [Fields](#toy-fields)
  * [Inheritance](#toy-inheritance)
    * [Fields in Complicated Object Systems](#toy-complicated-fields)
* [Putting it all Together](#all-together)
* [Conclusion](#conclusion)
* [References](#references)

<a id="toy-object-system" />

# Toy Object System

The overall object system consists of closures, the objects are
glorified hash-maps. Clojure allows us to do this quite elegantly.

<a name="toy-creating-class" />

## Creating a Class

We will declare classes with just their name so far. They are little
more than a closure.

```clojure
(defn declare-class [class-name]
  (fn [command & args]
    (condp = command
      :name class-name)))
      
(defmacro defclass [class-name]
  `(def ~class-name (declare-class '~class-name)))
```

<a name="toy-creating-objects" />

## Creating Objects

Since a class is a closure, an object likewise will be a closure. A
first pass at instantiation will be:

```clojure
(defn make-object [klass]
  (fn [command & args]
    (condp = command
     :class klass
     :class-name (klass :name))))
```

But we can now say that a class is-an object! We could have

```clojure
(defn declare-class [class-name]
  (fn class-declaration [command & args]
    (condp = command
     :name class-name
     :new (make-object class-declaration))))
```

A class-declaration is-an instance of a class. For a fuller discussion
of these abstract definitions and concrete instances, see Stepanov and
McJones' *Elements of Programming*.

<a name="toy-objects-and-state" />

## Objects and State 

We use objects to store state. Hence we introduce getter and setter
methods:

```clojure
(defn make-object [klass]
  (let [state (ref {})]
    (fn [command & args]
      (condp = command
        :class klass
        :class-name (klass :name)
        :set! (doseq [[k v] args]
                (dosync (alter state assoc k v)))
        :get (let [[key] args]
               (get @state key))))))
```

<a name="toy-methods" />

## Methods

Ultimately, we want to have something like

```clojure
(defclass Person
  (method speak []
    (str "Bow wow"))
  (method age []
    (* 21 2)))
```

We thus specify a method declaration as a key-value pair, where the key
is the identifier as-a keyword and the value is the method as-a function:

```clojure
;; sexp destructured as ('method method-name [& params] & body)
(defn method-spec [sexp]
  (let [method-name (keyword (second sexp))
        body (next sexp)]
    [method-name (cons 'fn body)]))

(defn method-specs [sexps]
  (some->> sexps
           (filter #(= 'method (first %)))
           (mapcat method-spec)
           (apply hash-map)))
```

So a class declaration becomes

```clojure
(defn declare-class [class-name & methods]
  (fn class-declaration [command & args]
    (condp = command
     :name class-name
     :new (make-object class-declaration)
     :methods (method-specs methods)
     :method (get (method-specs methods) (keyword command)))))

(defmacro defclass [class-name & methods]
  `(def ~class-name (declare-class ~class-name ~@methods)))
```

Likewise, method invocation becomes:

```clojure
(defn make-object [klass]
  (let [state (ref {})]
    (fn [command & args]
      (condp = command
        :class klass
        :class-name (klass :name)
        :set! (doseq [[k v] args]
                (dosync (alter state assoc k v)))
        :get (let [[key] args]
               (get @state key))
        (if-let [method (klass :method command)]
          (apply method args)
          (throw (RuntimeException. (str "Unable to find " command))))))))
```

<a name="toy-adding-this" />

### Adding "This" functionality

We want to consider a method of the form

```clojure
(defclass Person
  (method age []
    (* 21 2))
  (method speak-age []
    (println (str "I am" (this :age) "years old"))))
```

How do we implement `this`? We have to forward declare it and modify the
method invocation:

```clojure
(declare this)

(defn make-object [klass]
  (let [state (ref {})]
    (fn object-instance [command & args]
      (condp = command
        ; old conditions omitted for clarity
        (binding [this object-instance]
          (if-let [method (klass :method command)]
            (apply method args)
            (throw (NoSuchMethodError. (str "Unable to find " command)))))))))
```

<a name="toy-fields" />

## Fields

An object keeps track of state, which we sort-of do...albeit in a hacked
up manner which doesn't keep track of anything. 

We want to write something like:

```clojure
(defclass Person
  (field age 0)
  (field name "Stumpy McGee")
  (method speaks []
    (println (str "Hello, my name is" 
               (this :name) 
               "and I am" 
               (this :age) 
               "years old")))
  (method toString []
    (str "Person { name: " (this :name) ", age: " (this :age) "}")))
```

The generic field would be `(field identifier & initial-val)`. 
So we need to filter out the fields from the class body, then construct
the fields this way.

```clojure
(defn field-spec [[_ id & [val]]]
  [(keyword id) val])

(defn field-specs [class-body]
  (->> class-body
       (filter #(= 'field (first %)))
       (mapcat field-spec)
       (apply hash-map)))
```

We modify the `make-object` function to use the specified fields:

```clojure
(defn set-field [state k v]
  (if (contains? @state k)
    (dosync (alter state assoc k v))
    (throw (IllegalAccessError. (str "Unknown field " k " accessed")))))
    
(defn get-field [state k]
  (get @state k
    (throw (IllegalAccessError. (str "Unknown field " k " accessed")))))

(defn initialize-object [klass fields]
  (let [init-fields (klass :fields)]
    (if-let [bad-k (some (comp nil? (set (keys init-fields))) (keys fields))]
      (throw (IllegalAccessError. (str "Bad field " bad-k)))
      (merge init-fields fields))))

(defn make-object
  ([klass] (make-object klass {}))
  ([klass fields]
    (let [state (ref (initialize-object klass fields))]
      (fn [command & args]
        (condp = command
          ;; snip
          :set! (set-field state (first args) (second args))
          :get (get-field state (first args))
          ;; snip
          )))))
```

Likewise, we'll need to modify the class declaration to include an extra
field:

```clojure
(defn declare-class [class-name & body]
  (fn class-declaration [command & args]
    (condp = command
      ;; snip
      :fields (field-specs body)
      ;; snip
      )))
```

<a name="toy-inheritance" />

## Inheritance

We modify the class declaration to include a stack of superclasses.

Method invocation then looks in the current class for the method. If it
can't be found, it loops through each of the superclasses in the
`superclass-stack` and attempts to lookup the method in each of the
superclass. 

```clojure
(defclass Animal
  (method speak []
    (println "Bow Wow")))
    
(defclass Person
  (extends Animal)
  (method speak []
    (println "Get your hands off of me, you damn dirty animal!")))

;; (lookup-method
;;   (or (find-in-current-class method-name)
;;       (find-in-super-classes method-name)))

(defn lookup-super-method [method-name superclass]
  (let [methods (parent :methods)]
    (get methods method-name)))

(defn lookup-method [method-name methods superclass-stack]
  (or (methods method-name)
      (loop [[parent & stack] superclass-stack]
        (or (lookup-super-method method-name parent)
            (when parent (recur stack))))
      (throw (NoSuchMethodError. "Method " method-name " does not exist"))))

(defn declare-class [class-name & class-body]
  (let [methods (method-specs (filter #(= 'method (first %)) class-body))
        [_ superclass] (first (filter #(= 'extends (first %)) class-body))
        stack (if-not superclass 
                ['ToyObject]
                (cons superclass (superclass :superclass-stack)))]
    (fn class-declaration [command & args]
      (condp = command
       :name class-name
       :superclass-stack stack
       :parent (first stack)
       :new (make-object class-declaration)
       :methods methods
       :method (lookup-method (keyword (first args)) methods stack)))))
```

Why do we do this? Because it emulates the structure of the low-level
inheritance the JVM implements.

<a name="toy-complicated-fields" />

### Fields in Complicated Object Systems

We will try to implement fields in an object system by changing the
state to be a hash-map of the form `{class-name => {field-name =>
val}}`. So, we'd expect a generic state for the hierarchy:

```clojure
(defclass Animal
  (field age 0)
  (method toString []
    (str "Animal, age " (this :age))))
    
(defclass Person
  (extends Animal)
  (field name)
  (method toString []
    (str "Person named " (this :name) ", age " (this :age))))
```

A generic state for a `Person` object would be:

```clojure
{:Animal {:age 0}
 :Person {:name nil}}
```

Getter and setter methods should loop through the superclass stack,
after first checking through its fields.

```clojure
(defn set-field [state klass k v]
  (or 
    (loop [[parent & stack] (cons klass (klass :superclass-stack))]
      (if (contains? (@state (keyword (parent :class-name))) k)
        (do (dosync (alter state assoc-in [(keyword (parent :class-name)) k] v))
            v)
        (when parent (recur stack))))
     (throw (IllegalAccessError. (str "Unknown field " k " accessed")))))

(defn get-field [state klass k]
  (or (get-in state [(keyword (klass :class-name)) k])
      (loop [[parent & stack] (klass :superclass-stack)]
        (if-let [val (get-in state [(keyword (parent :class-name)) k])]
          val
          (when parent (recur stack))))
      (throw (IllegalAccessError. (str "Unknown field " k " accessed")))))

(defn initialize-object [klass fields]
  (into {}
        (for [parent (cons klass (klass :superclass-stack))]
          [(keyword (parent :class-name))
           (merge (parent :fields)
                  (select-keys fields (keys (klass :fields))))])))

(defn make-object
  ([klass] (make-object klass {}))
  ([klass fields]
    (let [state (ref (initialize-object klass fields))]
      (fn [command & args]
        (condp = command
          ;; snip
          :set! (set-field state klass (first args) (second args))
          :get (get-field @state klass (first args))
          ;; snip
          )))))
```

<a name="all-together" />

# Toy Object System: All Together

So combining everything together, we have:

```clojure
(declare this ToyObject make-object)

(defn set-field [state klass k v]
  (or 
    (loop [[parent & stack] (cons klass (klass :superclass-stack))]
      (if (contains? (@state (keyword (parent :class-name))) k)
        (do (dosync (alter state assoc-in [(keyword (parent :class-name)) k] v))
            v)
        (when parent (recur stack))))
    (throw (IllegalAccessError. (str "Unknown field " k " accessed")))))

(defn get-field [state klass k]
  (or (get-in state [(keyword (klass :class-name)) k])
      (loop [[parent & stack] (klass :superclass-stack)]
        (if-let [val (get-in state [(keyword (parent :class-name)) k])]
          val
          (when parent (recur stack))))
      (throw (IllegalAccessError. (str "Unknown field " k " accessed")))))

(defn initialize-object [klass fields]
  (into {}
        (for [parent (cons klass (klass :superclass-stack))]
          [(keyword (parent :class-name))
           (merge (parent :fields)
                  (select-keys fields (keys (klass :fields))))])))

(defn make-object 
  ([klass] (make-object klass {}))
  ([klass fields]
    (let [state (ref (initialize-object klass fields))]
      (fn [command & args]
        (condp = command
          :class klass
          :class-name (klass :name)
          :set! (set-field state klass (first args) (second args))
          :get (get-field @state klass (first args))
          (binding [this object-instance]
            (if-let [method (klass :method command)]
              (apply method args)
              (or
                (get-field @state klass command)
                (throw (RuntimeException. (str "Unable to find " command)))))))))))

;; (lookup-method
;;   (or (find-in-current-class method-name)
;;       (find-in-super-classes method-name)))

(defn lookup-super-method [method-name superclass]
  (let [methods (parent :methods)]
    (get methods method-name)))

(defn lookup-method [method-name methods superclass-stack]
  (or (methods method-name)
      (loop [[parent & stack] superclass-stack]
        (or (lookup-super-method method-name parent)
            (when parent (recur stack)))
      (throw (NoSuchMethodError. "Method " method-name " does not exist")))))

;; sexp destructured as ('method method-name [& params] & body)
(defn method-spec [sexp]
  (let [method-name (keyword (second sexp))
        body (next sexp)]
    [method-name (cons 'fn body)]))

(defn method-specs [sexps]
  (some->> sexps
           (filter #(= 'method (first %)))
           (mapcat method-spec)
           (apply hash-map)))

(defn field-spec [[_ id & [val]]]
  [(keyword id) val])

(defn field-specs [class-body]
  (->> class-body
       (filter #(= 'field (first %)))
       (mapcat field-spec)
       (apply hash-map)))

(defn declare-class [class-name & class-body]
  (let [methods (method-specs (filter #(= 'method (first %)) class-body))
        [_ superclass] (first (filter #(= 'extends (first %)) class-body))
        stack (if-not superclass 
                ['ToyObject]
                (cons superclass (superclass :superclass-stack)))]
    (fn class-declaration [command & args]
      (condp = command
       :name class-name
       :superclass-stack stack
       :fields (field-specs class-body)
       :parent (first stack)
       :new (make-object class-declaration)
       :methods methods
       :method (lookup-method (keyword (first args)) methods stack)))))
       
(defmacro defclass [class-name & class-body]
  `(def ~class-name (declare-class ~class-name ~@class-body)))
  
(defclass ToyObject)
```

<a name="conclusion" />

# Conclusion

We have implemented a toy object system which has the same overall
structure as the Java Object system's. 

If one were bored enough to extend this model, one would probably
consider interfaces. Also initializing an object must check all  the
parameters actually belong to the class (or one of the superclasses),
and throw an error otherwise.

We should also consider enforcing the principle "a class extends at
most one superclass". Right now, we just take the first class that the
child class extends and run with it. An error should be thrown.

<a name="references" />

# References
1. Alexander Stepanov, Paul McJones, *Elements of Programming*.
   Addison-Wesley Professional, 2009.
2. Amit Rathore, *Clojure in Action*. Manning Publishers, 2012.
3. The [Java 8 VM Specifications](http://docs.oracle.com/javase/specs/jvms/se8/html/index.html)
