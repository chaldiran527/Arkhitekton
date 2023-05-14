;===========================================================
;Programa que calcula la suma y la diferencia de dos numeros ingresados desde el teclado 
;Autores:
;		Carlos Dario
;		Juan Mallma 
;===========================================================

;Macros a ser usados en este programa 

section .data
    input db '2', 0 ; input infix expression

section .bss
    stack resb 100  ; stack for operators
    output resb 100  ; output buffer for postfix expression

section .text
    global _start

_start:
    ; Initialize registers
    mov ebx, input ; ebx points to the input string
    mov ecx, output ; ecx points to the output buffer
    mov edx, stack ; edx points to the stack

    ; Call the conversion function
    call infix_to_postfix

    ; Terminate program
    mov eax, 1 ; exit system call
    xor ebx, ebx ; return value
    int 0x80 ; execute system call

infix_to_postfix:
    ; Initialize registers
    xor eax, eax ; eax = 0 (stack pointer)
    xor ebx, ebx ; ebx = 0 (output buffer pointer)

    ; Loop through each character in the input string
    .loop:
        mov al, byte [ebx + input] ; load next character
        cmp al, 0 ; end of string?
        je .done

        ; If character is a digit, copy it to output buffer
        cmp al, '0'
        jb .operator
        cmp al, '9'
        ja .operator
        mov byte [ecx + edx], al
        inc edx
        jmp .next

    .operator:
        ; If character is an operator, push it onto stack
        cmp al, '('
        je .push
        cmp al, ')'
        je .pop
        mov byte [eax + edx], al
        inc eax
        jmp .next

    .push:
        mov byte [eax + edx], al
        inc eax
        jmp .next

    .pop:
        dec eax
        .pop_loop:
            mov bl, byte [eax + edx]
            cmp bl, '('
            je .next
            mov byte [ecx + edx], bl
            inc edx
            dec eax
        jmp .pop_loop

    .next:
        inc ebx
        jmp .loop

    .done:
        ; Pop remaining operators from stack
        .pop_remaining:
            dec eax
            cmp eax, -1
            je .finish
            mov bl, byte [eax + edx]
            mov byte [ecx + edx], bl
            inc edx
            jmp .pop_remaining

        .finish:
            ; Null terminate output buffer
            mov byte [ecx + edx], 0
            ret
