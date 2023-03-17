#===========================================================
#Programa que calcula la suma y la diferencia de dos numeros ingresados desde el teclado 
#Autores:
#		Juan Mallma
#		Carlos Dario 
#===========================================================

	.macro print hilera,long
		mov $4, %eax
		mov $1, %ebx
		mov \hilera, %ecx
		mov \long, %edx
		int $0x80
	.endm

	.macro input entrada,long
		mov \long, %edx
		mov \entrada, %ecx
		mov $0, %ebx
		mov $3, %eax
		int $0x80
	.endm

.section .data
	msj1: .ascii "Ingrese el primer numero: "
	longMsj1 = . - msj1
	msj2: .ascii "\nIngrese el segundo numero: "
	longMsj2 = . - msj2
	msjSuma: .ascii "\nSuma de ambos numeros es: "
	longMsjSuma =.-msjSuma
	msjDif: .ascii "\nDiferencia de ambos numeros es: "
	longMsjDif =.-msjDif
	msjError: .ascii "\nERROR: Usted acaba de ingresar un numero invalido!\n"
	longMsjError =.-msjError
	newLine: .ascii "\n"
	longNewLine =.-newLine
	numstr: .ascii "1334"
	longNumStr =.-numstr

.section .bss
	num1: .space 4
	longNum1 = . - num1
	num2: .space 4
	longNum2 = . - num2
	numSuma: .space 4
	longNumSuma = . - numSuma
	numDif: .space 4
	longNumDif = . - numDif
	nuevaLinea: .space 4
	caracter: .space 2
	longCaracter =.-caracter
	numInt1: .space 4
	longNumInt1 =.-numInt1
	numInt2: .space 4
	longNumInt2 =.-numInt2
	digito: .space 8
	longDigito = . - digito

.section .text
	.global _start

	_start:
	#Se pide y se recibe el input de los dos numeros a operar
	print $msj1, $longMsj1
	input $num1, $longNum1
	print $msj2, $longMsj2
	input $num2, $longNum2

	movq num1,%rax#Se mueve el numero 1 a rax
	add  num2,%rax#Se suma el numero2 a rax
	movq %rax,(numSuma)#Se mueve a numsuma el resultado almacenado en rax
	movq $10,%rbx#Se mueve un 10 que es la base decimal a rbx
	movq numSuma,%rcx #Se mueve numsuma a rcx
    	jmp _itoaLoop# Se salta al ciclo para pasar de entero a ascii

#CIclo para convertir de entero a ascii
_itoaLoop:
	xorq %rdx, %rdx         
	divq %rbx            #Dividr rbx   
	addq $48, %rdx       #sumar 49 para el codigo ascii
	mov %dl,(digito)
	movq (digito),%rcx
    	incq %rcx            #incrementar el contador de la posicion actual del registro iterado
    	cmpq $0,%rax         #verificar si es igual que cero 
    	jne _itoaLoop        #Si es diferente se continua el loop

#Se imprime el mensaje indicando la suma de los dos numeros 
        print $msjSuma,$longMsjSuma
    	movq numSuma, %rsi
    	add $2,%rsi
    	jmp _contarReves


_contarReves:# Se imprimen los caracteres al reves de la hilera
	cmpq numSuma,%rsi
	je _exit
	decq %rsi
	movb (%rsi), %al
	movb %al,(caracter)
	print $caracter,$longCaracter
	jmp _contarReves


_exit:#Se finaliza el programa llamando al sistema
	movq $1, %rax
	movq $0, %rcx
	int $0x80
