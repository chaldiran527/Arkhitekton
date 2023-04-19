;===========================================================
;Programa que cuenta la cantidad de palabras de un texto ingreado por el usuario
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
	msjIntro db 'Ingrese una palabra de menos de 1024 caracteres: ',0xA
	longMsjIntro equ $-msjIntro
    msjError db 'Error!'
    longMsjError equ $-msjError
    newLine db 0xA;Nuevalinea para separar las hileras a mostrar en la consola
    longNewLine equ $ - newLine
    errorTexto db 'Error, el texto ingresado supera los 1024 caracteres!!!',0xA
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
		cmp rax,1024
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