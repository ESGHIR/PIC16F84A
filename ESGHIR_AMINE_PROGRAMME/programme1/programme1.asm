;******************************
;* ESGHIR AMINE               *
;******************************
;* MASTER ESE                 *
;******************************
;*******************************
;* le premiere programme       *
;*******************************
;* Gestion de 2 feux           *
;*******************************
																						
				
; V  O  R     V  O  R
; 8  4  2  1  8  4  2  1 PORTB


LIST p=16F84A   ; Utilisation du circuit 16F84A
 #include <p16F84A.inc>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _HS_OSC ; la configuration de pic


; Equivalence registres
;***********************

PORTB		equ		0x0006	; Adresse du portb
TRISB		equ		0x0086	; Adresse du registre de direction du porta
STATUS		equ		0x0003	; Le bit 5 permet d'acceder à la Banque 1 ou 0 
					; ce qui donne acces au TRIS ou au PORT 
; Constantes
;************

DUREE2R		equ		14h		; 20 secondes
DUREEO		equ		02h		; 2 secondes
DUREEV		equ		04h		; 4 secondes ----------- clignetement 

;* Reservation memoire *
;***********************

; Les registres occupent la RAM jusqu'en OBh

COMPT		equ		0Ch
COMPT1		equ		0Dh
COMPT2		equ		0Eh
DUREE		equ		0Fh


;***************
;Initialisation*
;***************
		org		00h		; Apres le reset le PC pointe l'adresse 00

		goto		debut		; On saute les 5 premiers octets car à l'adresse
						; 04 on a l'adresse d'interruption
						; On prend l'habitude de ne pas ecrire sur ce segment
						; en sautant simplement jusqu'apres ce segment


		org		05h


debut		
		clrf		PORTB		
		bsf		STATUS,05	; Selection de Bank 1 pour l'accès au TRIS
        
		movlw		00h		;
		movwf		TRISB		; Declaration du portb en sortie
		bcf		STATUS,05	; Selection de Bank 0 pour l'accès au PORT
		clrf		PORTB		; Extinction de toutes les LEDS

;*********************
;Programme principal *
;*********************

; 1---On allume le feu "rouge 1" et le feu "vert 2" et on eteint les autres feux

boucle
		BCF PORTB,4
		movlw		02h		; FR1 et FV2 sont allumes
		movwf		PORTB	
;---------------------4 clignotement V2
				BCF PORTB,7
                call tempo_clignotements ; duré 0.5s

                BSF PORTB,7
                call tempo_clignotements ; duré 0.5s

                BCF PORTB,7
                call tempo_clignotements ; duré 0.5s

                BSF PORTB,7
                call tempo_clignotements ; duré 0.5s
				BCF PORTB,7
                call tempo_clignotements  ; duré 0.5s

                BSF PORTB,7
                call tempo_clignotements ; duré 0.5s

                BCF PORTB,7
                call tempo_clignotements ; duré 0.5s

                BSF PORTB,7
                call tempo_clignotements ; duré 0.5s
;----------------------------------------------

; 2---On allume le feu "rouge 1" et le feu "jeune 2" et on eteint les autres feux
		BCF PORTB,4
		movlw		42h		; FR1 et FO2 sont allumes
		movwf		PORTB	
		movlw		DUREEO		; 
		movwf		DUREE		; duree des feux 2s 
		call		tempo	

; 3---On allume le feu "vert 1" et le feu "rouge 2" et on eteint les autres feux
	
		movlw		28h		; FR1 et FO2 sont allumes
		movwf		PORTB	
		movlw		DUREE2R		; 
		movwf		DUREE		; duree des feux 20s
		BSF PORTB,4	
		call		tempo	

; 4---On allume le feu "vert 1" et le feu "rouge 2" et on eteint les autres feux
		BCF PORTB,4
		movlw		20h		; FR1 et FO2 sont allumes
		movwf		PORTB	
;---------------------------------4 fois clignotement V1
				BCF PORTB,3
                call tempo_clignotements  ;duré 0.5s

                BSF PORTB,3
                call tempo_clignotements ;duré 0.5s

                BCF PORTB,3
                call tempo_clignotements ;duré 0.5s

                BSF PORTB,3
                call tempo_clignotements ;duré 0.5s
				BCF PORTB,3
                call tempo_clignotements ;duré 0.5s

                BSF PORTB,3
                call tempo_clignotements ;duré 0.5s

                BCF PORTB,3
                call tempo_clignotements ;duré 0.5s

                BSF PORTB,3
                call tempo_clignotements ;duré 0.5s
;----------------------------------------------
; 5---On allume le feu "jeune 1" et le feu "rouge 2" et on eteint les autres feux
		BCF PORTB,4
		movlw		24h		; FR1 et FO2 sont allumes
		movwf		PORTB	
		movlw		DUREEO		; 
		movwf		DUREE		; duree des feux 2s
		call		tempo	

; 6---On allume le feu "rouge 1" et le feu "vert 2" et on eteint les autres feux
		
		movlw		82h		; FR1 et FO2 sont allumes
		movwf		PORTB	
		movlw		DUREE2R		; 
		movwf		DUREE		; duree des feux 20s
		BSF PORTB,4 
		call		tempo	

		goto		boucle		; feu permanent


;******************
; SOUS PROGRAMME  *
;******************

; SP tempo par passage de parametre duree est en seconde *
;*************************************************************************

tempo

		movlw		0x000A		; chargement de COMPT2 DE 10
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

		decfsz		COMPT2,1	; ON execute les boucles de 100 ms 10 fois  
		goto		delai2		; calcul du temps : 100ms*10=1s

		decfsz		DUREE,1		; ON execute les  boucles de la valeur de duree   
		goto		tempo		; calcul du temps : duree*100ms
		
		return
tempo_clignotements 
		movlw		0x0005		; chargement de COMPT2 DE 10
		movwf		COMPT2		; 
delai22
		movlw		0x00C8		; chargement de COMPT1 DE 200
		movwf		COMPT1		; 
delai1m
		movlw		0x00A5		; chargement de COMPT de 165
		movwf		COMPT
delaii
		decfsz		COMPT,1		; Le temps de decompter 165 valeurs 
		goto		delaii		; calcul du temps : 1 instruction =Tquartz/4=1µs =1 cycle
						; l'instruction decfz est de 2 cycles
						; 2 instructions = 3 µs repeter 165 fois t=495 µs + 2 inst =497µs
		decfsz		COMPT1,1	; ON execute la boucle de 497µs 200 fois + 2 instr dont 1 à 2 cycle
		goto		delai1m		; calcul du temps : 500µs*200=100ms on neglige les 5µs rstant

		decfsz		COMPT2,1	; ON execute les boucles de 100 ms 5 fois  
		goto		delai22
   
return
		end