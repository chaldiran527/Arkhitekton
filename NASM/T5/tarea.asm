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


;Store procedure xd para calcular el numero de caracteres de una hilera 
	lenHilera:
		xor rax,rax ;set counter to zero
		
	.cicloLenHilera:
		cmp byte [rdi],10;newline
		je .finCicloLenHilera
		inc rax
		inc rdi 
		jmp .cicloLenHilera

	.finCicloLenHilera:
		ret

;Procedure para convertir un numero de ascii a decimal pasado por parametro en un registro 

	Atoi:
		xor rbx,rbx
		xor rcx,rcx
		jmp .cicloAtoi

	.cicloAtoi:
		cmp byte[rsi],10;Se compara si el caracter actual es el newline 10 en ascii
		je .finAtoi;Si es igual a 10 se salta a atoi1End terminando este ciclo

		cmp byte[rsi],0
		je .finAtoi

		cmp byte[rsi],48;Se compara si el caracter actual es menor que 48(cero en ascii)
		jb _error;Si es menor el string no es numerico y se indica el error al usuario

		cmp byte[rsi],57;Se compara si el caracter actual es mayor que 57(nueve en ascii)
		ja _error;Si es mayor el string no es numerico y se indica el error al usuario

		movzx rax, byte[rsi];Se mueve con cero al contenido actual del byte actual del registro
		sub rax,'0';Se resta el cero en ascii 48 
		imul rbx,10;Se multiplica por 10 que es la base
		add rbx,rax;Se agrega el digito actual a rbx
		inc rsi;Se incrementa rsi para avanzar en la hilera
		jmp .cicloAtoi;Se devuelve para repetir el cicloAtoi1

	.finAtoi:
		mov rax,rbx;
		ret

;Procedure para convertir un numero en decimal a ascii pasado por parametro en un registro 	
	Itoa:

		mov rbx,10
		jmp .cicloItoa

	.cicloItoa:
	    xor rdx, rdx   ;Limpiar rdx para evitar un error del tipo arithmetic exception
	    div rbx        ;Dividr rbx   
	    add rdx, '0'   ;sumar 49 para el codigo ascii
	    mov [rcx], dl  ;almacenar el digito en rcx de numSuma
	    inc rcx        ;incrementar el contador de la posicion actual del registro iterado
	    cmp rax, 0     ;verificar si es igual que cero 
	    jne .cicloItoa  ;Si es diferente se continua el loop
	    jmp .finItoa

	.finItoa:
		ret

;Procedure para imprimir una hilera al reves
	printReves:

		jmp .cicloPrintReves
	.cicloPrintReves:
		cmp rdi,rbp;Se verifica si rsi apunta a la posicion de numSUma
		je  .finPrintReves;Si es igual rsi a numSuma se salta a _itoa2 
		dec rdi;Se decrementa la posicion de rsi
		mov al,[rdi];Se mueve a al el contenido de rsi
		mov [caracter],al;Se mueve al a carcater
		print caracter,1;Se imprime el caracter
		jmp .cicloPrintReves

	.finPrintReves:
		ret

;Procedure para calcular la suma de dos numeros enteros

	calcSuma:
		add rax,rbx;rax numInt1 y rbx numInt2
		jmp .finCalcSuma

	.finCalcSuma:
		ret

;Procedure para calcular al diferencia de dos numeros enteros 
	calcDif:
	;al primer numero a restar y bl es el segundo 
		cmp al,bl           ; Verificar si al es menor que bl 
		jb .num1Menor
		sub al,bl			; Sino se resta al con bl
		movzx rax,al 		; Se mueve a rax con cero
		jmp .finCalcDif
	
	.num1Menor:
		sub bl,al ;Se resta bl con al 
		movzx rax,bl;Se mueve a rax con cero
		jmp .finCalcDif

	.finCalcDif:
		ret

section .data
;Hileras de los mensajes a mostrar en la consola al uduario
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
	newLine db 0xA;Nuevalinea para separar las hileras a mostrar en la consola
	longNewLine equ $ - newLine

section .bss
;Variables sin inicializar a usar en el programa
;num1 y num2 almacenan los inputs del usuario
	num1 resb 100
	longNum1 equ $-num1
	num2 resb 100
	longNum2 equ $-num2
;numSuma almacena la suma de los dos numeros ingresados
	numSuma resb 100
	longNumSuma equ $-numSuma
;numDif almacena la diferencia de los dos numeros ingresados 
	numDif resb 100
	longNumDif equ $-numDif
	nuevaLinea resb 4
	caracter resb 2
	longCaracter equ $-caracter
;numInt1 almacena el primer numero entero convertido del string ingresado por el usuario
	numInt1 resb 100
	longNumInt1 equ $-numInt1
;numInt2 almacena el segundo numero entero convertido del string ingresado por el usuario
	numInt2 resb 100
	longNumInt2 equ $-numInt2
;lenNumero1 almacena la cantidad de digitos del numero1
	lenNumero1 resb 4;
	longLenNumero1 equ $-lenNumero1
;lenNumero2 almacena la cantidad de digitos del numero2
	lenNumero2 resb 4;
	longLenNumero2 equ $-lenNumero2
	posInicial resb 100
	longPosInicial equ $-posInicial


section .text
	global _start

_start:
	;Se pide y se recibe el input de los dos numeros a operar
	print msj1, longMsj1
	input num1, longNum1

	;Se verifica si el primer numero ingresado es menor a 20 digitos 
	mov rdi, num1	;rdi es el parametro 
	call lenHilera  ;rax almacena el resultado
	cmp rax,20		;En caso de ser mayor a 20 se salta al error
	ja _error
	mov [lenNumero1],rax
	
	;===Ahora hacer el proc de atoi del num1 y del num2!!!
	mov rsi,num1;Se mueve a rsi el string numerico ingresado por el input param proc
	call Atoi
	mov [numInt1], rax

	print msj2, longMsj2
	input num2, longNum2

	;Se verifica si el segundo numero ingresado es menor a 20 digitos 
	mov rdi, num2	;rdi es el parametro 
	call lenHilera  ;rax almacena el resultado
	cmp rax,20		;En caso de ser mayor a 20 se salta al error
	ja _error
	mov [lenNumero2],rax

	;===Ahora hacer el proc de atoi del num1 y del num2!!!
	mov rsi,num2;Se mueve a rsi el string numerico ingresado por el input param proc
	call Atoi
	mov [numInt2], rax


	;===Ahora hacer el proc de sum de dos numeros enteros
	mov rax,[numInt1]
	mov rbx,[numInt2]
	call calcDif		;rax tiene resultado
	mov [numDif],rax

	;Probando con numDif
	mov rcx, numDif
	call Itoa

	mov rax,[numInt1]
	mov rbx,[numInt2]
	call calcSuma
	mov [numSuma],rax

	;===Ahora hacer el proc de itoa probando con numSuma
	mov rcx, numSuma
	call Itoa; 
	;===Ahora hacer el proc de printReves para suma
	mov rbp,numSuma
	mov rdi,numSuma
	add rdi,longNumSuma
	call printReves

	print newLine,longNewLine;

	;Para diferencia
	mov rbp,numDif
	mov rdi,numDif
	add rdi,longNumDif
	call printReves
;REPETIOS EL CICLO 
	mov rcx,numInt1
	call Itoa; 

	mov rsi,numInt1;Se mueve a rsi el string numerico ingresado por el input param proc
	call Atoi
	mov [numInt1], rax

	mov rcx,numInt1
	call Itoa; 

	print newLine,longNewLine;
	mov rbp,num1
	mov rdi,num1
	add rdi,longNum1
	call printReves

	jmp _exit



;Se salta aqui en caso de detectar que se ingreso un caracter no numerico 
_error:
	print msjError,longMsjError;Se imprime el mensaje de error
	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
	jmp _exit;Se salta a _exit para acabar el programa 

_exit:;Se finaliza el programa
	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
;	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
	;Llamada de salida
	mov rbx,0 			;RBX=codigo de salido al 80 
	mov rax,1			;RAX=funcion sys_exit() del kernel llama al sistema 
	int 0x80 			;Llamada al sistema para acabar la ejecucion del programa