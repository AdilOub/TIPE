global _start ;on défini la fonction _start, c'est une directive ASM
_start: ;point d'entré
    mov rdi, 12 ;on met la valeur de retour dans le registre rdi
    mov rax, 60 ;on met la valeur qui correspond au code "exit" dans rax
    syscall ;on utilise un appel système qui va lancer un interrupt et terminer le programme