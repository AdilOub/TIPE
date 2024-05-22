(*
E -> if C then E else E | while C do E then E | P<E> = E; E | P(E) | I 
I -> int avec CAS
C -> vrai | faux | I==I | nand C C |
*)


type arbre = 
  | Ec of arbre * arbre * arbre 
  | Eb of arbre * arbre * arbre
  | Eps of arbre * arbre * arbre
  | Epg of arbre
  | Ei of arbre
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
exception SyntaxErrorExtended of token * string * (char list);; 
exception TempError of (char list);;


let rec genereE l  = begin print_char (List.hd l); match l with 
  | [] -> I(-1), []
  | ' '::xs -> genereE xs 
  | 'i'::'f'::' '::r -> print_string "\nif"; let aC,lC = genereC r in begin match lC with
      | 't'::'h'::'e'::'n'::' '::rr -> print_string "\nthen"; let aE, lE = genereE rr in begin match lE with
          | ' '::'e'::'l'::'s'::'e'::' '::rrr -> print_string "\nelse"; let aEE,lEE = genereE rrr in Ec(aC, aE, aEE), lEE
          | _ -> raise (TempError lE) (*raise (SyntaxError(E_e, "else")) *) end
      | _ -> raise (TempError lC);  (*raise (SyntaxError(E_e,"then if")) *)end

          
  | 'w'::'h'::'i'::'l'::'e'::' '::r -> begin let aC,lC = genereC r in match lC with 
      | 'd'::'o'::' '::rr -> let aE,lE = genereE rr in begin match lE with
          | ' '::'t'::'h'::'e'::'n'::' '::rrr -> let aEE,lEE = genereE rrr in Eb(aC, aE, aEE), lEE
          | _ -> raise (SyntaxError(E_e, "then while")) end
      | _ -> raise (SyntaxErrorExtended(E_e, "do", lC)) end

      
  | 'P'::'<'::r -> begin let aE,lE = genereE r in match lE with
    | '>'::' '::'='::' '::rr -> let aEE,lEE = genereE rr in begin match lEE with
      | ';'::' '::rrr -> let aEEE,lEEE = genereE rrr in Eps(aE, aEE, aEEE), lEEE 
      | _ -> raise (SyntaxError( E_e, "P<>")) end
    | _ -> raise (SyntaxError(E_e, ";")) end

  | 'P'::'('::r -> begin let aE,lE = genereE r in match lE with
    | ')'::rr -> Epg(aE), rr
    | _ -> raise (SyntaxError(E_e, "P()")) end
  
    
  | _ -> print_string "I\n"; let a,r = genereI l in Ei(a), r
  end

and genereI l = match lst_to_int l with (*for test purspose only. réécrire*)
  | None, _ -> raise (SyntaxError(I_e, "I"))
  | Some n, r -> I(n), r
(*
and genereC l = let aB,lB = (match l with 
  | 'v'::'r'::'a'::'i'::' '::r -> C(true), r
  | 'f'::'a'::'u'::'x'::' '::r -> C(false), r
  | _ -> C(false), l (*false nand X = X*)
  ) in match lB with
    | 'n'::'a'::'n'::'d'::rr -> let aC,lC = genereC rr in Cnand(aB,aC),rr
  (* faire gaffe pour générer I et C: on doit essayer de les générer*)
  | _ -> try let aI,lI = genereI l in match lI with
      | '='::'='::r -> let aII,lII = genereI r in CEq(aI, aII), lII
      | _ -> raise (SyntaxErrorExtended(I_e, "on essaye de parse une egalité inexistance", lI))
    with (SyntaxError(I_e, _)) -> (*c'est pas un I, ça doit être un C*)
      let aC, lC = genereC l in match lC with
        | 'n'::'a'::'n'::'d'::' '::r -> let aCC, lCC = genereC r in Cnand(aC,aCC), lCC
        | _ -> raise (SyntaxError(C_e, "nand"))
*)
and genereC l = try let aI,lI = genereI l in match lI with 
                    | '='::'='::r -> let aII,lII = genereI r in CEq(aI, aII), lII
                    | _ -> raise (SyntaxErrorExtended(C_e, "comparaison manque ==", lI))
                with SyntaxError(I_e,_) -> match l with
                  | 'v'::'r'::'a'::'i'::r -> C(true), r
                  | 'f'::'a'::'u'::'x'::r -> C(false), r
                  | 'n'::'a'::'n'::'d'::r -> let aC,lC = genereC r in let aCC, lCC = genereC lC in Cnand(aC, aCC), lCC
                  | _ -> raise (SyntaxErrorExtended(C_e, "logique error", l));;
          
let genere_gram s = print_string "debut"; let a,l = genereE (List.of_seq (String.to_seq s)) in
  match l with
    | [] -> a
    | _ -> failwith "syntax error list"



    (*bon ça va être plus simple de String.split(' ')*)