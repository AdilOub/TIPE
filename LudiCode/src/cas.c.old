#include "main.h"


enum TOKEN_TYPE {NOMBRE, ADD, SUB, MULT, DIV};
typedef enum TOKEN_TYPE TOKEN_TYPE;

struct token
{
    TOKEN_TYPE type;
    int value;
    int position; //unused
};
typedef struct token token;

int PRIORITE[5] = {0,1,2,4,3};

const char* NOM[5] = {"NOMBRE", "ADD", "SUB", "MULT", "DIV"};

typedef struct token_list token_list;
struct token_list{
    token val;
    token_list* next;
};


void clear_buffer(char* buffer, int size){
    for(int i = 0; i<size; i++){
        buffer[i] = 0;
    }
}

token_list* add_token(token_list* l, token t){
    token_list* nl = malloc(sizeof(token_list));
    nl->val = t;
    nl->next = l;
    return nl;
}

//renvoie un liste (dans le sens inverse) des tokens
token_list* tokenize(char* str){
    token_list* list = NULL;

    assert(str != NULL);

    char buffer[256];
    int i=0;
    int p=0;
    clear_buffer(buffer, 256);
    while (*str != 0)
    {
        buffer[i] = *str;
        switch (*str)
        {
        case '+':
            list = add_token(list, (token){ADD, 0, p});
            clear_buffer(buffer, 256);
            i=-1;
            break;
        case '-':
            list = add_token(list, (token){SUB, 0, p});
            clear_buffer(buffer, 256);
            i=-1;
            break;
        case '*':
            list = add_token(list, (token){MULT, 0, p});
            clear_buffer(buffer, 256);
            i=-1;
            break;
        case '/':
            list = add_token(list, (token){DIV, 0, p});
            clear_buffer(buffer, 256);
            i=-1;
            break;
        default:
            clear_buffer(buffer, 256);
            i=0;
            while(isdigit(*str)){
                buffer[i] = *str;
                str++;
                i++;
                p++;
            }
            if(i==0){
                printf("Erreur à la position %d\n", p);
                exit(EXIT_FAILURE);
            }
            str--; //on a pris un caractère en trop
            p--;//meme raison
            int v = atoi(buffer);
            i=-1;
            list = add_token(list, (token){NOMBRE, v, p});
            break;
        }

        str++;
        i++;
        p++;


    }
    return list;
} 

void afficher_token_list(token_list* l){
    if(l == NULL){
        printf("FIN\n");
        return;
    }
    printf("Token: %s %d %d \n", NOM[l->val.type], l->val.value, l->val.position);
    afficher_token_list(l->next);
}


//on va fabriquer l'arbre.
//si p(operation)<p(operation_suivante): on rajoute l'opération suivante à la racine, et son fils droit deviens le nombre d'après (verif à faire)
//sinon on change le fils droit actuelle par l'opération suivante

typedef struct arbre arbre;
struct arbre{
    token t;
    arbre* droit;
    arbre* gauche;
};


token base = {-1, 0, 0};



int get_next_prio(token_list *l){
    if(l->next == NULL){
        return -1;
    }
    return PRIORITE[l->next->val.value];
}


//idée: on peut construire un arbre manuelement pour un CAS
//mais pour un langage plus complexe c'est limite impossible
//donc on va utiliser une grammaire et une analyse LL1
arbre* construire_arbre_rec(token_list* list, arbre* prec, int last_prio){
    if(list==NULL){
        return prec;
    }
    if(list->val.type == NOMBRE && list->next == NULL){ //on a une expression du type n
        arbre* a = malloc(sizeof(arbre));
        a->droit = NULL;
        a->gauche = NULL;
        a->t = list->val;
        if(prec == NULL){
            return a;
        }

        if(prec->droit == NULL){
            prec->droit = a;
        }else if(prec->gauche == NULL){
            prec->gauche = a;
        }else{
            printf("Erreur syntaxe\n");
            exit(EXIT_FAILURE);
        }
        return prec;
    }
    //on a une expression du type n [reste d'expression]
    //on doit determiner la priorité du/des prochain(s) opérateur(s) dans [reste]
    if(list->next->val.type == NOMBRE){ //on a deux nombres qui se suivent: erreur
        printf("Erreur syntaxe: deux nombres se suivent à la position ou il manque un nombre %d???\n", list->val.position);
        exit(EXIT_FAILURE);
    }
    //on a donc une expression du type n operateur [reste]
    if(list->next->next->val.type != NOMBRE){ //on a n operateur operateur: pas normal !!
        printf("Erreur syntaxe: deux opérateurs se suivent à la position ou il manque un nombre %d\n", list->next->val.position);
        exit(EXIT_FAILURE);
    }
    
    //cas de base 
    if(last_prio == -1){
        arbre* op = malloc(sizeof(arbre));
        op->t = list->next->val;
        arbre* n = malloc(sizeof(arbre)); //un nombre est forcément une feuille
        n->t = list->val;
        n->droit = NULL;
        n->gauche = NULL;
        op->gauche = n;
        op->droit = construire_arbre_rec(list->next->next, NULL, PRIORITE[list->next->val.value]);
        return op;
    }

    //cas prio prec <= prio actuelle: c'est le cas de base
    if(last_prio <= PRIORITE[list->next->val.value]){
        printf("cas ok\n");
        //on a n operateur m [reste] c'est bon.
        //on fait l'arbre avec n<-operateur->[m & reste]
        arbre* op = malloc(sizeof(arbre));
        op->t = list->next->val;
        arbre* n = malloc(sizeof(arbre)); //un nombre est forcément une feuille
        n->t = list->val;
        n->droit = NULL;
        n->gauche = NULL;
        op->droit = n;
        op->gauche = construire_arbre_rec(list->next->next, op, PRIORITE[list->next->val.value]);
        return prec == NULL ? op : prec ;
    }
    printf("cas chiant\n");
    //cas prio prec < prio actuelle. c'est le cas relou
    arbre* op = malloc(sizeof(arbre));
    op->t = list->next->val;
    arbre* n = malloc(sizeof(arbre)); //un nombre est forcément une feuille
    n->t = list->val;
    n->droit = NULL;
    n->gauche = NULL;

    op->gauche = n;
    if(prec != NULL){
        prec->droit = op;
    }   
    op->droit = construire_arbre_rec(list->next->next, NULL, PRIORITE[list->next->val.value]);
    return prec;

}

arbre* creer_arbre(token_list* list){
    return construire_arbre_rec(list, NULL, -1);
}

void afficher_arbre(arbre* a){
    if(a==NULL){
        //printf("Fin\n");
        return;
    }
    printf("Racine: ");
    printf("Token: %s %d %d \n", NOM[a->t.type], a->t.value, a->t.position);
    printf("Fils gauche:\n");
    afficher_arbre(a->gauche);
    printf("Fils droit:\n");
    afficher_arbre(a->droit);
}

char* read_file(FILE* f){
    char * buffer = 0;
    long length;
    if(f)
    {
    fseek (f, 0, SEEK_END);
    length = ftell (f);
    fseek (f, 0, SEEK_SET);
    buffer = malloc (length);
    if (buffer)
    {
        fread (buffer, 1, length, f);
    }
    fclose (f);
    }
    return buffer;
}


int main(int argc, char* argv[]){
    assert(argc == 2);

    FILE* file = fopen(argv[1], "rw");
    char* str = read_file(file);
    printf("OK: %s\n", str);
    token_list* list = tokenize(str);

    afficher_token_list(list);
    printf("Construction arbre...\n");
    arbre* a = creer_arbre(list);
    printf("arbre ok: \n");
    afficher_arbre(a);

    return 0;
}