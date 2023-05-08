;===========================================================
;Programa que ordena alfabeticamente una palabra en un archivo de texto menor a 2048 caracteres
;Autores:
;       Carlos Dario
;       Juan Mallma 
;===========================================================

%include "Procs&macros.asm"


    contarPalabras:
        xor rcx,rcx ;Contador rcx se inicializa en cero 
        cmp byte[rsi],10;Se verifica si el caracter es el newline del final
        je .finContarPalabras

        cmp byte[rsi],32;Se verifica si el caracter es espacio
        je .loopEspacios


        inc rcx;Se incrementa el contador de palabras 
        jmp .loopPalabras;Se salta al ciclo de contar palabra

    .loopPalabras:
        inc rsi;Se incrementa la posicion actual del registro de la palabra
        cmp byte[rsi],10;Se verifica si el caracter es el newline del final
        je .finContarPalabras

        cmp byte[rsi],32;Se verifica si el caracter es espacio
        je .loopEspacios

        jmp .loopPalabras;Se salta de vuelta al label de palabras pues no se ha terminado de recorrer la palabra actual


    .loopEspacios:
        inc rsi;Se incrementa la posicion actual del registro de la palabra

        cmp byte[rsi],10
        je .finContarPalabras

        cmp byte[rsi],32
        je .loopEspacios
        ;
        inc rcx;Se incrementa el contador de palabras 
        jmp .loopPalabras

    .finContarPalabras:;Se finaliza este procedimiento ya no hay mas caracteres que contar
        ret


ordenarPalabra:
    mov rbx, rsi;Se mueve la direccion del registro de la hilera a rbx
    mov rdi, rcx ;Se mueve el registro del largo de esta hilera a rdi 

    dec rdi ;Se decrementa el contador
    cmp rdi, 0 ;se verifica si es cero 
    jle .finOrdenarPalabra ;Si es menor o igual se salta al final de este procedimiento 
    ;Sino se salta a ordenar los caracteres 
    jmp .loopOrdenamiento

.loopOrdenamiento:
    ;Se mueve el caracter actual que se esta iterando 
    mov al, [rbx]
    ;Se compara con el siguiente caracter
    cmp al, [rbx+1]
    ;Si es menor o igual se procede a comparar el siguinte caracter
    jbe .sigCambio 

;Sino se cambia la posicion de los caracteres
;Se mueve a dl el siguiente caracter que es menor
    mov dl,[rbx+1]
;Se mueve al a la posicion del siguiente caracter
    mov [rbx+1],al 
;Ahora dl esta en la posicion ue tenia al del primer caracter 
    mov [rbx], dl 
;Se salta al label en donde se continua la iteracion
    jmp .sigCambio
    

.sigCambio:
    inc rbx ;Se incrementa la posicion actual de la hilera
    dec rdi ;Se decrementa el contador rdi
    cmp rdi, 0;Se verifica si el contador es cero
    jg .loopOrdenamiento;Si es mayor se continua el ordenamiento

;Se disminuye el contador rcx
    dec rcx 
;Se verifica si es uno para saber si se continua o finaliza el ordenamiento
    cmp rcx, 1
    jg ordenarPalabra
    jmp .finOrdenarPalabra

.finOrdenarPalabra:
    ;Se ha llegado al fin de este procedimiento 
    ret


ordenarPalabras:
    mov rbx,rsi ;Se mueve a rbx el registro rsi de la hilera
    mov rdi,rcx ;Se mueve a rdi el registro rcx del largo de la hilera

.loopPalabras: 
    dec rdi ;Se decrementa en uno el largo actual de la hilera
    cmp rdi,0 ;Se verifica si es menor o igual que cero
    jle .finOrdenarPalabras 

    mov rcx, rdi   ;Se mueve a rcx la pos actual en rdi 
    mov rsi, rbx  ;Se mueve a rsi la hilera actual de la palabra a ordenar
    call ordenarPalabra ;Se ordena la palabra actual de la hilera llamando a este procedimiento

    add rbx,rcx ;Se mueve rbx al inicio de la siguiente palabra
    jmp .loopPalabras;Se salta de vuelta a este ciclo 

.finOrdenarPalabras:;Se finaliza el ordenamiento de palabras
    ret 



section .data 
    newLine db 0xA
    longNewLine equ $-newLine
    msjError db 'Error los caracteres son mas de 2048!',0
    longMsjError equ $-msjError
    msjCant db 'Cantidad de palabras: ',0
    longMsjCant equ $-msjCant
    msj1 db 'Hilera del archivo de texto: ',0
    longMsj1 equ $-msj1
    msj2 db 'Hilera ordenada: '
    longMsj2 equ $-msj2
    archivo db 'archivo.txt',0

section .bss 
    ingre resb 100
    lenIngre equ $-ingre
    caracter resb 100
    longCaracter equ $-caracter 
    palabra resb 100
    longPalabra equ $-palabra 
    buff resb 256
    numPalabrasInt resb 100
    longNumPalabrasInt equ $-numPalabrasInt
    numPalabras resb 100
    longNumPalabras equ $-numPalabras
    archivoTexto resb 100
    longArchivoTexto equ $-archivoTexto

section .text
    global _start

_start:
;Se abre el archivo de texto a leer
    mov rax,5
    mov rbx,archivo
    mov rcx,'r';Modo de lectura
    int 0x80

    mov rbx,rax   

    ;Se leen los contenidos del archivo
    mov rax,3
    mov rcx,archivoTexto
    mov rdx,longArchivoTexto
    mov rbx,rax
    int 0x80

;Se verifica que el archivo de texto sea menor que 1024 caracteres

    mov rdi,archivoTexto
    call lenHilera
    cmp rax,1024
    ja _error


;Se imprime la hilera del archivo de texto antes de ser ordenada 
 
    print msj1,longMsj1
    print archivoTexto,longArchivoTexto
    print newLine,longNewLine

    ;Se llama al procedimiento ordenar palabras para que ordene el string de acuerdo a su longitud
    mov rsi,archivoTexto
    mov rcx,longArchivoTexto
    call ordenarPalabras 


    ;Se imprime la hilera ordenada alfabeticamente
    print msj2,longMsj2
    print archivoTexto,longArchivoTexto ;Se imprime la hilera ordenada 


;Se calcula la cantidad de palabras de la hilera 
    mov rsi,archivoTexto
    call contarPalabras
    mov [numPalabras],rcx

    mov rax, [numPalabras]           ;Se mueve a rax el numero a convertir a base 10
    mov rbx, 10
    xor rcx,rcx
    mov rcx, numPalabrasInt          ;Se almacena el resultado de la conversion 
    call conversionBase           ;Se llama al procedure para convertir a la base decimal 

    mov rsi, numPalabrasInt         ;rsi va como parametro 
    call hileraInvertida        ;Se invierte la hilera con el string del numero convertido
;Se imprime el numero de la cantidad de palabras presentes en la hilera que ha sido ordenada 
    print newLine,longNewLine
    print newLine,longNewLine
    print msjCant,longMsjCant
    print numPalabrasInt,longNumPalabrasInt
    print newLine,longNewLine


;Se llama al label para finalizar el programa 
    jmp _exit
    
_error:;Seccion en donde se le indica al usuario que hubo un error
    print msjError,longMsjError;Se imprime el mensaje de error
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola
    jmp _exit;Se salta a _exit para acabar el programa 



_exit:;Se finaliza el programa
    print newLine,longNewLine; Se imprime una nuevalinea para permitir ver bien el texto anterior en la consola

    ;Llamada de salida
    mov rbx,0           ;RBX=codigo de salido al 80 
    mov rax,1           ;RAX=funcion sys_exit() del kernel llama al sistema 
    int 0x80            ;Llamada al sistema para acabar la ejecucion del programa

