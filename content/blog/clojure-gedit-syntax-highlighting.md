+++
title = "Syntax Highlighting for Clojure in gedit"
description = ""
tags = [
    "clojure",
    "set-up",
	"java",
	"gedit",
	"syntax highlighting"
]
date = "2016-09-24"
categories = [
    "Clojure",
]
banner = "img/banners/setting-up-clojure.jpg"
+++

## Making gedit Pretty Again

I'm assuming you are exhausted by now of the lack of syntax highlighting for Clojure in gedit (like I *was*) and that you have Git installed (you likely already have it).

A quick search provided me with enough information to get it working and I will share the stepts that I took with you now. 

Make sure your gedit is closed before you begin.

### Step 1. Open terminal and download repo

Make sure you are starting from the home directory so this whole thing will be a matter of copy/paste

In terminal:
```bash
git clone https://github.com/mitko/clojure_for_gedit.git
cd clojure_for_gedit/
```
### Step 2. Move files to where they need to be

In terminal:
```bash
sudo cp clojure.lang /usr/share/gtksourceview-3.0/language-specs/clojure.lang
sudo cp clojure.xml /usr/share/mime/packages/clojure.xml
```
### Step 3. Update mime

In terminal:
```bash
cd ../usr/share
sudo update-mime-database mime
```

This last command might take a minute, and you will get no progress output, so just be patient. When you get your cursor back, it is completed (there will be no output).

### Step 4. Open up a Clojure file to confirm

You should have pretty syntax highlighting now!
