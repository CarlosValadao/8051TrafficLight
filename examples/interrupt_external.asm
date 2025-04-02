	;Requisito 4.3.3, 4.3.4 e 4.3.5
	ORG 0
	LJMP MAIN
	
	ORG  0003H
	LJMP SINTE0

	ORG  0013H
	LJMP SINTE1
	
	ORG  0050H
	
MAIN:
	MOV IE, #10000101B ;Configuração das interrupções externas
	MOV IP, #00000101B ;Configuração da prioridade da interrupção
	MOV R0, #7H        ;Simula o contador do LED Vermelho
	MOV R1, #0AH       ;Simula o contador do LED Verde
	MOV R2, #3H        ;Simula o contador do LED Amarelo
	MOV R3, #000H      ;Informa se o sinal está vermelho (1true/0false)
	MOV R4, #006H      ;Usado para verificar se está passando mais de 5 veículos
	MOV B,  #000H      ;Simula a quantidade de veículos
	MOV P0, #0FFH      ;Usado para controlar os LEDs

LEDG:	CLR  P0.0
	DJNZ R1, LEDG
	SETB P0.0
	SJMP LEDY


LEDY:   CLR  P0.1
	DJNZ R2, LEDY
	SETB P0.1
	SJMP LEDV


LEDV:	CLR  P0.2
	MOV  R3, #1D
	DJNZ R0, LEDV
	SETB P0.2
	SJMP MAIN


SINTE0: ;Trata a interrupçao externa INT0 (P3.2)
	MOV R0, #000H
	MOV R0, #00FH
	RETI

SINTE1: ;Trata a interrupçao externa INT1 (P3.3)
        CJNE R3, #0D, NOTHING
	INC  B
	MOV  A, B
	XRL  A, R4
	JZ   INCV
	RETI

NOTHING:
	RETI


INCV:
	MOV R1, #000H
	MOV R1, #00FH
	RETI
	END
