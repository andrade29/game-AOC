# arena elemental - CRIATON MIPS

.data 
titulo: .asciiz "=== ARENA ELEMENTAL ===\n" 
subtitulo: .asciiz "Fogo, Água e Natureza em batalha\n"

.text
.globl main

main: 

	li $v0, 4    		# O 4 é a função de imprimir STRING
	la $a0, titulo 		# $a0 é um registrador de argumento para o SYSCALL 
	syscall 
	
	li $v0, 4
	la $a0, subtitulo
	syscall 
	
	li $v0, 10 		# O 10 encerra o programa
	syscall 