;Time of 7s
	ORG 0
	LJMP MAIN
	ORG 000BH
	LJMP ISRT0
	ORG 0050H

MAIN:	
	MOV R0, #140D
	MOV TH0, #3CH
	MOV TL0, #0AFH
	MOV TMOD, #00000001B
	MOV IE, #10000010B
	SETB TR0

LOOP:   
	SJMP LOOP
        ORG 0100H

RESTART_TIMER_COUNTER:
	MOV R0, #140D
	RET
	
	
ISRT0: 
       CPL P2.0
       MOV TH0, #0FFH
       MOV TL0, #0FAH
       DJNZ R0, RESTART_TIMER_COUNTER
       RETI
       END

