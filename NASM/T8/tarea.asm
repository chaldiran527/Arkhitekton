;===========================================================
;Programa que cuenta y ordena las palabras de un texto ingreado por el usuario
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
		xor r11,r11
		mov r11,rsi;Se mueve la pos actual del primer caracter de la palabra
		mov r15,rsi
	;	xor r12,r12;r12 contador de swaps
		xor r14,r14;contador de caracteres de la palabra
		inc r14;Existe almenos un caracter
		jmp .loopPalabras;Se salta al ciclo de contar palabra

	.loopPalabras:
		inc r15
		inc rsi;Se incrementa la posicion actual del registro de la palabra
		cmp byte[rsi],10;Se verifica si el caracter es el newline del final
		je .intercambiarPalabra;jmp .interCambiarPalabra

		cmp byte[rsi],32;Se verifica si el caracter es espacio
		je .intercambiarPalabra; jmp .intercambiarPalabras

		
		
		inc r14;Se incrementa el contador de caracteres
		jmp .loopPalabras;Se salta de vuelta al label de palabras pues no se ha terminado de recorrer la palabra actual

	.intercambiarPalabra:;sortloop
	;Hacer exchange del anterior con el actual en rsi xchg rsi-1,rsi
	;r14 tiene el total de caracteres de esta palabra
		xor r12,r12;Contador de swaps
		xor r13,r13;Iterador de la palabra rcx ecx
		;Se mueve rsi a la posicion inicial de la palabra contada antes de cicloPalabras
		mov rsi,r11
		jmp .cicloSwap
		;mov ecx,ebx ???
	.cicloSwap:;innerloop    cal
		mov al, [rsi]
		mov bl, [rsi+1]
		cmp al,bl
		jle .swap2

	

	.swap1:;swap
		;Se intercambian los caracteres usando el operador xchg
	;	mov rsp, [rsi+r13]
	;	xchg rsp,[rsi+r13+1]
	;	mov [rsi+r13], rsp
		;xchg [rsi+r13],[rsi+r13+1]
		mov byte[rsi+1],al
		mov byte[rsi],bl
		inc r12
		jmp .swap2

	.swap2:
		;Se incrementa el iterador r13
		inc rsi
		cmp rsi,[r11+r14-1]
		jne .cicloSwap;Verificar si el iterador es igual al ultimo caracter


		;Verificar si se hicieron intercambios
		cmp r12,0
		ja .intercambiarPalabra

		inc rsi 
		;jmp contarPalabras
		jmp contarPalabras


	.loopEspacios:
		inc rsi;Se incrementa la posicion actual del registro de la palabra

		cmp byte[rsi],10
		je .finContarPalabras

		cmp byte[rsi],32
		je .loopEspacios
		;
		inc rcx;Se incrementa el contador de palabras 
		xor r11,r11
		mov r11,rsi;Se mueve la pos actual del primer caracter de la palabra
		xor r12,r12;r12 contador de swaps
		xor r14,r14;contador de caracteres de la palabra
		inc r14;Existe almenos un caracter
		jmp .loopPalabras

	.finContarPalabras:
		ret


section .data
	msjIntro db 'Ingrese una palabra de menos de 2048 caracteres: ',0xA
	longMsjIntro equ $-msjIntro
    msjError db 'Error!'
    longMsjError equ $-msjError
    newLine db 0xA;Nuevalinea para separar las hileras a mostrar en la consola
    longNewLine equ $ - newLine
    errorTexto db 'Error, el texto ingresado supera los 2048 caracteres!!!',0xA
    longErrorTexto equ $-errorTexto
    msjNumPalabras db 'Cantidad de palabras: '
    longMsjNumPalabras equ $-msjNumPalabras 

section .bss
	texto resb 100
	longTexto equ $-texto
	caracter resb 100
    longCaracter equ $-caracter
    prueba resb 100
    longPrueba equ $-prueba
    numPalabras resb 100
    longNumPalabras equ $-numPalabras 
    numPalabrasInt resb 100
    longNumPalabrasInt equ $-numPalabrasInt

section .text
	global _start

	_start:
	;Se le pide al usuario ingresar el texto a evaluar
		print msjIntro,longMsjIntro
		print newLine,longNewLine
		input texto,longTexto

		mov rdi,texto
		call lenHilera
		cmp rax,2048
		ja _error

		mov rsi,texto
		call contarPalabras
		mov [numPalabras],rcx

	    mov rax, [numPalabras]           ;Se mueve a rax el numero a convertir de la multiplicacion
	    mov rbx, 10
	    xor rcx,rcx
	    mov rcx, numPalabrasInt          ;Se almacena el resultado de la conversion e
	    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

	    mov rsi, numPalabrasInt         ;rsi va como parametro 
	    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
	 	
	 	print msjNumPalabras,longMsjNumPalabras 
	 	print numPalabrasInt,longNumPalabrasInt

		jmp _exit


	_error:;Seccion en donde se le indica al usuario que hubo un error
    	;Se imprime el mensaje de error
    	print errorTexto,longErrorTexto
    	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
    	jmp _exit;Se salta a _exit para acabar el programa 

	_errorOverflow:;Ignorar no se usa en el programa ;)
	    print newLine,longNewLine; 
	    ;print msjErrorOf,longMsjErrorOf
		jmp _exit

	_exit:;Se finaliza el programa
    	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
    ;Llamada de salida
	    mov rbx,0           ;RBX=codigo de salido al 80 
	    mov rax,1           ;RAX=funcion sys_exit() del kernel llama al sistema 
	    int 0x80            ;Llamada al sistema para acabar la ejecucion del programa