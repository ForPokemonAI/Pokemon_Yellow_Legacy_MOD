MACRO move_choices
	IF _NARG
		db \# ; all args
	ENDC
	db 0 ; end
	DEF list_index += 1
ENDM

;1  Idiot routine
;2  Damage routine we run this before the other to store KO explosion
;3  Buff routine
;4  Explosion routine
;5  Status routine
;6  Trap routine

; move choice modification methods that are applied for each trainer class
TrainerClassMoveChoiceModifications:
	list_start TrainerClassMoveChoiceModifications
	move_choices 1       ; YOUNGSTER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6    ; BUG CATCHER (used to be 1)
	move_choices 1       ; LASS
	move_choices 1, 2, 3, 4, 5, 6    ; SAILOR
	move_choices 1, 2, 3, 4, 5, 6   ; JR_TRAINER_M (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6   ; JR_TRAINER_F (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6 ; POKEMANIAC
	move_choices 1, 2, 3, 4, 5, 6 ; SUPER_NERD (used to be 1,2)
	move_choices 1, 2, 3, 4, 5, 6   ; HIKER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6  ; BIKER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6     ; BURGLAR
	move_choices 1, 2, 3, 4, 5, 6  ; ENGINEER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6   ; FISHER
	move_choices 1, 2, 3, 4, 5, 6     ; SWIMMER
	move_choices 1, 2, 3, 4, 5, 6   ; CUE_BALL (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6  ; GAMBLER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6     ; BEAUTY
	move_choices 1, 2, 3, 4, 5, 6; PSYCHIC_TR (used to be 1,2)
	move_choices 1, 2, 3, 4, 5, 6 ; ROCKER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6  ; JUGGLER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6  ; TAMER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6 ; BIRD_KEEPER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6  ; BLACKBELT (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6     ; RIVAL1
	move_choices 1, 2, 3, 4, 5, 6 ; PROF_OAK
	move_choices 1, 2, 3, 4, 5, 6 ; SMITH
	move_choices 1, 2, 3, 4, 5, 6 ; CRAIG
	move_choices 1, 2, 3, 4, 5, 6 ; SCIENTIST (used to be 1,2)
	move_choices 1, 2, 3, 4, 5, 6 ; GIOVANNI
	move_choices 1, 2, 3, 4, 5, 6 ; ROCKET (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6   ; COOLTRAINER_M
	move_choices 1, 2, 3, 4, 5, 6     ; COOLTRAINER_F
	move_choices 1, 2, 3, 4, 5, 6 ; BRUNO
	move_choices 1, 2, 3, 4, 5, 6 ; BROCK (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6 ; MISTY
	move_choices 1, 2, 3, 4, 5, 6 ; LT_SURGE
	move_choices 1, 2, 3, 4, 5, 6 ; ERIKA
	move_choices 1, 2, 3, 4, 5, 6 ; KOGA
	move_choices 1, 2, 3, 4, 5, 6 ; BLAINE
	move_choices 1, 2, 3, 4, 5, 6 ; SABRINA
	move_choices 1, 2, 3, 4, 5, 6 ; GENTLEMAN (used to be 1,2)
	move_choices 1, 2, 3, 4, 5, 6    ; RIVAL2
	move_choices 1, 2, 3, 4, 5, 6 ; RIVAL3
	move_choices 1, 2, 3, 4, 5, 6  ; LORELEI
	move_choices 1, 2, 3, 4, 5, 6   ; CHANNELER (used to be 1)
	move_choices 1, 2, 3, 4, 5, 6 ; AGATHA
	move_choices 1, 2, 3, 4, 5, 6 ; LANCE
	move_choices 1, 2, 3, 4, 5, 6 ; WEEBRA
	move_choices 1, 2, 3, 4, 5, 6 ; JANINE
	move_choices 1, 2, 3, 4, 5, 6 ; JOY
	move_choices 1, 2, 3, 4, 5, 6 ; JENNY
	assert_list_length NUM_TRAINERS
