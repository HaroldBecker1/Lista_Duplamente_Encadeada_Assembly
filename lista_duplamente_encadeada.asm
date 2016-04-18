.data
menu:   	.asciiz		"\n\n-  Lista Ordenada  -\n-       MENU       - \n1 - Incluir Elemento \n2 - Excluir Elemento por indice\n3 - Excluir Elemento por valor\n4 - Ordenar Lista\n5 - Mostrar Totais\n6 - Mostrar Lista\n7 - Sair\n\nopcao: "

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
        add $s3, $zero, $zero           # ÚLTIMO ELEMENTO DA LISTA
###############################################################################
#                              Printa o menu                                  #
###############################################################################
#   Função que que printa o menu para o usuário                               #
###############################################################################
mostrar_menu:
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, menu                        # Move a string a ser printada
    syscall                             # Faz a chamada de sistema
###############################################################################
#                         Lê a opção do usuario                               #
###############################################################################
#   Função que lê a opção do usuário                                          #
###############################################################################
ler_opcao:
    li $v0, 5                           # Indica que irá ler um valor inteiro do teclado
    syscall                             # Faz a chamada de sistema
    move $t0, $v0		                # Move valor lido para $t0
###############################################################################
#                  Executa um case buscando a opção desejada                  #
###############################################################################
#   Função que verifica qual foi a opção escolhida pelo usuário               #
###############################################################################
case_escolha:
    addi $t1, $zero, 1
    beq  $t0, $t1, incluir_elemento     # Testa para ver se a opção escolhida foi incluir um elemento à lista
    addi $t1, $zero, 2
    beq  $t0, $t1, excluir_por_indice   # Testa para ver se a opção escolhida foi excluir um elemento pelo seu índice
    addi $t1, $zero, 3
    beq  $t0, $t1, excluir_por_valor    # Testa para ver se a opção escolhida foi excluir um elemento pelo seu valor
    addi $t1, $zero, 4
    beq  $t0, $t1, ordenar              # Testa para ver se a opção escolhida foi ordenar a lista
    addi $t1, $zero, 5
    beq  $t0, $t1, mostrar_totais       # Testa para ver se a opção escolhida foi mostrar estatísticas da lista
    addi $t1, $zero, 6
    beq  $t0, $t1, mostrar_lista        # Testa para ver se a opção escolhida foi exibir os dados da lista
    addi $t1, $zero, 7
    beq  $t0, $t1, op_sair              # Testa para ver se a opção escolhida foi sair do programa
###############################################################################
#                       Imprime Opção inválida                                #
###############################################################################
#   Função que imprime uma mensagem caso o usuário não escolha uma opção      #
#   válida                                                                    #
###############################################################################
imprime_opcao_invalida:
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_invalida                # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                      Insere elemento na lista                               #
###############################################################################
#   Função que insere um dado digitado pelo usuário na memória. A função      #
#   primeiramente pede o valor a ser inserido, logo após, é verificado        #
#   se a lista já possui elementos ou se ela esta vazia, se estiver vazia     #
#   é inserido primeiramento o ponteiro que identifica quem está atrás na     #
#   fila, o valor que foi digitado e o ponteiro para o próximo elemento da    #
#   lista, concluído essa parte, é incremento o contador de inclusões.        #
###############################################################################
#                                                                             #
###############################################################################
incluir_elemento:
    li $v0, 4                           # Indica que irá ser printado uma string
    la	$a0, txt_valor                  # Move a string a ser printada
    syscall                             # Faz a chamada de sistema
    li $v0, 5                           # Indica que irá ler um valor inteiro do teclado
    syscall                             # Faz a chamada de sistema
    move $t0, $v0                       # Move valor lido para $t0
    bne $s0, $zero, lista_com_elementos # Caso a lista não esteja vazia ele irá incluir o próximo elemento
    li $v0, 9                           # Indica irá alocar uma quantidade de bytes na memória
    li $a0, 12 			                # Quantidade de bytes a ser alocado
    syscall                             # Faz a chamada de sistema
    sw $zero, 0($v0)                    # Faz o ponteiro anterior apontar para NULL
    sw $t0, 4($v0)                      # Inclui o valor na memória
    sw $zero, 8($v0)                    # Faz o ponteiro próximo apontar para NULL
    move $s0, $v0                       # Move o inicio da lista para $s0
    move $s3, $v0                       # Move o último elemento da lista para $s3
    addi $v0, $zero, 0                  # Coloca 0 em $v0
    addi $s2, $s2, 1                    # Inicia o contador de inclusões

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#           Inclui elementos na lista quando esta possui valores              #
###############################################################################
#                                                                             #
###############################################################################
lista_com_elementos:
    li $v0, 9                           # Indica irá alocar uma quantidade de bytes na memória
    li $a0, 12 			                # Quantidade de bytes a ser alocado
    syscall                             # Faz a chamada de sistema
    sw $s3, 0($v0)                      # Faz o ponteiro anterior apontar para o elemento anterior
    sw $t0, 4($v0)                      # Inclui o valor na memória
    sw $zero, 8($v0)                    # Faz o ponteiro próximo apontar para NULL
    addi $s3, $s3, 8                    # Posiciona o ponteiro sob o ponteiro próximo
    sw $v0, 0($s3)                      # Inclui alocação na lista
    move $s3, $v0                       # Move o último elemento da lista para $s3
    addi $v0, $zero, 0                  # Coloca 0 em $v0
    addi $s2, $s2, 1                    # Incrementa o contador de inclusões

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                      Exclui Elemento por indice                             #
###############################################################################
excluir_por_indice:
    li $v0, 4                           # Indica que irá ser printado uma string
    la	$a0, txt_indice                 # Move a string a ser printada
    syscall                             # Faz a chamada de sistema
    li $v0, 5
    syscall
    move $t7, $v0  #valor digitado pelo usuario
    bne $s0, $zero, excluir_indice #caso a lista não seja nula
    li $v0, 4
    la $a0, txt_vazia
    syscall

    j mostrar_menu

excluir_indice:
    move $t1, $t7       # Indice
    move $t7, $s0       # Início do vetor
    addi $t7, $t7, 8
    add $t2, $zero, $zero # contador
    jal acha_indice
    addi $t7, $t7, -8 #retorna o ponteiro para o anterior
    lw $t3, 0($t7)
    addi $s1, $s1, 1    # contador de exclusoes
    beq $t3, $zero, primeiro_ou_unico
    addi $t7, $t7, 8     # pego o segundo ponteiro
    lw $t3, 0($t7)      # pego o segundo ponteiro
    beq $t3, $zero, ultimo #passo para pegar o último valor
########
    li $v0, 4                           # Indica irá alocar uma quantidade de bytes na memória
    la $a0, txt_sair 			                # Quantidade de bytes a ser alocado
    syscall
#######
    j mostrar_menu
acha_indice:
    beq $t2, $t1, retorna #caso achou o valor retorna
    lw $t5, 0($t7)
    beq $t5, $zero, indice_invalido
    addi $t7, $t5, 8
    addi $t2, $t2, 1

    j acha_indice
retorna:
    jr $ra

indice_invalido:
    li $v0, 4
    la $a0, txt_ind_inex
    syscall

    j mostrar_menu

primeiro_ou_unico:
    addi $t7, $t7, 8 #pego o ultimo ponteiro
    lw $t3, 0($t7)  #pego o ultimo ponteiro
    beq $t3, $zero, unico   #testo para ver se é o unico elemento da lista
    sw $zero, 0($t3)    #exclui o ponteiro
    sw $zero, 0($t7)    #exclui o ponteiro que aponta para o atual primeiro elemento da lista
    addi $t7, $t7, -4   #pego o local de memória do valor
    sw $zero, 0($t7)    #exclui valor
    move $s0, $t3       #move o novo inicio do vetor

    j mostrar_menu

unico:
    addi $t7, $t7, -4   #posiciono o ponteiro sob o valor
    sw $zero, 0($t7)    # removo o valor da memória
    move $s0, $zero     # anulo o inicio do vetor

    j mostrar_menu

ultimo:
    addi, $t7, $t7, -4
    sw $zero, 0($t7)
    addi, $t7, $t7, -4
    lw $t3, 0($t7)
    sw $zero, 0($t7)
    move $s3, $t3
    addi $t3, $t3, 8
    sw $zero, 0($t3)

    j mostrar_menu
###############################################################################
#                      Exclui Elemento por valor                              #
###############################################################################
#                                                                             #
###############################################################################
excluir_por_valor:
    li $v0, 4                           # Indica que irá ser printado uma string
    la	$a0, txt_valor_rem              # Move a string a ser printada
    syscall                             # Faz a chamada de sistema
    li $v0, 5                           # Lê um inteiro digitado pelo usuario
    syscall
    move $t0, $s0                       # Move o inicio da lista para $t0
    move $t1, $v0                       # Guardo o valor digitado em $t1
    move $t2, $s0
    addi $t0, $t0, 4                    # Pego o local de memória do primeiro elemento na lista
    addi $t2, $t2, 8
    add $t7, $zero, $zero               #indice do valor
    bne $s0, $zero, procurar_elemento   # Testo se o inicio do vetor não é nulo
    li $v0, 4                           # Printa uma string
    la	$a0, txt_vazia
    syscall

    j mostrar_menu

procurar_elemento:
    lw $t3, 0($t0)                      # Busco o valor na memória
    lw $t4, 0($t2)                      #próximo ponteiro
    beq $t3, $t1, excluir_indice     # Testo se o primeiro valor é diferente do que foi digitado
    beq $t4, $zero, fim_da_lista    #próximo valor da memória não existe
    lw $t5, 0($t2)
    addi $t0, $t5, 4                   # Pego o local de memória do elemento na lista
    addi $t2, $t5, 8
    addi $t7, $t7, 1                    # próxima posição

    j procurar_elemento

fim_da_lista:
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_val_inex                # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

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
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_total_inc               # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    li $v0, 1                           # Printa um inteiro
    move $a0, $s2                       # Coloca a quantidade de inclusões em $a0
    syscall

    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_total_exc               # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    li $v0, 1                           # Printa um inteiro
    move $a0, $s1                       # Coloca a quantidade de exclusões em $a0
    syscall

    j mostrar_menu                      # Retorna para o início
###############################################################################
#                           Mostrar Lista                                     #
###############################################################################
#                                                                             #
###############################################################################
mostrar_lista:
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_lista                   # Move a string a ser printada
    syscall                             # Faz a chamada de sistema
    move $t0, $s0                       # Move o inicio da lista para $t0
    addi $t0, $t0, 4                    # Pega o valor Contido na primeira posição
    move $t2, $s0               # ponteiro para o próximo
    addi $t2, $t2, 8                    #pego o próximo valor
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
    lw $t3, 0($t2)
    addi $t0, $t3, 4
    addi $t2, $t3, 8
    beq $t3, $zero, mostrar_menu          # Verifica se o próximo ponteiro é nulo
    j listar                            # Retorna para Listar o próximo elemento
###############################################################################
#                         Sair do programa                                    #
###############################################################################
op_sair:
    la  $a0, txt_sair
    li	$v0, 10
    syscall
