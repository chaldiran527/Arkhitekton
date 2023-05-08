;===========================================================
;Programa que ordena alfabeticamente una palabra en un archivo de texto 
;Autores:
;       Carlos Dario
;       Juan Mallma 
;===========================================================

%include "Procs&macros.asm"


    contarPalabras:
        xor rcx,rcx ;Contador rcx se inicializa en cero 
        cmp byte[rsi],10;Se verifica si el caracter es el newline del final
        je .finContarPalabras

        cmp byte[rsi],32;Se verifica si el caracter es espacio
        je .loopEspacios


        inc rcx;Se incrementa el contador de palabras 
        jmp .loopPalabras;Se salta al ciclo de contar palabra

    .loopPalabras:
        inc rsi;Se incrementa la posicion actual del registro de la palabra
        cmp byte[rsi],10;Se verifica si el caracter es el newline del final
        je .finContarPalabras

        cmp byte[rsi],32;Se verifica si el caracter es espacio
        je .loopEspacios

        jmp .loopPalabras;Se salta de vuelta al label de palabras pues no se ha terminado de recorrer la palabra actual

    .ordenarEspacio:
        jmp .loopEspacios 

    .ordenarFin:
        jmp .finContarPalabras

    .loopEspacios:
        inc rsi;Se incrementa la posicion actual del registro de la palabra

        cmp byte[rsi],10
        je .finContarPalabras

        cmp byte[rsi],32
        je .loopEspacios
        ;
        inc rcx;Se incrementa el contador de palabras 
        jmp .loopPalabras

    .finContarPalabras:;Se finaliza este procedimiento ya no hay mas caracteres que contar
        ret


section .data 
    string db 'cabdizajaf',10
    len equ $-string  
    newLine db 0xA
    longNewLine equ $-newLine
    msjError db 'Error!',0
    longMsjError equ $-msjError
    hilera1 db 'This is a test string',10

    

section .bss 
    ingre resb 100
    lenIngre equ $-ingre
    caracter resb 100
    longCaracter equ $-caracter 
    palabra resb 100
    longPalabra equ $-palabra 
    buff resb 256
    numPalabrasInt resb 100
    longNumPalabrasInt equ $-numPalabrasInt
    numPalabras resb 100
    longNumPalabras equ $-numPalabras
  

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
    ;print ingre,lenIngre
    ret


ordenarPalabras:
    mov rbx,rsi 
    mov rdi,rcx 

.loopPalabras: 
    dec rdi 
    cmp rdi,0 
    jle .finOrdenarPalabras 

    mov rcx, rdi  
    mov rsi, rbx 
    call ordenarPalabra 

    add rbx,rcx ;Mover rbx al inicio de la siguiente palabra
    jmp .loopPalabras 

.finOrdenarPalabras:
    ret 

_start:
    mov rsi,string 
    mov rcx,len 
    call ordenarPalabras 
    print string,len 


    mov rsi,string
    call contarPalabras
    mov [numPalabras],rcx

    mov rax, [numPalabras]           ;Se mueve a rax el numero a convertir de la multiplicacion
    mov rbx, 10
    xor rcx,rcx
    mov rcx, numPalabrasInt          ;Se almacena el resultado de la conversion e
    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

    mov rsi, numPalabrasInt         ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido

    print numPalabrasInt,longNumPalabrasInt
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

