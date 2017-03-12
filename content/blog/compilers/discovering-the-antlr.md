+++
title = "Discovering the Antlr"
description = ""
tags = [
    "compilers",
    "Antlr"
]
date = "2017-03-12"
categories = [
    "Compilers",
]
banner = "img/banners/antlers.jpg"
+++

## The Purpose

The goal of this tutorial is to demonstrate how you can use Antlr to program your context free grammar for a made up programming language. By the end of the tutorial you will be able to feed your made up language source code through the `ParseFile` program and get a Java version that you can then compile and execute.

## Before We Begin

You need Java 1.8 working on your machine! Even if you don't have the aliases set up on your computer for Antlr, you will be able to continue on with this tutorial. 

You will need to download the [course repo](https://github.com/adelehedrick/Compilers2017) that I set up, and you will be starting in the `Silly-Antlr-Tutorial`. The final code for the tutorial is in the `Silly-Antlr-Tutorial-Full` directory for your reference, but it is best if you follow along from the starting point.

## Tour of Starter Files

Once you download the repo and navigate to the `Silly-Antlr-Tutorial`, you will see the following files: 

- antlr-4.6-complete.jar
- inputfile
- Makefile
- ParseFile.java
- Silly.g4

### Antlr Jar

For your convenience, the Antlr JAR has been included, and is referenced relatively from the Makefile so you won't have to worry about storing it somewhere specific on your computer. Just keep it right there.

### Input File

This file contains the source code from our Silly language that will get fed into our parser. We will look at this a little more closely when we create our context free grammar.

### Makefile

The Makefile contains 4 commands: `all`, `run`, `silly` and `clean`. The `make all` command will compile the `Silly.g4` into the required java files, and then compile the generated java files. The `make run` command will parse the `inputfile` with the generated lexer and send the output to a `SillyOut.java` file. The `make silly` command will compile and run the `SillyOut.java` file. Lastly, the `make clean` will remove all the generated and compiled class files from the directory.

### ParseFile.java

This is the bare bones parser that will take the input stream, feed it through the generated Silly Lexer to get tokens, and then the tokens get fed through the Silly Parser which will print out the generated java code. You will not need to modify this file in any way.

### Silly.g4

This is where you will program your context free grammar! 

### Test the Starter Files

Open up your terminal/cmd in this directory and run `make all`. You should get an output similar to this:
```bash
 make all
java -cp ./antlr-4.6-complete.jar:. org.antlr.v4.Tool -no-listener -no-visitor *.g4
error(99): Silly.g4::: grammar Silly has no rules
Makefile:2: recipe for target 'all' failed
make: *** [all] Error 1
```
This is perfect. Java has successfully loaded the Antlr JAR file, and the g4 was found and fed into it. Our grammar has no rules, so the error is justified.

## Make a Silly Grammar

If you open up the `inputfile` you will see what our language is supposed to look like, and we will need to create a grammar to represent this language.

inputfile:

```
variable Hello;
variable World;
make Hello 5;
repeat 3 show Hello;
make World 10;
repeat Hello show World;
```

### Variable Declaration

From `variable Hello;` we see that a variable declaration has a pattern of `variable <id>;`.

### Variable Assignment

We can assign a value to a variable with `make <id> <id or integer>;`. 

### Repeatably Print Something

The last thing that the grammar can do is print something to the console repeatably using `repeat <id or integer> show <id or integer>;`. What a silly language, am I right?

### The Context Free Grammar

To fast forward, here is our grammar:

```
start --> statement+
statement --> var_decl | var_assign | repeat_show
var_decl --> 'variable' ID ';'
var_assign --> 'make' ID var ';'
repeat_show --> 'repeat' var 'show' var ';'
var --> ID | NUM
NUM --> [0-9]+ 
ID --> [a-zA-Z]?[a-zA-Z0-9_/-]*
```

The `start` symbol contains one or more statements, and the statements can be any of the three: variable declaration, `var_decl`; variable assignment, `var_assign`, and repeatably print something, `repeat_show`. We have a new non-terminal of `var` which represents a variable or an integer, which allows us to use the `var_assign` in such a way that we can assign one variable the value of another variable. We have two basic terminals `NUM` and `ID`. The `NUM` is a positive integer value, and `ID` is a string like sequence that has to have a minimum length of 1, and the first character has to be a letter, with any subsequent characters being letters, numbers, underscore, or hyphen. 

One major note, is that we are going to ignore white space in this language completely.

## Convert CFG to Antlr g4

Open up the Silly.g4, paste in the grammar and comment out each line like so:

{{<highlight ANTLR>}}
grammar Silly;

/* import statements go here */
@header {

}

/* may or may not need this */
@members {
	
}

/* start --> statement+                                 */
/* statement --> var_decl | var_assign | repeat_show    */
/* var_decl --> 'variable' ID ';'                       */
/* var_assign --> 'make' ID var ';'                     */
/* repeat_show --> 'repeat' var 'show' var ';'          */
/* var --> ID | NUM                                     */
/* NUM --> [0-9]+                                       */
/* ID --> [a-zA-Z]?[a-zA-Z0-9_/-]*                      */
{{</highlight>}}

The rules of our grammar actually _do_ something in Antlr. They build up the lexer Java file that Antlr creates, so think of each rule as a function of a program that has an input, and a return value. 

For example: the `var_decl` rule has `'variable' ID ';'` which means we see the literals `variable` followed by the terminal `ID` followed by the literal semicolon. `ID` is special though; we need to call our `ID` function/rule to find out the value of it (which should be a string), and then place the value of `ID` in our variable declaration production. But that's not all! The `var_decl` actually needs to return the Java equivalent of a variable declaration! In Java to declare an integer value you write `int id;` where `id` is the name of our variable. So Antlr in the end will parse the input file and spit out the Java translation. We are basically writing one of those English to French dictionary, except it is a Silly to Java dictionary!

Ok let's do this. Start from the terminals! 

{{<highlight ANTLR>}}
/* NUM --> [0-9]+                                       */
NUM : ('0' .. '9')+ ;

/* ID --> [a-zA-Z]?[a-zA-Z0-9_/-]*                      */
ID : ('a' .. 'z' | 'A' .. 'Z')+ ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-')* ;

/* we ignore white space                                 */
WS : (' ' | '\t' | '\r' | '\n') {skip();} ;
{{</highlight>}}

Terminals are pretty easy since there is no weird translation to be done, but we see a little bit of Java injected in our grammar with the white space rule. The `{skip();}` says that for every `WS` token we find, we are going to call the `skip` function which simply means we skip this token.

We are now going to move up to the `var` non-terminal which needs to return the value of an `ID` or `NUM`.
{{<highlight ANTLR>}}
/* var --> ID | NUM                                     */
var returns [String number]
	: ID 
		{ 
			$number = $ID.getText(); 
		}
	| NUM 
		{ 
			$number = ""+ $NUM.getText(); 
		}
	;
{{</highlight>}}

This is a lot to take in for the first time, so I'm going to unpack it! 

You now see that the `var` rule has an added `returns [String number]` which means that it is going to return a `String` with the name `number` which you will be able to access via `$var.number` within the injected Java code elsewhere in the Antlr grammar. 

The `$` attached to the name of a rule within the Java snippet, is how we tell Antlr we are referring to a rule within the grammar, and not some other variable defined elsewhere.

Each production of the rule has a snippet of Java attached to it between curly braces. The Java attached to the ID is `$number = $ID.getText();`, which has a lot going on. The `$number` variable that is returned by `var`, is being assigned the value of the text in the `$ID` token.

Let's jump up and fill in the `var_decl` which isn't going to return the value of a token, but instead return a string containing the Java translation of a variable declaration which looks like `int id;`.

{{<highlight ANTLR>}}
/* var_decl --> 'variable' ID ';'                       */
var_decl returns [String s]
	: 'variable' ID ';' 
		{ 
			$s = "int "+$ID.getText()+";";
		}
	;
{{</highlight>}}

The `var_decl` will return a `String` named `s` that contains the Java equivalent of a variable declaration, which is just a String. In the Java equivalent of a variable declaration, `int id;`, we want to replace the `id` with the text of the `ID` token, and then assign the value to `s`, that is exactly what is happening with `$s = "int "+$ID.getText()+";";`

Now lets move to the next easiest, the `var_assign`, which will return a `String s` that contains the Java equivalent of assigning a value to a variable, `id = 42;`.

{{<highlight ANTLR>}}
/* var_assign --> 'make' ID var ';'                     */
var_assign returns [String s]
	: 'make' name=ID var ';' 
		{ 
			$s = $name.getText() + " = " + $var.number + ";";
		}
	;
{{</highlight>}}

I'm doing something a little extra in this example, I'm assigning the ID in the production to an alias to be used within the Java snippet with `name=ID`. This comes in handy when you have multiple symbols of the same type appear in the production.

Another thing to note, is here when we want to get the value of `$var` we reference `number`, and that is because the `var` rule returns `number`.

The `repeat_show` rule translates to a little more Java then before. The Java we want, to print a number a certain number of times is:

{{<highlight Java>}}
for (int i = 0; i < iterations; i++)
    System.out.print(x);
{{</highlight>}}

`iterations` is the number of times we want to print the number `x`. If you remember our rule is `repeat_show --> 'repeat' var 'show' var ';'` so we can see that the first `var` will be our `iterations` value and the second `var` will be the `x` value. We will need to use aliases here to differentiate between the two `var`.

{{<highlight ANTLR>}}
/* repeat_show --> 'repeat' var 'show' var ';'          */
repeat_show returns [String s]
	: 'repeat' iterations=var 'show' x=var ';'
		{ 
			$s = "for(int i = 0; i < " + $iterations.number + "; i++)";
			$s = $s + "System.out.print(" + $x.number + ");";
		}
	;
{{</highlight>}}

Almost done! Let's now fill out the `statement` rule, which will take the `s` returned from any of the 3 types of statements and return it in its own variable `s`.

{{<highlight ANTLR>}}
/* statement --> var_decl | var_assign | repeat_show    */
statement returns [String s]
	: var_decl { $s = $var_decl.s; }
	| var_assign { $s = $var_assign.s; }
	| repeat_show { $s = $repeat_show.s; }
	;
{{</highlight>}}

Lastly, but not least, we need to define the `start` symbol which is going to wrap all the `statement`s with the required Java to run code! If you recall, the scaffolding we need to do a basic _Hello World!_ in Java is:

{{<highlight Java>}}
public class SillyOut {
    public static void main(String[] args) {
        //Statements go here
    }
}
{{</highlight>}}

The `start` symbol is not going to `return` anything this time, for this one we want the Java snippet that will be added to the lexer to actually print the entire Java string that has been compiled to the console. 

To make things nicer, we will need to add the white space to the string manually, and we need to isolate the Java string that will be printed before and after the statements. 

The string to be printed _before_ the statements is:
```
public class SillyOut {\n\tpublic static void main(String[] args) {\n
```

The string to be printed _after_ the statements is:
```
\n\t}\n}
```

We will also want to wrap each statement with some tabs and new lines, so that will look something like:

```
"\t\t" + $statement.s+"\n"
```

So remember, we aren't making a return variable `s`, but instead _printing_ the string containing the Java to the console. When we put this logic all together, we can replace our `start --> statement+` rule with something like:

```
start --> <print before snippet> ( <print statement snippet> )+ <print after snippet>
```

The full rule is:

{{<highlight ANTLR>}}
/* start --> statement+                                 */
start 
	: {System.out.println("public class SillyOut {\n\tpublic static void main(String[] args){");}( statement {System.out.println("\t\t" + $statement.s+"\n");})+  {System.out.println("\n\t}\n}");}
	;	
{{</highlight>}}

The full grammar in all its glory should look like:

{{<highlight ANTLR>}}
grammar Silly;

/* import statements go here */
@header {

}

/* may or may not need this */
@members {
	
}

/* start --> statement+                                 */
start 
	: {System.out.println("public class SillyOut {\n\tpublic static void main(String[] args){");}( statement {System.out.println("\t\t" + $statement.s+"\n");})+  {System.out.println("\n\t}\n}");}
	;	

/* statement --> var_decl | var_assign | repeat_show    */
statement returns [String s]
	: var_decl { $s = $var_decl.s; }
	| var_assign { $s = $var_assign.s; }
	| repeat_show { $s = $repeat_show.s; }
	;

/* var_decl --> 'variable' ID ';'                       */
var_decl returns [String s]
	: 'variable' ID ';' 
		{ 
			$s = "int "+$ID.getText()+";";
		}
	;

/* var_assign --> 'make' ID var ';'                     */
var_assign returns [String s]
	: 'make' name=ID var ';' 
		{ 
			$s = $name.getText() + " = " + $var.number + ";";
		}
	;

/* repeat_show --> 'repeat' var 'show' var ';'          */
repeat_show returns [String s]
	: 'repeat' iterations=var 'show' x=var ';'
		{ 
			$s = "for(int i = 0; i < " + $iterations.number + "; i++)";
			$s = $s + "System.out.print(" + $x.number + ");";
		}
	;


/* var --> ID | NUM                                     */
var returns [String number]
	: ID 
		{ 
			$number = $ID.getText(); 
		}
	| NUM 
		{ 
			$number = ""+ $NUM.getText(); 
		}
	;

/* NUM --> [0-9]+                                       */
NUM : ('0' .. '9')+ ;

/* ID --> [a-zA-Z]?[a-zA-Z0-9_/-]*                      */
ID : ('a' .. 'z' | 'A' .. 'Z')+ ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-')* ;

/* we ignore white space */
WS : (' ' | '\t' | '\r' | '\n') {skip();} ;
{{</highlight>}}

Let's take a moment, to just appreciate all that we have done, and all that Antlr is going to _do_ for us. Our Antlr parser is going to translate our Silly source code, compile it into Java and then print the Java code to the console!

If you recall, in my `Makefile`, I directed the output to a `SillyOut.java`, which matches the class name in the _before snippet_ that got printed, so let's open up a terminal and see this magic happen!

In your terminal type `make all` to generate our SillyParser.java, SillyLexer.java, SillyLexer.tokens and Silly.tokens files.

Open up the Silly.tokens and you will find a list of possible tokens that have been generated from our g4, some have been generated, and some are straight from our g4.

If you open up the SillyLexer.java, you will recognize that this does exactly what it should: tokenizes input!

The SillyParser.java contains the magic though, and you will find some of our magic in it!

If you scroll down to where the start symbol got translated you will see:

{{<highlight Java>}}
	public final StartContext start() throws RecognitionException {
		StartContext _localctx = new StartContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_start);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			System.out.println("public class SillyOut {\n\tpublic static void main(String[] args){");
			setState(16); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(13);
				((StartContext)_localctx).statement = statement();
				System.out.println("\t\t" + ((StartContext)_localctx).statement.s+"\n");
				}
				}
				setState(18); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__2) | (1L << T__3))) != 0) );
			System.out.println("\n\t}\n}");
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}
{{</highlight>}}

Can you identify the three print statements in there that we injected from our g4 file? How magical is that!?

Now feel free to go back to your terminal and execute `make silly` to compile and execute the generated SillyOut.java.

What I want everyone to now do, is get an idea of the errors and problems that can arise. I want everyone to break some part of the g4, take out a semicolon, take out a bar, remove the return statement, anything! Try to then run `make all` and then share with the class two things:

1. What did you change in the g4 and what line it was on
2. The console output that was the result of your added bug