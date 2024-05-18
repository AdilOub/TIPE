/*
CAS basique qui calcule des expressions arithmétiques simples, 
les evalues et génère du code assembleur qui les évalues aussi.
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*grammaire pour des additions:
S-> S+T | T
T-> T*F | F
F-> (S) | n
n est un nombre
*/


typedef enum {
    S, //somme
    T, //terme
    F, //facteur
    A //atom (entier)
} NodeType;


typedef struct node_t
{
    NodeType type;
    union 
    {
        struct
        {
            struct node_t* left;
            struct node_t* right;
        } s_or_t;
        struct 
        {
            struct node_t* child;
        } f;
        struct{
            int value;
        } a;
        
    } data;
    
} Node;

Node* create_s(Node* left, Node* right);
Node* create_t(Node* left, Node* right);
Node* create_f(Node* child);
Node* create_a(int value);

Node* create_s(Node* left, Node* right) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->type = S;
    node->data.s_or_t.left = left;
    node->data.s_or_t.right = right;
    return node;
}

Node* create_t(Node* left, Node* right) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->type = T;
    node->data.s_or_t.left = left;
    node->data.s_or_t.right = right;
    return node;
}

Node* create_f(Node* child) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->type = F;
    node->data.f.child = child;
    return node;
}

Node* create_a(int value) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->type = A;
    node->data.a.value = value;
    return node;
}

void free_node(Node* node) {
    if (node->type == S || node->type == T) {
        free_node(node->data.s_or_t.left);
        free_node(node->data.s_or_t.right);
    } else if (node->type == F) {
        free_node(node->data.f.child);
    }
    free(node);
}

typedef struct {
    Node* node;
    char* rest;
} ParseResult;

ParseResult genere_s(char* str);
ParseResult genere_t(char* str);
ParseResult genere_f(char* str);

ParseResult genere_s(char* str) {
    ParseResult result = genere_t(str);
    if(*result.rest == '+') {
        ParseResult result2 = genere_s(result.rest + 1);
        return (ParseResult) {create_s(result.node, result2.node), result2.rest};
    } else {
        return result;
    }
}

ParseResult genere_t(char* str) {
    ParseResult result = genere_f(str);
    if(*result.rest == '*') {
        ParseResult result2 = genere_t(result.rest + 1);
        return (ParseResult) {create_t(result.node, result2.node), result2.rest};
    } else {
        return result;
    }
}

ParseResult genere_f(char* str) {
    if(*str == '(') {
        ParseResult result = genere_s(str + 1);
        if(*result.rest == ')') {
            return (ParseResult) {create_f(result.node), result.rest + 1};
        } else {
            printf("Error: expected ')'");
            exit(1);
        }
    } else {
        return (ParseResult) {create_a(*str - '0'), str + 1};
    }
}

void afficher(Node* node) {
    if (node->type == S) {
        printf("S( ");
        afficher(node->data.s_or_t.left);
        printf("+");
        afficher(node->data.s_or_t.right);
        printf(" )");
    } else if (node->type == T) {
        printf("T( ");
        afficher(node->data.s_or_t.left);
        printf("*");
        afficher(node->data.s_or_t.right);
        printf(" )");
    } else if (node->type == F) {
        printf("F (");
        afficher(node->data.f.child);
        printf(")");
    } else if (node->type == A) {
        printf("%d", node->data.a.value);
    }
}

int eval(Node* node) {
    if (node->type == S) {
        return eval(node->data.s_or_t.left) + eval(node->data.s_or_t.right);
    } else if (node->type == T) {
        return eval(node->data.s_or_t.left) * eval(node->data.s_or_t.right);
    } else if (node->type == F) {
        return eval(node->data.f.child);
    } else if (node->type == A) {
        return node->data.a.value;
    }
}

void write_asm(FILE * file, Node* node){
    if (node->type == S) {
        write_asm(file, node->data.s_or_t.left);
        fprintf(file, "PUSH RAX\n");
        write_asm(file, node->data.s_or_t.right);
        fprintf(file, "POP RDX\n");
        fprintf(file, "ADD RAX, RDX\n");
    } else if (node->type == T) {
        write_asm(file, node->data.s_or_t.left);
        fprintf(file, "PUSH RAX\n");
        write_asm(file, node->data.s_or_t.right);
        fprintf(file, "POP RDX\n");
        fprintf(file, "MUL RDX\n");
    } else if (node->type == F) {
        write_asm(file, node->data.f.child);
    } else if (node->type == A) {
        fprintf(file, "MOV RAX, %d\n", node->data.a.value);
    }
}

void write_in_asm_main(FILE* file, Node* node){
    fprintf(file, "[BITS 64]\n");
    fprintf(file, "section .text\n");
    fprintf(file, "global _start\n");
    fprintf(file, "_start:\n");
    fprintf(file, "MOV RAX, 0\n");
    write_asm(file, node);
    //on return le resultat
    //mov rdi, result (valeur de retour)
    fprintf(file, "MOV RDI, RAX\n");
    //mov rax 60 (exit code)
    //syscall
    fprintf(file, "MOV RAX, 60\n");
    fprintf(file, "SYSCALL\n");
}

int main(){
    char* str = "1+2*(3+1)+10";
    FILE *file;
    file = fopen("calc.asm", "w");
    ParseResult result = genere_s(str);
    afficher(result.node);
    printf("\n");
    printf("Evaluation: %d\n", eval(result.node));
    write_in_asm_main(file, result.node);
    free_node(result.node);
    return 12;
}

/*
nasm -f elf64 -o calc.o calc.asm&&
ld -o calc calc.o&&
./calc&&
echo $?&&


*/