+++
title = "Exploring Game of Thrones Dataset with Clojure"
description = ""
tags = [
    "clojure"
]
date = "2016-10-15"
categories = [
    "Clojure",
]
banner = "img/banners/setting-up-clojure.jpg"
+++

## Before We Begin

I'm assuming you have the Clojure JAR in your home directory (e.g. accessible via ~/.clojure-1.8.0.jar) and know how to run a basic script. If you need a reminder, head on to [Getting Started with Clojure]({{< ref "blog/getting-started-clojure.md" >}}) and [Making Classes From Clojure]({{< ref "blog/clojure-classes.md" >}}) to get yourself caught up.

This post is also assuming that you are running Ubuntu or some other Linux flavor.

The data set we are going to be using is the Game of Thrones dataset on Kaggle, so you will need to make an account so you can [download the zip](https://www.kaggle.com/mylesoneill/game-of-thrones).

## Setup Hello Realm

You need to define a namespace, which is the same as the file path and name of this file in reference to where it will be executed from. Since we are just going to execute it in the current directory, we just need to define the namespace as the file name, without the extension.

To make sure the realm knows we are here, let's say hello.

{{< highlight clojure >}}
(ns tutorial.got)
    
(defn -main []
  (println "Hello Realm"))
{{</highlight>}}

```bash
$java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got
Hello Realm
```

The realm knows we are here, so now let's start investigating the deaths!

## Print Out Deaths

Let's start by reading in the `character-deaths.csv` and printing the contents out to the console. To do any input-output we need to use the `clojure.java.io` library, so be sure to add it to your namespace.

We then need to add an argument to our main method to pass the name of the filename we wish to open.

Lastly, we want to use a `with-open` to to open the file, create a reader object, and then print the `line-seq` created from the reader. 

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io))
    
(defn -main [filename]
  (with-open [r (reader filename)]
  	(println (line-seq r))))
{{</highlight>}}

Now when we run our script, we need to include the "character-deaths.csv" into the arguments passed to the Clojure main method.

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
(Name,Allegiances,Death Year,Book of Death,Death Chapter,Book Intro Chapter,Gender,Nobility,GoT,CoK,SoS,FfC,DwD Addam Marbrand,Lannister,,,,56,1,1,1,1,1,1,0 Aegon Frey (Jinglebell),None,299,3,51,49,1,1,0,0,1,0,0 Aegon Targaryen,House Targaryen,,,,5,1,1,0,0,0,0,1 Adrack Humble,House Greyjoy,300,5,20,20,1,1,0,0,0,0,1 Aemon Costayne,Lannister,,,,,1,1,0,0,1,0,0 Aemon Estermont,Baratheon,,,,,1,1,0,1,1,0,0 Aemon Targaryen (son of Maekar I),Night's Watch,300,4,35,21,1,1,1,0,1,1,0 Aenys Frey,None,300,5,,59,0,1,1,1,1,0,1 Aeron Greyjoy,House Greyjoy,,,,11,1,1,0,1,0,1,0 Aethan,Night's Watch,,,,0,1,0,0,0,1,0,0 Aggar,House Greyjoy,299,2,56,50,1,0,0,1,0,0,0 Aggo,House Targaryen,,,,54,1,0,1,1,1,0,1 Alan of Rosby,Night's Watch,300,5,4,18,1,1,0,1,1,0,1 Alayaya,None,,,,15,0,0,0,1,0,0,0 Albar Royce,Arryn,,,,38,1,1,1,0,0,1,0 Albett,Night's Watch,,,,26,1,0,1,0,0,0,0 Alebelly,House Stark,299,2,46,4,1,0,0,1,0,0,0 Alerie Hightower,House Tyrell,,,,6,0,1,0,0,1,1,0 Alesander Staedmon,Baratheon,,,,65,1,1,0,1,0,0,0 Alester Florent,Baratheon,300,4,,36,1,1,0,1,1,0,0 Alia of Braavos,None,,,,28,0,0,1
...
```

## Grabbing the Headers and Values

Looking at the character-deaths.csv file, we see that the first line is actually the column headers. So what I would like to do is read in the first line, and for that line read in, to become the keys to the values afterwards.

So essentially I want the file to be parsed as a sequence of maps!

Now I need to do some restructuring, because I need to call on the `line-seq` once to get the keys, and then read in the rest as data. Since I need to call on the `line-seq` in two different spots, let's assign it to a symbol `ls` using `let`.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io))
    
(defn -main [filename]
  (with-open [r (reader filename)]
  	(let [ls (line-seq r)]
  		(println ls))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
(Name,Allegiances,Death Year,Book of Death,Death Chapter,Book Intro Chapter,Gender,Nobility,GoT,CoK,SoS,FfC,DwD Addam Marbrand,Lannister,,,,56,1,1,1,1,1,1,0 Aegon Frey (Jinglebell),None,299,3,51,49,1,1,0,0,1,0,0 Aegon Targaryen,House Targaryen,,,,5,1,1,0,0,0,0,1 Adrack Humble,House Greyjoy,300,5,20,20,1,1,0,0,0,0,1 Aemon Costayne,Lannister,,,,,1,1,0,0,1,0,0 Aemon Estermont,Baratheon,,,,,1,1,0,1,1,0,0 Aemon Targaryen (son of Maekar I),Night's Watch,
...
```

As you can see, there has been no change to our output, which is good!

Now let's see if we can take the first line from the `line-seq` by using `first` and binding it to the symbol `headers`. 

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (first ls)]
      (println "headers: " headers)
      (println "values: " ls))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
headers:  Name,Allegiances,Death Year,Book of Death,Death Chapter,Book Intro Chapter,Gender,Nobility,GoT,CoK,SoS,FfC,DwD
values:  (Name,Allegiances,Death Year,Book of Death,Death Chapter,Book Intro Chapter,Gender,Nobility,GoT,CoK,SoS,FfC,DwD Addam Marbrand,Lannister,,,,56,1,1,1,1,1,1,0 Aegon Frey (Jinglebell),None,299,3,51,49,1,1,0,0,1,0,0 Aegon Targaryen,House Targaryen,,,,5,1,1,0,0,0,0,1 Adrack Humble,House Greyjoy,300,5,20,20,1,1,0,0,0,0,1 Aemon Costayne,Lannister,,,,,1,1,0,0,1,0,0 Aemon Estermont,Baratheon,,,,,1,1,0,1,1,0,0 Aemon Targaryen (son of Maekar I),Night's Watch,300,4,35,21,1,1,1,0,1,1,0 Aenys Frey,None,300,5,,59,0,1,1,1,1,0,1 Aeron Greyjoy,House Greyjoy,,,,11,1,1,0,1,0,1,0 Aethan,Night's Watch,,,,0,1,0,0,0,1,0,0 Aggar,House Greyjo
...
```

We have successfully grabbed the string containing the headers, but what we assumed was going to be the values is actually the entire `line-seq`. Let's now use the `rest` function ([documentation](http://clojure.org/reference/sequences#__em_rest_em_coll)) which will take everything after the first element of a sequence, and bind it to the symbol `values`. 

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (first ls)
          values (rest ls)]
      (println "headers: " headers)
      (println "values: " values))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
headers:  Name,Allegiances,Death Year,Book of Death,Death Chapter,Book Intro Chapter,Gender,Nobility,GoT,CoK,SoS,FfC,DwD
values:  (Addam Marbrand,Lannister,,,,56,1,1,1,1,1,1,0 Aegon Frey (Jinglebell),None,299,3,51,49,1,1,0,0,1,0,0 Aegon Targaryen,House Targaryen,,,,5,1,1,0,0,0,0,1 Adrack Humble,House Greyjoy,300,5,20,20,1,1,0,0,0,0,1 Aemon Costayne,Lannister,,,,,1,1,0,0,1,0,0 Aemon Estermont,Baratheon,,,,,1,1,0,1,1,0,0 Aemon Targaryen (son of Maekar I),Night's Watch,300,4,35,21,1,1,1,0,1,1,0 Aenys Frey,None,300,5,,59,0,1,1,1,1,0,1 Aeron Greyjoy,House Greyjoy,,,,11,1,1,0,1,0,1,0 Aethan,Night's Watch,,,,0,1,0,0,0,1,0,0 Aggar,House Greyjoy,299,2,56,50,1,0,0,1,0,0,0 
...
```

We are now getting somewhere! We have now extracted the first line as the `headers` symbol and the rest of the file as the `values` symbol!

## Split the Headers Up!

Before we can do anything with the headers and values, we need to turn them into a collections rather than one long string. To do that we can do a `split` on the comma.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use clojure.string))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (rest ls)]
      (println "headers: " headers)
      (println "values: " values))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
WARNING: reverse already refers to: #'clojure.core/reverse in namespace: tutorial.got, being replaced by: #'clojure.string/reverse
WARNING: replace already refers to: #'clojure.core/replace in namespace: tutorial.got, being replaced by: #'clojure.string/replace
headers:  [Name Allegiances Death Year Book of Death Death Chapter Book Intro Chapter Gender Nobility GoT CoK SoS FfC DwD]
values:  (Addam Marbrand,Lannister,,,,56,1,1,1,1,1,1,0 Aegon Frey (Jinglebell),None,299,3,51,49,1,1,0,0,1,0,0 Aegon Targaryen,House Targaryen,,,,5,1,1,0,0,0,0,1 Adrack Humble,House Greyjoy,300,5,20,20,1,1,0,0,0,0,1 Aemon Costayne,Lannister,,,,,1,1,0,0,1,0,0 Aemon Estermont,Baratheon,,,,,1,1,0,1,1,0,0 Aemon Targaryen (son of Maekar I),Night's Watch,300,4,35,21,1,1,1,0,1,1,0 Aenys Frey,None,300,5,,59,0,1,1,1,1,0,1 Aeron Greyjoy,House Greyjoy,,,,11,1,1,0,1,0,1,0 Aethan,Night's Watch,,,,0,1,0,0,0,1,0,0 Aggar,House Greyjoy,299,2,56,50,1,0,0,1,0,0,0 Aggo,House Targaryen,,,,54,1,0,1,1,1,0,1 Alan of Rosby,Night's Watch,30
...
```

I'm getting warnings because I'm importing everything in the `string` library and there are some conflicting names. Since all I need is `split`, let's just use the `split` function in the string library, rather than the whole library.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (rest ls)]
      (println "headers: " headers)
      (println "values: " values))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
headers:  [Name Allegiances Death Year Book of Death Death Chapter Book Intro Chapter Gender Nobility GoT CoK SoS FfC DwD]
values:  (Addam Marbrand,Lannister,,,,56,1,1,1,1,1,1,0 Aegon Frey (Jinglebell),None,299,3,51,49,1,1,0,0,1,0,0 Aegon Targaryen,House Targaryen,,,,5,1,1,0,0,0,0,1 Adrack Humble,House Greyjoy,300,5,20,20,1,1,0,0,0,0,1 Aemon Costayne,Lannister,,,,,1,1,0,0,1,0,0 Aemon Estermont,Baratheon,,,,,1,1,0,1,1,0,0 Aemon Targaryen (son of Maekar I),Night's Watch,300,4,35,21,1,1,1,0,1,1,0 Aenys Frey,None,300,5,,59,0,1,1,1,1,0,1 Aeron Greyjoy,House Greyjoy,,,,11,1,1,0,1,0,1,0 Aethan,Night's Watch,,,,0,1,0,0,0,1,0,0 Aggar,House Greyjoy,299,2,56,50,1,0,0,1,0,0,0 Aggo,House Targaryen,,,,54,1,0,1,1,1,0,1 Alan of Rosby,Night's Watch,300,5,4,18,1,1,0,1,1,0,1 Alayaya,None,,,,15,0,0,0,1,0,0,0 Albar Royce,Arryn,,,,38,1,1,1,0,0,1,0 Albett,Night's Watch,
...
```

No more warnings! And we can clearly see that our `headers` symbol is now a vector! I can use that!

## Applying Functions to the Values

I want to put those `headers` to good use now! So let's apply them to each line in the values, but unfortunately our `values` are still a sequence of strings. We need to iterate over the lines, splitting them and then mapping the items to the headers.

In other words, I want to transform the sequence of strings, into a sequence of split strings, which means I want to `map` a function over a sequence to generate another collection. To do this I can use the [map](https://clojuredocs.org/clojure.core/map) (do not get this confused with the map type collections of hash-map, sorted-map, struct-map). The *form* for `map` is `(map f coll)`, so let's quickly split up the strings using `split`.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map (split % #",") (rest ls))]
      (println "headers: " headers)
      (println "values: " values))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Exception in thread "main" java.lang.RuntimeException: Unable to resolve symbol: % in this context, compiling:(tutorial/got.clj:12:23)
	at clojure.lang.Compiler.analyze(Compiler.java:6688)
	at clojure.lang.Compiler.analyze(Compiler.java:6625)
	at clojure.lang.Compiler$InvokeExpr.parse(Compiler.java:3834)
	at clojure.lang.Compiler.analyzeSeq(Compiler.java:6870)
	at clojure.lang.Compiler.analyze(Compiler.java:6669)
...
```

Oh I made a mistake using the `map`! I remembered that I need to use the `%` as a placeholder for each string/element in the sequence, but I forgot that I need to explicit say that the `(split % #",")` is an anonymous function. There are two ways to define an anonymous function: `(fn ...)` and `#(...)`. I'm going to use the shorter of the two. 

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(split % #",") (rest ls))]
      (println "headers: " headers)
      (println "values: " values))))
{{</highlight>}}
```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
headers:  [Name Allegiances Death Year Book of Death Death Chapter Book Intro Chapter Gender Nobility GoT CoK SoS FfC DwD]
values:  ([Addam Marbrand Lannister    56 1 1 1 1 1 1 0] [Aegon Frey (Jinglebell) None 299 3 51 49 1 1 0 0 1 0 0] [Aegon Targaryen House Targaryen    5 1 1 0 0 0 0 1] [Adrack Humble House Greyjoy 300 5 20 20 1 1 0 0 0 0 1] [Aemon Costayne Lannister     1 1 0 0 1 0 0] [Aemon Estermont Baratheon     1 1 0 1 1 0 0] [Aemon Targaryen (son of Maekar I) Night's Watch 300 4 35 21 1 1 1 0 1 1 0] [Aenys Frey None 300 5  59 0 1 1 1 1 0 1] [Aeron Greyjoy House Greyjoy    11 1 1 0 1 0 1 0] [Aethan Night's Watch    0 1 0 0 0 1 0 0] [Aggar House Greyjoy 299 2 56 50 1 0 0 1 0 0 0] [Aggo House Targaryen    54 1 0 1 1 1 0 1] [Alan of Rosby Night's Watch 300 5 4 18 1 1 0 1 1 0 1] [Alayaya None    15 0 0 0 1 0 0 0] [Albar Royce Arryn    38 1 1 1 0 0 1 0] [Albett Night's Watch    26 1 0 1 0 0 0 0] [Alebelly House Stark 299 2 46 4 1 0 0 1 0 0 0] [Alerie Hightower House Tyrell    6 0 1 0 0 1 1 0] [Alesander Staedmon Baratheon    65 1 1 0 1 0 0 0] [Alester Florent Baratheon 300 4...
```

Now that we are mapping experts, let's map the `zipmap` function ([documentation](http://clojuredocs.org/clojure.core/zipmap)) which has the *form* `(zipmap keys vals)`. The keys are always going to be our headers, but the vals are going to be each vector returned by the split. 

*Note: I took out the println for headers, since it's pointless now*

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (println "values: " values))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
values:  ({SoS 1, DwD 0, Allegiances Lannister, Book Intro Chapter 56, Book of Death , Gender 1, FfC 1, GoT 1, CoK 1, Nobility 1, Death Chapter , Name Addam Marbrand, Death Year } {SoS 1, DwD 0, Allegiances None, Book Intro Chapter 49, Book of Death 3, Gender 1, FfC 0, GoT 0, CoK 0, Nobility 1, Death Chapter 51, Name Aegon Frey (Jinglebell), Death Year 299} {SoS 0, DwD 1, Allegiances House Targaryen, Book Intro Chapter 5, Book of Death , Gender 1, FfC 0, GoT 0, CoK 0, Nobility 1, Death Chapter , Name Aegon Targaryen, Death Year } {SoS 0, DwD 1, Allegiances House Greyjoy, Book Intro Chapter 20, Book of Death 5, Gender 1, FfC 0, GoT 0, CoK 0, Nobility 1, Death Chapter 20, Name Adrack Humble, Death Year 300} {SoS 1, DwD 0, Allegiances Lannister, Book Intro Chapter , Book of Death , Gender 1, FfC 0, GoT 0, CoK 0, Nobility 1, Death Chapter , Name Aemon Costayne, Death Year } {SoS 1, DwD 0, Allegiances Baratheon, Book Intro Chapter , Book of Death , Gender 1, FfC 0, GoT 0, CoK 1, Nobility 1, Death Chapter , Name Aemon Estermont, Death Year } {SoS 1, DwD 0, Allegiances Night's Watch, Book Intro Chapter 21, Book of Death 4, Gender 1, FfC 1, GoT 1, CoK 0, Nobility 1, Death Chapter 35, Name Aemon Targaryen (son of Maekar I), Death Year 300} {SoS 1, DwD 1, Allegiances None, Book Intro Chapter 59, Book of Death 5, Gender 0, FfC 0, GoT 1, CoK 1, Nobility 1, Death Chapter , Name Aenys Frey, Death Year 300}
```

## Count Everything!

I want to start doing a little bit of analysis, so how about a quick count of the unique items in each column? Sounds simple but there is a lot that needs to go on.

Here is my procedural plan:
 1. Loop over headers
 2. Iterate over values, grabbing the value associated to the current header
 3. Create unique set for each group of values
 4. Count the unique set of strings
 
So first off, let's make sure we can loop over the headers within the let.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers]
      	(println h)))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name
Allegiances
Death Year
Book of Death
Death Chapter
Book Intro Chapter
Gender
Nobility
GoT
CoK
SoS
FfC
DwD
```

Now my goal is to iterate over the values grabbing the value associated to the current header. To do this I am going to map the `get` function over the values, which will return a sequence of values!

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers]
      	(println h (map #(get % h) values))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name (Addam Marbrand Aegon Frey (Jinglebell) Aegon Targaryen Adrack Humble Aemon Costayne Aemon Estermont Aemon Targaryen (son of Maekar I) Aenys Frey Aeron Greyjoy Aethan Aggar Aggo Alan of Rosby Alayaya Albar Royce Albett Alebelly Alerie Hightower Alesander Staedmon Alester Florent Alia of Braavos Alla Tyrell Allard Seaworth Alliser Thorne Alyn Alyn Ambrose Alyn Estermont Alyn Stackspear Alys Karstark Alysane Mormont Alyx Frey Ambrode Amory Lorch Andar Royce Andrew Estermont Andrey Dalt Andrik Anguy Antario Jast Anvil Ryn Anya Waynwood Archibald Yronwood Ardrian Celtigar Areo Hotah Arianne Martell Arneld Arnolf Karstark Aron Santagar Arron Arron Qorgyle Arryk (Guard) Arson Arthor Karstark Arwyn Frey Arwyn Oakheart Arya Stark Arys O
...
```

Now we just need to wrap that `map` function with a `set` to return only unique values!

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers]
      	(println h (set (map #(get % h) values)))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name #{Jared Frey Gared Creighton Longbough Young Henly Mord Tristifer Botley Larra Blackmont Arwyn Oakheart Kraznys mo Nakloz Gyles Rosby Denys Mallister Alys Karstark Spotted Pate of Maidenpool Lanna (Happy Port) Watt Skinner Arwyn Frey Marwyn Hazzea Bowen Marsh Arron Mohor Ossy Myles Morton Waynwood Lady of the Leaves Qhorin Halfhand Salladhor Saan Jarman Buckwell Esgred Cotter Pyke Philip Foote Pypar Loras Tyrell Dick Crabb Bran Stark Donnel Drumm Brenett Gage Umfred Squirrel Wallen Jeor Mormont Kojja Mo Gerren Ondrew Locke Walda Rivers (daughter of Aemon) Grenn Tom of Sevenstreams Hake Davos Seaworth Maril
...
...too many names...
...
Allegiances #{House Tyrell Arryn Wildling Tully House Arryn House Baratheon Martell Baratheon House Tully House Martell None Tyrell House Greyjoy Lannister House Lannister House Targaryen House Stark Stark Targaryen Greyjoy Night's Watch}
Death Year #{ 300 299 297 298}
Book of Death #{ 3 4 5 1 2}
Death Chapter #{ 58 9 3 51 50 34 69 49 26 4 60 14 59 61 57 68 30 21 80 33 20 67 47 19 17 25 73 42 7 66 44 48 53 18 36 12 27 62 75 24 76 35 6 38 70 77 39 1 63 0 43 74 37 46 11 45 56 32 55 2 72 16 41 10 65 40 31 64 23 52 29}
Book Intro Chapter #{ 58 9 3 51 50 34 69 49 22 26 4 8 28 60 14 59 61 57 68 30 21 80 33 20 67 47 19 17 25 73 78 15 42 7 66 44 5 48 53 18 36 12 13 27 62 75 24 35 6 38 70 39 1 63 0 43 74 37 46 11 45 56 32 55 2 72 54 16 41 10 65 40 31 71 64 23 52 79 29}
Gender #{1 0}
Nobility #{1 0}
GoT #{1 0}
CoK #{1 0}
SoS #{1 0}
FfC #{1 0}
DwD #{1 0}
```

Now we can apply a count to the sets!

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers]
      	(println h (count (set (map #(get % h) values))))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name 916
Allegiances 21
Death Year 5
Book of Death 6
Death Chapter 72
Book Intro Chapter 80
Gender 2
Nobility 2
GoT 2
CoK 2
SoS 2
FfC 2
DwD 2

```

## Applying More Statistics

What if I want to apply more than just `count` to the set of mapped values? I could make a let statement within the body of the `doseq` for the set, but turns out, there is a `:let` keyword that we can apply to the arguments of the `doseq`!

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers
      	      :let [value_sets (set (map #(get % h) values))]]
      	(println h (count value_sets))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name 916
Allegiances 21
Death Year 5
Book of Death 6
Death Chapter 72
Book Intro Chapter 80
Gender 2
Nobility 2
GoT 2
CoK 2
SoS 2
FfC 2
DwD 2
```

Nothing has changed, but now we are ready to apply more functions! Let's try finding the `min` of each set!

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers
      	      :let [value_sets (set (map #(get % h) values))]]
      	(println h "- count:" (count value_sets) "- min:" (min value_sets))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name - count: 916 - min: #{Jared Frey Gared Creighton Longbough Young Henly Mord Tristifer Botley Larra Blackmont Arwyn Oakheart Kraznys mo Nakloz Gyles Rosby Denys Mallister Alys Karstark Spotted Pate of Maidenpool Lanna (Happy Port) Watt Skinner Arwyn Frey Marwyn Hazzea Bowen Marsh Arron Mohor Ossy Myles Morton Waynwood Lady of the Leaves Qhorin Halfhand Salladhor Saan Jarman Buckwell Esgred Cotter Pyke Philip Foote Pypar Loras Tyrell Dick Crabb Bran Stark Donnel Drumm Brenett Gage Umfred Squirrel Wallen Jeor Mormont Kojja Mo Gerren Ondrew Locke Walda Rivers (daughter of Aemon) Grenn Tom of Sevenstreams Hake Davos Seaworth Marillion Wat (orphan) Dale Seaworth Leo Lefford Patrek of King's Mountain Hosteen Frey Wayn (guard) Godwyn Horas Redwyne Syrio Forel Lewys Lydden Qyburn Jonos Bracken Lyonel Amory Lorch Nute Sylva Santagar Falia Flowers Ghael Mordane Leo Tyrell Eldred Codd William Mooton Garth Greyfeather Forley Prester Ellaria Sand Tim Tangletongue Josua Willum Ravella Swann Andrey Dalt Osmund Kettleblack Ottyn Wythers Dagmer Orphan Oss Ryger Rivers Rodrik Ry
...
```

What just happened? Let's take a closer look at the `min` function [documentation](https://clojuredocs.org/clojure.core/min). The documentation describes the form as `(min x)`, `(min x y)`, `(min x y & more)`, which means we have the write the arguments out, not hand it a collection! We are able to apply the `min` function along the elements of a collection if we use the `apply` function though!

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers
      	      :let [value_sets (set (map #(get % h) values))]]
      	(println h "- count:" (count value_sets) "- min:" (apply min value_sets))))))
{{</highlight>}}

```bash
l$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Exception in thread "main" java.lang.ClassCastException: java.lang.String cannot be cast to java.lang.Number
	at clojure.lang.Numbers.lt(Numbers.java:221)
	at clojure.lang.Numbers.min(Numbers.java:4124)
	at clojure.core$min.invokeStatic(core.clj:1114)
	at clojure.core$min.doInvoke(core.clj:1106)
	at clojure.lang.RestFn.applyTo(RestFn.java:142)
	at clojure.core$apply.invokeStatic(core.clj:646)
	at clojure.core$apply.invoke(core.clj:641)
```

Oh the struggle is real now. Alright, we only want to apply the `min` function *if* the contents of the set are a number then!

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers
      	      :let [value_sets (set (map #(get % h) values))]]
      	(println h 
      		     "- count:" (count value_sets) 
      		     (if (= (type 1) (type (first value_sets)))
      		     	(str "- min:" (apply min value_sets))))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name - count: 916 nil
Allegiances - count: 21 nil
Death Year - count: 5 nil
Book of Death - count: 6 nil
Death Chapter - count: 72 nil
Book Intro Chapter - count: 80 nil
Gender - count: 2 nil
Nobility - count: 2 nil
GoT - count: 2 nil
CoK - count: 2 nil
SoS - count: 2 nil
FfC - count: 2 nil
DwD - count: 2 nil
```

Apparently everything is considered a string, which makes sense seeing as how I never told the script to see the contents of the csv file as anything other than a string! Time to cast things! First I'm going to see if the first item in the set contains digits, and if it does then I will parse it as an integer.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers
      	      :let [value_sets (set (map #(get % h) values))]]
      	(println h 
      		     "- count:" (count value_sets) 
      		     (if (= (type 1) (type (first value_sets)))
      		     	(str "- min:" (apply min value_sets))))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name - count: 916 nil
Allegiances - count: 21 nil
Death Year - count: 5 nil
Book of Death - count: 6 nil
Death Chapter - count: 72 nil
Book Intro Chapter - count: 80 nil
Gender - count: 2 - min:0
Nobility - count: 2 - min:0
GoT - count: 2 - min:0
CoK - count: 2 - min:0
SoS - count: 2 - min:0
FfC - count: 2 - min:0
DwD - count: 2 - min:0
```

Are you frustrated? I sure am! At this point in my lesson planning I actually go into the data and see that the only two columns that contain strings are the first two: Name and Alliances. Now my plan is to check to see if the header is either of those two, and if it isn't, then I am going to parse everything as an integer.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers
      	      :let [value_sets (set (map #(get % h) values))]]
      	(println h 
      		     "- count:" (count value_sets) 
      		     (if-not (or (= h "Name") (= h "Allegiances"))
      		     	(str "- min:" (apply min (map #(Integer/parseInt %) value_sets)))))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name - count: 916 nil
Allegiances - count: 21 nil
Exception in thread "main" java.lang.NumberFormatException: For input string: ""
	at java.lang.NumberFormatException.forInputString(NumberFormatException.java:65)
	at java.lang.Integer.parseInt(Integer.java:592)
	at java.lang.Integer.parseInt(Integer.java:615)
	at tutorial.got$_main$fn__25.invoke(got.clj:15)
	at clojure.core$map$fn__4785.invoke(core.clj:2646)
	at clojure.lang.LazySeq.sval(LazySeq.java:40)
	at clojure.lang.LazySeq.seq(LazySeq.java:49)
```

Come on! Really? At least I know what's going on. The `parseInt` is struggling with the empty string, so we need to filter them out of the `value-set` before we parse the values as integers.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers
      	      :let [value_sets (set (map #(get % h) values))]]
      	(println h 
      		     "- count:" (count value_sets) 
      		     (if-not (or (= h "Name") (= h "Allegiances"))
      		     	(str "- min:" (apply min (map #(Integer/parseInt %) (filter #(> (count %) 0) value_sets))))))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name - count: 916 nil
Allegiances - count: 21 nil
Death Year - count: 5 - min:297
Book of Death - count: 6 - min:1
Death Chapter - count: 72 - min:0
Book Intro Chapter - count: 80 - min:0
Gender - count: 2 - min:0
Nobility - count: 2 - min:0
GoT - count: 2 - min:0
CoK - count: 2 - min:0
SoS - count: 2 - min:0
FfC - count: 2 - min:0
DwD - count: 2 - min:0

```

Victory! Now let's print out the max! I'm going to do a little restructuring because I want to `apply` `max` and `min` to the same filtered collection of integers, so I am going to create a symbol for it in a `let`.

{{< highlight clojure >}}
(ns tutorial.got
  (use clojure.java.io)
  (use [clojure.string :only (split)]))
    
(defn -main [filename]
  (with-open [r (reader filename)]
    (let [ls (line-seq r)
          headers (split (first ls) #",")
          values (map #(zipmap headers %) (map #(split % #",") (rest ls)))]
      (doseq [h headers
              :let [value_sets (set (map #(get % h) values))]]
        (println h 
                 "- count:" (count value_sets) 
                 (if-not (or (= h "Name") (= h "Allegiances"))
                   (let [int_values (map #(Integer/parseInt %) (filter #(> (count %) 0) value_sets))]
                     (str "- min:" (apply min int_values)
                          "- max:" (apply max int_values)))))))))
{{</highlight>}}

```bash
$ java -cp ~/clojure-1.8.0.jar:. clojure.main -m tutorial.got character-deaths.csv
Name - count: 916 nil
Allegiances - count: 21 nil
Death Year - count: 5 - min:297- max:300
Book of Death - count: 6 - min:1- max:5
Death Chapter - count: 72 - min:0- max:80
Book Intro Chapter - count: 80 - min:0- max:80
Gender - count: 2 - min:0- max:1
Nobility - count: 2 - min:0- max:1
GoT - count: 2 - min:0- max:1
CoK - count: 2 - min:0- max:1
SoS - count: 2 - min:0- max:1
FfC - count: 2 - min:0- max:1
DwD - count: 2 - min:0- max:1

```