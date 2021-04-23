.section .data
	titulo: 	.asciz "\n***Programa Vetor***\n\n"
	pedeTam: 	.asciz "\nDigite o tamanho do vetor\n"
	pedeNum: 	.asciz "\nDigite o numero\n"

	formato: 	.asciz "%d"
	mostraVet: 	.asciz "Mostra vetor"

	tamMax: 	.int 30
	tam: 		.int 0
	numero: 	.int 0

	vetor: 		.space 120 #4bytes pra cada numero armazenado
	
.section .text

.globl _start

_start:

	pushl	$titulo
	call	printf

	addl 	$4, %esp

	call	leTam
	call	leVetor
	movl	$mostraVet, %eax
	call	mostraVetor

fim:
	pushl	$0
	call exit
	


leTam:
	pushl	tamMax
	pushl	$pedeTam
	call 	printf
	pushl	$tam
	pushl	$formato
	call	scanf
	addl	$16, %esp
	
	movl	tam, %eax
	cmpl	$0, %eax
	jle	leTam
	cmpl	tamMax,	%eax
	jg	leTam

	ret

leVetor:
	
	movl	tam, %ecx
	movl	vetor, %edi
	movl	$1, %ebx

leNum:
	pushl	%ebx
	pushl	%ecx
	pushl	%edi

	pushl	%ebx
	pushl	$pedeNum
	call	printf
	pushl	%edi
	pushl	$formato
	call	scanf
	addl	$16, %esp

	incl	%ebx
	addl	$4, %edi
	loop	leNum

	ret


mostraVetor:
	pushl	%eax 
	call	printf
	addl	$4, %esp
	movl	$vetor, %edi
	movl	tam, %ecx
