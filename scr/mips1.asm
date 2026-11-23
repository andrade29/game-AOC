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


.text
.globl main

main: 

	li $v0, 4    		# O 4 é a função de imprimir STRING
	la $a0, titulo 		# $a0 é um registrador de argumento para o SYSCALL 
	syscall 
	
	li $v0, 4
	la $a0, subtitulo
	syscall 
	
	
menu_loop: 

	
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
	beq $t0, $t1, concentrar 	# " " " " 
	
	li $v0, 4 
	la $a0, msg_invalida 	# Caso a entrada não seja 1,2,3 aparece uma mensagem inválida
	syscall 
	
	j menu_loop 		# jump para o início da flag menu_loop
	

atacar: 

	li $v0, 4 
	la $a0, msg_ataque 	# a0 recebe o endereço de memória da string ' msg_ataque ' 
	syscall 
	
	j menu_loop
	
defender:

	li $v0, 4
	la $a0, msg_defesa
	syscall 
	
	j menu_loop

concentrar: 
	
	li $v0, 4
	la $a0, msg_concentrar
	syscall
	
	j menu_loop
	
sair:

	li $v0, 4
	la $a0, msg_sair 
	syscall
	li $v0, 10 		# Função 10 para encerrar o programa
	syscall 
	
