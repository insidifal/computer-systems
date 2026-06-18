default rel

section .data
    current_female dd 60
    current_pct    dd 88        ; 100% - 12% = 88%
    multiplier     dd 100
    fmt_out        db "Female students enrolled last year: %d", 10, 0

section .text
    global main
    extern printf
    extern exit

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; Calculate: (60 * 100) / 88
    mov eax, [current_female]
    mul dword [multiplier]     ; EDX:EAX = 6000
    
    mov ecx, [current_pct]
    div ecx                    ; EAX = 6000 / 88 = 68

    ; Print result
    lea rcx, [fmt_out]
    mov edx, eax               ; Pass result to printf
    call printf

    xor ecx, ecx
    call exit