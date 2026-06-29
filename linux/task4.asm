; 32-bit Linux assembly
        global  _start
        
        section .text
_start: mov     esi, group_A    ; point to start of memory address
        mov     [current_group], byte 'A'
        
_loop1:
        mov     eax, [esi]  ; put value into accumulator

        xor     edx, edx    ; clear edx for division
        mov     ecx, 3      ; dividing by 3 per group
        div     ecx         ; eax divide by ecx
        
        ; check for remainder
        test    edx, edx
        jz      _fill_buffer
        inc     eax
        
_fill_buffer:
        mov     edi, buffer_end
        dec     edi                     ; point to next position in buffer
    
_newline:
        mov     [edi], byte 10
        dec     edi
        
_loop2:  ; convert to ASCII
        xor     edx, edx    ; clear edx
        mov     ecx, 10
        div     ecx         ; eax divide by ecx
        
        add     dl, '0'     ; lowest byte of edx convert to ASCII
        mov     [edi], dl   ; store ASCII in buffer
        dec     edi         ; point to next position in buffer
        
        test    eax, eax    ; check equals 0
        jnz     _loop2
        
        inc     edi         ; move pointer back to the start of the answer
        
_print: ; update letter
        mov     al, [current_group]
        mov     [msg_letter], al

        mov     eax, 4          ; write system call
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
        
_next_group:
        add     esi, 4                      ; next 4 byte integer
        inc     byte [current_group]        ; next letter
        cmp     byte [current_group], 'F'   ; check if done
        jbe     _loop1
        
_exit:  mov     eax, 1          ; system exit
        int     0x80

        section .data
group_A:        dd      60
group_B:        dd      98
group_C:        dd      59
group_D:        dd      43
group_E:        dd      15
group_F:        dd      57
msg:            db      "Mini groups in group "
msg_letter:     db      "A: "
msglen: equ     $ - msg         ; length of message

        section .bss
current_group:  resb    1
buffer:         resb    12          ; Reserve 12 bytes for the number and newline
buffer_end:
