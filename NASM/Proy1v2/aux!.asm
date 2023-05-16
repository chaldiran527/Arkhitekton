;===========================================================
;Programa que calcula la suma y la diferencia de dos numeros ingresados desde el teclado 
;Autores:
;		Carlos Dario
;		Juan Mallma 
;===========================================================

;Macros a ser usados en este programa 

;Macro para imprimir mensaje con 2 parametros(%1 de hilera,%2 de longitud de la hilera)
    %macro print 2
        mov rax, 4
        mov rbx, 1
        mov rcx, %1
        mov rdx, %2
        int 0x80
    %endmacro

section .data
    input_string db '3 + x, x=21',0
    output_string db '3 + ', 0
    result_string db 16   ; Buffer to store the result as a string
    result_length equ $-result_string   ; Length of the result string

section .text
    global _start

_start:
    ; Find the position of 'x=' in the input string
    mov esi, input_string
    mov ecx, result_length
    cld
    repne scasb
    jne exit_program

    ; Skip 'x=' and extract the value of x
    mov esi, ecx
    xor eax, eax
    mov ebx, 10    ; Base 10 for converting the ASCII value to decimal
    extract_x:
        lodsb
        cmp al, 0
        je exit_program
        cmp al, '0'
        jb exit_program
        cmp al, '9'
        ja exit_program
        sub al, '0'
        mul ebx
        add eax, edx
        jmp extract_x

exit_program:
    ; Convert the value of x to a string
    add eax, '0'
    mov ecx, result_length
    mov edi, result_string
    std
    convert_to_string:
        xor edx, edx
        div ebx
        add dl, '0'
        dec ecx
        mov [edi+ecx], dl
        test eax, eax
        jnz convert_to_string

    ; Append the converted value of x to the output string
    mov esi, output_string
    mov ecx, result_length
    mov edi, ecx
    rep movsb

    ; Print the output string
    mov eax, 4
    mov ebx, 1
    mov ecx, output_string
    mov edx, result_length
    int 0x80

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
