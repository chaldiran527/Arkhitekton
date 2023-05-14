;===========================================================
;Tarea programada 1 del curso de Arquitectura de computadoras.
;Profesor Eduardo Canessa
;Semestre 1-2023
;Programa que recibe una expresion ingresada por el usuario en notacion infija, la convierte a posfija y la evalua 
;Autores:
;       Carlos Dario
;       Alessandro Bolandi 
;       Juan Mallma 
;===========================================================
;Archivo .asm con los procedimientos y macros creados y usados por este grupo a lo largo del curso
%include "Procs&macros.asm" 

section .data
	msjMenu1 db 'Ingrese la expresion matematica a evaluar con los operadores + - * / ( ): ',0
	longMsjMenu1 equ $-msjMenu1
    newLine db 0xA;Nuevalinea para separar las hileras a mostrar en la consola
    longNewLine equ $ - newLine
    msjError db 0xA,'ERROR: Usted acaba de ingresar un numero invalido!',0xA
    longMsjError equ $ - msjError
    msjErrorOf db 'ERROR: Resultado de la suma supera los 64 bits, hay overflow!',0
    longMsjErrorOf equ $-msjErrorOf
    msjErrorInput db 'ERROR: Usted ingreso una opcion invalida, intente nuevamente.!',0
    longMsjErrorInput equ $-msjErrorInput
    msjContinuacion db 'Digite 1 si desea ejecutar el programa nuevamente',0
    longMsjContinuacion equ $-msjContinuacion
    msjSalida db 'Digite cualquier otra tecla si desea terminar el programa-> ',0
    longMsjSalida equ $-msjSalida
    signoNeg db '-',0
    longSignoNeg equ $-signoNeg
    msjPosfijo db 'Expresion convertida a posfijo es: ',0
    longMsjPosfijo equ $-msjPosfijo
    msjResult db 'Resultado final: ',0
    longMsjResult equ $-msjResult
    msj1 db 'Ingrese la expresion matematica a evaluar: '
    longMsj1 equ $-msj1
    ;expr db '5 4 2 + * 8 2 / -',10
;    posfijo db '-4 8 3 * +',10
;    longPosfijo equ $-posfijo
    pila    db 20 dup(0)     ;Pila para almacenar las variables
    ptrPila      db 0            
;    input1 db '2 + 3',10
;    longInput1 equ $-input1 
   


section .bss
	input1 resb 100
	longInput1 equ $-input1
    input2 resb 10
    longInput2 equ $-input2
;   expr resb 100 
;   longExpr equ $-expr
    posfijo resb 100 
    longPosfijo equ $-posfijo
    caracter resb 100
    longCaracter equ $-caracter
    resultado resb 100
    longResultado equ $-resultado
    num resb 100
    longNum equ $-num
    negativo resb 1         ;Variable para conocer si es negativo el numero a evaluar 
    indice      resb 1      ;Puntero para la cima de la pila

section .text
	global _start

_start:
	;Se muestran los mensajes del menu del programa
    print newLine,longNewLine 
    print msjMenu1,longMsjMenu1
    ;print input1,longInput1 
    ;
    input input1,longInput1
    jmp _conversionPosfijo 

_conversionPosfijo:
    ;Se empieza iterando por todos los caracteres de la expresion ingresada
    xor rcx,rcx         ;Se inicializa en cero al contador rcx para iterar
    mov rsi, input1       ;se mueve a rsi la direccion de input1


_cicloInfijo:
    cmp byte [rsi+rcx], 10 ; Se verifica si se llego al final de la expresion ingresada
    je _finCicloInfijo
    mov al, [rsi+rcx]     ;Se obtiene el caracter actual iterado por rcx
;Se verifica si es uno de los operadores + - * / ( ) 
    cmp al, '+'           
    je _operador
    cmp al, '-'
    je _operador
    cmp al, '*'
    je _operador
    cmp al, '/'
    je _operador
    cmp al, '('           ;Se verifica si es un parentesis izquierdo 
    je _parentesisIzq
    cmp al, ')'           ;Se verifica si es un parentesis derecho
    je _parentesisDer
    ;Sino, entonces es un operando y se agrega a la hilera del posfijo 
    mov [posfijo+rbx], al 
    mov byte [posfijo+rbx+1], ' ' 
    inc rbx               ;Se incrementa el contador rbx para iterar
    jmp _sigCaracter ;

    
_operador:
    ;Se verifica si la pila esta vacia 
    cmp byte [ptrPila], 0     
    jne _verPrecedencia ;Si esta vacia se verifica el nivel de precedencia del operador 
    ; Si la pila esta vacia se empuja el operador hacia la pila 
    mov [pila], al
    inc byte [ptrPila]
    jmp _sigCaracter


_verPrecedencia:
    ;Se verifica la precedencia del operador compare operator precedence
    mov cl, byte [ptrPila]
    dec cl                ;Se decrementa para apuntar a la cima de la pila 
    mov bl, [pila+rcx]   ; Se obtiene el operador en la cima de la pial ;get top operator on stack
    cmp al, bl            ;Se verifica si el operador actual tiene mayor nivel de precedencia  is current operator higher precedence?
    jle _pushOperador     ;si no tiene se empuja hacia la pila 
    ;Si tiene mayor nivel, entonces se saca el operador de la pila
    inc rbx 
    mov [posfijo+rbx], bl  ;Se agrega a la expresion posfija 
    mov byte [posfijo+rbx+1], ' ' 
    inc rbx               ;Se incrementa el iterador de la expresion de salida posfija
    dec byte [ptrPila]    ;Se remueve el operador de la pila  remove operator from stack
    jmp _verPrecedencia 


_pushOperador:
    ;Se hace push a la pila del operador
    mov [pila+rcx+1], al
    inc byte [ptrPila]
    jmp _sigCaracter;Se continua iterando 


_parentesisIzq:
    ;Se hace push a la pila del parentesis izquierdo
    mov [pila+rcx+1], al
    inc byte [ptrPila]
    jmp _sigCaracter



_parentesisDer:
    ;Remorver operadores hasta encontrar un parentesis izquierdo
    mov cl, byte [ptrPila]
    dec cl                ;Se decrementa para apuntar a la cima de la pila  
    ;Se verifica si en la pila hay un parentesis izquierdo
    cmp byte [pila+rcx], '('
    jne _popOperador
    ;Descartarlo y continuar 
    dec byte [ptrPila]
    jmp _sigCaracter


_popOperador:
    ;Se remueve el oprador de la pila y se agrega a la expresion posfija
    mov al,[pila+rcx]
    mov [posfijo+rbx],al
    inc rbx
    dec byte [ptrPila]
    jmp _parentesisDer

_sigCaracter:
    ;Se incrementa el contador para continuar iterando la expresion
    inc rcx
    jmp _cicloInfijo

_finCicloInfijo:
    ;Se agregan los operadores restantes de la pila 
    mov byte [posfijo+rbx], ' '
    inc rbx 
    mov cl, byte [ptrPila]
    cmp cl, 0
    je _finConversionPosfijo

_cicloFinInfijo:
    mov al, [pila+rcx-1] ; Se obtiene el operador en la cima de la pila
    mov [posfijo+rbx], al ; Se agrega el operador a la expresion posfija
    inc ebx ; Se incrementa el contador para iterar 
    dec byte [ptrPila] ; Se decrementa el puntero remove operator from stack
    cmp byte [ptrPila], 0 ; Se verifica si la pila esta vacia
    jne _cicloFinInfijo ; ;no, continue

_finConversionPosfijo:
    ;Se agrega un 10 de newline para determinar el fin de la expresion posfija
    mov byte [posfijo+rbx], 10
    print msjPosfijo,longMsjPosfijo
    print posfijo,longPosfijo
    ;Se salta a evaluar la expresion en posfijo 
    jmp _evaluarPosfijo

_evaluarPosfijo:
    ;Empieza la evaluacion del posfijo
    ;Se ponen en cero a los registros que se van a utilizar en la evaluacion
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx
    jmp _leerPosfijo

_leerPosfijo:
    
    cmp byte[posfijo + rcx], 10        ;Se ha llegado al fin de la hilera?
    je _fin

    cmp byte[posfijo + rcx], '+'      ;Verificar si el caracter es el signo de suma
    je _sumar

    cmp byte[posfijo + rcx], '-'      ;Verificar si el caracter es el signo de resta
    je _restar

    cmp byte[posfijo + rcx], '*'      ;Verificar si el caracter es el signo de multiplicacion
    je _multiplicar
    
    cmp byte[posfijo + rcx], '/'      ;Verificar si el caracter es el signo de division
    je _dividir
    
    cmp byte[posfijo + rcx], ' '      ;Verificar si hay un espacio
    je _continuar              ;Si es un espacio se continua con el siguiente caracter 
    ;Sino entonces el caracter es un numero
    jmp _calcularNumero

_continuar:
    inc rcx                 ;Se incrementa el iterador rcx
    jmp _leerPosfijo        ;Se devuelve al ciclo de _leerPosfijo

_verificarNumero:
    cmp byte [negativo], 1         ;Se verifica si el numero se indico como negativo
    jz _calcularNumeroNeg
    jmp _push1

_push1:;Push en caso de que no se haya llegado al final de la expresion
    push rax                       
    xor rdx, rdx
    xor rax, rax
    jmp _continuar                     ;Se continua leyendo la expresion

_push2:;Push secundario, cuando ya se ha llegado al final de la expresion
    push rax                       ; pushes the number into the stack
    xor rdx, rdx
    xor rax, rax
    jmp _leerPosfijo                    ;Se continua leyendo expression


_calcularNumeroNeg:
    mov byte[negativo], 0          ;Se vuele a poner en cero
    not rax                        ; Se calcula el complemento 2 del numero negativo
    inc rax                  
    jmp _push1
                
_calcularNumero:
    mov rbx, 10                    ;Se multiplica en base 10 al numero actual
    mul rbx                        
    mov bl, byte[posfijo + rcx]       
    sub bl, '0'                    ;El digito actual en ascii se le resta 48 para obtener el digito numerico
    add rax, rbx                   ;Se agrega el digito al numero resultado
    
    inc rcx     ;Se incrementa el contador para iterear
        
    cmp byte[posfijo + rcx], ' '      ;Se verifica si el numero ha llegado a su fin
    je _verificarNumero; 

    cmp byte[posfijo + rcx],10       ;Se verifica si la expresion ha llegado a su fin
    je _push2;

    jmp _calcularNumero      ;Se continua el ciclo para leer los digitos del numero

_numeroNegativo:
    mov byte [negativo], 1         ;Se indica que el numero es negativo
    inc rcx
    jmp _calcularNumero            ;Se calculan los digitos del numero para el Atoi
                
_sumar:
;Se remueven los operandos de la pila memoria
    pop rbx                        
    pop rax
    add rax, rbx                 ;Se realiza la suma de los operandos
;Se hace push a la pila del resultado de la suma
    push rax                       
    xor rax, rax
    jmp _continuar                 ;Se continua leyendo la expresion posfijo

_restar:
;Se verifica si el operador no corresponde al signo negativo de un numero
    cmp byte[posfijo + rcx + 1], ' '  
    jg _numeroNegativo;Operar respecto a un numero negativo  

;Se remueven los operandos de la pila memoria
    pop rbx                        
    pop rax
    sub rax, rbx                   ;Se realiza la resta
;Se hace push a la pila del resultado de la resta
    push rax                       
    xor rax, rax
    jmp _continuar                    ;Se continua leyendo la expresion postfijo

_multiplicar:
;Se remueven los operandos de la pila memoria
    pop rbx                        
    pop rax
    imul rbx                       ;Se realiza la multiplicacion
;Se hace push a la pila del resultado de la multiplicacion 
    push rax                       
    xor rax, rax
    jmp _continuar                    ;Se continua leyendo la expresion postfijo

_dividir:
;Se remueven los operandos de la pila memoria
    pop rbx                        
    pop rax
    cdq
    idiv rbx                       ;Se realiza la division 
;Se hace push a la pila del resultado de la
    push rax                       
    xor rax, rax
    jmp _continuar                     ;Se continua leyendo la expresion postfijo

_fin:
;Se saca el resultado de la pila
    pop rax                        
    mov [num],rax
    mov rax, [num]  ;Se mueve a rax el resultado a convertir 
    mov rbx, 10     ;Base 10 
    xor rcx,rcx        
    mov rcx, resultado ;Se almacena el resultado de la conversion en resultado
    ;Se realiza el Itoa con base 10
    call conversionBase    ;Se llama al procedure para convertir a la base decimal 

    mov rsi, resultado    ;rsi va como parametro 
    call hileraInvertida      ;Se invierte la hilera con el string del resultado convertido
    print newLine,longNewLine

    ;Se imprime el resultado final
    print msjResult,longMsjResult
    print resultado,longResultado  ;Se imprime el resultado post conversion
    xor rax, rax
    pop rbp

;Se pregunta al usuario si desea continuar el programa o acabarlo 
    print newLine,longNewLine
    print newLine,longNewLine
    print msjContinuacion,longMsjContinuacion 
    print newLine,longNewLine
    print msjSalida,longMsjSalida
    input input2,longInput2
    ;Se verifica si el usuario desea ejecutar nuevamente el programa
    cmp byte[input2], '1'
    je _reiniciar 
    jmp _exit;Sino se salta a exit para terminar el programa 

_reiniciar:
;    ;Se reinicializa en cero con 100 bytes a las variables que fueron usadas...
    print newLine,longNewLine
    mov rbx,resultado
    mov rcx,100
    xor rax,rax
    rep stosb 

    mov rbx,num
    mov rcx,100
    xor rax,rax
    rep stosb 

    mov rbx,posfijo
    mov rcx,100
    xor rax,rax
    rep stosb 

    mov rbx,negativo
    mov rcx,100
    xor rax,rax
    rep stosb 

    mov rbx,input1
    mov rcx,100
    xor rax,rax
    rep stosb 

    jmp _start

_exit:;Se finaliza el programa
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola

    ;Llamada de salida
    mov rbx,0           ;RBX=codigo de salido al 80 
    mov rax,1           ;RAX=funcion sys_exit() del kernel llama al sistema 
    int 0x80            ;Llamada al sistema para acabar la ejecucion del programa


_error:;Seccion en donde se le indica al usuario que hubo un error
    print msjError,longMsjError;Se imprime el mensaje de error
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
    jmp _exit;Se salta a _exit para acabar el programa 

_errorInput:;Seccion donde se indica un error correspondiente a la expresion ingresada por el usuario 
    print newLine,longNewLine
    print msjErrorInput,longMsjErrorInput
    print newLine,longNewLine
    jmp _exit

_errorOverflow:;En caso de que hubo un error relacionado a desbordamiento en la pila de memoria 
    print newLine,longNewLine; 
    print msjErrorOf,longMsjErrorOf
    jmp _exit


;    ;Se reinicializa en cero con 100 bytes a las variables ...
;    mov rbx,resultMul
;    mov rcx,100
;    xor rax,rax
;    rep stosb 