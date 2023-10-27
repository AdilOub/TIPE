#include "tokenizer.h"
#include "str.h"

static size_t current_token_length;

list tokenize(FILE* f){
    token BOF = {"", NONE, 0};
    list token_list = creer_list(BOF);
    char c;
    while((c=getc(f)) != EOF){        
        //on lit un nombre
        if(char_isdigit(c)){
            int buffer[MAXSIZE];
            buffer[0] = char_to_int(c);
            int n = 1;
            char c2 = getc(f);
            while(c2!=EOF && char_isdigit(c2)){
                buffer[n] = char_to_int(c2);
                n++;
                c2 = getc(f);
            }
            c = c2;
            int d=0;
            int p=1;
            for(int i = n-1; i>=0; i--){
                d+=buffer[i]*p;
                p*=10;
            }
            token number_token = {"", NUMBER, d};
            token_list = ajouter_element(token_list, number_token);
        }

        if(c=='+'){
            token add_token = {"", ADD, 0};
            token_list = ajouter_element(token_list, add_token);
        }

        if(c=='*'){
            token_list = ajouter_element(token_list, (token){"", MULT, 0});

        }
    }

    return token_list;
}