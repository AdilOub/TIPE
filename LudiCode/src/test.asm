[BITS 64]
section .data
section .text
global _start
_start:
xor rax, rax
mov rax, 1
push rax
mov rax, 1
pop rbx
cmp rax, rbx
je cond_eq_vrai_1
mov rax, 0
jmp fin_eq1
cond_eq_vrai_1:
mov rax, 1
jmp fin_eq1
fin_eq1:
cmp rax, 1
je cond_vrai_0
jmp cond_faux_0
cond_vrai_0:
mov rax, 69
jmp fin
cond_faux_0:
mov rax, 12
jmp fin
fin:
mov rdi, rax
mov rax, 60
syscall
