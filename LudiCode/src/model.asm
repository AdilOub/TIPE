section .data
    msg db "On joue un coup ", 0ah
    info db 0

section .text
    global _start

_start:
    mov rax, 10
    mov [info], rax
    call loop
    

loop:
    ;on suppose que le coup est écrit en mémoire à l'adresse 0x100
    ask_loop:
    call est_legal
    cmp rbx, 1
    jne ask_loop
    call jouer_coup
    call fini
    cmp rbx, 1
    jne loop
    jmp end


demander_coup: ;ecrit un coup à l'adresse 0x100
    ;on s'en occupe pas
    ret
    
est_legal: ;ecrit dans rbx 1 si le coup (dans rax) est legal
    ;????
    mov rbx, 1
    ret

jouer_coup: ;joue le coup qui se situe à l'adresse 0x100
    ;????
    ;hello world
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 13
    syscall
    ret


fini: ;ecrit dans rbx 1 si la partie est fini
    ;????
    mov rbx, [info]
    cmp rbx, 0
    je stop
    dec rbx
    mov [info], rbx
    xor rbx, rbx
    ret
    stop:
    mov rbx, 1

end:
    ;return:
    mov rax, 60
    mov rdi, 0
    syscall