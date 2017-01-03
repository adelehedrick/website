+++
title = "Getting Started with Scala"
description = ""
tags = [
    "scala",
    "set-up",
	"java"
]
date = "2016-10-27"
categories = [
    "Scala",
]
banner = "img/banners/setting-up-scala.jpg"
+++

## Before We Begin

This guide will be for setting up your environment in a Linux OS, I'm currently using Ubuntu. You will need Java version 1.8 

To check your Java version just open up a terminal and type:
```bash
java -version
```

Just like Clojure, Scala compiles into JVM, that is why we need Java!

## Get Scala Up & Running

For this tutorial I used the Scala [Getting Started](http://www.scala-lang.org/documentation/getting-started.html) instructions as a resource. If you find my tutorials have too much detail, then work from that resource, otherwise you can continue on with my tutorial.

### Step 1. Download Scala

You can use `wget` to download the tgz from [http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz](http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz)

```bash
wget http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz
```

### Step 2. Unzip and Move

Unzip the compressed file using `tar` then move and rename the folder to _scala_ in the `/usr/local/share` folder.

```bash
tar -xvzf scala-2.11.8.tgz
sudo mv scala-2.11.8 /usr/local/share/scala
```

### Step 3. Modify Environment Variables

Open up your environment variables file in an editor via `sudo gedit /etc/environment` and within the PATH variable assignment, between the double quotes, add `:/usr/local/share/scala/bin`

```bash
PATH="<other stuff>:/usr/local/share/scala/bin"
```

### Step 4. Restart Computer

Restart your computer make the changes you made to the `environment` file come into effect.

### Step 5. Test Scala REPL

In your terminal type the command `scala` and you should then see a `scala>` prompt. At this point you can test a simple 'hello world' by typing `println("Hello World")` which should then print out the response to the console.

To exit the REPL use the command `:q`.

### Step 6. Compile Scala

Create a `hello.scala` file with the following _hello world_ contents:

{{< highlight scala >}}
object HelloWorld {
  def main(args: Array[String]): Unit = {
    println("Hello, world!")
  }
}
{{</highlight>}}

Open up a terminal at the location of your Scala file and use the Scala compiler to compile the class.

```bash
scalac hello.scala
```
Now if you type `ls` to list the files in the current folder, you will find `HelloWorld.class` and `HelloWorld$.class`. To run your new Scala class, execute:

```bash
scala HelloWorld
```
