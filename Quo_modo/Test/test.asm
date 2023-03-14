section .bss
    string resb 10
    longStr equ $-string

section .text
    global _start
_start:
    mov rax, 123        ; integer to convert
    mov rbx, 10          ; base 10
    mov rcx, string         ; pointer to the output string
.while_loop:
    xor rdx, rdx         ; clear edx to use as quotient
    div rbx            ; divide by 10
    add rdx, '0'         ; convert remainder to ASCII digit
    mov [rcx], dl        ; store digit in output string
    inc rcx              ; move to next character in string
    cmp rax, 0           ; check if quotient is zero
    jne .while_loop      ; if not, continue loop
    mov rax, 4           ; system call to print string to stdout
    mov rbx, 1           ; file descriptor for stdout
    mov rcx, string        ; pointer to string to print
    mov rdx, 3           ; number of bytes to print
    int 0x80             ; call kernel to print string
    mov rax, 1           ; system call to exit program
    xor rbx, rbx         ; exit with return code 0
    int 0x80             ; call kernel to exit program

