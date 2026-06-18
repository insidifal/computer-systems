default rel

section .data
    total_students dd 290        ; 'dd' defines a 4-byte integer constant
    pg_students    dd 75         ; 'dd' defines a 4-byte integer constant
    fmt_out        db "Total number of UG students: %d", 10, 0

section .text
    global main
    extern printf
    extern exit

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; Perform calculation dynamically using memory references
    mov eax, [total_students]    ; Load 290 into EAX
    sub eax, [pg_students]       ; Subtract 75 from EAX (EAX = 215)

    ; Print Output
    lea rcx, [fmt_out]           ; 1st Argument: Format string
    mov edx, eax                 ; 2nd Argument: Computed UG count (215)
    call printf

    xor ecx, ecx
    call exit