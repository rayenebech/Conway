myss		SEGMENT PARA STACK 'yigin'
			DW 100 DUP(?)
myss		ENDS

myds		SEGMENT PARA 'veri'
n           DW 10   
myds		ENDS

			    
;CONWAY YORDAMI

mycode1		SEGMENT PARA 'kod2'
		    ASSUME CS:mycode1
CONWAY  	PROC FAR 
            PUSH BP
			PUSH AX
			PUSH CX
			MOV BP, SP 
			MOV CX, [BP+10] ;find value of n
			
			CMP CX,0
			JE ZERO
			CMP CX,1
			JE SON
			CMP CX,2
			JE SON
			
			;first call of a(n-1)
			PUSH DX;value will be returned here (for local calls only)
			DEC CX
			PUSH CX
			CALL FAR PTR CONWAY
			;the [BP+2] has the value of a(n-1)
			POP AX ; AX now has the value of a(n-1)
			
			;second call of a(a(n-1))
			PUSH DX	;to return value of a(a(n-1))
			PUSH AX ;will be the new n = a(n-1)
			CALL FAR PTR CONWAY
			
			
			;the top of the stack now has the value of[BP] has a(a(n-1)) 			
			
			;Third callof a(n-a(n-1))
			MOV BP,SP
			INC CX ; CX now has the value of n
			SUB CX,AX
			; CX has the value of n-a(n-1)
			PUSH DX ;to return the value
			PUSH CX
			CALL FAR PTR CONWAY
			
			POP DX ;a(n-a(n))
			POP AX ;a(a(n-1))
			ADD AX,DX
			MOV BP,SP
			MOV [BP+12],AX
			JMP L1
						
SON:		
			MOV WORD PTR [BP+12],1
L1:			pop CX
			POP AX 
			POP BP
			RETF 2
			
			
ZERO: 		MOV WORD PTR [BP+12],0	
			pop CX
			POP AX 
			POP BP
			RETF 2  
		 
CONWAY	    ENDP
mycode1		ENDS
;END OF CONWAY

;PRINTINT YORDAMI

mycode2		SEGMENT PARA 'kod3'
		    ASSUME CS:mycode2
PRINTINT  	PROC FAR 
			PUSH BP
			MOV BP,SP
			
			MOV AX,[BP+6]
			;sonuç sıfır ise
			CMP AX,0
			JNE DEVAM
			MOV DX,48
			MOV AH,02H
			INT 21H
			JMP DONE
     
DEVAM: 		MOV BX,10 
			XOR SI,SI
    
D2:			CMP AX,0
			JE  D1
			XOR DX,DX
			DIV BX
			PUSH DX
			INC SI  
			JMP D2

D1:         CMP SI,0
			JE DONE
			POP DX
			ADD DX,48
			
			MOV AH,02H
			INT 21H
			
			DEC SI
			JMP D1
DONE:    	POP BP
			RETF 2
PRINTINT    ENDP
mycode2		ENDS
;END OF PRINTINT


globalcode	SEGMENT PARA 'kod'
			ASSUME CS:globalcode, DS:myds, SS:myss
					
ANA 		PROC FAR
			PUSH DS
			XOR AX, AX
			PUSH AX
			MOV AX, myds
			MOV DS, AX
			
			PUSH DX
			PUSH n
			CALL CONWAY
			POP DX	;sonuc burada 
			PUSH DX
			CALL PRINTINT			
			RETF
ANA			ENDP
globalcode	ENDS           

			END ANA         