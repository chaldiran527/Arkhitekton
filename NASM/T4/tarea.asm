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
	num1 resb 4
	longNum1 equ $-num1
	num2 resb 4
	longNum2 equ $-num2
;numSuma almacena la suma de los dos numeros ingresados
	numSuma resb 4
	longNumSuma equ $-numSuma
;numDif almacena la diferencia de los dos numeros ingresados 
	numDif resb 4
	longNumDif equ $-numDif
	nuevaLinea resb 4
	caracter resb 2
	longCaracter equ $-caracter
;numInt1 almacena el primer numero entero convertido del string ingresado por el usuario
	numInt1 resb 4
	longNumInt1 equ $-numInt1
;numInt2 almacena el segundo numero entero convertido del string ingresado por el usuario
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
	mov rsi,num1;Se mueve a rsi el string numerico ingresado por el input

;CicloAtoi1 en donde se convierte de ascii a entero el primer string numerico 'num1'
cicloAtoi1:
	cmp byte[rsi],10;Se compara si el caracter actual es el newline 10 en ascii
	je atoi1End;Si es igual a 10 se salta a atoi1End terminando este ciclo

	cmp byte[rsi],48;Se compara si el caracter actual es menor que 48(cero en ascii)
	jb _error;Si es menor el string no es numerico y se indica el error al usuario

	cmp byte[rsi],57;Se compara si el caracter actual es mayor que 57(nueve en ascii)
	ja _error;Si es mayor el string no es numerico y se indica el error al usuario

	movzx rax, byte[rsi];Se mueve con cero al contenido actual del byte actual del registro
	sub rax,'0';Se resta el cero en ascii 48 
	imul rbx,10;Se multiplica por 10 que es la base
	add rbx,rax;Se agrega el digito actual a rbx
	inc rsi;Se incrementa rsi para avanzar en la hilera
	jmp cicloAtoi1;Se devuelve para repetir el cicloAtoi1

;atoi1End en donde se continua el programa despues de finalizar el ciclo anterior
atoi1End:
	mov rax,rbx;Se mueve a rax el valor del entero convertido en rbx
	mov [numInt1],rax;Se almcaena en numInt1 el entero del primer numero convertido

;Se pide al usuario que ingrese el segundo numero 
	print msj2, longMsj2
	input num2, longNum2

;nuevo atoi para el segundo numero
	xor rbx,rbx
	xor rcx,rcx
	mov rsi,num2;Se mueve a rsi el string numerico ingresado por el input

;CicloAtoi2 en donde se convierte de ascii a entero el segundo string numerico 'num2'
cicloAtoi2:

	cmp byte[rsi],10;Se compara si el caracter actual es el newline 10 en ascii
	je atoi2End;Si es igual a 10 se salta a atoi1End terminando este ciclo

	cmp byte[rsi],48;Se compara si el caracter actual es menor que 48(cero en ascii)
	jb _error;Si es menor el string no es numerico y se indica el error al usuario

	cmp byte[rsi],57;Se compara si el caracter actual es mayor que 57(nueve en ascii)
	ja _error;Si es mayor el string no es numerico y se indica el error al usuario

	movzx rax, byte[rsi];Se mueve con cero al contenido actual del byte actual del registro
	sub rax,'0';Se resta el cero en ascii 48 
	imul rbx,10;Se multiplica por 10 que es la base
	add rbx,rax;Se agrega el digito actual a rbx
	inc rsi;Se incrementa rsi para avanzar en la hilera
	jmp cicloAtoi2;Se devuelve para repetir el cicloAtoi2

;atoi2End en donde se continua el programa despues de finalizar el ciclo anterior
atoi2End:
	mov rsp,rbx;Se mueve el numero2 a rsp
	add rbx,[numInt1];Se suma al numero2 el numero1 almacenado en numInt1

	mov rax,rbx;Se mueve el resultado de la suma a rax

	;Se apunta el contenido de rax en numSuma y se mueve rsp a numInt2
	mov [numSuma],rax
	mov [numInt2],rsp


    mov rbx, 10;Se mueve directamente un 10 a rbx
    mov rcx, numSuma;se mueve numSuma a rcx
    jmp _itoaLoop;Se salta al ciclo para convertir de entero a ascii la suma 

;Ciclo para hacer la conversion de cada digito a su caracter ascii de la suma
_itoaLoop:
    xor rdx, rdx   ;Limpiar rdx para evitar un error del tipo arithmetic exception
    div rbx        ;Dividr rbx   
    add rdx, '0'   ;sumar 49 para el codigo ascii
    mov [rcx], dl  ;almacenar el digito en rcx de numSuma
    inc rcx        ;incrementar el contador de la posicion actual del registro iterado
    cmp rax, 0     ;verificar si es igual que cero 
    jne _itoaLoop  ;Si es diferente se continua el loop

;Se imprime el mensaje que indica que se mostrara el resultado de la suma:
	print msjSuma,longMsjSuma
	mov rsi,numSuma;se mueve a rsi la posicion de numsuma
	add rsi,longNumSuma;se suma la posicion de rsi a la ultima de la hilera numSuma
	jmp _contarReves;Se salta al ciclo para contar los caracteres al reves de numSuma

;Ciclo en donde se recorre a la inversa la hilera y se impime cada caracter de paso
_contarReves:
	cmp rsi,numSuma;Se verifica si rsi apunta a la posicion de numSUma
	je _itoa2;Si es igual rsi a numSuma se salta a _itoa2 
	dec rsi;Se decrementa la posicion de rsi
	mov al,[rsi];Se mueve a al el contenido de rsi
	mov [caracter],al;Se mueve al a carcater
	print caracter,longCaracter;Se imprime el caracter
	jmp _contarReves;Se repite el ciclo 

;Se continua el programa para pasar de entero a ascii la resta
_itoa2:
;Se mueven los dos numeros a los registros al y bl
	mov al,[numInt1]
	mov bl,[numInt2]
	;Se verifica si el numero 1 es menor que el numero 2
	cmp al,bl
	jb _itoa2Num1Menor;Si al es menor se salta a itoa2Num1Menor para hacer la resta con los operandos al reves
	sub al,bl;Sino se resta al con bl
	movzx rax,al;Se mueve a rax con cero 
	mov [numDif],rax;Se mueve al numDif el contenido de rax
	mov rbx, 10;Se mueve un 10 directamente a rbx, pues estamos en base decimal 
	mov rcx,numDif;Se mueve numDif a rcx

	jmp _itoaLoop2;Se salta al segundo ciclo para pasar de entero a ascii

;Seccion en caso de que el primer numero sea menor que el segundo 
_itoa2Num1Menor:
	sub bl,al ;Se resta bl con al 
	movzx rax,bl;Se mueve a rax con cero
	mov [numDif],rax;Se mueve al numDif el contenido de rax
	mov rbx,10;Se mueve un 10 directamente a rbx, pues estamos en base decimal
	mov rcx,numDif;Se mueve numDif a rcx
	jmp _itoaLoop2;Se salta al segundo ciclo para pasar de entero a ascii

;Ciclo para hacer la conversion de cada digito a su caracter ascii de la diferencia
_itoaLoop2:
    xor rdx, rdx   ;Limpiar rdx para evitar un error del tipo arithmetic exception    
    div rbx        ;Dividr rbx   
    add rdx, '0'   ;sumar 49 para el codigo ascii
    mov [rcx], dl  ;almacenar el digito en rcx de numSuma
    inc rcx        ;incrementar el contador de la posicion actual del registro iterado
    cmp rax, 0     ;verificar si es igual que cero 
    jne _itoaLoop2 ;Si es diferente se continua el loop

;Se imprime el mensaje que indica que se mostrara el resultado de la resta
	print msjDif,longMsjDif
	mov rsi,numDif;se mueve a rsi la posicion de numsuma
	add rsi,longNumDif;se suma la posicion de rsi a la ultima de la hilera numDif
	jmp _contarReves2;Se salta al ciclo para contar los caracteres al reves de numDif

;Ciclo en donde se recorre a la inversa la hilera y se impime cada caracter de paso
_contarReves2:
	cmp rsi,numDif;Se verifica si rsi apunta a la posicion de numDif
	je _exit;Si es igual rsi a numDif se salta a _exit para finalizar el programa
	dec rsi;Se decrementa la posicion que apunta rsi
	mov al,[rsi];Se mueve a al el contenido de rsi
	mov [caracter],al
	print caracter,longCaracter
	jmp _contarReves2

;Se salta aqui en caso de detectar que se ingreso un caracter no numerico 
_error:
	print msjError,longMsjError;Se imprime el mensaje de error
	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
	jmp _exit;Se salta a _exit para acabar el programa 

_exit:;Se finaliza el programa
	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
	;Llamada de salida
	mov rbx,0 			;RBX=codigo de salido al 80 
	mov rax,1			;RAX=funcion sys_exit() del kernel llama al sistema 
	int 0x80 			;Llamada al sistema para acabar la ejecucion del programa