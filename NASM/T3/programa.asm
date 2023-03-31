;===========================================================
;Programa que convierte caracteres de minusucula a mayuscula y viceversa
;en una cadena de caracteres ingresada desde el teclado.
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
	;Se inicializan las hileras que se le muestran al usuario 
	msj1 db 'Ingrese una cadena de caracteres alfabeticos a ser convertida:';mensaje incial 
	longMsj1 equ $-msj1	;longitud mensaje inicial 
	msjError db 0xA,'Error: La hilera tiene valores no alfabeticos. Intente nuevamente',0xA,0xA;mensaje error
	longMsjError equ $-msjError ;longitud mensaje de error
	msj3 db '1'
	longMsj3 equ $-msj3
	msjExito db 0xA,0xA,'Conversion de caracteres realizada exitosamente',0xA
	longMsjExito equ $-msjExito 
	hileraConvertida db 0xA,'Hilera convertida: '
	longHileraConvertida equ $-hileraConvertida

section .bss
	hilera resb 255
	longInputHilera equ $-hilera
	caracter resb 2

section .text
	global _start

_start:
	;Se recibe el input del usuario
	print msj1, longMsj1 
	input hilera,longInputHilera
	mov rsi,hilera;Se mueve el contenido del string ingresado al registro rsi
	mov cl,0;Contador que empieza en cero. Cuando ha sido incrementado significa que la hilera es valida 
	jmp _loop 

_loop:
	mov al, [rsi];Se mueve a 'al' el contenido al que apunta actualmente rsi
	cmp al,0xA;Verificar si se llego al final de la hilera
	je _exito;Se finaliza el ciclo
	inc rsi;Se incrementa en uno la direccion de rsi 
	mov [caracter], al;Se cambia el contenido en caracter con el contenido de al
	jmp _convertirCaracter;Se manda a convertir al caracter


_convertirCaracter:
;Se verifica si el caracter es valido antes de mandarlo a hacer la conversion
	cmp byte [caracter], 20h;verificar si es la tecla de espacio
	je _error


	cmp byte [caracter],40h;verificar si es menor que 'A' 
	jb _error;saltar a imprimir  el mensaje de error

	cmp byte [caracter],5bh;verificar si es menor que 'Z'
	jb _mayusculaAMinuscula


	cmp byte [caracter],7ah;verificar si es mayor que 'z'
	ja _error

	cmp byte [caracter],60h;verificar si es menor que 'a'
	ja _minusculaAMayuscula

	jmp _error;Sino se encuentra en los intervalos de la tabla ASCII anteriores, se manda error


_mayusculaAMinuscula:
;Se hace la conversion de mayuscula a minuscula
	mov rsp, caracter 
	mov bl, [rsp]
	add bl, 32
	mov [caracter],bl
	cmp cl,0
	ja _printCaracter;Se imprime el caracter si el contador cl es mayor que cero
	jmp _loop

_minusculaAMayuscula:
;Se hace la conversion de minuscula a mayuscula
	mov rsp, caracter 
	mov bl, [rsp]
	sub bl, 32
	mov [caracter],bl

	cmp cl,0
	ja _printCaracter
	jmp _loop

_printCaracter:;Se imprime el caracter solo si el contador cl no es igual a cero
	cmp cl,0
	je _loop
	print caracter,1
	jmp _loop

_error:;Se imprime el mensaje de error y se manda el programa al exit
	print msjError,longMsjError
	jmp _exit

_exito:;Se verifica si el contador cl es cero. Si no lo es se imprime el mensaje de exito y se manda el programa al exit
	cmp cl,0
	je _incrementarContador
	print msjExito,longMsjExito
	jmp _exit

_incrementarContador:;Se incrementa el contador 'cl'
	inc cl
	mov rsi,hilera
	print hileraConvertida,longHileraConvertida
	jmp _loop
