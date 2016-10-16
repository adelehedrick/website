+++
title = "Breaking Problems Down, Then Building Them Up in Clojure"
description = ""
tags = [
    "clojure",
    "set-up",
	"java",
	"classes"
]
date = "2016-10-12"
categories = [
    "Clojure",
]
banner = "img/banners/setting-up-clojure.jpg"
draft=true
+++

## Before We Begin

I'm assuming you have the Clojure JAR and know how to run a basic script and a REPL. If you need a reminder head on to [Getting Started with Clojure]({{< ref "blog/getting-started-clojure.md" >}}) and [Making Classes From Clojure]({{< ref "blog/clojure-classes.md" >}}) to get yourself caught up.

This post is also assuming that you are running Ubuntu or some other Linux flavor.

## Project Setup

Let's all just get a script set up that is in the same folder as the `csci3055u-a1.txt` file from the first assignment and our Clojure JAR.

```
wget https://adelehedrick.github.io/Fall-2016-CSCI-3055U/files/csci3055u-a1.txt
wget http://repo1.maven.org/maven2/org/clojure/clojure/1.8.0/clojure-1.8.0.zip
unzip clojure-1.8.0.zip
mv clojure-1.8.0/clojure-1.8.0.jar ./
rm -rf clojur-1.8.0
rm clojure-1.8.0.zip
```

You are then going to create a new file called `clojure_tutorial.clj` in the current directory in your favourite editor.

```
gedit tutorial.clj
```
 
## Setup Hello World

You need to define a namespace, which is the same as the file path and name of this file in reference to where it will be executed from. Since we are just going to execute it in the current directory, we just need to define the namespace as the file name, without the extension.

To make sure the world knows we are here, let's say hello.

{{< highlight clojure >}}
(ns tutorial)
    
(println (str "Hello World"))
{{</highlight>}}

```bash
$ java -cp clojure-1.8.0.jar clojure.main tutorial.clj
Hello World
```

The world knows we are here, so now let's start solving world problems, such as...

## What is the nth column's value in each line of the text file?

Big world problem right here, which is made bigger when you are trying to write in a functional language, but are still thinking in OOP.

Let's make a to-do list for this problem, or at least break it down into smaller problems. You can even write your to-do list while wearing your OOP hat still.

 1. Read in the file *somehow*
 2. Iterate over the contents line by line
 3. Break the line apart
 4. Access the nth element of the line
 
Now we have to switch to the functional programming hat. What helps me do this, is to constantly think in terms of input-output. I want the output of function A to become the input of function B, so then the function A will end up being wrapped in function B. Seems strange, but this nesting thing will catch on.

## Spit everything out so we can see what happens!

We need to `use` the `'clojure.java.io` library to do input-output and access the `reader` function which will open up the file of the file name we hand it.

Just for fun, let's open up the file and create a reader `r`, and just spit it out to the console using println.

{{< highlight clojure >}}
(ns tutorial)
(use 'clojure.java.io)
    
(with-open [r (reader "csci3055u-a1.txt")]
  (println r))
{{</highlight>}}

```bash
$ java -cp clojure-1.8.0.jar clojure.main tutorial.clj
#object[java.io.BufferedReader 0x4de8b404 java.io.BufferedReader@4de8b404]
```

Just as we expected! An object of the BufferedReader class. 

## Actually spit everything out!

Here is where we start thinking of the input-output of functional programming. I want a function that will output the lines of text in the reader. So I need a function that takes the input of a reader and gives the output of some kind of collection of items (in this case strings of lines). The function that I need, and many of you have seen a couple times by now is the [line-seq](https://clojuredocs.org/clojure.core/line-seq).

Sequences are mind boggling at first. Every time you ask a sequence "can I have the next item?" it replies "here it is!" or "no more items." In Clojure, every collection can be treated as a sequence, but what is not so blatantly explained anywhere, is that a sequence can be treated like a collection! Maybe not literally, but I haven't found evidence to the contrary, so let's go with that.

{{< highlight clojure >}}
(ns tutorial)
(use 'clojure.java.io)
    
(with-open [r (reader "csci3055u-a1.txt")]
  (println (line-seq r)))
{{</highlight>}}

```bash
$ java -cp clojure-1.8.0.jar clojure.main tutorial.clj
(201609|Foun.of Ditgl Teach & Lrn Tech|AEDT 1120U|12|M|10|13|0|Virtual ONLINE11 201609|Foun.of Ditgl Teach & Lrn Tech|AEDT 1120U|18|M|10|19|0|Virtual ONLINE9 201609|Digital Commun. Technologies|AEDT 1160U|12|M|10|13|0|Virtual ONLINE10 201609|Digital Commun. Technologies|AEDT 1160U|18|M|10|19|0|Virtual ONLINE5 201609|Graphic Desgn, Digtl Tech.|AEDT 2130U|12|W|10|13|0|Virtual ONLINE12 201609|Graphic Desgn, Digtl Tech.|AEDT 2130U|18|W|10|19|0|Virtual ONLINE9 201609|Graphic Desgn, Digtl Tech.|AEDT 2130U|20|W|10|21|0|Virtual ...
```

We have spat out everything! But did we? Let's look at the file...

```bash
201609|Foun.of Ditgl Teach & Lrn Tech|AEDT 1120U|12|M|10|13|0|Virtual ONLINE11
201609|Foun.of Ditgl Teach & Lrn Tech|AEDT 1120U|18|M|10|19|0|Virtual ONLINE9
201609|Digital Commun. Technologies|AEDT 1160U|12|M|10|13|0|Virtual ONLINE10
201609|Digital Commun. Technologies|AEDT 1160U|18|M|10|19|0|Virtual ONLINE5
201609|Graphic Desgn, Digtl Tech.|AEDT 2130U|12|W|10|13|0|Virtual ONLINE12
201609|Graphic Desgn, Digtl Tech.|AEDT 2130U|18|W|10|19|0|Virtual ONLINE9
201609|Graphic Desgn, Digtl Tech.|AEDT 2130U|20|W|10|21|0|Virtual ONLINE10
```

To start we see that the line-seq has split the contents of the file by newlines, I'm happy with that, but we printed something a little extra to the console... can you see it? Right at the very beginning? I'm going to pretend everyone nods their head, and one excited person screams "THE ROUND BRACKET!" This looks far too similar to a list though, which could be defined `(1 2 3 4)`, but that's fine since a list is a collection, and a sequence can be treated like a collection.

## Break the line apart

Let's just quickly look at our to-do list:

 1. ~~Read in the file *somehow*~~
 2. ~~Iterate over the contents line by line~~
 3. Break the line apart
 4. Access the nth element of the line
  
Believe it or not, we are doing 1 and 2, but not so blatantly, and I guess we really are just printing the entire sequence of lines as a whole collection, rather than individual items or lines. We will correct that right now with 3.

I want to break each line apart so that I can do 4. Access the nth element of the line. Breaking the line apart sounds like a good function to create where we take a string, and break it apart on a character, in this case the `|`.

Before our `with-open` we need to declare our function, lets call this function `get-nth`.

{{< highlight clojure >}}
(ns tutorial)
(use 'clojure.java.io)

(defn get-nth [ln]
  )
    
(with-open [r (reader "csci3055u-a1.txt")]
  (println (line-seq r)))
{{</highlight>}}

I want to split the `ln` on the `|` which I can do using the split function like so `(split ln #"\|")`.

{{< highlight clojure >}}
(ns tutorial)
(use 'clojure.java.io)

(defn get-nth [ln]
  (split ln #"\|"))
    
(with-open [r (reader "csci3055u-a1.txt")]
  (println (line-seq r)))
{{</highlight>}}

Before I get too far ahead of myself, I need to make sure things work by calling this function and printing it out. Now I want to apply this function to every line in the sequence created by the `line-seq`. Not to be confused with the [apply](https://clojuredocs.org/clojure.core/apply) function that applies a function to a collection as if the collection is exploded (sorry I'm an old PHP programmer) with the contents handed to the function as arguments (`apply` might be useful in the assignment though). The function that we want is [map](https://clojuredocs.org/clojure.core/map), which is not to be confused with the data collections of hash-maps and such. Maps work in the fashion of `(map fun coll)` where the function `fun` gets applied to every element in `coll` and then returns a lazy sequence of the values. You can think of this as transforming each element by a function, so you then have a new collection of transformed elements. 

So I need to inject the `map` function into `(println (line-seq r))` and I need to do it in such a way that the *output* of the `line-seq` is the *input* of the `map` function. This is where the nesting comes in. We are going to *nest* the `line-seq` inside of the `map`, so the output of `line-seq` becomes the input of `map`.

{{< highlight clojure >}}
(ns tutorial)
(use 'clojure.java.io)

(defn get-nth [ln]
  (split ln #"\|"))
    
(with-open [r (reader "csci3055u-a1.txt")]
  (println (map get-nth (line-seq r))))
{{</highlight>}}

```bash
$ java -cp clojure-1.8.0.jar clojure.main tutorial.clj
Exception in thread "main" java.lang.RuntimeException: Unable to resolve symbol: split in this context, compiling:(/home/delio/Desktop/tutorial/tutorial.clj:5:2)
	at clojure.lang.Compiler.analyze(Compiler.java:6688)
	at clojure.lang.Compiler.analyze(Compiler.java:6625)
...
```

Whoops! Clojure has no idea what `split` is! I need to `use` the string library!

{{< highlight clojure >}}
(ns tutorial)
(use 'clojure.java.io)
(use 'clojure.string)

(defn get-nth [ln]
  (split ln #"\|"))
    
(with-open [r (reader "csci3055u-a1.txt")]
  (println (map get-nth (line-seq r))))
{{</highlight>}}

```bash
$ java -cp clojure-1.8.0.jar clojure.main tutorial.clj
WARNING: reverse already refers to: #'clojure.core/reverse in namespace: tutorial, being replaced by: #'clojure.string/reverse
WARNING: replace already refers to: #'clojure.core/replace in namespace: tutorial, being replaced by: #'clojure.string/replace
([201609 Foun.of Ditgl Teach & Lrn Tech AEDT 1120U 12 M 10 13 0 Virtual ONLINE11] [201609 Foun.of Ditgl Teach & Lrn Tech AEDT 1120U 18 M 10 19 0 Virtual ONLINE9] [201609 Digital Commun. Technologies AEDT 1160U 12 M 10 13 0 Virtual ONLINE10] [201609 Digital Commun. Technologies AEDT 1160U 18 M 10 19 0 Virtual ONLINE5] [201609 Graphic Desgn, Digtl Tech. AEDT 2130U 12 W 10 13 0 Virtual ONLINE12] [201609 Graphic Desgn, Digtl Tech. AEDT 2130U 18 W 10...
```
No errors! Win! So is our `split` function actually being applied? YES! If you look closely to our output you can see the `|` have been removed, and we have square brackets surrounding every line from the text file. The square brackets are because the `split` function actually returns a *vector* collection.

We are now officially iterating over the lines using map, and breaking them apart! 

## Access the 5th element and say Hi to Bruce Willis

To-do list recap:

 1. ~~Read in the file *somehow*~~
 2. ~~Iterate over the contents line by line~~
 3. ~~Break the line apart~~
 4. Access the nth element of the line
 
Since I want to access the nth element--but really I want the fifth element now since I'm thinking about the movie--we need to grab it from *every* line in the file, so we need to modify our `get-nth` function that gets applied to every line, and it was really a part of the initial purpose of the function. Clojure has a handy little function called [nth](https://clojuredocs.org/clojure.core/nth), which gets used like `(nth coll index)`.

So we want the *output* of the `split` function to be the *input* of our `nth` function, and the *output* of the `nth` function to be returned (and we want the 5th element now).

{{< highlight clojure >}}
(ns tutorial)
(use 'clojure.java.io)
(use 'clojure.string)

(defn get-nth [ln]
  (nth (split ln #"\|") 5))
    
(with-open [r (reader "csci3055u-a1.txt")]
  (println (map get-nth (line-seq r))))
{{</highlight>}}

```bash
$ java -cp clojure-1.8.0.jar clojure.main tutorial.clj
WARNING: reverse already refers to: #'clojure.core/reverse in namespace: tutorial, being replaced by: #'clojure.string/reverse
WARNING: replace already refers to: #'clojure.core/replace in namespace: tutorial, being replaced by: #'clojure.string/replace
(10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 40 40 40 10 40 40 10 40 10 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 10 40 10 10 40 10 40 10 10 40 10 10 10 10 10 10 10 10 10 10 10 10 40 40 10 10 10 10 40 40 40 40 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 10 10 10 10 10 40 40 40 40 40 10 10 10 10 10 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 40 40 40 40 40 40 40 40 40 40 40 40 10 10 10 10 40 40
```

 1. ~~Read in the file *somehow*~~
 2. ~~Iterate over the contents line by line~~
 3. ~~Break the line apart~~
 4. ~~Access the nth element of the line~~
 
World problem solved.

![mic drop](https://media4.giphy.com/media/DfbpTbQ9TvSX6/200w.gif#37)
