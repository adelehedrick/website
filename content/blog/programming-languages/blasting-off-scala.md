+++
title = "Blasting Off with Scala"
description = ""
tags = [
    "scala",
    "set-up",
	"java"
]
date = "2016-10-29"
categories = [
    "Scala",
]
banner = "img/banners/blast-off-scala.jpg"
+++

## Before We Begin

Make sure you have set up your environment and are able to use `scala` and `scalac`, if this is unfamiliar please visit [Getting Started with Scala]({{< ref "blog/programming-languages/getting-started-scala.md" >}})
\

{{< highlight scala >}}
object HelloWorld {
  def main(args: Array[String]): Unit = {
    println("Hello, world!")
  }
}
{{</highlight>}}