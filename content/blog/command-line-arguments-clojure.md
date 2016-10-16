+++
title = "Basics of Command Line Arguments in Clojure"
description = ""
tags = [
    "clojure",
    "set-up",
	"java",
	"classes"
]
date = "2016-09-22"
categories = [
    "Clojure",
]
banner = "img/banners/setting-up-clojure.jpg"
+++

## Before We Begin

This post is a continuation of the [classes post]({{< ref "blog/clojure-classes.md" >}}). So if it you're confused head on over there!

### Step 1. Open and edit hello.clj

In the project we made previously, open up the 'hello.clj' by entering `gedit hello.clj` in terminal.

We are now going to put a symbol in the parameter area of the main method declaration.

We are also going to change the output to include the name entered rather than "World".

{{< highlight clojure >}}
(ns hello
    (:gen-class))

(defn -main [name]
  (println (str "Hello " name "!")))
{{</highlight>}}

Save and close the file.

### Step 2. Open a REPL and compile

In terminal:
```bash
rlwrap java -cp ~/clojure-1.8.0.jar:. clojure.main
```

In REPL:
{{< highlight clojure >}}
(compile 'hello)
{{</highlight>}}

Output: 
```bash
hello
```

Success! Now you can exit the REPL with `CTRL + C`.

### Step 3. Execute the class file

In terminal:
```bash
java -cp ~/clojure-1.8.0.jar:./classes hello
```

Output:
```bash
Exception in thread "main" clojure.lang.ArityException: Wrong number of args (0) passed to: hello/-main
	at clojure.lang.AFn.throwArity(AFn.java:429)
	at clojure.lang.AFn.invoke(AFn.java:28)
	at clojure.lang.AFn.applyToHelper(AFn.java:152)
	at clojure.lang.AFn.applyTo(AFn.java:144)
	at hello.main(Unknown Source)
```

Whoops! Forgot the actual command line arguments! Let's give a shout out to our very own varsity member! #Power10!

In terminal:
```bash
java -cp ~/clojure-1.8.0.jar:./classes hello Christien
```

Output:
```bash
Hello Christien!
```

Success! I am so full of campus pride right now!

### Step 4. More arguments

Let's open up the 'hello.clj' file once again and change the arguments to two arguments; first and last.

In terminal:
```bash
gedit hello.clj
```

In hello.clj:
{{< highlight clojure >}}
(ns hello
    (:gen-class))

(defn -main [first last]
  (println (str "Hello " last ", " first "!")))
{{</highlight>}}

Save and close the file.

### Step 5. Recompile

You should have the line to open up the REPL still in your history, so press the up arrow till you find:
```bash
rlwrap java -cp ~/clojure-1.8.0.jar:. clojure.main
```

In REPL:
{{< highlight clojure >}}
(compile 'hello)
{{</highlight>}}

Output: 
```bash
hello
```

### Step 6. Say 'hello' to our professor

Again you should be able to press the up arrow till you find the write command, but don't forget to change the command line arguments.

```bash
java -cp ~/clojure-1.8.0.jar:./classes hello Ken Pu
```

Output:
```bash
Hello Pu, Ken!
```

### Step 7. Way more arguments to be less rude (ironic?)

Open up your 'hello.clj' again and this time we are going to get fancy.

In hello.clj:
{{< highlight clojure >}}
(ns hello
	(use [clojure.string :only (join)])
  (:gen-class))

(defn -main [first last prefix & msg]
  (println (str "Hello " prefix ". " first " " last "! " (join " " msg))))
{{</highlight>}}

Now I require that three arguments are provided; first, last and prefix. If there are any other arguments passed, the `&` is going to put the *rest* of them into the symbol `msg` as a list.

Since I want to actually output the rest of the arguments as a sentence, we need to take the list of words in `msg` and concatenate them together, in order, and separated by spaces. To use the join function, we will need to use the `clojure.string` library and *only* pull out the `join` function.

Save and close the file.

### Step 8. Recompile

You should have the line to open up the REPL still in your history, so press the up arrow till you find:
```bash
rlwrap java -cp ~/clojure-1.8.0.jar:. clojure.main
```

In REPL:
{{< highlight clojure >}}
(compile 'hello)
{{</highlight>}}

Output: 
```bash
hello
```

Sounds repetative, because it is. Thank you copy-paste!

### Step 9. Give a good greeting to our professor

In terminal:
```bash
java -cp ~/clojure-1.8.0.jar:./classes hello Ken Pu Dr Seen anything interesting on Hacker News lately?
```

Output:
```bash
Hello Dr. Ken Pu! Seen anything interesting on Hacker News lately?
```

You all should be argumenting pros now! 
