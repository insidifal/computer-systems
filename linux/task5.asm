; 32-bit Linux assembly
        global  _start
        
        section .text
_start: mov     eax, 100
        sub     eax, [decrease_pct]
        mul     eax, [current_female]

        xor     edx, edx    ; clear edx for division
        mov     ecx, 100    ; divide by 100 for percentage
        div     ecx         ; eax divide by ecx
        
        mov     edi, buffer_end
        dec     edi                     ; point to next position in buffer
        
_loop:  ; convert to ASCII
        xor     edx, edx    ; clear edx
        mov     ecx, 10
        div     ecx         ; eax divide by ecx
        
        add     dl, '0'     ; lowest byte of edx convert to ASCII
        mov     [edi], dl   ; store ASCII in buffer
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
        sub     edx, edi        ; edx = buffer_end - start (calculates exact character count)
        int     0x80            ; interrupts the CPU to allow the kernel to process system call
        
_exit:  mov     eax, 1          ; system exit
        int     0x80

        section .data
current_female: dd      60
decrease_pct:   dd      12

msg:            db      "Answer: "
msglen: equ     $ - msg         ; length of message

        section .bss
buffer:         resb    12          ; Reserve 12 bytes for the number and newline
buffer_end:
