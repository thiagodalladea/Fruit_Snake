;; Fruit Snake

;; Thiago Prado Dalla Dea - 12691710


;; ------- TABELA DE CORES -------
;; adicione ao caracter para Selecionar a cor correspondente


;; 0 branco							    0000 0000
;; 256 marrom						    0001 0000
;; 512 verde							0010 0000
;; 768 oliva							0011 0000
;; 1024 azul marinho					0100 0000
;; 1280 roxo							0101 0000
;; 1536 teal							0110 0000
;; 1792 prata						    0111 0000
;; 2048 cinza						    1000 0000
;; 2304 vermelho						1001 0000
;; 2560 lima							1010 0000
;; 2816 amarelo					    	1011 0000
;; 3072 azul							1100 0000
;; 3328 rosa							1101 0000
;; 3584 aqua							1110 0000
;; 3840 branco						    1111 0000

;;Listando strings (e strings vazias para limpar strings)
Mensagem_Derrota: 			string " VOCE PERDEU!! " 
Limpa_Mensagem_Derrota:		string "               "
Mensagem_Recomecar:			string " PRESSIONE 'Espaco' para recomecar "
Limpa_Mensagem_Recomecar:	string "                                   "

;;Listando variaveis 
Posicao_Cobra:  var #450
Posicao_Comida:	var #1
Posicao_Fruta: var #1
Tamanho_Cobra:	var #1
Status_Comida:	var #1
Direcao:		var #1






main:
	call Iniciar
	
	Loop:
		Loop_Jogo:
			call Desenha_Cobra
			
			call Cobra_Morreu
		
			call Move_Cobra
			
			call Troca_Comida
					
			call Delay
				
			jmp Loop_Jogo
			
		Loop_Recomecar:
		
			call Recomecar
		
			jmp Loop_Recomecar
;;------------------------------	

;; Inicializa o jogo, configurando a tela, posição inicial da cobra, comida, e direção padrão.
Iniciar:
		
		push r0
		push r1
		
		call Apagar_Tela
		call Desenha_Tela
		
		;; Tamanho da cobra inicial
		loadn r0, #4
		store Tamanho_Cobra, r0
		
		;; Posicao_Cobra[0] = 450
		loadn 	r0, #Posicao_Cobra
		loadn 	r1, #450
		storei 	r0, r1
		
		;; Posicao_Cobra[1] = 449
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		;; Posicao_Cobra[2] = 448
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		;; Posicao_Cobra[3] = 447
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		;; Posicao_Cobra[4] = 446
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		;; Posicao_Cobra[5] = 
		inc 	r0
		loadn 	r1, #0
		storei 	r0, r1
				
		;; Desenha a primeira cobra
		call Primeira_Cobra
		
		;; Direcao inicial
		loadn r0, #0
		store Direcao, r0
		
		pop r1
		pop r0
		
		rts
;;-------------------------------------
		
Desenha_Tela:
	push r1
	push r2
    loadn r1, #tela0Linha0	;; Endereco onde comeca a primeira linha do cenario
	loadn r2, #0	        ;; Utiliza cor branca
	call ImprimirTela2
	pop r1
	pop r2
	
	rts
;;-------------------------------------

;; Desenha a cobra inicial na tela e posiciona a comida na tela.
Primeira_Cobra:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #Posicao_Cobra		;; r0 = END(Posicao_Cobra)
	loadn r1, #2851					;; r1 = '#' em amarelo
	loadi r2, r0					;; r2 = Posicao_Cobra[0]
	loadn r3, #0					;; r3 = 0
	
	Loop_Para_Impressao:
		outchar r1, r2
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Loop_Para_Impressao
	
	
	loadn 	r0, #820
	loadn 	r1, #591       ;; r1 = `O` em cor verde
	outchar r1, r0
	store 	Posicao_Comida, r0
	
	loadn r1, #2392 
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts
;;----------------------------------------

;; Remove a cobra da tela, limpando suas posições atuais.
Limpa_Cobra:
	push r0
	push r1
	push r2
	push r3
	
	loadn 	r0, #Posicao_Cobra		;; r0 = & Posicao_Cobra
	inc 	r0
	loadn 	r1, #' '				;; r1 = ' '
	loadi 	r2, r0					;; r2 = Posicao_Cobra[0]
		
	loadn 	r3, #0					;; r3 = 0
	
	Loop_Para_Impressao:
		outchar r1, r2
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Loop_Para_Impressao
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts
;;-------------------------------------------

;; Atualiza a posição da cobra na direção atual, verifica colisões com comida, fruta ou bordas, e ajusta o tamanho e o corpo da cobra.
Move_Cobra:
	push r0	;; Direcao / Posicao_Cobra
	push r1	;; inchar
	push r2 ;; ajuda local
	push r3
	push r4
	
	;; Sincronização
	loadn 	r0, #5000
	loadn 	r1, #0
	mod 	r0, r6, r0		;; r1 = r0 % r1 (Teste condições de contorno)
	cmp 	r0, r1
	jne Fim_Movimento
	;; =============
	
	;; Verifica se a cabeça da cobra é igual a posição da comida
	Verifica_Comida:
		load 	r0, Posicao_Comida
		loadn 	r1, #Posicao_Cobra
		loadi 	r2, r1
		
		cmp r0, r2
		jne Espalha_Movimento
		
		load 	r0, Tamanho_Cobra
		inc 	r0
		store 	Tamanho_Cobra, r0
		
		loadn 	r0, #0
		dec 	r0
		store 	Status_Comida, r0
		
	Verifica_X:
	    load    r0, Posicao_Fruta  ;; Carrega a posição do X na variável r0
	    loadn   r1, #Posicao_Cobra ;; Carrega o endereço da posição da cobra na variável r1
	    loadi   r2, r1             ;; Carrega a posição da cabeça da cobra (Posicao_Cobra[0])

	    cmp     r0, r2             ;; Compara a posição do X com a posição da cabeça
	    jne     Espalha_Movimento  ;; Se não coincidem, continua o movimento

	    ;; Se coincidem, termina o jogo
	    call    Cobra_Morreu        ;; Chama a sub-rotina para fim de jogo
		
	;; Atualização das posições do corpo da cobra durante movimetno
	Espalha_Movimento:
		loadn 	r0, #Posicao_Cobra ;; aponta inicio do vetor
		loadn 	r1, #Posicao_Cobra ;; aponta para o mesmo, para acessar as posicoes anteriores da cobra
		load 	r2, Tamanho_Cobra  ;; carrega o tamanho atual
		
		add 	r0, r0, r2		;; r0 = Posicao_Cobra[Size]
		
		dec 	r2				;; r1 = Posicao_Cobra[Size-1]
		add 	r1, r1, r2		;; aponta para a penultima posicao
		
		loadn 	r4, #0
		
		Loop_Espalha_Movimento:
			loadi 	r3, r1	;; penultima parte do corpo da cobra
			storei 	r0, r3	;; armazena essa posição na próxima parte do corpo 
			
			dec r0		;; move os ponteiro para posicoes anteriores no vetor
			dec r1
			
			cmp r2, r4	;; compara indice
			dec r2
			;; repete se r2 n for zero
			jne Loop_Espalha_Movimento	
	
	Muda_Direcao:
		inchar 	r1
		;; escolhe direcao do movimento

		loadn r2, #100	;; 'D'
		cmp r1, r2
		jeq Move_D
		
		loadn r2, #115	;; 'S'
		cmp r1, r2
		jeq Move_S
		
		loadn r2, #97	;; 'A'
		cmp r1, r2
		jeq Move_A
		
		loadn r2, #119	;; 'W'
		cmp r1, r2
		jeq Move_W		
		
		jmp Atualiza_Movimento
		;; movimentos
		Move_D:
			loadn 	r0, #0
			;; Impede de "ir pra trás"
			loadn 	r1, #2
			load  	r2, Direcao
			cmp 	r1, r2
			jeq 	Move_Para_Esquerda
			
			store 	Direcao, r0
			jmp 	Move_Para_Direita
		Move_S:
			loadn 	r0, #1
			;; Impede de "ir pra trás"
			loadn 	r1, #3
			load  	r2, Direcao
			cmp 	r1, r2
			jeq 	Move_Para_Cima
			
			store 	Direcao, r0
			jmp 	Move_Para_Baixo
		Move_A:
			loadn 	r0, #2
			;; Impede de "ir pra trás"
			loadn 	r1, #0
			load  	r2, Direcao
			cmp 	r1, r2
			jeq 	Move_Para_Direita
			
			store 	Direcao, r0
			jmp 	Move_Para_Esquerda
		Move_W:
			loadn 	r0, #3
			;; Impede de "ir pra trás"
			loadn 	r1, #1
			load  	r2, Direcao
			cmp 	r1, r2
			jeq 	Move_Para_Baixo
			
			store 	Direcao, r0
			jmp 	Move_Para_Cima
	
	Atualiza_Movimento:
		load 	r0, Direcao
				
		loadn 	r2, #0
		cmp 	r0, r2
		jeq 	Move_Para_Direita
		
		loadn 	r2, #1
		cmp 	r0, r2
		jeq 	Move_Para_Baixo
		
		loadn 	r2, #2
		cmp 	r0, r2
		jeq 	Move_Para_Esquerda
		
		loadn 	r2, #3
		cmp 	r0, r2
		jeq 	Move_Para_Cima
		
		jmp Fim_Movimento
		
		Move_Para_Direita:
			loadn 	r0, #Posicao_Cobra	;; r0 = & Posicao_Cobra
			loadi 	r1, r0			;; r1 = Posicao_Cobra[0]
			inc 	r1				;; r1++
			storei 	r0, r1
			
			jmp Fim_Movimento
				
		Move_Para_Baixo:
			loadn 	r0, #Posicao_Cobra	;; r0 = & Posicao_Cobra
			loadi 	r1, r0			;; r1 = Posicao_Cobra[0]
			loadn 	r2, #40
			add 	r1, r1, r2
			storei 	r0, r1
			
			jmp Fim_Movimento
		
		Move_Para_Esquerda:
			loadn 	r0, #Posicao_Cobra	;; r0 = & Posicao_Cobra
			loadi 	r1, r0			;; r1 = Posicao_Cobra[0]
			dec 	r1				;; r1--
			storei 	r0, r1
			
			jmp Fim_Movimento
			
		Move_Para_Cima:
			loadn 	r0, #Posicao_Cobra	;; r0 = & Posicao_Cobra
			loadi 	r1, r0			;; r1 = Posicao_Cobra[0]
			loadn 	r2, #40
			sub 	r1, r1, r2
			storei 	r0, r1
		
			jmp Fim_Movimento
	
	
	Fim_Movimento:
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0

	rts
;;----------------------------------------------

;; atualiza a tela com a posição atual da cobra e da comida, limpa a última posição do rastro da cobra
Desenha_Cobra:
	push r0
	push r1
	push r2
	push r3 

	;; Sincronização
	loadn 	r0, #1000
	loadn 	r1, #0
	mod 	r0, r6, r0		;; r1 = r0 % r1 (Teste condições de contorno)
	cmp 	r0, r1
	jne Fim_Desenha_Cobra
	;; =============
	
	call Desenha_Tela
	
	load 	r0, Posicao_Comida
	loadn 	r1, #591       ;; r1 = `O` em cor verde
	outchar r1, r0
	
	loadn 	r0, #Posicao_Cobra	;; r0 = end Posicao_Cobra
	loadn 	r1, #2851	    ;; r1 = '#' em amarelo'
	loadi 	r2, r0			;; r2 = Posicao_Cobra[0]
	outchar r1, r2			
	
	loadn 	r0, #Posicao_Cobra	;; r0 = & Posicao_Cobra
	loadn 	r1, #' '		;; r1 = ' '
	load 	r3, Tamanho_Cobra	;; r3 = Tamanho_Cobra
	add 	r0, r0, r3		;; r0 += Tamanho_Cobra
	loadi 	r2, r0			;; r2 = Posicao_Cobra[Tamanho_Cobra]
	outchar r1, r2
	

	Fim_Desenha_Cobra:
		pop	r3
		pop r2
		pop r1
		pop r0
	
	rts
;;----------------------------------
Troca_Comida:
    push r0
    push r1
    push r2
    push r3

    ;; Verifica se a comida foi pega
    loadn   r0, #0
    dec     r0
    load    r1, Status_Comida
    cmp     r0, r1
    jne     Fim_Troca

    ;; Reposiciona a comida
    loadn   r1, #0
    store   Status_Comida, r1
    load    r1, Posicao_Comida

    load    r0, Direcao

    loadn   r2, #0
    cmp     r0, r2
    jeq     Troca_Direita

    loadn   r2, #1
    cmp     r0, r2
    jeq     Troca_Baixo

    loadn   r2, #2
    cmp     r0, r2
    jeq     Troca_Esquerda

    loadn   r2, #3
    cmp     r0, r2
    jeq     Troca_Cima


    ;; COMIDA PEGA PELA DIREITA = ACRESCENTA 220 NA POSICAO E VE SE ESTA NO LIMITE
    Troca_Direita:
        loadn   r3, #220
        add     r1, r1, r3
        jmp     Troca_Limites
    ;; COMIDA PEGA POR BAIXO ACRESCENTA 490 NA POSICAO E VE SE ESTA NO LIMITE
    Troca_Baixo:
        loadn   r3, #490
        sub     r1, r1, r3
        jmp     Troca_Limites
    ;; COMIDA PEGA PELA ESQUERDA ACRESCENTA 500 NA POSICAO E VE SE ESTA NO LIMITE
    Troca_Esquerda:
        loadn   r3, #500
        sub     r1, r1, r3
        jmp     Troca_Limites
    ;; COMIDA PEGA POR CIME ACRESCENTA 300 NA POSICAO E VE SE ESTA NO LIMITE
    Troca_Cima:
        loadn   r3, #300
        add     r1, r1, r3
        jmp     Troca_Limites
    
    ;; VERIFICA SE A POSICAO ESTA NOS LIMITES JOGAVEIS
    Troca_Limites:
        loadn   r2, #40 ;; primeira linha jogavel
        cmp     r1, r2
        jle     Troca_Para_Baixo ;; se for menor

        loadn   r2, #1160
        cmp     r1, r2
        jgr     Troca_Para_Cima ;; se for maior
        
        loadn   r0, #40
        loadn   r3, #1
        mod     r2, r1, r0
        cmp     r2, r3
        jel     Troca_Para_Esquerda ;; menor igual a 1 (borda)

        loadn   r0, #40
        loadn   r3, #39
        mod     r2, r1, r0
        cmp     r2, r3
        jeg     Troca_Para_Direita ;; maior igual a 39 (borda)

        jmp     Realiza_Troca

    ;; define como 220
    Troca_Para_Cima:
        loadn   r1, #220
        jmp     Realiza_Troca
    ;; define como 1020
    Troca_Para_Baixo:
        loadn   r1, #1020
        jmp     Realiza_Troca
    ;; define como 815
    Troca_Para_Direita:
        loadn   r1, #815
        jmp     Realiza_Troca
    ;; define como 225
    Troca_Para_Esquerda:
        loadn   r1, #225
        jmp     Realiza_Troca

    Realiza_Troca:
        ;; Salva a nova posição da comida
        store   Posicao_Comida, r1
        loadn   r0, #591       ;; `O` em cor verde
        outchar r0, r1
        
        
        ;; GERA O X

        ;; Gera o "X" vermelho sempre 10 posições à frente
        loadn   r2, #10           ;; Incremento fixo
        add     r3, r1, r2        ;; r3 = r1 + 10 (nova posição do X)
        store   Posicao_Fruta, r3 ;; Salva a nova posição do X

        ;; Desenha o "X" vermelho
        loadn   r0, #2392      ;; `X` em cor vermelha
        outchar r0, r3         ;; Imprime o "X" na posição calculada

    Fim_Troca:
        pop r3
        pop r2
        pop r1
        pop r0

    rts
;;------------------------------------------------------------

;;------------------------------------------------------------

Cobra_Morreu:
    push    r0
    push    r1
    push    r2
    push    r3
    push    r4

    ;; Posição da cabeça da cobra
    loadn   r0, #Posicao_Cobra
    loadi   r1, r0           ;; r1 = Posicao_Cobra[0]
    
    ;; Verifica se pegou o "X"
    Verifica_X:
        load    r2, Posicao_Fruta
        cmp     r1, r2       ;; Compara posição da cabeça com posição do "X"
        jeq     Tratamento_Fim_Jogo ;; Se coincidem, termina o jogo

    ;; Verifica se bateu nas bordas
    loadn   r2, #40
    loadn   r3, #39
    mod     r2, r1, r2       ;; r2 = r1 % 40 (colisão com borda direita)
    cmp     r2, r3
    jeq     Tratamento_Fim_Jogo

    loadn   r2, #40
    loadn   r3, #0
    mod     r2, r1, r2       ;; r2 = r1 % 40 (colisão com borda esquerda)
    cmp     r2, r3
    jeq     Tratamento_Fim_Jogo

    loadn   r2, #40
    cmp     r1, r2           ;; Colisão com borda superior
    jle     Tratamento_Fim_Jogo

    loadn   r2, #1160
    cmp     r1, r2           ;; Colisão com borda inferior
    jgr     Tratamento_Fim_Jogo

    ;; Verifica se bateu no próprio corpo
    Verifica_Colisao:
        load    r2, Tamanho_Cobra
        loadn   r3, #1
        loadi   r4, r0       ;; r4 = posição da cabeça da cobra

        Loop_Colisao:
            inc     r0
            loadi   r1, r0
            cmp     r1, r4
            jeq     Tratamento_Fim_Jogo

            dec     r2
            cmp     r2, r3
            jne     Loop_Colisao

    jmp     Fim_Cobra_Morreu
    
    
	;; apaga tela e termina o jogo
    Tratamento_Fim_Jogo:
        call    Apagar_Tela

        ;; Apaga a comida e o "X" da tela
        load    r0, Posicao_Comida
        loadn   r1, #' '
        outchar r1, r0

        load    r0, Posicao_Fruta
        loadn   r1, #' '
        outchar r1, r0

        ;; Exibe mensagem de derrota
        loadn   r0, #613
        loadn   r1, #Mensagem_Derrota
        loadn   r2, #2304
        call    Imprimir

        loadn   r0, #684
        loadn   r1, #Mensagem_Recomecar
        loadn   r2, #512
        call    Imprimir

        ;; Entra no loop de reinicialização
        jmp     Loop_Recomecar

    Fim_Cobra_Morreu:
        pop     r4
        pop     r3
        pop     r2
        pop     r1
        pop     r0
        rts

;;-----------------------------------------------------
	
Delay:
	push r0
	
	inc r6
	loadn r0, #10000
	cmp r6, r0
	jgr Reseta_Timer
	
	jmp Fim_Timer
	
	Reseta_Timer:
		loadn r6, #0
	Fim_Timer:		
		pop r0
	
	rts
;;-----------------------------------------------------

Recomecar:
	inchar 	r0
	loadn 	r1, #' '
	
	cmp r0, r1
	jeq Tratamento_Recomecar
	
	jmp Fim_Recomecar
	
	Tratamento_Recomecar:
		loadn r0, #609
		loadn r1, #Limpa_Mensagem_Derrota
		loadn r2, #0
		call Imprimir
		
		loadn r0, #684
		loadn r1, #Limpa_Mensagem_Recomecar
		loadn r2, #0
		call Imprimir
	
		call Limpa_Cobra
		call Iniciar
		
		jmp Loop_Jogo
		
	Fim_Recomecar:
	
	rts
;;-----------------------------------------------------------------

Imprimir:
	push r0		;; Posição na tela para imprimir a string
	push r1		;; Endereço da string a ser impressa
	push r2		;; Cor da mensagem
	push r3
	push r4

	
	loadn r3, #'\0'

	Loop_Imprimir:	
		loadi r4, r1
		cmp r4, r3
		jeq Fim_Imprimir
		add r4, r2, r4
		outchar r4, r0
		inc r0
		inc r1
		jmp Loop_Imprimir
		
	Fim_Imprimir:	
		pop r4	
		pop r3
		pop r2
		pop r1
		pop r0
		
	rts
;;---------------------------------------------------------
;;                   IMPRIME STRING
	
ImprimeStr:	;;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;;  r1 = endereco onde comeca a mensagem;; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	;; protege o r0 na pilha para preservar seu valor
	push r1	;; protege o r1 na pilha para preservar seu valor
	push r2	;; protege o r1 na pilha para preservar seu valor
	push r3	;; protege o r3 na pilha para ser usado na subrotina
	push r4	;; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	;; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		;; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	;; Soma a Cor
		outchar r4, r0	;; Imprime o caractere na tela
		inc r0			;; Incrementa a posicao na tela
		inc r1			;; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	;; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;;------------------------	

;;Imprimir TELA2

ImprimirTela2: 	;;  Rotina de Impresao de Cenario na Tela Inteira
		;;  r1 = endereco onde comeca a primeira linha do Cenario
		;;  r2 = cor do Cenario para ser impresso

	push r0	;; protege o r3 na pilha para ser usado na subrotina
	push r1	;; protege o r1 na pilha para preservar seu valor
	push r2	;; protege o r1 na pilha para preservar seu valor
	push r3	;; protege o r3 na pilha para ser usado na subrotina
	push r4	;; protege o r4 na pilha para ser usado na subrotina
	push r5	;; protege o r5 na pilha para ser usado na subrotina
	push r6	;; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	;; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	;; Incremento da posicao da tela!
	loadn R4, #41  	;; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ;; Limite da tela!
	loadn R6, #tela0Linha0	;; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimirTela2_Loop:
		call Imprimir_String
		add r0, r0, r3  	;; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	;; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	;; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			;; Compara r0 com 1200
		jne ImprimirTela2_Loop	;; Enquanto r0 < 1200

	pop r6	;; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;;---------------------

;;Imprimir STRING2
	
Imprimir_String:	;;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;;  r1 = endereco onde comeca a mensagem;; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	;; protege o r0 na pilha para preservar seu valor
	push r1	;; protege o r1 na pilha para preservar seu valor
	push r2	;; protege o r1 na pilha para preservar seu valor
	push r3	;; protege o r3 na pilha para ser usado na subrotina
	push r4	;; protege o r4 na pilha para ser usado na subrotina
	push r5	;; protege o r5 na pilha para ser usado na subrotina
	push r6	;; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	;; Criterio de parada
	loadn r5, #' '	;; Espaco em Branco

   Imprimir_String_Loop:	
		loadi r4, r1
		cmp r4, r3		;; If (Char == \0)  vai Embora
		jeq Imprimir_String_Sai
		cmp r4, r5		;; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq Imprimir_String_Skip
		add r4, r2, r4	;; Soma a Cor
		outchar r4, r0	;; Imprimir o caractere na tela
   		storei r6, r4
   Imprimir_String_Skip:
		inc r0			;; Incrementa a posicao na tela
		inc r1			;; Incrementa o ponteiro da String
		inc r6
		jmp Imprimir_String_Loop
	
   Imprimir_String_Sai:	
	pop r6	;; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;;APAGA TELA
Apagar_Tela:
	push r0
	push r1
	
	loadn r0, #1200		;; apaga as 1200 posicoes da Tela
	loadn r1, #' '		;; com "espaco"
	
	   Apagar_Tela_Loop:	;;;;label for(r0=1200;;r3>0;;r3--)
		dec r0
		outchar r1, r0
		jnz Apagar_Tela_Loop
 
	pop r1
	pop r0
	rts	

;; Desenho do fundo da tela
tela0Linha0  : string "|--------------------------------------|"
tela0Linha1  : string "|                                      |"
tela0Linha2  : string "|                                      |"
tela0Linha3  : string "|                                      |"
tela0Linha4  : string "|                                      |"
tela0Linha5  : string "|                                      |"
tela0Linha6  : string "|                                      |"
tela0Linha7  : string "|                                      |"
tela0Linha8  : string "|                                      |"
tela0Linha9  : string "|                                      |"
tela0Linha10 : string "|                                      |"
tela0Linha11 : string "|                                      |"
tela0Linha12 : string "|    -----  | | |   /|  |--| |--|      |"
tela0Linha13 : string "|      |    |-| |  /-|  |  | |  |      |"
tela0Linha14 : string "|      |    | | | /  |  |--| |__|      |"
tela0Linha15 : string "|                          |           |"
tela0Linha16 : string "|                        __|           |"
tela0Linha17 : string "|                                      |"
tela0Linha18 : string "|                                      |"
tela0Linha19 : string "|                                      |"
tela0Linha20 : string "|                                      |"
tela0Linha21 : string "|                                      |"
tela0Linha22 : string "|                                      |"
tela0Linha23 : string "|                                      |"
tela0Linha24 : string "|                                      |"
tela0Linha25 : string "|                                      |"
tela0Linha26 : string "|                                      |"
tela0Linha27 : string "|                                      |"
tela0Linha28 : string "|                                      |"
tela0Linha29 : string "|--------------------------------------|"