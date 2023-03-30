%include "tarea.asm"

section .data
    output: db "Number in base 4: ", 0
    digits: db "0123"
    input: dd 412
    newLine db 0xA,'',0xA,0xA
    longNewLine equ $-newLine

section .bss
    result resb 20
    lenResult equ $-result
    
section .text
    global _start
    
_start:
    mov eax, [input]
    mov ebx, 2
    mov ecx, result
    
    mov edx, 0
    divide_loop:
        xor edx, edx
        div ebx
        add edx, '0'
        mov byte [ecx], dl
        inc ecx
        cmp eax, 0
        jnz divide_loop
    
    mov byte [ecx], 0
    
    ; reverse the string in result
    mov ecx, result
    mov ebx, ecx
    dec ebx
    reverse_loop:
        cmp ecx, ebx
        jge done_reversing
        mov al, [ecx]
        mov ah, [ebx]
        mov [ecx], ah
        mov [ebx], al
        inc ecx
        dec ebx
        jmp reverse_loop
    done_reversing:
    
    ; print the output string
    mov eax,4
    mov ebx,1
    mov ecx,result
    mov edx,lenResult
    int 0x80
    
    ; print the converted number string
    mov ecx, result
    mov edx, ecx
    count_digits:
        cmp byte [edx], 0
        je done_counting
        inc edx
        jmp count_digits
        
    
    done_counting:
        sub edx, result

    mov eax,4
    mov ebx,1
    mov ecx,output
    mov ebx,19
    int 0x80
    
    mov eax, 1
    xor ebx, ebx
    int 0x80
