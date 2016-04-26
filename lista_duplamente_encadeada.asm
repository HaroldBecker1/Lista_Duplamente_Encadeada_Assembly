.data
menu:   	.asciiz		"\n\n-  Lista Ordenada  -\n-       MENU       - \n1 - Incluir Elemento \n2 - Excluir Elemento por indice\n3 - Excluir Elemento por valor\n4 - Mostrar Totais\n5 - Mostrar Lista\n6 - Sair\n\nopcao: "

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
###############################################################################
#                                                                             #
###############################################################################
main:
    add $s0, $zero, $zero               # INICIO DA LISTA
    add $s1, $zero, $zero               # CONTADOR DE EXCLUSÃO
    add $s2, $zero, $zero               # CONTADOR DE INSERSÕES
    add $s3, $zero, $zero               # ÚLTIMO ELEMENTO DA LISTA
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
    beq  $t0, $t1, mostrar_totais       # Testa para ver se a opção escolhida foi mostrar estatísticas da lista
    addi $t1, $zero, 5
    beq  $t0, $t1, mostrar_lista        # Testa para ver se a opção escolhida foi exibir os dados da lista
    addi $t1, $zero, 6
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
#                       Incluir Elemento                                      #
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
    li $v0, 5                           # Indica que irá ler um valor inteiro do teclado
    syscall                             # Faz a chamada de sistema
    move $t7, $v0                       # Move valor lido para $t7
    bne $s0, $zero, excluir_indice      # Faz a verificação de nulidade da lista
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_vazia                   # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                         Excluir Indice                                      #
###############################################################################
excluir_indice:
    move $t1, $t7                       # Move o indice digitado para $t1
    move $t7, $s0                       # Move o inicio da lista para $t7
    addi $t7, $t7, 8                    # Posiciono sob o ponteiro próximo
    add $t2, $zero, $zero               # Inicio o contador que busca o indice
    jal acha_indice                     # Procura o valor com o indice passado
    addi $t7, $t7, -8                   # Posiciona o sob o ponteiro anterior
    lw $t3, 0($t7)                      # Busca o ponteiro anterior na memória
    addi $s1, $s1, 1                    # Incrementa o contador de exclusões
    beq $t3, $zero, primeiro_ou_unico   # Verifica se o ponteiro anterior é nulo
    addi $t7, $t7, 8                    # Posiciono sob o ponteiro próximo
    lw $t3, 0($t7)                      # Busca o ponteiro próximo na memória
    beq $t3, $zero, ultimo              # Verifica se o ponteiro próximo é nulo
    sw $zero, 0($t7)                    # Exclui o ponteiro próximo da memória
    addi $t7, $t7, -4                   # Posiciona o ponteiro sob o valor
    sw $zero, 0($t7)                    # Exclui o valor da memória
    addi $t7, $t7, -4                   # Posiciona sob o ponteiro anterior
    lw $t0, 0($t7)                      # Busca o ponteiro anterior na memória
    sw $zero, 0($t7)                    # Exclui o ponteiro anterior
                                        # $t3 possui o inicio do elemento candidato a próximo da lista
    sw $t0, 0($t3)                      # Sobreescreve o ponteiro com o inicio do elemento anterior
    addi $t0, $t0, 8                    # Posiciona sob o ponteiro próximo
    sw $t3, 0($t0)                      # Sobreescreve o ponteiro próximo com o local de memoria do candidato a próximo da lista

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                     Procura Indice                                          #
###############################################################################
acha_indice:
    beq $t2, $t1, retorna               # Verifica se o indice já foi achado
    lw $t5, 0($t7)                      # Busca o próximo elemento da lista
    beq $t5, $zero, indice_invalido     # Verifica se o próximo elemento da lista é nulo
    addi $t7, $t5, 8                    # Posiciono sob o ponteiro próximo
    addi $t2, $t2, 1                    # Incrementa o contador

    j acha_indice                       # Retorna para procurar o indice
###############################################################################
#                             Retorno                                         #
###############################################################################
retorna:
    jr $ra                              # Retorna para quem chamou
###############################################################################
#                         Indice Inválido                                     #
###############################################################################
indice_invalido:
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_ind_inex                # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                    Primeiro elemento ou Único                               #
###############################################################################
primeiro_ou_unico:
    addi $t7, $t7, 8                    # Posiciona sob o ponteiro próximo
    lw $t3, 0($t7)                      # Busca o próximo elemento
    beq $t3, $zero, unico               # Verifico se é o unico elemento da lista
    sw $zero, 0($t3)                    # Exclui o ponteiro próximo
    addi $t7, $t7, -4                   # Posiciona o ponteiro sob o valor
    sw $zero, 0($t7)                    # Remove o valor da memória
    move $s0, $t3                       # Move o novo início da lista

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                        Único Elemento                                       #
###############################################################################
unico:
    addi $t7, $t7, -4                   # Posiciona o ponteiro sob o valor
    sw $zero, 0($t7)                    # Remove o valor da memória
    move $s0, $zero                     # Anula o inicio do vetor

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                      Último Elemento                                        #
###############################################################################
ultimo:
    addi, $t7, $t7, -4                  # Posiciona o ponteiro sob o valor
    sw $zero, 0($t7)                    # Remove o valor da memória
    addi, $t7, $t7, -4                  # Posiciona sob o ponteiro anterior
    lw $t3, 0($t7)                      # Busca o elemento anterior da lista
    sw $zero, 0($t7)                    # Exclui o ponteiro anterior
    move $s3, $t3                       # Move o último elemento da lista para $s3
    addi $t3, $t3, 8                    # Posiciona sob o ponteiro próximo
    sw $zero, 0($t3)                    # Exclui o ponteiro próximo

    j mostrar_menu                      # Retorna para o menu
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
    syscall                             # Faz a chamada de sistema
    move $t0, $s0                       # Move o inicio da lista para $t0
    move $t1, $v0                       # Move o valor digitado para $t1
    move $t2, $s0                       # Move o inicio da lista para $t2
    addi $t0, $t0, 4                    # Posiciona o ponteiro sob o valor
    addi $t2, $t2, 8                    # Posiciona sob o ponteiro próximo
    add $t7, $zero, $zero               # Inicializo índice do valor
    bne $s0, $zero, procurar_elemento   # Testo se o inicio do vetor não é nulo
    li $v0, 4                           # Indica que irá ser printado uma string
    la	$a0, txt_vazia                  # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                       Procura Elemento por valor                            #
###############################################################################
procurar_elemento:
    lw $t3, 0($t0)                      # Busco o valor na memória
    lw $t4, 0($t2)                      # Leio o próximo ponteiro
    beq $t3, $t1, excluir_indice        # Verifica se valor é igual ao que foi digitado
    beq $t4, $zero, fim_da_lista        # Verifica se o ponteiro próximo não existe
    addi $t0, $t4, 4                    # Posiciona o ponteiro sob o valor
    addi $t2, $t4, 8                    # Posiciona o sob o ponteiro próximo
    addi $t7, $t7, 1                    # Incrementa o valor do índice

    j procurar_elemento                 # Retorna para procurar_elemento
###############################################################################
#                       Fim da lista por valor                                #
###############################################################################
fim_da_lista:
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_val_inex                # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                Mostrar Dados de exclusão e inclusão                          #
###############################################################################
mostrar_totais:
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_total_inc               # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    li $v0, 1                           # Indica que irá ser printado um inteiro
    move $a0, $s2                       # Move o inteiro a ser mostrado
    syscall                             # Faz a chamada de sistema

    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_total_exc               # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    li $v0, 1                           # Indica que irá ser printado um inteiro
    move $a0, $s1                       # Move o inteiro a ser mostrado
    syscall                             # Faz a chamada de sistema

    j mostrar_menu                      # Retorna para o menu
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
    addi $t0, $t0, 4                    # Pega o valor contido na primeira posição
    move $t2, $s0                       # Move o início da lista para $t2
    addi $t2, $t2, 8                    # Pego o ponteiro próximo
    bne $s0, $zero, listar              # Faz a verificação de nulidade da lista
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_vazia                   # Move a string a ser printada
    syscall                             # Faz a chamada de sistema

    j mostrar_menu                      # Retorna para o menu
###############################################################################
#                            Listar Valores                                   #
###############################################################################
listar:
    lw $t1, 0($t0)                      # Busca na memoria o valor
    li $v0, 1                           # Indica que irá ser printado um inteiro
    move $a0, $t1                       # Move o inteiro a ser mostrado
    syscall                             # Faz a chamada de sistema
    li $v0, 4                           # Indica que irá ser printado uma string
    la $a0, txt_espaco                  # Move a string a ser printada
    syscall                             # Faz a chamada de sistema
    lw $t3, 0($t2)                      # Pega o inicio do próximo elemento da lista
    addi $t0, $t3, 4                    # Posiciona o Ponteiro sob o valor
    addi $t2, $t3, 8                    # Posiciona sob o Ponteiro próximo
    beq $t3, $zero, mostrar_menu        # Verifica se o ponteiro próximo é nulo

    j listar                            # Retorna para Listar o próximo elemento
###############################################################################
#                         Sair do programa                                    #
###############################################################################
op_sair:
    li	$v0, 4                          # Indica que irá ser printado uma string
    la  $a0, txt_sair                   # Move a string a ser printada
    syscall                             # Faz a chamada de sistema
    li $v0, 10                          # Indica que irá finalizar o programa
    syscall                             # Faz a chamada de sistema
