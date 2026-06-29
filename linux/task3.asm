; 32-bit Linux assembly
        global  _start
        extern printf

        section .text
_start: mov     eax, [total_students]
        sub     eax, [pg_students]      ; answer is in the accumulator eax
        
        mov     edi, buffer_end
        dec     edi                     ; point to next position in buffer
        
_loop:  ; convert to ASCII
        xor     edx, edx    ; clear edx
        mov     ecx, 10
        div     ecx         ; eax divide by ecx
        
        add     dl, '0'     ; lowest byte of edx convert to ASCII
        mov     edi, dl     ; store ASCII in buffer
        dec     edi         ; point to next position in buffer
        
        test    eax, eax    ; check equals 0
        jnz     _loop
        
        inc     edi         ; move pointer back to the start of the answer
        
_print: mov     eax, 4          ; write system call
        mov     ebx, 1          ; output to stdout
        mov     ecx, msg        ; move address of msg into ecx register
        mov     edx, msglen     ; move number of characters in message into edx register
        int     0x80            ; interrupts the CPU to allow the kernel to process system call
        
        mov     eax, 4          ; write system call
        mov     ebx, 1          ; output to stdout
        mov     ecx, edi        ; start of the ASCII answer
        mov     edx, buffer_end ; end of the ASCII answer
        int     0x80            ; interrupts the CPU to allow the kernel to process system call
        
_exit:  mov     eax, 1          ; system exit
        int     0x80

        section .data
total_students: dd      290
pg_students:    dd      75
msg:            db      "Total number of UG students: "
msglen: equ     $ - msg         ; length of message

        section .bss
buffer:         resb    12          ; Reserve 12 bytes for the number and newline
buffer_end:
