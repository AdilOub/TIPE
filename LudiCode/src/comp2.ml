(*
E -> if C then E else E | while C do U then E | U; E | P(E) | I 
U -> () | P<E> = E
I -> int avec CAS
C -> vrai | faux | eq I I | nand C C |
*)


type arbre = 
  | Ec of arbre * arbre * arbre 
  | Eb of arbre * arbre * arbre
  | Eps of arbre * arbre * arbre
  | Epg of arbre
  | Ei of arbre
  | Ua of arbre * arbre
  | U
  | I of int
  | C of bool 
  | CEq of arbre * arbre
  | Cnand of arbre * arbre;;


let explode s = List.init (String.length s) (String.get s)

let is_int c = c >= '0' && c <= '9';;

let rec lst_to_int l = match l with
  | [] -> None, []
  | x::xs when is_int x -> Some 3, xs
  | _ -> None, l;;


type token = E_e | I_e | C_e | U_e;;
exception SyntaxError of token * string;; 
exception SyntaxErrorExtended of token * string * (string list);; 
exception TempError of (char list);;


exception SyntaxErrorExtendedFinal of token * string * (string list) * arbre;; 

let rec print_list l = match l with 
    | [] -> print_string "vide\n"
    | x::xs -> print_string x; print_string "\n"; print_list xs;;

(*
E -> if C then E else E | while C do U then E | U; E | P(E) | I 
U -> () | P<E> = E
I -> int avec CAS
C -> vrai | faux | eq I I | nand C C |
*)

let rec genereE lst = match lst with
  | [] -> raise (SyntaxError(E_e, "E syntax error"))
  | "if"::xs -> let a1,l1 = genereC xs in
    match l1 with 
      | "then"::xs1 -> let a2,l2 = genereE xs1 in
        match l2 with
          | "else"::xs2 -> let a3,l3 = genereE xs2 in
            match l3 with
              | [] -> Ec(a1,a2,a3), []
              | _ -> raise (SyntaxErrorExtended(E_e, "E syntax error list", l3))
          | _ -> raise (SyntaxErrorExtended(E_e, "E syntax error list", l2))
      | _ -> raise (SyntaxErrorExtended(E_e, "E syntax error list", l1))

  | _ -> genereI lst 

and genereC lst = match lst with 
  | [] -> raise (SyntaxError(C_e, "C syntax error"))
  | "vrai"::xs -> C(true), xs
  | "faux"::xs -> C(false), xs

and genereI lst = match lst with 
  | [] -> raise (SyntaxError(I_e, "I syntax error"))
  | x::xs -> I(int_of_string x), xs;;

let genere s = let a,l = genereE (String.split_on_char ' ' s) in
  match l with
    | [] -> a
    | _ -> raise (SyntaxErrorExtendedFinal(E_e, "FINAL syntax error list", l, a));;



(*
let genere_gram s = let a,l = genereE (String.split_on_char ' ' s) in
  match l with
    | [] -> a
    | _ -> raise (SyntaxErrorExtendedFinal(C_e, "FINAL syntax error list", l, a))

*)