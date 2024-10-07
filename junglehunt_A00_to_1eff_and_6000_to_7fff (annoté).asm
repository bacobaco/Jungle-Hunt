0A00:4C 66 0A    JMP $0A66
0A03:6C 00 13    JMP ($1300) =>6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
0A06:6C 02 13    JMP ($1302) =>618E
0A09:6C 04 13    JMP ($1304) =>63C9
0A0C:6C 06 13    JMP ($1306) =>64EC		; Gestion des registres $D4, $D5, $D6 et $D7 pour le mode JOYSTICK
0A0F:6C 08 13    JMP ($1308) =>654E		; Gestion de la touche 'ESC' dans le jeu (PAUSE IN GAME)
0A12:6C 0A 13    JMP ($130A) =>65C6		; Sauvegarde page 0 dans $1c00 et $1f00 dans page 0
0A15:6C 0C 13    JMP ($130C) =>65D8		; Sauvegarde page 0 dans $1f00 et $1c00 dans page 0
0A18:6C 0E 13    JMP ($130E) =>6646		; Efface la page graphique 1 ou 2 suivant A sauvegardé dans $E6 (poids fort de la mémoire graphique)
0A1B:6C 10 13    JMP ($1310) =>65F8
0A1E:6C 12 13    JMP ($1312) =>65EA
0A21:6C 14 13    JMP ($1314) =>67DA
0A24:6C 16 13    JMP ($1316) =>6766		; On teste toutes les touches + Ecran des options si on est par en cours de partie
0A27:6C 18 13    JMP ($1318) =>6606
0A2A:6C 1A 13    JMP ($131A) =>661F
0A2D:6C 1C 13    JMP ($131C) =>6664
0A30:6C 1E 13    JMP ($131E) =>672E		; On remplit les lignes de X à Y-1, lignes paires avec $00$01 et lignes impaires avec $02$03
0A33:6C 20 13    JMP ($1320) =>66BE
0A36:6C 22 13    JMP ($1322) =>6B64     
0A39:6C 40 13    JMP ($1340) =>1400
0A3C:6C 42 13    JMP ($1342) =>1494
0A3F:6C 44 13    JMP ($1344) =>1464		;?
0A42:6C 30 13    JMP ($1330) =>72A5
0A45:6C 32 13    JMP ($1332) =>716B
0A48:6C 34 13    JMP ($1334) =>7287
0A4B:6C 36 13    JMP ($1336) =>706F
0A4E:6C 38 13    JMP ($1338) =>7152
0A51:6C 3A 13    JMP ($133A) =>72C3
0A54:6C 3C 13    JMP ($133C) =>722F
0A57:6C 3E 13    JMP ($133E) =>7277
0A5A:6C 52 13    JMP ($1352) =>15CD
0A5D:6C 54 13    JMP ($1354) =>17D3		; Responsable de la gestion de l'affichage de l'écran de fin de jeu.
0A60:6C 56 13    JMP ($1356) =>16C0     ; On recopie la page 1 ou 2 ($1D) dans l'autre page $1C
0A63:6C 58 13    JMP ($1358) =>1698		; 0A63 => JAMAIS APPELE ou dans du code level?
; Start of code
; On reconfigure via ($03F2) le Reset button vers $FAA6=PowerUp
0A66:A9 A6       LDA #$A6
0A68:8D F2 03    STA $03F2
0A6B:A9 FA       LDA #$FA
0A6D:8D F3 03    STA $03F3
0A70:20 6F FB    JSR $FB6F	;This is the beginning of a machine language subroutine which sets up the power-up location. 
0A73:20 91 0A    JSR $0A91	; Début du code d'initialisation du jeu avant la boucle principale
; boucle principale jeu infinie
0A76:20 24 0A    JSR $0A24	;<ROUTINE1> vérifie l'appui d'une touche $6766 et position des timers et gère l'écran des options
0A79:20 0D 0B    JSR $0B0D	;<ROUTINE2> gère probablement des actions spécifiques en fonction des touches appuyées.
0A7C:20 2B 0B    JSR $0B2B	;<ROUTINE3> vérifie que $31 est non nul sinon on reset le jeu? début de partie?
0A7F:20 A1 0C    JSR $0CA1	;Cette subroutine gère probablement le choix du joueur (joueur 1 ou 2).
0A82:20 50 0B    JSR $0B50	;Cette subroutine gère probablement la mise à jour du score du joueur.
0A85:20 B7 0B    JSR $0BB7	;Cette subroutine gère probablement l'état de la partie.
0A88:20 C3 0B    JSR $0BC3	;Cette subroutine gère probablement la gestion des inputs.
0A8B:20 83 0C    JSR $0C83	; On va tester la touche 'ESC' pour savoir si on a mis le jeu en pause (code en $654E)
0A8E:4C 76 0A    JMP $0A76
; fin de la boucle infinie
; Début du code d'initialisation du jeu avant la boucle principale
0A91:20 12 0A    JSR $0A12		; Sauvegarde page 0 dans $1c00 et $1f00 dans page 0
0A94:A0 00       LDY #$00
0A96:A9 00       LDA #$00
0A98:99 00 00    STA $0000,Y
0A9B:C8          INY
0A9C:D0 FA       BNE $0A98		; On efface toute la page 0
0A9E:A9 40       LDA #$40		
0AA0:85 1D       STA $1D		; Il marche avec $1C si l'un est le poids fort de la page 1 HGR alors l'autre est la page 2
0AA2:85 E6       STA $E6		; $E6 est utilisé comme switch pour chaque frame du jeu
0AA4:20 18 0A    JSR $0A18		; Efface la page graphique 1 ou 2 suivant A sauvegardé dans $E6 (poids fort de la mémoire graphique)
0AA7:A9 20       LDA #$20
0AA9:85 1C       STA $1C		; Il marche avec $1D si l'un est le poids fort de la page 1 HGR alors l'autre est la page 2
0AAB:85 E6       STA $E6
0AAD:20 18 0A    JSR $0A18		; Efface la page graphique 1 ou 2 suivant A sauvegardé dans $E6 (poids fort de la mémoire graphique)
0AB0:2C 10 C0    BIT $C010		;C010 49168 KBDSTRB      OECG WR   Keyboard Strobe
0AB3:2C 50 C0    BIT $C050		;C050 49232 TXTCLR       OECG WR   Display Graphics
0AB6:2C 54 C0    BIT $C054		;C054 49236 TXTPAGE1     OECG WR   Display Page 1
0AB9:2C 57 C0    BIT $C057		;C057 49239 HIRES        OECG WR   Display HiRes Graphics
0ABC:2C 52 C0    BIT $C052		;C052 49234 MIXCLR       OECG WR   Display Full Screen
0ABF:A9 01       LDA #$01		; Initialise certain registre du jeu:
0AC1:85 41       STA $41		; Nombre de joueur au départ égal à 1
0AC3:85 1F       STA $1F		; Initialise le level à 1
0AC5:85 31       STA $31		; Flag temporaire pour le prochain JSR
0AC7:20 2B 0B    JSR $0B2B		; Cette subroutine vérifie que $31 est à 1 pour init les registres/score/timers/difficulté
0ACA:A9 00       LDA #$00       
0ACC:85 33       STA $33		; Flag local qui gère les niveaux et les options au sein d'une partie.
0ACE:85 31       STA $31		; le registre prends maintenant le role du flag en partie ou en option
0AD0:A9 FF       LDA #$FF
0AD2:85 3F       STA $3F		; N'est JAMAIS utilisé?
0AD4:85 2A       STA $2A		; Flag options Joystick=1 ou keyboard=0 (ici on initialise à #FF)
0AD6:85 3C       STA $3C		
0AD8:A9 C1       LDA #$C1		; Valeur ASCII 'A'
0ADA:85 10       STA $10		; Direction du personnage en haut  
0ADC:A9 DA       LDA #$DA		; Valeur ASCII 'Z'
0ADE:85 11       STA $11		; Direction vers le bas
0AE0:A9 88       LDA #$88		; Valeur ASCII '←'
0AE2:85 12       STA $12		; Direction vers la gauche
0AE4:A9 95       LDA #$95		; Valeur ASCII '→'
0AE6:85 13       STA $13		; Direction vers la droite
0AE8:A9 A0       LDA #$A0		; Valeur ASCII <Space>
0AEA:85 14       STA $14		; Saut du personnage ou 
0AEC:85 15       STA $15		; ?
0AEE:60          RTS				; >>>Fin de l'init on rentre dans la boucle de jeu
0AEF:A0 99       LDY #$99		; Charge 99 dans Y et 0 dans l'accumulateur
0AF1:A9 00       LDA #$00
0AF3:99 00 00    STA $0000,Y	; Permet de mettre 0 dans les registre $99=>$BF soit
0AF6:C8          INY			;	le reset des scores des deux player ainsi que les timers
0AF7:C0 C0       CPY #$C0
0AF9:D0 F8       BNE $0AF3
0AFB:A9 05       LDA #$05		; Finalement on mais 5 dans les registres TIMER milliers
0AFD:85 A3       STA $A3		;	 et les flags timers des deux players
0AFF:85 A7       STA $A7
0B01:85 A6       STA $A6
0B03:85 AA       STA $AA
0B05:A9 01       LDA #$01
0B07:85 44       STA $44
0B09:20 09 0E    JSR $0E09
0B0C:60          RTS
;<ROUTINE2> de la boucle principale
0B0D:A5 3C       LDA $3C		; Si $3C égale à zéro on ne fait rien (vaut #$FF à l'init)
0B0F:F0 19       BEQ $0B2A
0B11:A5 1D       LDA $1D		; On charge la page à dessiner A=>#20 ou #40
0B13:20 18 0A    JSR $0A18		; Efface la page graphique 1 ou 2 suivant A sauvegardé dans $E6 (poids fort de la mémoire graphique)
0B16:A9 01       LDA #$01		
0B18:85 1F       STA $1F		; Flag du level en demandé = 1
0B1A:20 29 0E    JSR $0E29		; On vérifie quel level à charger en $7700 si nouveau level demandé ($1A=0)
0B1D:20 87 0C    JSR $0C87		; On position $1C=$E6 et $1D sur l'autre page
0B20:A9 00       LDA #$00		; 
0B22:85 3A       STA $3A		; Flag Mode Démo/Start?=1, Ecran Acceuil?/Option ou en partie = 0  
0B24:20 24 0E    JSR $0E24		; On efface $32 (flag=1 alors partie en cours, démo ou pas) et $36 (flag>1 on passe au level suivant)
0B27:20 5A 0A    JSR $0A5A		; $15CD
0B2A:60          RTS
; <Routine3> de la boucle principale
; Cette subroutine vérifie que $31 est non nul pour init les registres (= 1 en début de code)
0B2B:A5 31       LDA $31		; Charge le registre $31
0B2D:D0 01       BNE $0B30		; Si non nul (ce qui est le cas à l'init du jeu) on reset score et timers (code $0B30)
0B2F:60          RTS				; Sinon partie en cours?
0B30:20 EF 0A    JSR $0AEF		; Reset des Score et Timers des deux joueurs
0B33:A2 06       LDX #$06		; Charge 6 dans X (qui sera utilisé pour le nb de joueurs si la difficulté == 0)
0B35:A5 5C       LDA $5C		; Charge le registre $5C de l'écran des options LEVEL (difficulté)
0B37:85 40       STA $40		; On stocke la valeur du registre $5C dans $40 (difficulté à l'init du jeu)
0B39:F0 02       BEQ $0B3D		; Si $5C est nul on utilise la valeur de X=6 pour le nb de vie
0B3B:A2 03       LDX #$03		; Charge 3 dans le registre X
0B3D:86 42       STX $42		; Registre du nb de vie restante du player 1
0B3F:86 43       STX $43		; Registre du nb de vie restante du player 2
0B41:85 AF       STA $AF		; Registre de difficultés des levels Player 1 avec la valeur $5C
0B43:85 B0       STA $B0		; Registre de difficultés des levels Player 2 avec la valeur $5C
0B45:A9 01       LDA #$01
0B47:85 E1       STA $E1		; Registre de stockage du level player 1
0B49:85 E2       STA $E2		; Registre de stockage du level player 2
0B4B:85 33       STA $33		
0B4D:85 46       STA $46		; Registre du joueur en cours: Joueur 1 en cours
0B4F:60          RTS
;Cette subroutine gère probablement la mise à jour du score du joueur.
0B50:A5 32       LDA $32
0B52:D0 01       BNE $0B55		; On est en cours de partie $32=1
0B54:60          RTS
0B55:A5 34       LDA $34		; Flag d'appui sur CTRL-Q (>0)
0B57:F0 09       BEQ $0B62		; Pas de demande de reset du jeu (CTRL-Q) $34=0
0B59:85 31       STA $31		; 
0B5B:A9 00       LDA #$00
0B5D:85 34       STA $34		; On efface le flag de reset du jeu
0B5F:4C 71 0B    JMP $0B71		; 
0B62:20 A3 0B    JSR $0BA3		; Cette subroutine charge suivant le joueur ($46) le positionnement,avancement, difficulté et level
0B65:20 48 0D    JSR $0D48		; Cette subroutine gère probablement l'incrémentation du score et des bonus.
0B68:20 8F 0B    JSR $0B8F		; Cette subroutine sauvegarde dans les registres du joueur le positionnement,avancement, difficulté et level actuel.
0B6B:A5 35       LDA $35		; Registre flag fin de jeu si=1?
0B6D:F0 05       BEQ $0B74
0B6F:A9 00       LDA #$00
0B71:85 32       STA $32		; Flag=0 "La partie n'est plus en cours"
0B73:60          RTS
0B74:A5 36       LDA $36		; Registre flag si >0 passer au level suivant
0B76:F0 FB       BEQ $0B73		; NON on sort
0B78:A5 1F       LDA $1F		; $36>0 on change de level
0B7A:C9 04       CMP #$04		; Si on est au level 4
0B7C:B0 0B       BCS $0B89		; Supérieur ou égale à 4 on se branche plus bas
0B7E:A5 5A       LDA $5A		; Traitement Level inferieur à 4
0B80:85 80       STA $80
0B82:A5 5B       LDA $5B
0B84:85 81       STA $81
0B86:20 3F 0A    JSR $0A3F		; ?Semble interagir avec l'écran text ou boucle d'attente? => JMP $1464
0B89:85 33       STA $33		; On stocke #4
0B8B:20 CB 0D    JSR $0DCB		; Gère la fin d'un level (prise en compte level>4) 
0B8E:60          RTS
; Cette subroutine sauvegarde dans les registres du joueur le positionnement,avancement, difficulté et level actuel.
0B8F:A6 46       LDX $46		; Charge le joueur courant 1 ou 2
0B91:AD A0 13    LDA $13A0		; Registre de position du joueur actuel dans le level
0B94:A4 2E       LDY $2E		; Registre d'avancement du joueur actuel dans le level
0B96:95 AC       STA $AC,X		; Sauvegarde dans le registre du joueur(surement pour passer au joueur suivant)
0B98:94 AA       STY $AA,X
0B9A:A5 40       LDA $40		; Registre de la dificulté des levels
0B9C:A4 1F       LDY $1F		; Registre du level actuel
0B9E:95 AE       STA $AE,X		; Sauvegarde dans les registres du joueur actuel (surement pour passer au level suivant)
0BA0:94 E0       STY $E0,X
0BA2:60          RTS
; Cette subroutine charge suivant le joueur courant ($46) le positionnement,avancement, difficulté et level
0BA3:A6 46       LDX $46		
0BA5:B5 AC       LDA $AC,X
0BA7:B4 AA       LDY $AA,X
0BA9:8D A0 13    STA $13A0
0BAC:84 2E       STY $2E
0BAE:B5 AE       LDA $AE,X
0BB0:B4 E0       LDY $E0,X
0BB2:85 40       STA $40
0BB4:84 1F       STY $1F
0BB6:60          RTS
;
0BB7:A5 35       LDA $35
0BB9:F0 07       BEQ $0BC2
0BBB:A9 00       LDA #$00
0BBD:85 35       STA $35
0BBF:20 5D 0A    JSR $0A5D		;responsable de la gestion de l'affichage de l'écran de fin de jeu.
0BC2:60          RTS
;
0BC3:A5 3A       LDA $3A
0BC5:D0 01       BNE $0BC8
0BC7:60          RTS
0BC8:AD 00 C0    LDA $C000
0BCB:30 09       BMI $0BD6
0BCD:A5 2A       LDA $2A		; Flag Keyboard ou Joystick=0
0BCF:D0 1B       BNE $0BEC		; Branchement pour option Keyboard
0BD1:AD 61 C0    LDA $C061		;C061 49249	BUTN0	OECG	R7	Switch Input 0
0BD4:10 16       BPL $0BEC		
0BD6:A9 00       LDA #$00
0BD8:85 3A       STA $3A
0BDA:E6 31       INC $31
0BDC:A5 2A       LDA $2A
0BDE:F0 04       BEQ $0BE4
0BE0:A5 5F       LDA $5F
0BE2:85 2A       STA $2A
0BE4:20 21 0A    JSR $0A21
0BE7:85 3D       STA $3D
0BE9:85 3E       STA $3E
0BEB:60          RTS
0BEC:A5 3D       LDA $3D		; Suite traitement si pas de bouton appuyé ou option keyboard
0BEE:05 3E       ORA $3E
0BF0:D0 11       BNE $0C03
0BF2:A5 2A       LDA $2A
0BF4:85 5F       STA $5F
0BF6:A9 01       LDA #$01
0BF8:85 2A       STA $2A
0BFA:85 31       STA $31
0BFC:E6 3D       INC $3D
0BFE:D0 02       BNE $0C02
0C00:E6 3E       INC $3E
0C02:60          RTS
0C03:20 2B 0C    JSR $0C2B
0C06:A5 3E       LDA $3E
0C08:C9 02       CMP #$02
0C0A:90 10       BCC $0C1C
0C0C:A9 00       LDA #$00
0C0E:85 3D       STA $3D
0C10:85 3E       STA $3E
0C12:20 CB 0D    JSR $0DCB		; Gère la fin d'un level (prise en compte level>4) 
0C15:A9 01       LDA #$01
0C17:85 33       STA $33
0C19:4C FC 0B    JMP $0BFC
0C1C:A5 2C       LDA $2C
0C1E:F0 DC       BEQ $0BFC
0C20:A5 1F       LDA $1F
0C22:C9 04       CMP #$04
0C24:D0 E6       BNE $0C0C
0C26:E6 3C       INC $3C
0C28:4C 0C 0C    JMP $0C0C
0C2B:A5 1F       LDA $1F		; Charge le Registre du level
0C2D:C9 01       CMP #$01
0C2F:F0 0B       BEQ $0C3C
0C31:C9 02       CMP #$02
0C33:F0 1F       BEQ $0C54
0C35:C9 03       CMP #$03
0C37:F0 39       BEQ $0C72
0C39:4C 77 0C    JMP $0C77
0C3C:AD A0 13    LDA $13A0		; Traitement Level 1: Position du joueur
0C3F:C9 02       CMP #$02		; Sur l'arbre au début ?
0C41:F0 0C       BEQ $0C4F		; oui on met 1 dans $D6 et on sort
0C43:C9 04       CMP #$04		; non, en l'air entre deux lianes ?
0C45:D0 3B       BNE $0C82		; non => on sort
0C47:A5 3D       LDA $3D		; 
0C49:29 3F       AND #$3F
0C4B:C9 3F       CMP #$3F
0C4D:D0 33       BNE $0C82
0C4F:A9 01       LDA #$01
0C51:85 D6       STA $D6
0C53:60          RTS
0C54:A9 FF       LDA #$FF		; Traitement Level 2
0C56:85 D5       STA $D5
0C58:A5 17       LDA $17
0C5A:D0 02       BNE $0C5E
0C5C:85 D6       STA $D6
0C5E:A5 3D       LDA $3D
0C60:29 2F       AND #$2F
0C62:C9 2F       CMP #$2F
0C64:D0 02       BNE $0C68
0C66:85 D6       STA $D6
0C68:A9 73       LDA #$73
0C6A:38          SEC
0C6B:ED A0 13    SBC $13A0
0C6E:8D A3 13    STA $13A3
0C71:60          RTS
0C72:A9 FF       LDA #$FF		; Traitement Level 3
0C74:85 D5       STA $D5
0C76:60          RTS
0C77:A5 3D       LDA $3D		; Traitement Level 4
0C79:C9 80       CMP #$80
0C7B:90 05       BCC $0C82
0C7D:A9 FF       LDA #$FF
0C7F:8D A2 13    STA $13A2
0C82:60          RTS
0C83:20 0F 0A    JSR $0A0F		; On va tester la touche 'ESC' (code en $654E)
0C86:60          RTS
;
0C87:A2 20       LDX #$20		; poids fort de la page 1 HGR
0C89:A0 40       LDY #$40		; poids fort de la page 2 HGR
0C8B:A5 E6       LDA $E6		; page affiché actuelement
0C8D:C9 20       CMP #$20		; page 1?
0C8F:D0 08       BNE $0C99
0C91:86 1C       STX $1C		; on assure que $1C sera la page afficher
0C93:84 1D       STY $1D
0C95:2C 54 C0    BIT $C054		;C054 49236	TXTPAGE1	OECG	WR	Display Page 1
0C98:60          RTS
0C99:86 1D       STX $1D
0C9B:84 1C       STY $1C		; on assure que $1C sera la page afficher
0C9D:2C 55 C0    BIT $C055		;C055 49237	TXTPAGE2	OECG	WR	If 80STORE Off: Display Page 2
0CA0:60          RTS
;
0CA1:A5 33       LDA $33
0CA3:D0 01       BNE $0CA6
0CA5:60          RTS
0CA6:A9 00       LDA #$00
0CA8:85 32       STA $32
0CAA:85 BF       STA $BF
0CAC:A5 31       LDA $31
0CAE:D0 2D       BNE $0CDD
0CB0:A5 2C       LDA $2C
0CB2:D0 09       BNE $0CBD
0CB4:A5 46       LDA $46
0CB6:C9 01       CMP #$01
0CB8:F0 23       BEQ $0CDD		; cas joueur 1
0CBA:4C D3 0C    JMP $0CD3
0CBD:A5 41       LDA $41
0CBF:C9 01       CMP #$01
0CC1:F0 1A       BEQ $0CDD
0CC3:85 BF       STA $BF
0CC5:A5 46       LDA $46
0CC7:C9 02       CMP #$02
0CC9:D0 04       BNE $0CCF		; cas joueur 1
0CCB:A5 42       LDA $42		; nb de vie joueur 1
0CCD:D0 0E       BNE $0CDD		; cas du joueur 1 qui a encore des vies
0CCF:A5 43       LDA $43		; nb de vie joueur 2
0CD1:F0 0A       BEQ $0CDD		; cas le joueur 2 n'a plus de vie
0CD3:A9 02       LDA #$02		;
0CD5:85 46       STA $46		; sélection joueur 2
0CD7:20 A3 0B    JSR $0BA3		; Cette subroutine charge suivant le joueur ($46) le positionnement,avancement, difficulté et level
0CDA:4C ED 0C    JMP $0CED
0CDD:A9 01       LDA #$01		; on sélectionne le joueur 1 si joueur 2 n'a plus de vie
0CDF:85 46       STA $46
0CE1:20 A3 0B    JSR $0BA3		; Cette subroutine charge suivant le joueur ($46) le positionnement,avancement, difficulté et level
0CE4:A5 42       LDA $42		; nb vie joueur 1
0CE6:D0 05       BNE $0CED		; non nulle
0CE8:85 33       STA $33		; 
0CEA:E6 35       INC $35		;$35==1 => écran fin de jeu
0CEC:60          RTS
0CED:A2 0A       LDX #$0A	
0CEF:A9 00       LDA #$00
0CF1:95 60       STA $60,X		; On efface les registres $60->$69
0CF3:CA          DEX
0CF4:D0 FB       BNE $0CF1
0CF6:85 31       STA $31
0CF8:85 2C       STA $2C
0CFA:20 87 0C    JSR $0C87		; On position $1C=$E6 et $1D sur l'autre page
0CFD:20 29 0E    JSR $0E29
0D00:A5 1F       LDA $1F		; Registre Level
0D02:C9 01       CMP #$01
0D04:D0 11       BNE $0D17		; NON>↓>
0D06:20 00 77    JSR $7700		; Lancement Level 1
0D09:AD A0 13    LDA $13A0		; Attitude du joeur en cours
0D0C:C9 01       CMP #$01
0D0E:D0 07       BNE $0D17
0D10:85 2F       STA $2F
0D12:A9 00       LDA #$00
0D14:8D A0 13    STA $13A0		; Remise à zéro de l'Attitude du Joueur 
0D17:20 33 0D    JSR $0D33		;>>Pas level 1>↓>
0D1A:20 00 77    JSR $7700
0D1D:A9 01       LDA #$01
0D1F:85 32       STA $32
0D21:A6 46       LDX $46
0D23:95 B0       STA $B0,X
0D25:20 4E 0A    JSR $0A4E
0D28:A9 00       LDA #$00
0D2A:85 33       STA $33
0D2C:20 60 0A    JSR $0A60      ; On recopie la page 1 ou 2 ($1D) dans l'autre page $1C
0D2F:20 8F 0B    JSR $0B8F
0D32:60          RTS
0D33:A5 1D       LDA $1D		;>>Charge la page à dessiner
0D35:20 18 0A    JSR $0A18		; Efface la page graphique 1 ou 2 suivant A qui sera sauvegardé dans $E6 (poids fort de la mémoire graphique)
0D38:20 B7 12    JSR $12B7		; On affiche un bout du décors (lignes vertes $672E) du level 1
0D3B:20 0D 0F    JSR $0F0D		
0D3E:20 48 0A    JSR $0A48
0D41:20 4E 0A    JSR $0A4E
0D44:20 51 0A    JSR $0A51
0D47:60          RTS
;Cette subroutine gère probablement l'incrémentation du score et des bonus.
0D48:20 B4 0D    JSR $0DB4
0D4B:E6 27       INC $27
0D4D:A5 27       LDA $27
0D4F:6A          ROR
0D50:90 3C       BCC $0D8E
0D52:A9 20       LDA #$20		
0D54:85 E6       STA $E6
0D56:20 0C 0A    JSR $0A0C		; =>$64EC Gestion des registres $D4, $D5, $D6 et $D7 pour le mode JOYSTICK
0D59:20 9F 0D    JSR $0D9F		; Code Level $7700
0D5C:2C 54 C0    BIT $C054		;C054 49236	TXTPAGE1	OECG	WR	Display Page 1
0D5F:20 45 0A    JSR $0A45
0D62:20 39 0A    JSR $0A39
0D65:A5 2D       LDA $2D
0D67:05 33       ORA $33
0D69:05 35       ORA $35
0D6B:05 36       ORA $36
0D6D:D0 1E       BNE $0D8D
0D6F:A2 00       LDX #$00
0D71:A5 46       LDA $46
0D73:C9 01       CMP #$01
0D75:F0 02       BEQ $0D79
0D77:A2 04       LDX #$04
0D79:D6 A6       DEC $A6,X
0D7B:B5 A6       LDA $A6,X
0D7D:15 A5       ORA $A5,X
0D7F:15 A4       ORA $A4,X
0D81:15 A3       ORA $A3,X
0D83:D0 08       BNE $0D8D
0D85:A6 46       LDX $46
0D87:95 41       STA $41,X
0D89:E6 33       INC $33
0D8B:E6 2C       INC $2C
0D8D:60          RTS
0D8E:A9 40       LDA #$40		; Positionne @HI Page 2
0D90:85 E6       STA $E6		; Affecte le registre de la page courante
0D92:20 9F 0D    JSR $0D9F		; Code Level $7700
0D95:2C 55 C0    BIT $C055		;C055 49237	TXTPAGE2	OECG	WR	If 80STORE Off: Display Page 2
0D98:20 45 0A    JSR $0A45
0D9B:20 39 0A    JSR $0A39
0D9E:60          RTS
0D9F:20 00 77    JSR $7700		; Code du Level en cours
0DA2:A5 36       LDA $36		; Flag pour passer niveau suivant
0DA4:F0 04       BEQ $0DAA		; NON>↓>
0DA6:A9 05       LDA #$05
0DA8:85 91       STA $91
0DAA:20 FD 0E    JSR $0EFD		;>>
0DAD:20 4B 0A    JSR $0A4B
0DB0:20 51 0A    JSR $0A51
0DB3:60          RTS
;
0DB4:A5 D8       LDA $D8
0DB6:C9 F5       CMP #$F5
0DB8:90 04       BCC $0DBE
0DBA:A9 00       LDA #$00
0DBC:85 D8       STA $D8
0DBE:A5 D9       LDA $D9
0DC0:C9 BF       CMP #$BF
0DC2:90 04       BCC $0DC8
0DC4:A9 00       LDA #$00
0DC6:85 D9       STA $D9
0DC8:E6 D9       INC $D9
0DCA:60          RTS
; Gére probablement le max de vie, le passage de level, gestion difficulté de level si level >4 et remise à 5000 du TIMER
0DCB:A6 46       LDX $46		; Charge le joueur actuel dans la partie 1 ou 2
0DCD:B5 41       LDA $41,X		; Charge le registre $42 ou $43: nb de vie restant du joueur 1 ou 2
0DCF:C9 09       CMP #$09		; Compare avec 9 vies (max de vies possibles)
0DD1:90 04       BCC $0DD7		; si inférieur aller en $DD7
0DD3:A9 09       LDA #$09		; sinon mettre 9 dans $42 ou $43
0DD5:95 41       STA $41,X		
0DD7:F6 E0       INC $E0,X		; Incrémenter le level du joueur 1 ou 2
0DD9:B5 E0       LDA $E0,X		; Charge le level du joueur 1 ou 2
0DDB:C9 05       CMP #$05		; Comparer à 5
0DDD:90 26       BCC $0E05		; Si inférieur aller en $0E05 (JSR $0E09)
0DDF:A9 01       LDA #$01		; Si supérieur ou egale mettre 1 (fin level 4?)
0DE1:95 E0       STA $E0,X		; Stocke le level joueur 1 et 2
0DE3:F6 AE       INC $AE,X		; Incrémente la difficulté des levels joueur 1 et joueur 2
0DE5:B5 AE       LDA $AE,X		; Charge la difficulté des levels
0DE7:C9 03       CMP #$03		; Comparer à 3 (max difficulté est 2)
0DE9:90 04       BCC $0DEF		; Si inférieur continuer
0DEB:A9 02       LDA #$02		; si égale à la difficulté >=3 mettre la difficulté à 2
0DED:95 AE       STA $AE,X		; Stocker la difficulté joueur 1 ou 2
0DEF:A2 00       LDX #$00
0DF1:A5 46       LDA $46		; Charge le joueur actuel dans la partie 1 ou 2
0DF3:C9 01       CMP #$01		; si joueur 1 garder LDX à zéro
0DF5:F0 02       BEQ $0DF9		
0DF7:A2 04       LDX #$04		; permet de modifier le TIMER du joueur 2
0DF9:A9 05       LDA #$05	
0DFB:95 A3       STA $A3,X		; on réinitialise le TIMER millier: 5 dans $A3 pour joueur 1 ou 5 et dans $A7 si joueur 2
0DFD:95 A6       STA $A6,X		; mettre 5 dans $A6 (flag pour decrementer le TIMER) 
0DFF:A9 00       LDA #$00
0E01:95 A4       STA $A4,X		; réinitialisation du TIMER centaine
0E03:95 A5       STA $A5,X		; réinitialisation du TIMER dizaine
0E05:20 09 0E    JSR $0E09
0E08:60          RTS
0E09:A9 00       LDA #$00
0E0B:85 1E       STA $1E
0E0D:85 D6       STA $D6		; Flag saut demandé si <>0 (bouton 0 ou space)
0E0F:85 D7       STA $D7		; Bouton 1 Joystick ou timer temps position couché level 3
0E11:A6 46       LDX $46
0E13:95 AC       STA $AC,X		; Reset la position/posture du joueur 1 ou suivant le registre $46 dans le level
0E15:95 AA       STA $AA,X		; Reset l'avancement du joueur dans le level
0E17:8D A8 13    STA $13A8
0E1A:85 2D       STA $2D
0E1C:85 45       STA $45
0E1E:85 2F       STA $2F
0E20:85 17       STA $17
0E22:85 18       STA $18
0E24:85 36       STA $36		; On efface le flag de passage de level
0E26:85 32       STA $32		; Flag Partie en cours (démo ou pas) mis à zéro
0E28:60          RTS
;
0E29:A5 1F       LDA $1F		; On charge le level prévu (1 à l'init <ROUTINE2>)
0E2B:C9 04       CMP #$04		; Level 4?
0E2D:D0 03       BNE $0E32		; NON>↓>
0E2F:4C A8 0E    JMP $0EA8		; Traitement Level 4
0E32:C9 03       CMP #$03		; >>Level 3?
0E34:F0 53       BEQ $0E89		; OUI>↓>
0E36:C9 02       CMP #$02		; Level 2?
0E38:F0 23       BEQ $0E5D		; OUI>↓>
0E3A:A5 1A       LDA $1A		; Level prévu est $1F=1 on regarde le level en cours $1A
0E3C:C9 01       CMP #$01		; Level 1 déjà en cours ? (visiblement passe par ici dès le début pour charger le code level 1?)
0E3E:F0 0D       BEQ $0E4D		; OUI>↓>
0E40:A9 01       LDA #$01		; Le level en cours $1A n'été pas encore chargé pourtant $1F=1
0E42:85 1A       STA $1A		; On met le flag Level en cours à $1A=1 correspond au début de level 1
0E44:A9 03       LDA #$03		
0E46:A0 04       LDY #$04
0E48:A2 77       LDX #$77		
0E4A:20 00 1D    JSR $1D00		; Charge du code Level 1 dans la mémoire Buffer=$7700, Track 3 (=>$86FF=>) et 4 (=>$96FF)
0E4D:A9 00       LDA #$00		; Traitement level 1
0E4F:85 39       STA $39		; Flag décors en traveling (=1)
0E51:A9 00       LDA #$00		
0E53:48          PHA
0E54:A9 80       LDA #$80
0E56:A0 00       LDY #$00
0E58:A2 8C       LDX #$8C
0E5A:4C C4 0E    JMP $0EC4		; >>
0E5D:A5 1A       LDA $1A		; Charge le Level en demandé
0E5F:C9 02       CMP #$02		; Level 2? (déjà comparé précdemment?)
0E61:F0 16       BEQ $0E79		; OUI>>
0E63:A9 02       LDA #$02		; On passe le registre $1A du level en cours à 2 (on viens de finir le level 1)
0E65:85 1A       STA $1A		; On n'était pas en Level 2 il faut chargé du nouveau code
0E67:A9 05       LDA #$05
0E69:A0 05       LDY #$05
0E6B:A2 77       LDX #$77
0E6D:20 00 1D    JSR $1D00		; Charge du code dans la mémoire Buffer=$7700, Track 5 => code Level 2
0E70:A9 06       LDA #$06
0E72:A0 07       LDY #$07
0E74:A2 7D       LDX #$7D
0E76:20 00 1D    JSR $1D00		; Charge du code dans la mémoire Buffer=$7D00, Track 6 et 7 => 
0E79:A9 FF       LDA #$FF		; >>Traitement Level 2 déjà en cours ($1A) pas besoin de chargé du nouveau code
0E7B:85 39       STA $39		; Flag Traveling ?
0E7D:A9 00       LDA #$00
0E7F:48          PHA
0E80:A9 7D       LDA #$7D
0E82:A0 1E       LDY #$1E
0E84:A2 7D       LDX #$7D
0E86:4C C4 0E    JMP $0EC4		; >>
0E89:A5 1A       LDA $1A		; >>On charge le level demandé
0E8B:C9 03       CMP #$03		; Level 3? déjà en cours
0E8D:F0 0D       BEQ $0E9C		; OUI>>
0E8F:A9 03       LDA #$03		; On force à 3
0E91:85 1A       STA $1A		; Le level en cours
0E93:A9 08       LDA #$08
0E95:A0 09       LDY #$09
0E97:A2 77       LDX #$77
0E99:20 00 1D    JSR $1D00		; Charge du code dans la mémoire Buffer=$7700, Track 8 et 9
0E9C:A9 FF       LDA #$FF
0E9E:85 39       STA $39
0EA0:A9 00       LDA #$00
0EA2:48          PHA
0EA3:A9 8C       LDA #$8C
0EA5:4C C8 0E    JMP $0EC8		; >>
0EA8:A5 1A       LDA $1A		; Charge le numéro du niveau actuel
0EAA:C9 04       CMP #$04		; Compare avec 4 (niveau 4)
0EAC:F0 0D       BEQ $0EBB		; OUI
0EAE:A9 04       LDA #$04		; On applique le niveau 4 demandé ($1F)
0EB0:85 1A       STA $1A		
0EB2:A9 0A       LDA #$0A
0EB4:A0 0B       LDY #$0B
0EB6:A2 77       LDX #$77
0EB8:20 00 1D    JSR $1D00		; Charge du code dans la mémoire Buffer=$7700, Track A et B
0EBB:A9 00       LDA #$00		; Traitement Level 4
0EBD:85 39       STA $39		; Flag Traveling (=1) ou pas(=0)
0EBF:A9 00       LDA #$00
0EC1:48          PHA
0EC2:A9 8C       LDA #$8C
0EC4:86 8B       STX $8B		; <<JMP from $0E86
0EC6:84 8A       STY $8A
0EC8:85 89       STA $89		; <<JMP from $0E45
0ECA:68          PLA
0ECB:85 88       STA $88
0ECD:A0 00       LDY #$00
0ECF:84 38       STY $38
0ED1:B1 88       LDA ($88),Y
0ED3:85 C7       STA $C7
0ED5:B1 8A       LDA ($8A),Y
0ED7:85 C9       STA $C9
0ED9:C8          INY
0EDA:B1 88       LDA ($88),Y
0EDC:85 C8       STA $C8
0EDE:B1 8A       LDA ($8A),Y
0EE0:85 CA       STA $CA
0EE2:A5 88       LDA $88
0EE4:18          CLC
0EE5:69 02       ADC #$02
0EE7:85 88       STA $88
0EE9:A5 89       LDA $89
0EEB:69 00       ADC #$00		; Permet de propager une retenue éventuelle de la précédent addition #$02
0EED:85 89       STA $89
0EEF:A5 8A       LDA $8A
0EF1:18          CLC
0EF2:69 02       ADC #$02
0EF4:85 8A       STA $8A
0EF6:A5 8B       LDA $8B
0EF8:69 00       ADC #$00
0EFA:85 8B       STA $8B
0EFC:60          RTS
;
0EFD:A5 39       LDA $39		;Flag pour travelling décors
0EFF:F0 0C       BEQ $0F0D		;NON>↓>
0F01:E6 38       INC $38		
0F03:A5 38       LDA $38		; Incrément de la position du décors en travelling
0F05:C9 1C       CMP #$1C		; #28
0F07:90 04       BCC $0F0D		; Inferieur Strictement à #28? OUI>↓>
0F09:A9 00       LDA #$00		
0F0B:85 38       STA $38		; Mettre à zéro le position du décors si position supérieur ou égale à #28
; Gestion du Travelling décors?
0F0D:A5 1F       LDA $1F
0F0F:C9 01       CMP #$01		; Level 1? 
0F11:F0 0E       BEQ $0F21		; OUI>↓>Traitement Level 1
0F13:C9 02       CMP #$02		; Level 2?
0F15:F0 38       BEQ $0F4F		; OUI>↓>Traitement Level 1
0F17:C9 03       CMP #$03		; Vérification Level 1 demandé
0F19:D0 03       BNE $0F1E		; NON>↓>Traitement Level 1
0F1B:4C 50 10    JMP $1050
0F1E:4C 64 10    JMP $1064		; Level 4 pas de travelling?>>
0F21:A5 39       LDA $39		;>> Flag travelling décors
0F23:F0 0E       BEQ $0F33		;OUI>↓>
0F25:A5 38       LDA $38
0F27:18          CLC
0F28:69 04       ADC #$04
0F2A:C9 1C       CMP #$1C
0F2C:90 03       BCC $0F31
0F2E:38          SEC
0F2F:E9 1C       SBC #$1C
0F31:85 38       STA $38
0F33:A5 38       LDA $38		;>> Position du décors
0F35:29 FE       AND #$FE		; On garde le bit0
0F37:48          PHA
0F38:A8          TAY				; bit0 de la position du décors dans Y
0F39:20 73 10    JSR $1073
0F3C:A0 B7       LDY #$B7
0F3E:20 36 0A    JSR $0A36
0F41:68          PLA
0F42:A8          TAY
0F43:20 81 10    JSR $1081
0F46:A0 28       LDY #$28
0F48:20 36 0A    JSR $0A36
0F4B:20 8F 10    JSR $108F
0F4E:60          RTS
0F4F:A5 C0       LDA $C0
0F51:A4 45       LDY $45
0F53:D0 02       BNE $0F57
0F55:A5 38       LDA $38
0F57:29 FE       AND #$FE
0F59:A8          TAY
0F5A:20 73 10    JSR $1073
0F5D:A0 B7       LDY #$B7
0F5F:20 36 0A    JSR $0A36
0F62:A5 38       LDA $38
0F64:C9 0E       CMP #$0E
0F66:90 03       BCC $0F6B
0F68:38          SEC
0F69:E9 0E       SBC #$0E
0F6B:0A          ASL
0F6C:A8          TAY
0F6D:20 81 10    JSR $1081
0F70:A0 64       LDY #$64
0F72:20 36 0A    JSR $0A36
0F75:20 FF 11    JSR $11FF
0F78:AD A3 13    LDA $13A3
0F7B:C9 71       CMP #$71
0F7D:B0 04       BCS $0F83
0F7F:A9 00       LDA #$00
0F81:85 4F       STA $4F
0F83:A5 27       LDA $27
0F85:6A          ROR
0F86:90 0F       BCC $0F97
0F88:E6 4F       INC $4F
0F8A:A9 FA       LDA #$FA
0F8C:C5 4F       CMP $4F
0F8E:B0 07       BCS $0F97
0F90:85 4F       STA $4F
0F92:A9 02       LDA #$02
0F94:8D A0 13    STA $13A0
0F97:A5 4F       LDA $4F
0F99:A2 1C       LDX #$1C
0F9B:A0 1C       LDY #$1C
0F9D:C9 FA       CMP #$FA
0F9F:B0 58       BCS $0FF9
0FA1:A2 1D       LDX #$1D
0FA3:C9 EB       CMP #$EB
0FA5:B0 52       BCS $0FF9
0FA7:A0 1D       LDY #$1D
0FA9:C9 D7       CMP #$D7
0FAB:B0 4C       BCS $0FF9
0FAD:A2 1E       LDX #$1E
0FAF:C9 C8       CMP #$C8
0FB1:B0 46       BCS $0FF9
0FB3:A0 1E       LDY #$1E
0FB5:C9 B4       CMP #$B4
0FB7:B0 40       BCS $0FF9
0FB9:A2 1F       LDX #$1F
0FBB:C9 A5       CMP #$A5
0FBD:B0 3A       BCS $0FF9
0FBF:A0 1F       LDY #$1F
0FC1:C9 91       CMP #$91
0FC3:B0 34       BCS $0FF9
0FC5:A2 20       LDX #$20
0FC7:C9 82       CMP #$82
0FC9:B0 2E       BCS $0FF9
0FCB:A0 20       LDY #$20
0FCD:C9 6E       CMP #$6E
0FCF:B0 28       BCS $0FF9
0FD1:A2 21       LDX #$21
0FD3:C9 5F       CMP #$5F
0FD5:B0 22       BCS $0FF9
0FD7:A0 21       LDY #$21
0FD9:C9 4B       CMP #$4B
0FDB:B0 1C       BCS $0FF9
0FDD:A2 22       LDX #$22
0FDF:C9 3C       CMP #$3C
0FE1:B0 16       BCS $0FF9
0FE3:A0 22       LDY #$22
0FE5:C9 28       CMP #$28
0FE7:B0 10       BCS $0FF9
0FE9:A2 23       LDX #$23
0FEB:C9 19       CMP #$19
0FED:B0 0A       BCS $0FF9
0FEF:A0 23       LDY #$23
0FF1:C9 05       CMP #$05
0FF3:B0 04       BCS $0FF9
0FF5:A2 24       LDX #$24
0FF7:A0 24       LDY #$24
0FF9:86 C5       STX $C5
0FFB:84 C4       STY $C4
0FFD:A9 08       LDA #$08
0FFF:85 4A       STA $4A
1001:A9 08       LDA #$08
1003:85 4B       STA $4B
1005:A9 43       LDA #$43
1007:85 DC       STA $DC
1009:A4 DC       LDY $DC
100B:20 03 0A    JSR $0A03
100E:A0 1C       LDY #$1C
1010:A9 AA       LDA #$AA
1012:C4 C4       CPY $C4
1014:90 08       BCC $101E
1016:A9 8A       LDA #$8A
1018:C4 C5       CPY $C5
101A:90 02       BCC $101E
101C:A9 80       LDA #$80
101E:91 4C       STA ($4C),Y
1020:C8          INY
1021:C6 4B       DEC $4B
1023:F0 15       BEQ $103A
1025:A9 D5       LDA #$D5
1027:C4 C4       CPY $C4
1029:90 08       BCC $1033
102B:A9 85       LDA #$85
102D:C4 C5       CPY $C5
102F:90 02       BCC $1033
1031:A9 80       LDA #$80
1033:91 4C       STA ($4C),Y
1035:C8          INY
1036:C6 4B       DEC $4B
1038:D0 D6       BNE $1010
103A:C6 DC       DEC $DC
103C:A9 08       LDA #$08
103E:85 4B       STA $4B
1040:C6 4A       DEC $4A
1042:D0 C5       BNE $1009
1044:A5 4F       LDA $4F
1046:C9 B4       CMP #$B4
1048:90 02       BCC $104C
104A:E6 67       INC $67
104C:20 42 0A    JSR $0A42
104F:60          RTS
; Traitement Travelling Level 3?
1050:A5 39       LDA $39		; Flag travelling décors
1052:F0 02       BEQ $1056		; NON>↓>
1054:E6 38       INC $38		; On incrémente la position du travaling
1056:A5 38       LDA $38		;>>
1058:29 FE       AND #$FE		; On efface uniquement le bit0 de la position travelling
105A:A8          TAY
105B:20 73 10    JSR $1073
105E:A0 28       LDY #$28
1060:20 36 0A    JSR $0A36
1063:60          RTS
1064:A5 32       LDA $32
1066:D0 0A       BNE $1072
1068:A0 00       LDY #$00
106A:20 73 10    JSR $1073
106D:A0 28       LDY #$28
106F:20 36 0A    JSR $0A36
1072:60          RTS
;
1073:B1 88       LDA ($88),Y		; bit0 de la position du décors ($38) dans Y
1075:85 E8       STA $E8
1077:C8          INY
1078:B1 88       LDA ($88),Y
107A:85 E9       STA $E9
107C:A5 C7       LDA $C7
107E:A6 C8       LDX $C8
1080:60          RTS
1081:B1 8A       LDA ($8A),Y
1083:85 E8       STA $E8
1085:C8          INY
1086:B1 8A       LDA ($8A),Y
1088:85 E9       STA $E9
108A:A5 C9       LDA $C9
108C:A6 CA       LDX $CA
108E:60          RTS
108F:A5 2F       LDA $2F
1091:D0 01       BNE $1094
1093:60          RTS
1094:C9 01       CMP #$01
1096:D0 29       BNE $10C1
1098:20 ED 11    JSR $11ED
109B:A2 22       LDX #$22
109D:20 90 11    JSR $1190
10A0:A9 B4       LDA #$B4
10A2:A0 01       LDY #$01
10A4:20 AF 11    JSR $11AF
10A7:A9 29       LDA #$29
10A9:A0 01       LDY #$01
10AB:20 AF 11    JSR $11AF
10AE:A2 1E       LDX #$1E
10B0:20 C8 11    JSR $11C8
10B3:A2 1A       LDX #$1A
10B5:20 CF 11    JSR $11CF
10B8:A5 33       LDA $33
10BA:D0 04       BNE $10C0
10BC:A9 02       LDA #$02
10BE:85 2F       STA $2F
10C0:60          RTS
10C1:C9 02       CMP #$02
10C3:D0 1E       BNE $10E3
10C5:20 ED 11    JSR $11ED
10C8:A2 22       LDX #$22
10CA:86 E5       STX $E5
10CC:A9 B4       LDA #$B4
10CE:A0 01       LDY #$01
10D0:20 AF 11    JSR $11AF
10D3:A9 29       LDA #$29
10D5:A0 01       LDY #$01
10D7:20 AF 11    JSR $11AF
10DA:A5 39       LDA $39
10DC:F0 04       BEQ $10E2
10DE:A9 03       LDA #$03
10E0:85 2F       STA $2F
10E2:60          RTS
10E3:C9 09       CMP #$09
10E5:B0 4A       BCS $1131
10E7:C9 05       CMP #$05
10E9:B0 15       BCS $1100
10EB:20 F6 11    JSR $11F6
10EE:A2 23       LDX #$23
10F0:20 90 11    JSR $1190
10F3:A2 1F       LDX #$1F
10F5:20 C8 11    JSR $11C8
10F8:A2 1B       LDX #$1B
10FA:20 CF 11    JSR $11CF
10FD:E6 2F       INC $2F
10FF:60          RTS
1100:C9 07       CMP #$07
1102:B0 15       BCS $1119
1104:20 ED 11    JSR $11ED
1107:A2 24       LDX #$24
1109:20 90 11    JSR $1190
110C:A2 20       LDX #$20
110E:20 C8 11    JSR $11C8
1111:A2 1C       LDX #$1C
1113:20 CF 11    JSR $11CF
1116:E6 2F       INC $2F
1118:60          RTS
1119:20 ED 11    JSR $11ED
111C:A2 26       LDX #$26
111E:20 90 11    JSR $1190
1121:20 F6 11    JSR $11F6
1124:A2 21       LDX #$21
1126:20 C8 11    JSR $11C8
1129:A2 1D       LDX #$1D
112B:20 CF 11    JSR $11CF
112E:E6 2F       INC $2F
1130:60          RTS
1131:C9 0B       CMP #$0B
1133:B0 10       BCS $1145
1135:20 ED 11    JSR $11ED
1138:A2 22       LDX #$22
113A:20 C8 11    JSR $11C8
113D:A2 1E       LDX #$1E
113F:20 CF 11    JSR $11CF
1142:E6 2F       INC $2F
1144:60          RTS
1145:C9 0D       CMP #$0D
1147:B0 10       BCS $1159
1149:20 ED 11    JSR $11ED
114C:A2 24       LDX #$24
114E:20 C8 11    JSR $11C8
1151:A2 20       LDX #$20
1153:20 CF 11    JSR $11CF
1156:E6 2F       INC $2F
1158:60          RTS
1159:C9 0F       CMP #$0F
115B:B0 10       BCS $116D
115D:20 ED 11    JSR $11ED
1160:A2 26       LDX #$26
1162:20 C8 11    JSR $11C8
1165:A2 22       LDX #$22
1167:20 CF 11    JSR $11CF
116A:E6 2F       INC $2F
116C:60          RTS
116D:C9 11       CMP #$11
116F:B0 0B       BCS $117C
1171:20 ED 11    JSR $11ED
1174:A2 24       LDX #$24
1176:20 CF 11    JSR $11CF
1179:E6 2F       INC $2F
117B:60          RTS
117C:C9 13       CMP #$13
117E:B0 0B       BCS $118B
1180:20 ED 11    JSR $11ED
1183:A2 26       LDX #$26
1185:20 CF 11    JSR $11CF
1188:E6 2F       INC $2F
118A:60          RTS
118B:A9 00       LDA #$00
118D:85 2F       STA $2F
118F:60          RTS
1190:86 E5       STX $E5
1192:A9 A7       LDA #$A7
1194:85 DC       STA $DC
1196:A0 08       LDY #$08
1198:8C AC 12    STY $12AC
119B:A5 84       LDA $84
119D:85 80       STA $80
119F:A5 85       LDA $85
11A1:85 81       STA $81
11A3:20 27 0A    JSR $0A27
11A6:20 2D 0A    JSR $0A2D
11A9:CE AC 12    DEC $12AC
11AC:D0 ED       BNE $119B
11AE:60          RTS
11AF:85 DC       STA $DC
11B1:8C AC 12    STY $12AC
11B4:A5 84       LDA $84
11B6:85 80       STA $80
11B8:A5 85       LDA $85
11BA:85 81       STA $81
11BC:20 27 0A    JSR $0A27
11BF:20 33 0A    JSR $0A33
11C2:CE AC 12    DEC $12AC
11C5:D0 ED       BNE $11B4
11C7:60          RTS
11C8:A9 6A       LDA #$6A
11CA:A0 06       LDY #$06
11CC:4C D3 11    JMP $11D3
11CF:A9 68       LDA #$68
11D1:A0 04       LDY #$04
11D3:86 E5       STX $E5
11D5:85 DC       STA $DC
11D7:8C E6 11    STY $11E6		; Violation du code pour stocker Y
11DA:A5 84       LDA $84
11DC:85 80       STA $80
11DE:A5 85       LDA $85
11E0:85 81       STA $81
11E2:20 27 0A    JSR $0A27
11E5:A9 04       LDA #$04		; valeur changeante cf ci dessus
11E7:85 4A       STA $4A
11E9:20 2D 0A    JSR $0A2D
11EC:60          RTS
11ED:A9 92       LDA #$92
11EF:A0 80       LDY #$80
11F1:85 84       STA $84
11F3:84 85       STY $85
11F5:60          RTS
11F6:A9 F4       LDA #$F4
11F8:A0 80       LDY #$80
11FA:85 84       STA $84
11FC:84 85       STY $85
11FE:60          RTS
11FF:A5 44       LDA $44
1201:D0 08       BNE $120B
1203:A5 45       LDA $45
1205:F0 03       BEQ $120A
1207:4C 60 12    JMP $1260
120A:60          RTS
120B:A9 B3       LDA #$B3
120D:85 DC       STA $DC
120F:A9 0E       LDA #$0E
1211:8D AC 12    STA $12AC
1214:20 1F 12    JSR $121F
1217:CE AC 12    DEC $12AC
121A:D0 F8       BNE $1214
121C:E6 44       INC $44
121E:60          RTS
121F:A5 44       LDA $44
1221:C9 04       CMP #$04
1223:B0 08       BCS $122D
1225:20 AD 12    JSR $12AD
1228:A2 24       LDX #$24
122A:4C 53 12    JMP $1253
122D:C9 08       CMP #$08
122F:B0 08       BCS $1239
1231:20 B2 12    JSR $12B2
1234:A2 25       LDX #$25
1236:4C 53 12    JMP $1253
1239:C9 0C       CMP #$0C
123B:B0 08       BCS $1245
123D:20 AD 12    JSR $12AD
1240:A2 26       LDX #$26
1242:4C 53 12    JMP $1253
1245:C9 10       CMP #$10
1247:90 05       BCC $124E
1249:A9 FF       LDA #$FF
124B:85 44       STA $44
124D:60          RTS
124E:20 B2 12    JSR $12B2
1251:A2 27       LDX #$27
1253:86 E5       STX $E5
1255:85 80       STA $80
1257:84 81       STY $81
1259:20 27 0A    JSR $0A27
125C:20 2D 0A    JSR $0A2D
125F:60          RTS
1260:A9 B5       LDA #$B5
1262:85 DC       STA $DC
1264:A9 0F       LDA #$0F
1266:8D AC 12    STA $12AC
1269:A9 00       LDA #$00
126B:85 E5       STA $E5
126D:20 7E 12    JSR $127E
1270:CE AC 12    DEC $12AC
1273:D0 F8       BNE $126D
1275:A5 45       LDA $45
1277:C9 1E       CMP #$1E
1279:B0 02       BCS $127D
127B:E6 45       INC $45
127D:60          RTS
127E:A5 45       LDA $45
1280:C9 07       CMP #$07
1282:90 0B       BCC $128F
1284:C9 0E       CMP #$0E
1286:90 0E       BCC $1296
1288:20 A7 12    JSR $12A7
128B:20 55 12    JSR $1255
128E:60          RTS
128F:20 9D 12    JSR $129D
1292:20 55 12    JSR $1255
1295:60          RTS
1296:20 A2 12    JSR $12A2
1299:20 55 12    JSR $1255
129C:60          RTS
129D:A9 04       LDA #$04
129F:A0 7E       LDY #$7E
12A1:60          RTS
12A2:A9 0C       LDA #$0C
12A4:A0 7E       LDY #$7E
12A6:60          RTS
12A7:A9 1A       LDA #$1A
12A9:A0 7E       LDY #$7E
12AB:60          RTS
12AC:01          ???				; Utilisé comme Registre
12AD:A9 D6       LDA #$D6
12AF:A0 7D       LDY #$7D
12B1:60          RTS
12B2:A9 F0       LDA #$F0
12B4:A0 7D       LDY #$7D
12B6:60          RTS
12B7:A5 1F       LDA $1F		;>>On vérifie (encore?)
12B9:C9 01       CMP #$01		; Que l'on a sélectionné au Level 1
12BB:F0 01       BEQ $12BE		; OUI>>
12BD:60          RTS
12BE:A9 00       LDA #$00		;>>Traitement si Level 1
12C0:85 00       STA $00		; Lignes Paires sera noires
12C2:85 01       STA $01
12C4:A9 2A       LDA #$2A		; Lignes Impaires seront vertes (#2A #55)
12C6:85 02       STA $02
12C8:A9 55       LDA #$55
12CA:85 03       STA $03
12CC:A2 B8       LDX #$B8		; Remplissage de la ligne 184 à 192
12CE:A0 C0       LDY #$C0
12D0:20 30 0A    JSR $0A30		;>>JMP $672E>> On remplit les lignes de X à Y-1, lignes paires avec $00$01 et lignes impaires avec $02$03
12D3:A9 2A       LDA #$2A		; Lignes Impaires seront vertes (#2A #55)
12D5:85 00       STA $00
12D7:A9 55       LDA #$55
12D9:85 01       STA $01
12DB:A9 00       LDA #$00		; Lignes Paires sera noires
12DD:85 02       STA $02
12DF:85 03       STA $03
12E1:A2 10       LDX #$10		; Remplissage de la ligne 16 à 27
12E3:A0 1B       LDY #$1B
12E5:20 30 0A    JSR $0A30
12E8:60          RTS
12E9:02                   ???
12EA:BB                   ???
12EB:5A                   ???
12EC:30 5F       BMI $134D
12EE:EE 3D A8    INC $A83D
12F1:00          BRK
12F2:12                   ???
12F3:A6 E9       LDX $E9
12F5:F0 1F       BEQ $1316
12F7:E0 04       CPX #$04
12F9:90 11       BCC $130C
12FB:A0 03       LDY #$03
12FD:B9 64 15    LDA $1564,Y
1300:00          BRK
1301:60          RTS
1302:8E 61 C9    STX $C961
1305:63                   ???
1306:EC 64 4E    CPX $4E64
1309:65 C6       ADC $C6
130B:65 D8       ADC $D8
130D:65 46       ADC $46
130F:66 F8       ROR $F8
1311:65 EA       ADC $EA
1313:65 DA       ADC $DA
1315:67                   ???
1316:66 67       ROR $67
1318:06 66       ASL $66
131A:1F                   ???
131B:66 64       ROR $64
131D:66 2E       ROR $2E
131F:67                   ???
1320:BE 66 64    LDX $6466,Y
1323:6B                   ???
1324:69 6C       ADC #$6C
1326:8B                   ???
1327:66 EB       ROR $EB
1329:66 11       ROR $11
132B:67                   ???
132C:40          RTI
132D:6B                   ???
132E:64                   ???
132F:15 A5       ORA $A5,X
1331:72                   ???
1332:6B                   ???
1333:71 87       ADC ($87),Y
1335:72                   ???
1336:6F                   ???
1337:70 52       BVS $138B
1339:71 C3       ADC ($C3),Y
133B:72                   ???
133C:2F                   ???
133D:72                   ???
133E:77                   ???
133F:72                   ???
1340:00          BRK
1341:14                   ???
1342:94 14       STY $14,X
1344:64                   ???
1345:14                   ???
1346:0F                   ???
1347:D0 02       BNE $134B
1349:A2 00       LDX #$00
134B:A9 FF       LDA #$FF
134D:9D 44 14    STA $1444,X
1350:5C                   ???
1351:13                   ???
1352:CD 15 D3    CMP $D315
1355:17                   ???
1356:C0 16       CPY #$16
1358:98          TYA
1359:16 5C       ASL $5C,X
135B:13                   ???
135C:60          RTS
135D:64                   ???
135E:A0 15       LDY #$15
1360:8D 13 10    STA $1013
1363:8C 14 10    STY $1014
1366:A9 10       LDA #$10
1368:A0 0B       LDY #$0B
136A:20 05 10    JSR $1005
136D:90 03       BCC $1372
136F:4C A4 12    JMP $12A4
1372:18          CLC
1373:A5 D4       LDA $D4
1375:A6 E9       LDX $E9
1377:7D 9C 13    ADC $139C,X
137A:AA          TAX
137B:A0 00       LDY #$00
137D:B9 64 15    LDA $1564,Y
1380:91 DE       STA ($DE),Y
1382:C8          INY
1383:CA          DEX
1384:D0 F7       BNE $137D
1386:A5 D2       LDA $D2
1388:8D 13 10    STA $1013
138B:60          RTS
138C:0F                   ???
138D:01 02       ORA ($02,X)
138F:03                   ???
1390:04                   ???
1391:05 06       ORA $06
1393:07                   ???
1394:08          PHP
1395:09 0A       ORA #$0A
1397:0B                   ???
1398:0C                   ???
1399:0D 0E 00    ORA $000E
139C:00          BRK
139D:02                   ???
139E:02                   ???
139F:00          BRK
13A0:02                   ???
13A1:D2                   ???
13A2:00          BRK
13A3:64                   ???		; Position du sprite joueur?
13A4:00          BRK
13A5:02                   ???
13A6:D2                   ???
13A7:64                   ???
13A8:04                   ???
13A9:01 03       ORA ($03,X)
13AB:FF                   ???
13AC:41 05       EOR ($05,X)
13AE:01 04       ORA ($04,X)
13B0:41 00       EOR ($00,X)
13B2:00          BRK
13B3:01 FF       ORA ($FF,X)
13B5:AF                   ???
13B6:05 00       ORA $00
13B8:02                   ???
13B9:AF                   ???
13BA:00          BRK
13BB:00          BRK
13BC:14                   ???
13BD:00          BRK
13BE:64                   ???
13BF:00          BRK
13C0:00          BRK
13C1:14                   ???
13C2:64                   ???
13C3:00          BRK
13C4:00          BRK
13C5:00          BRK
13C6:00          BRK
13C7:00          BRK
13C8:00          BRK
13C9:00          BRK
13CA:00          BRK
13CB:00          BRK
13CC:00          BRK
13CD:00          BRK
13CE:00          BRK
13CF:00          BRK
13D0:00          BRK
13D1:00          BRK
13D2:00          BRK
13D3:00          BRK
13D4:00          BRK
13D5:00          BRK
13D6:00          BRK
13D7:46 00       LSR $00
13D9:64                   ???
13DA:00          BRK
13DB:00          BRK
13DC:46 64       LSR $64
13DE:00          BRK
13DF:00          BRK
13E0:00          BRK
13E1:00          BRK
13E2:00          BRK
13E3:00          BRK
13E4:00          BRK
13E5:00          BRK
13E6:00          BRK
13E7:00          BRK
13E8:00          BRK
13E9:00          BRK
13EA:00          BRK
13EB:00          BRK
13EC:00          BRK
13ED:00          BRK
13EE:00          BRK
13EF:00          BRK
13F0:00          BRK
13F1:02                   ???
13F2:BB                   ???
13F3:5A                   ???
13F4:30 5F       BMI $1455
13F6:EE 3D A8    INC $A83D
13F9:60          RTS
13FA:D3                   ???
13FB:C9 C3       CMP #$C3
13FD:A0 A0       LDY #$A0
13FF:A0          ???
1400:A5 1B       LDA $1B		; Option SON activé?
1402:F0 0A       BEQ $140E		; OUI 
1404:A2 0A       LDX #$0A		; NON
1406:A9 00       LDA #$00
1408:95 60       STA $60,X		; On efface les registres $60->$69
140A:CA          DEX
140B:D0 FB       BNE $1408
140D:60          RTS
140E:A0 0A       LDY #$0A
1410:8C 41 14    STY $1441
1413:B9 60 00    LDA $0060,Y
1416:F0 20       BEQ $1438
1418:B9 43 14    LDA $1443,Y
141B:F0 1B       BEQ $1438
141D:8D 42 14    STA $1442
1420:BE 4E 14    LDX $144E,Y
1423:2C 30 C0    BIT $C030		;C030 48200	SPKR	OECG	R	Toggle Speaker
1426:CA          DEX
1427:D0 FA       BNE $1423
1429:BE 59 14    LDX $1459,Y
142C:CA          DEX
142D:D0 FD       BNE $142C
142F:CE 42 14    DEC $1442
1432:D0 EC       BNE $1420
1434:98          TYA
1435:AA          TAX
1436:D6 60       DEC $60,X
1438:CE 41 14    DEC $1441
143B:AC 41 14    LDY $1441
143E:D0 D3       BNE $1413
1440:60          RTS
1441:00          BRK
1442:00          BRK
1443:00          BRK
1444:20 10 20    JSR $2010
1447:05 05       ORA $05
1449:10 10       BPL $145B
144B:10 20       BPL $146D
144D:0A          ASL
144E:00          BRK
144F:05 0A       ORA $0A
1451:05 05       ORA $05
1453:05 05       ORA $05
1455:05 03       ORA $03
1457:10 05       BPL $145E
1459:00          BRK
145A:10 02       BPL $145E
145C:20 02 05    JSR $0502
145F:10 10       BPL $1471
1461:08          PHP
1462:20 05		 ???
; desassemblage manuel
1464:A9 10       LDA #$10
1466:85 20       STA $20	
146A:8C 93 14    STY $1493		; Sauvegarde dans adresse mémoire flag $1493
146D:AC 93 14    LDY $1493
1470:B1 80       LDA ($80),Y
1472:C9 FF       CMP #$FF
1474:D0 01       BNE $1477
1476:60          RTS
1477:85 22       STA $22
1479:C8          INY
147A:B1 80       LDA ($80),Y
147C:85 21       STA $21
147E:C8          INY
147F:8C 93 14    STY $1493
1482:20 94 14    JSR $1494
1485:A9 00       LDA #$00
1487:85 22       STA $22
1489:A9 0A       LDA #$0A
148B:85 21       STA $21
148D:20 94 14    JSR $1494
1490:4C 6D 14    JMP $146D
1493:26		     ???			; Adresse mémoire flag
1495:A5 1B       LDA $1B
1496:F0 01       BEQ $1499
1498:60          RTS
1499:4C D0 14    JMP $14D0
149C:A4 23       LDY $23
149E:AD 30 C0    LDA $C030
14A1:E6 25       INC $25
14A3:D0 05       BNE $14AA
14A5:E6 26       INC $26
14A7:D0 05       BNE $14AE
14A9:60          RTS
14AA:EA          NOP
14AB:4C AE 14    JMP $14AE
14AE:88          DEY
14AF:F0 05       BEQ $14B6
14B1:4C B4 14    JMP $14B4
14B4:D0 EB       BNE $14A1
14B6:A4 24       LDY $24
14B8:AD 30 C0    LDA $C030
14BB:E6 25       INC $25
14BD:D0 05       BNE $14C4
14BF:E6 26       INC $26
14C1:D0 05       BNE $14C8
14C3:60          RTS
14C4:EA          NOP
14C5:4C C8 14    JMP $14C8
14C8:88          DEY
14C9:F0 D1       BEQ $149C
14CB:4C CE 14    JMP $14CE
14CE:D0 EB       BNE $14BB
14D0:A5 22       LDA $22
14D2:0A          ASL
14D3:A8          TAY
14D4:B9 15 15    LDA $1515,Y
14D7:85 24       STA $24
14D9:A5 20       LDA $20
14DB:4A          LSR
14DC:F0 04       BEQ $14E2
14DE:46 24       LSR $24
14E0:D0 F9       BNE $14DB
14E2:B9 15 15    LDA $1515,Y
14E5:38          SEC
14E6:E5 24       SBC $24
14E8:85 23       STA $23
14EA:C8          INY
14EB:B9 15 15    LDA $1515,Y
14EE:65 24       ADC $24
14F0:85 24       STA $24
14F2:A9 00       LDA #$00
14F4:38          SEC
14F5:E5 21       SBC $21
14F7:85 26       STA $26
14F9:A9 00       LDA #$00
14FB:85 25       STA $25
14FD:A5 23       LDA $23
14FF:D0 9B       BNE $149C
1501:EA          NOP
1502:EA          NOP
1503:4C 06 15    JMP $1506
1506:E6 25       INC $25
1508:D0 05       BNE $150F
150A:E6 26       INC $26
150C:D0 05       BNE $1513
150E:60          RTS
150F:EA          NOP
1510:4C 13 15    JMP $1513
1513:D0 EC       BNE $1501
1515:00          BRK
1516:00          BRK
1517:F6 F6       INC $F6,X
1519:E8          INX
151A:E8          INX
151B:DB                   ???
151C:DB                   ???
151D:CF                   ???
151E:CF                   ???
151F:C3                   ???
1520:C3                   ???
1521:B8          CLV
1522:B8          CLV
1523:AE AE A4    LDX $A4AE
1526:A4 9B       LDY $9B
1528:9B                   ???
1529:92                   ???
152A:92                   ???
152B:8A          TXA
152C:8A          TXA
152D:82                   ???
152E:82                   ???
152F:7B                   ???
1530:7B                   ???
1531:74                   ???
1532:74                   ???
1533:6D 6E 67    ADC $676E
1536:68          PLA
1537:61 62       ADC ($62,X)
1539:5C                   ???
153A:5C                   ???
153B:57                   ???
153C:57                   ???
153D:52                   ???
153E:52                   ???
153F:4D 4E 49    EOR $494E
1542:49 45       EOR #$45
1544:45 41       EOR $41
1546:41 3D       EOR ($3D,X)
1548:3E 3A 3A    ROL $3A3A,X
154B:36 37       ROL $37,X
154D:33                   ???
154E:34                   ???
154F:30 31       BMI $1582
1551:2E 2E 2B    ROL $2B2E
1554:2C 29 29    BIT $2929
1557:26 27       ROL $27
1559:24 25       BIT $25
155B:22                   ???
155C:23                   ???
155D:20 21 1E    JSR $1E21
1560:1F                   ???
1561:1D 1D 1B    ORA $1B1D,X
1564:1C                   ???
1565:1A                   ???
1566:1A                   ???
1567:18          CLC
1568:19 17 17    ORA $1717,Y
156B:15 16       ORA $16,X
156D:14                   ???
156E:15 13       ORA $13,X
1570:14                   ???
1571:12                   ???
1572:12                   ???
1573:11 11       ORA ($11),Y
1575:10 10       BPL $1587
1577:0F                   ???
1578:10 0E       BPL $1588
157A:0F                   ???
157B:02                   ???
157C:BB                   ???
157D:5A                   ???
157E:30 5F       BMI $15DF
1580:EE 3D A8    INC $A83D
1583:60          RTS
1584:00          BRK
1585:00          BRK
1586:00          BRK
1587:00          BRK
1588:00          BRK
1589:00          BRK
158A:00          BRK
158B:00          BRK
158C:00          BRK
158D:00          BRK
158E:00          BRK
158F:00          BRK
1590:00          BRK
1591:00          BRK
1592:00          BRK
1593:00          BRK
1594:00          BRK
1595:00          BRK
1596:00          BRK
1597:00          BRK
1598:00          BRK
1599:00          BRK
159A:00          BRK
159B:00          BRK
159C:00          BRK
159D:00          BRK
159E:00          BRK
159F:00          BRK
15A0:6C 00 13    JMP ($1300) =>6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
15A3:6C 02 13    JMP ($1302) =>618E
15A6:6C 06 13    JMP ($1306) =>64EC		; Gestion des registre $D4, $D5, $D6 et $D7 pour le mode JOYSTICK
15A9:6C 0E 13    JMP ($130E) =>6646		; Efface la page graphique 1 ou 2 suivant A sauvegardé dans $E6 (poids fort de la mémoire graphique)
15AC:6C 10 13    JMP ($1310) =>65F8
15AF:6C 14 13    JMP ($1314) =>67DA
15B2:6C 16 13    JMP ($1316) =>6766		; <ROUTINE1>
15B5:6C 42 13    JMP ($1342) =>1494
15B8:6C 32 13    JMP ($1332) =>716B
15BB:6C 34 13    JMP ($1334) =>7287
15BE:6C 36 13    JMP ($1336) =>706F
15C1:6C 38 13    JMP ($1338) =>7152
15C4:6C 3A 13    JMP ($133A) =>72C3
15C7:6C 3C 13    JMP ($133C) =>722F
15CA:6C 3E 13    JMP ($133E) =>7277
; Semble être l'écran d'acceuil
15CD:A9 00       LDA #$00
15CF:85 3C       STA $3C		; Flag local=1 si de fin de tempo pour écran option? ou?
15D1:20 B2 15    JSR $15B2		; <ROUTINE1> Test touche
15D4:A5 31       LDA $31		; A priori pas en ECRAN OPTIONs...
15D6:F0 01       BEQ $15D9		;pas en cours d'option>↓>
15D8:60          RTS
15D9:A5 1D       LDA $1D		; Prends la page à dessiner
15DB:A2 2A       LDX #$2A		
15DD:A0 55       LDY #$55
15DF:20 98 16    JSR $1698		; Affiche un écran tout vert 
15E2:20 C7 15    JSR $15C7		; JMP$722F Affiche les bandes haute et basse du texte de l'écran d'acceuil
15E5:A5 1D       LDA $1D
15E7:C9 20       CMP #$20
15E9:D0 06       BNE $15F1
15EB:2C 54 C0    BIT $C054
15EE:4C F4 15    JMP $15F4
15F1:2C 55 C0    BIT $C055
15F4:A4 1C       LDY $1C
15F6:85 1C       STA $1C
15F8:85 E6       STA $E6
15FA:84 1D       STY $1D
15FC:A9 10       LDA #$10
15FE:85 20       STA $20
1600:A9 0C       LDA #$0C
1602:A0 0D       LDY #$0D
1604:A6 1D       LDX $1D
1606:20 00 1D    JSR $1D00      ; on charge la page graphique $1D avec deux tracks $0c & $0d qui représente le logo "Jungle Hunt"
1609:A9 00       LDA #$00
160B:8D 15 17    STA $1715
160E:A9 64       LDA #$64
1610:85 DE       STA $DE
1612:A9 14       LDA #$14
1614:85 DC       STA $DC
1616:A5 1C       LDA $1C
1618:85 E6       STA $E6
161A:A0 78       LDY #$78       ; ligne graphique 120
161C:20 A0 15    JSR $15A0		; JMP$6000>>Récupère la adresse de la ligne graphique Y dans ($4C) (page $E6)
161F:A5 4C       LDA $4C
1621:85 84       STA $84
1623:A5 4D       LDA $4D
1625:85 85       STA $85
1627:A5 1D       LDA $1D
1629:85 E6       STA $E6
162B:A4 DC       LDY $DC        ; ligne graphique 20=>
162D:20 A0 15    JSR $15A0		; JMP$6000>>Récupère la adresse de la ligne graphique Y dans ($4C) (page $E6)
1630:A0 05       LDY #$05       ; on commence au 5ème octets de la ligne
1632:B1 4C       LDA ($4C),Y
1634:91 84       STA ($84),Y
1636:C8          INY
1637:C0 23       CPY #$23       ; on fini au 35ème octet
1639:90 F7       BCC $1632
163B:E6 DC       INC $DC
163D:A5 1C       LDA $1C
163F:85 E6       STA $E6
1641:A9 64       LDA #$64
1643:85 C4       STA $C4
1645:A0 14       LDY #$14
1647:84 C5       STY $C5
1649:A4 C5       LDY $C5
164B:20 A0 15    JSR $15A0		; JMP$6000>>Récupère la adresse de la ligne graphique Y dans ($4C) (page $E6)
164E:A5 4C       LDA $4C
1650:85 86       STA $86
1652:A5 4D       LDA $4D
1654:85 87       STA $87
1656:E6 C5       INC $C5
1658:A4 C5       LDY $C5
165A:20 A0 15    JSR $15A0		; JMP$6000>>Récupère la adresse de la ligne graphique Y dans ($4C) (page $E6)
165D:A0 05       LDY #$05
165F:B1 4C       LDA ($4C),Y
1661:91 86       STA ($86),Y
1663:C8          INY
1664:C0 23       CPY #$23
1666:D0 F7       BNE $165F
1668:20 B2 15    JSR $15B2		; <ROUTINE1> touche appuyée dans
166B:A5 31       LDA $31        ; En options
166D:05 3C       ORA $3C
166F:D0 26       BNE $1697
1671:C6 C4       DEC $C4
1673:D0 D9       BNE $164E
1675:C6 DE       DEC $DE
1677:D0 AE       BNE $1627
1679:20 F0 16    JSR $16F0
167C:C9 FF       CMP #$FF
167E:D0 03       BNE $1683
1680:E6 3A       INC $3A
1682:60          RTS
1683:20 B2 15    JSR $15B2		; <ROUTINE1>
1686:A5 2A       LDA $2A
1688:D0 07       BNE $1691
168A:AD 61 C0    LDA $C061
168D:10 02       BPL $1691
168F:85 31       STA $31
1691:A5 31       LDA $31
1693:05 3C       ORA $3C
1695:F0 E2       BEQ $1679
1697:60          RTS
; Affiche un écran tout vert
1698:85 E6       STA $E6		; Prochain écran à afficher
169A:86 0E       STX $0E		; Sauvegarde de la couleur (verte) octet impaire 
169C:84 0F       STY $0F		; Sauvegarde de la couleur (verte) paire
169E:A9 40       LDA #$40	
16A0:85 4A       STA $4A
16A2:A4 4A       LDY $4A		; Charge le nb de ligne verte à afficher
16A4:D0 01       BNE $16A7		;non nul OUI>↓>
16A6:60          RTS
16A7:88          DEY				;>> On va a
16A8:20 A0 15    JSR $15A0		; JMP$6000>>Récupère la adresse de la ligne graphique Y dans ($4C) (page $E6)
16AB:A0 00       LDY #$00		
16AD:A5 0E       LDA $0E
16AF:91 4C       STA ($4C),Y
16B1:C8          INY
16B2:A5 0F       LDA $0F
16B4:91 4C       STA ($4C),Y
16B6:C8          INY
16B7:C0 80       CPY #$80		; correspond à 3 lignes (remplissage des 3 banks mémoires)
16B9:90 F2       BCC $16AD
16BB:C6 4A       DEC $4A
16BD:4C A2 16    JMP $16A2
; On recopie la page 1 ou 2 ($1D) dans l'autre page $1C
16C0:A0 00       LDY #$00
16C2:84 4A       STY $4A
16C4:A5 1D       LDA $1D        ; $1D vaut soit la page 1 ou 2 et on est sur que $1C est l'autre page
16C6:85 E6       STA $E6
16C8:20 A0 15    JSR $15A0      ; Récupère la adresse de la ligne graphique Y dans ($4C) (page $E6)
16CB:A5 4C       LDA $4C
16CD:85 80       STA $80
16CF:A5 4D       LDA $4D
16D1:85 81       STA $81
16D3:A5 1C       LDA $1C        ; $1C vaut soit la page 1 ou 2 et on est sur que $1D est l'autre page
16D5:85 E6       STA $E6
16D7:A4 4A       LDY $4A
16D9:20 A0 15    JSR $15A0      ; Récupère la adresse de la ligne graphique Y dans ($4C)
16DC:A0 00       LDY #$00
16DE:B1 80       LDA ($80),Y
16E0:91 4C       STA ($4C),Y
16E2:C8          INY
16E3:C0 80       CPY #$80
16E5:90 F7       BCC $16DE
16E7:E6 4A       INC $4A
16E9:A4 4A       LDY $4A
16EB:C0 40       CPY #$40
16ED:90 D5       BCC $16C4
16EF:60          RTS
;
16F0:AC 15 17    LDY $1715
16F3:B9 16 17    LDA $1716,Y
16F6:C9 FF       CMP #$FF
16F8:F0 1A       BEQ $1714
16FA:85 22       STA $22
16FC:C8          INY
16FD:B9 16 17    LDA $1716,Y
1700:85 21       STA $21
1702:C8          INY
1703:8C 15 17    STY $1715
1706:20 B5 15    JSR $15B5
1709:A9 00       LDA #$00
170B:85 22       STA $22
170D:A9 0F       LDA #$0F
170F:85 21       STA $21
1711:20 B5 15    JSR $15B5
1714:60          RTS
1715:00          BRK
1716:03                   ???
1717:10 0F       BPL $1728
1719:20 16 08    JSR $0816
171C:0F                   ???
171D:08          PHP
171E:16 08       ASL $08,X
1720:0F                   ???
1721:40          RTI
1722:16 08       ASL $08,X
1724:0F                   ???
1725:08          PHP
1726:16 08       ASL $08,X
1728:0C                   ???
1729:10 18       BPL $1743
172B:20 13 08    JSR $0813
172E:18          CLC
172F:40          RTI
1730:13                   ???
1731:08          PHP
1732:18          CLC
1733:08          PHP
1734:03                   ???
1735:10 0F       BPL $1746
1737:20 16 08    JSR $0816
173A:0F                   ???
173B:08          PHP
173C:16 08       ASL $08,X
173E:0F                   ???
173F:40          RTI
1740:16 08       ASL $08,X
1742:0F                   ???
1743:08          PHP
1744:16 08       ASL $08,X
1746:0C                   ???
1747:10 18       BPL $1761
1749:20 13 08    JSR $0813
174C:18          CLC
174D:40          RTI
174E:13                   ???
174F:08          PHP
1750:18          CLC
1751:08          PHP
1752:11 08       ORA ($08),Y
1754:14                   ???
1755:08          PHP
1756:00          BRK
1757:08          PHP
1758:18          CLC
1759:08          PHP
175A:00          BRK
175B:08          PHP
175C:16 08       ASL $08,X
175E:18          CLC
175F:08          PHP
1760:00          BRK
1761:08          PHP
1762:11 08       ORA ($08),Y
1764:14                   ???
1765:08          PHP
1766:00          BRK
1767:08          PHP
1768:18          CLC
1769:08          PHP
176A:00          BRK
176B:08          PHP
176C:16 08       ASL $08,X
176E:18          CLC
176F:08          PHP
1770:00          BRK
1771:08          PHP
1772:03                   ???
1773:08          PHP
1774:13                   ???
1775:08          PHP
1776:00          BRK
1777:08          PHP
1778:18          CLC
1779:08          PHP
177A:00          BRK
177B:08          PHP
177C:16 08       ASL $08,X
177E:18          CLC
177F:08          PHP
1780:00          BRK
1781:08          PHP
1782:03                   ???
1783:08          PHP
1784:13                   ???
1785:08          PHP
1786:00          BRK
1787:08          PHP
1788:18          CLC
1789:08          PHP
178A:00          BRK
178B:08          PHP
178C:16 08       ASL $08,X
178E:18          CLC
178F:08          PHP
1790:00          BRK
1791:08          PHP
1792:11 08       ORA ($08),Y
1794:14                   ???
1795:08          PHP
1796:00          BRK
1797:08          PHP
1798:18          CLC
1799:08          PHP
179A:00          BRK
179B:08          PHP
179C:16 08       ASL $08,X
179E:18          CLC
179F:08          PHP
17A0:00          BRK
17A1:08          PHP
17A2:11 08       ORA ($08),Y
17A4:14                   ???
17A5:08          PHP
17A6:00          BRK
17A7:08          PHP
17A8:18          CLC
17A9:08          PHP
17AA:00          BRK
17AB:08          PHP
17AC:16 08       ASL $08,X
17AE:18          CLC
17AF:08          PHP
17B0:00          BRK
17B1:08          PHP
17B2:03                   ???
17B3:08          PHP
17B4:13                   ???
17B5:08          PHP
17B6:00          BRK
17B7:08          PHP
17B8:18          CLC
17B9:08          PHP
17BA:00          BRK
17BB:08          PHP
17BC:16 08       ASL $08,X
17BE:18          CLC
17BF:08          PHP
17C0:00          BRK
17C1:08          PHP
17C2:03                   ???
17C3:08          PHP
17C4:13                   ???
17C5:08          PHP
17C6:00          BRK
17C7:08          PHP
17C8:18          CLC
17C9:08          PHP
17CA:00          BRK
17CB:08          PHP
17CC:16 08       ASL $08,X
17CE:18          CLC
17CF:08          PHP
17D0:00          BRK
17D1:08          PHP
17D2:FF                   ???
;Responsable de la gestion de l'affichage de l'écran de fin de jeu.
17D3:A9 00       LDA #$00
17D5:85 3D       STA $3D
17D7:85 3E       STA $3E
17D9:A9 20       LDA #$20
17DB:85 E6       STA $E6		; Flag écran Page 1
17DD:20 CA 15    JSR $15CA
17E0:2C 54 C0    BIT $C054		; Display HGR#0
17E3:A2 FF       LDX #$FF
17E5:CA          DEX
17E6:D0 FD       BNE $17E5		; Boucle vide de 255
17E8:E6 3D       INC $3D		
17EA:D0 11       BNE $17FD
17EC:E6 3E       INC $3E
17EE:A5 3E       LDA $3E
17F0:C9 20       CMP #$20
17F2:90 09       BCC $17FD
17F4:E6 3A       INC $3A
17F6:A9 00       LDA #$00
17F8:85 3D       STA $3D
17FA:85 3E       STA $3E
17FC:60          RTS
17FD:20 B2 15    JSR $15B2		; <ROUTINE1>
1800:A5 2A       LDA $2A
1802:D0 07       BNE $180B
1804:AD 61 C0    LDA $C061		;Switch Input 0
1807:10 02       BPL $180B		; bit7=0 (pas de bouton pressé) on va en $180B
1809:85 31       STA $31		
180B:A5 31       LDA $31
180D:05 3C       ORA $3C
180F:F0 D2       BEQ $17E3
1811:4C F6 17    JMP $17F6
;
1814:00          BRK
1815:8C C0 10    STY $10C0
1818:FB                   ???
1819:C8          INY
181A:CC 40 08    CPY $0840
181D:30 D7       BMI $17F6
181F:4C 0B 18    JMP $180B
1822:A9 00       LDA #$00
1824:8D 59 03    STA $0359
1827:AD 00 C0    LDA $C000		; Last Key Pressed (+ 128 if strobe not cleared)
182A:C9 9B       CMP #$9B		; Touche 'ESC'
182C:D0 10       BNE $183E
182E:AD 10 C0    LDA $C010		;C010 49168	KBDSTRB	OECG	WR	Keyboard Strobe
1831:68          PLA
1832:68          PLA
1833:A9 00       LDA #$00
1835:8D 57 03    STA $0357
1838:20 1E 28    JSR $281E
183B:4C 79 26    JMP $2679
183E:A6 10       LDX $10
1840:CA          DEX
1841:BD 03 08    LDA $0803,X
1844:85 17       STA $17
1846:CA          DEX
1847:BD 03 08    LDA $0803,X
184A:85 14       STA $14
184C:CA          DEX
184D:BD 03 08    LDA $0803,X
; Table des adresses de caractères du Jeu 
1850:AA          TAX					; Adresse du bitmap de ESPACE
1851:18          CLC
1852:B2                   ???		; Adresse de 'A'
1853:18          CLC
1854:BA          TSX
1855:18          CLC
1856:C2                   ???
1857:18          CLC
1858:CA          DEX
1859:18          CLC
185A:D2                   ???
185B:18          CLC
185C:DA                   ???
185D:18          CLC
185E:E2                   ???
185F:18          CLC
1860:EA          NOP
1861:18          CLC
1862:F2                   ???
1863:18          CLC
1864:FA                   ???
1865:18          CLC
1866:02                   ???
1867:19 0A 19    ORA $190A,Y
186A:12                   ???
186B:19 1A 19    ORA $191A,Y
186E:22                   ???
186F:19 2A 19    ORA $192A,Y
1872:32                   ???
1873:19 3A 19    ORA $193A,Y
1876:42                   ???
1877:19 4A 19    ORA $194A,Y
187A:52                   ???
187B:19 5A 19    ORA $195A,Y
187E:62                   ???
187F:19 6A 19    ORA $196A,Y
1882:72                   ???
1883:19 7A 19    ORA $197A,Y
1886:92                   ???
1887:19 9A 19    ORA $199A,Y
188A:A2 19       LDX #$19
188C:AA          TAX
188D:19 B2 19    ORA $19B2,Y
1890:BA          TSX
1891:19 C2 19    ORA $19C2,Y
1894:CA          DEX
1895:19 D2 19    ORA $19D2,Y
1898:DA                   ???
1899:19 82 19    ORA $1982,Y
189C:E2                   ???
189D:19 EA 19    ORA $19EA,Y
18A0:F2                   ???		; Adresse du point central '.'
18A1:19 8A 19    ORA $198A,Y		; Adresse vers un autre ESPACE (8 brk/#00 at $198A)
18A4:8A          TXA					; Adresse vers un autre ESPACE (8 brk at $198A)
18A5:19 8A 19    ORA $198A,Y		; Adresse vers un autre ESPACE (8 brk at $198A)
18A8:AA          TAX					; Adresse de ESPACE
18A9:18          CLC
; Mémoire/Table Graphique des Lettres 7 octets par lettre
18AA:00          BRK					; ESPACE
18AB:00          BRK
18AC:00          BRK
18AD:00          BRK
18AE:00          BRK
18AF:00          BRK
18B0:00          BRK
18B1:00          BRK
18B2:0C                   ???		; Lettre 'A'
18B3:1E 33 33    ASL $3333,X
18B6:3F                   ???
18B7:33                   ???
18B8:33                   ???
18B9:00          BRK
18BA:1F                   ???		; Lettre 'B'
18BB:33                   ???
18BC:33                   ???
18BD:1F                   ???
18BE:33                   ???
18BF:33                   ???
18C0:1F                   ???
18C1:00          BRK
18C2:1E 33 03    ASL $0333,X		; Lettre 'C'
18C5:03                   ???
18C6:03                   ???
18C7:33                   ???
18C8:1E 00 1F    ASL $1F00,X		; Lettre 'D'
18CB:33                   ???
18CC:33                   ???
18CD:33                   ???
18CE:33                   ???
18CF:33                   ???
18D0:1F                   ???
18D1:00          BRK	
18D2:3F                   ???		; Lettre 'E'
18D3:03                   ???
18D4:03                   ???
18D5:1F                   ???
18D6:03                   ???
18D7:03                   ???
18D8:3F                   ???
18D9:00          BRK
18DA:3F                   ???		; Lettre 'F'
18DB:03                   ???
18DC:03                   ???
18DD:0F                   ???
18DE:03                   ???
18DF:03                   ???
18E0:03                   ???
18E1:00          BRK
18E2:1E 33 03    ASL $0333,X		; Lettre 'G'
18E5:03                   ???
18E6:3B                   ???
18E7:33                   ???
18E8:1E 00 33    ASL $3300,X		; Lettre 'H'
18EB:33                   ???
18EC:33                   ???
18ED:3F                   ???
18EE:33                   ???
18EF:33                   ???
18F0:33                   ???
18F1:00          BRK
18F2:3F                   ???		; Lettre 'I'
18F3:0C                   ???
18F4:0C                   ???
18F5:0C                   ???
18F6:0C                   ???
18F7:0C                   ???
18F8:3F                   ???
18F9:00          BRK
18FA:3C                   ???		; Lettre 'J'
18FB:18          CLC
18FC:18          CLC
18FD:18          CLC
18FE:1B                   ???
18FF:1B                   ???
1900:0E 00 33    ASL $3300			; Lettre 'K'
1903:1B                   ???
1904:0F                   ???
1905:0F                   ???
1906:1B                   ???
1907:33                   ???
1908:33                   ???
1909:00          BRK
190A:03                   ???		; Lettre 'L'
190B:03                   ???
190C:03                   ???
190D:03                   ???
190E:03                   ???
190F:03                   ???
1910:3F                   ???
1911:00          BRK
1912:21 33       AND ($33,X)		; Lettre 'M'
1914:3F                   ???
1915:33                   ???
1916:33                   ???
1917:33                   ???
1918:33                   ???
1919:00          BRK		
191A:31 33       AND ($33),Y		; Lettre 'N'
191C:37                   ???
191D:3F                   ???
191E:3B                   ???
191F:33                   ???
1920:23                   ???
1921:00          BRK
1922:1E 33 33    ASL $3333,X		; Lettre 'O'
1925:33                   ???
1926:33                   ???
1927:33                   ???
1928:1E 00 1F    ASL $1F00,X		; Lettre 'P'
192B:33                   ???
192C:33                   ???
192D:1F                   ???
192E:03                   ???
192F:03                   ???
1930:03                   ???
1931:00          BRK
1932:1E 33 33    ASL $3333,X		; Lettre 'Q'
1935:33                   ???
1936:33                   ???
1937:1E 30 00    ASL $0030,X		
193A:1F                   ???		; Lettre 'R'
193B:33                   ???
193C:33                   ???
193D:1F                   ???
193E:0F                   ???
193F:1B                   ???
1940:33                   ???
1941:00          BRK
1942:1E 33 03    ASL $0333,X		; Lettre 'S'
1945:1E 30 33    ASL $3330,X
1948:1E 00 3F    ASL $3F00,X		; Lettre 'T'
194B:0C                   ???
194C:0C                   ???
194D:0C                   ???
194E:0C                   ???
194F:0C                   ???
1950:0C                   ???
1951:00          BRK
1952:33                   ???		; Lettre 'U'
1953:33                   ???
1954:33                   ???
1955:33                   ???
1956:33                   ???
1957:33                   ???
1958:1E 00 33    ASL $3300,X		; Lettre 'V'
195B:33                   ???
195C:33                   ???
195D:33                   ???
195E:33                   ???
195F:1E 0C 00    ASL $000C,X
1962:33                   ???		; Lettre "W"
1963:33                   ???
1964:33                   ???
1965:33                   ???
1966:3F                   ???
1967:33                   ???
1968:21 00       AND ($00,X)
196A:33                   ???		; Lettre 'X'
196B:33                   ???
196C:1E 0C 1E    ASL $1E0C,X
196F:33                   ???
1970:33                   ???
1971:00          BRK
1972:33                   ???		; Lettre 'Y'
1973:33                   ???
1974:1E 0C 0C    ASL $0C0C,X	
1977:0C                   ???
1978:0C                   ???
1979:00          BRK
197A:3F                   ???		; Lettre 'Z'
197B:30 18       BMI $1995
197D:0C                   ???
197E:06 03       ASL $03
1980:3F                   ???
1981:00          BRK
1982:00          BRK
1983:00          BRK
1984:00          BRK
1985:00          BRK
1986:00          BRK
1987:00          BRK
1988:00          BRK
1989:00          BRK
198A:00          BRK
198B:00          BRK
198C:00          BRK
198D:00          BRK
198E:00          BRK
198F:00          BRK
1990:00          BRK
1991:00          BRK
;; Mémoire/Table Graphique des CHIFFRES et parenthèses et point 
1992:00          BRK                     ; Chiffre '0'
1993:3C                   ???
1994:66 66       ROR $66
1996:66 66       ROR $66
1998:3C                   ???
1999:00          BRK
199A:00          BRK                     ; Chiffre '1'
199B:18          CLC
199C:1C                   ???
199D:18          CLC
199E:18          CLC
199F:18          CLC
19A0:7E 00 00    ROR $0000,X            ; Chiffre '2'
19A3:1C                   ???
19A4:36 30       ROL $30,X
19A6:18          CLC
19A7:0C                   ???
19A8:7E 00 00    ROR $0000,X            ; Chiffre '3'
19AB:7E 30 18    ROR $1830,X
19AE:30 66       BMI $1A16
19B0:3C                   ???
19B1:00          BRK
19B2:00          BRK                     ; Chiffre '4'
19B3:36 36       ROL $36,X
19B5:36 7E       ROL $7E,X
19B7:30 30       BMI $19E9
19B9:00          BRK
19BA:00          BRK                     ; Chiffre '5'
19BB:7E 06 3E    ROR $3E06,X
19BE:60          RTS
19BF:66 3C       ROR $3C
19C1:00          BRK
19C2:00          BRK                     ; Chiffre '6'
19C3:1C                   ???
19C4:06 3E       ASL $3E
19C6:66 66       ROR $66
19C8:3C                   ???
19C9:00          BRK
19CA:00          BRK                     ; Chiffre '7'
19CB:7E 30 18    ROR $1830,X
19CE:0C                   ???
19CF:06 06       ASL $06
19D1:00          BRK
19D2:00          BRK                     ; Chiffre '8'
19D3:3C                   ???
19D4:66 3C       ROR $3C
19D6:66 66       ROR $66
19D8:3C                   ???
19D9:00          BRK
19DA:00          BRK                     ; Chiffre '9'
19DB:3C                   ???
19DC:66 66       ROR $66
19DE:7C                   ???
19DF:60          RTS
19E0:3C                   ???
19E1:00          BRK                     ; Parenthèse ouvrante '('
19E2:0C                   ???
19E3:06 03       ASL $03
19E5:03                   ???
19E6:03                   ???
19E7:06 0C       ASL $0C
19E9:00          BRK                     ; Parenthèse fermante ')'
19EA:0C                   ???
19EB:18          CLC
19EC:30 30       BMI $1A1E
19EE:30 18       BMI $1A08
19F0:0C                   ???
19F1:00          BRK
19F2:00          BRK                     ; Point central "."
19F3:00          BRK
19F4:00          BRK
19F5:1C                   ???
19F6:1C                   ???
19F7:00          BRK
19F8:00          BRK
19F9:00          BRK
19FA:60          RTS
19FB:08          PHP
19FC:CA          DEX
19FD:A5 14       LDA $14
19FF:9D 03 08    STA $0803,X
1A02:CA          DEX
1A03:A5 0F       LDA $0F
1A05:9D 03 08    STA $0803,X
1A08:CA          DEX
1A09:A5 0E       LDA $0E
1A0B:9D 03 08    STA $0803,X
1A0E:60          RTS
1A0F:A0 00       LDY #$00
1A11:B9 E7 1A    LDA $1AE7,Y
1A14:C8          INY
1A15:C9 A6       CMP #$A6
1A17:F0 06       BEQ $1A1F
1A19:20 F0 FD    JSR $FDF0
1A1C:4C 11 1A    JMP $1A11
1A1F:A5 05       LDA $05
1A21:18          CLC
1A22:6A          ROR
1A23:08          PHP
1A24:20 DA FD    JSR $FDDA
1A27:28          PLP
1A28:90 0A       BCC $1A34
1A2A:A9 AE       LDA #$AE
1A2C:20 F0 FD    JSR $FDF0
1A2F:A9 B5       LDA #$B5
1A31:20 F0 FD    JSR $FDF0
1A34:AD 58 03    LDA $0358
1A37:D0 12       BNE $1A4B
1A39:A0 14       LDY #$14
1A3B:A9 00       LDA #$00
1A3D:20 A8 FC    JSR $FCA8
1A40:88          DEY
1A41:D0 F8       BNE $1A3B
1A43:A9 00       LDA #$00
1A45:8D 25 09    STA $0925
1A48:4C BF 18    JMP $18BF
1A4B:AD 1B 08    LDA $081B
1A4E:C9 02       CMP #$02
1A50:D0 BC       BNE $1A0E
1A52:20 8E FD    JSR $FD8E
1A55:A0 00       LDY #$00
1A57:B9 02 1B    LDA $1B02,Y
1A5A:F0 07       BEQ $1A63
1A5C:C8          INY
1A5D:20 F0 FD    JSR $FDF0
1A60:4C 57 1A    JMP $1A57
1A63:20 0C FD    JSR $FD0C
1A66:C9 9B       CMP #$9B
1A68:D0 05       BNE $1A6F
1A6A:68          PLA
1A6B:68          PLA
1A6C:6C F2 03    JMP ($03F2)
1A6F:C9 D2       CMP #$D2
1A71:D0 08       BNE $1A7B
1A73:68          PLA
1A74:68          PLA
1A75:20 E8 0D    JSR $0DE8
1A78:4C EF 11    JMP $11EF
1A7B:C9 C5       CMP #$C5
1A7D:D0 02       BNE $1A81
1A7F:F0 0E       BEQ $1A8F
1A81:C9 CE       CMP #$CE
1A83:D0 20       BNE $1AA5
1A85:20 E8 0D    JSR $0DE8
1A88:A4 07       LDY $07
1A8A:A9 02       LDA #$02
1A8C:99 25 09    STA $0925,Y
1A8F:A5 16       LDA $16
1A91:85 0F       STA $0F
1A93:A9 00       LDA #$00
1A95:85 0E       STA $0E
1A97:A5 0D       LDA $0D
1A99:38          SEC
1A9A:E9 01       SBC #$01
1A9C:85 17       STA $17
1A9E:A9 FF       LDA #$FF
1AA0:85 14       STA $14
1AA2:4C F1 19    JMP $19F1
1AA5:4C 0E 1A    JMP $1A0E
1AA8:B9 77 1B    LDA $1B77,Y
1AAB:C8          INY
1AAC:C9 A6       CMP #$A6
1AAE:F0 06       BEQ $1AB6
1AB0:20 F0 FD    JSR $FDF0
1AB3:4C A8 1A    JMP $1AA8
1AB6:60          RTS
1AB7:08          PHP
1AB8:05 01       ORA $01
1ABA:04                   ???
1ABB:05 12       ORA $12
1ABD:A6 13       LDX $13
1ABF:19 0E 03    ORA $030E,Y
1AC2:A6 8D       LDX $8D
1AC4:A0 A0       LDY #$A0
1AC6:13                   ???
1AC7:0F                   ???
1AC8:15 12       ORA $12,X
1ACA:03                   ???
1ACB:05 3A       ORA $3A
1ACD:A0 A0       LDY #$A0
1ACF:A0 A0       LDY #$A0
1AD1:A0 A0       LDY #$A0
1AD3:A0 A0       LDY #$A0
1AD5:A0 0F       LDY #$0F
1AD7:02                   ???
1AD8:0A          ASL
1AD9:05 03       ORA $03
1ADB:14                   ???
1ADC:3A                   ???
1ADD:A0 A0       LDY #$A0
1ADF:A0 A0       LDY #$A0
1AE1:A0 A0       LDY #$A0
1AE3:A0 A0       LDY #$A0
1AE5:A0 A6       LDY #$A6
1AE7:8D A0 D5    STA $D5A0
1AEA:CE C1 C2    DEC $C2C1
1AED:CC C5 A0    CPY $A0C5
1AF0:D4                   ???
1AF1:CF                   ???
1AF2:A0 C1       LDY #$C1
1AF4:CE C1 CC    DEC $CCC1
1AF7:D9 DA C5    CMP $C5DA,Y
1AFA:A0 D4       LDY #$D4
1AFC:D2                   ???
1AFD:C1 C3       CMP ($C3,X)
1AFF:CB                   ???
1B00:4C 84 1D    JMP $1D84
1B03:A9 BF       LDA #$BF
1B05:85 41       STA $41
1B07:A2 00       LDX #$00
1B09:86 40       STX $40
1B0B:A0 00       LDY #$00
1B0D:A1 40       LDA ($40,X)
1B0F:85 26       STA $26
1B11:98          TYA
1B12:45 26       EOR $26
1B14:85 26       STA $26
1B16:98          TYA
1B17:41 40       EOR ($40,X)
1B19:81 40       STA ($40,X)
1B1B:C5 26       CMP $26
1B1D:D0 05       BNE $1B24
1B1F:C8          INY
1B20:D0 EF       BNE $1B11
1B22:F0 04       BEQ $1B28
1B24:C6 41       DEC $41
1B26:D0 E3       BNE $1B0B
1B28:A5 41       LDA $41
1B2A:29 DF       AND #$DF
1B2C:85 43       STA $43
1B2E:86 42       STX $42
1B30:A1 42       LDA ($42,X)
1B32:48          PHA
1B33:85 26       STA $26
1B35:98          TYA
1B36:45 26       EOR $26
1B38:85 26       STA $26
1B3A:98          TYA
1B3B:41 40       EOR ($40,X)
1B3D:81 42       STA ($42,X)
1B3F:C5 26       CMP $26
1B41:D0 09       BNE $1B4C
1B43:C8          INY
1B44:D0 EF       BNE $1B35
1B46:A4 43       LDY $43
1B48:68          PLA
1B49:4C 51 1B    JMP $1B51
1B4C:68          PLA
1B4D:81 42       STA ($42,X)
1B4F:A4 41       LDY $41
1B51:C8          INY
1B52:8C 7D 1C    STY $1C7D
1B55:38          SEC
1B56:98          TYA
1B57:ED 7E 1C    SBC $1C7E
1B5A:8D 7C 1C    STA $1C7C
1B5D:38          SEC
1B5E:ED 7A 1C    SBC $1C7A
1B61:F0 9D       BEQ $1B00
1B63:8D 7F 1C    STA $1C7F
1B66:AD 7A 1C    LDA $1C7A
1B69:8D 0D 1D    STA $1D0D
1B6C:A9 1D       LDA #$1D
1B6E:8D 49 37    STA $3749
1B71:A9 84       LDA #$84
1B73:8D 48 37    STA $3748
1B76:A2 00       LDX #$00
1B78:86 40       STX $40
1B7A:BD 29 1C    LDA $1C29,X
1B7D:A8          TAY
1B7E:BD 2A 1C    LDA $1C2A,X
1B81:85 41       STA $41
1B83:4C 93 1B    JMP $1B93
1B86:18          CLC
1B87:B1 40       LDA ($40),Y
1B89:6D 7F 1C    ADC $1C7F
1B8C:91 40       STA ($40),Y
1B8E:C8          INY
1B8F:D0 02       BNE $1B93
1B91:E6 41       INC $41
1B93:C8          INY
1B94:D0 02       BNE $1B98
1B96:E6 41       INC $41
1B98:A5 41       LDA $41
1B9A:DD 2C 1C    CMP $1C2C,X
1B9D:90 E7       BCC $1B86
1B9F:98          TYA
1BA0:DD 2B 1C    CMP $1C2B,X
1BA3:90 E1       BCC $1B86
1BA5:8A          TXA
1BA6:18          CLC
1BA7:69 04       ADC #$04
1BA9:AA          TAX
1BAA:EC 28 1C    CPX $1C28
1BAD:90 CB       BCC $1B7A
1BAF:A2 00       LDX #$00
1BB1:8E 9C 33    STX $339C
1BB4:BD 5A 1C    LDA $1C5A,X
1BB7:85 40       STA $40
1BB9:BD 5B 1C    LDA $1C5B,X
1BBC:85 41       STA $41
1BBE:A2 00       LDX #$00
1BC0:A1 40       LDA ($40,X)
1BC2:20 8E F8    JSR $F88E
1BC5:A4 2F       LDY $2F
1BC7:C0 02       CPY #$02
1BC9:D0 11       BNE $1BDC
1BCB:B1 40       LDA ($40),Y
1BCD:CD 7A 1C    CMP $1C7A
1BD0:90 0A       BCC $1BDC
1BD2:CD 7B 1C    CMP $1C7B
1BD5:B0 05       BCS $1BDC
1BD7:6D 7F 1C    ADC $1C7F
1BDA:91 40       STA ($40),Y
1BDC:38          SEC
1BDD:A5 2F       LDA $2F
1BDF:65 40       ADC $40
1BE1:85 40       STA $40
1BE3:A9 00       LDA #$00
1BE5:65 41       ADC $41
1BE7:85 41       STA $41
1BE9:AE 9C 33    LDX $339C
1BEC:DD 5D 1C    CMP $1C5D,X
1BEF:90 CD       BCC $1BBE
1BF1:A5 40       LDA $40
1BF3:DD 5C 1C    CMP $1C5C,X
1BF6:90 C6       BCC $1BBE
1BF8:8A          TXA
1BF9:18          CLC
1BFA:69 04       ADC #$04
1BFC:AA          TAX
1BFD:EC 59 1C    CPX $1C59
1C00:4C 3C D4    JMP $D43C
1C03:4C 3A DB    JMP $DB3A
1C06:00          BRK
1C07:00          BRK
1C08:FF                   ???
1C09:FF                   ???
1C0A:4C 99 E1    JMP $E199
1C0D:FF                   ???
1C0E:00          BRK
1C0F:00          BRK
1C10:FF                   ???
1C11:FF                   ???
1C12:00          BRK
1C13:00          BRK
1C14:00          BRK
1C15:FF                   ???
1C16:00          BRK
1C17:00          BRK
1C18:FF                   ???
1C19:FF                   ???
1C1A:00          BRK
1C1B:00          BRK
1C1C:FF                   ???
1C1D:FF                   ???
1C1E:00          BRK
1C1F:00          BRK
1C20:00          BRK
1C21:28          PLP
1C22:00          BRK
1C23:18          CLC
1C24:01 17       ORA ($17,X)
1C26:00          BRK
1C27:F3                   ???
1C28:D0 07       BNE $1C31
1C2A:1A                   ???
1C2B:60          RTS
1C2C:F3                   ???
1C2D:00          BRK
1C2E:0D FE FF    ORA $FFFE
1C31:FF                   ???
1C32:FF                   ???
1C33:DD FF FF    CMP $FFFF,X
1C36:BD 9E 81    LDA $819E,X
1C39:9E                   ???
1C3A:00          BRK
1C3B:00          BRK
1C3C:68          PLA
1C3D:1D 00 5F    ORA $5F00,X
1C40:2D 98 00    AND $0098
1C43:98          TYA
1C44:2D 98 82    AND $8298
1C47:D8          CLD
1C48:57                   ???
1C49:1D 00 00    ORA $0000,X
1C4C:FF                   ???
1C4D:FF                   ???
1C4E:F2                   ???
1C4F:32                   ???
1C50:00          BRK
1C51:C0 55       CPY #$55
1C53:00          BRK
1C54:00          BRK
1C55:FF                   ???
1C56:00          BRK
1C57:00          BRK
1C58:FF                   ???
1C59:FF                   ???
1C5A:00          BRK
1C5B:00          BRK
1C5C:FF                   ???
1C5D:FF                   ???
1C5E:00          BRK
1C5F:00          BRK
1C60:FF                   ???
1C61:FF                   ???
1C62:00          BRK
1C63:00          BRK
1C64:FF                   ???
1C65:FF                   ???
1C66:00          BRK
1C67:01 08       ORA ($08,X)
1C69:03                   ???
1C6A:08          PHP
1C6B:03                   ???
1C6C:08          PHP
1C6D:03                   ???
1C6E:08          PHP
1C6F:00          BRK
1C70:96 FF       STX $FF,Y
1C72:00          BRK
1C73:00          BRK
1C74:96 FF       STX $FF,Y
1C76:FF                   ???
1C77:00          BRK
1C78:FF                   ???
1C79:FF                   ???
1C7A:00          BRK
1C7B:00          BRK
1C7C:FF                   ???
1C7D:00          BRK
1C7E:08          PHP
1C7F:00          BRK
1C80:FF                   ???
1C81:FF                   ???
1C82:00          BRK
1C83:00          BRK
1C84:FF                   ???
1C85:FF                   ???
1C86:00          BRK
1C87:00          BRK
1C88:FF                   ???
1C89:FF                   ???
1C8A:00          BRK
1C8B:00          BRK
1C8C:FF                   ???
1C8D:FF                   ???
1C8E:00          BRK
1C8F:03                   ???
1C90:4C FF 00    JMP $00FF
1C93:00          BRK
1C94:FF                   ???
1C95:FF                   ???
1C96:00          BRK
1C97:00          BRK
1C98:FF                   ???
1C99:FF                   ???
1C9A:00          BRK
1C9B:00          BRK
1C9C:FF                   ???
1C9D:FF                   ???
1C9E:00          BRK
1C9F:00          BRK
1CA0:FF                   ???
1CA1:FF                   ???
1CA2:00          BRK
1CA3:00          BRK
1CA4:00          BRK
1CA5:FF                   ???
1CA6:00          BRK
1CA7:00          BRK
1CA8:FF                   ???
1CA9:FF                   ???
1CAA:00          BRK
1CAB:00          BRK
1CAC:FF                   ???
1CAD:FF                   ???
1CAE:00          BRK
1CAF:03                   ???
1CB0:08          PHP
1CB1:E6 B8       INC $B8
1CB3:D0 02       BNE $1CB7
1CB5:E6 B9       INC $B9
1CB7:AD 00 08    LDA $0800
1CBA:C9 3A       CMP #$3A
1CBC:B0 0A       BCS $1CC8
1CBE:C9 20       CMP #$20
1CC0:F0 EF       BEQ $1CB1
1CC2:38          SEC
1CC3:E9 30       SBC #$30
1CC5:38          SEC
1CC6:E9 D0       SBC #$D0
1CC8:60          RTS
1CC9:80                   ???
1CCA:4F                   ???
1CCB:C7                   ???
1CCC:52                   ???
1CCD:FF                   ???
1CCE:00          BRK
1CCF:00          BRK
1CD0:FF                   ???
1CD1:FF                   ???
1CD2:00          BRK
1CD3:00          BRK
1CD4:FF                   ???
1CD5:FF                   ???
1CD6:00          BRK
1CD7:00          BRK
1CD8:FF                   ???
1CD9:FF                   ???
1CDA:00          BRK
1CDB:00          BRK
1CDC:FF                   ???
1CDD:FF                   ???
1CDE:00          BRK
1CDF:00          BRK
1CE0:FF                   ???
1CE1:FF                   ???
1CE2:00          BRK
1CE3:00          BRK
1CE4:FF                   ???
1CE5:FF                   ???
1CE6:00          BRK
1CE7:00          BRK
1CE8:FF                   ???
1CE9:FF                   ???
1CEA:00          BRK
1CEB:00          BRK
1CEC:FF                   ???
1CED:FF                   ???
1CEE:00          BRK
1CEF:00          BRK
1CF0:FF                   ???
1CF1:01 00       ORA ($00,X)
1CF3:00          BRK
1CF4:FF                   ???
1CF5:FF                   ???
1CF6:00          BRK
1CF7:00          BRK
1CF8:FF                   ???
1CF9:FF                   ???
1CFA:00          BRK
1CFB:00          BRK
1CFC:FF                   ???
1CFD:FF                   ???
1CFE:00          BRK
1CFF:00          BRK
; Charge du code de suivant X (Buffer @HI),A (Track Number start),Y (Last Track to Read)
1D00:8E 60 1D    STX $1D60		; Buffer @HI
1D03:8D 5B 1D    STA $1D5B		; Track start
1D06:8C 6D 1D    STY $1D6D		; Last Track to read
1D09:20 71 1D    JSR $1D71		; Sauvegarde page 0 dans $1f00 et $1c00 dans page 0 (on va utiliser RWTS on remets la page avant le jeu)
1D0C:A9 0F       LDA #$0F		
1D0E:8D 5C 1D    STA $1D5C		; Sector start
1D11:AD F7 B7    LDA $B7F7		; Dernier slot utilisé par le DOS (RWTS)
1D14:8D 58 1D    STA $1D58		; On applique ce dernier slot utilisé
1D17:8D 66 1D    STA $1D66		
1D1A:AD F8 B7    LDA $B7F8		; Dernier drive utilisé par le DOS
1D1D:8D 59 1D    STA $1D59		; On l'applique ce dernier drive
1D20:8D 67 1D    STA $1D67
1D23:A9 00       LDA #$00		;>>
1D25:8D 64 1D    STA $1D64		; Code retour positionné à 0
1D28:A0 57       LDY #$57
1D2A:A9 1D       LDA #$1D
1D2C:20 B5 B7    JSR $B7B5		; Lecture DISK (table $1D57: Track=($1D5B), BufferHI=($1D60))
1D2F:EE 60 1D    INC $1D60
1D32:CE 5C 1D    DEC $1D5C		; On décrémente le sector en cours
1D35:10 08       BPL $1D3F		; Si Postif (N=0/<>"#FF")>↓>
1D37:A9 0F       LDA #$0F
1D39:8D 5C 1D    STA $1D5C
1D3C:EE 5B 1D    INC $1D5B
1D3F:AD 5B 1D    LDA $1D5B		;>> Charge le Track en cours (incrémenté ou non si fin de lecture des secteurs)
1D42:CD 6D 1D    CMP $1D6D		; Comparaison avec le Track final à lire
1D45:90 DC       BCC $1D23		; Si < on continue de lire les secteurs
1D47:F0 02       BEQ $1D4B		; Si = cas du dernier track à lire >↓>
1D49:B0 08       BCS $1D53		; Si > arrive au moment du dernier track lu >> on sort
1D4B:AD 5C 1D    LDA $1D5C		; >> Cas dernier track à lire: Charge le secteur en lecture
1D4E:CD 6C 1D    CMP $1D6C		; Dernier secteur à lire pour ce dernier track
1D51:B0 D0       BCS $1D23		; >= On continue de lire tant que le secteur de fin ($1D6C) n'a pas été lu.
1D53:20 6E 1D    JSR $1D6E	    ; Sauvegarde page 0 dans $1c00 et $1f00 dans page 0
1D56:60          RTS
; Table IOB
1D57:01 60       ORA ($60,X)		; unused, Slot 6
1D59:01 00       ORA ($00,X)		; Drive 1, tout type de volume 00
1D5B:0E 0F 68    ASL $680F			; Track number ($1D5B), Sector number ($1D5C), DCT
1D5E:1D 00 60    ORA $6000,X		; DCT, Buffer $(1D5F)
1D61:00          BRK
1D62:00          BRK
1D63:01 B3       ORA ($B3,X)		; Commande DOS READ, ERROR retour
1D65:FE 60 01    INC $0160,X		; Dernier Volume, slot, drive
;
1D68:00          BRK
1D69:01 EF       ORA ($EF,X)
1D6B:D8          CLD
1D6C:00 0D       BRK					; 
1D6E:6C 0A 13    JMP ($130A) =>65C6
1D71:6C 0C 13    JMP ($130C) =>65D8
1D74:3C                   ???
1D75:D4                   ???
1D76:F2                   ???
1D77:D4                   ???
1D78:06 A5       ASL $A5
1D7A:06 A5       ASL $A5
1D7C:67                   ???
1D7D:10 84       BPL $1D03
1D7F:9D 3C 0C    STA $0C3C,X
1D82:F2                   ???
1D83:0C                   ???


;
;===============================================================================================================
; Semble être une copie du début du DOS coldstart ENTRY $9D84 (ici $1D84) jusque $20FF (Chargement depuis BOOT)
; Bizaremment le copie (exacte du DOS) est interrompu en plein milieux
; Je pense que le but était de récupérer le code de la routine RWTS et qu'il on pris plus de code ?
; On remarque que les JMP de ce code copié utilise les JMP du code originel en $9D84...
;================================================================================================================
1D84:AD E9 B7    LDA $B7E9		; Slot number from RWTS parlist
1D87:4A          LSR
1D88:4A          LSR
1D89:4A          LSR
1D8A:4A          LSR				; On rècupére #6 pour #$60
1D8B:8D 6A AA    STA $AA6A		; On stocke le slot pour une commande DOS
1D8E:AD EA B7    LDA $B7EA		; Drive number from RWTS parlist		
1D91:8D 68 AA    STA $AA68		; On stocke le DRIVE pour une commande DOS
1D94:AD 00 E0    LDA $E000		; If a LANGUAGE CARD is present, DOS stores a zero on it at $E000 during \
										;   bootstrap to force the HELLO program on master diskette to reload BASIC
1D97:49 20       EOR #$20
1D99:D0 11       BNE $1DAC		; Pas de carte language? >>
1D9B:8D B6 AA    STA $AAB6
1D9E:A2 0A       LDX #$0A		
1DA0:BD 61 9D    LDA $9D61,X	; Récupére $9D6B=>$9D62: Image of entry point vector for Integer Basic
1DA3:9D 55 9D    STA $9D55,X	; This image $9D62=>$9D6B is copied to 9D56 if INTEGER BASIC is made active
1DA6:CA          DEX				; $9D56-$9D61: Active BASIC entry point vector table. The addresses stored her e\
1DA7:D0 F7       BNE $1DA0		;	are maintained by DOS such that they apply to current version of BASIC running
1DA9:4C BC 9D    JMP $9DBC		; Normalement ENTRY point du BASIC est $9D84
1DAC:A9 40       LDA #$40		>>
1DAE:8D B6 AA    STA $AAB6
1DB1:A2 0C       LDX #$0C
1DB3:BD 6B 9D    LDA $9D6B,X
1DB6:9D 55 9D    STA $9D55,X
1DB9:CA          DEX
1DBA:D0 F7       BNE $1DB3
1DBC:38          SEC
1DBD:B0 12       BCS $1DD1
1DBF:AD B6 AA    LDA $AAB6
1DC2:D0 04       BNE $1DC8
1DC4:A9 20       LDA #$20
1DC6:D0 05       BNE $1DCD
1DC8:0A          ASL
1DC9:10 05       BPL $1DD0
1DCB:A9 4C       LDA #$4C
1DCD:20 B2 A5    JSR $A5B2
1DD0:18          CLC
1DD1:08          PHP
1DD2:20 51 A8    JSR $A851
1DD5:A9 00       LDA #$00
1DD7:8D 5E AA    STA $AA5E
1DDA:8D 52 AA    STA $AA52
1DDD:28          PLP
1DDE:6A          ROR
1DDF:8D 51 AA    STA $AA51
1DE2:30 03       BMI $1DE7
1DE4:6C 5E 9D    JMP ($9D5E)
1DE7:6C 5C 9D    JMP ($9D5C)
1DEA:0A          ASL
1DEB:10 19       BPL $1E06
1DED:8D B6 AA    STA $AAB6
1DF0:A2 0C       LDX #$0C
1DF2:BD 77 9D    LDA $9D77,X
1DF5:9D 55 9D    STA $9D55,X
1DF8:CA          DEX
1DF9:D0 F7       BNE $1DF2
1DFB:A2 1D       LDX #$1D
1DFD:BD 93 AA    LDA $AA93,X
1E00:9D 75 AA    STA $AA75,X
1E03:CA          DEX
1E04:10 F7       BPL $1DFD
1E06:AD B1 AA    LDA $AAB1
1E09:8D 57 AA    STA $AA57
1E0C:20 D4 A7    JSR $A7D4
1E0F:AD B3 AA    LDA $AAB3
1E12:F0 09       BEQ $1E1D
1E14:48          PHA
1E15:20 9D A6    JSR $A69D
1E18:68          PLA
1E19:A0 00       LDY #$00
1E1B:91 40       STA ($40),Y
1E1D:20 5B A7    JSR $A75B
1E20:AD 5F AA    LDA $AA5F
1E23:D0 20       BNE $1E45
1E25:A2 2F       LDX #$2F
1E27:BD 51 9E    LDA $9E51,X
1E2A:9D D0 03    STA $03D0,X
1E2D:CA          DEX
1E2E:10 F7       BPL $1E27
1E30:AD 53 9E    LDA $9E53
1E33:8D F3 03    STA $03F3
1E36:49 A5       EOR #$A5
1E38:8D F4 03    STA $03F4
1E3B:AD 52 9E    LDA $9E52
1E3E:8D F2 03    STA $03F2
1E41:A9 06       LDA #$06
1E43:D0 05       BNE $1E4A
1E45:AD 62 AA    LDA $AA62
1E48:F0 06       BEQ $1E50
1E4A:8D 5F AA    STA $AA5F
1E4D:4C 80 A1    JMP $A180
1E50:60          RTS
1E51:4C BF 9D    JMP $9DBF
1E54:4C 84 9D    JMP $9D84
1E57:4C FD AA    JMP $AAFD
1E5A:4C B5 B7    JMP $B7B5
1E5D:AD 0F 9D    LDA $9D0F
1E60:AC 0E 9D    LDY $9D0E
1E63:60          RTS
1E64:AD C2 AA    LDA $AAC2
1E67:AC C1 AA    LDY $AAC1
1E6A:60          RTS
1E6B:4C 51 A8    JMP $A851
1E6E:EA          NOP
1E6F:EA          NOP
1E70:4C 59 FA    JMP $FA59
1E73:4C 65 FF    JMP $FF65
1E76:4C 58 FF    JMP $FF58
1E79:4C 65 FF    JMP $FF65
1E7C:4C 65 FF    JMP $FF65
1E7F:65 FF       ADC $FF
1E81:20 D1 9E    JSR $9ED1
1E84:AD 51 AA    LDA $AA51
1E87:F0 15       BEQ $1E9E
1E89:48          PHA
1E8A:AD 5C AA    LDA $AA5C
1E8D:91 28       STA ($28),Y
1E8F:68          PLA
1E90:30 03       BMI $1E95
1E92:4C 26 A6    JMP $A626
1E95:20 EA 9D    JSR $9DEA
1E98:A4 24       LDY $24
1E9A:A9 60       LDA #$60
1E9C:91 28       STA ($28),Y
1E9E:AD B3 AA    LDA $AAB3
1EA1:F0 03       BEQ $1EA6
1EA3:20 82 A6    JSR $A682
1EA6:A9 03       LDA #$03
1EA8:8D 52 AA    STA $AA52
1EAB:20 BA 9F    JSR $9FBA
1EAE:20 BA 9E    JSR $9EBA
1EB1:8D 5C AA    STA $AA5C
1EB4:8E 5A AA    STX $AA5A
1EB7:4C B3 9F    JMP $9FB3
1EBA:6C 38 00    JMP ($0038)
1EBD:20 D1 9E    JSR $9ED1
1EC0:AD 52 AA    LDA $AA52
1EC3:0A          ASL
1EC4:AA          TAX
1EC5:BD 11 9D    LDA $9D11,X
1EC8:48          PHA
1EC9:BD 10 9D    LDA $9D10,X
1ECC:48          PHA
1ECD:AD 5C AA    LDA $AA5C
1ED0:60          RTS
1ED1:8D 5C AA    STA $AA5C
1ED4:8E 5A AA    STX $AA5A
1ED7:8C 5B AA    STY $AA5B
1EDA:BA          TSX
1EDB:E8          INX
1EDC:E8          INX
1EDD:8E 59 AA    STX $AA59
1EE0:A2 03       LDX #$03
1EE2:BD 53 AA    LDA $AA53,X
1EE5:95 36       STA $36,X
1EE7:CA          DEX
1EE8:10 F8       BPL $1EE2
1EEA:60          RTS
1EEB:AE B7 AA    LDX $AAB7
1EEE:F0 03       BEQ $1EF3
1EF0:4C 78 9F    JMP $9F78
1EF3:AE 51 AA    LDX $AA51
1EF6:F0 08       BEQ $1F00
1EF8:C9 BF       CMP #$BF
1EFA:F0 75       BEQ $1F71
1EFC:C5 33       CMP $33
1EFE:F0 27       BEQ $1F27
1F00:A2 02       LDX #$02
1F02:8E 52 AA    STX $AA52
1F05:CD B2 AA    CMP $AAB2
1F08:D0 19       BNE $1F23
1F0A:CA          DEX
1F0B:8E 52 AA    STX $AA52
1F0E:CA          DEX
1F0F:8E 5D AA    STX $AA5D
1F12:AE 5D AA    LDX $AA5D
1F15:9D 00 02    STA $0200, X
1F18:E8          INX
1F19:8E 5D AA    STX $AA5D
1F1C:C9 8D       CMP #$8D
1F1E:D0 75       BNE $1F95
1F20:4C CD 9F    JMP $9FCD
1F23:C9 8D       CMP #$8D
1F25:D0 7D       BNE $1FA4
1F27:A2 00       LDX #$00
1F29:8E 52 AA    STX $AA52
1F2C:4C A4 9F    JMP $9FA4
1F2F:A2 00       LDX #$00
1F31:8E 52 AA    STX $AA52
1F34:C9 8D       CMP #$8D
1F36:F0 07       BEQ $1F3F
1F38:AD B3 AA    LDA $AAB3
1F3B:F0 67       BEQ $1FA4
1F3D:D0 5E       BNE $1F9D
1F3F:48          PHA
1F40:38          SEC
1F41:AD B3 AA    LDA $AAB3
1F44:D0 03       BNE $1F49
1F46:20 5E A6    JSR $A65E
1F49:68          PLA
1F4A:90 EC       BCC $1F38
1F4C:AE 5A AA    LDX $AA5A
1F4F:4C 15 9F    JMP $9F15
1F52:C9 8D       CMP #$8D
1F54:D0 05       BNE $1F5B
1F56:A9 05       LDA #$05
1F58:8D 52 AA    STA $AA52
1F5B:20 0E A6    JSR $A60E
1F5E:4C 99 9F    JMP $9F99
1F61:CD B2 AA    CMP $AAB2
1F64:F0 85       BEQ $1EEB
1F66:C9 8A       CMP #$8A
1F68:F0 F1       BEQ $1F5B
1F6A:A2 04       LDX #$04
1F6C:8E 52 AA    STX $AA52
1F6F:D0 E1       BNE $1F52
1F71:A9 00       LDA #$00
1F73:8D 52 AA    STA $AA52
1F76:F0 25       BEQ $1F9D
1F78:A9 00       LDA #$00
1F7A:8D B7 AA    STA $AAB7
1F7D:20 51 A8    JSR $A851
1F80:4C DC A4    JMP $A4DC
1F83:AD 00 02    LDA $0200
1F86:CD B2 AA    CMP $AAB2
1F89:F0 0A       BEQ $1F95
1F8B:A9 8D       LDA #$8D
1F8D:8D 00 02    STA $0200
1F90:A2 00       LDX #$00
1F92:8E 5A AA    STX $AA5A
1F95:A9 40       LDA #$40
1F97:D0 06       BNE $1F9F
1F99:A9 10       LDA #$10
1F9B:D0 02       BNE $1F9F
1F9D:A9 20       LDA #$20
1F9F:2D 5E AA    AND $AA5E
1FA2:F0 0F       BEQ $1FB3
1FA4:20 BA 9F    JSR $9FBA
1FA7:20 C5 9F    JSR $9FC5
1FAA:8D 5C AA    STA $AA5C
1FAD:8C 5B AA    STY $AA5B
1FB0:8E 5A AA    STX $AA5A
1FB3:20 51 A8    JSR $A851
1FB6:AE 59 AA    LDX $AA59
1FB9:9A          TXS
1FBA:AD 5C AA    LDA $AA5C
1FBD:AC 5B AA    LDY $AA5B
1FC0:AE 5A AA    LDX $AA5A
1FC3:38          SEC
1FC4:60          RTS
1FC5:6C 36 00    JMP ($0036)
1FC8:A9 8D       LDA #$8D
1FCA:4C C5 9F    JMP $9FC5
1FCD:A0 FF       LDY #$FF
1FCF:8C 5F AA    STY $AA5F
1FD2:C8          INY
1FD3:8C 62 AA    STY $AA62
1FD6:EE 5F AA    INC $AA5F
1FD9:A2 00       LDX #$00
1FDB:08          PHP
1FDC:BD 00 02    LDA $0200, X
1FDF:CD B2 AA    CMP $AAB2
1FE2:D0 01       BNE $1FE5
1FE4:E8          INX
1FE5:8E 5D AA    STX $AA5D
1FE8:20 A4 A1    JSR $A1A4
1FEB:29 7F       AND #$7F
1FED:59 84 A8    EOR $A884, Y
1FF0:C8          INY
1FF1:0A          ASL A
1FF2:F0 02       BEQ $1FF6
1FF4:68          PLA
1FF5:08          PHP
1FF6:90 F0       BCC $1FE8
1FF8:28          PLP
1FF9:F0 20       BEQ $201B
1FFB:B9 84 A8    LDA $A884, Y
1FFE:D0 D6       BNE $1FD6
2000:AD 00 02    LDA $0200
2003:CD B2 AA    CMP $AAB2
2006:F0 03       BEQ $200B
2008:4C A4 9F    JMP $9FA4
200B:AD 01 02    LDA $0201
200E:C9 8D       CMP #$8D
2010:D0 06       BNE $2018
2012:20 5B A7    JSR $A75B
2015:4C 95 9F    JMP $9F95
2018:4C C4 A6    JMP $A6C4
201B:0E 5F AA    ASL $AA5F
201E:AC 5F AA    LDY $AA5F
2021:20 5E A6    JSR $A65E
2024:90 0C       BCC $2032
2026:A9 02       LDA #$02
2028:39 09 A9    AND $A909, Y
202B:F0 05       BEQ $2032
202D:A9 0F       LDA #$0F
202F:4C D2 A6    JMP $A6D2
2032:C0 06       CPY #$06
2034:D0 02       BNE $2038
2036:84 33       STY <PROMPT
2038:A9 20       LDA #$20
203A:39 09 A9    AND $A909, Y
203D:F0 61       BEQ $20A0
203F:20 95 A0    JSR $A095
2042:08          PHP
2043:20 A4 A1    JSR $A1A4
2046:F0 1E       BEQ $2066
2048:0A          ASL A
2049:90 05       BCC $2050
204B:30 03       BMI $2050
204D:4C 00 A0    JMP $A000
2050:6A          ROR A
2051:4C 59 A0    JMP $A059
2054:20 93 A1    JSR $A193
2057:F0 0D       BEQ $2066
2059:99 75 AA    STA $AA75, Y
205C:C8          INY
205D:C0 3C       CPY #$3C
205F:90 F3       BCC $2054
2061:20 93 A1    JSR $A193
2064:D0 FB       BNE $2061
2066:28          PLP
2067:D0 0F       BNE $2078
2069:AC 5F AA    LDY $AA5F
206C:A9 10       LDA #$10
206E:39 09 A9    AND $A909, Y
2071:F0 0C       BEQ $207F
2073:A0 1E       LDY #$1E
2075:08          PHP
2076:D0 CB       BNE $2043
2078:AD 93 AA    LDA $AA93
207B:C9 A0       CMP #$A0
207D:F0 13       BEQ $2092
207F:AD 75 AA    LDA $AA75
2082:C9 A0       CMP #$A0
2084:D0 4B       BNE $20D1
2086:AC 5F AA    LDY $AA5F
2089:A9 C0       LDA #$C0
208B:39 09 A9    AND $A909, Y
208E:F0 02       BEQ $2092
2090:10 3F       BPL $20D1
2092:4C 00 A0    JMP $A000
2095:A0 3C       LDY #$3C
2097:A9 A0       LDA #$A0
2099:99 74 AA    STA $AA74, Y
209C:88          DEY
209D:D0 FA       BNE $2099
209F:60          RTS
20A0:8D 75 AA    STA $AA75
20A3:A9 0C       LDA #$0C
20A5:39 09 A9    AND $A909, Y
20A8:F0 27       BEQ $20D1
20AA:20 B9 A1    JSR $A1B9
20AD:B0 1F       BCS $20CE
20AF:A8          TAY
20B0:D0 17       BNE $20C9
20B2:E0 11       CPX #$11
20B4:B0 13       BCS $20C9
20B6:AC 5F AA    LDY $AA5F
20B9:A9 08       LDA #$08
20BB:39 09 A9    AND $A909, Y
20BE:F0 06       BEQ $20C6
20C0:E0 08       CPX #$08
20C2:B0 CE       BCS $2092
20C4:90 0B       BCC $20D1
20C6:8A          TXA
20C7:D0 08       BNE $20D1
20C9:A9 02       LDA #$02
20CB:4C D2 A6    JMP $A6D2
20CE:4C C4 A6    JMP $A6C4
20D1:A9 00       LDA #$00
20D3:8D 65 AA    STA $AA65
20D6:8D 74 AA    STA $AA74
20D9:8D 66 AA    STA $AA66
20DC:8D 6C AA    STA $AA6C
20DF:8D 6D AA    STA $AA6D
20E2:20 DC BF    JSR $BFDC
20E5:AD 5D AA    LDA $AA5D
20E8:20 A4 A1    JSR $A1A4
20EB:D0 1F       BNE $210C
20ED:C9 8D       CMP #$8D
20EF:D0 F7       BNE $20E8
20F1:AE 5F AA    LDX $AA5F
20F4:AD 65 AA    LDA $AA65
20F7:1D 0A A9    ORA $A90A, X
20FA:5D 0A A9    EOR $A90A, X
20FD:D0 93       BNE $2092
20FF:AE 00 FF    LDX $FF00


;
; ###########################
;      MAIN2 $6000=>78FF  
; ###########################
; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
6000:B9 0E 60    LDA $600E,Y	; Utilise la table en $600E (192 lignes) le poids faible $4C d'adressage HGR
6003:85 4C       STA $4C
6005:B9 CE 60    LDA $60CE,Y	; Utilise la table en $60CE 
6008:18          CLC
6009:65 E6       ADC $E6
600B:85 4D       STA $4D
600D:60          RTS
; Table mémoire des 192 lignes HIRES poids faible
600E:00          BRK
600F:00          BRK
6010:00          BRK
6011:00          BRK
6012:00          BRK
6013:00          BRK
6014:00          BRK
6015:00          BRK
6016:80                   ???
6017:80                   ???
6018:80                   ???
6019:80                   ???
601A:80                   ???
601B:80                   ???
601C:80                   ???
601D:80                   ???
601E:00          BRK
601F:00          BRK
6020:00          BRK
6021:00          BRK
6022:00          BRK
6023:00          BRK
6024:00          BRK
6025:00          BRK
6026:80                   ???
6027:80                   ???
6028:80                   ???
6029:80                   ???
602A:80                   ???
602B:80                   ???
602C:80                   ???
602D:80                   ???
602E:00          BRK
602F:00          BRK
6030:00          BRK
6031:00          BRK
6032:00          BRK
6033:00          BRK
6034:00          BRK
6035:00          BRK
6036:80                   ???
6037:80                   ???
6038:80                   ???
6039:80                   ???
603A:80                   ???
603B:80                   ???
603C:80                   ???
603D:80                   ???
603E:00          BRK
603F:00          BRK
6040:00          BRK
6041:00          BRK
6042:00          BRK
6043:00          BRK
6044:00          BRK
6045:00          BRK
6046:80                   ???
6047:80                   ???
6048:80                   ???
6049:80                   ???
604A:80                   ???
604B:80                   ???
604C:80                   ???
604D:80                   ???
604E:28          PLP
604F:28          PLP
6050:28          PLP
6051:28          PLP
6052:28          PLP
6053:28          PLP
6054:28          PLP
6055:28          PLP
6056:A8          TAY
6057:A8          TAY
6058:A8          TAY
6059:A8          TAY
605A:A8          TAY
605B:A8          TAY
605C:A8          TAY
605D:A8          TAY
605E:28          PLP
605F:28          PLP
6060:28          PLP
6061:28          PLP
6062:28          PLP
6063:28          PLP
6064:28          PLP
6065:28          PLP
6066:A8          TAY
6067:A8          TAY
6068:A8          TAY
6069:A8          TAY
606A:A8          TAY
606B:A8          TAY
606C:A8          TAY
606D:A8          TAY
606E:28          PLP
606F:28          PLP
6070:28          PLP
6071:28          PLP
6072:28          PLP
6073:28          PLP
6074:28          PLP
6075:28          PLP
6076:A8          TAY
6077:A8          TAY
6078:A8          TAY
6079:A8          TAY
607A:A8          TAY
607B:A8          TAY
607C:A8          TAY
607D:A8          TAY
607E:28          PLP
607F:28          PLP
6080:28          PLP
6081:28          PLP
6082:28          PLP
6083:28          PLP
6084:28          PLP
6085:28          PLP
6086:A8          TAY
6087:A8          TAY
6088:A8          TAY
6089:A8          TAY
608A:A8          TAY
608B:A8          TAY
608C:A8          TAY
608D:A8          TAY
608E:50 50       BVC $60E0
6090:50 50       BVC $60E2
6092:50 50       BVC $60E4
6094:50 50       BVC $60E6
6096:D0 D0       BNE $6068
6098:D0 D0       BNE $606A
609A:D0 D0       BNE $606C
609C:D0 D0       BNE $606E
609E:50 50       BVC $60F0
60A0:50 50       BVC $60F2
60A2:50 50       BVC $60F4
60A4:50 50       BVC $60F6
60A6:D0 D0       BNE $6078
60A8:D0 D0       BNE $607A
60AA:D0 D0       BNE $607C
60AC:D0 D0       BNE $607E
60AE:50 50       BVC $6100
60B0:50 50       BVC $6102
60B2:50 50       BVC $6104
60B4:50 50       BVC $6106
60B6:D0 D0       BNE $6088
60B8:D0 D0       BNE $608A
60BA:D0 D0       BNE $608C
60BC:D0 D0       BNE $608E
60BE:50 50       BVC $6110
60C0:50 50       BVC $6112
60C2:50 50       BVC $6114
60C4:50 50       BVC $6116
60C6:D0 D0       BNE $6098
60C8:D0 D0       BNE $609A
60CA:D0 D0       BNE $609C
60CC:D0 D0       BNE $609E
; Table mémoire des 192 lignes HIRES poids fort
60CE:00          BRK
60CF:04                   ???
60D0:08          PHP
60D1:0C                   ???
60D2:10 14       BPL $60E8
60D4:18          CLC
60D5:1C                   ???
60D6:00          BRK
60D7:04                   ???
60D8:08          PHP
60D9:0C                   ???
60DA:10 14       BPL $60F0
60DC:18          CLC
60DD:1C                   ???
60DE:01 05       ORA ($05,X)
60E0:09 0D       ORA #$0D
60E2:11 15       ORA ($15),Y
60E4:19 1D 01    ORA $011D,Y
60E7:05 09       ORA $09
60E9:0D 11 15    ORA $1511
60EC:19 1D 02    ORA $021D,Y
60EF:06 0A       ASL $0A
60F1:0E 12 16    ASL $1612
60F4:1A                   ???
60F5:1E 02 06    ASL $0602,X
60F8:0A          ASL
60F9:0E 12 16    ASL $1612
60FC:1A                   ???
60FD:1E 03 07    ASL $0703,X
6100:0B                   ???
6101:0F                   ???
6102:13                   ???
6103:17                   ???
6104:1B                   ???
6105:1F                   ???
6106:03                   ???
6107:07                   ???
6108:0B                   ???
6109:0F                   ???
610A:13                   ???
610B:17                   ???
610C:1B                   ???
610D:1F                   ???
610E:00          BRK
610F:04                   ???
6110:08          PHP
6111:0C                   ???
6112:10 14       BPL $6128
6114:18          CLC
6115:1C                   ???
6116:00          BRK
6117:04                   ???
6118:08          PHP
6119:0C                   ???
611A:10 14       BPL $6130
611C:18          CLC
611D:1C                   ???
611E:01 05       ORA ($05,X)
6120:09 0D       ORA #$0D
6122:11 15       ORA ($15),Y
6124:19 1D 01    ORA $011D,Y
6127:05 09       ORA $09
6129:0D 11 15    ORA $1511
612C:19 1D 02    ORA $021D,Y
612F:06 0A       ASL $0A
6131:0E 12 16    ASL $1612
6134:1A                   ???
6135:1E 02 06    ASL $0602,X
6138:0A          ASL
6139:0E 12 16    ASL $1612
613C:1A                   ???
613D:1E 03 07    ASL $0703,X
6140:0B                   ???
6141:0F                   ???
6142:13                   ???
6143:17                   ???
6144:1B                   ???
6145:1F                   ???
6146:03                   ???
6147:07                   ???
6148:0B                   ???
6149:0F                   ???
614A:13                   ???
614B:17                   ???
614C:1B                   ???
614D:1F                   ???
614E:00          BRK
614F:04                   ???
6150:08          PHP
6151:0C                   ???
6152:10 14       BPL $6168
6154:18          CLC
6155:1C                   ???
6156:00          BRK
6157:04                   ???
6158:08          PHP
6159:0C                   ???
615A:10 14       BPL $6170
615C:18          CLC
615D:1C                   ???
615E:01 05       ORA ($05,X)
6160:09 0D       ORA #$0D
6162:11 15       ORA ($15),Y
6164:19 1D 01    ORA $011D,Y
6167:05 09       ORA $09
6169:0D 11 15    ORA $1511
616C:19 1D 02    ORA $021D,Y
616F:06 0A       ASL $0A
6171:0E 12 16    ASL $1612
6174:1A                   ???
6175:1E 02 06    ASL $0602,X
6178:0A          ASL
6179:0E 12 16    ASL $1612
617C:1A                   ???
617D:1E 03 07    ASL $0703,X
6180:0B                   ???
6181:0F                   ???
6182:13                   ???
6183:17                   ???
6184:1B                   ???
6185:1F                   ???
6186:03                   ???
6187:07                   ???
6188:0B                   ???
6189:0F                   ???
618A:13                   ???
618B:17                   ???
618C:1B                   ???
618D:1F                   ???
618E:BD 99 61    LDA $6199,X
6191:85 E5       STA $E5
6193:BD B1 62    LDA $62B1,X
6196:85 29       STA $29
6198:60          RTS
6199:00          BRK
619A:00          BRK
619B:00          BRK
619C:00          BRK
619D:00          BRK
619E:00          BRK
619F:00          BRK
61A0:01 01       ORA ($01,X)
61A2:01 01       ORA ($01,X)
61A4:01 01       ORA ($01,X)
61A6:01 02       ORA ($02,X)
61A8:02                   ???
61A9:02                   ???
61AA:02                   ???
61AB:02                   ???
61AC:02                   ???
61AD:02                   ???
61AE:03                   ???
61AF:03                   ???
61B0:03                   ???
61B1:03                   ???
61B2:03                   ???
61B3:03                   ???
61B4:03                   ???
61B5:04                   ???
61B6:04                   ???
61B7:04                   ???
61B8:04                   ???
61B9:04                   ???
61BA:04                   ???
61BB:04                   ???
61BC:05 05       ORA $05
61BE:05 05       ORA $05
61C0:05 05       ORA $05
61C2:05 06       ORA $06
61C4:06 06       ASL $06
61C6:06 06       ASL $06
61C8:06 06       ASL $06
61CA:07                   ???
61CB:07                   ???
61CC:07                   ???
61CD:07                   ???
61CE:07                   ???
61CF:07                   ???
61D0:07                   ???
61D1:08          PHP
61D2:08          PHP
61D3:08          PHP
61D4:08          PHP
61D5:08          PHP
61D6:08          PHP
61D7:08          PHP
61D8:09 09       ORA #$09
61DA:09 09       ORA #$09
61DC:09 09       ORA #$09
61DE:09 0A       ORA #$0A
61E0:0A          ASL
61E1:0A          ASL
61E2:0A          ASL
61E3:0A          ASL
61E4:0A          ASL
61E5:0A          ASL
61E6:0B                   ???
61E7:0B                   ???
61E8:0B                   ???
61E9:0B                   ???
61EA:0B                   ???
61EB:0B                   ???
61EC:0B                   ???
61ED:0C                   ???
61EE:0C                   ???
61EF:0C                   ???
61F0:0C                   ???
61F1:0C                   ???
61F2:0C                   ???
61F3:0C                   ???
61F4:0D 0D 0D    ORA $0D0D
61F7:0D 0D 0D    ORA $0D0D
61FA:0D 0E 0E    ORA $0E0E
61FD:0E 0E 0E    ASL $0E0E
6200:0E 0E 0F    ASL $0F0E
6203:0F                   ???
6204:0F                   ???
6205:0F                   ???
6206:0F                   ???
6207:0F                   ???
6208:0F                   ???
6209:10 10       BPL $621B
620B:10 10       BPL $621D
620D:10 10       BPL $621F
620F:10 11       BPL $6222
6211:11 11       ORA ($11),Y
6213:11 11       ORA ($11),Y
6215:11 11       ORA ($11),Y
6217:12                   ???
6218:12                   ???
6219:12                   ???
621A:12                   ???
621B:12                   ???
621C:12                   ???
621D:12                   ???
621E:13                   ???
621F:13                   ???
6220:13                   ???
6221:13                   ???
6222:13                   ???
6223:13                   ???
6224:13                   ???
6225:14                   ???
6226:14                   ???
6227:14                   ???
6228:14                   ???
6229:14                   ???
622A:14                   ???
622B:14                   ???
622C:15 15       ORA $15,X
622E:15 15       ORA $15,X
6230:15 15       ORA $15,X
6232:15 16       ORA $16,X
6234:16 16       ASL $16,X
6236:16 16       ASL $16,X
6238:16 16       ASL $16,X
623A:17                   ???
623B:17                   ???
623C:17                   ???
623D:17                   ???
623E:17                   ???
623F:17                   ???
6240:17                   ???
6241:18          CLC
6242:18          CLC
6243:18          CLC
6244:18          CLC
6245:18          CLC
6246:18          CLC
6247:18          CLC
6248:19 19 19    ORA $1919,Y
624B:19 19 19    ORA $1919,Y
624E:19 1A 1A    ORA $1A1A,Y
6251:1A                   ???
6252:1A                   ???
6253:1A                   ???
6254:1A                   ???
6255:1A                   ???
6256:1B                   ???
6257:1B                   ???
6258:1B                   ???
6259:1B                   ???
625A:1B                   ???
625B:1B                   ???
625C:1B                   ???
625D:1C                   ???
625E:1C                   ???
625F:1C                   ???
6260:1C                   ???
6261:1C                   ???
6262:1C                   ???
6263:1C                   ???
6264:1D 1D 1D    ORA $1D1D,X
6267:1D 1D 1D    ORA $1D1D,X
626A:1D 1E 1E    ORA $1E1E,X
626D:1E 1E 1E    ASL $1E1E,X
6270:1E 1E 1F    ASL $1F1E,X
6273:1F                   ???
6274:1F                   ???
6275:1F                   ???
6276:1F                   ???
6277:1F                   ???
6278:1F                   ???
6279:20 20 20    JSR $2020
627C:20 20 20    JSR $2020
627F:20 21 21    JSR $2121
6282:21 21       AND ($21,X)
6284:21 21       AND ($21,X)
6286:21 22       AND ($22,X)
6288:22                   ???
6289:22                   ???
628A:22                   ???
628B:22                   ???
628C:22                   ???
628D:22                   ???
628E:23                   ???
628F:23                   ???
6290:23                   ???
6291:23                   ???
6292:23                   ???
6293:23                   ???
6294:23                   ???
6295:24 24       BIT $24
6297:24 24       BIT $24
6299:24 24       BIT $24
629B:24 25       BIT $25
629D:25 25       AND $25
629F:25 25       AND $25
62A1:25 25       AND $25
62A3:26 26       ROL $26
62A5:26 26       ROL $26
62A7:26 26       ROL $26
62A9:26 27       ROL $27
62AB:27                   ???
62AC:27                   ???
62AD:27                   ???
62AE:27                   ???
62AF:27                   ???
62B0:27                   ???
62B1:00          BRK
62B2:01 02       ORA ($02,X)
62B4:03                   ???
62B5:04                   ???
62B6:05 06       ORA $06
62B8:07                   ???
62B9:08          PHP
62BA:09 0A       ORA #$0A
62BC:0B                   ???
62BD:0C                   ???
62BE:0D 00 01    ORA $0100
62C1:02                   ???
62C2:03                   ???
62C3:04                   ???
62C4:05 06       ORA $06
62C6:07                   ???
62C7:08          PHP
62C8:09 0A       ORA #$0A
62CA:0B                   ???
62CB:0C                   ???
62CC:0D 00 01    ORA $0100
62CF:02                   ???
62D0:03                   ???
62D1:04                   ???
62D2:05 06       ORA $06
62D4:07                   ???
62D5:08          PHP
62D6:09 0A       ORA #$0A
62D8:0B                   ???
62D9:0C                   ???
62DA:0D 00 01    ORA $0100
62DD:02                   ???
62DE:03                   ???
62DF:04                   ???
62E0:05 06       ORA $06
62E2:07                   ???
62E3:08          PHP
62E4:09 0A       ORA #$0A
62E6:0B                   ???
62E7:0C                   ???
62E8:0D 00 01    ORA $0100
62EB:02                   ???
62EC:03                   ???
62ED:04                   ???
62EE:05 06       ORA $06
62F0:07                   ???
62F1:08          PHP
62F2:09 0A       ORA #$0A
62F4:0B                   ???
62F5:0C                   ???
62F6:0D 00 01    ORA $0100
62F9:02                   ???
62FA:03                   ???
62FB:04                   ???
62FC:05 06       ORA $06
62FE:07                   ???
62FF:08          PHP
6300:09 0A       ORA #$0A
6302:0B                   ???
6303:0C                   ???
6304:0D 00 01    ORA $0100
6307:02                   ???
6308:03                   ???
6309:04                   ???
630A:05 06       ORA $06
630C:07                   ???
630D:08          PHP
630E:09 0A       ORA #$0A
6310:0B                   ???
6311:0C                   ???
6312:0D 00 01    ORA $0100
6315:02                   ???
6316:03                   ???
6317:04                   ???
6318:05 06       ORA $06
631A:07                   ???
631B:08          PHP
631C:09 0A       ORA #$0A
631E:0B                   ???
631F:0C                   ???
6320:0D 00 01    ORA $0100
6323:02                   ???
6324:03                   ???
6325:04                   ???
6326:05 06       ORA $06
6328:07                   ???
6329:08          PHP
632A:09 0A       ORA #$0A
632C:0B                   ???
632D:0C                   ???
632E:0D 00 01    ORA $0100
6331:02                   ???
6332:03                   ???
6333:04                   ???
6334:05 06       ORA $06
6336:07                   ???
6337:08          PHP
6338:09 0A       ORA #$0A
633A:0B                   ???
633B:0C                   ???
633C:0D 00 01    ORA $0100
633F:02                   ???
6340:03                   ???
6341:04                   ???
6342:05 06       ORA $06
6344:07                   ???
6345:08          PHP
6346:09 0A       ORA #$0A
6348:0B                   ???
6349:0C                   ???
634A:0D 00 01    ORA $0100
634D:02                   ???
634E:03                   ???
634F:04                   ???
6350:05 06       ORA $06
6352:07                   ???
6353:08          PHP
6354:09 0A       ORA #$0A
6356:0B                   ???
6357:0C                   ???
6358:0D 00 01    ORA $0100
635B:02                   ???
635C:03                   ???
635D:04                   ???
635E:05 06       ORA $06
6360:07                   ???
6361:08          PHP
6362:09 0A       ORA #$0A
6364:0B                   ???
6365:0C                   ???
6366:0D 00 01    ORA $0100
6369:02                   ???
636A:03                   ???
636B:04                   ???
636C:05 06       ORA $06
636E:07                   ???
636F:08          PHP
6370:09 0A       ORA #$0A
6372:0B                   ???
6373:0C                   ???
6374:0D 00 01    ORA $0100
6377:02                   ???
6378:03                   ???
6379:04                   ???
637A:05 06       ORA $06
637C:07                   ???
637D:08          PHP
637E:09 0A       ORA #$0A
6380:0B                   ???
6381:0C                   ???
6382:0D 00 01    ORA $0100
6385:02                   ???
6386:03                   ???
6387:04                   ???
6388:05 06       ORA $06
638A:07                   ???
638B:08          PHP
638C:09 0A       ORA #$0A
638E:0B                   ???
638F:0C                   ???
6390:0D 00 01    ORA $0100
6393:02                   ???
6394:03                   ???
6395:04                   ???
6396:05 06       ORA $06
6398:07                   ???
6399:08          PHP
639A:09 0A       ORA #$0A
639C:0B                   ???
639D:0C                   ???
639E:0D 00 01    ORA $0100
63A1:02                   ???
63A2:03                   ???
63A3:04                   ???
63A4:05 06       ORA $06
63A6:07                   ???
63A7:08          PHP
63A8:09 0A       ORA #$0A
63AA:0B                   ???
63AB:0C                   ???
63AC:0D 00 01    ORA $0100
63AF:02                   ???
63B0:03                   ???
63B1:04                   ???
63B2:05 06       ORA $06
63B4:07                   ???
63B5:08          PHP
63B6:09 0A       ORA #$0A
63B8:0B                   ???
63B9:0C                   ???
63BA:0D 00 01    ORA $0100
63BD:02                   ???
63BE:03                   ???
63BF:04                   ???
63C0:05 06       ORA $06
63C2:07                   ???
63C3:08          PHP
63C4:09 0A       ORA #$0A
63C6:0B                   ???
63C7:0C                   ???
63C8:0D BD D4    ORA $D4BD
63CB:63                   ???
63CC:85 E5       STA $E5
63CE:BD B1 62    LDA $62B1,X
63D1:85 29       STA $29
63D3:60          RTS
63D4:00          BRK
63D5:00          BRK
63D6:00          BRK
63D7:00          BRK
63D8:00          BRK
63D9:00          BRK
63DA:00          BRK
63DB:00          BRK
63DC:01 01       ORA ($01,X)
63DE:01 01       ORA ($01,X)
63E0:01 01       ORA ($01,X)
63E2:02                   ???
63E3:02                   ???
63E4:02                   ???
63E5:02                   ???
63E6:02                   ???
63E7:02                   ???
63E8:02                   ???
63E9:02                   ???
63EA:03                   ???
63EB:03                   ???
63EC:03                   ???
63ED:03                   ???
63EE:03                   ???
63EF:03                   ???
63F0:04                   ???
63F1:04                   ???
63F2:04                   ???
63F3:04                   ???
63F4:04                   ???
63F5:04                   ???
63F6:04                   ???
63F7:04                   ???
63F8:05 05       ORA $05
63FA:05 05       ORA $05
63FC:05 05       ORA $05
63FE:06 06       ASL $06
6400:06 06       ASL $06
6402:06 06       ASL $06
6404:06 06       ASL $06
6406:07                   ???
6407:07                   ???
6408:07                   ???
6409:07                   ???
640A:07                   ???
640B:07                   ???
640C:08          PHP
640D:08          PHP
640E:08          PHP
640F:08          PHP
6410:08          PHP
6411:08          PHP
6412:08          PHP
6413:08          PHP
6414:09 09       ORA #$09
6416:09 09       ORA #$09
6418:09 09       ORA #$09
641A:0A          ASL
641B:0A          ASL
641C:0A          ASL
641D:0A          ASL
641E:0A          ASL
641F:0A          ASL
6420:0A          ASL
6421:0A          ASL
6422:0B                   ???
6423:0B                   ???
6424:0B                   ???
6425:0B                   ???
6426:0B                   ???
6427:0B                   ???
6428:0C                   ???
6429:0C                   ???
642A:0C                   ???
642B:0C                   ???
642C:0C                   ???
642D:0C                   ???
642E:0C                   ???
642F:0C                   ???
6430:0D 0D 0D    ORA $0D0D
6433:0D 0D 0D    ORA $0D0D
6436:0E 0E 0E    ASL $0E0E
6439:0E 0E 0E    ASL $0E0E
643C:0E 0E 0F    ASL $0F0E
643F:0F                   ???
6440:0F                   ???
6441:0F                   ???
6442:0F                   ???
6443:0F                   ???
6444:10 10       BPL $6456
6446:10 10       BPL $6458
6448:10 10       BPL $645A
644A:10 10       BPL $645C
644C:11 11       ORA ($11),Y
644E:11 11       ORA ($11),Y
6450:11 11       ORA ($11),Y
6452:12                   ???
6453:12                   ???
6454:12                   ???
6455:12                   ???
6456:12                   ???
6457:12                   ???
6458:12                   ???
6459:12                   ???
645A:13                   ???
645B:13                   ???
645C:13                   ???
645D:13                   ???
645E:13                   ???
645F:13                   ???
6460:14                   ???
6461:14                   ???
6462:14                   ???
6463:14                   ???
6464:14                   ???
6465:14                   ???
6466:14                   ???
6467:14                   ???
6468:15 15       ORA $15,X
646A:15 15       ORA $15,X
646C:15 15       ORA $15,X
646E:16 16       ASL $16,X
6470:16 16       ASL $16,X
6472:16 16       ASL $16,X
6474:16 16       ASL $16,X
6476:17                   ???
6477:17                   ???
6478:17                   ???
6479:17                   ???
647A:17                   ???
647B:17                   ???
647C:18          CLC
647D:18          CLC
647E:18          CLC
647F:18          CLC
6480:18          CLC
6481:18          CLC
6482:18          CLC
6483:18          CLC
6484:19 19 19    ORA $1919,Y
6487:19 19 19    ORA $1919,Y
648A:1A                   ???
648B:1A                   ???
648C:1A                   ???
648D:1A                   ???
648E:1A                   ???
648F:1A                   ???
6490:1A                   ???
6491:1A                   ???
6492:1B                   ???
6493:1B                   ???
6494:1B                   ???
6495:1B                   ???
6496:1B                   ???
6497:1B                   ???
6498:1C                   ???
6499:1C                   ???
649A:1C                   ???
649B:1C                   ???
649C:1C                   ???
649D:1C                   ???
649E:1C                   ???
649F:1C                   ???
64A0:1D 1D 1D    ORA $1D1D,X
64A3:1D 1D 1D    ORA $1D1D,X
64A6:1E 1E 1E    ASL $1E1E,X
64A9:1E 1E 1E    ASL $1E1E,X
64AC:1E 1E 1F    ASL $1F1E,X
64AF:1F                   ???
64B0:1F                   ???
64B1:1F                   ???
64B2:1F                   ???
64B3:1F                   ???
64B4:20 20 20    JSR $2020
64B7:20 20 20    JSR $2020
64BA:20 20 21    JSR $2120
64BD:21 21       AND ($21,X)
64BF:21 21       AND ($21,X)
64C1:21 22       AND ($22,X)
64C3:22                   ???
64C4:22                   ???
64C5:22                   ???
64C6:22                   ???
64C7:22                   ???
64C8:22                   ???
64C9:22                   ???
64CA:23                   ???
64CB:23                   ???
64CC:23                   ???
64CD:23                   ???
64CE:23                   ???
64CF:23                   ???
64D0:24 24       BIT $24
64D2:24 24       BIT $24
64D4:24 24       BIT $24
64D6:24 24       BIT $24
64D8:25 25       AND $25
64DA:25 25       AND $25
64DC:25 25       AND $25
64DE:26 26       ROL $26
64E0:26 26       ROL $26
64E2:26 26       ROL $26
64E4:26 26       ROL $26
64E6:27                   ???
64E7:27                   ???
64E8:27                   ???
64E9:27                   ???
64EA:27                   ???
64EB:27                   ???
; Gestion des registres $D4, $D5, $D6 et $D7 pour le mode JOYSTICK
64EC:A5 2A       LDA $2A		; Registre Options KEYBOARD ou JOYSTICK
64EE:F0 01       BEQ $64F1		; Branchement si JOYSTICK
64F0:60          RTS				; Retour si Clavier
64F1:A5 26       LDA $26		; Flag local $26 Paddle 0 et 1 alternativement
64F3:F0 21       BEQ $6516
64F5:A2 00       LDX #$00
64F7:86 26       STX $26
64F9:20 1E FB    JSR $FB1E		; Read Analog Paddle numéro 0 (X), valeur dans Y
64FC:98          TYA
64FD:C9 3C       CMP #$3C		; Branchement si supérieur ou égale à #60
64FF:B0 07       BCS $6508
6501:A9 FF       LDA #$FF
6503:85 D5       STA $D5		; $D5 registre horizontal (FF GAUCHE, 00 DROIT)		
6505:4C 37 65    JMP $6537
6508:C9 BE       CMP #$BE		; Branchement si supérieur ou égale à #190
650A:B0 05       BCS $6511
650C:A9 00       LDA #$00
650E:4C 03 65    JMP $6503
6511:A9 01       LDA #$01
6513:4C 03 65    JMP $6503
6516:A2 01       LDX #$01
6518:86 26       STX $26
651A:20 1E FB    JSR $FB1E		; Read Analog Paddle numéro 1 (X), valeur dans Y
651D:98          TYA
651E:C9 3C       CMP #$3C
6520:B0 07       BCS $6529		; Branchement si supérieur ou égale à #60
6522:A9 FF       LDA #$FF
6524:85 D4       STA $D4		; $D4 registre vertical (FF HAUT, 00 BAS)
6526:4C 37 65    JMP $6537
6529:C9 BE       CMP #$BE
652B:B0 05       BCS $6532		; Branchement si supérieur ou égale à #190
652D:A9 00       LDA #$00
652F:4C 24 65    JMP $6524
6532:A9 01       LDA #$01
6534:4C 24 65    JMP $6524
6537:A0 01       LDY #$01
6539:AD 61 C0    LDA $C061		;C061 49249	BUTN0	OECG	R7	Switch Input 0
653C:30 02       BMI $6540
653E:A0 00       LDY #$00
6540:84 D6       STY $D6		; Demande de saut =1 ou pas =0 (Bouton 0) 
6542:A0 01       LDY #$01
6544:AD 62 C0    LDA $C062		;C062 49250	BUTN1	OECG	R7	Switch Input 1
6547:30 02       BMI $654B
6549:A0 00       LDY #$00
654B:84 D7       STY $D7		; Registre Bouton 2 et timer 'couché' en mode KEYBOARD
654D:60          RTS
; Routine concernant la touche 'ESC' permettant de faire une pause et si pause longue un écran noir
654E:AD 00 C0    LDA $C000		; Load the ASCII code of the last key pressed into the accumulator
6551:10 70       BPL $65C3		; Branch to NO_KEY if no key was pressed (negative value)
6553:C9 9B       CMP #$9B		; "ESC" key? (PAUSE in GAME)
6555:D0 6C       BNE $65C3		; non => on sort
6557:A9 00       LDA #$00		; oui on traite la demande de PAUSE dans le jeu
6559:85 C4       STA $C4		; timer d'attente
655B:85 C5       STA $C5
655D:2C 10 C0    BIT $C010		; on efface la touche
6560:AD 00 C0    LDA $C000		; on charge une éventuelle touche
6563:30 27       BMI $658C		; oui nouvelle touche pressée
6565:E6 C4       INC $C4
6567:D0 07       BNE $6570
6569:E6 C5       INC $C5
656B:D0 03       BNE $6570		; Continue la boucle jusqu'à $C5=00 (255*255 cycles)
656D:4C 78 65    JMP $6578		; On a fait tous les cycles 255*255 sur $C4 et $C5
6570:A9 20       LDA #$20
6572:20 A8 FC    JSR $FCA8		
6575:4C 60 65    JMP $6560
6578:A9 A0       LDA #$A0		; On met le code <space> dans le registre $00
657A:85 00       STA $00
657C:20 0B 6B    JSR $6B0B		; Rempli la mémoire TEXT page 1 0x400-0x7FF de <space>
657F:A9 00       LDA #$00
6581:85 37       STA $37		; Flag de l'inialisation de la mémoire TEXT remis à zéro
6583:2C 54 C0    BIT $C054		;C054 49236	TXTPAGE1	OECG	WR	Display Page 1
6586:2C 51 C0    BIT $C051		;C051 49233	TXTSET	OECG	WR	Display Text
6589:4C 60 65    JMP $6560		; Et on recommence l'attente d'une touche 'ESC'
658C:C9 9B       CMP #$9B		; On teste si de nouveau on a appuyer sur 'ESC'
658E:F0 1A       BEQ $65AA		; Si oui on va réveiller le jeu
6590:C9 C9       CMP #$C9		; Si non on teste la touche 'I' => permet d'attendre à l'infini la prochaine touche cf plus bas
6592:D0 C9       BNE $655D		; Sinon on efface la touche via $C010 et retourne à notre boucle d'attente
6594:2C 10 C0    BIT $C010		; On efface la touche
6597:AD 00 C0    LDA $C000		; On recharge une touche pressée
659A:10 FB       BPL $6597		; Branchement si pas de touche pressée => on boucle à l'infini en attendant une touche pressée
659C:C9 CD       CMP #$CD		; Si 'M' on incrémente registre $36
659E:D0 BD       BNE $655D		; Autre touche que la touche 'M' => on boucle pour tester une touche 'ESC'
65A0:E6 36       INC $36		; Registre Flag qui permet de passer au niveau suivant (touche 'I' et 'M' en pause)
65A2:A9 C4       LDA #$C4
65A4:85 5A       STA $5A
65A6:A9 65       LDA #$65
65A8:85 5B       STA $5B		; Charge ($5A)=$65C4:FF FF
65AA:2C 10 C0    BIT $C010		;C010 49168	KBDSTRB	OECG	WR	Keyboard Strobe
65AD:2C 50 C0    BIT $C050		;C050 49232	TXTCLR	OECG	WR	Display Graphics
65B0:2C 52 C0    BIT $C052		;C052 49234	MIXCLR	OECG	WR	Display Full Screen
65B3:2C 57 C0    BIT $C057		;C057 49239	HIRES	OECG	WR	Display HiRes Graphics
65B6:A5 E6       LDA $E6		; On charge le registre $E6 flag pour savoir si on est sur la page 1 ou 2 du text ou hgr?
65B8:C9 20       CMP #$20		; si #$20 Text page 1
65BA:D0 04       BNE $65C0		; sinon page TEXT 2
65BC:2C 54 C0    BIT $C054		;C054 49236	TXTPAGE1	OECG	WR	Display Page 1
65BF:60          RTS
65C0:2C 55 C0    BIT $C055		;C055 49237	TXTPAGE2	OECG	WR	If 80STORE Off: Display Page 2	
65C3:60          RTS
65C4:FF                   ???
65C5:FF                   ???
; On sauvegarde toute la page 0 dans $1C00 et on remplace par $1F00
65C6:A0 00       LDY #$00
65C8:B9 00 00    LDA $0000,Y	; On sauvegarde la page 0 dans $1C00
65CB:99 00 1C    STA $1C00,Y	
65CE:B9 00 1F    LDA $1F00,Y	; On mets en page 0 $1F00
65D1:99 00 00    STA $0000,Y
65D4:C8          INY
65D5:D0 F1       BNE $65C8
65D7:60          RTS
65D8:A0 00       LDY #$00
65DA:B9 00 00    LDA $0000,Y
65DD:99 00 1F    STA $1F00,Y
65E0:B9 00 1C    LDA $1C00,Y
65E3:99 00 00    STA $0000,Y
65E6:C8          INY
65E7:D0 F1       BNE $65DA
65E9:60          RTS
;
65EA:18          CLC
65EB:A5 84       LDA $84
65ED:69 09       ADC #$09
65EF:85 84       STA $84
65F1:A5 85       LDA $85
65F3:69 00       ADC #$00
65F5:85 85       STA $85
65F7:60          RTS
;
65F8:18          CLC
65F9:A5 80       LDA $80
65FB:69 09       ADC #$09
65FD:85 80       STA $80
65FF:A5 81       LDA $81
6601:69 00       ADC #$00
6603:85 81       STA $81
6605:60          RTS
;
6606:A0 00       LDY #$00
6608:B1 80       LDA ($80),Y
660A:85 4A       STA $4A
660C:C8          INY
660D:B1 80       LDA ($80),Y
660F:85 4B       STA $4B
6611:A5 80       LDA $80
6613:18          CLC
6614:69 02       ADC #$02
6616:85 E8       STA $E8
6618:A5 81       LDA $81
661A:69 00       ADC #$00
661C:85 E9       STA $E9
661E:60          RTS
661F:A0 00       LDY #$00
6621:B1 80       LDA ($80),Y
6623:85 4A       STA $4A
6625:C8          INY
6626:B1 80       LDA ($80),Y
6628:85 4B       STA $4B
662A:A5 80       LDA $80
662C:18          CLC
662D:69 02       ADC #$02
662F:85 80       STA $80
6631:A5 81       LDA $81
6633:69 00       ADC #$00
6635:85 81       STA $81
6637:A5 29       LDA $29
6639:29 FE       AND #$FE
663B:A8          TAY
663C:B1 80       LDA ($80),Y
663E:85 E8       STA $E8
6640:C8          INY
6641:B1 80       LDA ($80),Y
6643:85 E9       STA $E9
6645:60          RTS
; Efface la page graphique 1 ou 2 suivant A sauvegardé dans $E6 (poids fort de la mémoire graphique)
6646:85 E6       STA $E6
6648:A9 00       LDA #$00
664A:85 DC       STA $DC
664C:A8          TAY
664D:20 00 60    JSR $6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
6650:A9 00       LDA #$00
6652:A0 00       LDY #$00
6654:91 4C       STA ($4C),Y	; On a l'emplacement mémoire de la ligne ($4C) on ajoute Y
6656:C8          INY
6657:C0 80       CPY #$80		; On efface trois lignes graphiques sur trois bandes
6659:90 F9       BCC $6654
665B:E6 DC       INC $DC
665D:A5 DC       LDA $DC
665F:C9 40       CMP #$40		; On passe en revue les 64 premieres lignes soit en tout 3*64=192 lignes
6661:90 E9       BCC $664C
6663:60          RTS
;
6664:A5 4B       LDA $4B
6666:85 C3       STA $C3
6668:A4 DC       LDY $DC
666A:20 00 60    JSR $6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
666D:A2 00       LDX #$00
666F:A4 E5       LDY $E5
6671:C0 28       CPY #$28
6673:B0 04       BCS $6679
6675:A1 E8       LDA ($E8,X)
6677:91 4C       STA ($4C),Y	; Rempli à la ligne graphique A le contenu ($E8)
6679:E6 E8       INC $E8
667B:D0 02       BNE $667F
667D:E6 E9       INC $E9
667F:C8          INY
6680:C6 C3       DEC $C3
6682:D0 ED       BNE $6671
6684:C6 DC       DEC $DC
6686:C6 4A       DEC $4A	
6688:D0 DA       BNE $6664
668A:60          RTS
;
668B:A5 4B       LDA $4B
668D:85 C3       STA $C3
668F:A4 DC       LDY $DC
6691:20 00 60    JSR $6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
6694:A2 00       LDX #$00
6696:A4 E5       LDY $E5
6698:C0 28       CPY #$28
669A:B0 0A       BCS $66A6
669C:A1 86       LDA ($86,X)
669E:49 FF       EOR #$FF
66A0:31 4C       AND ($4C),Y
66A2:01 E8       ORA ($E8,X)
66A4:91 4C       STA ($4C),Y
66A6:E6 E8       INC $E8
66A8:D0 02       BNE $66AC
66AA:E6 E9       INC $E9
66AC:E6 86       INC $86
66AE:D0 02       BNE $66B2
66B0:E6 87       INC $87
66B2:C8          INY
66B3:C6 C3       DEC $C3
66B5:D0 E1       BNE $6698
66B7:C6 DC       DEC $DC
66B9:C6 4A       DEC $4A
66BB:D0 CE       BNE $668B
66BD:60          RTS
;
66BE:A5 4B       LDA $4B
66C0:85 C3       STA $C3
66C2:A4 DC       LDY $DC
66C4:20 00 60    JSR $6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
66C7:A2 00       LDX #$00
66C9:A4 E5       LDY $E5
66CB:C0 28       CPY #$28
66CD:B0 0A       BCS $66D9
66CF:A1 E8       LDA ($E8,X)
66D1:49 FF       EOR #$FF
66D3:31 4C       AND ($4C),Y
66D5:01 E8       ORA ($E8,X)
66D7:91 4C       STA ($4C),Y
66D9:E6 E8       INC $E8
66DB:D0 02       BNE $66DF
66DD:E6 E9       INC $E9
66DF:C8          INY
66E0:C6 C3       DEC $C3
66E2:D0 E7       BNE $66CB
66E4:C6 DC       DEC $DC
66E6:C6 4A       DEC $4A
66E8:D0 D4       BNE $66BE
66EA:60          RTS
66EB:8D 02 67    STA $6702
66EE:20 C9 63    JSR $63C9
66F1:84 DC       STY $DC
66F3:20 1F 66    JSR $661F
66F6:A4 DC       LDY $DC
66F8:20 00 60    JSR $6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
66FB:A5 4B       LDA $4B
66FD:85 C3       STA $C3
66FF:A4 E5       LDY $E5
6701:A9 00       LDA #$00
6703:91 4C       STA ($4C),Y
6705:C8          INY
6706:C6 C3       DEC $C3
6708:D0 F9       BNE $6703
670A:C6 DC       DEC $DC
670C:C6 4A       DEC $4A
670E:D0 E6       BNE $66F6
6710:60          RTS
6711:A0 03       LDY #$03
6713:B1 80       LDA ($80),Y
6715:48          PHA
6716:88          DEY
6717:88          DEY
6718:B1 80       LDA ($80),Y
671A:AA          TAX
671B:88          DEY
671C:B1 80       LDA ($80),Y
671E:A0 05       LDY #$05
6720:91 80       STA ($80),Y
6722:C8          INY
6723:8A          TXA
6724:91 80       STA ($80),Y
6726:C8          INY
6727:68          PLA
6728:91 80       STA ($80),Y
672A:20 F8 65    JSR $65F8
672D:60          RTS
; Affiche des points en mémoire graphique page $E6
; On remplit les lignes de X à Y-1, lignes paires avec $00$01 et lignes impaires avec $02$03
672E:86 DE       STX $DE
6730:84 DC       STY $DC
6732:A4 DE       LDY $DE
6734:20 00 60    JSR $6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
6737:A0 00       LDY #$00
6739:A5 DE       LDA $DE		
673B:4A          LSR				; Logical Shift Right (bit de poids faible qui vient de tomber dans CARRY=>ligne pair ou impair)
673C:B0 11       BCS $674F		; Carry SET? OUI>↓>Ligne impaire On va remplir avec les octets $02 et $03 la ligne
673E:A5 00       LDA $00		;>> On rempli avec $00 et $01 toute la ligne paire 
6740:91 4C       STA ($4C),Y	; Mettre l'octet Y pair, la valeur $00 dans la mémoire de la ligne paire $DE
6742:C8          INY				; Octets suivant (impaire) sur la ligne paire $DE
6743:A5 01       LDA $01		; Mettre l'octet Y impair, la valeur $00 dans la mémoire de la ligne paire $DE
6745:91 4C       STA ($4C),Y
6747:C8          INY
6748:C0 28       CPY #$28		; 40 octets de points déjà traité (40*7bit=280)?
674A:90 F2       BCC $673E		; OUI>↑> strictement inférieur
674C:4C 5D 67    JMP $675D		; Traitement>↓>On prend la ligne suivante jusqu'à $DC
674F:A5 02       LDA $02		;>>Traitement ligne impaire
6751:91 4C       STA ($4C),Y
6753:C8          INY
6754:A5 03       LDA $03
6756:91 4C       STA ($4C),Y
6758:C8          INY
6759:C0 28       CPY #$28
675B:90 F2       BCC $674F
675D:E6 DE       INC $DE		; Ligne suivante
675F:A4 DE       LDY $DE
6761:C4 DC       CPY $DC		; On a fini de remplir jusqu'à la ligne $DC
6763:90 CF       BCC $6734		; Inférieur strictement>↑>
6765:60          RTS		
; <ROUTINE1> de la boucle pricipale 
; Récupération de la dernière touche appuyée ou bouton appuyé et positionnement de TIMER
6766:AD 00 C0    LDA $C000		;C000 49152	KBD	OECG	R	Last Key Pressed (+ 128 if strobe not cleared)
6769:30 01       BMI $676C		; oui nouvelle touche pressée	
676B:60          RTS
676C:A4 2A       LDY $2A			
676E:F0 47       BEQ $67B7		; Aller plus bas au traitement Joystick
6770:A4 32       LDY $32		; Flag=1 si 'partie en cours' 
6772:F0 57       BEQ $67CB		; si $32=0 on ne controle que la touche espace cf plus bas >>
6774:C5 10       CMP $10		; Touche vers le HAUT 'A'
6776:D0 07       BNE $677F		; non
6778:A9 FF       LDA #$FF		; On prévoit de mettre FF dans le registre $D4 (vertical&HAUT)
677A:E6 D9       INC $D9		; ?semble gèrer un timer qui croit sans cesse de 01=>BF qq soit le level?
677C:4C AD 67    JMP $67AD		; on sort
677F:C5 11       CMP $11		; Touche vers le BAS 'Z'
6781:D0 0B       BNE $678E		; non testons l'axe horizontal
6783:A9 DC       LDA #$DC		
6785:85 D7       STA $D7		; Timer décroissant utiliser au level 3 pour limiter la position 'coucher'
6787:A9 01       LDA #$01		; On va mettre 01 dans le registre $D4 (vertical&BAS)
6789:E6 D9       INC $D9		; ? on retrouve D9 timer croissant de 01=>BF ?
678B:4C AD 67    JMP $67AD		; on sort
678E:C5 12       CMP $12		; Touche Flèche de gauche
6790:D0 07       BNE $6799		; non
6792:A9 FF       LDA #$FF		; oui '←' appuyée, on va mettre FF dans le registre $D5 (HORIZONTAL&GAUCHE)
6794:E6 D9       INC $D9		; ? on retrouve D9 timer croissant de 01=>BF ?		
6796:4C B2 67    JMP $67B2		; On va mettre FF dans $D5 (direction appuyé)
6799:C5 13       CMP $13		; Touche Flèche de droite
679B:D0 07       BNE $67A4		; NON
679D:A9 01       LDA #$01		; On va mettre 01 dans le registre $D5 (HORIZONTAL&DROITE)
679F:E6 D9       INC $D9
67A1:4C B2 67    JMP $67B2		; Affectation de $D4
67A4:C5 15       CMP $15		; $15 contient comme $14 le code ascii pour <SPACE>=#A0
67A6:D0 0F       BNE $67B7		; NON => on va comme pour le traitement avec joystick
67A8:85 D6       STA $D6		; Registre $D6 vaut #0A si action d'un saut ou sortie de couteau
67AA:4C D6 67    JMP $67D6		; on sort
67AD:85 D4       STA $D4		; On met soit 01 (BAS) ou soit FF (HAUT) dans le registre $D4
67AF:4C D6 67    JMP $67D6		; on sort
67B2:85 D5       STA $D5		; On met soi01 (DROITE) ou soit FF (GAUCHE) dans le registre $D5
67B4:4C D6 67    JMP $67D6		; on sort
; Traitement si $2A=0 (Joystick)
67B7:A4 32       LDY $32    	; Charge 'Partie en cours'=1?
67B9:F0 10       BEQ $67CB		; NON: on test uniquement touche espace pour fenetre des options
67BB:C9 91       CMP #$91		; Touche 'Ctrl-Q' si on est en cours de partie
67BD:D0 05       BNE $67C4		; NON
67BF:85 34       STA $34		; On quitte le jeu (en fait on recommence) flag $34=#$91
67C1:4C D6 67    JMP $67D6		; on sort
67C4:C9 8F       CMP #$8F		; Touche 'Ctrl-O'
67C6:D0 0E       BNE $67D6		; On sort si pas appuyé
67C8:4C CF 67    JMP $67CF		; On retourne directement dans
67CB:C9 A0       CMP #$A0		; >>Touche appuyée <space>
67CD:D0 07       BNE $67D6		; si non on sort
67CF:A9 01       LDA #$01		; On va rentrer dans l'écran des options juste ci dessous
67D1:85 31       STA $31		; $31 est mis à 1 pendant que l'on présente les options
67D3:20 DA 67    JSR $67DA		; Routine de l'affichage et gestions des options
67D6:2C 10 C0    BIT $C010		;C010 49168	KBDSTRB	OECG	WR	Keyboard Strobe
67D9:60          RTS
; Affichage de l'Ecran des Options (sans les options)
67DA:A9 00       LDA #$00
67DC:85 3D       STA $3D
67DE:85 3E       STA $3E
67E0:85 CE       STA $CE
67E2:2C 10 C0    BIT $C010		;C010 49168	KBDSTRB	OECG	WR	Keyboard Strobe
67E5:A9 A0       LDA #$A0
67E7:85 00       STA $00
67E9:20 0B 6B    JSR $6B0B		; vide la mémoire TEXT page 1 0x400-0x7FF
67EC:A9 00       LDA #$00
67EE:85 C3       STA $C3
67F0:A5 C3       LDA $C3
67F2:0A          ASL				; Décalage à gauche des bit de A (Carry Flag affecté)
67F3:A8          TAY
67F4:B9 94 69    LDA $6994,Y	; récupération de l'adresse poids faible 
67F7:85 80       STA $80
67F9:C8          INY
67FA:2C 10 C0    BIT $C010		;C010 49168	KBDSTRB	OECG	WR	Keyboard Strobe
67FD:B9 94 69    LDA $6994,Y	; récupération de l'adresse poids faible 
6800:85 81       STA $81		; Stockage du text écran d'options aux différentes adresses ($80)=$69AC,$69D0,$69ED,$6A09...
6802:A0 00       LDY #$00		
6804:B1 80       LDA ($80),Y	; Récupération du texte à l'adresse $69AC au premier ligne au premier passage
6806:C9 FF       CMP #$FF		; S'arrête de lire le TEXTE en ($80),Y lorsqu'il rencontre #$FF
6808:F0 18       BEQ $6822
680A:C8          INY			
680B:85 85       STA $85
680D:B1 80       LDA ($80),Y
680F:85 84       STA $84
6811:C8          INY
6812:B1 80       LDA ($80),Y
6814:C9 FF       CMP #$FF
6816:F0 05       BEQ $681D
6818:91 84       STA ($84),Y
681A:4C 11 68    JMP $6811
681D:E6 C3       INC $C3
681F:4C F0 67    JMP $67F0
6822:A2 00       LDX #$00		; Arrive ici en fin de lecture d'une ligne de texte
6824:A0 0F       LDY #$0F		; 
6826:B5 94       LDA $94,X		; Récupére le highscore et score joueur 1 et 2 soit 5*3=15 valeurs
6828:18          CLC
6829:69 B0       ADC #$B0		; Ajoute #$B0 pour avoir le chiffre du score en text (par exemple ascii #$B0-$80 = $30 = '0')
682B:99 7A 69    STA $697A,Y	; On stocke le Score en partant des dizaines
682E:E8          INX
682F:88          DEY
6830:D0 F4       BNE $6826		; boucle sur 15 valeurs des 3 scores à afficher
6832:A2 B0       LDX #$B0
6834:B9 80 69    LDA $6980,Y	; 
6837:99 83 04    STA $0483,Y	; Affecte directement l'écran TEXT avec le score joueur 1
683A:C8          INY
683B:C0 05       CPY #$05
683D:90 F5       BCC $6834
683F:8A          TXA			; récupere dans A #$B0 correspond à l'unité du score toujours à '0'
6840:99 83 04    STA $0483,Y	; Stocke l'unité du score à '0' dans le mémoire
6843:A0 00       LDY #$00		
6845:B9 7B 69    LDA $697B,Y	; Même processus que précédemment pour le score joueur 2
6848:99 8E 04    STA $048E,Y
684B:C8          INY
684C:C0 05       CPY #$05
684E:90 F5       BCC $6845
6850:8A          TXA
6851:99 8E 04    STA $048E,Y
6854:A0 00       LDY #$00
6856:B9 85 69    LDA $6985,Y	; Même processus pour le HighScore
6859:99 9A 04    STA $049A,Y
685C:C8          INY
685D:C0 05       CPY #$05
685F:90 F5       BCC $6856
6861:8A          TXA
6862:99 9A 04    STA $049A,Y
6865:A9 20       LDA #$20		; On sélectionne la premiere page graphique $2000
6867:20 46 66    JSR $6646		; Efface la page graphique 1 ou 2 suivant A sauvegardé dans $E6 (poids fort de la mémoire graphique)
686A:A9 40       LDA #$40		; On sélectionne la premiere page graphique $4000
686C:20 46 66    JSR $6646		; Efface la page graphique 1 ou 2 suivant A sauvegardé dans $E6 (poids fort de la mémoire graphique)
686F:2C 54 C0    BIT $C054		; C054 49236	TXTPAGE1	OECG	WR	Display Page 1
6872:2C 51 C0    BIT $C051		; C051 49233	TXTSET	OECG	WR	Display Text
; On affiche toutes les options directement dans la mémoire écran
6875:A0 00       LDY #$00
6877:A5 2A       LDA $2A		; Flag joystick (=0)
6879:F0 0E       BEQ $6889		; si oui on va afficher "JOYSTICK"
687B:B9 63 69    LDA $6963,Y	; Récupération de 8 valeurs en $6963=CB C5 D9 C2 CF C1 D2 C4 = "KEYBOARD"
687E:99 B1 07    STA $07B1,Y	;  pour les mettre dans la mémoire écran au bonne endroit $07B1
6881:C8          INY
6882:C0 08       CPY #$08
6884:90 F5       BCC $687B		; branchement si strictement inférieur à 8
6886:4C 94 68    JMP $6894		; On passe le traitement keyboard
6889:B9 6B 69    LDA $696B,Y	; Traitement Affichage direct dans mem écran le mot "JOYSTICK"
688C:99 B1 07    STA $07B1,Y	; Récupération de 8 valeurs en $696B=CA CF D9 D3 D4 C9 C3 CB = "JOYSTICK"
688F:C8          INY				;  pour les mettre dans la mémoire écran au bonne endroit $07B1
6890:C0 08       CPY #$08
6892:90 F5       BCC $6889
6894:A5 5C       LDA $5C		; Récupération du flag de la difficulté de 0 à 2
6896:18          CLC			
6897:69 B1       ADC #$B1		; Conversion du nombre en ASCII
6899:8D 32 07    STA $0732		; On stocke le caractére en ASCII du level/difficulté soit '1' '2' ou '3'
689C:A5 41       LDA $41		; Registre du nombre de joueur
689E:18          CLC
689F:69 B0       ADC #$B0		; Addition pour conversion en ASCII du registre 'nb de joueur' $41
68A1:8D 48 07    STA $0748		; On stocke dans la mémoire écran texte à l'endroit pile de l'option "PLAYERS (X)"
68A4:A0 00       LDY #$00	
68A6:A5 1B       LDA $1B
68A8:F0 0E       BEQ $68B8
68AA:B9 76 69    LDA $6976,Y
68AD:99 C6 07    STA $07C6,Y	; Affiche soit "ON " soit "OFF" pour l'option 'SON'
68B0:C8          INY
68B1:C0 03       CPY #$03
68B3:90 F5       BCC $68AA
68B5:4C C3 68    JMP $68C3
68B8:B9 73 69    LDA $6973,Y
68BB:99 C6 07    STA $07C6,Y
68BE:C8          INY
68BF:C0 03       CPY #$03
68C1:90 F5       BCC $68B8
; Traitement des touches pour la sélection des options
68C3:A2 FF       LDX #$FF		; Boucle de temps 255
68C5:CA          DEX
68C6:D0 FD       BNE $68C5
68C8:E6 3D       INC $3D
68CA:D0 16       BNE $68E2		; si différent de zéro on teste les touches de l'écran d'option
68CC:E6 3E       INC $3E		; on incrémente le poids fort du délai de l'écran
68CE:A5 3E       LDA $3E
68D0:C9 20       CMP #$20		; si poids fort égale à #$20 
68D2:90 0E       BCC $68E2		; si strictement inférieur à 20 on reste sur l'écran des options
68D4:E6 3C       INC $3C		; on va sortir après qu'aucune activité n'est apparue (incrément le flag de sortie?)
68D6:A9 00       LDA #$00		
68D8:85 3E       STA $3E		; on remets le compteur à zéro de la tempo 
68DA:85 33       STA $33		; 
68DC:85 31       STA $31 		; $31: Flag global qui indique si le jeu est en mode options ou en mode partie.
68DE:2C 50 C0    BIT $C050		;C050 49232	TXTCLR	OECG	WR	Display Graphics
68E1:60          RTS			; On sort après un temps d'inactivité sur l'écran des options ($3C>0)
68E2:A5 2A       LDA $2A		; Flag option KEYBOARD ou JOYSTICK=0
68E4:D0 05       BNE $68EB		; Branchement si Keyboard
68E6:AD 61 C0    LDA $C061		; C061 49249	BUTN0	OECG	R7	Switch Input 0
68E9:30 5E       BMI $6949		; On démarre le jeu si on est en mode Joystick et on a appuyé sur le boutton 0
68EB:AD 00 C0    LDA $C000		; sinon Lecture de la touche
68EE:10 D3       BPL $68C3
68F0:C9 A0       CMP #$A0		; Test de la touche <Espace>
68F2:F0 55       BEQ $6949		; Sortir pour démarrer le jeu
68F4:A0 00       LDY #$00
68F6:84 3E       STY $3E
68F8:C9 CB       CMP #$CB		; Test de la touche 'K' (#31+bit7)
68FA:D0 05       BNE $6901
68FC:85 2A       STA $2A		; Positionne le registre $2A Keyboard à #CB <>0
68FE:4C 43 69    JMP $6943
6901:C9 CA       CMP #$CA		; Test de la touche 'J' (#31+bit7)
6903:D0 07       BNE $690C
6905:A9 00       LDA #$00
6907:85 2A       STA $2A		; Positionne le registre $2A Joystick à 0
6909:4C 43 69    JMP $6943
690C:C9 B1       CMP #$B1		; Test de la touche '1' (#31+bit7)
690E:D0 07       BNE $6917
6910:A9 01       LDA #$01		; Positionne le registre du nb de joueur à 1
6912:85 41       STA $41
6914:4C 43 69    JMP $6943
6917:C9 B2       CMP #$B2		; Teste la touche '2' (#32+bit7)
6919:D0 07       BNE $6922
691B:A9 02       LDA #$02
691D:85 41       STA $41		; Positionne le registre du nb de joueur à 2
691F:4C 43 69    JMP $6943
6922:C9 D3       CMP #$D3		; Teste la touche 'S' (#53+bit7) option du son
6924:D0 0D       BNE $6933
6926:A2 00       LDX #$00		; On inverse la position
6928:A5 1B       LDA $1B		; du registre $1B, flag du son
692A:D0 02       BNE $692E		; si $1B==#01 on met zéro
692C:A2 01       LDX #$01		; sinon on met $1B à '1' 
692E:86 1B       STX $1B
6930:4C 43 69    JMP $6943		
6933:C9 CC       CMP #$CC		; Teste la touche 'L' (#53+bit7) option du level/difficulté
6935:D0 0C       BNE $6943		
6937:E6 5C       INC $5C		; on affecte le flag $5C de la difficulté de 0 à 2
6939:A5 5C       LDA $5C
693B:C9 03       CMP #$03
693D:90 02       BCC $6941		; inférieur strictement à #03
693F:A9 00       LDA #$00		; sinon on remets le flag à zéro
6941:85 5C       STA $5C
6943:2C 10 C0    BIT $C010		; On efface la touche appuyée
6946:4C 75 68    JMP $6875		; On réaffiche l'écran des options
6949:2C 50 C0    BIT $C050		;C050 49232	TXTCLR	OECG	WR	Display Graphics
694C:2C 52 C0    BIT $C052		;C052 49234	MIXCLR	OECG	WR	Display Full Screen
694F:2C 57 C0    BIT $C057		;C057 49239	HIRES	OECG	WR	Display HiRes Graphics
6952:2C 10 C0    BIT $C010		;C010 49168	KBDSTRB	OECG	WR	Keyboard Strobe
6955:A5 1C       LDA $1C		; On retourne sur la page $1C à afficher ($1D est la page que l'on desssine)
6957:C9 20       CMP #$20		; Page 1
6959:D0 04       BNE $695F		; sinon Page 2
695B:2C 54 C0    BIT $C054		;C054 49236	TXTPAGE1	OECG	WR	Display Page 1
695E:60          RTS
695F:2C 55 C0    BIT $C055		;C055 49237	TXTPAGE2	OECG	WR	If 80STORE Off: Display Page 2
6962:60          RTS
;fin de <ROUTINE1>
6963:CB                   ???
6964:C5 D9       CMP $D9
6966:C2                   ???
6967:CF                   ???
6968:C1 D2       CMP ($D2,X)
696A:C4 CA       CPY $CA
696C:CF                   ???
696D:D9 D3 D4    CMP $D4D3,Y
6970:C9 C3       CMP #$C3
6972:CB                   ???
6973:CF                   ???
6974:CE A0 CF    DEC $CFA0
6977:C6 C6       DEC $C6
6979:00          BRK
697A:00          BRK
697B:B0 B0       BCS $692D
697D:B0 B0       BCS $692F
697F:B0 B0       BCS $6931
6981:B0 B0       BCS $6933
6983:B0 B0       BCS $6935
6985:B0 B0       BCS $6937
6987:B0 B0       BCS $6939
6989:B0 07       BCS $6992
698B:35 07       AND $07,X
698D:49 07       EOR #$07
698F:B4 07       LDY $07,X
6991:C7                   ???
6992:00          BRK
6993:00          BRK
6994:AC 69 D0    LDY $D069
6997:69 ED       ADC #$ED
6999:69 09       ADC #$09
699B:6A          ROR
699C:25 6A       AND $6A
699E:45 6A       EOR $6A
69A0:65 6A       ADC $6A
69A2:87                   ???
69A3:6A          ROR
69A4:A5 6A       LDA $6A
69A6:C8          INY
69A7:6A          ROR
69A8:EB                   ???
69A9:6A          ROR
69AA:0A          ASL
69AB:6B                   ???
; Emplacement des infos texte de l'écran des options
69AC:04                   ???	; 
69AD:00          BRK
69AE:A0 D0       LDY #$D0		; " PLAYER 1   PLAYER 2   HIGH SCORE"
69B0:CC C1 D9    CPY $D9C1
69B3:C5 D2       CMP $D2
69B5:A0 B1       LDY #$B1
69B7:A0 A0       LDY #$A0
69B9:A0 D0       LDY #$D0
69BB:CC C1 D9    CPY $D9C1
69BE:C5 D2       CMP $D2
69C0:A0 B2       LDY #$B2
69C2:A0 A0       LDY #$A0
69C4:A0 C8       LDY #$C8
69C6:C9 C7       CMP #$C7
69C8:C8          INY
69C9:A0 D3       LDY #$D3
69CB:C3                   ???
69CC:CF                   ???
69CD:D2                   ???
69CE:C5 FF       CMP $FF
69D0:06 00       ASL $00
69D2:A0 A0       LDY #$A0
69D4:A0 A0       LDY #$A0
69D6:A0 A0       LDY #$A0
69D8:A0 CA       LDY #$CA
69DA:D5 CE       CMP $CE,X
69DC:C7                   ???
69DD:CC C5 A0    CPY $A0C5
69E0:C8          INY
69E1:D5 CE       CMP $CE,X
69E3:D4                   ???
69E4:A0 CF       LDY #$CF
69E6:D0 D4       BNE $69BC
69E8:C9 CF       CMP #$CF
69EA:CE D3 FF    DEC $FFD3
69ED:07                   ???
69EE:80                   ???
69EF:A0 A0       LDY #$A0
69F1:A0 A0       LDY #$A0
69F3:A0 A0       LDY #$A0
69F5:A0 A0       LDY #$A0
69F7:A0 CB       LDY #$CB
69F9:A0 A0       LDY #$A0
69FB:CB                   ???
69FC:C5 D9       CMP $D9
69FE:C2                   ???
69FF:CF                   ???
6A00:C1 D2       CMP ($D2,X)
6A02:C4 A0       CPY $A0
6A04:CD CF C4    CMP $C4CF
6A07:C5 FF       CMP $FF
6A09:04                   ???
6A0A:28          PLP
6A0B:A0 A0       LDY #$A0
6A0D:A0 A0       LDY #$A0
6A0F:A0 A0       LDY #$A0
6A11:A0 A0       LDY #$A0
6A13:A0 CA       LDY #$CA
6A15:A0 A0       LDY #$A0
6A17:CA          DEX
6A18:CF                   ???
6A19:D9 D3 D4    CMP $D4D3,Y
6A1C:C9 C3       CMP #$C3
6A1E:CB                   ???
6A1F:A0 CD       LDY #$CD
6A21:CF                   ???
6A22:C4 C5       CPY $C5
6A24:FF                   ???
6A25:04                   ???
6A26:A8          TAY
6A27:A0 A0       LDY #$A0
6A29:A0 A0       LDY #$A0
6A2B:A0 A0       LDY #$A0
6A2D:A0 A0       LDY #$A0
6A2F:A0 B1       LDY #$B1
6A31:A0 A0       LDY #$A0
6A33:CF                   ???
6A34:CE C5 A0    DEC $A0C5
6A37:D0 CC       BNE $6A05
6A39:C1 D9       CMP ($D9,X)
6A3B:C5 D2       CMP $D2
6A3D:A0 CF       LDY #$CF
6A3F:D0 D4       BNE $6A15
6A41:C9 CF       CMP #$CF
6A43:CE FF 05    DEC $05FF
6A46:28          PLP
6A47:A0 A0       LDY #$A0
6A49:A0 A0       LDY #$A0
6A4B:A0 A0       LDY #$A0
6A4D:A0 A0       LDY #$A0
6A4F:A0 B2       LDY #$B2
6A51:A0 A0       LDY #$A0
6A53:D4                   ???
6A54:D7                   ???
6A55:CF                   ???
6A56:A0 D0       LDY #$D0
6A58:CC C1 D9    CPY $D9C1
6A5B:C5 D2       CMP $D2
6A5D:A0 CF       LDY #$CF
6A5F:D0 D4       BNE $6A35
6A61:C9 CF       CMP #$CF
6A63:CE FF 05    DEC $05FF
6A66:A8          TAY
6A67:A0 A0       LDY #$A0
6A69:A0 A0       LDY #$A0
6A6B:A0 A0       LDY #$A0
6A6D:A0 A0       LDY #$A0
6A6F:A0 CC       LDY #$CC
6A71:A0 A0       LDY #$A0
6A73:CC C5 D6    CPY $D6C5
6A76:C5 CC       CMP $CC
6A78:A0 CF       LDY #$CF
6A7A:C6 A0       DEC $A0
6A7C:C4 C9       CPY $C9
6A7E:C6 C6       DEC $C6
6A80:C9 C3       CMP #$C3
6A82:D5 CC       CMP $CC,X
6A84:D4                   ???
6A85:D9 FF 06    CMP $06FF,Y
6A88:28          PLP
6A89:A0 A0       LDY #$A0
6A8B:A0 A0       LDY #$A0
6A8D:A0 A0       LDY #$A0
6A8F:A0 A0       LDY #$A0
6A91:A0 D3       LDY #$D3
6A93:A0 A0       LDY #$A0
6A95:D3                   ???
6A96:CF                   ???
6A97:D5 CE       CMP $CE,X
6A99:C4 A0       CPY $A0
6A9B:CF                   ???
6A9C:CE A0 CF    DEC $CFA0
6A9F:D2                   ???
6AA0:A0 CF       LDY #$CF
6AA2:C6 C6       DEC $C6
6AA4:FF                   ???
6AA5:07                   ???
6AA6:28          PLP
6AA7:A0 CC       LDY #$CC
6AA9:C5 D6       CMP $D6
6AAB:C5 CC       CMP $CC
6AAD:A0 A8       LDY #$A8
6AAF:A0 A9       LDY #$A9
6AB1:A0 A0       LDY #$A0
6AB3:A0 A0       LDY #$A0
6AB5:A0 A0       LDY #$A0
6AB7:A0 A0       LDY #$A0
6AB9:A0 A0       LDY #$A0
6ABB:A0 D0       LDY #$D0
6ABD:CC C1 D9    CPY $D9C1
6AC0:C5 D2       CMP $D2
6AC2:D3                   ???
6AC3:A0 A8       LDY #$A8
6AC5:A0 A9       LDY #$A9
6AC7:FF                   ???
6AC8:07                   ???
6AC9:A8          TAY
6ACA:A0 CD       LDY #$CD
6ACC:CF                   ???
6ACD:C4 C5       CPY $C5
6ACF:A0 A8       LDY #$A8
6AD1:CA          DEX
6AD2:CF                   ???
6AD3:D9 D3 D4    CMP $D4D3,Y
6AD6:C9 C3       CMP #$C3
6AD8:CB                   ???
6AD9:A9 A0       LDA #$A0
6ADB:A0 A0       LDY #$A0
6ADD:A0 A0       LDY #$A0
6ADF:D3                   ???
6AE0:CF                   ???
6AE1:D5 CE       CMP $CE,X
6AE3:C4 A0       CPY $A0
6AE5:A8          TAY
6AE6:CF                   ???
6AE7:C6 C6       DEC $C6
6AE9:A9 FF       LDA #$FF
6AEB:05 50       ORA $50
6AED:A0 A0       LDY #$A0
6AEF:A0 A0       LDY #$A0
6AF1:A0 A0       LDY #$A0
6AF3:A0 D3       LDY #$D3
6AF5:D0 C1       BNE $6AB8
6AF7:C3                   ???
6AF8:C5 A0       CMP $A0
6AFA:C2                   ???
6AFB:C1 D2       CMP ($D2,X)
6AFD:A0 D3       LDY #$D3
6AFF:D4                   ???
6B00:C1 D2       CMP ($D2,X)
6B02:D4                   ???
6B03:D3                   ???
6B04:A0 C7       LDY #$C7
6B06:C1 CD       CMP ($CD,X)
6B08:C5 FF       CMP $FF
6B0A:FF                   ???
; On initialise toute la fenetre text de $400 à $7FF par bande avec la valeur qu'il y a dans $00 (soit <sapce> soit bloc orange
6B0B:A9 00       LDA #$00		;0400–07FF	Text page 0 dans ($80)
6B0D:85 80       STA $80
6B0F:A9 04       LDA #$04
6B11:85 81       STA $81
6B13:85 37       STA $37		; Flag pendant l'initialisation
6B15:A0 00       LDY #$00
6B17:A5 00       LDA $00		; Le registre $00 contient #$A0=<space>
6B19:91 80       STA ($80),Y
6B1B:E6 80       INC $80
6B1D:A5 80       LDA $80
6B1F:C9 78       CMP #$78		; Mettre #00 de $400 à $477 au premier passage => trois premières bande texte col0, col8 et col6
6B21:90 F4       BCC $6B17		; Si strictement inférieur
6B23:A9 80       LDA #$80
6B25:85 80       STA $80		; On charge ($80)=$480
6B27:A5 00       LDA $00
6B29:91 80       STA ($80),Y
6B2B:E6 80       INC $80
6B2D:A5 80       LDA $80
6B2F:C9 F8       CMP #$F8		; Mettre #00 de $480 à $4F7 (trois deuxième bande texte col1, col9 et col7)
6B31:90 F4       BCC $6B27
6B33:A9 00       LDA #$00
6B35:85 80       STA $80
6B37:E6 81       INC $81		; on recommence avec ($80)=$500 puis $600 puis $700 (soit 2*3 bandes 4 fois=6*4=24 lignes)
6B39:A5 81       LDA $81
6B3B:C9 08       CMP #$08
6B3D:90 D8       BCC $6B17
6B3F:60          RTS
; Rempli l'écran GR (TEXT) en orange au moment de la mort du joueur
6B40:A9 99       LDA #$99		; Charge #$99 (bloc orange en GR) dans le registre $00
6B42:85 00       STA $00
6B44:20 0B 6B    JSR $6B0B		; Rempli la mémoire TEXT page 1 0x400-0x7FF avec #$99=bloc orange en mode GR
6B47:2C 54 C0    BIT $C054		;C054 49236	TXTPAGE1	OECG	WR	Display Page 1
6B4A:2C 56 C0    BIT $C056		;C056 49238	LORES	OECG	WR	Display LoRes Graphics
6B4D:A0 FF       LDY #$FF
6B4F:A2 FF       LDX #$FF
6B51:CA          DEX
6B52:D0 FD       BNE $6B51
6B54:88          DEY
6B55:D0 F8       BNE $6B4F
6B57:2C 57 C0    BIT $C057		;C057 49239	HIRES	OECG	WR	Display HiRes Graphics
6B5A:A5 1C       LDA $1C		; si $1D vaut #$20 (page1) alors $1D vaut #$40 (page2)
6B5C:C9 20       CMP #$20
6B5E:F0 03       BEQ $6B63
6B60:2C 55 C0    BIT $C055		;C055 49237	TXTPAGE2	OECG	WR	If 80STORE Off: Display Page 2
6B63:60          RTS
6B64:85 4A       STA $4A
6B66:86 4B       STX $4B
6B68:84 DC       STY $DC
6B6A:A4 DC       LDY $DC
6B6C:20 00 60    JSR $6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
6B6F:A2 00       LDX #$00
6B71:A1 E8       LDA ($E8,X)
6B73:AA          TAX
6B74:A0 00       LDY #$00
6B76:91 4C       STA ($4C),Y
6B78:A0 04       LDY #$04
6B7A:8A          TXA
6B7B:91 4C       STA ($4C),Y
6B7D:A0 08       LDY #$08
6B7F:8A          TXA
6B80:91 4C       STA ($4C),Y
6B82:A0 0C       LDY #$0C
6B84:8A          TXA
6B85:91 4C       STA ($4C),Y
6B87:A0 10       LDY #$10
6B89:8A          TXA
6B8A:91 4C       STA ($4C),Y
6B8C:A0 14       LDY #$14
6B8E:8A          TXA
6B8F:91 4C       STA ($4C),Y
6B91:A0 18       LDY #$18
6B93:8A          TXA
6B94:91 4C       STA ($4C),Y
6B96:A0 1C       LDY #$1C
6B98:8A          TXA
6B99:91 4C       STA ($4C),Y
6B9B:A0 20       LDY #$20
6B9D:8A          TXA
6B9E:91 4C       STA ($4C),Y
6BA0:A0 24       LDY #$24
6BA2:8A          TXA
6BA3:91 4C       STA ($4C),Y
6BA5:E6 E8       INC $E8
6BA7:D0 02       BNE $6BAB
6BA9:E6 E9       INC $E9
6BAB:A2 00       LDX #$00
6BAD:A1 E8       LDA ($E8,X)
6BAF:AA          TAX
6BB0:A0 01       LDY #$01
6BB2:91 4C       STA ($4C),Y
6BB4:A0 05       LDY #$05
6BB6:8A          TXA
6BB7:91 4C       STA ($4C),Y
6BB9:A0 09       LDY #$09
6BBB:8A          TXA
6BBC:91 4C       STA ($4C),Y
6BBE:A0 0D       LDY #$0D
6BC0:8A          TXA
6BC1:91 4C       STA ($4C),Y
6BC3:A0 11       LDY #$11
6BC5:8A          TXA
6BC6:91 4C       STA ($4C),Y
6BC8:A0 15       LDY #$15
6BCA:8A          TXA
6BCB:91 4C       STA ($4C),Y
6BCD:A0 19       LDY #$19
6BCF:8A          TXA
6BD0:91 4C       STA ($4C),Y
6BD2:A0 1D       LDY #$1D
6BD4:8A          TXA
6BD5:91 4C       STA ($4C),Y
6BD7:A0 21       LDY #$21
6BD9:8A          TXA
6BDA:91 4C       STA ($4C),Y
6BDC:A0 25       LDY #$25
6BDE:8A          TXA
6BDF:91 4C       STA ($4C),Y
6BE1:E6 E8       INC $E8
6BE3:D0 02       BNE $6BE7
6BE5:E6 E9       INC $E9
6BE7:A2 00       LDX #$00
6BE9:A1 E8       LDA ($E8,X)
6BEB:AA          TAX
6BEC:A0 02       LDY #$02
6BEE:91 4C       STA ($4C),Y
6BF0:A0 06       LDY #$06
6BF2:8A          TXA
6BF3:91 4C       STA ($4C),Y
6BF5:A0 0A       LDY #$0A
6BF7:8A          TXA
6BF8:91 4C       STA ($4C),Y
6BFA:A0 0E       LDY #$0E
6BFC:8A          TXA
6BFD:91 4C       STA ($4C),Y
6BFF:A0 12       LDY #$12
6C01:8A          TXA
6C02:91 4C       STA ($4C),Y
6C04:A0 16       LDY #$16
6C06:8A          TXA
6C07:91 4C       STA ($4C),Y
6C09:A0 1A       LDY #$1A
6C0B:8A          TXA
6C0C:91 4C       STA ($4C),Y
6C0E:A0 1E       LDY #$1E
6C10:8A          TXA
6C11:91 4C       STA ($4C),Y
6C13:A0 22       LDY #$22
6C15:8A          TXA
6C16:91 4C       STA ($4C),Y
6C18:A0 26       LDY #$26
6C1A:8A          TXA
6C1B:91 4C       STA ($4C),Y
6C1D:E6 E8       INC $E8
6C1F:D0 02       BNE $6C23
6C21:E6 E9       INC $E9
6C23:A2 00       LDX #$00
6C25:A1 E8       LDA ($E8,X)
6C27:AA          TAX
6C28:A0 03       LDY #$03
6C2A:91 4C       STA ($4C),Y
6C2C:A0 07       LDY #$07
6C2E:8A          TXA
6C2F:91 4C       STA ($4C),Y
6C31:A0 0B       LDY #$0B
6C33:8A          TXA
6C34:91 4C       STA ($4C),Y
6C36:A0 0F       LDY #$0F
6C38:8A          TXA
6C39:91 4C       STA ($4C),Y
6C3B:A0 13       LDY #$13
6C3D:8A          TXA
6C3E:91 4C       STA ($4C),Y
6C40:A0 17       LDY #$17
6C42:8A          TXA
6C43:91 4C       STA ($4C),Y
6C45:A0 1B       LDY #$1B
6C47:8A          TXA
6C48:91 4C       STA ($4C),Y
6C4A:A0 1F       LDY #$1F
6C4C:8A          TXA
6C4D:91 4C       STA ($4C),Y
6C4F:A0 23       LDY #$23
6C51:8A          TXA
6C52:91 4C       STA ($4C),Y
6C54:A0 27       LDY #$27
6C56:8A          TXA
6C57:91 4C       STA ($4C),Y
6C59:E6 E8       INC $E8
6C5B:D0 02       BNE $6C5F
6C5D:E6 E9       INC $E9
6C5F:C6 DC       DEC $DC
6C61:C6 4A       DEC $4A
6C63:F0 03       BEQ $6C68
6C65:4C 6A 6B    JMP $6B6A
6C68:60          RTS
6C69:A0 00       LDY #$00
6C6B:B1 84       LDA ($84),Y
6C6D:91 80       STA ($80),Y
6C6F:C8          INY
6C70:B1 84       LDA ($84),Y
6C72:91 80       STA ($80),Y
6C74:C8          INY
6C75:B1 84       LDA ($84),Y
6C77:91 80       STA ($80),Y
6C79:C8          INY
6C7A:B1 84       LDA ($84),Y
6C7C:91 80       STA ($80),Y
6C7E:C8          INY
6C7F:B1 84       LDA ($84),Y
6C81:91 80       STA ($80),Y
6C83:C8          INY
6C84:B1 84       LDA ($84),Y
6C86:91 80       STA ($80),Y
6C88:C8          INY
6C89:B1 84       LDA ($84),Y
6C8B:91 80       STA ($80),Y
6C8D:C8          INY
6C8E:B1 84       LDA ($84),Y
6C90:91 80       STA ($80),Y
6C92:C8          INY
6C93:B1 84       LDA ($84),Y
6C95:91 80       STA ($80),Y
6C97:20 F8 65    JSR $65F8
6C9A:20 EA 65    JSR $65EA
6C9D:60          RTS
6C9E:02                   ???
6C9F:BB                   ???
6CA0:5A                   ???
6CA1:30 5F       BMI $6D02
6CA3:EE 3D A8    INC $A83D
6CA6:00          BRK
6CA7:AB                   ???
6CA8:AB                   ???
6CA9:AB                   ???
6CAA:AF                   ???
6CAB:FF                   ???
6CAC:FA                   ???
6CAD:AA          TAX
6CAE:DE 7F 7F    DEC $7F7F,X
6CB1:FC                   ???
6CB2:FE FE FE    INC $FEFE,X
6CB5:FE D5 AA    INC $AAD5,X
6CB8:AD 96 96    LDA $9696
6CBB:96 96       STX $96,Y
6CBD:96 96       STX $96,Y
6CBF:96 96       STX $96,Y
6CC1:96 96       STX $96,Y
6CC3:96 96       STX $96,Y
6CC5:96 96       STX $96,Y
6CC7:96 96       STX $96,Y
6CC9:96 96       STX $96,Y
6CCB:96 96       STX $96,Y
6CCD:96 96       STX $96,Y
6CCF:96 96       STX $96,Y
6CD1:96 96       STX $96,Y
6CD3:96 96       STX $96,Y
6CD5:96 96       STX $96,Y
6CD7:96 96       STX $96,Y
6CD9:96 96       STX $96,Y
6CDB:96 96       STX $96,Y
6CDD:96 96       STX $96,Y
6CDF:96 96       STX $96,Y
6CE1:96 96       STX $96,Y
6CE3:96 96       STX $96,Y
6CE5:96 96       STX $96,Y
6CE7:96 96       STX $96,Y
6CE9:96 96       STX $96,Y
6CEB:96 96       STX $96,Y
6CED:96 96       STX $96,Y
6CEF:96 96       STX $96,Y
6CF1:96 96       STX $96,Y
6CF3:96 96       STX $96,Y
6CF5:96 96       STX $96,Y
6CF7:96 96       STX $96,Y
6CF9:96 96       STX $96,Y
6CFB:96 96       STX $96,Y
6CFD:96 96       STX $96,Y
6CFF:96 96       STX $96,Y
6D01:96 96       STX $96,Y
6D03:96 96       STX $96,Y
6D05:96 96       STX $96,Y
6D07:96 96       STX $96,Y
6D09:96 96       STX $96,Y
6D0B:96 96       STX $96,Y
6D0D:96 96       STX $96,Y
6D0F:96 96       STX $96,Y
6D11:96 96       STX $96,Y
6D13:96 96       STX $96,Y
6D15:96 96       STX $96,Y
6D17:96 96       STX $96,Y
6D19:96 96       STX $96,Y
6D1B:96 96       STX $96,Y
6D1D:96 96       STX $96,Y
6D1F:96 96       STX $96,Y
6D21:96 96       STX $96,Y
6D23:96 96       STX $96,Y
6D25:96 96       STX $96,Y
6D27:96 96       STX $96,Y
6D29:96 96       STX $96,Y
6D2B:96 96       STX $96,Y
6D2D:96 96       STX $96,Y
6D2F:96 96       STX $96,Y
6D31:96 96       STX $96,Y
6D33:96 96       STX $96,Y
6D35:96 96       STX $96,Y
6D37:96 96       STX $96,Y
6D39:96 96       STX $96,Y
6D3B:96 96       STX $96,Y
6D3D:96 96       STX $96,Y
6D3F:96 96       STX $96,Y
6D41:96 96       STX $96,Y
6D43:96 96       STX $96,Y
6D45:96 96       STX $96,Y
6D47:96 96       STX $96,Y
6D49:96 96       STX $96,Y
6D4B:96 96       STX $96,Y
6D4D:96 96       STX $96,Y
6D4F:96 96       STX $96,Y
6D51:96 96       STX $96,Y
6D53:96 96       STX $96,Y
6D55:96 96       STX $96,Y
6D57:96 96       STX $96,Y
6D59:96 96       STX $96,Y
6D5B:96 96       STX $96,Y
6D5D:96 96       STX $96,Y
6D5F:96 96       STX $96,Y
6D61:96 96       STX $96,Y
6D63:96 96       STX $96,Y
6D65:96 96       STX $96,Y
6D67:96 96       STX $96,Y
6D69:96 96       STX $96,Y
6D6B:96 96       STX $96,Y
6D6D:96 96       STX $96,Y
6D6F:96 96       STX $96,Y
6D71:96 96       STX $96,Y
6D73:96 96       STX $96,Y
6D75:96 96       STX $96,Y
6D77:96 96       STX $96,Y
6D79:96 96       STX $96,Y
6D7B:96 96       STX $96,Y
6D7D:96 96       STX $96,Y
6D7F:96 96       STX $96,Y
6D81:96 96       STX $96,Y
6D83:96 96       STX $96,Y
6D85:96 96       STX $96,Y
6D87:96 96       STX $96,Y
6D89:96 96       STX $96,Y
6D8B:96 96       STX $96,Y
6D8D:96 96       STX $96,Y
6D8F:96 96       STX $96,Y
6D91:96 96       STX $96,Y
6D93:96 96       STX $96,Y
6D95:96 96       STX $96,Y
6D97:96 96       STX $96,Y
6D99:96 96       STX $96,Y
6D9B:96 96       STX $96,Y
6D9D:96 96       STX $96,Y
6D9F:96 96       STX $96,Y
6DA1:96 96       STX $96,Y
6DA3:96 96       STX $96,Y
6DA5:96 96       STX $96,Y
6DA7:96 96       STX $96,Y
6DA9:96 96       STX $96,Y
6DAB:96 96       STX $96,Y
6DAD:96 96       STX $96,Y
6DAF:96 96       STX $96,Y
6DB1:96 96       STX $96,Y
6DB3:96 96       STX $96,Y
6DB5:96 96       STX $96,Y
6DB7:96 96       STX $96,Y
6DB9:96 96       STX $96,Y
6DBB:96 96       STX $96,Y
6DBD:96 96       STX $96,Y
6DBF:96 96       STX $96,Y
6DC1:96 96       STX $96,Y
6DC3:96 96       STX $96,Y
6DC5:96 96       STX $96,Y
6DC7:96 96       STX $96,Y
6DC9:96 96       STX $96,Y
6DCB:96 96       STX $96,Y
6DCD:96 96       STX $96,Y
6DCF:96 96       STX $96,Y
6DD1:96 96       STX $96,Y
6DD3:96 96       STX $96,Y
6DD5:96 96       STX $96,Y
6DD7:96 96       STX $96,Y
6DD9:96 96       STX $96,Y
6DDB:96 96       STX $96,Y
6DDD:96 96       STX $96,Y
6DDF:96 96       STX $96,Y
6DE1:96 96       STX $96,Y
6DE3:96 96       STX $96,Y
6DE5:96 96       STX $96,Y
6DE7:96 96       STX $96,Y
6DE9:96 96       STX $96,Y
6DEB:96 96       STX $96,Y
6DED:96 96       STX $96,Y
6DEF:96 96       STX $96,Y
6DF1:96 96       STX $96,Y
6DF3:96 96       STX $96,Y
6DF5:96 96       STX $96,Y
6DF7:96 96       STX $96,Y
6DF9:96 96       STX $96,Y
6DFB:96 96       STX $96,Y
6DFD:96 96       STX $96,Y
6DFF:96 96       STX $96,Y
6E01:96 96       STX $96,Y
6E03:96 96       STX $96,Y
6E05:96 96       STX $96,Y
6E07:96 96       STX $96,Y
6E09:96 96       STX $96,Y
6E0B:96 96       STX $96,Y
6E0D:96 96       STX $96,Y
6E0F:96 AA       STX $AA,Y
6E11:DE EB 7F    DEC $7FEB,X
6E14:7F                   ???
6E15:A7                   ???
6E16:7F                   ???
6E17:FE FE FE    INC $FEFE,X
6E1A:FE FE FE    INC $FEFE,X
6E1D:FE FE FE    INC $FEFE,X
6E20:FE FE FE    INC $FEFE,X
6E23:FE FE D5    INC $D5FE,X
6E26:AA          TAX
6E27:96 FF       STX $FF,Y
6E29:FE AB AB    INC $ABAB,X
6E2C:AE AA FA    LDX $FAAA
6E2F:FF                   ???
6E30:AA          TAX
6E31:DE 7F 7F    DEC $7F7F,X
6E34:FC                   ???
6E35:FE FE FE    INC $FEFE,X
6E38:FE D5 AA    INC $AAD5,X
6E3B:AD 96 96    LDA $9696
6E3E:96 96       STX $96,Y
6E40:96 96       STX $96,Y
6E42:96 96       STX $96,Y
6E44:96 96       STX $96,Y
6E46:96 96       STX $96,Y
6E48:96 96       STX $96,Y
6E4A:96 96       STX $96,Y
6E4C:96 96       STX $96,Y
6E4E:96 96       STX $96,Y
6E50:96 96       STX $96,Y
6E52:96 96       STX $96,Y
6E54:96 96       STX $96,Y
6E56:96 96       STX $96,Y
6E58:96 96       STX $96,Y
6E5A:96 96       STX $96,Y
6E5C:96 96       STX $96,Y
6E5E:96 96       STX $96,Y
6E60:96 96       STX $96,Y
6E62:96 96       STX $96,Y
6E64:96 96       STX $96,Y
6E66:96 96       STX $96,Y
6E68:96 96       STX $96,Y
6E6A:96 96       STX $96,Y
6E6C:96 96       STX $96,Y
6E6E:96 96       STX $96,Y
6E70:96 96       STX $96,Y
6E72:96 96       STX $96,Y
6E74:96 96       STX $96,Y
6E76:96 96       STX $96,Y
6E78:96 96       STX $96,Y
6E7A:96 96       STX $96,Y
6E7C:96 96       STX $96,Y
6E7E:96 96       STX $96,Y
6E80:96 96       STX $96,Y
6E82:96 96       STX $96,Y
6E84:96 96       STX $96,Y
6E86:96 96       STX $96,Y
6E88:96 96       STX $96,Y
6E8A:96 96       STX $96,Y
6E8C:96 96       STX $96,Y
6E8E:96 96       STX $96,Y
6E90:96 96       STX $96,Y
6E92:96 96       STX $96,Y
6E94:96 96       STX $96,Y
6E96:96 96       STX $96,Y
6E98:96 96       STX $96,Y
6E9A:96 96       STX $96,Y
6E9C:96 96       STX $96,Y
6E9E:96 96       STX $96,Y
6EA0:96 96       STX $96,Y
6EA2:96 96       STX $96,Y
6EA4:96 96       STX $96,Y
6EA6:96 96       STX $96,Y
6EA8:96 96       STX $96,Y
6EAA:96 96       STX $96,Y
6EAC:96 96       STX $96,Y
6EAE:96 96       STX $96,Y
6EB0:96 96       STX $96,Y
6EB2:96 96       STX $96,Y
6EB4:96 96       STX $96,Y
6EB6:96 96       STX $96,Y
6EB8:96 96       STX $96,Y
6EBA:96 96       STX $96,Y
6EBC:96 96       STX $96,Y
6EBE:96 96       STX $96,Y
6EC0:96 96       STX $96,Y
6EC2:96 96       STX $96,Y
6EC4:96 96       STX $96,Y
6EC6:96 96       STX $96,Y
6EC8:96 96       STX $96,Y
6ECA:96 96       STX $96,Y
6ECC:96 96       STX $96,Y
6ECE:96 96       STX $96,Y
6ED0:96 96       STX $96,Y
6ED2:96 96       STX $96,Y
6ED4:96 96       STX $96,Y
6ED6:96 96       STX $96,Y
6ED8:96 96       STX $96,Y
6EDA:96 96       STX $96,Y
6EDC:96 96       STX $96,Y
6EDE:96 96       STX $96,Y
6EE0:96 96       STX $96,Y
6EE2:96 96       STX $96,Y
6EE4:96 96       STX $96,Y
6EE6:96 96       STX $96,Y
6EE8:96 96       STX $96,Y
6EEA:96 96       STX $96,Y
6EEC:96 96       STX $96,Y
6EEE:96 96       STX $96,Y
6EF0:96 96       STX $96,Y
6EF2:96 96       STX $96,Y
6EF4:96 96       STX $96,Y
6EF6:96 96       STX $96,Y
6EF8:96 96       STX $96,Y
6EFA:96 96       STX $96,Y
6EFC:96 96       STX $96,Y
6EFE:96 96       STX $96,Y
6F00:96 96       STX $96,Y
6F02:96 96       STX $96,Y
6F04:96 96       STX $96,Y
6F06:96 96       STX $96,Y
6F08:96 96       STX $96,Y
6F0A:96 96       STX $96,Y
6F0C:96 96       STX $96,Y
6F0E:96 96       STX $96,Y
6F10:96 96       STX $96,Y
6F12:96 96       STX $96,Y
6F14:96 96       STX $96,Y
6F16:96 96       STX $96,Y
6F18:96 96       STX $96,Y
6F1A:96 96       STX $96,Y
6F1C:96 96       STX $96,Y
6F1E:96 96       STX $96,Y
6F20:96 96       STX $96,Y
6F22:96 96       STX $96,Y
6F24:96 96       STX $96,Y
6F26:96 96       STX $96,Y
6F28:96 96       STX $96,Y
6F2A:96 96       STX $96,Y
6F2C:96 96       STX $96,Y
6F2E:96 96       STX $96,Y
6F30:96 96       STX $96,Y
6F32:96 96       STX $96,Y
6F34:96 96       STX $96,Y
6F36:96 96       STX $96,Y
6F38:96 96       STX $96,Y
6F3A:96 96       STX $96,Y
6F3C:96 96       STX $96,Y
6F3E:96 96       STX $96,Y
6F40:96 96       STX $96,Y
6F42:96 96       STX $96,Y
6F44:96 96       STX $96,Y
6F46:96 96       STX $96,Y
6F48:96 96       STX $96,Y
6F4A:96 96       STX $96,Y
6F4C:96 96       STX $96,Y
6F4E:96 96       STX $96,Y
6F50:96 96       STX $96,Y
6F52:96 96       STX $96,Y
6F54:96 96       STX $96,Y
6F56:96 96       STX $96,Y
6F58:96 96       STX $96,Y
6F5A:96 96       STX $96,Y
6F5C:96 96       STX $96,Y
6F5E:96 96       STX $96,Y
6F60:96 96       STX $96,Y
6F62:96 96       STX $96,Y
6F64:96 96       STX $96,Y
6F66:96 96       STX $96,Y
6F68:96 96       STX $96,Y
6F6A:96 96       STX $96,Y
6F6C:96 96       STX $96,Y
6F6E:96 96       STX $96,Y
6F70:96 96       STX $96,Y
6F72:96 96       STX $96,Y
6F74:96 96       STX $96,Y
6F76:96 96       STX $96,Y
6F78:96 96       STX $96,Y
6F7A:96 96       STX $96,Y
6F7C:96 96       STX $96,Y
6F7E:96 96       STX $96,Y
6F80:96 96       STX $96,Y
6F82:96 96       STX $96,Y
6F84:96 96       STX $96,Y
6F86:96 96       STX $96,Y
6F88:96 96       STX $96,Y
6F8A:96 96       STX $96,Y
6F8C:96 96       STX $96,Y
6F8E:96 96       STX $96,Y
6F90:96 96       STX $96,Y
6F92:96 AA       STX $AA,Y
6F94:DE EB 7F    DEC $7FEB,X
6F97:CA          DEX
6F98:FF                   ???
6F99:FE FE FE    INC $FEFE,X
6F9C:FE FE FE    INC $FEFE,X
6F9F:FE FE FE    INC $FEFE,X
6FA2:FE FE FE    INC $FEFE,X
6FA5:FE FE D5    INC $D5FE,X
6FA8:AA          TAX
6FA9:96 FF       STX $FF,Y
6FAB:FE AB AB    INC $ABAB,X
6FAE:AE AB FA    LDX $FAAB
6FB1:FE AA DE    INC $DEAA,X
6FB4:7F                   ???
6FB5:7F                   ???
6FB6:9F                   ???
6FB7:7F                   ???
6FB8:7F                   ???
6FB9:FE FE FE    INC $FEFE,X
6FBC:D5 AA       CMP $AA,X
6FBE:AD 96 96    LDA $9696
6FC1:96 96       STX $96,Y
6FC3:96 96       STX $96,Y
6FC5:96 96       STX $96,Y
6FC7:96 96       STX $96,Y
6FC9:96 96       STX $96,Y
6FCB:96 96       STX $96,Y
6FCD:96 96       STX $96,Y
6FCF:96 96       STX $96,Y
6FD1:96 96       STX $96,Y
6FD3:96 96       STX $96,Y
6FD5:96 96       STX $96,Y
6FD7:96 96       STX $96,Y
6FD9:96 96       STX $96,Y
6FDB:96 96       STX $96,Y
6FDD:96 96       STX $96,Y
6FDF:96 96       STX $96,Y
6FE1:96 96       STX $96,Y
6FE3:96 96       STX $96,Y
6FE5:96 96       STX $96,Y
6FE7:96 96       STX $96,Y
6FE9:96 96       STX $96,Y
6FEB:96 96       STX $96,Y
6FED:96 96       STX $96,Y
6FEF:96 96       STX $96,Y
6FF1:96 96       STX $96,Y
6FF3:96 96       STX $96,Y
6FF5:96 96       STX $96,Y
6FF7:96 96       STX $96,Y
6FF9:96 96       STX $96,Y
6FFB:96 96       STX $96,Y
6FFD:96 96       STX $96,Y
6FFF:96 	     ???
7000:6C 00 13    JMP ($1300) =>6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)		
7003:6C 40 13    JMP ($1340) =>1400
7006:6C 42 13    JMP ($1342) =>1494
; Ecriture dans la mêmoire graphique du caractère
7009:84 DC       STY $DC
700B:86 DE       STX $DE
700D:A9 08       LDA #$08
700F:85 4A       STA $4A			; nb d'octets à récupérer pour un caractère
7011:A2 00       LDX #$00
7013:A4 DC       LDY $DC
7015:20 00 70    JSR $7000
7018:A4 DE       LDY $DE
701A:A1 E8       LDA ($E8,X)		; Récupèration de la table graphique du caractère
701C:91 4C       STA ($4C),Y		; Ecriture à l'octets Y 
701E:E6 E8       INC $E8			
7020:D0 02       BNE $7024
7022:E6 E9       INC $E9			; On se position au prochain octet à récupérer
7024:E6 DC       INC $DC
7026:C6 4A       DEC $4A			; boucle nb de d'octets à récupérer
7028:D0 E9       BNE $7013
702A:60          RTS
; Récupération de l'adresse où se trouve le bitmap du caractères à afficher ($E8)
702B:0A          ASL				; Shift Left de A 
702C:A8          TAY
702D:B1 80       LDA ($80),Y
702F:85 E8       STA $E8
7031:C8          INY
7032:B1 80       LDA ($80),Y
7034:85 E9       STA $E9
7036:60          RTS
; Traitement du HighScore on l'ajuste si score Joueur 1 plus élevé
7037:A2 05       LDX #$05
7039:CA          DEX
703A:B5 99       LDA $99,X
703C:D5 94       CMP $94,X		
703E:90 12       BCC $7052		; si inférieur on sort
7040:F0 0C       BEQ $704E		; si égale on continue les tests
7042:A2 00       LDX #$00		; sinon on sauvegarde le hisghscore
7044:B5 99       LDA $99,X		; transfert du score player 1
7046:95 94       STA $94,X		; dans $94=>$98
7048:E8          INX
7049:E0 05       CPX #$05
704B:90 F7       BCC $7044
704D:60          RTS
704E:E0 00       CPX #$00		; vérifie que l'on a bien testé tout le score
7050:D0 E7       BNE $7039
7052:60          RTS
; Traitement du HighScore on l'ajuste si score Joueur 2 plus élevé
7053:A2 05       LDX #$05
7055:CA          DEX
7056:B5 9E       LDA $9E,X
7058:D5 94       CMP $94,X
705A:90 12       BCC $706E
705C:F0 0C       BEQ $706A
705E:A2 00       LDX #$00
7060:B5 9E       LDA $9E,X
7062:95 94       STA $94,X
7064:E8          INX
7065:E0 05       CPX #$05
7067:90 F7       BCC $7060
7069:60          RTS
706A:E0 00       CPX #$00
706C:D0 E7       BNE $7055
706E:60          RTS
;
706F:A5 46       LDA $46		; Registre du player en cours
7071:C9 02       CMP #$02		; Player 2?
7073:F0 5D       BEQ $70D2		;OUI
7075:A2 00       LDX #$00		; Traitement Player1
7077:B5 90       LDA $90,X
7079:18          CLC
707A:75 99       ADC $99,X
707C:95 99       STA $99,X
707E:E8          INX
707F:E0 03       CPX #$03
7081:90 F4       BCC $7077		; Branchement si Inférieur strictement
7083:A5 9C       LDA $9C
7085:85 C3       STA $C3
7087:A2 00       LDX #$00
7089:B5 99       LDA $99,X
708B:C9 0A       CMP #$0A
708D:90 07       BCC $7096
708F:F6 9A       INC $9A,X
7091:38          SEC
7092:E9 0A       SBC #$0A
7094:95 99       STA $99,X
7096:E8          INX
7097:E0 05       CPX #$05
7099:90 EE       BCC $7089
709B:A5 9D       LDA $9D
709D:C9 0A       CMP #$0A
709F:90 04       BCC $70A5
70A1:A9 00       LDA #$00
70A3:85 9D       STA $9D
70A5:A5 9C       LDA $9C
70A7:C5 C3       CMP $C3
70A9:F0 06       BEQ $70B1
70AB:C9 01       CMP #$01
70AD:D0 04       BNE $70B3
70AF:E6 42       INC $42
70B1:A2 03       LDX #$03
70B3:B5 A3       LDA $A3,X
70B5:C9 0A       CMP #$0A
70B7:90 06       BCC $70BF
70B9:A9 09       LDA #$09
70BB:95 A3       STA $A3,X
70BD:D6 A2       DEC $A2,X
70BF:CA          DEX
70C0:D0 F1       BNE $70B3
70C2:A5 A3       LDA $A3
70C4:C9 0A       CMP #$0A
70C6:90 04       BCC $70CC
70C8:A9 09       LDA #$09
70CA:85 A3       STA $A3
70CC:20 37 70    JSR $7037
70CF:4C 2C 71    JMP $712C
70D2:A2 00       LDX #$00		; Traitement Player 2
70D4:B5 90       LDA $90,X
70D6:18          CLC
70D7:75 9E       ADC $9E,X
70D9:95 9E       STA $9E,X
70DB:E8          INX
70DC:E0 03       CPX #$03
70DE:90 F4       BCC $70D4
70E0:A5 A1       LDA $A1
70E2:85 C3       STA $C3
70E4:A2 00       LDX #$00
70E6:B5 9E       LDA $9E,X
70E8:C9 0A       CMP #$0A
70EA:90 07       BCC $70F3
70EC:F6 9F       INC $9F,X
70EE:38          SEC
70EF:E9 0A       SBC #$0A
70F1:95 9E       STA $9E,X
70F3:E8          INX
70F4:E0 05       CPX #$05
70F6:90 EE       BCC $70E6
70F8:A5 A2       LDA $A2
70FA:C9 0A       CMP #$0A
70FC:90 04       BCC $7102
70FE:A9 00       LDA #$00
7100:85 A2       STA $A2
7102:A5 A1       LDA $A1
7104:C5 C3       CMP $C3
7106:F0 06       BEQ $710E
7108:C9 01       CMP #$01
710A:D0 02       BNE $710E
710C:E6 43       INC $43
710E:A2 03       LDX #$03
7110:B5 A7       LDA $A7,X
7112:C9 0A       CMP #$0A
7114:90 06       BCC $711C
7116:A9 09       LDA #$09
7118:95 A7       STA $A7,X
711A:D6 A6       DEC $A6,X
711C:CA          DEX
711D:D0 F1       BNE $7110
711F:A5 A7       LDA $A7
7121:C9 0A       CMP #$0A
7123:90 04       BCC $7129
7125:A9 09       LDA #$09
7127:85 A7       STA $A7
7129:20 53 70    JSR $7053
712C:A9 00       LDA #$00
712E:85 90       STA $90
7130:85 91       STA $91
7132:85 92       STA $92
7134:60          RTS
7135:A9 DE       LDA #$DE
7137:A0 74       LDY #$74
7139:A2 00       LDX #$00
713B:20 FF 71    JSR $71FF
713E:60          RTS
713F:A9 00       LDA #$00
7141:A0 75       LDY #$75
7143:A2 00       LDX #$00
7145:20 FF 71    JSR $71FF
7148:60          RTS
;
7149:A9 50       LDA #$50		; Charge la table des adresses de caractères ($80)
714B:85 80       STA $80
714D:A9 18       LDA #$18
714F:85 81       STA $81
7151:60          RTS
;
7152:20 49 71    JSR $7149		;Charge la table des adresses de caractères ($80)
7155:20 35 71    JSR $7135
7158:A5 41       LDA $41
715A:C9 02       CMP #$02
715C:90 03       BCC $7161
715E:20 3F 71    JSR $713F
7161:A9 47       LDA #$47
7163:A0 75       LDY #$75
7165:A2 00       LDX #$00
7167:20 FF 71    JSR $71FF
716A:60          RTS
716B:A5 3A       LDA $3A
716D:D0 0E       BNE $717D
716F:A5 BF       LDA $BF
7171:D0 0B       BNE $717E
7173:A5 41       LDA $41
7175:C9 01       CMP #$01
7177:F0 04       BEQ $717D
7179:A5 CE       LDA $CE
717B:D0 01       BNE $717E
717D:60          RTS
717E:2C 10 C0    BIT $C010
7181:A9 00       LDA #$00
7183:8D FE 71    STA $71FE
7186:20 49 71    JSR $7149		;Charge la table des adresses de caractères ($80)
7189:A5 CE       LDA $CE
718B:F0 09       BEQ $7196
718D:A9 F3       LDA #$F3
718F:A0 75       LDY #$75
7191:A2 08       LDX #$08
7193:20 FF 71    JSR $71FF
7196:A5 46       LDA $46
7198:C9 01       CMP #$01
719A:D0 22       BNE $71BE
719C:20 DC 71    JSR $71DC
719F:20 ED 71    JSR $71ED
71A2:20 35 71    JSR $7135
71A5:20 ED 71    JSR $71ED
71A8:AD FE 71    LDA $71FE
71AB:C9 0A       CMP #$0A
71AD:B0 05       BCS $71B4
71AF:AD 00 C0    LDA $C000
71B2:10 E8       BPL $719C
71B4:2C 10 C0    BIT $C010
71B7:A9 00       LDA #$00
71B9:85 BF       STA $BF
71BB:85 CE       STA $CE
71BD:60          RTS
71BE:20 E3 71    JSR $71E3
71C1:20 ED 71    JSR $71ED
71C4:20 3F 71    JSR $713F
71C7:20 ED 71    JSR $71ED
71CA:AD FE 71    LDA $71FE
71CD:C9 0A       CMP #$0A
71CF:B0 E3       BCS $71B4
71D1:AD 00 C0    LDA $C000
71D4:0D 61 C0    ORA $C061
71D7:10 E5       BPL $71BE
71D9:4C B4 71    JMP $71B4
71DC:A9 F1       LDA #$F1
71DE:A0 74       LDY #$74
71E0:4C E7 71    JMP $71E7
71E3:A9 13       LDA #$13
71E5:A0 75       LDY #$75
71E7:A2 00       LDX #$00
71E9:20 FF 71    JSR $71FF
71EC:60          RTS
71ED:EE FE 71    INC $71FE
71F0:A9 02       LDA #$02
71F2:85 C3       STA $C3
71F4:A9 FF       LDA #$FF
71F6:20 A8 FC    JSR $FCA8
71F9:C6 C3       DEC $C3
71FB:D0 F7       BNE $71F4
71FD:60          RTS
71FE:00          BRK
;
71FF:85 84       STA $84		; Adresse des choses à écrire sur l'écran ($84)
7201:84 85       STY $85		; 
7203:8E 2E 72    STX $722E		; 
7206:A0 00       LDY #$00
7208:8C 0C 72    STY $720C		; On tape direct dans le code pour mettre #00 dans Y (?)
720B:A0 14       LDY #$14
720D:B1 84       LDA ($84),Y
720F:C9 FF       CMP #$FF
7211:90 01       BCC $7214
7213:60          RTS
7214:C8          INY
7215:8C 0C 72    STY $720C		; On incrémente Y et on met directe dans le code la valeur
7218:20 2B 70    JSR $702B		; On récupère dans ($E8) l'adresse du bitmap du caractère A
721B:AC 0C 72    LDY $720C		; On récupère Y après avoir salement sauvegarder dans le code sa valeur (!)
721E:B1 84       LDA ($84),Y
7220:C8          INY
7221:8C 0C 72    STY $720C
7224:AC 2E 72    LDY $722E		; On récupère la valeur de X du début
7227:AA          TAX
7228:20 09 70    JSR $7009
722B:4C 0B 72    JMP $720B
722E:00          >REGISTRE MEMOIRE<
; Bande noire haut et bas de l'écran d'acceuil
722F:A0 A6       LDY #$A6
7231:84 4A       STY $4A
7233:A4 4A       LDY $4A
7235:C0 C0       CPY #$C0		; Remplir de noir les lignes de 166 à 192
7237:B0 13       BCS $724C
7239:20 00 70    JSR $7000
723C:A0 00       LDY #$00
723E:A9 00       LDA #$00
7240:91 4C       STA ($4C),Y
7242:C8          INY
7243:C0 28       CPY #$28
7245:90 F9       BCC $7240
7247:E6 4A       INC $4A
7249:4C 33 72    JMP $7233		; Boucle sur les lignes noires du bas
724C:20 87 72    JSR $7287
724F:20 49 71    JSR $7149		;Charge la table des adresses de caractères ($80)
7252:A9 5C       LDA #$5C
7254:A0 75       LDY #$75
7256:A2 A8       LDX #$A8
7258:20 FF 71    JSR $71FF
725B:A9 8D       LDA #$8D
725D:A0 75       LDY #$75
725F:A2 B0       LDX #$B0
7261:20 FF 71    JSR $71FF
7264:A9 22       LDA #$22
7266:A0 75       LDY #$75
7268:A2 03       LDX #$03
726A:20 FF 71    JSR $71FF
;
726D:A9 B0       LDA #$B0
726F:A0 75       LDY #$75
7271:A2 B8       LDX #$B8
7273:20 FF 71    JSR $71FF
7276:60          RTS
;
7277:20 49 71    JSR $7149		;Charge la table des adresses de caractères ($80)
727A:20 6D 72    JSR $726D
727D:A9 F3       LDA #$F3
727F:A0 75       LDY #$75
7281:A2 08       LDX #$08
7283:20 FF 71    JSR $71FF
7286:60          RTS
; Rempli les lignes en noires de 0 à 16
7287:A0 00       LDY #$00
7289:84 4A       STY $4A
728B:A4 4A       LDY $4A
728D:C0 10       CPY #$10
728F:90 01       BCC $7292
7291:60          RTS
7292:20 00 70    JSR $7000
7295:A0 00       LDY #$00
7297:A9 00       LDA #$00
7299:91 4C       STA ($4C),Y
729B:C8          INY
729C:C0 28       CPY #$28
729E:90 F9       BCC $7299
72A0:E6 4A       INC $4A
72A2:4C 8B 72    JMP $728B
72A5:20 49 71    JSR $7149		;>↑> Charge la table des adresses de caractères ($80)
72A8:A9 B2       LDA #$B2		; Adresse des écritures à mettre $72B2
72AA:A0 72       LDY #$72
72AC:A2 3C       LDX #$3C		; ligne d'écriture?
72AE:20 FF 71    JSR $71FF
72B1:60          RTS
; Table des choses à écrire sur la page d'acceuil
72B2:00          BRK
72B3:14                   ???
72B4:04                   ???
72B5:15 09       ORA $09,X
72B7:16 16       ASL $16,X
72B9:17                   ???
72BA:09 18       ORA #$18
72BC:0E 19 07    ASL $0719
72BF:1A                   ???
72C0:00          BRK
72C1:1B                   ???
72C2:FF                   ???
72C3:A9 86       LDA #$86
72C5:85 80       STA $80
72C7:A9 18       LDA #$18
72C9:85 81       STA $81
72CB:A9 00       LDA #$00
72CD:85 C3       STA $C3
72CF:A5 9D       LDA $9D
72D1:F0 05       BEQ $72D8
72D3:85 C3       STA $C3
72D5:4C DE 72    JMP $72DE
72D8:A4 C3       LDY $C3
72DA:D0 02       BNE $72DE
72DC:A9 11       LDA #$11
72DE:20 2B 70    JSR $702B
72E1:A0 08       LDY #$08
72E3:A2 02       LDX #$02
72E5:20 09 70    JSR $7009
72E8:A5 9C       LDA $9C
72EA:F0 05       BEQ $72F1
72EC:85 C3       STA $C3
72EE:4C F7 72    JMP $72F7
72F1:A4 C3       LDY $C3
72F3:D0 02       BNE $72F7
72F5:A9 11       LDA #$11
72F7:20 2B 70    JSR $702B
72FA:A0 08       LDY #$08
72FC:A2 03       LDX #$03
72FE:20 09 70    JSR $7009
7301:A5 9B       LDA $9B
7303:F0 05       BEQ $730A
7305:85 C3       STA $C3
7307:4C 10 73    JMP $7310
730A:A4 C3       LDY $C3
730C:D0 02       BNE $7310
730E:A9 11       LDA #$11
7310:20 2B 70    JSR $702B
7313:A0 08       LDY #$08
7315:A2 04       LDX #$04
7317:20 09 70    JSR $7009
731A:A5 9A       LDA $9A
731C:F0 05       BEQ $7323
731E:85 C3       STA $C3
7320:4C 29 73    JMP $7329
7323:A4 C3       LDY $C3
7325:D0 02       BNE $7329
7327:A9 11       LDA #$11
7329:20 2B 70    JSR $702B
732C:A0 08       LDY #$08
732E:A2 05       LDX #$05
7330:20 09 70    JSR $7009
7333:A5 99       LDA $99
7335:F0 05       BEQ $733C
7337:85 C3       STA $C3
7339:4C 42 73    JMP $7342
733C:A4 C3       LDY $C3
733E:D0 02       BNE $7342
7340:A9 11       LDA #$11
7342:20 2B 70    JSR $702B
7345:A0 08       LDY #$08
7347:A2 06       LDX #$06
7349:20 09 70    JSR $7009
734C:A9 07       LDA #$07
734E:20 CF 74    JSR $74CF
7351:A5 2D       LDA $2D
7353:D0 04       BNE $7359
7355:A5 2C       LDA $2C
7357:D0 15       BNE $736E
7359:A5 42       LDA $42		; Charge le nombre de vies restantes du joueur 1
735B:A4 46       LDY $46		; Charge l'identifiant du joueur courant (1 ou 2)
735D:C0 01       CPY #$01		; Vérifie si c'est le joueur 1
735F:D0 03       BNE $7364		; Si ce n'est pas le joueur 1, saute à $7364
7361:38          SEC			; Sinon, décrémente la vie du joueur 1
7362:E9 01       SBC #$01		
7364:20 2B 70    JSR $702B
7367:A0 00       LDY #$00
7369:A2 0C       LDX #$0C
736B:20 09 70    JSR $7009
736E:A5 41       LDA $41		; Charge le nombre de joueurs
7370:C9 02       CMP #$02		; Vérifie s'il y a deux joueurs
7372:B0 03       BCS $7377		; Si c'est supérieur ou égale à 2, passe à $7377
7374:4C 1A 74    JMP $741A		; Si c'est un seul joueur, saute à $741A
7377:A9 00       LDA #$00
7379:85 C3       STA $C3
737B:A5 A2       LDA $A2
737D:F0 05       BEQ $7384
737F:85 C3       STA $C3
7381:4C 8A 73    JMP $738A
7384:A4 C3       LDY $C3
7386:D0 02       BNE $738A
7388:A9 11       LDA #$11
738A:20 2B 70    JSR $702B
738D:A0 08       LDY #$08
738F:A2 20       LDX #$20
7391:20 09 70    JSR $7009
7394:A5 A1       LDA $A1
7396:F0 05       BEQ $739D
7398:85 C3       STA $C3
739A:4C A3 73    JMP $73A3
739D:A4 C3       LDY $C3
739F:D0 02       BNE $73A3
73A1:A9 11       LDA #$11
73A3:20 2B 70    JSR $702B
73A6:A0 08       LDY #$08
73A8:A2 21       LDX #$21
73AA:20 09 70    JSR $7009
73AD:A5 A0       LDA $A0
73AF:F0 05       BEQ $73B6
73B1:85 C3       STA $C3
73B3:4C BC 73    JMP $73BC
73B6:A4 C3       LDY $C3
73B8:D0 02       BNE $73BC
73BA:A9 11       LDA #$11
73BC:20 2B 70    JSR $702B
73BF:A0 08       LDY #$08
73C1:A2 22       LDX #$22
73C3:20 09 70    JSR $7009
73C6:A5 9F       LDA $9F
73C8:F0 05       BEQ $73CF
73CA:85 C3       STA $C3
73CC:4C D5 73    JMP $73D5
73CF:A4 C3       LDY $C3
73D1:D0 02       BNE $73D5
73D3:A9 11       LDA #$11
73D5:20 2B 70    JSR $702B
73D8:A0 08       LDY #$08
73DA:A2 23       LDX #$23
73DC:20 09 70    JSR $7009
73DF:A5 9E       LDA $9E
73E1:F0 05       BEQ $73E8
73E3:85 C3       STA $C3
73E5:4C EE 73    JMP $73EE
73E8:A4 C3       LDY $C3
73EA:D0 02       BNE $73EE
73EC:A9 11       LDA #$11
73EE:20 2B 70    JSR $702B
73F1:A0 08       LDY #$08
73F3:A2 24       LDX #$24
73F5:20 09 70    JSR $7009
73F8:A9 25       LDA #$25
73FA:20 CF 74    JSR $74CF
73FD:A5 2D       LDA $2D
73FF:D0 04       BNE $7405
7401:A5 2C       LDA $2C
7403:D0 15       BNE $741A
7405:A5 43       LDA $43		; Charge le nombre de vies restantes du joueur 2
7407:A4 46       LDY $46		; Identifiant du joueur en cours
7409:C0 02       CPY #$02		; Vérifie si c'est le joueur 2
740B:D0 03       BNE $7410		; Si non, passe à $7410
740D:38          SEC			
740E:E9 01       SBC #$01		; Retire une vie au joueur 2
7410:20 2B 70    JSR $702B
7413:A0 00       LDY #$00
7415:A2 1C       LDX #$1C
7417:20 09 70    JSR $7009
741A:A9 00       LDA #$00
741C:85 C3       STA $C3
741E:A5 46       LDA $46
7420:C9 02       CMP #$02
7422:F0 4E       BEQ $7472
7424:A5 A3       LDA $A3
7426:F0 05       BEQ $742D
7428:85 C3       STA $C3
742A:4C 33 74    JMP $7433
742D:A4 C3       LDY $C3
742F:D0 02       BNE $7433
7431:A9 11       LDA #$11
7433:20 2B 70    JSR $702B
7436:A0 08       LDY #$08
7438:A2 12       LDX #$12
743A:20 09 70    JSR $7009
743D:A5 A4       LDA $A4
743F:F0 05       BEQ $7446
7441:85 C3       STA $C3
7443:4C 4C 74    JMP $744C
7446:A4 C3       LDY $C3
7448:D0 02       BNE $744C
744A:A9 11       LDA #$11
744C:20 2B 70    JSR $702B
744F:A0 08       LDY #$08
7451:A2 13       LDX #$13
7453:20 09 70    JSR $7009
7456:A5 A5       LDA $A5
7458:F0 05       BEQ $745F
745A:85 C3       STA $C3
745C:4C 65 74    JMP $7465
745F:A4 C3       LDY $C3
7461:D0 02       BNE $7465
7463:A9 11       LDA #$11
7465:20 2B 70    JSR $702B
7468:A0 08       LDY #$08
746A:A2 14       LDX #$14
746C:20 09 70    JSR $7009
746F:4C BD 74    JMP $74BD
7472:A5 A7       LDA $A7
7474:F0 05       BEQ $747B
7476:85 C3       STA $C3
7478:4C 81 74    JMP $7481
747B:A4 C3       LDY $C3
747D:D0 02       BNE $7481
747F:A9 11       LDA #$11
7481:20 2B 70    JSR $702B
7484:A0 08       LDY #$08
7486:A2 12       LDX #$12
7488:20 09 70    JSR $7009
748B:A5 A8       LDA $A8
748D:F0 05       BEQ $7494
748F:85 C3       STA $C3
7491:4C 9A 74    JMP $749A
7494:A4 C3       LDY $C3
7496:D0 02       BNE $749A
7498:A9 11       LDA #$11
749A:20 2B 70    JSR $702B
749D:A0 08       LDY #$08
749F:A2 13       LDX #$13
74A1:20 09 70    JSR $7009
74A4:A5 A9       LDA $A9
74A6:F0 05       BEQ $74AD
74A8:85 C3       STA $C3
74AA:4C B3 74    JMP $74B3
74AD:A4 C3       LDY $C3
74AF:D0 02       BNE $74B3
74B1:A9 11       LDA #$11
74B3:20 2B 70    JSR $702B
74B6:A0 08       LDY #$08
74B8:A2 14       LDX #$14
74BA:20 09 70    JSR $7009
74BD:A9 15       LDA #$15
74BF:20 CF 74    JSR $74CF
74C2:A9 11       LDA #$11
74C4:20 2B 70    JSR $702B
74C7:A0 08       LDY #$08
74C9:A2 11       LDX #$11
74CB:20 09 70    JSR $7009
74CE:60          RTS
74CF:8D DA 74    STA $74DA
74D2:A9 00       LDA #$00
74D4:20 2B 70    JSR $702B
74D7:A0 08       LDY #$08
74D9:A2 15       LDX #$15
74DB:4C 09 70    JMP $7009
74DE:10 01       BPL $74E1
74E0:0C                   ???
74E1:02                   ???
74E2:01 03       ORA ($03,X)
74E4:19 04 05    ORA $0504,Y
74E7:05 12       ORA $12
74E9:06 1C       ASL $1C
74EB:08          PHP
74EC:26 0B       ROL $0B
74EE:27                   ???
74EF:0D FF 00    ORA $00FF
74F2:01 00       ORA ($00,X)
74F4:02                   ???
74F5:00          BRK
74F6:03                   ???
74F7:00          BRK
74F8:04                   ???
74F9:00          BRK
74FA:05 00       ORA $00
74FC:06 00       ASL $00
74FE:08          PHP
74FF:FF                   ???
7500:26 1B       ROL $1B
7502:27                   ???
7503:1D 10 1F    ORA $1F10,X
7506:0C                   ???
7507:20 01 21    JSR $2101
750A:19 22 05    ORA $0522,Y
750D:23                   ???
750E:12                   ???
750F:24 1D       BIT $1D
7511:26 FF       ROL $FF
7513:00          BRK
7514:1F                   ???
7515:00          BRK
7516:20 00 21    JSR $2100
7519:00          BRK
751A:22                   ???
751B:00          BRK
751C:23                   ???
751D:00          BRK
751E:24 00       BIT $00
7520:26 FF       ROL $FF
7522:01 0B       ORA ($0B,X)
7524:14                   ???
7525:0C                   ???
7526:01 0D       ORA ($0D,X)
7528:12                   ???
7529:0E 09 0F    ASL $0F09
752C:13                   ???
752D:10 0F       BPL $753E
752F:11 06       ORA ($06),Y
7531:12                   ???
7532:14                   ???
7533:13                   ???
7534:00          BRK
7535:14                   ???
7536:10 15       BPL $754D
7538:12                   ???
7539:16 05       ASL $05,X
753B:17                   ???
753C:13                   ???
753D:18          CLC
753E:05 19       ORA $19
7540:0E 1A 14    ASL $141A
7543:1B                   ???
7544:13                   ???
7545:1C                   ???
7546:FF                   ???
7547:00          BRK
7548:0F                   ???
7549:00          BRK
754A:10 00       BPL $754C
754C:11 14       ORA ($14),Y
754E:12                   ???
754F:09 13       ORA #$13
7551:0D 14 05    ORA $0514
7554:15 12       ORA $12,X
7556:16 00       ASL $00,X
7558:17                   ???
7559:00          BRK
755A:18          CLC
755B:FF                   ???
755C:26 01       ROL $01
755E:03                   ???
755F:02                   ???
7560:27                   ???
7561:03                   ???
7562:1C                   ???
7563:05 24       ORA $24
7565:06 23       ASL $23
7567:07                   ???
7568:1D 08 14    ORA $1408,X
756B:0A          ASL
756C:01 0B       ORA ($0B,X)
756E:09 0C       ORA #$0C
7570:14                   ???
7571:0D 0F 0E    ORA $0E0F
7574:26 19       ROL $19
7576:03                   ???
7577:1A                   ???
7578:27                   ???
7579:1B                   ???
757A:1C                   ???
757B:1D 24 1E    ORA $1E24,X
757E:23                   ???
757F:1F                   ???
7580:1F                   ???
7581:20 01 22    JSR $2201
7584:14                   ???
7585:23                   ???
7586:01 24       ORA ($24,X)
7588:12                   ???
7589:25 09       AND $09
758B:26 FF       ROL $FF
758D:01 0A       ORA ($0A,X)
758F:0C                   ???
7590:0B                   ???
7591:0C                   ???
7592:0C                   ???
7593:12                   ???
7594:0E 09 0F    ASL $0F09
7597:07                   ???
7598:10 08       BPL $75A2
759A:11 14       ORA ($14),Y
759C:12                   ???
759D:13                   ???
759E:13                   ???
759F:12                   ???
75A0:15 05       ORA $05,X
75A2:16 13       ASL $13,X
75A4:17                   ???
75A5:05 18       ORA $18
75A7:12                   ???
75A8:19 16 1A    ORA $1A16,Y
75AB:05 1B       ORA $1B
75AD:04                   ???
75AE:1C                   ???
75AF:FF                   ???
75B0:10 03       BPL $75B5
75B2:12                   ???
75B3:04                   ???
75B4:05 05       ORA $05
75B6:13                   ???
75B7:06 13       ASL $13
75B9:07                   ???
75BA:00          BRK
75BB:08          PHP
75BC:13                   ???
75BD:09 10       ORA #$10
75BF:0A          ASL
75C0:01 0B       ORA ($0B,X)
75C2:03                   ???
75C3:0C                   ???
75C4:05 0D       ORA $0D
75C6:00          BRK
75C7:0E 02 0F    ASL $0F02
75CA:01 10       ORA ($10,X)
75CC:12                   ???
75CD:11 00       ORA ($00),Y
75CF:12                   ???
75D0:06 13       ASL $13
75D2:0F                   ???
75D3:14                   ???
75D4:12                   ???
75D5:15 00       ORA $00,X
75D7:16 0F       ASL $0F,X
75D9:17                   ???
75DA:10 18       BPL $75F4
75DC:14                   ???
75DD:19 09 1A    ORA $1A09,Y
75E0:0F                   ???
75E1:1B                   ???
75E2:0E 1C 00    ASL $001C
75E5:1D 13 1E    ORA $1E13,X
75E8:03                   ???
75E9:1F                   ???
75EA:12                   ???
75EB:20 05 21    JSR $2105
75EE:05 22       ORA $22
75F0:0E 23 FF    ASL $FF23
75F3:05 0E       ORA $0E
75F5:0E 0F 04    ASL $040F
75F8:10 00       BPL $75FA
75FA:11 0F       ORA ($0F),Y
75FC:12                   ???
75FD:06 13       ASL $13
75FF:00          BRK
7600:14                   ???
7601:07                   ???
7602:15 01       ORA $01,X
7604:16 0D       ASL $0D,X
7606:17                   ???
7607:05 18       ORA $18
7609:FF                   ???
760A:02                   ???
760B:BB                   ???
760C:5A                   ???
760D:30 5F       BMI $766E
760F:EE 3D A8    INC $A83D
7612:96 96       STX $96,Y
7614:96 96       STX $96,Y
7616:96 96       STX $96,Y
7618:96 96       STX $96,Y
761A:96 96       STX $96,Y
761C:96 96       STX $96,Y
761E:96 96       STX $96,Y
7620:96 96       STX $96,Y
7622:96 96       STX $96,Y
7624:96 96       STX $96,Y
7626:96 96       STX $96,Y
7628:96 96       STX $96,Y
762A:96 96       STX $96,Y
762C:96 96       STX $96,Y
762E:96 96       STX $96,Y
7630:96 96       STX $96,Y
7632:96 96       STX $96,Y
7634:96 96       STX $96,Y
7636:96 96       STX $96,Y
7638:96 96       STX $96,Y
763A:96 96       STX $96,Y
763C:96 96       STX $96,Y
763E:96 96       STX $96,Y
7640:96 96       STX $96,Y
7642:96 96       STX $96,Y
7644:96 96       STX $96,Y
7646:96 96       STX $96,Y
7648:96 96       STX $96,Y
764A:96 96       STX $96,Y
764C:96 96       STX $96,Y
764E:96 96       STX $96,Y
7650:96 96       STX $96,Y
7652:96 96       STX $96,Y
7654:96 96       STX $96,Y
7656:96 96       STX $96,Y
7658:96 96       STX $96,Y
765A:96 96       STX $96,Y
765C:96 96       STX $96,Y
765E:96 96       STX $96,Y
7660:96 96       STX $96,Y
7662:96 96       STX $96,Y
7664:96 96       STX $96,Y
7666:96 96       STX $96,Y
7668:96 96       STX $96,Y
766A:96 96       STX $96,Y
766C:96 96       STX $96,Y
766E:96 96       STX $96,Y
7670:96 96       STX $96,Y
7672:96 96       STX $96,Y
7674:96 96       STX $96,Y
7676:96 96       STX $96,Y
7678:96 96       STX $96,Y
767A:96 96       STX $96,Y
767C:96 96       STX $96,Y
767E:96 96       STX $96,Y
7680:96 96       STX $96,Y
7682:96 96       STX $96,Y
7684:96 96       STX $96,Y
7686:96 96       STX $96,Y
7688:96 96       STX $96,Y
768A:96 96       STX $96,Y
768C:96 96       STX $96,Y
768E:96 96       STX $96,Y
7690:96 96       STX $96,Y
7692:96 96       STX $96,Y
7694:96 96       STX $96,Y
7696:96 96       STX $96,Y
7698:96 96       STX $96,Y
769A:96 96       STX $96,Y
769C:96 96       STX $96,Y
769E:96 96       STX $96,Y
76A0:96 96       STX $96,Y
76A2:96 96       STX $96,Y
76A4:96 96       STX $96,Y
76A6:96 96       STX $96,Y
76A8:96 96       STX $96,Y
76AA:96 96       STX $96,Y
76AC:96 96       STX $96,Y
76AE:96 96       STX $96,Y
76B0:96 96       STX $96,Y
76B2:96 96       STX $96,Y
76B4:96 96       STX $96,Y
76B6:96 96       STX $96,Y
76B8:96 96       STX $96,Y
76BA:96 96       STX $96,Y
76BC:96 96       STX $96,Y
76BE:96 96       STX $96,Y
76C0:96 96       STX $96,Y
76C2:96 96       STX $96,Y
76C4:96 96       STX $96,Y
76C6:96 96       STX $96,Y
76C8:96 96       STX $96,Y
76CA:96 96       STX $96,Y
76CC:96 96       STX $96,Y
76CE:96 96       STX $96,Y
76D0:96 96       STX $96,Y
76D2:96 96       STX $96,Y
76D4:96 96       STX $96,Y
76D6:96 96       STX $96,Y
76D8:96 96       STX $96,Y
76DA:96 96       STX $96,Y
76DC:96 96       STX $96,Y
76DE:96 96       STX $96,Y
76E0:96 96       STX $96,Y
76E2:96 96       STX $96,Y
76E4:96 96       STX $96,Y
76E6:96 96       STX $96,Y
76E8:96 96       STX $96,Y
76EA:96 96       STX $96,Y
76EC:96 96       STX $96,Y
76EE:96 96       STX $96,Y
76F0:96 96       STX $96,Y
76F2:96 96       STX $96,Y
76F4:96 96       STX $96,Y
76F6:96 96       STX $96,Y
76F8:96 96       STX $96,Y
76FA:96 96       STX $96,Y
76FC:96 96       STX $96,Y
76FE:96 96       STX $96,Y


; !! ATTENTION LE CODE ACTUEL $7700 est pour le level 1 chargé au tout début 
7700:4C 2D 77    JMP $772D
7703:6C 00 13    JMP ($1300) =>6000		; Routine permettant de mettre dans ($4C) l'emplacement de la ligne Y ($E6 détermine page 1 ou 2)
7706:6C 02 13    JMP ($1302) =>618E
7709:6C 04 13    JMP ($1304) =>63C9
770C:6C 10 13    JMP ($1310) =>65F8
770F:6C 12 13    JMP ($1312) =>65EA
7712:6C 18 13    JMP ($1318) =>6606
7715:6C 1A 13    JMP ($131A) =>661F
7718:6C 1C 13    JMP ($131C) =>6664
771B:6C 20 13    JMP ($1320)
771E:6C 24 13    JMP ($1324)
7721:6C 28 13    JMP ($1328)
7724:6C 2A 13    JMP ($132A)
7727:6C 2C 13    JMP ($132C)
772A:6C 44 13    JMP ($1344)
772D:A5 33       LDA $33
772F:F0 04       BEQ $7735
7731:20 8F 7D    JSR $7D8F
7734:60          RTS
7735:20 4E 77    JSR $774E
7738:20 DD 77    JSR $77DD
773B:20 D8 78    JSR $78D8
773E:20 10 7D    JSR $7D10
7741:A5 36       LDA $36
7743:F0 08       BEQ $774D		; Registre flag $36 si >0 change $5A et $5B
7745:A9 FD       LDA #$FD
7747:85 5A       STA $5A
7749:A9 7B       LDA #$7B
774B:85 5B       STA $5B
774D:60          RTS
774E:AD F8 7D    LDA $7DF8
7751:C9 FF       CMP #$FF
7753:F0 1A       BEQ $776F
7755:EE F8 7D    INC $7DF8
7758:AD F8 7D    LDA $7DF8
775B:C9 02       CMP #$02
775D:90 10       BCC $776F
775F:A9 FF       LDA #$FF
7761:8D F8 7D    STA $7DF8
7764:A9 B5       LDA #$B5
7766:85 80       STA $80
7768:A9 77       LDA #$77
776A:85 81       STA $81
776C:20 2A 77    JSR $772A
776F:A5 2E       LDA $2E
7771:A2 96       LDX #$96
7773:C9 0A       CMP #$0A
7775:90 02       BCC $7779
7777:A2 5A       LDX #$5A
7779:86 C3       STX $C3
777B:A5 39       LDA $39
777D:D0 1F       BNE $779E
777F:AD A0 13    LDA $13A0
7782:C9 04       CMP #$04
7784:D0 0C       BNE $7792
7786:AD AC 13    LDA $13AC
7789:C5 C3       CMP $C3
778B:B0 04       BCS $7791
778D:A9 01       LDA #$01
778F:85 39       STA $39
7791:60          RTS
7792:C9 03       CMP #$03
7794:D0 FB       BNE $7791
7796:AD A1 13    LDA $13A1
7799:C9 3C       CMP #$3C
779B:90 F0       BCC $778D
779D:60          RTS
779E:AD A0 13    LDA $13A0
77A1:C9 05       CMP #$05
77A3:B0 0B       BCS $77B0
77A5:AD AC 13    LDA $13AC
77A8:C5 C3       CMP $C3
77AA:90 08       BCC $77B4
77AC:C9 9C       CMP #$9C
77AE:B0 04       BCS $77B4
77B0:A9 00       LDA #$00
77B2:85 39       STA $39
77B4:60          RTS
77B5:14                   ???
77B6:10 00       BPL $77B8
77B8:10 0F       BPL $77C9
77BA:10 1D       BPL $77D9
77BC:20 0F 10    JSR $100F
77BF:1E 10 1D    ASL $1D10,X
77C2:10 0F       BPL $77D3
77C4:10 18       BPL $77DE
77C6:20 0F 10    JSR $100F
77C9:18          CLC
77CA:10 19       BPL $77E5
77CC:10 18       BPL $77E6
77CE:10 16       BPL $77E6
77D0:10 18       BPL $77EA
77D2:10 16       BPL $77EA
77D4:10 14       BPL $77EA
77D6:10 00       BPL $77D8
77D8:20 20 10    JSR $1020
77DB:FF                   ???
77DC:FF                   ???
77DD:20 F3 77    JSR $77F3
77E0:20 FC 77    JSR $77FC
77E3:20 0F 77    JSR $770F
77E6:20 FC 77    JSR $77FC
77E9:20 0F 77    JSR $770F
77EC:20 AA 78    JSR $78AA
77EF:20 C6 78    JSR $78C6
77F2:60          RTS
;
77F3:A9 A9       LDA #$A9		; Charge ($84)=$13A9=01 03 FF
77F5:85 84       STA $84
77F7:A9 13       LDA #$13
77F9:85 85       STA $85
77FB:60          RTS
;
77FC:A0 05       LDY #$05
77FE:B1 84       LDA ($84),Y
7800:F0 10       BEQ $7812
7802:C8          INY
7803:B1 84       LDA ($84),Y
7805:0A          ASL
7806:AA          TAX
7807:C8          INY
7808:B1 84       LDA ($84),Y
780A:A8          TAY
780B:A9 FF       LDA #$FF
780D:85 47       STA $47
780F:20 2F 78    JSR $782F
7812:A9 00       LDA #$00
7814:85 47       STA $47
7816:60          RTS
7817:00          BRK
7818:BD 39 7E    LDA $7E39,X
781B:85 80       STA $80
781D:E8          INX
781E:BD 39 7E    LDA $7E39,X
7821:85 81       STA $81
7823:A9 00       LDA #$00
7825:E0 0C       CPX #$0C
7827:B0 02       BCS $782B
7829:A9 01       LDA #$01
782B:8D 5C 78    STA $785C
782E:60          RTS
782F:84 C3       STY $C3
7831:20 18 78    JSR $7818
7834:A0 00       LDY #$00
7836:B1 80       LDA ($80),Y
7838:C9 FF       CMP #$FF
783A:F0 1F       BEQ $785B
783C:AE 5C 78    LDX $785C		; Tape direct dans la mémoire: registre mémoire ci dessous
783F:F0 05       BEQ $7846
7841:49 FF       EOR #$FF
7843:18          CLC
7844:69 01       ADC #$01
7846:85 C4       STA $C4
7848:20 5D 78    JSR $785D
784B:A5 80       LDA $80
784D:18          CLC
784E:69 03       ADC #$03
7850:85 80       STA $80
7852:A5 81       LDA $81
7854:69 00       ADC #$00
7856:85 81       STA $81
7858:4C 34 78    JMP $7834
785B:60          RTS
785C:01          ???				; Mémoire registre
785D:A5 C4       LDA $C4
785F:10 06       BPL $7867
7861:18          CLC
7862:65 C3       ADC $C3
7864:B0 06       BCS $786C
7866:60          RTS
7867:18          CLC
7868:65 C3       ADC $C3
786A:B0 FA       BCS $7866
786C:85 DE       STA $DE
786E:AA          TAX
786F:C8          INY
7870:B1 80       LDA ($80),Y
7872:85 DC       STA $DC
7874:C8          INY
7875:B1 80       LDA ($80),Y
7877:85 4A       STA $4A
7879:20 06 77    JSR $7706
787C:A4 DC       LDY $DC
787E:20 03 77    JSR $7703
7881:A5 29       LDA $29
7883:0A          ASL
7884:AA          TAX
7885:BD 1D 7E    LDA $7E1D,X
7888:A4 E5       LDY $E5
788A:24 47       BIT $47
788C:F0 02       BEQ $7890
788E:A9 00       LDA #$00
7890:91 4C       STA ($4C),Y
7892:E8          INX
7893:C8          INY
7894:C0 28       CPY #$28
7896:B0 0B       BCS $78A3
7898:BD 1D 7E    LDA $7E1D,X
789B:24 47       BIT $47
789D:F0 02       BEQ $78A1
789F:A9 00       LDA #$00
78A1:91 4C       STA ($4C),Y
78A3:C6 DC       DEC $DC
78A5:C6 4A       DEC $4A
78A7:D0 D3       BNE $787C
78A9:60          RTS
78AA:A0 05       LDY #$05
78AC:B1 84       LDA ($84),Y
78AE:F0 15       BEQ $78C5
78B0:A9 72       LDA #$72
78B2:85 80       STA $80
78B4:A9 80       LDA #$80
78B6:85 81       STA $81
78B8:C8          INY
78B9:B1 84       LDA ($84),Y
78BB:AA          TAX
78BC:C8          INY
78BD:B1 84       LDA ($84),Y
78BF:A8          TAY
78C0:A9 00       LDA #$00
78C2:20 21 77    JSR $7721
78C5:60          RTS
78C6:AD A5 13    LDA $13A5
78C9:20 46 7C    JSR $7C46
78CC:AE A6 13    LDX $13A6
78CF:AC A7 13    LDY $13A7
78D2:A9 00       LDA #$00
78D4:20 21 77    JSR $7721
78D7:60          RTS
78D8:20 F1 78    JSR $78F1
78DB:20 F3 77    JSR $77F3
78DE:20 06 79    JSR $7906
78E1:20 0F 77    JSR $770F
78E4:20 06 79    JSR $7906
78E7:20 0F 77    JSR $770F
78EA:20 9E 7C    JSR $7C9E
78ED:20 9B 79    JSR $799B
78F0:60          RTS
78F1:A9 A0       LDA #$A0
78F3:85 80       STA $80
78F5:A9 13       LDA #$13
78F7:85 81       STA $81
78F9:20 24 77    JSR $7724
78FC:20 24 77    JSR $7724
78FF:20 24 77    JSR $7724
