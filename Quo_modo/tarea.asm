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
;	%macro input 2
;		mov rdx, %2
;		mov rcx, %1
;		mov rbx, 0
;		mov rax, 3
;		int 0x80
;	%endmacro

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
		;movzx rax,al 		; Se mueve a rax con cero
		jmp .finCalcDif
	
	.num1Menor:
		sub rbx,rax ;Se resta bl con al 
		mov rax,rbx
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

_error:
	jmp _exit;Se salta a _exit para acabar el programa 


_exit:;Se finaliza el programaSe imprime una nuevalinea para permitir ver bien el texto anterior en la consola
;	print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
	;Llamada de salida
	mov rbx,0 			;RBX=codigo de salido al 80 
	mov rax,1			;RAX=funcion sys_exit() del kernel llama al sistema 
	int 0x80 			;Llamada al sistema para acabar la ejecucion del programa