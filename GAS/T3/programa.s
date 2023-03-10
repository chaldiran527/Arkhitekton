#============================================================

#Programa que convierte caracteres de minusucula a mayuscula y viceversa
#en una cadena de caracteres ingresada desde el teclado.
#Autores:
#       Carlos Dario
#       Juan Mallma 
#============================================================
.section .data
#   Se inicializan las hileras que se le muestran al usuario 
    msj1: .ascii "GAS!!Ingrese una cadena de caracteres alfabeticos a ser convertida:"
    longMsj1 = . - msj1
    msjError: .ascii "\nError: La hilera tiene valores no alfabeticos."
    longMsjError = . - msjError

.section .bss
    hilera: .space 255
    longInputHilera = . - hilera
    caracter: .space 2

.section .text
    .global _start
    
_start:
    # Se imprime el mensaje pidiendo que se ingrese el texto
    mov $4, %rax
    mov $1, %rbx
    mov $msj1, %rcx
    mov $longMsj1, %rdx
    int $0x80
    
    #Se recibe el input del usuario
    mov $3, %rax
    mov $0, %rbx
    mov $hilera, %rcx
    mov $longInputHilera, %rdx
    int $0x80
    
    mov hilera, %rsi
    jmp _loop
    
_loop:
    mov (%rsi), %al#Se mueve a 'al' el contenido al que apunta actualmente rsi
    cmp $0xA, %rsi#Verificar si se llego al final de la hilera
    je _exito#finaliza el ciclo
    inc %rsi#Se incrementa en uno la direccion de rsi 
    mov %al, caracter#Se cambia el contenido en caracter con el contenido de al
    jmp _convertirCaracter#Se manda a convertir al caracter
    
_convertirCaracter:
#Se verifica si el caracter es valido antes de mandarlo a hacer la conversion
    cmp $0x20, %al
    je _printCaracter
    
    cmp $0x40, %al#verificar si es menor que 'A' 
    jb _error
    
    cmp $0x5B, %al#verificar si es menor que 'Z'
    jb _mayusculaAMinuscula
    
    cmp $0x7A, %al#verificar si es mayor que 'z'
    ja _error
    
    cmp $0x60, %al#verificar si es mayor que 'a'
    ja _minusculaAMayuscula
    
    jmp _error#mandar a ejecutar el error
    
_mayusculaAMinuscula:
#Se hace la conversion de mayuscula a minuscula
    addb $32, caracter(%rsi)
    mov %r9, caracter
    mov $1, %rdx
    mov caracter, %rcx
    mov $4, %rax
    int $0x80
    jmp _loop
    
_minusculaAMayuscula:
#Se hace la conversion de minuscula a mayuscula
    subb $32, caracter(%rsi)
    mov %r9, caracter
    mov $1, %rdx
    mov caracter, %rcx
    mov $4, %rax
    int $0x80
    jmp _loop
    
_printCaracter:
#se imprime el caracter convertido en pantalla 
    mov $1, %rdx
    mov caracter, %rcx
    mov $4, %rax
    int $0x80
    jmp _loop
    
_error:
#se escribe el mensaje indicando que el usuario ingreso una hilera invalida
    mov $4, %rax
    mov $1, %rbx
    mov $msjError, %rcx
    mov $longMsjError, %rdx
    int $0x80
    jmp _exito
    
_exito:
#se finaliza el programa llamando al sistema 
    movq $0, %rbx
    movq $1, %rax
    int $0x80
    
   
  
 
 
