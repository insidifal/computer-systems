; 32-bit Linux assembly
            global _start

            section .text
_start:     mov     ecx, msg    ; move address of H into ecx register
            mov     edx, len    ; move number of characters in message into edx register
            mov     ebx, 1      ; ebx = 1 instructs the system to output to stdout
            mov     eax, 4      ; eax = 4 instructs the system to use the write system call
            int     0x80        ; interrupts the CPU to allow the kernel to process system call

            mov     eax, 1      ; eax = 1 instructs the system to exit
            int     0x80        ; interrupts the CPU to allow the kernel to process system call

            section .data
msg:        db      "Hello, I am Joshua"   ; stores the message
len:        equ     $ - msg         ; calculates the number of characters in the message
