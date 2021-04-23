.section .data
	abertura:	.asciz	"\nLeitura de um Registro\n"
	pedenome:	.asciz	"\nDigite um nome: "
	pedeidade:	.asciz	"\nDigite sua idade: "
	pedecpf:	.asciz  "\nDigite o CPF: "
	pedegenero:	.asciz  "\nDigite o genero [M/F]: "

	mostranome:	.asciz	"\nNome: %s"
	mostraidade:	.asciz  "\nIdade: %d"
	mostracpf:	.asciz	"\nCPF: %s"
	mostragenero:	.asciz	"\nGenero: %c"
	mostraprox:	.asciz	"\nEnd. Próx: %X"

	tamreg:		.int	55

	tipoint:	.asciz	"%d"
	tipocar:	.asciz  "%c"
	tipostr:	.asciz  "%s"

	lista:		.int 	0

	NULL:		.int	0

.section .text

.globl _start

_start:

	call	ler_registro
	call	mostrar_registro	

	pushl	$0
	call 	exit

ler_registro:
	#mostrando abertura
	pushl	$abertura
	call	printf
	addl	$4, %esp

	#alocando memória de tamanho de um registro	
	pushl	tamreg
	call	malloc #malloc deixa o inicio do endereço salvo em %eax, então devemos fazer o lista receber esse endereço
	movl	%eax, lista
	addl	$4, %esp

	#lendo nome
	pushl	$pedenome
	call 	printf
	addl	$4, %esp

	movl	lista, %edi
	pushl	%edi
	call	gets

	popl	%edi #obtendo edi novamente
	addl	$31, %edi #deslocando 31, pois entende-se que as primeiras 31 posições pertence à string nome

	#lendo idade
	pushl	%edi #protegendo edi
	pushl	$pedeidade
	call 	printf
	addl	$4, %esp #desempilhando pushl $pedeidade, pra deixar endereço do %edi no topo da pilha

	pushl	$tipoint
	call 	scanf
	addl	$4, %esp #desempilhando pushl $tipoint, pra deixar o endereço do %edi no topo da pilha

	popl	%edi
	addl	$4, %edi #avançando no %edi pra receber proximo dado

	#lendo cpf
	pushl	%edi
	pushl	$pedecpf
	call 	printf
	addl	$4, %esp

	call	gets
	call	gets

	popl	%edi
	addl	$12, %edi #avançando %edi pra receber proximo dado

	#lendo genero
	pushl	%edi
	pushl	$pedegenero
	call 	printf

	addl	$4, %esp

	pushl	$tipocar
	call	scanf
	addl	$4, %esp

	popl	%edi

	addl	$4, %edi

	#apontar próximo pra NULL
	movl	$NULL, (%edi)

	ret

mostrar_registro:

	movl	lista, %edi

	pushl	%edi

	pushl	$mostranome
	call	printf
	addl	$4, %esp

	popl	%edi
	addl	$31, %edi
	pushl	%edi

	movl	(%edi), %eax
	pushl	%eax
	pushl	$mostraidade
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi
	pushl	%edi

	pushl	$mostracpf
	call	printf
	addl	$4, %esp

	popl	%edi
	addl	$12, %edi
	pushl	%edi

	movl	(%edi), %eax
	pushl	%eax
	pushl	$mostragenero
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi
	pushl	%edi

	pushl	$mostraprox
	call	printf
	addl	$4, %esp

	popl	%edi

	ret
