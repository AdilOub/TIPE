#include "includes.h"


#ifndef __TOKENIZER__
#define __TOKENIZER__
#define MAXSIZE 4096


typedef enum STATE {State_NONE, State_NUMBER, State_SYMBOL, State_EOF, State_ERROR} STATE;

typedef enum TOKEN_TYPE {NONE, NUMBER, ADD, MULT, MINUS, DIVIDE, POWER, TOKEN_MAX} TOKEN_TYPE;

typedef enum PRIORITE {Priorite_min, Priorite_Term, Priorite_Facteur, Priorite_Puissance} PRIORITE;

static char* token_to_str[TOKEN_MAX] = {
    [NUMBER] = "number",
    [ADD] = "add",
    [MULT] = "mult",
    [NONE] = "debut_fichier",
};
static PRIORITE get_priorite[TOKEN_MAX] = {
    [ADD] = Priorite_Term,
    [MINUS] = Priorite_Term,
    [MULT] = Priorite_Term,
    [DIVIDE] = Priorite_Term,
    [POWER] = Priorite_Puissance,
};

typedef struct token
{
    char str[MAXSIZE]; //pas utiliser pour CAS
    TOKEN_TYPE type;
    int value;

} token;

//LISTE
typedef token val_type;

typedef struct maillon maillon;
//on utilise une liste circulaire
struct maillon
{
    val_type val;
    maillon* next;
    maillon* prev;
    maillon* first; 
};
typedef maillon* list;
list creer_list(val_type data);
list ajouter_element(list liste, val_type val);
void detruire_list(list liste);
void afficher_list(list liste);
void next_listptr(list *l);
list tokenize(FILE*);


typedef struct arbre arbre;
struct arbre{
    val_type key;
    arbre* fils_gauche;
    arbre* fils_droit;
};
arbre* creer_arbre(val_type);
void detruire_arbre(arbre*);
#endif
