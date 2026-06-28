; 32-bit Linux assembly
        global  _start

        section .text
_start: mov     eax, 4          ; write system call
        mov     ebx, 1          ; output to stdout
        mov     ecx, msg        ; move address of msg into ecx register
        mov     edx, msglen     ; move number of characters in message into edx register
        int     0x80            ; interrupts the CPU to allow the kernel to process system call

        mov     eax, 3          ; system read
        mov     ebx, 0          ; stdin
        mov     ecx, age
        mov     edx, 4          ; maximum bytes to read
        int     0x80
        
        mov     esi, age        ; point source index to num start
        mov     ecx, 0          ; initialise value for age
        
_loop:  movzx   eax, byte [esi] ; moves the byte at esi into eax

        cmp     al, 0x0A        ; check the lowest byte of eax (al) for the newline char (end of input)
        je      _end_loop
        cmp     al, '0'         ; compare start of ASCII 0-9
        jl      _invalid_input
        cmp     al, '9'         ; compare end of ASCII 0-9
        jg      _invalid_input
        cmp     al, 0
        je      _end_loop
        
        sub     al, '0'         ; convert ASCII to numeric value
        imul    ecx, ecx, 10    ; shift up current digit
        add     ecx, eax        ; add new digit to value
        
        inc     esi             ; step to next input char
        jmp     _loop
        
_end_loop:

_compare:
        cmp     ecx, 19
        jl      _invalid_input
        cmp     ecx, 42
        jg      _invalid_input
        
        cmp     ecx, 25
        jbe     _young_adult
        
        cmp     ecx, 35
        jbe     _adult
        
        jmp     _mature_adult
        
_young_adult:
        mov     eax, 4          ; write system call
        mov     ebx, 1          ; output to stdout
        mov     ecx, msg_young        ; move address of msg into ecx register
        mov     edx, msgylen     ; move number of characters in message into edx register
        int     0x80
        jmp     _exit
       
_adult:
        mov     eax, 4          ; write system call
        mov     ebx, 1          ; output to stdout
        mov     ecx, msg_adult       ; move address of msg into ecx register
        mov     edx, msgalen     ; move number of characters in message into edx register
        int     0x80
        jmp     _exit
       
_mature_adult:
        mov     eax, 4          ; write system call
        mov     ebx, 1          ; output to stdout
        mov     ecx, msg_mature       ; move address of msg into ecx register
        mov     edx, msgmlen     ; move number of characters in message into edx register
        int     0x80
        jmp     _exit
       
_invalid_input:
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, err
        mov     edx, errlen
        int     0x80
         
_exit:  mov     eax, 1          ; system exit
        int     0x80

        section .data
msg:    db      "Enter age:"    ; stores the message
msglen: equ     $ - msg         ; length of message
err:    db      "Invalid input"
errlen: equ     $ - err


msg_young:      db "Life Stage: Young Adult (19-25)", 10, 0
msgylen:        equ     $ - msg_young
msg_adult:      db "Life Stage: Adult (26-35)", 10, 0
msgalen:        equ     $ - msg_adult
msg_mature:     db "Life Stage: Mature Adult (36-42)", 10, 0
msgmlen:        equ     $ - msg_mature

        section .bss
age:    resb    4               ; reserve memory for age
