(*
S->T|T+S
T->F|F*T
F->a|(S)   
*)

type arbre = 
  | S of arbre * arbre
  | T of arbre * arbre
  | F of arbre
  | A of int


let is_int c = c >= '0' && c <= '9';;

let rec genereS l = let aT, lt = genereT l in 
  match lt with
    | '+'::r -> let aS, lr = genereS r in S(aT, aS), lr
    | _ -> aT, lt
and genereT l = let aF, lt = genereF l in 
  match lt with
    | '*'::r -> let aT, lr = genereT r in T(aF, aT), lr
    | _ -> aF, lt
and genereF l = 
  match l with
    | n::r when is_int n -> A(int_of_char n -48), r
    | '('::r -> let aS, lr = genereS r in
      begin match lr with
        | ')'::r -> F(aS), r
        | _ -> failwith "syntax error F )"
      end
    | _ -> failwith "syntax error F debut"

let genere_gram s = let a,l = genereS (List.of_seq (String.to_seq s)) in
  match l with
    | [] -> a
    | _ -> failwith "syntax error list"

let rec eval n = match n with
  | A a -> a
  | S(a,b) -> eval a + eval b
  | T(a,b) -> eval a * eval b
  | F(a) -> eval a

