.section .data
	titulo: .asciz "\n*** Programa Inverte Vetor 1.0 ***\n\n"
	pedeTam: .asciz "\nDigite o tamanho do vetor (máximo=%d) => "
	pedeNum: .asciz "Entre com o elemento %d => "
	tipoNum: .asciz "%d"

	mostraVet: .asciz "\nVetor Original:"
	mostraElem: .asciz " %d"
	mostraVetInv: .asciz "\nVetor Invertido:"
	mostraSoma: .asciz "\nSoma do Vetor: %d\n"
	pulaLin: .asciz "\n"

	maxTam: .int 30
	tam: .int 0
	num: .int 0
	soma: .int 0

	vetor: .space 120 # 4 BYTES PARA CADA NÚMERO A SER ARMAZENADO

.section .text
	# as -32 inverte_vetor1.s -o inverte_vetor1.o
	# ld -m elf_i386 inverte_vetor1.o -l c -dynamic-linker /lib/ld-linux.so.2 -o inverte_vetor1

.globl _start
_start:
	pushl $titulo
	call printf

	call lerTam
	call lerVetor
	movl $mostraVet, %eax
	call mostraVetor
	call invertVetor
	movl $mostraVetInv, %eax
	call mostraVetor
	call somaVetor


_end:
	pushl $0
	call exit


lerTam:
	pushl maxTam
	pushl $pedeTam
	call printf
	pushl $tam
	pushl $tipoNum
	call scanf
	addl $16, %esp

	movl tam, %eax
	cmpl $0, %eax
	jle lerTam
	cmpl maxTam, %eax
	jg lerTam

	ret


lerVetor:
	movl tam, %ecx
	movl $vetor, %edi
	movl $1, %ebx

lerNum:
	pushl %ebx
	pushl %ecx
	pushl %edi

	pushl %ebx
	pushl $pedeNum
	call printf
	pushl %edi
	pushl $tipoNum
	call scanf

	addl $16, %esp
	popl %edi
	popl %ecx
	popl %ebx

	incl %ebx
	addl $4, %edi
	loop lerNum

	ret


mostraVetor:
	pushl %eax
	call printf
	movl $vetor, %edi
	movl tam, %ecx
	addl $4, %esp

volta:
	pushl %ecx
	pushl %edi

	movl (%edi), %eax
	pushl %eax
	pushl $mostraElem
	call printf

	addl $8, %esp
	popl %edi
	popl %ecx

	addl $4, %edi
	loop volta

	pushl $pulaLin
	call printf
	addl $4, %esp

	ret


invertVetor:
	movl $vetor, %esi
	movl %esi, %edi

	movl tam, %eax
	decl %eax
	movl $4, %ebx
	mull %ebx
	addl %eax, %edi

	movl tam, %eax
	movl $2, %ebx
	movl $0, %edx
	divl %ebx
	movl %eax, %ecx

volta2:
	movl (%esi), %eax
	movl (%edi), %ebx
	movl %ebx, (%esi)
	movl %eax, (%edi)

	addl $4, %esi
	subl $4, %edi
	loop volta2

	ret


somaVetor:
	movl tam, %ecx
	movl soma, %eax
	movl $vetor, %edi

volta3:
	movl (%edi), %ebx
	addl %ebx, %eax
	addl $4, %edi

	loop volta3
	movl %eax, soma
	pushl soma
	pushl $mostraSoma
	call printf
	addl $8, %esp

	ret
