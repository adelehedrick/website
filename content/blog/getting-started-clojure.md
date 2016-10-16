+++
title = "Getting Started with Clojure"
description = ""
tags = [
    "clojure",
    "set-up",
	"java"
]
date = "2016-09-18"
categories = [
    "Clojure",
]
banner = "img/banners/setting-up-clojure.jpg"
+++

## Before We Begin

This guide will be for setting up your environment in a Linux OS, I'm currently using Ubuntu. You will need Java version 1.6 or later, which is recommended by everything that I have read so far.

To check your Java version just open up a terminal and type:
```bash
java -version
```

Now you are probably thinking "why do we need Java? I thought we are programming in Clojure?" To answer your unasked question, the Clojure code you write will be compiled by the Clojure *compiler* to create Java Virtual Machine (JVM) bytecode. The Clojure compiler--that we will get to later on--is actually an executable JAR file, hence the need for Java.

## Get Clojure Up & Running

### Step 1. Download Clojure Zip

Let's start off by opening up a terminal, and navigating to a location you want the JAR. Once there use the `wget` command to download the zip folder:

```bash
wget http://repo1.maven.org/maven2/org/clojure/clojure/1.8.0/clojure-1.8.0.zip
``` 

### Step 2. Unzip

Unzip the folder to current directory.

```bash
unzip clojure-1.8.0.zip
```

### Step 3. Move the JAR into the Current Directory

If you enter `ls` you will find your new 'clojure-1.8.0' folder, and inside it is the 'clojure-1.8.0.jar' that we want. Let's pull that JAR out of its directory and bring it into the current directory.

```bash
mv clojure-1.8.0/clojure-1.8.0.jar ./
```


### Step 4. Test with a REPL

I go into more detail about the REPL in this [post]({{< ref "blog/first-clojure-repl.md" >}}), but for now just do these short steps:

 1. Enter `rlwrap java -cp clojure-1.8.0.jar clojure.main` 
 2. You are now in the Clojure REPL. Try `(+ 1 3)` and see if you get 4
 3. Exit out of the REPL by typing `CTRL + D`
 
*Note that if rlwrap doesn't work, then do a `sudo apt-get install rlwrap`*

### Step 4. Run a Clojure Script

REPLs are nice, but but what if you want to code offline and then run it? Let's quickly do that!

 1. Still in the same terminal window create a new Clojure file with `gedit hello.clj`
 2. In the file enter `(println "Hello World!")` then save and close the file
 3. Back in your terminal window you are going to run the same command as you did to start the Clojure REPL, but now you are going to provide it with a command line argument of the file name of the script you just wrote: `java -cp clojure-1.8.0.jar clojure.main hello.clj`. If you didn't get the expected output of `Hello World!` then something went wrong!
 
### Step 5. Break the Script

Let's take a quick look at what happens when there is a bug in your Clojure code. Being able to read/write code is very important, but so is being able to read *errors*!

 1. Open up the hello.clj again with `gedit hello.clj`
 2. Change `println` to something else (e.g. `printlny`)
 3. Now run the script again! `java -cp clojure-1.8.0.jar clojure.main hello.clj`
 
Errors!!

```bash
Exception in thread "main" java.lang.RuntimeException: Unable to resolve symbol: printlny in this context, compiling:(/home/delio/clojure_play/hello.clj:1:1)
	at clojure.lang.Compiler.analyze(Compiler.java:6688)
	at clojure.lang.Compiler.analyze(Compiler.java:6625)
	at clojure.lang.Compiler$InvokeExpr.parse(Compiler.java:3766)
	at clojure.lang.Compiler.analyzeSeq(Compiler.java:6870)
	at clojure.lang.Compiler.analyze(Compiler.java:6669)
	at clojure.lang.Compiler.analyze(Compiler.java:6625)
	at clojure.lang.Compiler$BodyExpr$Parser.parse(Compiler.java:6001)
	at clojure.lang.Compiler$FnMethod.parse(Compiler.java:5380)
	at clojure.lang.Compiler$FnExpr.parse(Compiler.java:3972)
	at clojure.lang.Compiler.analyzeSeq(Compiler.java:6866)
	at clojure.lang.Compiler.analyze(Compiler.java:6669)
	at clojure.lang.Compiler.eval(Compiler.java:6924)
	at clojure.lang.Compiler.load(Compiler.java:7379)
	at clojure.lang.Compiler.loadFile(Compiler.java:7317)
	at clojure.main$load_script.invokeStatic(main.clj:275)
	at clojure.main$script_opt.invokeStatic(main.clj:335)
	at clojure.main$script_opt.invoke(main.clj:330)
	at clojure.main$main.invokeStatic(main.clj:421)
	at clojure.main$main.doInvoke(main.clj:384)
	at clojure.lang.RestFn.invoke(RestFn.java:408)
	at clojure.lang.Var.invoke(Var.java:379)
	at clojure.lang.AFn.applyToHelper(AFn.java:154)
	at clojure.lang.Var.applyTo(Var.java:700)
	at clojure.main.main(main.java:37)
Caused by: java.lang.RuntimeException: Unable to resolve symbol: printlny in this context
	at clojure.lang.Util.runtimeException(Util.java:221)
	at clojure.lang.Compiler.resolveIn(Compiler.java:7164)
	at clojure.lang.Compiler.resolve(Compiler.java:7108)
	at clojure.lang.Compiler.analyzeSymbol(Compiler.java:7069)
	at clojure.lang.Compiler.analyze(Compiler.java:6648)
	... 23 more
```

This is an epic output! This stack trace shows you exactly where in the Clojure compiler JAR everything broke down, but most importantly it tells you where in your Clojure script it broke!

Look at the first line a little more closely:

```bash
Exception in thread "main" java.lang.RuntimeException: Unable to resolve symbol: printlny in this context, compiling:(/home/delio/clojure_play/hello.clj:1:1)
```
This tells me a lot! `Unable to resolve symbol: printly` tells me that the compiler encountered  something--in this case 'printly'--that is completely unknown, and therefore it can't be translated to JVM bytecode! The error then tells me where it encountered the problem by showing the file name, line number and column; `(/home/delio/clojure_play/hello.clj:1:1)`. Just to be clear, the first '1' is the line number, and the second is the column number.

## Moving Forward

Ready for more? Why don't you head over to the [post on making classes from Clojure files]({{< ref "blog/clojure-classes.md" >}})!
