+++
title = "Taking Advantage of Bash Aliases for Clojure"
description = ""
tags = [
    "clojure",
    "set-up",
	"java",
	"aliases",
	"bash"
]
date = "2016-09-22"
categories = [
    "Bonus",
]
banner = "img/banners/setting-up-clojure.jpg"
+++

## Too much typing!

I don't know about you, but I am exhausted from typing in terminal all the characters I need to start a REPL, or execute Clojure class files.

A little birdy asked me how Ken has short forms for within terminal, and my response was "I don't know, we should Google that!" 

I think I have some pretty snazzy aliases (that's what Google said their called) now and I am willing to share them with you.

## Home for the Clojure JAR

For my aliases to work for you, you need to put your 'clojure-1.8.0.jar' into your home folder.

## The magical .bash_aliases

In terminal:
```bash
sudo gedit ~/.bash_aliases
```

Will open the file where all your aliases have been stored. Do *not* remove anything that is already there (don't be scared if the file is empty), but you can append some more to the bottom. 

Append the following to your .bash_aliases
```
alias cljrepl='rlwrap java -cp ~/clojure-1.8.0.jar:. clojure.main '
alias clj='java -cp ~/clojure-1.8.0.jar:. clojure.main '
alias cljclass='java -cp ~/clojure-1.8.0.jar:./classes '
```

Save and close.

The first alias `cljrepl` starts a REPL from your current directory with the rlwrap. The second alias `clj` is your basic REPL or execution. Finally the third alias `cljclass` is to be used from within your project folder one level up from your 'classes' folder.

## Try it out

If you still have the hello.clj from the [command line arguments post]({{< ref "blog/command-line-arguments-clojure.md" >}}), feel free to try out these tasks from a terminal in the project directory:

 1. Start a REPL with `cljrepl`
 2. In the REPL: `(compile 'hello)`
 3. `CTRL + C` to exit the REPL
 4. Execute the class with `cljclass hello Adele Hedrick Mrs I really appreciate you typing all this out!`
 5. Output: `Hello Mrs. Adele Hedrick! I really appreciate you typing all this out!`

Hope this makes your life easier!
