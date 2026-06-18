default rel

section .data
    prompt    db "Enter your age (19-42): ", 0
    format_in db "%d", 0
    
    msg_young  db "Life Stage: Young Adult (19-25)", 10, 0
    msg_adult  db "Life Stage: Adult (26-35)", 10, 0
    msg_mature db "Life Stage: Mature Adult (36-42)", 10, 0
    msg_invalid db "Error: Age out of scope for this cohort.", 10, 0

section .bss
    age resd 1          ; Reserve 4 bytes for integer age

section .text
    global main
    extern printf
    extern scanf
    extern exit

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; Prompt User
    lea rcx, [prompt]
    call printf

    ; Read Integer Input
    lea rcx, [format_in]
    lea rdx, [age]
    call scanf

    ; Load age into EAX for comparison
    mov eax, [age]

    ; Check Bounds (19-42)
    cmp eax, 19
    jl .invalid
    cmp eax, 42
    jg .invalid

    ; Selection Logic
    cmp eax, 25
    jbe .young_adult    ; If age <= 25

    cmp eax, 35
    jbe .adult          ; If age <= 35

    jmp .mature_adult   ; If age > 35 (and <= 42)

.young_adult:
    lea rcx, [msg_young]
    call printf
    jmp .done

.adult:
    lea rcx, [msg_adult]
    call printf
    jmp .done

.mature_adult:
    lea rcx, [msg_mature]
    call printf
    jmp .done

.invalid:
    lea rcx, [msg_invalid]
    call printf

.done:
    xor ecx, ecx
    call exit