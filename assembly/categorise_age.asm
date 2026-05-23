; 32-bit Linux assembly
        global  _start

        section .text
_start: mov     eax, 4          ; write system call
        mov     ebx, 1          ; output to stdout
        mov     ecx, msg        ; move address of msg into ecx register
        mov     edx, msglen        ; move number of characters in message into edx register
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

        section .bss
age:    resb    4               ; reserve memory for age
