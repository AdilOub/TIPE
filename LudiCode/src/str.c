#include "str.h"

str create_string(int capacity){
    str string;
    string.index = 0;
    string.max_size = capacity;
    string.str = malloc_char(capacity, '\0');
    return string;
}

int get_char_size(char* str){
    int i = 0;
    while(str[i] != '\0'){
        i++;
    }
    return i+1; //+1 pour compter le \0
}

void append_string(str *str1, char* str2, int size){
    int s = size;
    if(s == UNKNOWN_STR_SIZE){
        s = get_char_size(str2);
    }
    if(str1->index + s < str1->max_size){
        for(int i = 0; i<s; i++){
            str1->str[i + str1->index] = str2[i];
        }
        str1->index += s;
    }else{
        realloc_string(str1, s+str1->max_size);
        append_string(str1, str2, s);
    }
}

void realloc_string(str *string, int min_size){
    int size = min_size < string->max_size ? string->max_size : min_size;
    size *= 2;
    char* newstr = malloc_char(size, '!');
    for(int i = 0; i<string->max_size; i++){
        newstr[i] = string->str[i];
    }
    string->max_size = size;
    if(string->str != NULL){
        free(string->str);
    }
    string->str = newstr;
}


void destroy_str(str string){
    if(string.str != NULL){
        free(string.str);
    }
    string.max_size = 0;
    string.index = 0;
}

char* malloc_char(int size, char c){
    char* s = malloc(sizeof(char)*size);
    for(int i = 0; i<size; i++){
        s[i] = c;
    }
    return s;
}

/*
bool is_digit(char* buffer, int s){
    int size = s;
    if(size == UNKNOWN_STR_SIZE){
        size = get_char_size(buffer);
    }

    for(int i = 0; i<size; i++){
        if(buffer[i] < '0' || buffer[i] > '9'){
            return false;
        }
    }
    return true;
}*/

bool char_isdigit(char c){
    if(c < '0' || c > '9'){
        return false;
    }
    return true;
}

int char_to_int(char c){
    return c - 48;
}

int str_to_int(char* buffer){
    int size = get_char_size(buffer);
    int puissanceDix = 1;
    int result = 0;

    int offset = buffer[size-1] == '\0' ? -2 : -1;
    for(int i = size + offset; i>=0; i--){
        int c = buffer[i];
        if(!char_isdigit(c)){
            fprintf(stderr, "Conversion en entier impossible pour %s\n", buffer);
            return -1;
        }
        result += char_to_int(c) * puissanceDix;
        puissanceDix *= 10;
    }

    return result;
}