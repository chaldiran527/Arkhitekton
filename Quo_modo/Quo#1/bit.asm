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
	;Se inicializan las hileras que se le muestran al usuario 
	msj1 db 'Es cero',0xA;mensaje incial 
	longMsj1 equ $-msj1	;longitud mensaje inicial 
	msjError db 0xA,'Error: La hilera tiene valores no alfabeticos. Intente nuevamente',0xA,0xA;mensaje error
	longMsjError equ $-msjError ;longitud mensaje de error
	msj3 db '1'
	longMsj3 equ $-msj3
	msjExito db 0xA,0xA,'Conversion de caracteres realizada exitosamente',0xA
	longMsjExito equ $-msjExito 
	hileraConvertida db 0xA,'Hilera convertida: '
	longHileraConvertida equ $-hileraConvertida

section .bss
	hilera resb 255
	longInputHilera equ $-hilera
	caracter resb 2
	simbolo resb 1
	mascara resb 1

section .text
	global _start

_start:
	mov rsp,1
	shl rsp,35;Numero del bit que se quiere buscar
	and rsp,rdx
	mov [mascara],rsp
	cmp byte[mascara],0
	je _esCero

    cmp byte[mascara],1
	je _esUno


_esCero:
	print msj1,longMsj1
	jmp _exit

_esUno:
	print msj3,longMsj3
	jmp _exit

_exit:;Se finaliza el programa
	;Llamada de salida
	mov rbx,0 			;RBX=codigo de salido al 80 
	mov rax,1			;RAX=funcion sys_exit() del kernel llama al sistema 
	int 0x80 			;Llamada al sistema para acabar la ejecucion del programa