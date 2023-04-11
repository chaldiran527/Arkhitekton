
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

