bits 64
default rel

section .data
    prompt         db "Enter project group letter (A-F): ", 0
    format_in      db " %c", 0   ; The space before %c skips any leftover newlines
    
    ; Array of student counts aligned to 'A', 'B', 'C', 'D', 'E', 'F'
    student_counts dd 60, 98, 59, 43, 15, 57
    
    fmt_out        db "Group %c has %d mini-groups (Remaining students assigned: %d)", 10, 0
    msg_error      db "Error: Invalid group letter. Please use A, B, C, D, E, or F.", 10, 0
    divisor        dd 3

section .bss
    group_input    resb 1        ; Reserve 1 byte for user's character input

section .text
    global main
    extern printf
    extern scanf
    extern exit

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; 1. Prompt User
    lea rcx, [prompt]
    call printf

    ; 2. Read Character Input
    lea rcx, [format_in]
    lea rdx, [group_input]
    call scanf

    ; 3. Convert Character to Array Index
    movzx eax, byte [group_input] ; Load input character (e.g., 'A' is ASCII 65)
    
    ; Check lower bounds (ASCII 'A' = 65)
    cmp eax, 65
    jl .invalid
    ; Check upper bounds (ASCII 'F' = 70)
    cmp eax, 70
    jg .invalid

    ; Calculate index: Index = Input - 'A'
    sub eax, 65                  ; 'A' becomes 0, 'B' becomes 1, etc.

    ; 4. Load Student Count from Array
    lea rdx, [student_counts]
    mov eax, [rdx + rax * 4]     ; Multiply index by 4 (dd = 4 bytes)

    ; 5. Divide Student Count by 3
    xor edx, edx                 ; Clear EDX for division
    mov ecx, [divisor]
    div ecx                      ; EAX = mini-groups, EDX = leftover students

    ; 6. Print the Result
    ; Save variables to stack temporarily because printf overwrites volatile registers
    push rdx                     ; Save Remainder
    push rax                     ; Save Quotient

    lea rcx, [fmt_out]           ; 1st Arg: Format string
    movzx rdx, byte [group_input]; 2nd Arg: The character they typed
    mov r8, [rsp]                ; 3rd Arg: Quotient (mini-groups)
    mov r9, [rsp + 8]            ; 4th Arg: Remainder (leftovers)
    call printf
    
    add rsp, 16                  ; Clean up the two pushed values
    jmp .done

.invalid:
    lea rcx, [msg_error]
    call printf

.done:
    xor ecx, ecx
    call exit
