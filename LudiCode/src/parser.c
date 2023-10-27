#include "includes.h"
#include "parser.h"

//si un opérateur à une priorité supérieur à l'opérateur qui suit alors on évalue l'arbre normalement
// A a B b C (avec a et b des opérateurs, A,B,C des expressions):
//Si a>=b: b est la racines, le fils gauche est a, le droit est C. ET le fils gauche de a est A, le fils droit de a est B
//Si a<b: a est la racine, le fils gauche de a est A, le gauche est b. ET les fils de b sont B et C (gauche et droite resp.)

/*
Précondition: l doit pointer vers le debut de la liste, appel_init ne doit être vrai que pour l'appel initial
*/
arbre* parse(list l, bool appel_init){
    if(l->next = l){
        //la liste n'a qu'un element, ça doit donc être un nombre (sinon erreur)
        if(l->val.type != NUMBER){
            fprintf(stderr, "Erreur en parsant: l'arbre ne contient qu'un element, et il est différent d'un nombre");
            return NULL;
        }
        return creer_arbre(l->val);
    }

    arbre* number1 = creer_arbre(l->val);
    arbre*symbol = creer_arbre(l->next->val);
    
    
}

float eval_tree(arbre* a){
    return -1;
}