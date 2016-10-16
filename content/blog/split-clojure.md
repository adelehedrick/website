+++
title = "Doing the Splits in Clojure"
description = ""
tags = [
    "clojure",
    "string",
    "split",
    "let"
]
date = "2016-09-21"
categories = [
    "Clojure",
]
banner = "img/banners/splits-clojure.jpg"
+++

## Before We Begin

This is going to be a quick tutorial about the [split](https://clojuredocs.org/clojure.string/split) function in Clojure. 

You will need to have a REPL up and running. If you forgot how to do that visit [this post]({{< ref "blog/first-clojure-repl.md" >}}). I will tell you exactly when to enter statements into the REPL, and those statements will be preceded by the `user=>` prompt.

### Load the Split

```bash
user=> (use '[clojure.string :only (split)])
```

Output:
```bash
nil
```

Using this doesn't return a value, so we get a nil.

### Let's Be Friends

I am going to start off by using a [let](https://clojuredocs.org/clojure.core/let) special form to bind some values to symbols in a cozy local scope. Please note that `<...>` are placeholders.

{{< highlight clojure >}}
(let [<symbols values>]
    <body>)
{{</highlight>}}

The [split](https://clojuredocs.org/clojure.string/split) function that I will be demoing, has two required arguments, and a third optional argument. Respectively they are; the string you are splitting, the regular expression you are using to split with, and the optional limit.

So let's create the symbol `s` for the string 'I like pumpkin spice lattes and am proud of it', and the symbol `re` for the regular expression of a space.

{{< highlight clojure >}}
(let [s "I like pumpkin spice lattes and am proud of it"
      re #"\s"]
    <body>)
{{</highlight>}} 

#### Going on a Hashtag Tangent

Some of you may be wondering what is going on with the \# in front of the string containing our regular expression for a space. To address your wondering, it is a reader macro that will make the pattern within the quotes be compiled at read-time. See more in the [docs](http://clojure.org/reference/other_functions).

### Split!

Time to replace the body placeholder with the [split](https://clojuredocs.org/clojure.string/split) function. 

{{< highlight clojure >}}
(let [s "I like pumpkin spice lattes and am proud of it"
      re #"\s"]
    (split s re))
{{</highlight>}} 

```bash
user=> (let [s "I like pumpkin spice lattes and am proud of it" re #"\s"](split s re))
```

Output:
```bash
["I" "like" "pumpkin" "spice" "lattes" "and" "am" "proud" "of" "it"]
```

You now have a vector of strings! 