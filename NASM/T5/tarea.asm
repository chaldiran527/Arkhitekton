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

;Macro para imprimir mensaje con 2 parametros(%1 de hilera numerica)
	%macro revertirNumStr 1
		mov rsi,%1;
		call Atoi
		mov [%1], rax

		mov rcx, %1
		call Itoa
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
		mov rdi,rcx		;
		mov rsi,0 		;
		mov rcx,0 		;
		mov rbx,10  	;

		cmp rax,10
		jb .digitoItoa
		cmp rax,0
		ja .cicloItoa
		mov byte [rdi + rsi], '0';di
		inc rsi
		jmp .finItoa


	.digitoItoa:
		add rax,'0'
		mov byte[rdi + rsi], al
		inc rsi
		jmp .finItoa


	.cicloItoa:
	    xor rdx, rdx   ;Limpiar rdx para evitar un error del tipo arithmetic exception
	    div rbx        ;Dividr rbx   
	    add dl, '0'   ;sumar 49 para el codigo ascii
	    mov byte[rdi + rsi], dl  ;almacenar el digito en rcx de numSuma
	    inc rcx        ;incrementar el contador de la posicion actual del registro iterado
	    inc rsi  
	    cmp rax, 0     ;verificar si es igual que cero 
	    jne .cicloItoa  ;Si es diferente se continua el loop
	    jmp .finCicloItoa
	    
	.finCicloItoa:

	   ; mov rsi,rcx
	    mov rcx,rsi
	    ;cambios
	    dec rsi
	    shr rcx,1
	 	jz .finItoa
	    jmp .invertirNumero

	.invertirNumero:
		mov al,[rdi + rsi]
		mov ah,[rdi + rcx]
		;xchg al, [rdi + rcx]
		mov [rdi + rsi], al
		mov [rdi + rsi], ah
		dec rcx
		inc rsi
		cmp rsi,rcx
		jle .invertirNumero
		jmp .finItoa

	.finItoa:
		mov byte[rdi + rsi],0
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
		cmp rax,rbx           ; Verificar si al es menor que bl 
		jb .num1Menor
		sub rax,rbx			; Sino se resta al con bl
		;movzx rax,al 	
		jmp .finCalcDif
	
	.num1Menor:
		sub rbx,rax ;Se resta bl con al 
		;movzx rax,bl;Se mueve a rax con cero
		jmp .finCalcDif

	.finCalcDif:
		ret

	hileraInvertida:
		mov rcx,0
		mov r9,rsi
		jmp .cicloA

	.cicloA:
		cmp byte[rsi],0
		je .revertir
		inc rcx
		inc rsi
		jmp .cicloA

	.revertir:
		mov rdi, r9
		mov rsi, r9
		add rsi, rcx
		dec rsi
		jmp .cicloB

	.cicloB:
		cmp rdi, rsi
		jge .finHileraInvertida
		mov al,[rdi]
		xchg al,[rsi]
		mov [rdi],al
		inc rdi
		dec rsi
		jmp .cicloB

	.finHileraInvertida:
		ret

	baseConversion:
        ;xor ecx,ecx
        jmp .divCiclo

    .divCiclo:
        xor edx, edx
        div ebx
        cmp edx, 10
        jl .conversionDigito
        add edx, 'A' - 10
        jmp .almacenarDigito


    .conversionDigito:
    	add edx,'0'
    	jmp .almacenarDigito

    .almacenarDigito:
    	mov byte[ecx],dl
    	inc ecx 
    	cmp eax, 0
    	jnz .divCiclo
    	jmp .finConversion

    .finConversion:
    	mov byte[ecx],0
    	ret 

section .data
;Hileras de los mensajes a mostrar en la consola al uduario
	msj1 db 'Ingrese el primer numero: '
	longMsj1 equ $ - msj1
	msj2 db 0xA,'Ingrese el segundo numero: '
	longMsj2 equ $ - msj2
	msjError db 0xA,'ERROR: Usted acaba de ingresar un numero invalido!',0xA
	longMsjError equ $ - msjError
	newLine db 0xA;Nuevalinea para separar las hileras a mostrar en la consola
	longNewLine equ $ - newLine
	msjSuma db '   Suma: ',0
	longMsjSuma equ $ - msjSuma
	msjBase db 'Base ',0
	longMsjBase equ $-msjBase
	msjDif db '   Diferencia: ',0
	longMsjDif equ $-msjDif
	msjContinuacion db 'Presione enter para continuar ',0xA
   ;msjgenera1 db 'Base 2___        ___          ___         ___          ___'
	strPrueba db 'adam',0
	longStrPrueba equ $-strPrueba
	espacio db '             '
	longEspacio equ $-espacio
	baseN dd 1

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
	caracter resb 10
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
	numSumaInt resb 100
	longNumSumaInt equ $-numSumaInt
	numDifInt  resb 100
	longNumDifInt equ $-numDifInt
	numInput resb 100
	longNumInput equ $-numInput
	numDifStr resb 100
	longNumDifStr equ $-numDifStr
	numSumaStr resb 100
	longNumSumaStr equ $-numSumaStr

section .text
	global _start

_start:
	mov r11,9
	mov rax,r11
	mov [numSuma],rax
	mov rcx, numSuma
	call Itoa
	;reverir string resultante del itoa 
	mov rsi, numSuma
	call hileraInvertida
	print numSuma,longNumSuma
	jmp _exit
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
	mov rsi,num2;
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
	mov rsi, numDif
	call hileraInvertida


	mov rax,[numInt1]
	mov rbx,[numInt2]
	call calcSuma
	mov rbx,rax
	mov [numSuma],rax


	mov rcx, numSuma
	call Itoa
	;reverir string resultante del itoa 
	mov rsi, numSuma
	call hileraInvertida
;	print numSuma,longNumSuma
	print newLine,longNewLine
	
	;mov r12, numSuma
	;mov [numSumaStr],r12


;	print numDif,longNumDif


;;;	
	jmp _prueba
	mov r13,16
	_cicloPrograma:
		push rsi
		push rax
		push rcx
		print msjBase, longMsjBase
		mov r14,r13
		add r14,'0'
		mov [caracter],r14
		print caracter,longCaracter
		print msjSuma,longMsjSuma

	    mov rsi,numSuma
		call Atoi
		mov [numSumaInt],rax

		mov eax, [numSumaInt];
	    mov rbx, r13
	    mov ecx, numSumaStr
	    call baseConversion

	    mov rsi, numSumaStr
	    call hileraInvertida
	    print numSumaStr,longNumSumaStr

	    print msjDif,longMsjDif

	    mov rsi,numDif
		call Atoi
		mov [numDifInt],rax

	    mov eax, [numDifInt];recibe input
	    mov rbx, r13
	    mov ecx, numDifStr
	    call baseConversion

	    mov rsi, numDifStr
	    call hileraInvertida
	    print numDifStr,longNumDifStr
	    inc r13
	    print newLine,longNewLine
	    ;jmp _exit
	    ;cmp r13,3
	    ;je _prepararBase
	    cmp r13,13
	    je _prepararBase
	    cmp r13, 16
	    ja _exit
	    pop rsi
		pop rax
		pop rcx
	    jmp _cicloPrograma

	 _prepararBase:
	    	inc r13
	    	jmp _cicloPrograma

	    ;jmp _cicloPrograma

    _prueba:
    	mov r13,11
;;;;;;;;;;;;;;;;;;;;
;		mov rax, numSumaInt
;		mov rcx,100
;		xor rdx,rdx
;		cld 
;		rep stosb 

		mov rsi,numSuma
		call Atoi
		mov [numSumaInt],rax

	    mov eax, [numSumaInt];recibe input
	    mov rbx, 11
	    xor ecx,ecx
	    mov ecx, numSumaStr
	    call baseConversion

	    mov rsi, numSumaStr
	    call hileraInvertida
	    print numSumaStr,longNumSumaStr

	    jmp _exit

	    print newLine,longNewLine

	    print numDif,longNumDif
	    print newLine,longNewLine
	    
	;;;;;;;;;;;;;;;;;;;
		inc r13
		mov rsi,numDif
		call Atoi
		mov [numDifInt],rax

	 	mov eax, [numDifInt];
	    mov rbx, r13
	    xor ecx,ecx
	    mov ecx, numDifStr
	    call baseConversion

	    mov rsi, numDifStr
	    call hileraInvertida
	    print numDifStr,longNumDifStr

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