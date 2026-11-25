# arena elemental - CRIATON MIPS

.data 
titulo: .asciiz "=== ARENA ELEMENTAL ===\n" 
subtitulo: .asciiz "Fogo, Água, Terra e Natureza em batalha\n"
menu: .asciiz "\n[1] Atacar [2] Defender [3] Concentrar [0] Desistir\n"
msg_ataque: .asciiz " >>>>> Você atacou!\n"
msg_defesa: .asciiz ">>>>> Você defendeu!\n" 
msg_concentrar: .asciiz ">>>>> Você concentrou!\n"
msg_invalida: .asciiz ">>>>> Opção inválida! Tente novamente!\n"
msg_sair: .asciiz ">>>>> Fim de Jogo!\n" 
msg_rodada: .asciiz ">>>>> Rodada "
msg_rodada_fim: .asciiz " <<<<< \n"
msg_sem_energia: .asciiz ">>>>> Energia insuficiente! O ataque precisa de 15.\n"
jog1: .word 0, 100, 50	# [elemnto, vida e energia]
jog2: .word 1, 100, 50 
txt_j1: .asciiz "\nJogador 1 - Vida: "
txt_j2: .asciiz "Jogador 2 - Vida: "
txt_energia:  .asciiz "  Energia: "
txt_vez: .asciiz "\nVez do Jogador "
msg_vitoria: .asciiz "\n***** VITORIA DO JOGADOR "
msg_fim_vit: .asciiz " *****\n"
quebra_linha: .asciiz "\n"


.text
.globl main

main: 

	li $v0, 4    		# O 4 é a função de imprimir STRING
	la $a0, titulo 		# $a0 é um registrador de argumento para o SYSCALL 
	syscall 
	
	li $v0, 4
	la $a0, subtitulo
	syscall 
	
	li $s1, 0 		# registrador $s são usados para guardar valores a longo prazo e que não podem se perder // carregando o jogador 1
	
	
menu_loop: 
	
#===============================================================================================================================#
				#jogador 1 
				
	li $v0, 4
	la $a0, txt_j1		# texto de vida do jogador 1 
	syscall
	
	la $t3, jog1		# usarei o t3 para iniciliazlir o jogador 1
	lw $a0, 4($t3) 		# lw usado para ler uma palavra de 4bytes da memória e 4($t3) porque a .word ocupa 4 bytes // aqui é a vida
	li $v0, 1 		# a função 1 imprime um inteiro
	syscall
	
	li $v0, 4
	la $a0, txt_energia
	syscall
	
	lw $a0, 8($t3)		# como foi declarado elemento, vida e energia a energia fica +8
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, quebra_linha
	syscall
	
#===============================================================================================================================#
				#jogador 2

	li $v0, 4
	la $a0, txt_j2		# "Jogador 2 - Vida: "
	syscall

	la $t3, jog2		# agora $t3 aponta para o jog2
	lw $a0, 4($t3)		# vida do jogador 2
	li $v0, 1
	syscall

	li $v0, 4
	la $a0, txt_energia
	syscall

	lw $a0, 8($t3)		# energia do jogador 2
	li $v0, 1
	syscall

	li $v0, 4
	la $a0, quebra_linha
	syscall
#===============================================================================================================================#
				# decide a vez do jogador
				
	beq $s1, $zero, vez_j1 #condicional if do jogador 1
	
	la $s2, jog2		#vez do jogador 2
	la $s3, jog1		
	j vez_atual 
	
vez_j1:
	
	la $s2, jog1		#vez do jogador 1 agir
	la $s3, jog2

vez_atual:
	
	li $v0, 4
	la $a0, txt_vez
	syscall
	addi $a0, $s1, 1	#reutilizamos $s1 para mostrar a vez de x jogador
	
	li $v0, 1
	syscall 
#===============================================================================================================================#


				#menu e desvios (jumps) 
				
				
	li $v0, 4 		#mostrar menu
	la $a0, menu 		#carregando o endereço de memória de menu no registrador de argumento a0 
	syscall 
	
	li $v0, 5 		# A função 5 lê um inteiro no registrador de função %v
	syscall 
	move $t0, $v0 		# A entrada do usuário passa para o registrador temporário t0 
	
	addi $s0, $s0, 1  	#contador de rodadas
	
	li $v0, 4
	la $a0, msg_rodada	#primeira parte da mensagem de rodada
	syscall 
	
	li $v0, 1 
	move $a0, $s0 		#passa o número da rodada para que seja iterativo 
	syscall 
	
	li $v0, 4
	la $a0, msg_rodada_fim
	syscall 
	
	beq $t0, $zero, sair	# se o t0 for igual a zero, pulo para a flag de saída do programa 
	
	li $t1, 1
	beq $t0, $t1, atacar 	#se o t1 for igual a um, pulo para a flag de atacar...
	
	li $t1, 2 
	beq $t0, $t1, defender 	# " " " " 
	
	li $t1, 3
	beq $t0, $t1, concentrar # " " " " 
	
	li $v0, 4 
	la $a0, msg_invalida 	# Caso a entrada não seja 1,2,3 aparece uma mensagem inválida
	syscall 
	
	j menu_loop 		# jump para o início da flag menu_loop
	

atacar: 
	
	lw $t2, 8($s2)		# lendo da memória a energia do ATUAL JOGADOR e carregando no registrador
	li $t1, 15
	blt $t2, $t1, sem_energia	# se a energia atual for menor que 15 jump para sem_energia
	
	addi $t2, $t2, -15 	# aqui o jogador perde energia por ataque
	sw $t2, 8($s2) 		# faz a gravação/atualização na memória
	
	lw $t3, 4($s3)		# lendo da memória a vida do ALVO
	addi $t3, $t3, -20	# alvo perde 20 de vida
	sw $t3, 4($s3)		
	
	li $v0, 4 
	la $a0, msg_ataque 	# a0 recebe o endereço de memória da string ' msg_ataque ' 
	syscall 
	
	
	j trocar_vez
	
defender:

	li $v0, 4
	la $a0, msg_defesa
	syscall 
	
	j trocar_vez

concentrar: 

	lw $t2, 8($s2)		# carrega a energia da memória
	addi $t2, $t2, 20	#soma 20 de energia no JOGADOR ATUAL
	
	li $t1, 100
	ble $t2, $t1, conc_ok	# se energia carregada em $t2 for menor ou igual a $t1 ( <= 100 ) OK
	li $t2, 100		# senão, limito em 100
conc_ok:
	
	sw $t2, 8($s2)		#gravo a nova energia na memória
	
	li $v0, 4
	la $a0, msg_concentrar
	syscall
	
	j trocar_vez
	
trocar_vez:
	
	xori $s1, $s1, 1 	# 0 vira 1 e 1 vira 0
	j menu_loop
	

sem_energia:
	
	li $v0, 4	# mostrando a mensagem de sem energia SEM passar a vez
	la $a0, msg_sem_energia
	syscall
	j menu_loop
sair:

	li $v0, 4
	la $a0, msg_sair 
	syscall
	li $v0, 10 		# Função 10 para encerrar o programa
	syscall 
	
