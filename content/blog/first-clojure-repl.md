+++
title = "Your First Clojure REPL"
description = ""
tags = [
    "clojure",
    "set-up",
	"java"
]
date = "2016-09-19"
categories = [
    "Clojure",
]
menu = "clojure"
banner = "img/banners/first-clojure-repl.jpg"
+++

## Before We Begin

Do you have the Clojure JAR? If not check out the [Setting Up Clojure]({{< ref "blog/getting-started-clojure.md" >}}) post

## Your First Clojure REPL

I like to think of the read-eval-print loop (REPL) as the *interactive programming* mode of a language. 

### Step 1. Find your Clojure JAR

First open a terminal window and navigate to where your Clojure JAR is located.

### Step 2. Run the main method!
 
```bash
rlwrap java -cp clojure-1.8.0.jar clojure.main
```

You will now see that you have a new prompt that looks like:

```bash
user=>
```

You are now ready to get your Clojure on! When starting a new language, it is good luck to do the typical "Hello World". To do this, we will use the `println` function. 

Type the following Clojure command to bring yourself lots of good luck with Clojure:

```clojure
(println "Hello World")
```

To leave the REPL, you just need to use `CTRL + D`
