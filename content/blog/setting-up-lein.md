+++
title = "Setting Up Leiningen"
description = ""
tags = [
    "clojure",
    "set-up",
	"java",
	"leiningen"
]
date = "2016-09-18"
categories = [
    "Clojure",
]
menu = "main"
banner = "img/banners/setting-up-clojure.jpg"
+++

## Before We Begin

This guide will be for setting up your environment in a Linux OS, I'm currently using Ubuntu. You will need Java version 1.6 or later, which is recommended by everything that I have read so far.

To check your Java version just open up a terminal and type:
```bash
java -version
```

To quote their [website](http://leiningen.org/); Leiningen is "for automating Clojure projects without setting your hair on fire." Leiningen will be helping us get Clojure running as well as manage any dependencies we use. Instructions are on their [website](http://leiningen.org/) for installing Leiningen, but they are not detailed enough for my liking, so I have made very thorough instructions.

## Install Leiningen

### Step 1. Open a terminal and download the lein script

Download the script right from the source listed on the Leiningen [website](http://leiningen.org/) 
```bash
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
```

### Step 2. Change ownership

Use chmod to change the *ownership* of the lein bash file you just downloaded to allow for anyone to execute the file.

```bash
chmod a+x lein
```

### Step 3. Move lein

Now move lein--with super user privileges--to your system's executable path.

```bash
sudo mv lein /usr/bin
```
If you are prompted to enter your password, do so and carry on.

### Step 4. Run it

Now you will simply run *lein* and it will download the self-install package. If you try to run lein without super user privileges, it might yell at you about firewall junk. Be sure to press `ENTER` when it asks you to confirm this action.

```bash
sudo lein
```
### Step 5. Confirm all is well

Just to make sure everything is good, let's check the version of lein.

```bash
lein -v
```
You should receive an output similar to mine below (depending on your Java version).

```bash
> Leiningen 2.7.0 on Java 1.7.0_80 Java HotSpot(TM) 64-Bit Server VM
```

## Next Steps

Now that you have Leiningen installed and the Clojure compiler downloaded, why don't you start [your first Leiningen REPL]({{< ref "blog/first-lein-repl.md" >}})?