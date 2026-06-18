default rel

section .data
    intro_msg db "Hello Group! My name is Flavian Cocosila and I am excited to work with you on this Computer Systems project.", 10, 0

section .text
    global main
    extern printf
    extern exit

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32         ; Shadow space

    lea rcx, [intro_msg]
    call printf

    xor ecx, ecx
    call exit