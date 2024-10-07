// see BOOT PROCESS.TXT for General info: https://gswv.apple2.org.za/a2zine/GS.WorldView/Resources/DOS.3.3.ANATOMY/BOOT.PROCESS.txt
// Programme de boot du logiciel Jungle Hunt chargé par le DOS via le filename A ("HELLO" type binary)
// via 2 phase IOB/RTWS le code charge deux parties du code de Jungle Hunt
//	 	de $0A00=>$20FF (TRACK #$19)
//		et $6000=>$78FF

4000:20 7E 40    JSR   $407E
4003:8D 65 40    STA   $4065		; Slot #$60
4006:8D 73 40    STA   $4073		; Slot found #$60
4009:AD F8 B7    LDA   $B7F8		; Drive number found
400C:8D 66 40    STA   $4066		; On l'assigne le dernier drive courant trouvé dans le DOS
400F:8D 74 40    STA   $4074		; et au dernier drive found dans la table IOB
4012:20 34 40    JSR   $4034		; On exécute la première lecture pour remplir $0A00 => $78FF
4015:A9 60       LDA   #$60			; Deuxième Table à paramêtrer pour IOB et track et sector finaux
4017:8D 6D 40    STA   $406D		; Buffer de réception 256 bytes (#$0A pour le premier appel de JSR $4034 et #$60, le second)
401A:A9 1B       LDA   #$1B
401C:8D 68 40    STA   $4068		; Début de lecture Track Number
401F:A9 1C       LDA   #$1C
4021:8D 7A 40    STA   $407A		; Dernier track à lire
4024:A9 0F       LDA   #$0F
4026:8D 69 40    STA   $4069		; On réinitialise le 'début' du Track (Sector #0F)
4029:A9 07       LDA   #$07		
402B:8D 79 40    STA   $4079		; et dernier SECTOR (#9 pour la première phase de lecture) du dernier TRACK à lire
402E:20 34 40    JSR   $4034		; On exécute la lecture pour remplir $6000 => $78FF
4031:4C 00 0A    JMP   $0A00
; Lecture du disque suivant IOB et $407A (dernier track) et $4079 (dernier secteur à lire inversé)
4034:A9 00       LDA   #$00	 
4036:8D 71 40    STA   $4071		; On force le code retour "Aucune Erreur"=#00
4039:A0 64       LDY   #$64			; Table de L'IOB à $4064
403B:A9 40       LDA   #$40			; On a déjà le buffer positionné à $0A00 et le mode=Lecture
403D:20 B5 B7    JSR   $B7B5		; Appel à RTWS (cf les explication ci dessous)
4040:EE 6D 40    INC   $406D		; On incrément le byte fort du buffer ($0Axx)
4043:CE 69 40    DEC   $4069		; On décrément le secteur (0F à l'init)
4046:10 08       BPL   $4050		; Branchement si >=0
4048:A9 0F       LDA   #$0F			; Sinon On a tout lu le track => on remets le sector à 15
404A:8D 69 40    STA   $4069		
404D:EE 68 40    INC   $4068		; On augmente le Track
4050:AD 68 40    LDA   $4068		; Branchement après lecture du secteur+1
4053:CD 7A 40    CMP   $407A		; On compare le track de la table (#$19 pour $0A00) avec #$1A (qui sera le dernier à lire)
4056:90 DC       BCC   $4034		; Si Strictement inférieur on recommence en prenant tous les secteurs du track
4058:F0 01       BEQ   $405B		; Si égale au dernier track, on va prendre le nb de secteur à lire de ce dernier track
405A:60          RTS					; On accèdera jamais à ce RTS...?
405B:AD 69 40    LDA   $4069		; On charge le secteur en cours
405E:CD 79 40    CMP   $4079		; Compare avec le secteur finale
4061:B0 D1       BCS   $4034		; Toujours Supérieur ou égale on continue
4063:60          RTS				; Fin de lecture => on va changer la table IOB pour charger du code $6000
; Liste des paramêtres de la première table IOB déjà positionnée pour le chargement de $0A00->$20FF
4064:01 60       ORA   ($60,X)		; Table type IOB: 01, Slot=60
4066:01 00       ORA   ($00,X)		; Drive=1, Tout type de Volume=0
4068:19 0F 75    ORA   $750F,Y		; Track=19, Sector=0F (début de lecture pour $0A00)
406B:40          RTI				; DCT=($4075)=00 01 EF D8 (constant pour DISK II)
406C:00          ???				; Buffer ($406C)=$0A00
406D:0A          ASL
406E:00          ???				; not used
406F:00          ???				; Byte count for partial sector (should be 0 for 256 bytes)
4070:01 00       ???          		; Command=01=READ, Code retour=00
4072:00          ???				; Last Volume
4073:60          ???				; Last Slot
4074:01 00       ???          		; Last Drive
4076:01 EF       ???
4078:D8          CLD
4079:09 1A       ???       			; Fin du secteur à lire = #$09 du dernier track à lire = #$1A (pour la premier phase $0A00)
407B:84 00       STY   $00
407D:00          BRK
407E:A9 00       LDA   #$00
4080:8D F4 03    STA   $03F4
4083:AD F7 B7    LDA   $B7F7
4086:60          RTS
4087:00          BRK
4088:00          BRK
4089:00          BRK
408A:00          BRK

/*
Point d'entrée RWTS
===================
Adresse : $B7B5
Paramètres d'entrée :
	Registre A : Page haute de l'IOB (Input/Output Block)
	Registre Y : Offset de l'IOB dans la page
	Registre X : non utilisé, préservé

Structure de l'IOB (17 octets) $B7E8-$B7F8 
(dans notre cas $4064/74 => Y=64 et A=40 à l'appel de RWTS)
===========================================================
Offset  Description
$00     Table type d'IOB (must be $01 pour RWTS)
$01     Numéro de slot * 16 (ex: $60 pour slot 6)
$02     Numéro de drive (1 ou 2)
$03     Numéro de volume (0=accepte tout type de volume)
$04     Track Number (#$00 à #$22/#34) ($4068)
$05     Secteur Number (#$00 à #$0F) ($4069)
$06-$07 Adresse de la table DCT (Device Characteristics Table) 
				($06),0: Device type (should be #00 for DISK II)
				($06),1: Phase per track (should be #01 for DISK II)
				($06),2 et ($06),3: Motor on time count (should be #$EFD8 for DISK II)
$08-$09 Adresse du buffer de 256 bytes pour Lecture et Ecriture (pour nous $406C/D)
$0A     Non utilisé
$0B     Byte count for partial sector (use $00 for 256)
$0C     Command code: 0=SEEK, 1=READ, 2=WRITE, 4=FORMAT ($4070)
$0D     Code de retour - The processor CARRY flag is set ($4071)
			upon return from RWTS if there is a non-zeo return code
				#$00=no errors
				#$08=Error during initialisation
				#$10=Write protect Error
				#$20=Volume mismatch error
				#$40=Drive error
				#$80 = read error (obosolete)
$0E     Volume number of last access (must be initialized)
$0F     Slot number of last access*16 (must be initialized)
$10     Drive number of last access (must be initialized)

Codes d'erreur RWTS
====================
$00 : Pas d'erreur
$10 : Erreur de recherche de données
$20 : Volume incorrect
$40 : Erreur de lecteur
$80 : Volume protégé en écriture


// INFOS sur le chargement du DOS
	$FFFF +------------------+
          |                  |
    $C700 |                  |
    $C600 +------------------+ ---> Boot 0 ROM
    $C500 |                  |      (contrôleur disque)
          |                  |
    $C000 +------------------+
          |                  |
    $BFFF +==================+ ---> RWTS
          |                  |      (Read/Write Track Sector)
    $B700 +==================+
          |                  |
          |  Programme DOS   |
          |   Principal      |
    $9D00 +==================+
          |                  |
          |  Tampons DOS     |
    $9600 +==================+
          |                  |
          |                  |
    $0900 |   Boot 1         |
    $0800 +==================+ ---> Chargé depuis Piste 0, Sect 0
          |                  |
          |                  |
    $0000 +------------------+

    Légende:
    ======== = Zones DOS
    -------- = ROM
           
    Processus de chargement:
    1. $C600 (ROM) charge Piste 0, Secteur 0 à $0800
    2. $0800 charge:
       - RWTS à $B700-$BFFF
       - DOS principal à $9D00-$B6FF
       - Tampons à $9600-$9FFF