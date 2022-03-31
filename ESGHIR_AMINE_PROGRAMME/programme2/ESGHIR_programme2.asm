LIST p=16F84A   ; definition de processeur
 #include <p16F84A.inc>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _HS_OSC

COMPT		equ		0Ch
COMPT1		equ		0Dh
COMPT2		equ		0Eh
DUREE		equ		0Fh

			
	            ORg 0x00
                goto start
                start
                ; _ _ _ _ _ _ accé au bank1 
                BSF STATUS, RP0
				BSF  TRISA,4 ;---INPUT
				clrf TRISB
				BCF STATUS, RP0



				;programme principal
				clrf PORTB
		loop 	BTFSS PORTA,4
				goto loop
				call decomptage
				goto loop





                     ;21 sec
 decomptage     clrf PORTB
				BSF PORTB,5 ;-----------------20
				call tempo_clignotements
                call tempo_clignotements
				movlw b'00011001'
				movwf PORTB
					;19
			MM  call tempo_clignotements
				call tempo_clignotements
				decf PORTB,f
				btfsc PORTB , 4
				goto MM
					;9
				movlw b'00001001'
				movwf PORTB
            KK  call tempo_clignotements ;
				call tempo_clignotements
                decf PORTB,f
                clrw
                subwf PORTB,W
                BTFSS STATUS,Z 
                goto KK	
                RETURN

return


               
 

tempo_clignotements 

		movlw		0x0005		; chargement de COMPT2 DE 10
		movwf		COMPT2		; 
delai2
		movlw		0x00C8		; chargement de COMPT1 DE 200
		movwf		COMPT1		; 
delai1
		movlw		0x00A5		; chargement de COMPT de 165
		movwf		COMPT
delai
		decfsz		COMPT,1		; Le temps de decompter 165 valeurs 
		goto		delai		; calcul du temps : 1 instruction =Tquartz/4=1µs =1 cycle
						; l'instruction decfz est de 2 cycles
						; 2 instructions = 3 µs repeter 165 fois t=495 µs + 2 inst =497µs
		decfsz		COMPT1,1	; ON execute la boucle de 497µs 200 fois + 2 instr dont 1 à 2 cycle
		goto		delai1		; calcul du temps : 500µs*200=100ms on neglige les 5µs rstant

		decfsz		COMPT2,1	; ON execute les boucles de 100 ms 5 fois  
		goto		delai2
   
return
end