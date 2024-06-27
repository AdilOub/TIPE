[BITS 64]
section .data
msg db "Debug: debut data ", 0ah
memory times 512 db 0
section .text
global _start
_start:
xor rax, rax
debut_while_0:
mov rax, 0
debut_condition_while_0:
mov rax, 0
cmp rax, 1
jne fin_while_0
jmp debut_while_0
fin_while_0:
mov rax, 1
fin:
mov rdi, rax
mov rax, 60
syscall
