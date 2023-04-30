;===========================================================
;Programa que realiza y valida las operaciones basicas de suma,resta,multiplicacion y division
;Autores:
;       Carlos Dario
;       Juan Mallma 
;===========================================================

%include "Procs&macros.asm"



section .data 
    string db 'cabd',0
    len equ $-string  
    newLine db 0xA
    longNewLine equ $-newLine
    msjError db 'Error!',0
    longMsjError equ $-msjError
    hilera1 db 'This is a test string',0
    

section .bss 
    caracter resb 100
    longCaracter equ $-caracter 
    palabra resb 100
    longPalabra equ $-palabra 
    buff resb 256

section .text
    global _start


ordenarPalabra:
    mov rbx, rsi
    mov rdi, rcx 

    dec rdi 
    cmp rdi, 0 
    jle .finOrdenarPalabra
    jmp .loopOrdenamiento

.loopOrdenamiento:
    mov al, [rbx]
    cmp al, [rbx+1]
    jbe .sigCambio 

    mov dl,[rbx+1]
    mov [rbx+1],al 
    mov [rbx], dl 
    jmp .sigCambio
    

.sigCambio:
    inc rbx 
    dec rdi 
    cmp rdi, 0
    jg .loopOrdenamiento

    dec rcx 
    cmp rcx, 1
    jg ordenarPalabra
    jmp .finOrdenarPalabra

.finOrdenarPalabra:
    print string,len
    ret


_start:
    jmp _start2
    mov rsi,string
    mov rcx,len
    call ordenarPalabra
    jmp _exit

_start2:
    mov byte[buff],0
    mov rcx, hilera1 
    xor rdx,rdx 
    lea rsi,[buff]
   ; mov rsi,buff

_loop:
    cmp byte[rcx],0
    je _finito

    cmp byte[rcx], ' '
    je _skip_espacio    

   ; mov byte[buff+rdx], byte[rcx]
    inc rdx   
    movsb
;    mov byte[rsi+rdx-1],al
    jmp _sigCaracter 

_skip_espacio:
    cmp rdx,0
    je  _sigCaracter

    ;Hacer print directo o pasar a buffer palabra 
;;Cambios222
    ;sub rcx,rdx 
    print buff,rdx
    mov byte[buff+rdx],0
    xor rdx,rdx ;Contador vuelve a cero 

_sigCaracter:
    inc rcx 
    jmp _loop 

_finito:
    cmp rdx,0 
    je _exit 


;    sub rcx,rdx
 ;   print rcx,rdx
    print buff,rdx
    xor rdx,rdx

    jmp _exit

_error:;Seccion en donde se le indica al usuario que hubo un error
    print msjError,longMsjError;Se imprime el mensaje de error
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
    jmp _exit;Se salta a _exit para acabar el programa 


_errorOverflow:
    print msjError,longMsjError 
    print newLine, longNewLine
    jmp _exit 

_exit:;Se finaliza el programa
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola

    ;Llamada de salida
    mov rbx,0           ;RBX=codigo de salido al 80 
    mov rax,1           ;RAX=funcion sys_exit() del kernel llama al sistema 
    int 0x80            ;Llamada al sistema para acabar la ejecucion del programa

