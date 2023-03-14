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
	msjError db 0xA,'ERROR: Usted acaba de ingresar un numero invalido!',0xA
	longMsjError equ $ - msjError
	val1 db 50
	val2 db 60
	newLine db 0xA
	longNewLine equ $ - newLine
	numstr db '1334',0
	longNumStr equ $-numstr

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
	caracter resb 2
	longCaracter equ $-caracter
	numInt1 resb 4
	longNumInt1 equ $-numInt1
	numInt2 resb 4
	longNumInt2 equ $-numInt2



section .text
	global _start

_start:
	;Se pide y se recibe el input de los dos numeros a operar
	print msj1, longMsj1
	input num1, longNum1

	;Se alistan los registros a ser usados para la conversion de Ascii a entero
	xor rbx,rbx
	xor rcx,rcx
	mov rsi,num1


cicloAtoi1:
	cmp byte[rsi],10
	je atoi1End

	cmp byte[rsi],48
	jb _error

	cmp byte[rsi],57
	ja _error

	movzx rax, byte[rsi]
	sub rax,'0'
	imul rbx,10
	add rbx,rax
	inc rsi
	jmp cicloAtoi1

atoi1End:
	mov rax,rbx
	mov [numInt1],rax

	print msj2, longMsj2
	input num2, longNum2

;nuevo atoi para el segundo numero...
	xor rbx,rbx
	xor rcx,rcx
	mov rsi,num2


cicloAtoi2:

	cmp byte[rsi],10
	je atoi2End

	cmp byte[rsi],48
	jb _error

	cmp byte[rsi],57
	ja _error

	movzx rax, byte[rsi]
	sub rax,'0'
	imul rbx,10
	add rbx,rax
	inc rsi
	jmp cicloAtoi2

atoi2End:
	mov rsp,rbx
	add rbx,[numInt1]

	mov rax,rbx

	mov [numSuma],rax
	mov [numInt2],rsp


    mov rbx, 10
    mov rcx, numSuma
    jmp _itoaLoop


_itoaLoop:
    xor rdx, rdx         
    div rbx              ; Dividr rbx   
    add rdx, '0'         ; sumar 49 para el codigo ascii
    mov [rcx], dl        ; almacenar el digito en rcx de numSuma
    inc rcx              ; incrementar el contador de la posicion actual del registro iterado
    cmp rax, 0           ; verificar si es igual que cero 
    jne _itoaLoop      ; Si es diferente se continua el loop


	print msjSuma,longMsjSuma
	mov rsi,numSuma
	add rsi,longNumSuma
	jmp _contarReves


_contarReves:
	cmp rsi,numSuma
	je _itoa2
	dec rsi
	mov al,[rsi]
	mov [caracter],al
	print caracter,longCaracter
	jmp _contarReves

_itoa2:
	mov al,[numInt1]
	mov bl,[numInt2]
	;Se verifica si el numero 1 es menor que el numero 2
	cmp al,bl
	jb _itoa2Num1Menor
	sub al,bl
	movzx rax,al
	mov [numDif],rax
	mov rbx, 10
	mov rcx,numDif

	jmp _itoaLoop2

_itoa2Num1Menor:
	sub bl,al 
	movzx rax,bl
	mov [numDif],rax
	mov rbx,10
	mov rcx,numDif
	jmp _itoaLoop2

_itoaLoop2:
    xor rdx, rdx         
    div rbx              ; Dividr rbx   
    add rdx, '0'         ; sumar 49 para el codigo ascii
    mov [rcx], dl        ; almacenar el digito en rcx de numSuma
    inc rcx              ; incrementar el contador de la posicion actual del registro iterado
    cmp rax, 0           ; verificar si es igual que cero 
    jne _itoaLoop2      ; Si es diferente se continua el loop


	print msjDif,longMsjDif
	mov rsi,numDif
	add rsi,longNumDif
	jmp _contarReves2

_contarReves2:
	cmp rsi,numDif
	je _exit
	dec rsi
	mov al,[rsi]
	mov [caracter],al
	print caracter,longCaracter
	jmp _contarReves2

_error:
	print msjError,longMsjError
	jmp _exit

_exit:;Se finaliza el programa
	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
	;Llamada de salida
	mov rbx,0 			;RBX=codigo de salido al 80 
	mov rax,1			;RAX=funcion sys_exit() del kernel llama al sistema 
	int 0x80 			;Llamada al sistema para acabar la ejecucion del programa