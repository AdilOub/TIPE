(*
E -> if C then E else E | while C do U done E | U; E | P(E) | I 
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
  | I of arbre
  | IS of arbre * arbre
  | IT of arbre * arbre
  | IF of arbre 
  | IA of int
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
E -> if C then E else E | while C do E done E | set E <- E ; E | get E | I 
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

  | "while"::xs -> let aC,lC = genereC xs in begin 
    match lC with
      | "do"::xss -> let aE,lE = genereE xss in begin
          match lE with 
            | "done"::xsss -> let aE2,lE2 = genereE xsss in Eb(aC, aE, aE2), lE2
            | _ -> raise (SyntaxErrorExtended(E_e, "While SyntaxError Part2", lE))
      end
      | _ -> raise (SyntaxErrorExtended(E_e, "While SyntaxError Part1", lC))
  end

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

  | "eq("::xs -> let aE,l1 = genereE xs in begin
    match l1 with
      | ","::xss -> let aE2,l2 = genereE xss in begin
        match l2 with
          | ")"::xsss -> CEq(aE, aE2), xsss
          | _ -> raise (SyntaxErrorExtended(C_e, "Eq SyntaxError Part2", l2))
      end
      | _ -> raise (SyntaxErrorExtended(C_e, "Eq SyntaxError Part1", l1)) 
  end
  
  | _ -> raise (SyntaxErrorExtended(C_e, "genereC non valide", lst))
(*
and genereI lst = match lst with 
  | [] -> raise (SyntaxError(I_e, "I syntax error (empty !)"))
  | "+"::xs -> let a
  | x::xs -> I(int_of_string x), xs
*)
and genereI lst =
  let rec genereS lst = let aT,lT = genereT lst in
    match lT with
      | "+"::xs -> let aS,lS = genereS xs in IS(aT, aS), lS
      | _ -> aT, lT
  and genereT lst = let aF,lF = genereF lst in
    match lF with
      | "*"::xs -> let aT,lT = genereT xs in IT(aF, aT), lT
      | _ -> aF, lF
  and genereF lst = match lst with 
    | [] -> raise (SyntaxError(I_e, "F syntax error (empty !)"))
    | "("::r -> let aS,lr = genereS r in begin
      match lr with
        | ")"::r -> IF(aS), r
        | _ -> raise (SyntaxErrorExtended(I_e, "F syntax error )", lr))
      end
    | x::xs -> IA(int_of_string x), xs
    in genereS lst;;

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

let rec interpret arbre = let memory = Array.make 256 0 in
  match arbre with
  | Ec(a1,a2,a3) -> if (interpretC a1) then interpret a2 else interpret a3
  | Eps(a1,a2,a3) -> let a = interpret a2 in memory.(interpretI a1) <- a; interpret a3
  | Epg(a1) -> memory.(interpretI a1)
  | I(a) -> failwith "syntax error I not existing"
  | IS(a1,a2) -> interpret a1 + interpret a2
  | IT(a1,a2) -> interpret a1 * interpret a2
  | IF(a) -> interpret a
  | IA(a) -> a
  | _ -> raise (SyntaxError(I_e, "interpret error"))
  and 
  interpretC arbre = match arbre with
  | C(a) -> a
  | CEq(a1,a2) -> if (interpret a1) = (interpret a2) then true else false
  | Cnand(a1,a2) -> if (interpretC a1) && (interpretC a2) then false else true
  | _ -> raise (SyntaxError(C_e, "interpretC error"))
  and 
  interpretI arbre = match arbre with
  | I(a) -> failwith "syntax error I not existing 2"
  | _ -> raise (SyntaxError(I_e, "interpretI error"));;

(* écriture du code ASM *)


let incr c = c:= !c + 1;;

(* on suppose qu'on a à la fin un label "fin"*)
(* on suppose que la mémoire est accessible par le label "partie"*)

(*type arbre = 
  | Ec of arbre * arbre * arbre 
  | Eb of arbre * arbre * arbre
  | Eps of arbre * arbre * arbre
  | Epg of arbre
  | Ei of arbre (*unsued*)
  | Ua of arbre * arbre
  | U
  | I of arbre
  | IS of arbre * arbre
  | IT of arbre * arbre
  | IF of arbre 
  | IA of int
  | C of bool 
  | CEq of arbre * arbre
  | Cnand of arbre * arbre;;
*)
let rec genere_asm arbre out (cond_label:int) = 
  match arbre with 
  | Ec(a1,a2,a3) -> genere_asm a1 out (cond_label+1);
                    output_string out "cmp rax, 1\n";
                    output_string out ("je cond_vrai_" ^ (string_of_int cond_label) ^ "\n");
                    output_string out ("jmp cond_faux_" ^ (string_of_int cond_label) ^ "\n");
                    output_string out ("cond_vrai_" ^ (string_of_int cond_label) ^ ":\n");
                    genere_asm a2 out (cond_label+1);
                    output_string out ("jmp fin_if_" ^ (string_of_int cond_label) ^ "\n");
                    output_string out ("cond_faux_" ^ (string_of_int cond_label) ^ ":\n");
                    genere_asm a3 out (cond_label+1);
                    output_string out ("jmp fin_if_" ^ (string_of_int cond_label) ^ "\n");
                    output_string out ("fin_if_" ^ (string_of_int cond_label) ^ ":\n");

  | IA(a) -> output_string out ("mov rax, " ^ (string_of_int a) ^ "\n");
  | IS(a1,a2) -> genere_asm a1 out (cond_label+1);
                 output_string out "push rax\n";
                 genere_asm a2 out (cond_label+1);
                 output_string out "pop rbx\n";
                 output_string out "add rax, rbx\n";
  | IT(a1,a2) -> genere_asm a1 out (cond_label+1);
                  output_string out "push rax\n";
                  genere_asm a2 out (cond_label+1);
                  output_string out "pop rbx\n";
                  output_string out "imul rax, rbx\n";
  | IF(a) -> genere_asm a out (cond_label+1);
  | C(a) -> output_string out ("mov rax, " ^ (if a then "1" else "0") ^ "\n");
  | CEq(a1, a2) -> genere_asm a1 out (cond_label+1);
                   output_string out "push rax\n";
                   genere_asm a2 out (cond_label+1);
                   output_string out "pop rbx\n";
                   output_string out "cmp rax, rbx\n";
                   output_string out ("je cond_eq_vrai_" ^ (string_of_int cond_label) ^ "\n");
                  output_string out "mov rax, 0\n";
                  output_string out ("jmp fin_eq" ^ (string_of_int cond_label) ^ "\n");
                  output_string out ("cond_eq_vrai_" ^ (string_of_int cond_label) ^ ":\n");
                  output_string out "mov rax, 1\n";
                  output_string out ("jmp fin_eq" ^ (string_of_int cond_label) ^ "\n");
                  output_string out ("fin_eq" ^ (string_of_int cond_label) ^ ":\n");
  | Cnand(a1, a2) -> genere_asm a1 out (cond_label+1);
                      output_string out "push rax\n";
                      genere_asm a2 out (cond_label+1);
                      output_string out "pop rbx\n";
                      output_string out "and rax, rbx\n";
                      output_string out "not rax\n";
  | Epg(a) -> genere_asm a out (cond_label+1);
              output_string out "mov rax, [memory+rax]\n";
  | Eps(a1,a2,a3) -> genere_asm a1 out (cond_label+1);
                  output_string out "push rax\n";
                  genere_asm a2 out (cond_label+1);
                  output_string out "pop rbx\n";
                  output_string out "mov [memory+rbx], rax\n";
                  genere_asm a3 out (cond_label+1);
  | Eb(a1,a2,a3) -> output_string out ("debut_while_" ^ (string_of_int cond_label) ^ ":\n");
                    genere_asm a2 out (cond_label+1);
                    output_string out ("debut_condition_while_" ^ (string_of_int cond_label) ^ ":\n");
                    genere_asm a1 out (cond_label+1);
                    output_string out "cmp rax, 1\n";
                    output_string out ("jne fin_while_" ^ (string_of_int cond_label) ^ "\n");
                    output_string out ("jmp debut_while_" ^ (string_of_int cond_label) ^ "\n");
                    output_string out ("fin_while_" ^ (string_of_int cond_label) ^ ":\n");
                    genere_asm a3 out (cond_label+1);
                    
                  
  | _ -> raise (SyntaxError(I_e, "interpret error"));;

let compile str nom = 
  let arbre = genere str in
  let out = open_out (nom^".asm") in
  output_string out "[BITS 64]\n";

  output_string out "section .data\n";
  output_string out "msg db \"Debug: debut data \", 0ah\n";
  output_string out "memory times 512 db 0\n";

  output_string out "section .text\n";
  output_string out "global _start\n";
  output_string out "_start:\n";
  output_string out "xor rax, rax\n";

  genere_asm arbre out 0;

  output_string out "fin:\n";
  output_string out "mov rdi, rax\n"; (*on return la valeur de rax, pour la production on devra juste laisser rax comme il l'est*)
  output_string out "mov rax, 60\n";
  output_string out "syscall\n";
  close_out out;;




(* todo add while loop !!!*)