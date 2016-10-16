+++
title = "Your First Leiningen REPL"
description = ""
tags = [
    "clojure",
    "set-up",
	"java",
	"leiningen"
]
date = "2016-09-19"
categories = [
    "Clojure",
]
menu = "clojure"
banner = "img/banners/first-clojure-repl.jpg"
+++

## Before We Begin

Have you installed Leiningen? It is a requirement of running the lein repl! If you have no idea what I am saying you can head on over to the [Setting Up Leiningen]({{< ref "blog/setting-up-lein.md" >}}) post

## Your First lein REPL

I like to think of the read-eval-print loop (REPL) as the *interactive programming* mode of a language. The first time you create a REPL through lein, it will download any extra files it needs. 

Open up one now in your terminal window with:
 
```bash
lein repl
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
