(*
E -> if C then E else E | while C do E then E | P<E> = E; E | P(E) | I 
I -> int avec CAS
C -> vrai | faux | I==I | I!=I | C && C | C || C | !C
*)


type token = if | then | else | while | do | 
type arbre = 
  | Ec of arbre * arbre * arbre 
  | Eb of arbre * arbre * arbre
  | Eps of arbre * arbre
  | Epg of arbre
  | Ei of arbre
  | I of int
  | C of bool 
  | Cbis of C * C
  | Cbbis of int * int


let explode s = List.init (String.length s) (String.get s)

let is_int c = c >= '0' && c <= '9';;

let rec lst_to_int l = Some 3;;

let rec genereE l : arbre = match l with 
  | [] -> I 0
  | ' '::xs -> genereE xs
  | 'i'::'f'::' '::r -> let aC,lC = genereC lC in match lC with
      | 't'::'h'::'e'::'n'::' '::rr -> let aE,lE = genereE rr in match lE with
          | 'e'::'l'::'s'::'e'::' '::rrr -> let aEE,lEE = genereE rrr in Ec(ac, aE, aEE), lEE

  | 'w'::'h'::'i'::'l'::'e'::' '::r -> let aC,lC = genereC r in match lC with 
      | 'd'::'o'::' '::rr -> let aE,lE = genereE rr in match lE with
          | 't'::'h'::'e'::'n'::' '::rrr -> let aEE,lEE = genereE rrr in Eb(ac, aE, aEE), lEE

  | 'P'::'<'::r -> let aE,lE = genereE r in match lE with
    | '>'::' '::''='::' '::rr -> let aEE,lEE = genereE rr in match lEE with
      | ';'::' '::rrr -> let aEEE,lEEE = genereE rrr in Eps(aE, aEE, aEEE), lEEE
    
  | 'P'::'('::r -> let aE,lE = genereE in match lE with
    | ')'::rr -> Epg(aE)

  | _ -> let a,r = genereI l in Ei(a), r

and genereI l = match list_to_int l with (*for test purspose only. réécrire*)
  | None -> failwith "syntax error I"
  | Some n -> I(n)

and genereC l = match l with 
  | 'v'::'r'::'a'::'i'::[] -> C(true)
  | 'f'::'a'::'u'::'x'::[] -> C(false)
  | (* faire gaffe pour générer I et C: on doit essayer de les générer*)           
          
let genere_gram s = let a,l = genereS (List.of_seq (String.to_seq s)) in
  match l with
    | [] -> a
    | _ -> failwith "syntax error list"
