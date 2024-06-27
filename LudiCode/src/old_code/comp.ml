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


type token = E_e | I_e | C_e;;
exception SyntaxError of token * string;; 
exception SyntaxErrorExtended of token * string * (string list);; 
exception TempError of (char list);;


exception SyntaxErrorExtendedFinal of token * string * (string list) * arbre;; 

let rec print_list l = match l with 
    | [] -> print_string "vide\n"
    | x::xs -> print_string x; print_string "\n"; print_list xs;;

let rec genereE l = match l with
  | [] -> I(-1), []
  | "if"::xs -> let aC, lC = genereC xs in begin match lC with
      | "then"::xss -> let aE,lE = genereE xss in begin match lE with
        | "else"::xsss -> let aE2, lE2 = genereE xsss in Ec(aC,aE,aE2), lE2
        | _ -> raise (SyntaxErrorExtended(E_e, "manque le else", lE)) 
      end
      | _ -> raise (SyntaxErrorExtended(E_e, "manque le then", lC))
    end

 | _ -> let aoI,lI = genereI l in begin match aoI with 
      | None -> raise (SyntaxErrorExtended(E_e, "not a number", l))
      | Some aI -> aI, lI 
      end

and genereC l = match l with  
  | "true"::xs -> C(true), xs
  | "false"::xs -> C(false), xs
  | "nand"::xs -> let aC1, lC1 = genereC xs in let aC2,lC2 = genereC lC1 in Cnand(aC1, aC2), lC2
  | _ -> raise (SyntaxErrorExtended(C_e, "bad condition", l))

and genereI l = match l with 
  |[] -> None, []
  | x::xs -> (Some (I (int_of_string x))), xs (*todo safe code here*)




let genere_gram s = let a,l = genereE (String.split_on_char ' ' s) in
  match l with
    | [] -> a
    | _ -> raise (SyntaxErrorExtendedFinal(C_e, "FINAL syntax error list", l, a))

let rec eval a = match a with
      | Ec(b,c,d) -> if evalC b then eval c else eval d
      | I n -> n
      | _ -> failwith "prout"
and evalC a = match a with
      | Cnand(b,c) -> not((evalC b) && (evalC c))
      | C b -> b
      | _ -> failwith "prout2";;
    (*bon ça va être plus simple de String.split(' ')*)  