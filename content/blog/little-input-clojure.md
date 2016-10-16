+++
title = "A Little Input in Clojure"
description = ""
tags = [
    "clojure",
    "input",
    "if statement",
    "loop",
    "recur"
]
date = "2016-09-21"
categories = [
    "Clojure",
]
banner = "img/banners/clojure-input.jpg"
+++

## Before We Begin

Make sure that you have the Clojure JAR handy and know how to use it! If you don't remember, then check out this [post]({{< ref "blog/getting-started-clojure.md" >}}) to get yourself started!

I'm assuming you understand binding, loops and basic functions in Clojure by now, but anything I do here I will be sure to explain in detail to help reinforce your understanding.

Dr. Ken Pu has graciously provided some extremely relevant data for everyone to play with. So relevant that it might change your undergraduate lives at this very moment. He has provided--*drum roll please*--**the current listing of classes and rooms for this semester!** The relevance might elude you, but after your first assignment, you will see the value in this data!

### Step 1. Find a Happy Place

Find a happy place to put the files for this activity and make sure you know the path from the current directory to your Clojure JAR file. Better yet, why don't you copy that JAR file into your current directory.

### Step 2. Download the Data

Open up a terminal window for your current directory and download the file with a `wget`.

```bash
wget https://adelehedrick.github.io/Fall-2016-CSCI-3055U/files/csci3055u-a1.txt
```
### Step 3. Create a Clojure File

```bash
gedit read_file.clj
```
The next few steps will be from within this file you just created and opened.

### Step 4. "Use" the Clojure Java I/O Library

Start by telling Clojure that you want to use the io library

{{< highlight clojure >}}
(use 'clojure.java.io)
{{</highlight>}}

### Step 5. With-Open Goodness

As you know I/O comes with many risks. What if we lose connection to the file? What if the file is too big and we run out of memory? What if there is no file? That is why when doing I/O, you typically have to surround the block of code with a try-catch. You also need to *close* the file when you are done with it! So many things to worry about with I/O. 

Thankfully, Clojure has provided us with the [with-open](https://clojuredocs.org/clojure.core/with-open) function which looks like this:

{{< highlight clojure >}}
(use 'clojure.java.io)

(with-open [<file>]
    <body>)
{{</highlight>}}

*Note that I will use <...> as placeholders for awesomeness to come*

[with-open](https://clojuredocs.org/clojure.core/with-open) will open the file and surround it as well as the body of the function in a try-catch for us, as well as *close* the file when we are finished the body of the function!

### Step 6. Let's Bind a File to Something Short and Sweet

In Clojure we don't assign values to variables, we are too cool for that now. Instead, we *bind* values to *symbols*. The `[ ]` that we had beside the `with-open`, is what holds our bindings, which in this case will be a single symbol and value to be bound to it. 

We are going to use the [reader](https://clojuredocs.org/clojure.java.io/reader) function within the io library which takes a single argument--the file path/name--and bind it to something short like `r` for reader.

{{< highlight clojure >}}
(use 'clojure.java.io)

(with-open [r (reader "csci3055u-a1.txt")]
    <body>)
{{</highlight>}}

### Step 7. Read & Print

Let's just jump ahead a bunch of steps and start printing *something*! We are going to use the `println` function to print something that we read from the reader `r`.

In read_file.clj:

{{< highlight clojure >}}
(use 'clojure.java.io)
(with-open [r (reader "csci3055u-a1.txt")]
	(println (.read r)))
{{</highlight>}}

In terminal:
```bash
java -cp clojure-1.8.0.jar clojure.main read_file.clj
```

Output:
```bash
50
```

No errors! But let's just double check what's going on. The first line of the text file you have is actually :

```
201609|Foun.of Ditgl Teach & Lrn Tech|AEDT 1120U|12|M|10|13|0|Virtual ONLINE11
```
Where did the 50 come from? Turns out we read in a char, and printed the raw value of it rather than the char it represents. Let's fix that by telling the println to print the char that we read in.

In read_file.clj:
{{< highlight clojure >}}
(use 'clojure.java.io)
(with-open [r (reader "csci3055u-a1.txt")]
	(println (char (.read r))))
{{</highlight>}}

In terminal:
```bash
java -cp clojure-1.8.0.jar clojure.main read_file.clj
```

Output:
```bash
2
```

Success! We have read something in from the file and printed it to the console!

### Step 8. Keep Reading Till the End

We want to read-print-read-print..., so in other words we need to repeat a set of instructions. I'm sure you are all familiar with *for* loops and *while* loops, but again I will say that we are too cool for that now, because in Clojure we use recursion to loop over things!

In this next snippet, I had to refactor some things. The value read in by `.read r` is now bound to the symbol `c` during the initialization of the [loop](https://clojuredocs.org/clojure.core/loop). 

We check to see if `c` is anything but the end of the file (which is represented by `-1`). This `if` statement will actually become our stopping condition for the loop. 

Since we want to do two instructions concurrently we need to wrap the two statements in a [do](https://clojuredocs.org/clojure.core/do) function which allows us to evaluate the statements in order.

The first statement in our [do](https://clojuredocs.org/clojure.core/do) function prints the character that the `c` symbol represents. The second statement has the [recur](https://clojuredocs.org/clojure.core/loop) function which actually returns us to the beginning of our [loop](https://clojuredocs.org/clojure.core/loop), passing along the new value to be assigned to `c`. The value that we pass along is the next character read in from our reader `r`. 

In read_file.clj:
{{< highlight clojure >}}
(use 'clojure.java.io)
(with-open [r (reader "csci3055u-a1.txt")]
    (loop [c (.read r)] 
    	(if (not= c -1)
    	   (do
    	       (print (char c))
    	       (recur (.read r))))))
{{</highlight>}}

In terminal:
```bash
java -cp clojure-1.8.0.jar clojure.main read_file.clj
```

We have  now printed the entire file to the console, but in the worst possible way! So don't hand anything like this in. 

### Step 9. Do Better With Sequences

Sequences are powerful! Essentially, they let us take one item from a list/vector/array like collection without worrying about how big the collection it came from. We just deal with the items one at a time, and it is glorious and fast!

In the next snippet, the reader `r` is now going to become the input to the [line-seq](https://clojuredocs.org/clojure.core/line-seq), which as you can guess is a *sequence of lines* (isn't that exactly what a text file is anyway?).

The [doseq](https://clojuredocs.org/clojure.core/doseq) is similar to a 'for each' loop in other languages. To really hammer this home, what this statement is saying is that we want to 'do the body of the loop, to every line in the line sequence `ls`'
 
In read_file.clj:
{{< highlight clojure >}}
(use 'clojure.java.io)
(with-open [r (reader "csci3055u-a1.txt")]
	(doseq [ls (line-seq r)]
		(println ls)))
{{</highlight>}}

## Moving Forward

Want to see how we can extract specific values from the lines we read in? Head on over to the post on [doing the splits in Clojure]({{< ref "blog/split-clojure.md" >}}).