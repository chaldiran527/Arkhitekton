%include "aux!.asm"

section .data
	msjMenu1 db 0xA,'Ingrese el numero de la operacion que desea realizar: ',0xA,0xA
	longMsjMenu1 equ $-msjMenu1
	msjMenu2 db '1.Suma 2.Resta 3.Multiplicacion 4.Division 5.Salir del programa  ',0xA,0xA
	longMsjMenu2 equ $-msjMenu2
    msjNum1 db 'Ingrese el primer numero: '
    longMsjNum1 equ $ - msjNum1
    msjNum2 db 0xA,'Ingrese el segundo numero: '
    longMsjNum2 equ $ - msjNum2
    newLine db 0xA;Nuevalinea para separar las hileras a mostrar en la consola
    longNewLine equ $ - newLine
    msjSuma db '   Suma: ',0
    longMsjSuma equ $ - msjSuma
    msjBase db 'Base ',0
    longMsjBase equ $-msjBase
    msjBase2 db 'Base 2 ',0
    longMsjBase2 equ $-msjBase2
    msjBase8 db 'Base 8 ',0
    longMsjBase8 equ $-msjBase8
    msjBase16 db 'Base 16 ',0
    longMsjBase16 equ $-msjBase16
    msjResta db '   Resta: ',0
    longMsjResta equ $-msjResta
    msjError db 0xA,'ERROR: Usted acaba de ingresar un numero invalido!',0xA
    longMsjError equ $ - msjError
    msjErrorOf db 'ERROR: Resultado de la suma supera los 64 bits, hay overflow!',0
    longMsjErrorOf equ $-msjErrorOf
    msjErrorInput db 'ERROR: Usted ingreso una opcion invalida, intente nuevamente y seleccione un digito del 1 al 5 segun corresponda',0
    longMsjErrorInput equ $-msjErrorInput
    msjContinuacion db 'Digite 1 si desea intentar ingresar nuevamente el numero   ',0
    longMsjContinuacion equ $-msjContinuacion
    msjSalida db 'Digite cualquier otra tecla si desea terminar el programa-> ',0
    longMsjSalida equ $-msjSalida
    signoNeg db '-',0
    longSignoNeg equ $-signoNeg
    msjResultSuma db 'Resultado de la suma: ',0
    longMsjResultSuma equ $-msjResultSuma
    msjResultResta db 'Resultado de la resta: ',0
    longMsjResultResta equ $-msjResultResta
    msjResultMul db 'Resultado de la multiplicacion: ',0
    longMsjResultMul equ $-msjResultMul
    msjResultDiv db 'Resultado de la division: ',0
    longMsjResultDiv equ $-msjResultDiv

section .bss
	input1 resb 100
	longInput1 equ $-input1
    input2 resb 100
    longInput2 equ $-input2
    caracter resb 100
    longCaracter equ $-caracter
    result1 resb 100
    lenResult1 equ $-result1
    result2 resb 100
    lenResult2 equ $-result2
    resultSuma resb 100
    longResultSuma equ $-resultSuma
    resultResta resb 100
    longResultResta equ $-resultResta
    resultMul resb 100
    longResultMul equ $-resultMul
    resultDiv resb 100
    longResultDiv equ $-resultDiv
    num1 resb 100
    longNum1 equ $-num1
    num2 resb 100
    longNum2 equ $-num2
    lenNumero1 resb 100;
    longLenNumero1 equ $-lenNumero1
;lenNumero2 almacena la cantidad de digitos del numero2
    lenNumero2 resb 100;
    longLenNumero2 equ $-lenNumero2
    numInt1 resb 100
    longNumInt1 equ $-numInt1
    numInt2 resb 100
    longNumInt2 equ $-numInt2
;numSuma almacena la suma de los dos numeros ingresados
    numSuma resb 100
    longNumSuma equ $-numSuma
;numDif almacena la diferencia de los dos numeros ingresados 
    numResta resd 100
    longNumResta equ $-numResta
;numMul almacena la multiplicacion de los dos numeros ingresados
    numMul resb 100
    longNumMul equ $-numMul
;numDiv almacena la division de los dos numeros ingresados
	numDiv resb 100
	longNumDiv equ $-numDiv

section .text
	global _start

_start:
	;Se muestran los mensajes del menu del programa
	print msjMenu1,longMsjMenu1
	print msjMenu2,longMsjMenu2

	;Se recibe el input de la opcion del usuario 
	input input1,longInput1
	print newLine,longNewLine

    mov rdi, input1   ;rdi es el parametro 
    call lenHilera  ;rax almacena el resultado
    cmp rax,1      ;En caso de ser mayor a 20 se salta al error
    ja _errorInput

	;Se compara si el usuario decidio salir del programa
	cmp byte[input1],'5' ;Se compara con la opcion numero 5
	je _exit   			 ;Se salta al label de salida del programa 

    ;Se valida que el input del usuario es un numero entre 1 a 5
    cmp byte[input1],'1'
    jb _errorInput

    cmp byte[input1],'5'
    ja _errorInput

_startNum1:;Se recibe y valida el input del primer numero 
	print msjNum1,longMsjNum1
    input num1, longNum1
    ;Se verifica si el primer numero ingresado es menor a 20 digitos 
    mov rdi, num1   ;rdi es el parametro 
    call lenHilera  ;rax almacena el resultado
    cmp rax,20      ;En caso de ser mayor a 20 se salta al error
    ja _errorNum1
    mov [lenNumero1],rax
    
    ;===Se ejecuta  el proc de atoi de num1 
    mov rsi,num1;Se mueve a rsi el string numerico ingresado por el input, parametro para el procedimiento 
    call Atoi
    mov [numInt1], rax   ;Se guarda el resultado post Atoi en numInt1

_startNum2:;Se recibe y valida el input del segundo numero 
    print msjNum2, longMsjNum2
    input num2, longNum2

    ;Se verifica si el segundo numero ingresado es menor a 20 digitos 
    mov rdi, num2   ;rdi es el parametro 
    call lenHilera  
    cmp rax,20      ;En caso de ser mayor a 20 se salta al error
    ja _errorNum2
    mov [lenNumero2],rax

    ;===Se ejecuta  el proc de atoi de num2
    mov rsi,num2;
    call Atoi
    mov [numInt2], rax ;Se guarda el resultado post Atoi en numInt2

    ;Condicionales para saltar a los labels segun el input del usuario 
    ;Comprobar si el usuario decidio hacer una suma 
	cmp byte[input1],'1' ;Se compara con la opcion numero 1
	je _suma  			 ;Se salta al label de suma   

    ;Comprobar si el usuario decidio hacer una resta
	cmp byte[input1],'2' ;Se compara con la opcion numero 2
	je _resta		 ;Se salta al label de resta

	;Comprobar si el usuario decidio hacer una multiplicacion
	cmp byte[input1],'3' ;Se compara con la opcion numero 3
	je _multiplicacion	 ;Se salta al label de multiplicacion

	;Comprobar si el usuario decidio hacer una suma 
	cmp byte[input1],'4' ;Se compara con la opcion numero 4
	je _division   			 ;Se salta al label de division

    ;Se devuelve al inicio del programa 
    print newLine,longNewLine 
    print newLine,longNewLine
	jmp _start

_suma:  ; Seccion donde se realiza la suma de los dos numeros ingresados
    ;===Se ejecuta el proc de suma de los dos numeros enteros
    mov rax,[numInt1]
    mov rbx,[numInt2]
    call calcSuma   
    ;En el procedimiento de calcsuma se verifico si hubo overflow 
    mov [numSuma],rax ;rax tiene resultado

    mov rax, [numSuma]  ;Se mueve a rax el numero a convertir de la suma
    mov rbx, 10
    xor rcx,rcx         ;Se mueve a rax el numero a convertir de la diferencia
    mov rcx, resultSuma ;Se almacena el resultado de la conversion en resultSuma
    call conversionBase    ;Se llama al procedure para convertir a la base decimal

    mov rsi, resultSuma    ;rsi va como parametro 
    call hileraInvertida      ;Se invierte la hilera con el string del numero convertido


	print newLine,longNewLine

    ;Se imprime el resultado de la suma
	print msjResultSuma,longMsjResultSuma
    print resultSuma,longResultSuma  ;Se imprime el numero post conversion

    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultSuma
    mov rcx,100
    xor rax,rax
    rep stosb 

	;Se hace una pausa para que el usuario pueda apreciar el resultado 
	print newLine,longNewLine 
    print newLine,longNewLine
	jmp _exit

_resta:  ; Seccion donde se realiza la resta de los dos numeros ingresados
    ;===Se ejecuta el proc de suma de los dos numeros enteros
    mov rax,[numInt1]
    mov rbx,[numInt2]
    cmp rax,rbx
    jb _restaNegativa
    call calcResta       
    mov [numResta],rax ;rax tiene resultado

    mov rax, [numResta]           ;Se mueve a rax el numero a convertir de la diferencia
    mov rbx, 10
    xor rcx,rcx
    mov rcx, resultResta          ;Se almacena el resultado de la conversion en resultDif
    call conversionBase           ;Se llama al procedure para convertir a la base actual en r13

    mov rsi, resultResta          ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido

	print newLine,longNewLine
    ;Se imprime el resultado de la resta
    print msjResultResta,longMsjResultResta
    print resultResta,longResultResta
    ;Se hace una pausa para que el usuario pueda apreciar el resultado 

    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultResta
    mov rcx,100
    xor rax,rax
    rep stosb 
    print newLine,longNewLine 
    print newLine,longNewLine
	jmp _exit

_restaNegativa:;Se salta a este label en caso de que el primer operando sea mayor, es decir el resultado sera negativo
    call calcResta       
    mov [numResta],rax ;rax tiene resultado

    mov rax, [numResta]           ;Se mueve a rax el numero a convertir de la diferencia
    mov rbx, 10
    xor rcx,rcx
    mov rcx, resultResta          ;Se almacena el resultado de la conversion en resultDif
    call conversionBase           ;Se llama al procedure para convertir a la base actual en r13

    mov rsi, resultResta          ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido

    print newLine,longNewLine
    ;Se imprime el resultado de la resta
    print msjResultResta,longMsjResultResta
    print signoNeg,longSignoNeg
    print resultResta,longResultResta
    ;Se hace una pausa para que el usuario pueda apreciar el resultado 

    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultResta
    mov rcx,100
    xor rax,rax
    rep stosb 
    print newLine,longNewLine 
    print newLine,longNewLine
    jmp _exit

_multiplicacion: ; Seccion donde se realiza la multiplicacion de los dos numeros ingresados
    ;===Se ejecuta la multiplicacion de los dos numeros enteros
    mov rax,[numInt1]
    mov rcx,[numInt2]
    mul rcx
    jo _mulOverflow
    mov [numMul],rax 

    mov rax, [numMul]           ;Se mueve a rax el numero a convertir de la multiplicacion
    mov rbx, 10
    xor rcx,rcx
    mov rcx, resultMul          ;Se almacena el resultado de la conversion en resultMul
    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

    mov rsi, resultMul         ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
   
    ;Se imprime el numero multiplicado 
	print newLine,longNewLine
	print msjResultMul,longMsjResultMul
    print resultMul,longResultMul
    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultMul
    mov rcx,100
    xor rax,rax
    rep stosb 
    print newLine,longNewLine 
    print newLine,longNewLine
	jmp _exit

_mulOverflow:;Se salta a este label en caso de que el resultado de multiplicacion tenga overflow
    mov [numMul],rax 

;Se imprime el resultado en base binaria,octal y hexadecimal:
    mov rax, [numMul]           ;Se mueve a rax el numero a convertir de la multiplicacion
    mov rbx, 2
    xor rcx,rcx
    mov rcx, resultMul          ;Se almacena el resultado de la conversion en resultMul
    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

    mov rsi, resultMul         ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
   
    ;Se imprime el numero multiplicado 
    print newLine,longNewLine
    print msjBase2, longMsjBase2
    print msjResultMul,longMsjResultMul
    print resultMul,longResultMul
    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultMul
    mov rcx,100
    xor rax,rax
    rep stosb 
    print newLine,longNewLine 
    print newLine,longNewLine


    mov rax, [numMul]           ;Se mueve a rax el numero a convertir de la multiplicacion
    mov rbx, 8
    xor rcx,rcx
    mov rcx, resultMul          ;Se almacena el resultado de la conversion en resultMul
    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

    mov rsi, resultMul         ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
   
    ;Se imprime el numero multiplicado 
    print newLine,longNewLine
    print msjBase8, longMsjBase8
    print msjResultMul,longMsjResultMul
    print resultMul,longResultMul
    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultMul
    mov rcx,100
    xor rax,rax
    rep stosb 


    mov rax, [numMul]           ;Se mueve a rax el numero a convertir de la multiplicacion
    mov rbx, 16
    xor rcx,rcx
    mov rcx, resultMul          ;Se almacena el resultado de la conversion en resultMul
    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

    mov rsi, resultMul         ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
   
    ;Se imprime el numero multiplicado 
    print newLine,longNewLine
    print msjBase16, longMsjBase16
    print msjResultMul,longMsjResultMul
    print resultMul,longResultMul
    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultMul
    mov rcx,100
    xor rax,rax
    rep stosb 
    jmp _exit

_division:  ; Seccion donde se realiza la division de los dos numeros ingresados
    mov r9,[numInt1]
    mov r10,[numInt2]
    ;Se verifica si el primer operando es menor que el segundo 
    cmp r9,r10
    jb _divNum1Menor ;Saltar a este label en caso de ser menor 
    mov rax,[numInt1]
    mov rcx,[numInt2]
    mov rdx, 0
    div rcx

    mov [numDiv],rax            ;

    mov rax, [numDiv]           ;Se mueve a rax el numero a convertir de la multiplicacion
    mov rbx, 10
    xor rcx,rcx
    mov rcx, resultDiv          ;Se almacena el resultado de la conversion en resultMul
    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

    mov rsi, resultDiv         ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
   
    ;Se imprime el numero dividido 
	print newLine,longNewLine
	print msjResultDiv,longMsjResultDiv
    print resultDiv,longResultDiv
	;Se hace una pausa para que el usuario pueda apreciar el resultado 

    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultDiv
    mov rcx,100
    xor rax,rax
    rep stosb 
    print newLine,longNewLine 
    print newLine,longNewLine
	jmp _exit

_divNum1Menor:
    mov rax,[numInt2]
    mov rcx,[numInt1]
    mov rdx, 0
    div rcx

    mov [numDiv],rax            ;

    mov rax, [numDiv]           ;Se mueve a rax el numero a convertir de la multiplicacion
    mov rbx, 10
    xor rcx,rcx
    mov rcx, resultDiv          ;Se almacena el resultado de la conversion en resultMul
    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

    mov rsi, resultDiv         ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
   
    ;Se imprime el numero dividido 
    print newLine,longNewLine
    print msjResultDiv,longMsjResultDiv
    print resultDiv,longResultDiv
    ;Se hace una pausa para que el usuario pueda apreciar el resultado 

    ;Se reinicializa en cero con 100 bytes a la variable resultSuma
    mov rbx,resultDiv
    mov rcx,100
    xor rax,rax
    rep stosb 
    print newLine,longNewLine 
    print newLine,longNewLine
    jmp _exit


_error:;Seccion en donde se le indica al usuario que hubo un error
    print msjError,longMsjError;Se imprime el mensaje de error
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
    jmp _exit;Se salta a _exit para acabar el programa 

_errorInput:
    print newLine,longNewLine
    print msjErrorInput,longMsjErrorInput
    print newLine,longNewLine
    jmp _exit

_errorOverflow:
    print newLine,longNewLine; 
    print msjErrorOf,longMsjErrorOf
	jmp _exit

_errorNum1:
    ;Se limpia el registro de num2
    mov rbx, num1
    mov rcx,100
    xor rax,rax
    rep stosb
    ;Se le ofrece al usuario la opcion de continuar o acabar el programa
    print newLine,longNewLine
    print msjError, longMsjError
    print newLine,longNewLine; 
    print msjContinuacion,longMsjContinuacion
    print newLine,longNewLine
    print msjSalida,longMsjSalida
    ;Se recibe el input de la opcion del usuario 
    input input2,longInput1
    print newLine,longNewLine
    cmp byte[input2],'1'
    je _startNum1
    jmp _exit

_errorNum2:
    ;Se limpia el registro de num2
    mov rbx, num2 
    mov rcx,100
    xor rax,rax
    rep stosb 
    ;Se le ofrece al usuario la opcion de continuar o acabar el programa
    print newLine,longNewLine
    print msjError, longMsjError
    print newLine,longNewLine;   
    print msjContinuacion,longMsjContinuacion  
    print newLine,longNewLine
    print msjSalida,longMsjSalida
    ;Se recibe el input de la opcion del usuario 
    input input2,longInput1
    print newLine,longNewLine
    cmp byte[input2],'1';Si es igual a 1 se continua el programa
    je _startNum2
    jmp _exit

_exit:;Se finaliza el programa
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola


    ;Llamada de salida
    mov rbx,0           ;RBX=codigo de salido al 80 
    mov rax,1           ;RAX=funcion sys_exit() del kernel llama al sistema 
    int 0x80            ;Llamada al sistema para acabar la ejecucion del programa
