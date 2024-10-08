.text
    # Reservar espaço na pilha para a matrizA, a matrizB e a matrizC resultante
    addi $sp, $sp, -64

    # Armazenar os valores na matrizA por linha
    li $t0, 1
    sw $t0, 0($sp)    # Armazena 1 na posição 0($sp)
    li $t0, 2
    sw $t0, 4($sp)    # Armazena 2 na posição 4($sp)
    li $t0, 3
    sw $t0, 8($sp)    # Armazena 3 na posição 8($sp)
    li $t0, 4
    sw $t0, 12($sp)   # Armazena 4 na posição 12($sp)
    
    # Armazenar os valores da matrizB na forma transposta para facilitar o cáculo fazendo primeira linha de A com primeira linha B, primeira linha de A com a segunda linha de B...
    li $t0, 5
    sw $t0, 16($sp)    # Armazena 1 na posição 16($sp)
    li $t0, 8
    sw $t0, 20($sp)    # Armazena 2 na posição 20($sp)
    li $t0, 6
    sw $t0, 24($sp)    # Armazena 3 na posição 24($sp)
    li $t0, 9
    sw $t0, 28($sp)   # Armazena 4 na posição 28($sp)
    li $t0, 7
    sw $t0, 32($sp)
    li $t0, 10
    sw $t0, 36($sp)   
    # Multiplicação das mastrizes A e B
    li $t0, 0 #indice inicial da matrizA
    la $s0, 40($sp) #endereço da primeria linha e coluna da matrizC
    la $s5, 0($sp) #endereço da primeria linha e coluna da matrizA
    la $t1, 0($s5) #endereço da primeria linha e coluna da matrizA
    la $t2, 16($sp) #endereço da primeria linha e coluna da matrizB
    li $t8, 16 #acumulador de bytes
    # loop1 das linhas da matrizA
    loop1:
	beq $t0, 2, end_loop1 #linhas da matrizA
	li $t3, 0 #variavel do loop2
	loop2:
		beq $t3, 3, end_loop2 #linhas da matrizB
		li $t7, 0 #acumulador
		li $s1, 0 #variavel do loop3
		loop3:
			beq $s1, 2, end_loop3 #colunas da matrizB
			lw $t4, 0($t1) #acessando valor da matrizA
			lw $t5, 0($t2) #acessando valor da matrizB
			mul $t6, $t4, $t5 #multiplicando os valores das matrizes
			add $t7, $t7, $t6 #adicionando o resultado ao acumulador
			addi $t1, $t1, 4 #acessando endereço da matrizA
			la $s4, 0($t1) #salvando a próxima linha da matriz A caso a sua linha anterior já foi totalmente utilizada
			addi $t2, $t2, 4 #acessando endereço da matrizB
			addi $t8, $t8, 4 #acumulador de bytes
			addi $s1, $s1, 1 #incrementando a varivel do loop3
			j loop3
    
    end_loop3:
    	addi $t3, $t3, 1 #incrementando a varivel do loop2
    	sw $t7, 0($s0) #adicionando valor na matriz C
    	li $v0, 1	#imprimindo elemento da matrizC
    	lw $a0, 0($s0) #imprimindo elemento da matrizC
    	syscall #imprimindo elemento da matrizC
    	li $v0, 11 #imprimir um espaço em branco
    	li $a0, 32 #imprimir um espaço em branco
    	syscall #imprimir um espaço em branco
    	sw $t7, 0($s0) #adicionando valor na matriz C
    	addi $s0, $s0, 4 #acessando endereço da matriz C
    	bne $t8, 40, reseta_linha_matrizA #a linha atual da matrizA ainda não foi calculada com todas as outras linhas da matrizB
    	la $t2, 16($sp) #endereço da primeria linha e coluna da matrizB #a linha atual da matrizA já foi calculada
    	li $t8, 16 #acumulador de bytes
    	j loop2
    	
    end_loop2:
    	la $s5, 0($s4) #próxima linha da matrizA que será calculada
    	addi $t0, $t0, 1 #incrementando a varivel do loop1
    	li $v0, 11       # quebrar  linha (\n)
	li $a0, 10       # quebrar  linha (\n)
	syscall	 	 # quebrar  linha (\n)
    	j loop1
    	
    reseta_linha_matrizA:
    	la $t1, 0($s5) #endereço do primeiro elemento da linha da matrizAa que está sendo calculada
    	j loop2
    	
    # Finalizar o programa
    end_loop1:
    	li $v0, 10
    	syscall
