            .data
menu:   	.asciiz		"\n\n-  Lista Ordenada  -\n-       MENU       - \n1 - Incluir Elemento \n2 - Excluir Elemento por indice\n3 - Excluir Elemento por valor\n4 -Ordena Lista\n5 - Mostrar Totais\n6- Mostrar Lista\n7 - Sair\n\nopcao: "

txt_invalida: 	.asciiz		"OPCAO INVALIDA\n"
txt_valor: 		.asciiz		"Entre com o valor a ser inserido: "
txt_indice: 	.asciiz		"Entre com o indice do valor a ser removido: "
txt_ind_inex:	.asciiz 	"Indice Inexistente\n"
txt_val_inex:	.asciiz 	"Valor Inexistente\n"
txt_valor_rem: 	.asciiz		"Entre com o valor a ser removido: "
txt_vazia: 		.asciiz		"Lista Vazia \n"
txt_sair: 		.asciiz		"PROGRAMA FINALIZADO \n"
txt_total_inc: 	.asciiz		"\n\nTotal de inclusoes: "
txt_total_exc:	.asciiz		"\nTotal de exclusoes: "
txt_lista: 		.asciiz		"Lista: "
txt_espaco: 	.asciiz		" "
txt_posicao:	.asciiz     "Posicao Inserida: "
txt_vremovido:	.asciiz		"Valor Removido: "
txt_iremovido:	.asciiz		"Indice Removido: "
                .text

main:
    add $s0, $zero, $zero               # INICIO DA LISTA
    add $s1, $zero, $zero               # CONTADOR DE EXCLUSÃO
    add $s2, $zero, $zero               # CONTADOR DE INSERSÕES
###############################################################################
#                              printa o menu                                  #
###############################################################################
mostrar_menu:
    li $v0, 4
    la $a0, menu
    syscall
###############################################################################
#                         lê a opção do usuario                               #
###############################################################################
ler_opcao:
    li	$v0, 5
    syscall
    add	$t0, $zero, $v0		            # Carrega valor lido em $t0
    li	$v0, 4
###############################################################################
#                  Executa um case buscando a opção desejada                  #
###############################################################################
case_escolha:
    addi $t1, $zero, 1
	beq  $t0, $t1, incluir_elemento
	addi $t1, $zero, 2
	beq  $t0, $t1, excluir_por_indice
	addi $t1, $zero, 3
	beq  $t0, $t1, excluir_por_valor
	addi $t1, $zero, 4
	beq  $t0, $t1, ordenar
	addi $t1, $zero, 5
	beq  $t0, $t1, mostrar_totais
    addi $t1, $zero, 6
	beq  $t0, $t1, mostrar_lista
    addi $t1, $zero, 7
	beq  $t0, $t1, op_sair
###############################################################################
#                       Imprime Opção inválida                                #
###############################################################################
imprime_opcao_invalida:
	la	$a0, txt_invalida
	syscall
	j mostrar_menu
###############################################################################
#                      Insere elemento na lista                               #
###############################################################################
#   $t0 -> Valor digitado pelo usuario                                        #
#   $t1 -> Ponteiro que percorre o vetor                                      #
#   $s0 -> Início do vetor                                                    #
#   $s2 -> Inicia a contagem de inclusões                                     #
#   0-4 bytes -> Ponteiro para o valor anterior                               #
#   4-8 bytes -> Valor inteiro                                                #
#   8-12 bytes -> Ponteiro para o próximo valor                               #
###############################################################################
incluir_elemento:
    la	$a0, txt_valor                  # Mostra texto de inclusão de valor
    syscall
    li $v0, 5                           # Lê um inteiro digitado pelo usuario
    syscall
    add $t0, $zero, $v0                 # Coloca o valor lido em $t0
    bne $s0, $zero, lista_com_elementos # Caso a lisa não seja nula pula para incluir o próximo valor
    li $a0, 12 			                # Quantidade de bytes de memória a ser alocado
    li $v0, 9                           # Comando para alocal dinamicamente na memória
    syscall
    sw $zero, 0($v0)                    # Faz o ponteiro anterior apontar para NULL
    sw $t0, 4($v0)                      # Coloca valor na memoria
    sw $zero, 8($v0)                    # Faz o ponteiro próximo apontar para NULL
    move $s0, $v0                       # Move o inicio do vetor para $s0
    li $v0, 1
    move $a0, $s0
    syscall
    move $t1, $v0                       # Move o ponteiro para $t1
    addi $v0, $zero, 0                  # Coloca 0 em $v0
    addi $s2, $zero, 1                  # Inicia o contador de inclusões
    j mostrar_menu                      # Retorna para o início
###############################################################################
#           Inclui elementos na lista quando esta possui valores              #
###############################################################################
#   $t0 -> Valor Digitado Pelo Usuário                                        #
#   $t1 -> Poteiro com o local de memória do valor anterior                   #
#   $s2 -> Contagem de inclusões                                              #
#   0-4 bytes -> Ponteiro para o valor anterior                               #
#   4-8 bytes -> Valor inteiro                                                #
#   8-12 bytes -> Ponteiro para o próximo valor                               #
###############################################################################
lista_com_elementos:
    li $a0, 12 			                # Quantidade de bytes de memória a ser alocado
    li $v0, 9                           # Comando para alocal dinamicamente na memória
    syscall
    sw $t1, 0($v0)                      # Faz o ponteiro apontar para o anterior
    sw $t0, 4($v0)                      # Coloca valor na memoria
    sw $zero, 8($v0)                    # Faz o ponteiro próximo apontar para NULL
    move $t1, $v0                       # Move o valr do ponteiro para o atual
    addi $v0, $zero, 0                  # coloca 0 em $v0
    addi $s2, $s2, 1                    # Incrementa o contador de inclusões
    j mostrar_menu                      # Retorna para o início
###############################################################################
#                      Exclui Elemento por indice                             #
###############################################################################
excluir_por_indice:
    la	$a0, txt_invalida
    syscall
    j mostrar_menu
###############################################################################
#                      Exclui Elemento por valor                              #
###############################################################################
excluir_por_valor:
    la	$a0, txt_invalida
    syscall
    j mostrar_menu
###############################################################################
#                      Ordena vetor de dados                                  #
###############################################################################
ordenar:
    la	$a0, txt_invalida
    syscall
    j mostrar_menu
###############################################################################
#                Mostra Dados de exclusão e inclusão                          #
###############################################################################
mostrar_totais:
    li $v0, 4                           # Printa uma string
    la $a0, txt_total_inc               # Printa mensagem de inclusões
    syscall

    li $v0, 1                           # Printa um inteiro
    move $a0, $s2                       # Coloca a quantidade de inclusões em $a0
    syscall

    li $v0, 4                           # Printa uma string
    la $a0, txt_total_exc               # Printa mensagem de exclusões
    syscall

    li $v0, 1                           # Printa um inteiro
    move $a0, $s1                       # Coloca a quantidade de exclusões em $a0
    syscall

    j mostrar_menu                      # Retorna para o início
###############################################################################
#                           Mostrar Lista                                     #
###############################################################################
#   $t0 -> Local de memória do valor                                          #
#   $t1 -> Valor a ser exibido                                                #
#   $t2 -> Contador do laço                                                   #
#   $s0 -> Inicio da Lista                                                    #
#   $s2 -> Quantidade de Valores inseridos                                    #
###############################################################################
mostrar_lista:
    li $v0, 4
    la $a0, txt_lista                   # Printa uma string
    syscall
    add $t2, $zero, $zero               # Contador do vetor
    move $t0, $s0                       # Move o inicio do vetor para $t0
    addi $t0, $t0, 4                    # Pega o valor Contido na primeira posição
    bne $s0, $zero, listar              # Caso  $s0 não seja nulo ele mostra a lista
    li $v0, 4
    la $a0, txt_vazia                   # Printa uma string
    syscall
    j mostrar_menu                      # Retorna para o menu

listar:
    lw $t1, 0($t0)                      # Busca na memoria o valor do campo
    li $v0, 1                           # Printa um inteiro
    move $a0, $t1                       # Printo o valor
    syscall
    li $v0, 4                           # Printa uma string
    la $a0, txt_espaco
    syscall
    addi $t2, $t2, 1                    # Incrementa o contador
    addi $t0, $t0, 12                   # Anda de 12 em 12 bytes no vetor, pois preciso pular 2 ponteiros
    beq $t2, $s2, mostrar_menu          # Caso o contador seja igual ao numero de inserções ele retorna
    j listar                            # Retorna para Listar o próximo elemento
###############################################################################
#                         Sair do programa                                    #
###############################################################################
op_sair:
    la  $a0, txt_sair
    li	$v0, 10
    syscall
