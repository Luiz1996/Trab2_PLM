#Luiz Flávio Pereira ra91706 => Avaliação 2

.section .data

	tracejado:	.asciz  "\n -------------------------------------------------------------------------------------------------\n"
        abert:		.asciz	"\n ********** Lista Dinâmica Circular **********"
	mostraLista:	.asciz	"\n ********** Resultado - Lista Dinâmica Circular **********\n\n"
	formatoRes:	.asciz	"\t End. Início Reg | Conteúdo Reg | End. Próx Reg\n\t ----------------------------------------------\n"
	imprimeReg:	.asciz	"\t %-15X | %-12d | %X \n" 
	linhaFim:	.asciz	"\t ----------------------------------------------\n"
	pedeQtdeRegs:	.asciz  "\n\n Informe quantos elementos terá na lista dinâmica circular[1~999]: "
	msg:		.asciz	"\n Daremos início a criação da lista dinâmica circular com %d elemento(s) numérico(s)...\n\n"
	msgErroQtde:	.asciz  "\n A quantidade(%d) de registro(s) informado(s) é inválida, programa abortado!\n\n"
	pedeNum:	.asciz  " Informe o %-3dº número da lista dinâmica circular: "
	vaiDenovo:	.asciz	"\n Deseja criar uma nova lista dinâmica circular [s]im/[n]ão?\n R: "
	tipoChar:	.asciz	" %c"
	tipoNum:	.asciz 	"%d"
	
	qtdeMaxRegs:	.int 	999
	tamReg:		.int 	8	#4 bytes para o número lido + 4 bytes para endereço do próximo registro
	varCtrl:	.int 	1
	qtdeRegs:	.int    0
	lista:		.int	0 	#contém sempre o endereço do primeiro registro da lista
	listaProx:	.int	0	#será atualizado sempre com o endereço dos próximos registros criados
	endProxReg:	.int	0	#conterá sempre o endereço do próximo registro a ser impresso
	zero:		.int    0
	
	vamosDenovo:	.byte	'n'

.section .text

.globl _start

_start:
	#atualizando valor de varCtrl ao criar lista dinâmica circular novamente
	movl	$1, varCtrl
	
	#chamando demais métodos para cração e impressão da lista dinâmica circular
	call	mostra_abertura
	call	inicia_lista
	call	imprime_lista
	call	fim

mostra_abertura:
	#mostrando a abertura ao usuário
	pushl	$tracejado
	call 	printf
	pushl	$abert
	call 	printf

	#obtendo quantidade de registros na lista circular
	pushl	$pedeQtdeRegs
	call 	printf
	pushl	$qtdeRegs
	pushl	$tipoNum
	call	scanf

	#realizando validações
	movl	qtdeRegs, %eax
	cmpl	zero, %eax
	jle	qtde_invalida_regs	#comparando se menor ou igual a 0
	movl	qtdeRegs, %eax
	cmpl	qtdeMaxRegs, %eax
	jg	qtde_invalida_regs	#comparando se maior que 999

	#mostrando a mensagem inicial ao usuário
	pushl	qtdeRegs
	pushl	$msg
	call 	printf

	#atualizando pilha
	addl 	$28, %esp

	ret

qtde_invalida_regs:
	#imprimindo mensagem de erro
	pushl 	qtdeRegs
	pushl 	$msgErroQtde
	call 	printf

	#imprimindo tracejado
	pushl	$tracejado
	call	printf

	#atualizando a pilha
	addl	$12, %esp

	#encerrando aplicação
	call fim

inicia_lista:
	#alocando primeiro registro
	pushl	tamReg
	call	malloc 		#endereço alocado é salvo no %eax
	movl	%eax, lista 	#fazendo com que lista receba tal endereço

	#mostrando mensagem pra obter primeiro registro
	pushl	varCtrl
	pushl	$pedeNum
	call	printf
	addl	$12, %esp	#atualizando pilha

	#obtendo primeiro número em %edi
	movl	lista, %edi
	pushl	%edi
	pushl	$tipoNum
	call	scanf
	addl	$4, %esp	#atualizando pilha

	popl	%edi		#desempilhando %edi

	#validando quantidade de registros
	movl 	qtdeRegs, %eax
	cmpl	$1, %eax
	jg	pede_numeros		#comparando se qtdeRegs é maior que 1
	je	finaliza_numeros	#comparando se qtdeRegs é igual a 1

	ret

finaliza_numeros:
	#como haverá apenas 1 registro, devemos avançar %edi e fazê-lo apontar para o início da lista
	addl	$4, %edi	#avança %edi pra receber endereço da lista
	pushl	%edi		#empilha %edi para manipulá-lo
	movl	lista, %eax	#move endereço da lista para %eax
	movl	%eax, (%edi)	#move conteúdo de %eax para o conteúdo de %edi

	#desempilhando %edi
	popl	%edi

	ret

pede_numeros:
	#atualizando valor de varCtrl, uma vez que haverá mais de 1 elemento
	addl	$1, varCtrl

	#alocando próximo registro da lista dinâmica
	pushl	tamReg
	call	malloc
	
	#atribuindo endereço do próximo registro no ponteiro PRÓX do registro anterior
	addl	$4, %edi
	pushl	%edi
	movl	%eax, (%edi)

	#atualizando listaProx
	movl	%eax, listaProx

	#pedindo próximo número
	pushl   varCtrl
	pushl	$pedeNum
	call 	printf

	#atualizando pilha
	addl	$16, %esp

	#obtendo número no %edi
	movl	listaProx, %edi
	pushl	%edi
	pushl	$tipoNum
	call	scanf

	#atualizando pilha
	addl	$4, %esp

	#desempilhando %edi
	popl	%edi

	#manutenção do loop até se obter todos os números
	movl	varCtrl, %eax
	cmpl	qtdeRegs, %eax
	je	finaliza_numeros	#comparando de varCtrl é igual a qtdeRegs
	jle	pede_numeros		#comparando se varCtrl é menor ou igual a qtdeRegs(entrará nessa condição apenas se for menor)

	ret

imprime_lista:
	#imprimindo cabeçalho
	pushl	$mostraLista
	call 	printf
	pushl	$formatoRes
	call 	printf

	#atualizando pilha
	addl	$8, %esp
	
	#atualizando ponteiros
	movl	lista, %edi
	addl	$4, %edi

	#imprimindo cada elemento da lista
	call	imprime_regs

	ret

imprime_regs:
	#salvando endereço do próximo registro
	movl	(%edi), %eax
	movl	%eax, endProxReg

	#imprime registro
	pushl	(%edi)
	subl	$4, %edi
	pushl	(%edi)
	pushl	%edi
	pushl	$imprimeReg
	call	printf

	#atualiza pilha
	addl	$16, %esp

	#avaliando se precisa imprimir mais registros	
	movl	endProxReg, %eax
	cmpl	lista, %eax
	jne	atualiza_ponteiro_edi	#continuará a imprimir reg até que o end. do próx reg seja diferente do end. de início da lista
	
	#finaliza impressão
	call	finaliza_impressao

	ret

atualiza_ponteiro_edi:
	#setando endereço do próximo registro em %edi
	movl	endProxReg, %edi
	addl	$4, %edi

	#continuando impressão do próximo registro
	call	 imprime_regs	

	ret

finaliza_impressao:
	#imprimindo tracejado de fim
	pushl	$linhaFim
	call	printf
	
	#atualizando pilha
	addl	$4, %esp

	ret

fim:
	#perguntando ao usuário se deseja criar nova lista dinâmica circular
	pushl	$vaiDenovo
	call	printf

	#obtendo resposta do usuário
	pushl	$vamosDenovo
	pushl	$tipoChar
	call	scanf

	#atualizando pilha
	addl	$12, %esp

	#avaliando possibilidade de continuar
	movb	vamosDenovo, %al
	cmpb	$'s', %al
	je	_start		#continuará a execução se vamosDenovo for igual a 's'
	cmpb	$'S', %al
	je	_start		#continuará a execução se vamosDenovo for igual a 'S'	

	#imprimindo tracejado
	pushl	$tracejado
	call	printf
	
	#atualizando a pilha
	addl	$4, %esp

	#finalizando programa
	pushl	zero
	call	exit
