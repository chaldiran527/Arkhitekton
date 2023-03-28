
section .data



Bienvenida db "Bienvenido a la tutoria de ensamblador ", 0XA
lenbienvenida equ $-Bienvenida


pregunta db "Por favor Ingrese su numero: ", 0XA
lenpregunta equ $-pregunta

error db "error",0xA
lenerror equ $-error

digits db '0123456789', 0xA





section .bss


input resb 20
resultado resb 20


section .text

global _start

	_start:
		call _imprimirbienvenida
		call _imprimirpregunta
		call _getinput
		call _imprimirinput
		call _atoi
		call _salir




	


_imprimirbienvenida:
	mov rax, 1
	mov rdi, 1
	mov rsi, Bienvenida
	mov rdx, lenbienvenida
	syscall
	ret


_imprimirpregunta:
	mov rax, 1
	mov rdi, 1
	mov rsi, pregunta
	mov rdx, lenpregunta
	syscall
	ret



_getinput:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 200
    syscall
    ret


_atoi:     ;ascii to integer
	xor r10, r10  ;para iterar por el input
	xor rax, rax ; vamos a guardar el numero
	xor r11, r11 ;aqui vamos a hacer operaciones
	mov r10, input ;movimos el input a r10
.next:
	movzx r11, byte[r10]
	cmp r11, 0xA ;para saber si ya terminamos
	je _sumar

	sub r11, '0' ;convirtiendolo a numero
	imul rax, 10 
	add rax, r11
	inc r10
	jmp .next


_sumar:
	imul rax, 15
	jmp _itoa

_itoa:   ;integer to ascii
	xor rcx, rcx ;vamos a poner el divisor
	xor rdx, rdx ;aqui vamos a guardar el residuo
	xor r8, r8 ;movimientos
	xor r9, r9 ;iterar por 2da variable
	mov rcx, 10 ;nuestro divisor


.next:

	cmp rax, 0   ;si llegamos a 0, no hay nada mas que dividir
	je _imprimirresultado

	div rcx 	;rax/rcx
	mov r8b, byte[digits+rdx]
	mov byte[resultado+r9], r8b
	inc r9
	xor rdx, rdx
	jmp .next
	

	

_imprimirinput:
	mov rax, 1
	mov rdi, 1
	mov rsi, input
	mov rdx, 20
	syscall
	ret


_imprimirresultado:
	mov rax, 1
	mov rdi, 1
	mov rsi, resultado
	mov rdx, 20
	syscall


_salir:
	mov rax, 60
	mov rdi, 0
	syscall	

