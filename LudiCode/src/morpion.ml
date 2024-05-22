(*

LL(2)

M coups joué
J joueur
v : M -> {j1, j2, aucun} tq renvoit le gagnant ou aucun

S->AL|BL|CL
L->0F|1F|2F
F-> if mot in M then S else ajouter mot dans M; changer joueur; JM

lire 
A0XB0OB1XA1OC2X victoire de X
*)



type joueur = X | O;;
type coo = int * int;;
type coup = coo * joueur;;
type ensemble = coup list;;


(*determine si on est dans un état final *)
let verificateur ensemble = 
  false;;

type arbre = 
  | S of arbre
  | L of arbre
  | F of arbre;;

let rec genereS lst = match lst with
  | 'A'::xs -> let aL, lL = genereL xs in 
  | 'B'::xs ->
  | 'C'::xs -> 
  | _ -> failwith "Syntax error ocaml"
and 