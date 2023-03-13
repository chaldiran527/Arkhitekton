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
	%macro input 2
		mov rdx, %2
		mov rcx, %1
		mov rbx, 0
		mov rax, 3
		int 0x80
	%endmacro

section .data
	msj1 db 'Ingrese el primer numero: '
	longMsj1 equ $ - msj1
	msj2 db 0xA,'Ingrese el segundo numero: '
	longMsj2 equ $ - msj2
	msjSuma db 0xA,'Suma de ambos numeros es: '
	longMsjSuma equ $ - msjSuma
	msjDif db 0xA,'Diferencia de ambos numeros es: '
	longMsjDif equ $ - msjDif
	msjError db 0xA,'Usted acaba de ingresar un numero invalido!',0xA
	longMsjError equ $ - msjError


section .bss
	num1 resb 4
	longNum1 equ $-num1
	num2 resb 4
	longNum2 equ $-num2
	numSuma resb 4
	longNumSuma equ $-numSuma
	numDif resb 4
	longNumDif equ $-numDif
	nuevaLinea resb 4

section .text
	global _start

_start:
	;Se pide y se recibe el input de los dos numeros a operar
	print msj1, longMsj1
	input num1, longNum1
	print msj2, longMsj2
	input num2, longNum2
	jmp _exit

_exit:;Se finaliza el programa
	;Llamada de salida
	mov rbx,0 			;RBX=codigo de salido al 80 
	mov rax,1			;RAX=funcion sys_exit() del kernel llama al sistema 
	int 0x80 			;Llamada al sistema para acabar la ejecucion del programa