#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef enum {
    E_condition,
    E_boucle,
    E_unit,
    E_int,
    U_ptr,
    U_nop,
    U_void,
    C_bool,
    C_nand,
    C_eq,
    I_ptr,
    I_cas
} NodeType;

typedef struct node_t Node;
struct node_t{
    NodeType type;
    union 
    {
        struct{
            Node* C_if;
            Node* E_then;
            Node* E_else;
        } e_condition;

        struct {
            Node* C_while;
            Node* U_do;
            Node* E_then;
        } e_boucle;

        struct{
            Node* U_u;
            Node* E_r;
        } e_unit;

        struct {
            
        }
        struct{

        } u;

        struct{

        } c;

        struct {

        } i;
    } data;
    
};

//on va pas utiliser la recursivité ici, mais à la place une pile !!!