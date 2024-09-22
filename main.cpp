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
