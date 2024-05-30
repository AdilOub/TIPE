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
E -> if C then E else E | while C do E then E | set E <- E ; E | get E | I 
I -> int avec CAS
C -> vrai | faux | eq( E, E ) | nand( C , C ) |
*)

let rec genereE lst = match lst with
  | [] -> raise (SyntaxError(E_e, "E syntax error"))
  | "if"::xs -> let a1,l1 = genereC xs in begin
    match l1 with  
      | "then"::xs1 -> let a2,l2 = genereE xs1 in begin
        match l2 with
          | "else"::xs2 -> let a3,l3 = genereE xs2 in begin
            match l3 with
              | _ -> Ec(a1,a2,a3), l3
              end
          | _ -> raise (SyntaxErrorExtended(E_e, "E syntax error list then", l2))
        end
      | _ -> raise (SyntaxErrorExtended(E_e, "E syntax error list if", l1))
      end
  | "set"::xs -> let aE1,l1 = genereE xs in begin 
    match l1 with
    | "<-"::xss -> let aE2, l2 = genereE xss in begin 
      match l2 with 
      | ";"::xsss -> let aE3, l3 = genereE xsss in Eps(aE1, aE2, aE3), l3
      | _ -> raise (SyntaxErrorExtended(E_e, "E syntax error ptr arrow", l2))
    end
    | _ -> raise (SyntaxErrorExtended(E_e, "E syntax error ptr attribution", l1))  
  end

  | "get"::xs -> let aE,l1 = genereE xs in Epg(aE), l1

  | _ -> genereI lst 

and genereC lst = match lst with 
  | [] -> raise (SyntaxError(C_e, "C syntax error"))
  | "true"::xs -> C(true), xs
  | "false"::xs -> C(false), xs
  | "nand("::xs -> let aC1, lr1 = genereC xs in begin 
    match lr1 with
      | ","::xss -> let aC2, lr2 = genereC xss in begin
        match lr2 with
          | ")"::xsss -> Cnand(aC1, aC2), xsss
          | _ -> raise (SyntaxErrorExtended(C_e, "Nand SyntaxError Part2", lr2))
      end
      | _ -> raise (SyntaxErrorExtended(C_e, "Nand SyntaxError Part1", lr1))
    end

  | "eq("::xs -> let aE,l1 = genereE in begin
    match l1 with
      | ","::xss -> 
      | _ -> 
  end
  
  | _ -> raise (SyntaxErrorExtended(C_e, "genereC non valide", lst))

and genereI lst = match lst with 
  | [] -> raise (SyntaxError(I_e, "I syntax error (empty !)"))
  | x::xs -> I(int_of_string x), xs

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