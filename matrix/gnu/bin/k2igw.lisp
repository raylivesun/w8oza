#|
k2igw:
- Author: admin
- Date: 2024-09-22
|#

#|
5.5 Modifying strings
There are two approaches to changing characters inside a string. Either use the index
numbers of the characters, or specify the substring you want to ﬁnd or change.
|#

#|
5.5.1 Using index numbers in strings
To change characters by their index numbers, use setf, the general purpose function for
changing strings, lists, and arrays:
|#

(set 't "a hypotentical one-dimensional subatomic particles")
(setf (t 0) "A")

;; You could also use nth with setf to specify the location:
(set 't "a hypothetical one-dimensional subatomic particle")
;-> "a hypothetical one-dimensional subatomic particle"
(setf (nth 0 t) "A")
;-> "A"
t
;-> "A hypothetical one-dimensional subatomic particle"

;; Here's how to 'increment' the ﬁrst (zeroth) letter of a string:
(set 'wd "cream")
;-> "cream"
(setf (wd 0) (char (+ (char $it) 1)))
;-> "d"
wd
;-> "dream"

;; $it contains the value found by the ﬁrst part of the setf expression, and its numeric value
;; is incremented to form the second part.

#|
5.5.2 Changing substrings
If you don't want to - or can't - use index numbers or character positions, use replace, a
powerful destructive function that does all kinds of useful operations on strings. Use it in
the form:
|#

(set 't "a hypothetical one-dimensional subatomic particle")
(replace "hypoth" t "theor")

#|
replace is destructive, but if you want to use replace or another destructive function con-
structively for its side eﬀects, without modifying the original string, use the copy function:
|#

(set 't "a hypothetical one-dimensional subatomic particle")
(replace "hypoth" (copy t) "theor")
;-> "a theoretical one-dimensional subatomic particle"
t
;-> "a hypothetical one-dimensional subatomic particle"

#|
5.5.3 Regular expressions
replace is one of a group of newLISP functions that accept regular expressions for deﬁning
patterns in text. For most of them, you add an extra number at the end of the expression
which speciﬁes options for the regular expression operation: 0 means basic matching, 1
means case-insensitive matching, and so on.
|#

(set 't "a hypothetical one-dimensional subatomic particle")
(replace {h.*?l(?# h followed by l but not too greedy)} t {} 0)
#|
Sometimes I put comments inside regular expressions, so that I know what I was trying
to do when I read the code some days later. Text between (?# and the following closing
parenthesis is ignored.
If you're happy working with Perl-compatible Regular Expressions (PCRE), you'll be happy
with replace and its regex-using cousins (ﬁnd, regex, ﬁnd-all, parse, starts-with, ends-
with, directory, and search ). Full details are in the newLISP reference manual.
You have to steer your pattern through both the newLISP reader and the regular expression
processor. Remember the diﬀerence between strings enclosed in quotes and strings enclosed
in braces? Quotes allow the processing of escaped characters, whereas braces don't. Braces
have some advantages: they face each other visually, they don't have smart and dumb
versions to confuse you, your text editor might balance them for you, and they let you
use the more commonly occurring quotation characters in strings without having to escape
them all the time. But if you use quotes, you must double the backslashes, so that a single
backslash survives intact as far as the regular expression processor:
|#

(set 'str "\s")
(replace str "this is a phrase" "|" 0)
;-> thi| i| a phra|e
(set 'str "\\s")
(replace str "this is a phrase" "|" 0)
;-> this|is|a|phrase
; oops, not searching for \s (white
; but for the letter s
; ah, better!

#|
5.5.4 System variables: $0, $1 ...
replace updates a set of system variables $0, $1, $2, up to $15, with the matches. These
refer to the parenthesized expressions in the pattern, and are the equivalent of the \1, \2
that you might be familiar with if you've used grep. For example:
(set 'quotation {"I cannot explain." She spoke in a low, eager voice,
with a curious lisp in her utterance. "But for God's sake do what I
ask you. Go back and never set foot upon the moor again."})
|#

#|
$1 "I cannot explain." She spoke in a low $2 lisp $3 in her utterance.
"But for God's sake do what I ask you. Go back and never set foot upon
the $4 moor $5 again."
Here we've looked for ﬁve patterns, separated by any string starting with a comma and
ending with the word curious. $0 stores the matched expression, $1 stores the ﬁrst paren-
thesized sub-expression, and so on.
If you prefer to use quotation marks rather than the braces I used here, remember that
certain characters have to be escaped with a backslash.
|#

#|
5.5.5 The replacement expression
The previous example demonstrates that an important feature of replace is that the re-
placement doesn't have to be just a simple string or list, it can be any newLISP expression.
Each time the pattern is found, the replacement expression is evaluated. You can use this
to provide a replacement value that's calculated dynamically, or you could do anything else
you wanted to with the found text. It's even possible to evaluate an expression that's got
nothing to do with found text at all.
Here's another example: search for the letter t followed either by the letter h or by any
vowel, and print out the combinations that replace found:
|#

(set 't "a hypothetical one-dimensional subatomic particle")

;; For every matching piece of text found, the third expression

(println $0)

#|
was evaluated. This is a good way of seeing what the regular expression engine is up to
while the function is running. In this example, the original string appears to be unchanged,
but in fact it did change, because (println $0) did two things: it printed the string, and it
returned the value to replace, thus replacing the found text with itself. Invisible mending!
If the replacement expression doesn't return a string, no replacement occurs.
You could do other useful things too, such as build a list of matches for later processing,
and you can use the newLISP system variables and any other function to use any of the
text that was found.
In the next example, we look for the letters a, e, or c, and force each occurrence to upper-
case:
|#

(replace "a|e|c" "This is a sentence" (upper-case $0) 0)
;-> "This is A sEntEnCE"

#|
As another example, here's a simple search and replace operation that keeps count of how
many times the letter 'o' has been found in a string, and replaces each occurrence in the
original string with the count so far. The replacement is a block of expressions grouped
into a single begin expression. This block is evaluated every time a match is found:
|#

(set 't "a hypothetical one-dimensional subatomic particle")
(set 'counter 0)
(replace "o" t
(begin
(inc counter)
(println {replacing "} $0 {" number } counter)
(string counter)))
; the replacement text should be a string

#|
The output from println doesn't appear in the string; the ﬁnal value of the entire begin
expression is a string version of the counter, so that gets inserted into the string.
Here's yet another example of replace in action. Suppose I have a text ﬁle, consisting of
the following:
|#

1 a = 15
2 another_variable = "strings"
4 x2 = "another string"
5 c = 25
3x=9

#|
I want to write a newLISP script that re-numbers the lines in multiples of 10, starting at
10, and aligns the text so that the equals signs line up, like this:
|#

10 a = 15
20 another_variable = "strings"
30 x2 = "another strings"
40 c = 25
50 x = 9

#|
(I don't know what language this is!)
The following script will do this:
|#

#|
I've used two replace operations inside the while loop, to keep things clearer. The ﬁrst
one sets a temporary variable to the result of a replace operation. The search string
({ˆ(\d*)(\s*)(.*)}) is a regular expression that's looking for any number at the start
of a line, followed by some space, followed by anything. The replacement string ((string
(inc counter 10) " " $3) 0)) consists of a incremented counter value, followed by the
third match (ie the anything I just looked for).
The result of the second replace operation is printed. I'm searching the temporary variable
temp for more strings and spaces with an equals sign in the middle:
({(\S*)(\s*)(=)(\s*)(.*)})
The replacement expression is built up from the important found elements ($1, $3, $5) but
it also includes a quick calculation of the amount of space required to bring the equals sign
across to character 20, which should be the diﬀerence between the ﬁrst item's width and
position 20 (which I've chosen arbitrarily as the location for the equals sign).
Regular expressions aren't very easy for the newcomer, but they're very powerful, particu-
larly with newLISP's replace function, so they're worth learning.
|#

#|
5.6 Testing and comparing strings
There are various tests that you can run on strings. newLISP's comparison operators work
by ﬁnding and comparing the code numbers of the characters until a decision can be made:
|#

(> {Higgs Boson} {Higgs boson})
(> {Higgs Boson} {Higgs})
(< {dollar} {euro})
(> {newLISP} {LISP})
(= {fred} {Fred})
(= {fred} {fred})

;; and of course newLISP's ﬂexible argument handling lets you test loads of strings at the
;; same time:

(< "a" "c" "d" "f" "h")
;-> true

#|
These comparison functions also let you use them with a single argument. If you supply
only one argument, newLISP helpfully assumes that you mean 0 or "", depending on the
type of the ﬁrst argument:
|#

(> 1)
(> "fred")

#|
To check whether two strings share common features, you can either use starts-with and
ends-with, or the more general pattern matching commands member, regex, ﬁnd, and
ﬁnd-all. starts-with and ends-with are simple enough:
|#

(starts-with "newLISP" "new")
;-> true
(ends-with "newLISP" "LISP")
;-> true

;; They can also accept regular expressions, using one of the regex options (0 being the most
;; commonly used):

;; ﬁnd, ﬁnd-all, member, and regex look everywhere in a string. ﬁnd returns the index of
;; the matching substring:

(set 't "a hypothetical one-dimensional subatomic particle")
(find "atom" t)
;-> 34
(find "l" t)
;-> 13
(find "L" t)
;-> nil

;; member looks to see if one string is in another. It returns the rest of the string, including
;; the search string, rather than the index of the ﬁrst occurrence.

(member "rest" "a good restaurant")
;-> "restaurant"

;; Both ﬁnd and member let you use regular expressions:

(set 'quotation {"I cannot explain." She spoke in a low,
eager voice, with a curious lisp in her utterance. "But for
Gods sake do what I ask you. Go back and never set foot upon
the moor again."})

(find "lisp" quotation)
;-> 69; without regex
; character 69
(find {i} quotation 0)
;-> 15; with regex
; character 15
(find {s} quotation 1)
;-> 20; case insensitive regex
; character 20
(println "character "
(find {(l.*?p)} quotation 0) ": " $0)
;-> character 13: lain." She sp

#|
ﬁnd-all works like ﬁnd, but returns a list of all matching strings, rather than the index of
just the ﬁrst match. It always takes regular expressions, so - for once - you don't have to
put regex option numbers at the end.
|#

(set 'quotation {"I cannot explain." She spoke in a low,
eager voice, with a curious lisp in her utterance. "But for
Gods sake do what I ask you. Go back and never set foot upon
the moor again."})

(find-all "[aeiou]{2,}" quotation $0)
; two or more vowels
;-> ("ai" "ea" "oi" "iou" "ou" "oo" "oo" "ai")

#|
Or you could use regex. This returns nil if the string doesn't contain the pattern, but, if
it does contain the pattern, it returns a list with the matched strings and substrings, and
the start and length of each string. The results can be quite complicated:
|#

(set 'quotation
{She spoke in a low, eager voice, with a curious lisp in her utterance.})
(println (regex {(.*)(l.*)(l.*p)(.*)} quotation 0))
("She spoke in a low, eager voice, with a curious lisp in
her utterance." 0 70 "She spoke in a " 0 15 "low, eager
voice, with a curious " 15 33 "lisp" 48 4 " in her
utterance." 52 18)

#|
This results list can be interpreted as 'the ﬁrst match was from character 0 continuing for 70
characters, the second from character 0 continuing for 15 characters, another from character
15 for 33 characters', and so on.
The matches are also stored in the system variables ($0, $1, ...) which you can inspect
easily with a simple loop:
|#

(for (x 1 4)
(println {$} x ": " ($ x)))

#|
5.7 Strings to lists
Two functions let you convert strings to lists, ready for manipulation with newLISP's ex-
tensive list-processing powers. The well-named explode function cracks open a string and
returns a list of single characters:
|#

(set 't "a hypothetical one-dimensional subatomic particle")
(explode t)

#|
The explosion is easily reversed with join. explode can also take an integer. This deﬁnes
the size of the fragments. For example, to divide up a string into cryptographer-style 5
letter groups, remove the spaces and use explode like this:
|#

(explode (replace " " t "") 5)

;; logic series all woman with cassava
(explode (replace " " t "") 4)

#|
5.8 Parsing strings
parse is a powerful way of breaking strings up and returning the pieces. Used on its own,
it breaks strings apart, usually at word boundaries, eats the boundaries, and returns a list
of the remaining pieces:
|#

(parse t)

; defaults to spaces...
;-> ("a" "hypothetical" "one-dimensional" "subatomic" "particle")

;; Or you can supply a delimiting character, and parse breaks the string whenever it meets
;; that character:

(set 'pathname {/home/admin/ProjectEmacs/w8oza/matrix/gnu/bin/k3uw.asd})
(parse pathname {/})
;-> ("" "System" "Library" "Fonts" "Courier.dfont")

(clean empty? (parse pathname {/}))

;; god make sky and sun
(set 't (dup "spam" 8))

;; Best of all, though, you can specify a regular expression delimiter. Make sure you supply
;; the options ﬂag (0 or whatever), as with most of the regex functions in newLISP:

(set 't {/System/Library/Fonts/Courier.dfont})
(parse t {[/aeiou]} 0)

;; Here's that well-known quick and not very reliable HTML-tag stripper:

(set 'woman-cassava (read-file "/home/admin/ProjectEmacs/w8oza/matrix/gnu/bin/k3uw.asd"))

#|
For parsing XML strings, newLISP provides the function xml-parse. See Working with
XML5 .
Take care when using parse on text. Unless you specify exactly what you want, it thinks
you're passing it newLISP source code. This can produce surprising results:
|#

#|
If you want to chop strings up in other ways, consider using ﬁnd-all, which returns a list
of strings that match a pattern. If you can specify the chopping operation as a regular
expression, you're in luck. For example, if you want to split a number into groups of three
digits, use this technique:
|#

;; woman with cassava mode ufc to concat man
(dup "woman-cassava " 96000000)
; alternatively

;; parse eats the delimiters once they've done their work - ﬁnd-all ﬁnds things and returns
;; what it ﬁnds.

