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


char* pile[1024];

int main(){


    return 0;
}