#|
s500p:
- Author: admin
- Date: 2024-09-22
|#

(date)

(set 't "a hypothetical one-dimensional subatomic particle")
(upper-case t)
(lower-case t)
(title-case t)

;; 5.4 Substrings
;; If you know which part of a string you want to extract, use one of the following constructive
;; functions:
(set 't "a hypothetical one-dimensional subatomic particle")
(first t)
;-> "a"
(rest t)
;-> " hypothetical one-dimensional subatomic particle"
(last t)
;-> "e"
(t 2)
;-> "h"

#|
 5.4.1 String slices
slice gives you a new slice of an existing string, counting either forwards from the cut
(positive integers) or backwards from the end (negative integers), for the given number of
characters or to the speciﬁed position:
|#

(set 't "a hypothetical one-dimensional subatomic particle")
(slice t 15 13)
;-> "one-dimension"
(slice t -8 8)
;-> "particle"
(slice t 2 -9)
;-> "hypothetical one-dimensional subatomic"
(slice "schwarzwalderkirschtorte" 19 -1)
;-> "tort"


;; There's a shortcut to do this, too. Put the required start and length before the string in a
;; list:

(15 13 t)
;-> "one-dimension"
(0 14 t)
;-> "a hypothetical"

;; If you don't want a continuous run of characters, but want to cherry-pick some of them for
;; a new string, use select followed by a sequence of character index numbers:

(set 't "a hypothetical one-dimensional subatomic particle")
(select t 3 5 24 48 21 10 44 8)
;-> "yosemite"

#|
5.4.2 Changing the ends of strings
trim and chop are both constructive string-editing functions that work from the ends of
the original strings inwards.
chop works from the end:
|#

(chop t)
; defaults to the last character
;-> "a hypothetical one-dimensional subatomic particl"

(chop t 9)
; chop 9 characters off
;-> "a hypothetical one-dimensional subatomic"

;; trim can remove characters from both ends:

(set 's "centured ")  ; defaults to removing spaces
(trim s)
;-> "centred"

(set 's "------centred------")
(trim s "-")
;-> "centred"

(set 's "------centred******") ; front and back
(trim s "-" "*")
;-> "centred"

(set 't "some")
(push "this is " t)
(push "text" t -1)
#|
pop always returns what was popped, but push returns the modiﬁed target of the action.
It's useful when you want to break up a string and process the pieces as you go. For
example, to print the newLISP version number, which is stored as a 4 or 5 digit integer,
use something like this:
|#

(set 'version-string (string (sys-info -2)))
; eg: version-string is now "10303"
(set 'dev-version (pop version-string -2 2))
; always two digits
; dev-version is "03", version-string is "103"
(set 'point-version (pop version-string -1))
; always one digit
; point-version is "3", version-string is now "10"
(set 'version version-string)
; one or two digits
(println version "." point-version "." dev-version)

;; It's easier to work from the right-hand side of the string and use pop to extract the infor-
;; mation and remove it in one operation.
