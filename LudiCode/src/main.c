#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "str.h"
#include "parser.h"
#include "tokenizer.h"

#define MAX_TOKEN_SIZE 128


void print_and_clear_buffer(char* buffer, int size){
    for(int i = 0; i<size; i++){
        printf("%c", buffer[i]);
        buffer[i] = '\0';
    }
    printf("\n");
}

//verifie que b inclus dans a
//unsafe si size(b) < size(a)
bool strcmp_naive(char* a, char* b, int sb){
    for(int i = 0; i<sb; i++){
        if(a[i] != b[i]){
            printf("%s different de %s\n", a, b);
            return false;
        }
    }
    return true;
}

int main(int argc, char* args[]){
    if(argc != 2){
        fprintf(stderr, "Veuillez donner un fichier d'entree\n");
        return EXIT_FAILURE;
    }

    char* name = args[1];
    FILE* fptr = fopen(name, "r");

    if(fptr == NULL){
        fprintf(stderr, "Impossible d'ouvrir le fichier: %s\n", name);
        return EXIT_FAILURE;
    }
    list token_list = tokenize(fptr);
    afficher_list(token_list);
    
    fclose(fptr);   
    detruire_list(token_list); 
    return EXIT_SUCCESS;
}