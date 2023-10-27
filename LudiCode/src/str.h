#pragma once
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

#define UNKNOWN_STR_SIZE -1

typedef struct str
{
    char* str;
    int index;
    int max_size;
} str;

str create_string(int capacity);
void append_string(str *str1, char* str2, int size);
int get_char_size(char* str);
void realloc_string(str *string, int min_size);

void destroy_str(str string);
char* malloc_char(int size, char c);

int char_to_int(char c);
bool char_isdigit(char c);
int str_to_int(char* buffer);