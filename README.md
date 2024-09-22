# w8oza ([newlisp](https://www.newlisp.org/))

The provided code snippet is a C program that reverses the order of words in a given string and also reverses each word within the string. The main function prompts the user to enter a string, calls the reverseWords function to reverse the words, and then prints the reversed string.

The reverseString function takes a string as input and reverses it in-place. The reverseWords function uses the reverseString function to reverse each word in the given string.

The code does not contain any direct reference to the name "DindovUv". It is a standalone program that performs string manipulation.

The selected code is a function named reverseString that takes a character pointer str as input. This function reverses the order of characters in the string pointed to by str.

Here's a step-by-step explanation of the code:

1. The function calculates the length of the string using the strlen function and stores it in the length variable.
2. Two pointers, start and end, are initialized to point to the beginning and end of the string, respectively.
3. The function enters a while loop that continues until start and end meet or cross each other.
4. Inside the loop, the function swaps the characters pointed to by start and end using a temporary variable temp.
5. The start pointer is incremented and the end pointer is decremented after each swap.
6. Once the loop finishes, the string pointed to by str is reversed.


This function is used as a helper function in the reverseWords function to reverse individual words in a string.

The selected code within the open file is a function named reverseWords. This function takes a string as input and reverses the order of the words in the string.

Here's a breakdown of the code:

1. The function initializes two pointers, wordStart and wordEnd, to point to the beginning of the string.
2. It enters a while loop that continues until wordEnd reaches the end of the string ('\0').
3. Inside the loop, it checks if the character pointed to by wordEnd is a space or the end of the string.
4. If a space or the end of the string is found, it means that a word has ended. In this case, the function calls the reverseString function to reverse the characters in the current word from wordStart to wordEnd - 1.
5. After reversing the current word, the function updates wordStart to point to the next character after the space, which marks the beginning of the next word.
6. Finally, after the loop ends, the function calls reverseString once more to reverse the entire string.


This implementation effectively reverses the order of the words in the input string.

# C++ Library Reference - https://www.newlisp.org/ 
```c++
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_STR_LENGTH 100

void reverseString(char* str) {
    int length = strlen(str);
    char* start = str;
    char* end = str + length - 1;

    while (start < end) {
        char temp = *start;
        *start = *end;
        *end = temp;
        start++;
        end--;
    }
}

void reverseWords(char* str) {
    char* wordStart = str;
    char* wordEnd = str;

    while (*wordEnd != '\0') {
        if (*wordEnd == ' ' || *wordEnd == '\0') {
            reverseString(wordStart);
            wordStart = wordEnd + 1;
        }
        wordEnd++;
    }

    reverseString(str);
}

int main() {
    char input[MAX_STR_LENGTH];
    printf("Enter a string: ");
    fgets(input, MAX_STR_LENGTH, stdin);

    reverseWords(input);
    printf("Reversed string: %s", input);

    return 0;
}
```
# Makefile example library
```makefile
CXX = g++
CXXFLAGS = -Wall -Werror -Wextra -pedantic -std=c++17 -g main.cpp
LDFLAGS =  main.cpp

SRC = 
OBJ = $(SRC:.cc=.o)
EXEC = w8oza

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CXX) $(LDFLAGS) -o $@ $(OBJ) $(LBLIBS)

clean:
	rm -rf $(OBJ) $(EXEC)
```
# install makefiles
$-> make all 
   
