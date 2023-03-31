%include "tarea.asm"

;Macro para recibir un input desde consola con 1 parametro(%1 de la hilera que almacenara el input)
    %macro input 2
        mov rdx, %2
        mov rcx, %1
        mov rbx, 0
        mov rax, 3
        int 0x80
    %endmacro

    baseConvert:
        ;xor ecx,ecx
        jmp .divide_loop

    .divide_loop:
        xor edx, edx
        div ebx
        cmp edx, 10
        jl .digit
        add edx, 'A' - 10
        jmp .store_digit

    .digit:
        add edx,'0'
        jmp .store_digit

    .store_digit:
        mov byte [ecx], dl
        inc ecx
        cmp eax, 0
        jnz .divide_loop   

    .endBaseConvert:
        mov byte[ecx],0
        ret

section .data
    inputA: dd 1000
    msj1 db 'Ingrese el primer numero: '
    longMsj1 equ $ - msj1
    msj2 db 0xA,'Ingrese el segundo numero: '
    longMsj2 equ $ - msj2
    newLine db 0xA;Nuevalinea para separar las hileras a mostrar en la consola
    longNewLine equ $ - newLine
    msjSuma db '   Suma: ',0
    longMsjSuma equ $ - msjSuma
    msjBase db 'Base ',0
    longMsjBase equ $-msjBase
    msjDif db '   Diferencia: ',0
    longMsjDif equ $-msjDif
    msjGeneral db 'A continuacion se muestran la suma y diferencia de estos dos numeros en orden ascendente desde base 2 hasta base 16:'
    longMsjGeneral equ $-msjGeneral

section .bss
    result1 resb 100
    lenResult1 equ $-result1
    result2 resb 100
    lenResult2 equ $-result2
    resultSuma resb 100
    longResultSuma equ $-resultSuma
    resultDif resb 100
    longResultDif equ $-resultDif
    num1 resb 100
    longNum1 equ $-num1
    num2 resb 100
    longNum2 equ $-num2
    lenNumero1 resb 100;
    longLenNumero1 equ $-lenNumero1
;lenNumero2 almacena la cantidad de digitos del numero2
    lenNumero2 resb 100;
    longLenNumero2 equ $-lenNumero2
    numInt1 resb 100
    longNumInt1 equ $-numInt1
    numInt2 resb 100
    longNumInt2 equ $-numInt2
;numSuma almacena la suma de los dos numeros ingresados
    numSuma resb 100
    longNumSuma equ $-numSuma
;numDif almacena la diferencia de los dos numeros ingresados 
    numDif resd 100
    longNumDif equ $-numDif
    caracter resb 100
    longCaracter equ $-caracter

section .text
    global _start
    
_start:
    print msj1,longMsj1
    input num1, longNum1
        ;Se verifica si el primer numero ingresado es menor a 20 digitos 
    mov rdi, num1   ;rdi es el parametro 
    call lenHilera  ;rax almacena el resultado
    cmp rax,20      ;En caso de ser mayor a 20 se salta al error
    ja _error
    mov [lenNumero1],rax
    
    ;===Se ejecuta  el proc de atoi de num1 
    mov rsi,num1;Se mueve a rsi el string numerico ingresado por el input, parametro para el procedimiento 
    call Atoi
    mov [numInt1], rax   ;Se guarda el resultado post Atoi en numInt1

    print msj2, longMsj2
    input num2, longNum2

    ;Se verifica si el segundo numero ingresado es menor a 20 digitos 
    mov rdi, num2   ;rdi es el parametro 
    call lenHilera  
    cmp rax,20      ;En caso de ser mayor a 20 se salta al error
    ja _error
    mov [lenNumero2],rax

    ;===Se ejecuta  el proc de atoi de num2
    mov rsi,num2;
    call Atoi
    mov [numInt2], rax ;Se guarda el resultado post Atoi en numInt2


    ;===Se ejecuta el proc de suma y resta de los dos numeros enteros
    mov rax,[numInt1]
    mov rbx,[numInt2]
    call calcSuma       
    mov [numSuma],rax ;rax tiene resultado

    mov rax,[numInt1]
    mov rbx,[numInt2]
    call calcDif        
    mov [numDif],rax ;rax tiene resultado

    ;Se imprime el mensaje describiendo las conversiones de bases a mostrar en la pantalla
    print newLine,longNewLine
    print msjGeneral,longMsjGeneral
    print newLine,longNewLine

    mov r13,2 ;contador de la base actual a convertir

    _loopConversion:
        print newLine,longNewLine
        print msjSuma,longMsjSuma

        mov eax, [numSuma]  ;Se mueve a eax el numero a convertir de la suma
        mov rbx, r13
        xor ecx,ecx         ;Se mueve a eax el numero a convertir de la diferencia
        mov ecx, resultSuma ;Se almacena el resultado de la conversion en resultSuma
        call baseConvert    ;Se llama al procedure para convertir a la base actual en r13

        mov rsi, resultSuma ;rsi va como parametro 
        call hileraInvertida      ;Se invierte la hilera con el string del numero convertido
        print resultSuma,longResultSuma  ;Se imprime el numero post conversion

       ;Se reinicializa en cero con 100 bytes a la variable resultSuma
        mov rbx,resultSuma
        mov rcx,100
        xor rax,rax
        rep stosb 

        print msjDif,longMsjDif     ;Se imprime el mensaje de Diferencia:

        mov eax, [numDif]           ;Se mueve a eax el numero a convertir de la diferencia
        mov rbx, r13
        xor ecx,ecx
        mov ecx, resultDif          ;Se almacena el resultado de la conversion en resultDif
        call baseConvert            ;Se llama al procedure para convertir a la base actual en r13

        mov rsi, resultDif          ;rsi va como parametro 
        call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
        print resultDif,longResultDif ;Se imprime el numero post conversion


      ;Se reinicializa en cero con 100 bytes a la variable resultDif
        mov rbx,resultDif
        mov rcx,100
        xor rax,rax
        rep stosb 

        print newLine,longNewLine

        inc r13         ;Se incrementa el contador de la base n  a convertir
        cmp r13,16      ;Se compara si r13 es mayor que 16
        ja _exit        ;Salir del programa en caso de ser mayor

        jmp _loopConversion     ;Repetir el ciclo de conversion 