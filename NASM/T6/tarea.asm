
;===========================================================
;Programa que calcula la suma y la diferencia de dos numeros ingresados y hace su conversion en bases 2 a 16 
;Autores:
;       Carlos Dario
;       Juan Mallma 
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


;Macro para recibir un input desde consola con 1 parametro(%1 de la hilera que almacenara el input,%2 del largo de la hilera del input)
    %macro input 2
        mov rdx, %2
        mov rcx, %1
        mov rbx, 0
        mov rax, 3
        int 0x80
    %endmacro

;Procedure para hacer la conversion a base n que se pasa por el registro ebx
    conversionBase:
        ;xor ecx,ecx
        jmp .cicloDivision

    .cicloDivision:
        xor edx, edx    ;Se reinicializa en cero al regsitro edx para evitar artihmetic exception
        div ebx         ;Se divide el numero por la base n a convertir
        cmp edx, 10     ;Se comprueba que el residuo sea menor que 10
        jl .sumarDigito ;En caso de ser menor que 10 se suma salta sumarDIgito
        add edx, 'A' - 10 ;Si el residuo es mayor que 10 se suma el valor de la letra para el hexadecimal 
        jmp .almacenarDigito 

    .sumarDigito:
        add edx,'0'     ;Se suma el digito con su valor ascii + 48
        jmp .almacenarDigito

    .almacenarDigito:
        mov byte [ecx], dl ;Se mueve el digito actual en edx a la hilera resulante que es apuntada por ecx
        inc ecx            ;Se incrementa la posicion de ecx
        cmp eax, 0         ;Se verifica si el digito es cero
        jnz .cicloDivision 

    .finConversionBase: ;Se finaliza la conversion
        mov byte[ecx],0   
        ret

section .data
    inputA: dd 1000
    msj1 db 'Ingrese el primer numero: '
    longMsj1 equ $ - msj1
    msj2 db 0xA,'Ingrese el segundo numero: '
    longMsj2 equ $ - msj2
    newLine db 0xA;Nuevalinea para separar las hileras a mostrar en la consola
    longNewLine equ $ - newLine
    msjSuma db '   Suma: ',0
    longMsjSuma equ $ - msjSuma
    msjBase db 'Base ',0
    longMsjBase equ $-msjBase
    msjDif db '   Diferencia: ',0
    longMsjDif equ $-msjDif
    msjGeneral db 'A continuacion se muestran la suma y diferencia de estos dos numeros en orden ascendente desde base 2 hasta base 16:'
    longMsjGeneral equ $-msjGeneral
    msjError db 0xA,'ERROR: Usted acaba de ingresar un numero invalido!',0xA
    longMsjError equ $ - msjError

section .bss
    result1 resb 100
    lenResult1 equ $-result1
    result2 resb 100
    lenResult2 equ $-result2
    resultSuma resb 100
    longResultSuma equ $-resultSuma
    resultDif resb 100
    longResultDif equ $-resultDif
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
    numDif resd 100
    longNumDif equ $-numDif
    caracter resb 100
    longCaracter equ $-caracter

section .text
    global _start
    
_start:
    print msj1,longMsj1
    input num1, longNum1
    ;Se verifica si el primer numero ingresado es menor a 20 digitos 
    mov rdi, num1   ;rdi es el parametro 
    call lenHilera  ;rax almacena el resultado
    cmp rax,20      ;En caso de ser mayor a 20 se salta al error
    ja _error
    mov [lenNumero1],rax
    
    ;===Se ejecuta  el proc de atoi de num1 
    mov rsi,num1;Se mueve a rsi el string numerico ingresado por el input, parametro para el procedimiento 
    call Atoi
    mov [numInt1], rax   ;Se guarda el resultado post Atoi en numInt1

    print msj2, longMsj2
    input num2, longNum2

    ;Se verifica si el segundo numero ingresado es menor a 20 digitos 
    mov rdi, num2   ;rdi es el parametro 
    call lenHilera  
    cmp rax,20      ;En caso de ser mayor a 20 se salta al error
    ja _error
    mov [lenNumero2],rax

    ;===Se ejecuta  el proc de atoi de num2
    mov rsi,num2;
    call Atoi
    mov [numInt2], rax ;Se guarda el resultado post Atoi en numInt2


    ;===Se ejecuta el proc de suma y resta de los dos numeros enteros
    mov rax,[numInt1]
    mov rbx,[numInt2]
    call calcSuma       
    mov [numSuma],rax ;rax tiene resultado

    mov rax,[numInt1]
    mov rbx,[numInt2]
    call calcDif        
    mov [numDif],rax ;rax tiene resultado

    ;Se imprime el mensaje describiendo las conversiones de bases a mostrar en la pantalla
    print newLine,longNewLine
    print msjGeneral,longMsjGeneral
    print newLine,longNewLine

    mov r13,2 ;contador de la base actual a convertir
;Ciclo _loopConversion donde se convierte e imprime de bases 2 a 16
    _loopConversion:
        print newLine,longNewLine
        print msjBase,longMsjBase

        ;Se imprime el numero actual de la base que se esta convirtiendo en esta iteracion del ciclo 
        mov rax,r13
        mov [caracter],rax
        mov rcx, caracter
        call Itoa
        ;revertir string resultante del itoa 
        mov rsi, caracter
        call hileraInvertida
        print caracter,longCaracter


        print msjSuma,longMsjSuma

        mov rax, [numSuma]  ;Se mueve a eax el numero a convertir de la suma
        mov rbx, r13
        xor rcx,rcx         ;Se mueve a eax el numero a convertir de la diferencia
        mov rcx, resultSuma ;Se almacena el resultado de la conversion en resultSuma
        call conversionBase    ;Se llama al procedure para convertir a la base actual en r13

        mov rsi, resultSuma ;rsi va como parametro 
        call hileraInvertida      ;Se invierte la hilera con el string del numero convertido
        print resultSuma,longResultSuma  ;Se imprime el numero post conversion

       ;Se reinicializa en cero con 100 bytes a la variable resultSuma
        mov rbx,resultSuma
        mov rcx,100
        xor rax,rax
        rep stosb 

        print msjDif,longMsjDif     ;Se imprime el mensaje de Diferencia:

        mov eax, [numDif]           ;Se mueve a eax el numero a convertir de la diferencia
        mov rbx, r13
        xor ecx,ecx
        mov ecx, resultDif          ;Se almacena el resultado de la conversion en resultDif
        call conversionBase           ;Se llama al procedure para convertir a la base actual en r13

        mov rsi, resultDif          ;rsi va como parametro 
        call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
        print resultDif,longResultDif ;Se imprime el numero post conversion


      ;Se reinicializa en cero con 100 bytes a la variable resultDif
        mov rbx,resultDif
        mov rcx,100
        xor rax,rax
        rep stosb 

        print newLine,longNewLine

        inc r13         ;Se incrementa el contador de la base n  a convertir
        cmp r13,16      ;Se compara si r13 es mayor que 16
        ja _exit        ;Salir del programa en caso de ser mayor

        jmp _loopConversion     ;Repetir el ciclo de conversion 

_error:
    print msjError,longMsjError;Se imprime el mensaje de error
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
    jmp _exit;Se salta a _exit para acabar el programa 

_exit:;Se finaliza el programa
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
;   print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
    ;Llamada de salida
    mov rbx,0           ;RBX=codigo de salido al 80 
    mov rax,1           ;RAX=funcion sys_exit() del kernel llama al sistema 
    int 0x80            ;Llamada al sistema para acabar la ejecucion del programa








;Macro para convertir de ascii a entero y de entero a ascii a un registro apuntando a una hilera
    %macro revertirNumStr 1
        mov rsi,%1;Parametro rsi para el Atoi
        call Atoi ;Se llama al procedimiento para convertir de ascii a entero
        mov [%1], rax ;Se almacena en el registro del parametro la representacion del  numero entero
        mov rcx, %1   ;Parametro rcx del numero para convertir a ascii
        call Itoa     ;Se llama al procedimiento para convertir el numero entero a caracteres ascii
    %endmacro

;Store procedure xd para calcular el numero de caracteres de una hilera 
    lenHilera:
        xor rax,rax ;set counter to zero
        
    .cicloLenHilera:
        cmp byte [rdi],10;Se verifica si es un new line
        je .finCicloLenHilera
        inc rax ;Se incrementa el contador
        inc rdi ;Se incrementa la posicion actual del registro de la hilera
        jmp .cicloLenHilera

    .finCicloLenHilera: ;Se finaliza el procedmimento 
        ret

;Procedure para convertir un numero de ascii a decimal pasado por parametro en un registro 

    Atoi:
        ;Se limpian los registros a usar rbx  y  rcx
        xor rbx,rbx
        xor rcx,rcx
        jmp .cicloAtoi

    .cicloAtoi:
        cmp byte[rsi],10;Se compara si el caracter actual es el newline 10 en ascii
        je .finAtoi;Si es igual a 10 se salta a atoi1End terminando este ciclo

        cmp byte[rsi],0;Se compara si el caracter actual es cero(nulo/null)
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

    .finAtoi:;Se finaliza el procedimiento 
        mov rax,rbx; Se mueve a rax el numero resultante post Atoi
        ret

;Procedure para convertir un numero en decimal a ascii pasado por parametro en un registro  
    Itoa:
        ;Se limpian los registros a utilizar en este procedimiento
        mov rdi,rcx     ;Se mueve a rdi la posicion del numero a convertir a ascii
        mov rsi,0       ;Se limpia en cero el registro rsi
        mov rcx,0       ;Se limpia en cero el registro rcx
        mov rbx,10      ;Base decimal a convertir 

        cmp rax,10      ;Se verifica que el numero no sea de un solo digito
        jb .digitoItoa  ;Si es menor que cero tiene un solo digito 
        cmp rax,0       ;Se verifica que no sea cero
        ;Si es mayor que cero se procede al ciclo para la conversion de los digitos a su valor ascii
        ;sino se mueve un 0 y se finaliza el procedmiento 
        ja .cicloItoa   
        mov byte [rdi + rsi], '0'
        inc rsi
        jmp .finItoa


    .digitoItoa:
        add rax,'0'     ;Se suma el digito en ascii del valor
        mov byte[rdi + rsi], al ;Se mueve el caracter
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
;Intento de revertir la hilera al finalizar el cicloItoa pero no funciona :( (se invierte posterior al itoa llamando al procedimiento hileraInvertida!)
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
        mov [rdi + rsi], al
        mov [rdi + rsi], ah
        dec rcx
        inc rsi
        cmp rsi,rcx
        jle .invertirNumero
        jmp .finItoa

    .finItoa:;Se finaliza el procedimiento 
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
    ;rax primer numero a restar y rbx es el segundo 
        cmp rax,rbx           ; Verificar si rax es menor que rbx 
        jb .num1Menor
        sub rax,rbx         ; Sino se resta al con rnx
        jmp .finCalcDif
    
    .num1Menor:
        sub rbx,rax ;Se resta rbx con rax
        mov rax,rbx ;Se mueve a rax el resultado de la resta en rbx 
        jmp .finCalcDif

    .finCalcDif:;Se finaliza el procedimiento
        ret



    hileraInvertida:
        mov rcx,0   ;Se limpia el registro rcx en cero
        mov r9,rsi  ;Se mueve en r9 la direccion de la hilera a invertir
        jmp .cicloA 

    .cicloA:
        cmp byte[rsi],0  ;Se comprueba si se llego al final de la hilera
        je .revertir     ;Si es igual a cero se salta al ciclo .revertir
        inc rcx          ;Se incrementa el contador de caracteres del string 
        inc rsi          ;Se incrementa la posicion actual del registro de la hilera
        jmp .cicloA      

    .revertir:
        mov rdi, r9     ;se mueve a rdi el registro r9 que apunta a la hilera
        mov rsi, r9     ;se mueve a rsi igualmente el registro r9
        add rsi, rcx    ;Se suma la cantidad de caracteres que  apuntara rsi
        dec rsi         ;se resta en uno para apuntar al ultimo caracter
        jmp .cicloB

    .cicloB:
        cmp rdi, rsi            ;Se verifica si rdi y rsi apuntan a la misma posicion en la mitad
        jge .finHileraInvertida ;
        mov al,[rdi]            ;Se mueve el caracter del final del inicio de la hilera
        xchg al,[rsi]           ;operador xchg para intercambiar del final al inicio de la hilera
        mov [rdi],al            
        inc rdi                 ;Se incrementa la posicion rdi
        dec rsi                 ;Se decrementa la posicion del redi
        jmp .cicloB             ;Se repite el ciclo

    .finHileraInvertida:;Se finaliza el procedimiento 
        ret

