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

	.concatenarEspacio:
	;llamar al insertion sort que ordena e imprime la palabra 
		jmp .loopEspacios

	.concatenarFin:
	;llamar al insertion sort que ordena e imprime la palabra 
		jmp .finContarPalabras

	.finContarPalabras:;Se finaliza este procedimiento ya no hay mas caracteres que contar
		ret

	ordenarPalabra:
	;r9: Iterador de la palabra a ordenar
	;r11: Iterador de la segunda palabra que ya esta ordenada 
		jmp .finOrdenarPalabra

	.finOrdenarPalabra:
	;Imprimir palabra 
		ret 

	InsertionSort:
		cmp byte[rsi],10
		jne .finInsertionSort

		jmp InsertionSort

	.finInsertionSort:
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
    palabrota db 'caras',0xA
    longPalabrota equ $-palabrota

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
    palabra resb 100
    longPalabra equ $-palabra
    palabraNueva resb 100
    longPalabraNueva equ $-palabraNueva

section .text
	global _start

	_start:
		;from down here use tarea T6 code asInt
		input palabra,longPalabra
		mov rbx,palabra 
		xor rbp,rbp;palabra ordenada 
		;mov 
		inc rbx
	_is:
	
		cmp byte[rbx],10
		jne _exit


	_fis:
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