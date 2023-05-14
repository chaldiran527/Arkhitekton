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

;Macro para recibir un input desde consola con 1 parametro(%1 de la hilera que almacenara el input)
	%macro inputi 2
		mov rdx, %2
		mov rcx, %1
		mov rbx, 0
		mov rax, 3
		int 0x80
	%endmacro

section .data
	pila    db 20 dup(0)     ;Pila para almacenar las variables
	ptrPila      db 0            ; pointer to top of stack
	input1 db '2 * 3',0
	longInput1 equ $-input1 

section .bss
	posfijo   resb 20         ; buffer for output string
	longPosfijo equ $-posfijo
	idx      resb 1          ; index of output string

section .text
global _start

_start:

_conversionPosfijo:
    ;Se empieza iterando por todos los caracteres de la expresion ingresada
    xor rcx,rcx  		;Se inicializa en cero al contador rcx para iterar
    mov rsi, input1       ;se mueve a rsi la direccion de input1


_cicloInfijo:
    cmp byte [rsi+rcx], 0 ; Se verifica si se llego al final de la expresion ingresada
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
    ; yes, pop higher precedence operator from stack
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
    ; pop operators from stack until left parenthesis is found
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

	print posfijo,longPosfijo
	jmp _exit;Se salta a evaluar la expresion en posfijo 



	;Se termina 
_exit:
	mov rax, 1
	xor rbx, rbx
	int 0x80