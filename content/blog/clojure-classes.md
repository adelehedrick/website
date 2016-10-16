+++
title = "Making Classes From Clojure"
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

I'm assuming you have the Clojure JAR and know how to run a basic script and a REPL. If you need a reminder head on to [Getting Started with Clojure]({{< ref "blog/getting-started-clojure.md" >}}) to get yourself caught up.

This post is also assuming that you are running Ubuntu or some other Linux flavor.

## Project Setup

### Step 1. Move the JAR to your home-sweet-home

For simplicity sake, I'm going to ask that you put your 'clojure-1.8.0.jar' file into your home directory so it is accessible via '~/clojure-1.8.0.jar'.

### Step 2. Create a project folder

Create a project folder somewhere other than your home folder. Perhaps in a place you normally put your projects?

### Step 3. Create a classes folder

At this point you can open up a terminal for your project folder. A cheap way to open a terminal for a window of a directory is to right click on the window, and select 'Open in Terminal'.

I'm now going to switch to doing most commands in terminal so we all can get cozy in this environment. 

Make the 'classes' folder with `mkdir classes` (this name is non-negotiable)

Confirm the folder by checking what's currently in the directory with `ls`.
 
### Step 4. Create a hello.clj

I'm just using gedit for everything since I'm lazy, so go ahead and create a 'hello.clj' file by entering `gedit hello.clj`.

In the hello.clj file I want you to enter:
{{< highlight clojure >}}
(ns hello
    (:gen-class))

(defn -main []
  (println (str "Hello World!")))
{{</highlight>}}

It is important to note that the [ns](http://clojure.github.io/clojure/clojure.core-api.html#clojure.core/ns) macro we called in the first line cooresponds to the name of our file. Supplying the `:gen-class` keyword will allow this file to compile into a class file of the same name as the namespace and the class is expected to have a main function.

Speaking of main functions, we declared one! Since we don't want any command line arguments (yet) we can just leave the parameter area blank.

You may now save and close this file.

### Step 5. Start a REPL

In terminal:
```bash
rlwrap java -cp ~/clojure-1.8.0.jar clojure.main
```
Notice the `~/` which points to the home folder no matter what directory you are currently in!

### Step 6. Compile in the REPL  

In REPL:
{{< highlight clojure >}}
(compile 'hello)
{{</highlight>}}

Output:
```bash
hello
```

Sweet! It spit out the name of our namespace!

Now enter `CTRL + C` to exit the REPL

### Step 7. Take a peek at the classes

Remember how I said it was important to create that 'classes' folder? Well it is because the Clojure compiler expects it to exist, and places all your class files in there.

In Terminal:
```bash
cd classes
ls
```

Output:
```bash
hello.class        hello__init.class                     hello$_main.class
hello$fn__5.class  hello$loading__5569__auto____3.class
```

Look at all those fancy classes! Now return back to your project folder.

In Terminal:
```bash
cd ..
```

### Step 8. Execute the classes

In Terminal:
```bash
java -cp ~/clojure-1.8.0.jar:./classes hello
```

Output:
```bash
Hello World!
```

Notice that we had to include the 'classes' folder in the classpath.

### Moving forward

My [next post]({{< ref "blog/command-line-arguments-clojure.md" >}}) will extend this post by adding command line arguments!
