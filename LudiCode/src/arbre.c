#include "includes.h"
#include "tokenizer.h"

arbre* cree_arbre(val_type racine){
    arbre* a = malloc(sizeof(arbre));
    a->key = racine;
    a->fils_droit = NULL;
    a->fils_gauche = NULL;
    return a;
}

void detruire_arbre(arbre *a){
    if(a==NULL){ //si il n'y a rien on return
        return;
    }
    if(a->fils_droit == NULL && a->fils_gauche == NULL){ //on libère les feuilles
        free(a);
    }
    detruire_arbre(a->fils_gauche);
    detruire_arbre(a->fils_droit);
    free(a);
}