#include "includes.h"
#include "tokenizer.h"


list creer_list(val_type data){
    maillon* m = malloc(sizeof(maillon));
    m->first = m;
    m->next = m;
    m->prev = m;
    m->val = data;
    return m;
}

list ajouter_element(list liste, val_type val){
    maillon* m = malloc(sizeof(maillon));

    m->first = liste->first;

    m->prev = liste;
    m->next = liste->first;
    m->val = val;

    liste->next = m;
    liste->first->prev = m;

    return m;
}

void detruire_list(list liste){
    maillon* n = liste;
    if(n->next==NULL){
        free(n);
        return;
    }
    maillon* tofree = n;
    n=n->next;

    while(n != liste){
        if(n != NULL){
            maillon* temp = n;
            n = n->next;
            free(temp);
        }else{
            fprintf(stderr, "Erreur: on essaye de free un maillon nul !\n");
            break;
        }
    }
    free(tofree);

}

void afficher_list(list liste){
    maillon* n = liste->next;
    maillon* premier = n;
    printf("%s (%d)\n", token_to_str[(n->val).type], (n->val).value);
    if(n->next == NULL){
        return;
    }
    n=n->next;

    while(n != premier){
        printf("%s (%d)\n", token_to_str[(n->val).type], (n->val).value);
        n = n->next;
    }
    return;
}

void next_listptr(list *l){
    *l = (*l)->next;
}