; creates a set of moves that may be used and returns its address in hl
; unused slots are filled with 0, all used slots may be chosen with equal probability
AIEnemyTrainerChooseMoves:
	ld a, $15 ; give all moves a value of 21 to begin with
	ld hl, wBuffer ; init temporary move selection array. Only the moves with the lowest numbers are chosen in the end
	ld [hli], a   ; move 1
	ld [hli], a   ; move 2
	ld [hli], a   ; move 3
	ld [hl], a    ; move 4
	
;;;;;;;;;; shinpokerednote: ADDED: make a backup buffer
	push hl
	ld a, $ff ; the backup buffer is at max value to begin with
	inc hl
	ld [hli], a	;backup 1
	ld [hli], a	;backup 2
	ld [hli], a	;backup 3
	ld [hl], a	;backup 4
	pop hl
;;;;;;;;;;
    ld a, 1
    ld [wBuffer + 19], a ; marker for AI calculation

	ld a, [wEnemyDisabledMove] ; forbid disabled move (if any)
	swap a
	and $f
	jr z, .noMoveDisabled
	ld hl, wBuffer
	dec a
	ld c, a
	ld b, $0
	add hl, bc    ; advance pointer to forbidden move
	ld [hl], $50  ; forbid (highly discourage) disabled move
.noMoveDisabled
	ld hl, TrainerClassMoveChoiceModifications
	ld a, [wTrainerClass]
	ld b, a
.loopTrainerClasses
	dec b
	jr z, .readTrainerClassData
.loopTrainerClassData
	ld a, [hli]
	and a
	jr nz, .loopTrainerClassData
	jr .loopTrainerClasses
	
.readTrainerClassData
	ld a, [hl]
	and a
	jp z, .useOriginalMoveSet
	push hl
.nextMoveChoiceModification
	pop hl
	ld a, [hli]
	and a
	jr z, .loopFindMinimumEntries
	push hl
	ld hl, AIMoveChoiceModificationFunctionPointers
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc    ; skip to pointer
	ld a, [hli]   ; read pointer into hl
	ld h, [hl]
	ld l, a
	ld de, .nextMoveChoiceModification  ; set return address
	push de
	jp hl         ; execute modification function
.loopFindMinimumEntries_backupfirst	;shinpokerednote: ADDED: make a backup of the scores
	ld hl, wBuffer  ; temp move selection array
	ld de, wBuffer + NUM_MOVES  ;backup buffer
	ld bc, NUM_MOVES
	call CopyData
.loopFindMinimumEntries ; all entries will be decremented sequentially until one of them is zero
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.loopDecrementEntries
	ld a, [de]
	inc de
	and a
	jr z, .loopFindMinimumEntries
	dec [hl]
	jr z, .minimumEntriesFound
	inc hl
	dec c
	jr z, .loopFindMinimumEntries
	jr .loopDecrementEntries
.minimumEntriesFound
	ld a, c
.loopUndoPartialIteration ; undo last (partial) loop iteration
	inc [hl]
	dec hl
	inc a
	cp NUM_MOVES + 1
	jr nz, .loopUndoPartialIteration
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.filterMinimalEntries ; all minimal entries now have value 1. All other slots will be disabled (move set to 0)
	ld a, [de]
	and a
	jr nz, .moveExisting
	ld [hl], a
.moveExisting
	ld a, [hl]
	dec a
	jr z, .slotWithMinimalValue
	xor a
	ld [hli], a     ; disable move slot
	jr .next
.slotWithMinimalValue
	ld a, [de]
	ld [hli], a     ; enable move slot
.next
	inc de
	dec c
	jr nz, .filterMinimalEntries
	ld hl, wBuffer    ; use created temporary array as move set
	jr .done
.useOriginalMoveSet
	ld hl, wEnemyMonMoves    ; use original move set
.done
;;;;;;;;;; PureRGBnote: clear these values at the end of an AI cycle, they only apply when the player has switched or healed in a turn
	xor a
;	ld [wAIMoveSpamAvoider], a ; has to be reset on the core side to take locked turns into account
	; ld [wAITargetMonStatus], a
	; ld [wAITargetMonType1], a 
	; ld [wAITargetMonType2], a 
	; ld [wBuffer + 28], a ; we borrow this for storing defense
	; ld [wBuffer + 29], a ; we borrow this for storing defense
	; ld [wBuffer + 26], a ; we borrow this for storing special
	; ld [wBuffer + 27], a ; we borrow this for storing special
	; ld [wBuffer + 24], a ; we borrow this for storing speed
	; ld [wBuffer + 25], a ; we borrow this for storing speed
	; ld [wBuffer + 22], a ; we borrow this for storing attack
	; ld [wBuffer + 23], a ; we borrow this for storing attack
	; ld [wBuffer + 20], a ; we borrow this for storing status3
	; ld [wBuffer + 21], a ; we borrow this for storing status2
    ; ld [wBuffer + 18], a ; we borrow this for storing player monster number
	; ld [wBuffer + 16], a ; we borrow this for storing the hp
	; ld [wBuffer + 17], a ; we borrow this for storing the hp
	; ld [wBuffer + 15], a ; we borrow this for storing status1
	; ld [wBuffer + 14], a ; we borrow this for storing the max hp
	; ld [wBuffer + 13], a ; we borrow this for storing the max hp
    ld [wBuffer + 12], a ; we borrow this for storing the KO explosion move ID
	ld [wHPBarNewHP], a ; we borrow this to store the highest damage
	ld [wHPBarNewHP + 1], a; we borrow this to store the highest damage
	ld [wDamage], a ; we borrow this to store the damage calcs
	ld [wDamage + 1], a ; we borrow this to store the damage calcs
    ld [wBuffer + 19], a ; reset marker for AI calculation
    
;;;;;;;;;;
	ret

AIMoveChoiceModificationFunctionPointers:
	dw AIMoveChoiceModification1 ; Idiot routine
	dw AIMoveChoiceModification5 ; Damage routine we run this before the other to store KO explosion
	dw AIMoveChoiceModification2 ; Buff routine
	dw AIMoveChoiceModification3 ; Explosion routine
	dw AIMoveChoiceModification4 ; Status routine
	dw AIMoveChoiceModification6 ; Trap routine

; PureRGBnote: CHANGED: AKA the "Dont do stupid things no player would ever do" AI subroutine, many new default AI restrictions added
; discourages moves that cause no damage but only a status ailment if player's mon already has one, or if they're immune to it
; discourages moves that after being used once won't do anything when used again (mist, leech seed, etc.)
; discourages moves that will fail due to the current enemy pokemon's state (recover at full health, one hit ko moves on faster pkmn)
;JOONAS: Filling up the missing parts from RGB ai:
;don't use substitute when already using one or below quarter hp(substitute costs 1/4 of max hp)
;don't use switch/teleport moves(that do nothing in trainer battle)
;don't use statup/down moves when at full buff/debuff counter
;don't use moves that enemy is immune to(type/substitute/in the sky/underground)
AIMoveChoiceModification1:
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	ld a, [wEnemyMovePower] ; checking for move power to filter out attacking
	and a ; we check if move power is zero.
	jp z, .checkMoveEffect ; if it is we send to the non-damaging moves section.
	; it used to do the opposite but JOONAS switched because most moves are damaging moves. This is cheaper.
	;Damaging moves section
.checkCounter ; we need to check for counter first as it hits everything
        ld a, [wEnemyMoveNum]
	cp COUNTER ; check for counter since it hits everything
	jr z, .nextMove ; if counter, ignore
.checkMoveType
	ld a, [wEnemyMoveEffect]
	cp DREAM_EATER_EFFECT ; check for dream eater
	jp z, .checkAsleep ; asleep pokemon can not be invulnerable and psychic affects everything so no need for fly/dig/type check
	cp DRAIN_HP_EFFECT ; check for draining moves
	jr z, .checkPlayerSubstitute ; Nothing is immune to draining moves so need for type check
	cp SPECIAL_DAMAGE_EFFECT ; check for static damage moves
	jr z, .checkFlyDig ; ignores type so no need to check type
	cp SUPER_FANG_EFFECT ; check for super fang
	jr z, .checkFlyDig ; works on everything so no need for type check
.checkPlayerTypes ; check for player mon types vs attack type for non-effective moves
	; this needs all these registers
	push hl
	push de
	push bc
	callfar AIGetTypeEffectiveness
	pop bc
	pop de
	pop hl
	;return the registers before returning
	ld a, [wTypeEffectiveness]
	cp NO_EFFECT ; check for no effect
	jr z, .discourage ; discourage if found
    ld a, [wEnemyMoveNum]
	cp QUICK_ATTACK ; check for quick attack since it has different fly/dig interaction
	jr z, .quickAttack ; if yes, check fly but not speed.
.checkMoveType2 ; we weed out the rest of the special attacks here
	ld a, [wEnemyMoveEffect]
	cp OHKO_EFFECT ; check for 1-hit KO moves
	jr z, .ohko ; OHKO only works on slower pokemon so fly/dig makes player mon completely invulnerable and needs it's own check
	cp CHARGE_EFFECT ; check for charge moves
	jr z, .nextMove ; Charge moves do not care about invulnerability
	cp FLY_EFFECT
	jr z, .nextMove ; Charge moves do not care about invulnerability
	cp SWIFT_EFFECT ; check for swift
	jr z, .nextMove ; swift hits invulnerable targets too
	cp EXPLODE_EFFECT ; check for explosion moves
	jr z, .checkFRZ ; check if player mon frozen
.checkFlyDig ; check for player mon fly/dig status; routine to check player mon substitute status
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .loadOldStatusFD; if they did, check old status for dig/fly
	ld a, [wPlayerBattleStatus1]
.checkFD
	bit INVULNERABLE, a ; check if player mon can be hit with a move other than swift
	jr z, .nextMove ; if it can, ignore
	call CompareSpeed ; else, check speed
	jr c, .nextMove ; if AI mon is slower, it can still hit so ignore
.discourage ; else flow into discourage
	ld a, [hl]
	add $32 ; heavily discourage move, this should be high enough to never come back with the other routines (50)
	ld [hl], a
	jr .nextMove ; check next move

.loadOldStatusFD	
   	ld a, [wBuffer + 15] ; we borrow this for storing old status 1
   	jr .checkFD
    			
.checkPlayerSubstitute ; routine to check player mon substitute status
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .loadOldStatusSubs; if they did, check old status confusion
	ld a, [wPlayerBattleStatus2]
.checkSubs
	bit HAS_SUBSTITUTE_UP, a ; check for enemy substitute
	jr nz, .discourage ; don't use if already up
	jr .checkFlyDig ;else check for invulnerability
	
.loadOldStatusSubs
   	ld a, [wBuffer + 21]; we borrow this for storing old status 2
   	jr .checkSubs
	
.ohko ; check for fly/dig and speed
	call CompareSpeed ; check speed
	jr c, .discourage ; discourage if AI mon slower
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .loadOldStatusFDOHKO; if they did, check old status confusion
	ld a, [wPlayerBattleStatus1]
.checkFDOHKO	
	bit INVULNERABLE, a ; check if player mon invulnerable
	jr nz, .discourage ; if yes, don't try to hit
	jp .nextMove ; else, ignore
	
.loadOldStatusFDOHKO	
   	ld a, [wBuffer + 15] ; we borrow this for storing old status 1
   	jr .checkFDOHKO	
	
.checkAsleep ; Routine to check player mon sleep status
	ld a, [wAIMoveSpamAvoider] ; this is the switch non-prediction routine	
	cp 2 ; set to two if switched
	jr z, .switchedAsleep ; go read preswitch status
	ld a, [wBattleMonStatus] ; read current mon status because no switch
.checkAS	
	and SLP_MASK ; check sleep
	jr z, .discourage ; if the player mon is not asleep avoid using dream eater
	jp .nextMove ; else, ignore
	
.quickAttack
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .loadOldStatusFDQA; if they did, check old status confusion
	ld a, [wPlayerBattleStatus1]
.checkFDQA
	bit INVULNERABLE, a ; check if player mon can be hit with a move other than swift
	jp z, .nextMove ; if it can, ignore
	jr .discourage ; else discourage
	   	
.checkFRZ
	ld a, [wAIMoveSpamAvoider] ; set if player switched or healed this turn
	cp 2 ; set to 2 if player switched
	jr z, .loadOldFRZStatus ; load old status if switched
	ld a, [wBattleMonStatus] ; else load player mon current status
.checkStatusFRZ
	bit FRZ, a ; check if player mon is frozen
	jr z, .checkFlyDig ; if the player mon isn't frozen check for fly/dig status
	jr .discourage ; else discourage
	
.switchedAsleep
	ld a, [wAITargetMonStatus] ; preswitch status
	jr .checkAS
	
.loadOldStatusFDQA        
   	ld a, [wBuffer + 15] ; we borrow this for storing old status 1
   	jr .checkFDQA
	
.loadOldFRZStatus
	ld a, [wAITargetMonStatus] ; set to the player mon current status before it gets healed or before it switches out
	jr .checkStatusFRZ
   		
	;Non-damaging moves section, moved here because most moves are damaging moves so this is cheaper
.checkMoveEffect
	ld a, [wEnemyMoveEffect] ; the rest continue to go through the other checks
	cp SWITCH_AND_TELEPORT_EFFECT ; don't use moves that don't function in trainer battles
	jp z, .discourage
	cp CONFUSION_EFFECT ; is the move confusion status move?
	jp z, .checkConfused ; jf yes, check for player mon confusion prerequisites
	cp HEAL_EFFECT ; is the move a healing move?
	jp z, .checkFullHealth ; jf yes, check for full health status
	cp FOCUS_ENERGY_EFFECT ; is the move focus energy?
	jp z, .checkPumpedUp ; jf yes, check for AI mon focus energy status
	cp DISABLE_EFFECT ; is the move disable?
	jp z, .checkDisabled ; jf yes, check for player mon disabled moves
	cp LEECH_SEED_EFFECT ; is the move leech seed?
	jp z, .checkSeeded ; jf yes, check for player mon leech seed prerequisities
	cp REFLECT_EFFECT ; is the move reflect?
	jr z, .checkReflectUp ; jf yes, check for AI mon reflect status
	cp LIGHT_SCREEN_EFFECT ; is the move light screen?
	jr z, .checkLightScreenUp ; jf yes, check for AI mon light screen status
	cp MIST_EFFECT ; is the move mist?
	jr z, .checkMistUp  ; jf yes, check for AI mon mist status
	cp SUBSTITUTE_EFFECT ; is the move substitute?
	jr z, .checkSubstitute ; if yes check for AI mon substitute/hp
	cp MIRROR_MOVE_EFFECT ; is the move mirror move?
	jp z, .checkNoMirrorMoveOnFirstTurn ; jf yes, check for mirror move prerequisite
	ld a, [wEnemyMoveEffect] ; added this section to check for already fully boosted/lowered status
	push hl ; this requires full wrap
	push de
	push bc
	ld hl, StatUpEffects ; we check for stat up effect list
	ld de, 1
	call IsInArray
	jr c, .checkStatUpModifier ; if found in list, check for max stat up modifier vs current
	ld a, [wEnemyMoveEffect]
	ld hl, StatDownEffects ; we check for stat down effect list
	ld de, 1
	call IsInArray
	jp c, .checkStatDownModifier ; if found in list, check for stat down prerequisites
	; end of added section
	ld a, [wEnemyMoveEffect]
	ld hl, StatusAilmentMoveEffects ; we check for status move list
	ld de, 1
	call IsInArray
	pop bc
	pop de
	pop hl ; return from full wrap
	jp nc, .nextMove ; if not found, ignore all moves from this point forward(though there should be only bide left that works on everything)
	;this is just a safeguard in case some move was forgotten
.checkStatusImmunity ; else check for status prerequisites
	call CheckStatusImmunity ; check for immunity, subtitute check has to be wrapped in due to different immunities
	jp c, .discourage ; if found, discourage
.notImmune
	ld a, [wAIMoveSpamAvoider] ; set if player switched or healed this turn
	cp 2 ; set to 2 if player switched
	jr z, .loadOldStatusNotImmune ; load old status if switched
	ld a, [wBattleMonStatus] ; else load player mon current status
.checkStatusNotImmune
	and a ; check if none set
	jp z, .checkFlyDig ; if the player mon doesn't have a status check for fly/dig status, in damaging moves section
	jp .discourage ; else discourage
	
.loadOldStatusNotImmune
	ld a, [wAITargetMonStatus] ; set to the player mon current status before it gets healed or before it switches out
	jr .checkStatusNotImmune
    		
.checkReflectUp
	ld a, [wEnemyBattleStatus3]
	bit HAS_REFLECT_UP, a
	jp nz, .discourage ; if the AI mon has a reflect up dont use the move again
	jp .nextMove
	
.checkLightScreenUp
	ld a, [wEnemyBattleStatus3]
	bit HAS_LIGHT_SCREEN_UP, a
	jp nz, .discourage ; if the AI mon has a light screen up dont use the move again
	jp .nextMove
	
.checkMistUp
	ld a, [wEnemyBattleStatus2]
	bit PROTECTED_BY_MIST, a
	jp nz, .discourage ; if the AI mon has used mist, don't use it again
	jp .nextMove
	
.checkSubstitute
	ld a, [wEnemyBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a ; check for AI mon substitute
	jp nz, .discourage ; don't use if already up
	ld a, 4 ; substitue takes 1/4 hp to use
	call AICheckIfHPBelowFractionWrapped
	jp c, .discourage ; discourage if too low hp
	jp .nextMove ; else ignore
	
.checkNoMirrorMoveOnFirstTurn
	ld a, [wPlayerLastSelectedMove]
	and a ; check if no move used
	jp z, .discourage ; don't use mirror move if the player has never selected a move yet
	jp .nextMove
	
.checkStatUpModifier    ; check to see if we are at max boost
	ld hl, wEnemyMonStatMods
	ld de, wEnemyMoveEffect
	ld a, [de]
	sub ATTACK_UP1_EFFECT
	cp EVASION_UP1_EFFECT + $3 - ATTACK_UP1_EFFECT ; covers all +1 effects
	jr c, .incrementStatMod
	sub ATTACK_UP2_EFFECT - ATTACK_UP1_EFFECT ; map +2 effects to equivalent +1 effect
.incrementStatMod
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl]
	inc b ; increment corresponding stat mod
	ld a, $d
	cp b ; can't raise stat past +6 ($d or 13)
	pop bc
	pop de
	pop hl ; release full wrap
	jp c, .discourage ; if we would go over max boost, discourage move
	jp .nextMove
	
.checkStatDownModifier   
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .checkOldStatus2; if they did, check old status confusion
	ld a, [wPlayerBattleStatus2] ; cheaper to do this here since we have to load the status for mist anyway
.checkStat2
	bit HAS_SUBSTITUTE_UP, a ; We first check for player mon substitute
	jp nz, .discourage ; if it is, discourage
	bit PROTECTED_BY_MIST, a ; is playermon protected by mist?
	jp nz, .discourage ; if it is, discourage, else continue
	ld hl, wPlayerMonStatMods ; it is SO rare for AI to spam you to minus 6, that predicting a shift is probably OK
	ld bc, wPlayerBattleStatus1
	ld de, wEnemyMoveEffect
	ld a, [de]
	sub ATTACK_DOWN1_EFFECT
	cp EVASION_DOWN1_EFFECT + $3 - ATTACK_DOWN1_EFFECT ; covers all -1 effects
	jr c, .decrementStatMod
	sub ATTACK_DOWN2_EFFECT - ATTACK_DOWN1_EFFECT ; map -2 effects to corresponding -1 effect
.decrementStatMod
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl]
	dec b ; dec corresponding stat mod
        pop bc
	pop de
	pop hl ; release full wrap
	jp z, .discourage ; if at full debuff(0), don't try to debuff more
	jp .checkFlyDig ; else we check for fly/dig, this is in the damaging section
	
.checkOldStatus2	
	ld a, [wBuffer + 21] ; cheaper to do this here since we have to load the status for mist anyway
    jr .checkStat2
	
.checkDisabled
	ld a, [wPlayerDisabledMove] ; non-zero if the player mon has a disabled move
	and a ; check for zero
	jp z, .checkFlyDig ; if it's zero check fly/dig, this is in the damaging section
	jp .discourage ; otherwise discourage using disable while opponent is disabled already
	
.checkPumpedUp
	ld a, [wEnemyBattleStatus2]
	bit GETTING_PUMPED, a
	jp nz, .discourage ; if the AI mon has used focus energy don't use again
	jp .nextMove
	
.checkConfused
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .checkOldStatusConf; if they did, check old status confusion
	ld a, [wPlayerBattleStatus1] ; if not load current status
.checkConf	
	bit CONFUSED, a ; if the player mon is confused
	jp nz, .discourage ; don't use confusion-inflicting moves
	jp .checkPlayerSubstitute ; else continue checking for substitute and fly/dig, in damaging moves section
		
.checkOldStatusConf		; load old status
	ld a, [wBuffer + 15] ; we borrow this for storing status1
	jr .checkConf ; go check status
	
.checkSeeded
;	ld a, [wPlayerBattleStatus1] ; pointless line
	call CheckSeeded
	jp nc, .checkFlyDig ; if not seeded, check fly/dig, this is in the damaging section
	jp .discourage ; if seeded, discourage because cannot seed again
	
.checkFullHealth ; avoid using moves like recover at full health.
	push hl ; this needs to be wrapped
	push de
	ld hl, wEnemyMonMaxHP
	ld de, wEnemyMonHP
	ld a, [de] ; check first part of health
	cp [hl]
	jr nz, .notFullHealth
	inc hl ; advance pointers to second part of health(as it's a 16 bit value)
	inc de ; advance pointers to second part of health(as it's a 16 bit value)
	ld a, [de] ; check second part of health
	cp [hl]
	jr nz, .notFullHealth
	pop de
	pop hl ; release wrap
	jp .discourage ; if no missing health found, discourage
	
.notFullHealth
	pop de
	pop hl ; release wrap
	jp .nextMove

StatusAilmentMoveEffects:
	db SLEEP_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
;	db BURN_SIDE_EFFECT2 ; Fire Blast is often used as a burn spreading tool in comp RBY! 
	;JOONAS:This is dumb, don't discourage higher burn chance moves
	;like fireblast, fire punch or triattack just because opponent is statused or immune to burning.
	db -1 ; end
	
StatUpEffects:
	db ATTACK_UP1_EFFECT
	db DEFENSE_UP1_EFFECT
	db SPEED_UP1_EFFECT
	db SPECIAL_UP1_EFFECT
	db ACCURACY_UP1_EFFECT
	db EVASION_UP1_EFFECT
	db ATTACK_UP2_EFFECT
	db DEFENSE_UP2_EFFECT
	db SPEED_UP2_EFFECT
	db SPECIAL_UP2_EFFECT
	db ACCURACY_UP2_EFFECT
	db EVASION_UP2_EFFECT
	db -1 ; end	

StatDownEffects:	
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db SPEED_DOWN1_EFFECT
	db SPECIAL_DOWN1_EFFECT
	db ACCURACY_DOWN1_EFFECT
	db EVASION_DOWN1_EFFECT
	db ATTACK_DOWN2_EFFECT
	db DEFENSE_DOWN2_EFFECT
	db SPEED_DOWN2_EFFECT
	db SPECIAL_DOWN2_EFFECT
	db ACCURACY_DOWN2_EFFECT
	db EVASION_DOWN2_EFFECT
	db -1 ; end	

;;;;;;;;;; PureRGBnote: ADDED: function for checking if the player can have leech seed applied and whether they already have it applied

CheckSeeded:
	push hl
	ld a, [wAIMoveSpamAvoider]
	cp 2 ; set to 2 if we switched out this turn
	jr z, .loadOldSeedStatus
	ld a, [wPlayerBattleStatus2]
.checkSeed
	bit SEEDED, a
	jr nz, .discourage ; if the enemy has used leech seed don't use again
	ld a, [wAIMoveSpamAvoider]
	cp 2 ; set to 2 if we switched out this turn
	ld hl, wBattleMonType1
	jr nz, .noSwitchOut
	ld hl, wAITargetMonType1 ; stores what the AI thinks the player's type is when a switchout happens
.noSwitchOut	
	ld a, [hli] ; check first player mon type
	cp GRASS
	jr z, .discourage ; leech seed does not affect grass types
	ld a, [hl] ; check second player mon type
	cp GRASS
	jr z, .discourage ; leech seed does not affect grass types
	pop hl
	and a
	ret
.discourage
	pop hl
	scf
	ret	
	
.loadOldSeedStatus
    ld a, [wBuffer + 21]
    jr .checkSeed

;;;;;;;;;;

;;;;;;;;;; PureRGBnote: ADDED: function for checking if the player's pokemon is unaffected by specific status moves.

CheckStatusImmunity:
	push bc
	push hl
	ld a, [wEnemyMoveEffect]
	cp PARALYZE_EFFECT
	jr z, .checkParalyze
	cp POISON_EFFECT  
	ld b, POISON 
	jr z, .checkSubstitute ; poison is blocked by substitute
;	cp BURN_SIDE_EFFECT2 ; not necessary at the moment
;	ld b, FIRE
;	jr z, .checkSubstitute ; burn is blocked by substitute
;	cp BURN_SIDE_EFFECT1 ; should check both burn effects for future proofing
;	jr z, .checkSubstitute ; burn is blocked by substitute
;	cp FREEZE_SIDE_EFFECT ; should check freeze effects for future proofing
;	ld b, ICE
;	jr z, .checkSubstitute ; freeze is blocked by substitute
	jr .done
	
.checkSubstitute
	ld a, [wAIMoveSpamAvoider] ; set if we healed status or switched out this turn
	cp 2 ; it's 2 if we switched out
	jr z, .loadOldSubStat
	ld a, [wPlayerBattleStatus2]
.checkSubStat	
	bit HAS_SUBSTITUTE_UP, a
	jr nz, .discourage ; if the player has substitute don't use affected moves   
	jr .getMonTypes ; if not, check types

.loadOldSubStat	
   	ld a, [wBuffer + 21]
   	jr .checkSubStat
			
.checkParalyze
	ld a, [wEnemyMoveType]
	cp ELECTRIC
	ld b, GROUND
	jr nz, .done
.getMonTypes
	ld a, [wAIMoveSpamAvoider] ; set if we healed status or switched out this turn
	cp 2 ; it's 2 if we switched out
	jr nz, .noSwitchOut
	ld hl, wAITargetMonType1
	jr .checkTypes
	
.noSwitchOut
	ld hl, wBattleMonType1
.checkTypes
	ld a, [hl]
	cp b
	jr z, .discourage
	inc hl
	ld a, [hl]
	cp b
	jr z, .discourage
.done
	pop hl
	pop bc
	and a
	ret
.discourage
	pop hl
	pop bc
	scf
	ret 
;;;;;;;;;;

;;;;;;;;;; PureRGBnote: ADDED: function that allows AI to avoid OHKO moves if they will never do anything to the player's pokemon due to speed differences
; WillOHKOMoveAlwaysFail: ; JOONAS not needed as a call function
	; call CompareSpeed
	; jr c, .userIsSlower
	; and a
	; ret
; .userIsSlower
	; scf
	; ret
;;;;;;;;;;

; PureRGBnote: CHANGED: AKA the "Boost stats on the first turn" subroutine
; slightly encourage moves with specific effects on the first turn. (PureRGBnote: FIXED: used to be the second turn, made it first turn)
; JOONAS this means trainers with just this routine and the basic one will ALWAYS buff/debuff on the first turn
; aside from that, this is also bad logically. You want to buff at full hp or when the opponent is sleeping
; so we should discourage these when enemy is at low HP
; if we want to encourage first turn moves, it should be with random chance of some percentage
AIMoveChoiceModification2:
;	ld a, [wAILayer2Encouragement]
;	and a
;	ret nz ; choose this modifier only on the first turn ; no we want it on all but the encouragement to come only when full hp
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove2
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	ld a, [wEnemyMoveEffect]
	push hl
	push de
	push bc
	ld hl, Modifier2PreferredMoves
	ld de, 1
	call IsInArray
	pop bc
	pop de
	pop hl
	jr nc, .nextMove2 ; if not in array ignore and check next move
	ld a, [wEnemyMoveEffect]
	cp SPEED_UP2_EFFECT ; we check for speed up moves
	jr z, .checkSpeedsForBuff
	ld a, 2	; for every other move we do not want to use them if we are below 50% hp as we are likely to faint anyway
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr c, .lowerPreference ; don't use stat moves below 50% hp
	ld a, 1	; check if AI mon at full hp
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr c, .checkSpeedsForGeneral ; if not at full hp, check for speed and ignore if faster or similar speed, else lower preference
	ld a, [wAILayer2Encouragement] ; checking for first turn after everything else
	and a ; check if first turn
    jr nz, .nextMove2 ; if not, check next move
	call Random
	cp 25 percent ; 25% chance to boost move
	jr nc, .nextMove2 ; ~50% chance to use move(one move probably already eliminated)
.preferMove2 ; else raise preference
	dec [hl] ; slightly encourage this move
	jr .nextMove2
	
.checkSpeedsForBuff
	call CompareSpeed ; we check which monster is faster
	jr c, .preferSpeed ; if AI mon is slower we tell it to use speedboost
	; this is only useful if the speed boost is enough switch turns around but usually only fast pokemon get these so it is
.lowerPreference ; if it is already faster there's no point so we tell it not to like this move
    inc [hl]	; but it's not completely useless so if all other moves are bad, this is still alright
    jr .nextMove2
    	
.checkSpeedsForGeneral
	call CompareSpeed ; we check which monster is faster
	jr c, .lowerPreference ; if AI mon is slower we tell it not to use buffs when not at full hp
	call Random
	cp 25 percent ; 25% chance to lower preference
	jr nc, .nextMove2 ; ~25% chance to use move(one move probably already eliminated)
    jr .lowerPreference ; else lower preference

.preferSpeed ; this will make this a very preferred move, only behind spore
	ld a, [hl]
	sub $11 ; 16 in dec, -18
	ld [hl], a
	jr .preferMove2 ; if AI mon is slower we tell it to use speedboost
    

Modifier2PreferredMoves: ; these should be further split into buff/debuff, special and strong/weak moves, but this will do for now
	db LEECH_SEED_EFFECT ; do we want this here?
	db FOCUS_ENERGY_EFFECT
	db REFLECT_EFFECT
	db LIGHT_SCREEN_EFFECT
	db ATTACK_UP1_EFFECT
	db DEFENSE_UP1_EFFECT
	db SPEED_UP1_EFFECT
	db SPECIAL_UP1_EFFECT
	db ACCURACY_UP1_EFFECT
	db EVASION_UP1_EFFECT
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db SPEED_DOWN1_EFFECT
	db SPECIAL_DOWN1_EFFECT
	db ACCURACY_DOWN1_EFFECT
	db EVASION_DOWN1_EFFECT
	db ATTACK_UP2_EFFECT
	db DEFENSE_UP2_EFFECT
	db SPEED_UP2_EFFECT
	db SPECIAL_UP2_EFFECT
	db ACCURACY_UP2_EFFECT
	db EVASION_UP2_EFFECT
	db ATTACK_DOWN2_EFFECT
	db DEFENSE_DOWN2_EFFECT
	db SPEED_DOWN2_EFFECT
	db SPECIAL_DOWN2_EFFECT
	db ACCURACY_DOWN2_EFFECT
	db EVASION_DOWN2_EFFECT
	db SUBSTITUTE_EFFECT ; do we want this here?
	db -1 ; end

; PureRGBnote: CHANGED: AKA the "Use Effective damaging moves offensively" subroutine
; encourages moves that are effective against the player's mon if they do damage. 
; discourage damaging moves that are ineffective or not very effective against the player's mon,
; unless there's no damaging move that deals at least neutral damage
; encourage effective or super effective priority moves if the pokemon is slower than the player's pokemon (but only after obtaining 5 badges)
; encourage effective or super effective draining moves to be used at low health
; PureRGBnote: FIXED: this subroutine won't cause the AI to prefer status moves 
;                     just because their type is super effective against the opponent. Like spamming agility on a poison pokemon.
; JOONAS: This means AIs with just this and the basic routine will only use Super effective damaging moves, ALWAYS
; And NEVER use not very effective moves. Even if it's their ONLY damaging move.
; This is just a bad logic, don't bother with this, the new damaging function is much more useful.
; replaced with explosion AI
AIMoveChoiceModification3: ; explosion AI
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z  ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z  ; no more moves in move set
	inc de
	call ReadMove ; else continue
	ld a, [wEnemyMoveEffect]
    cp EXPLODE_EFFECT
    jr nz, .nextMove ; ignore other moves aside from explody ones
	ld a, [wPlayerBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a ; check if player has a substitute up
	jr nz, .noBoom ; if the player has substitute don't explode
    call CompareSpeed ; check speed
    jr c, .slowerBoom ; if slower go to it's own routine
	inc [hl] ; else use some other move if faster + 1
.checkFullHPFaster
	ld a, 1	; check if AI mon at full hp
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr nc, .nextMove ; if at full hp go next move.
	dec [hl] ; encourage explosion if hurt	0
.CheckHalfHPFaster
	ld a, 2	; check if AI mon below 50% hp
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr nc, .nextMove ; if above 50% hp go next move.
	ld a, [hl]
	sub $7 ; heavily encourage move, this should be high enough to never fall behind other routines
	; but not high enough to ever bring back discarded moves from routine 1, while not rolling over 10
	ld [hl], a ; -7
	jr .nextMove ; check next move, we get 1 encouragement from KO routine
	
.noBoom
    inc [hl]
    inc [hl]
    inc [hl]
    jr .nextMove
  
.slowerBoom
.checkFullHPSlower
	ld a, 1	; check if AI mon at full hp
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr nc, .checkFullHPKO ; if at full hp go next move.
	ld a, [hl]
	sub $7 ; heavily encourage move, this should be high enough to never fall behind other routines
	; but not high enough to ever bring back discarded moves from routine 1, while not rolling over 10
	ld [hl], a ; -7
.CheckHalfHPSlower
	ld a, 2	; check if AI mon below 50% hp
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr nc, .nextMove ; if above 50% hp go next move.
	dec [hl] ; encourage explosion if below 50% hp
	jr .checkHalfHPKO ; check next move, we get 1 encouragement from KO routine
	
.checkFullHPKO
	ld a, [wBuffer +12 ] ; stored explosion KO
	ld c, a
	ld a, [wEnemyMoveNum] ; current move
	cp c ; compare
	jr nz, .nextMove ; if not a KO, ignore
	ld a, [hl]
	sub 6 ; boost to -7 total if KO
	ld [hl], a	
	jr .nextMove
	
.checkHalfHPKO
	ld a, [wBuffer +12 ] ; stored explosion KO
	ld c, a
	ld a, [wEnemyMoveNum] ; current move
	cp c ; compare
	jr nz, .nextMove ; if not a KO, ignore
    dec [hl] ; boost to total of -10
    dec [hl] ; boost to total of -10
	jr .nextMove

  
      
; old routine
;	ld a, [wEnemyMovePower]
;;	and a
;;	jr z, .nextMove ; ignores moves that do no damage (status moves), as we're only concerned with damaging moves for this modifier
;	ld a, [wAIMoveSpamAvoider] ; if we switched this turn or healed status, this is set
;	cp 2 ; it's 2 if we switched pokemon this turn
;	call nz, StoreBattleMonTypes ; in the case where we didnt switch
;								 ; we need to populate wAITargetMonType1 and wAITargetMonType2 with the current pokemon's type data
;	; this needs all these registers
;	push hl
;	push de
;	push bc
;	callfar AIGetTypeEffectiveness
;	pop bc
;	pop de
;	pop hl
;	;return the registers before returning
;	ld a, [wTypeEffectiveness]
;	cp EFFECTIVE ; compare to normally effective move
;	jr z, .checkSpecificEffects ; if found, check draining effect
;	jr c, .notEffectiveMove ; if lower than effective see as not very effective
;	;ld a, [wEnemyMoveEffect]
;	; check for reasons not to use a super effective move here
;	dec [hl] ; slightly encourage this super effective move
;.checkSpecificEffects ; we'll further encourage certain moves
;	call EncourageDrainingMoveIfLowHealth
;	jr .nextMove
;.notEffectiveMove ; discourages non-effective moves if better moves are available
;	push hl
;	push de
;	push bc
;	ld a, [wEnemyMoveType]
;	ld d, a
;	ld hl, wEnemyMonMoves  ; enemy moves
;	ld bc, NUM_MOVES + 1
;	ld c, $0
;.loopMoves
;	dec b
;	jr z, .done
;	ld a, [hli]
;	and a
;	jr z, .done
;	call ReadMove
;	ld a, [wEnemyMoveEffect]
;	cp SUPER_FANG_EFFECT
;	jr z, .betterMoveFound ; Super Fang is considered to be a better move
;	cp SPECIAL_DAMAGE_EFFECT
;	jr z, .betterMoveFound ; any special damage moves are considered to be better moves
;	cp FLY_EFFECT
;	jr z, .betterMoveFound ; Fly is considered to be a better move
;	ld a, [wEnemyMoveType]
;	cp d
;;	jr z, .loopMoves
;	ld a, [wEnemyMovePower]
;	and a
;	jr nz, .betterMoveFound ; damaging moves of a different type are considered to be better moves
;	jr .loopMoves
;.betterMoveFound
;	ld c, a
;.done
;	ld a, c
;	pop bc
;	pop de
;	pop hl
;	and a
;	jp z, .nextMove
;	inc [hl] ; slightly discourage this move
;	jp .nextMove
;.clearPreviousTypes
;	xor a
;	ld [wAITargetMonType1], a
;	ld [wAITargetMonType2], a
;	ret

;;;;;;;;;; PureRGBnote: ADDED: function that allows AI to be aware if their mon is slower than the playermon. Allows them to prefer priority moves.
CompareSpeed:
	push hl
	push de
	push bc
	ld hl, wEnemyMonSpeed + 1
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .switchSpeed
	ld de, wBattleMonSpeed + 1 ; first high byte
.compareSpeed; check if current speed is higher than the target's
	ld a, [de]
	dec de
	ld b, a; b is player mon high byte
	ld a, [hld] ; is ai mon high byte
	sub b ; substract
	ld a, [de]
	ld b, a
	ld a, [hl]
	sbc b ; carry flag set if player mon is faster(cleared if slower or speedtie)
	pop bc
	pop de
	pop hl
	ret
	
.switchSpeed
	ld de, wBuffer + 25 ; high byte first
	jr .compareSpeed
	
;;;;;;;;;;

; PureRGBnote: ADDED: if the opponent has less than 1/2 health they will prefer healing moves if they use AI subroutine 3
;EncourageDrainingMoveIfLowHealth:
;	ld a, [wEnemyMoveEffect]
;	cp DRAIN_HP_EFFECT
;	ret nz
;	ld a, 2 ; 1/2 maximum hp gone
;	call AICheckIfHPBelowFractionWrapped
;	ret nc
; [hl] ; encourage the draining move if enemy has more than half health gone
;	ret

; PureRGBnote: ADDED: AKA the "Apply Status and Heal when needed" subroutine
; slightly encourage moves with specific effects. 
; This one will make the opponent want to use status applying moves when you don't have one.
; It also makes them want to use dream eater if you're asleep, and want to use a recovery move at low health.
; JOONAS: Dream eater moved to damaging moves routine 5
AIMoveChoiceModification4:
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove4
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
;	ld a, [wEnemyMoveEffect]
;	cp DREAM_EATER_EFFECT ; moved to routine 5
;	jr z, .checkOpponentAsleep
	ld a, [wEnemyMovePower] ; remove all damaging moves
	and a ; check for 0
	jr nz, .nextMove4 ; if not zero, go next move
	ld a, [wEnemyMoveEffect]
	cp HEAL_EFFECT
	jp z, .checkWorthHealing
	cp CONFUSION_EFFECT
	jr z, .checkConfusion
	push hl
	push de
	push bc
	ld hl, Modifier4PreferredMoves
	ld de, 1
	call IsInArray
	pop bc
	pop de
	pop hl
	jr nc, .nextMove4 ; if not in list, ignore
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .checkOldStatus; if they did, check old status confusion
	ld a, [wBattleMonStatus] ; set to nonzero if player healed battle mon's status or switched one with a status out this turn
.checkStatus
	and a ; check for status
	jr nz, .nextMove4 ; ignore if already statused
	ld a, [wEnemyMoveEffect]
	cp PARALYZE_EFFECT ; check for paralyze
	jr z, .checkParalyzeSpeed
	cp POISON_EFFECT ; check for poison
	jp z, .checkPoisonStatus
.rankSleepMoves ; only sleep moves left
	ld a, [wEnemyMoveAccuracy]
	cp 75 percent ; check for accuracy
	jr z, .rankSleepPowder ; if 75, rank sleep powder/lovely kiss
	jr nc, .preferSpore ; if higher, spore is great, use it always
	call Random ; else we are left with sing/hypnosis
	cp 36 percent - 1 ; 57-58% chance roughly
	jr nc, .nextMove4
	jr .preferSleep
	
.rankSleepPowder	
	call Random
	cp 63 percent - 1; 75% chance roughly
	jr nc, .nextMove4
	jr .preferSleep

.preferSpore
	ld a, [hl]
	sub $8 ; -19
	ld [hl], a
.preferThunderWave
	ld a, [hl]
	sub $6 ; -11
	ld [hl], a
.preferSleep
	dec [hl] ; -5
.preferParalyze
	dec [hl] ; -4
.preferHeal
	dec [hl] ; -3
.preferPoison
	dec [hl] ; -2
.preferConfusion
	dec [hl] ; -1
	jr .nextMove4
    
.checkConfusion
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .checkOldStatusConf; if they did, check old status confusion
	ld a, [wPlayerBattleStatus1] ; if not load current status
.checkConfStat	
	bit CONFUSED, a ; if the player mon is confused
	jp z, .rankConfMoves ; encourage confusion if not confused
	jp .nextMove4 ; else ignore
		
.checkOldStatusConf		; check old status
	ld a, [wBuffer + 15] ; we borrow this for storing status1
	jr .checkConfStat
	
.rankConfMoves
    ld a, [wEnemyMoveNum]
    cp CONFUSE_RAY
    jr z, .rankConfusion
    call Random ; else rank supersonic
    cp 8 percent ; roughly 35% chance after move selection
    jp nc, .nextMove4
	jr .rankConfusion ; else ignore

.rankConfusion
    call Random
    cp 25 percent ; roughly 50% chance after move selection
    jp nc, .nextMove4
	jr .rankConfusion ; else ignore
	
.checkOldStatus
	ld a, [wAITargetMonStatus] ; set to nonzero if player healed battle mon's status or switched one with a status out this turn
	jr .checkStatus
	
.checkWorthHealing
	ld a, 2 ; 1/2 maximum HP
	call AICheckIfHPBelowFractionWrapped
	jp nc, .nextMove4 ; if HP is below 50% encourage using a healing move,
	call Random
	cp 63 - 1 percent ; 75% chance roughly
	jp nc, .nextMove4 
	jr .preferHeal ; otherwise encourage

.checkParalyzeSpeed
    call CompareSpeed
    jr nc, .dropPreference ; if faster, drop preference to 25%
	ld a, [wEnemyMoveAccuracy]
	cp 90 percent ; check for accuracy
	jr z, .rankGlare ; if 90, rank glare
	jr nc, .preferThunderWave ; if higher, thunderwave is great, use it always
	call Random ; else rank stun spore
	cp 63 percent - 1 ; 75% chance roughly
	jp nc, .nextMove4
	jr .preferParalyze
	
.rankGlare
	call Random
	cp 85 percent; 90% chance roughly
	jp nc, .nextMove4
	jr .preferParalyze

.rankMovePoison
    call Random
    cp 78 percent  ; roughly 85% chance after move selection
    jp nc, .nextMove4
    jr .preferPoison ; boost move		
						
.dropPreference	
    call Random
    cp 25 percent  ; roughly 25% chance after move selection
    jp nc, .nextMove4 ; ignore 75% of the time
    inc [hl] ; discourage move rest of the time
	jp .nextMove4 
	
.checkPoisonStatus
    ld a, 1 ; 100% hp check
    call AICheckIfPLayerHPBelowFractionWrapped
    jr nc, .rankMovePoison ; if playermon 100% hp , boost poison
    jp c, .nextMove4 ;else ignore

    

;.checkOpponentAsleep
;	ld a, [wAITargetMonStatus] ; set to nonzero if player healed battle mon's status or switched one with a status out this turn
;	and SLP_MASK
;	jr nz, .preferMoveEvenMore
;	ld a, [wAIMoveSpamAvoider] ; set if we switched or healed this turn
;	cp 2 ; set to 2 if we switched
;	jr z, .nextMove ; if the AI thinks the player IS NOT asleep before they switch, we shouldn't encourage based on the new mon's status
;	ld a, [wBattleMonStatus]
;	and SLP_MASK
;	jr z, .nextMove
;.preferMoveEvenMore
;	dec [hl]
;	jr .preferMove

;.done
;	ret

Modifier4PreferredMoves:
	db SLEEP_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
;	db BURN_SIDE_EFFECT2 ; 0 damage burn does not exist
;	db CONFUSION_EFFECT ; uses a different status pointer
	db -1 ; end
	
; START OF ADDED SECTION 

AIMoveChoiceModification5: ; best damage and knockout routine
	ld c, 3 ; initialized for second round check
	xor a
	ld hl, wHPBarNewHP ; this is borrowed to store highest damage
	ld [hli], a
	ld [hl], a
	ld hl, wBuffer + 8 ; zero recheck flags
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
.secondRound  ; we have to loop through entries twice so set this up
	dec c   
	ret z ; if second round done, end
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1  
.nextMove5
	dec b ; check if we did all moves
	jr z, .secondRound ; if round done, check for second round
	inc hl
	ld a, [de] ; check if last known move checked
	and a ; check for moves list running out
	jr z, .secondRound ; if round done, check for second round
	inc de
	call ReadMove
	ld a, [wEnemyMoveNum] ; we have to check for bide before, because it's non-damaging move
	cp BIDE ; check for bide
	jp z, .fullHPCheck ; check for below 100% hp
	ld a, [wEnemyMovePower]
	and a ; check for zero damage moves(bide also has 0 damage)
	jr z, .nextMove5 ; ignore if non damaging moves
	ld a, [wEnemyMoveEffect]
	cp OHKO_EFFECT ; check for OHKO moves
	jr z, .nextMove5 ; ignore OHKO moves
	ld a, [wEnemyMoveNum]
	cp COUNTER ; check for counter
	jr z, .halfHPCheck ; ignore Counter at below 50% hp
	cp DREAM_EATER ; check for dream eater
	jp z, .checkDreamEater ; ignore dream eater completely? This is the only damaging move the requires a condition.
	; we never want to discourage it anyway because it's psychic and draining, another routine should encourage it.
	push hl
	push de
	push bc
	callfar CalcAIMoveDamage ; this saves the move damage(high crit moves assumed to crit) in wDamage and sets carry if knockout
	jp c, .encourageCheck ; we send knockout moves to priorization, else we compare for highest damage
	; we compare the previous highest damage to current move damage 
	ld a, [wHPBarNewHP] ; load the previous highest damage value high byte
	ld b, a ; bc is damage
	ld a, [wHPBarNewHP + 1] ; load the previous highest damage value low byte
	ld c, a ; bc is damage
	ld a, [wDamage + 1] ; load current move damage low byte
	cp c ; substract low byte
	ld a, [wDamage] ; load current move damage high byte
	sbc b ; substract high byte with carry ; sets carry if previous damage is higher
	jr c, .badMove ; if previous move did better damage, this is a bad move
	ld a, [wDamage] ; if higher, set comparison value to new value
	ld [wHPBarNewHP], a ; store high byte
	ld a, [wDamage + 1]        
	ld [wHPBarNewHP + 1], a ;  store low byte
	pop bc
	pop de
	pop hl ; release registers
	jr .nextMove5 ; check next move until all moves are checked
                                          
.badMove
	pop bc
	pop de
	pop hl ; return registers
.markBideCounter
    call MarkAnalyze
    jr nc, .nextMove5 ; if already analyzed check next move
	ld a, [wEnemyMoveEffect]	
	cp DRAIN_HP_EFFECT ; check for draining moves
	jr nz, .dropMove ; if not a draining move continue as normal
	ld a, 2	; else check for HP below 50%
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr nc, .dropMove ; do discourage draining moves above 50% hp
	call Random ; if below 50%, give a random chance to boost the move
	cp 33 percent - 1 ; 33% chance to boost move
	jr nc, .dropMove ; ~50% chance to use move(no moves probably eliminated)
	dec [hl]
	dec [hl]
	dec [hl]	 ; boost draining move
	jr .nextMove5
	
.dropMove ; else discourage
	ld a, [hl]
	add $2 ; push move to low priority, still possible to advance past it with other modifiers
	ld [hl], a
	jp .nextMove5 ; check next move

.encourageQuickAttack ; should take priority over everything else
	dec [hl] 
	dec [hl]  
	dec [hl]  ; max encouragement at -20
.encourageSwift ; Never miss
	dec [hl]  ; encouragement of -17
.encourageDrain ; draining moves
	dec [hl]  ; encouragement of -16
.encourageAccurate ; 100% accuracy moves
	dec [hl]  ; encouragement of -15
.encourageRecoil ; recoil moves are 100% accurate
	dec [hl]  ; encouragement of -14
.encourageMore ; rest of normal damaging moves
	dec [hl]  ; encouragement of -13
.encourageCharge ; charge moves are 100% accurate but give a chance to switch
	ld a, [hl]
	sub $b ; heavily encourage move, this should be high enough to never fall behind other routines
	; but not high enough to ever bring back discarded moves from routine 1, while not rolling over 20
	ld [hl], a ; -12
.encourage ; self destruct moves
	dec [hl]  ; encouragement of -1
	jp .nextMove5
	
.fullHPCheck
	ld a, 1	; else check for HP below 100%
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr c, .markBideCounter ; don't use bide below 100% hp
	ld a, [hl] ; else
	sub $7 ; force Brock to open with Bide.
	ld [hl], a ; -7
	jp .nextMove5 ; check next move until all moves are checked
	
.halfHPCheck
	ld a, 2	; else check for HP below 50%
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jr c, .markBideCounter ; don't use counter below 50% hp
	jp .nextMove5 ; check next move until all moves are checked
	
.checkDreamEater ; Routine to check player mon sleep status
    call MarkAnalyze
    jp nc, .nextMove5 ; if already analyzed check next move
	ld a, [wAIMoveSpamAvoider] ; check if player switched
	cp 2 ; set to two if switched
	jr z, .switchedDreamEater ; go check preswitch status if switched
	ld a, [wBattleMonStatus] ; else check current status
.sleepStatus
	and SLP_MASK ; check for sleep status
	jp z, .nextMove5 ; if the player mon is not asleep ignore
.encourageDreamEater ; else encourage dream eater
	ld a, [hl]
	sub $9 ; heavily encourage move, this should be high enough to never fall behind other routines
	; but not high enough to ever bring back discarded moves from routine 1, while not rolling over 10
	ld [hl], a ; -12
	jp .nextMove5 ; else, ignore
		
.switchedDreamEater
	ld a, [wAITargetMonStatus] ; check previous status
	jr .sleepStatus ; else ignore

.encourageCheck ; prioritize moves for knocking out player mon
	pop bc
	pop de
	pop hl ; return registers here
    call MarkAnalyze
    jp nc, .nextMove5 ; if already analyzed check next move
	ld a, [wEnemyMoveNum]
	cp QUICK_ATTACK ; check for quick attack
	jr z, .encourageQuickAttack
	cp SWIFT ; check for swift
	jr z, .encourageSwift
	ld a, [wEnemyMoveEffect]
	cp EXPLODE_EFFECT ; check for selfdestruct moves
	jr z, .storeExplosionKO
	cp RECOIL_EFFECT ; check for recoil moves, all of them are 100% accurate
	jr z, .encourageRecoil
	cp DRAIN_HP_EFFECT ; check for drain moves, all of them are 100% accurate
	jr z, .checkDrainHPKO
	cp TRAPPING_EFFECT ; check for trapping moves,
	jr z, .checkTrap
	cp FLY_EFFECT ; check for charge moves,
	jr z, .encourageCharge
	cp CHARGE_EFFECT ; check for charge moves,
	jr z, .encourageCharge
	ld a, [wEnemyMoveAccuracy]
	cp 100 percent; check for accurate moves
	jr nc, .encourageAccurate
	jr .encourageMore ; the rest of the moves all grouped together
	; there is a case to be made to separate multihit moves after these still
	
.checkDrainHPKO
	ld a, 2	; check for HP below 50%
	call AICheckIfHPBelowFractionWrapped ; checks for HP/a and returns carry if it is
	jp c, .encourageDrain ; prioritize draining moves below 50% hp
	jp .encourageAccurate ; else send it to the rest of the accurate moves
	
.storeExplosionKO
    ld a, [wEnemyMoveNum]
    ld [wBuffer + 12], a
	jp z, .encourage
   
.checkTrap ; this neutralisez the use wrap if faster boost if applicable
    call CompareSpeed ; check speed
    jp c, .encourageMore  ; if AI mon slower, return to normal loop
	ld a, [hl] ; else
	add $6 ; neutralize already boosted faster wrap status.
	ld [hl], a ; +6
    jp .encourageMore ; return to normal loop

MarkAnalyze: ;returns with carry if not analyzed
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hl] ; check if already analyzed
	cp 1 ; sets carry if not analyzed
	jr z, .markEnd ; if it has, return without carry
	ld [hl], 1 ; this is to mark move analyzed so it does not get modified twice. It's the same buffer 8 bytes further
.markEnd	
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	ret                  

AIMoveChoiceModification6: ; wrap AI
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove6
	dec b
	ret z  ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z  ; no more moves in move set
	inc de
	call ReadMove
	ld a, [wEnemyMoveEffect]
	cp TRAPPING_EFFECT ; check for trapping moves
	jr nz, .nextMove6
	call CompareSpeed ; check for speed
	jr c, .nextMove6 ; if AI mon slower, don't boost trapping 
	ld a, [hl]
	sub $6 ; heavily encourage move, this should be high enough to never fall behind other routines
	; but not high enough to ever bring back discarded moves from routine 1, while not rolling over 10
	ld [hl], a ; -6
	jr .nextMove6
	
		
	
;END OF ADDED SECTION

ReadMove:
	push hl
	push de
	push bc
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wEnemyMoveNum
	call CopyData
	pop bc
	pop de
	pop hl
	ret

INCLUDE "data/trainers/move_choices.asm"

INCLUDE "data/trainers/pic_pointers_money.asm"

INCLUDE "data/trainers/names.asm"

INCLUDE "engine/battle/misc.asm"

INCLUDE "engine/battle/read_trainer_party.asm"

INCLUDE "data/trainers/special_moves.asm"

INCLUDE "data/trainers/parties.asm"

TrainerAI:
	and a
	ld a, [wIsInBattle]
	dec a
	ret z ; if not a trainer, we're done here
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z ; if in a link battle, we're done as well
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;shinpokerednote: FIXED: AI should not use actions (items / switching) if in a move that prevents such a thing
	and a ; clear carry flag in case we return due to the next two checks,
		; we dont want carry returned in those cases as it marks an action as being taken by the opponent.
	ld a, [wEnemyBattleStatus2]
	bit NEEDS_TO_RECHARGE, a
	ret nz
	ld a, [wEnemyBattleStatus1]
	and %01110010 
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ld a, [wTrainerClass] ; what trainer class is this?
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerAIPointers
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [wAICount]
	and a
	ret z ; if no AI uses left, we're done here
	inc hl
	inc a
	jr nz, .getpointer
	dec hl
	ld a, [hli]
	ld [wAICount], a
.getpointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Random
	jp hl

INCLUDE "data/trainers/ai_pointers.asm"

JugglerAI:
	cp 25 percent + 1
	ret nc
	jp AISwitchIfEnoughMons

BlackbeltAI:
	cp 13 percent - 1
	ret nc
	jp AIUseXAttack

GiovanniAI:
	and a
	ret
	; cp 25 percent + 1
	; ret nc
	; jp AIUseGuardSpec

CooltrainerMAI:
	cp 25 percent + 1
	ret nc ; 25% chance to do anything below
	ld a, 3 ; below 33% hp
	call AICheckIfHPBelowFraction ; first check hp
	jp c, AIUseHyperPotion ; if below 33% use hyper potion
	ld a, 2 ; below 50%
	call AICheckIfHPBelowFraction ; second check hp
	ret nc ; do nothing if above 50%
	jp AISwitchIfEnoughMons ; if below, switch pokemon if another available

CooltrainerFAI:
	cp 25 percent + 1
	ret nc ; 25% chance to do anything below
	ld a, 3 ; below 33% hp
	call AICheckIfHPBelowFraction ; first check hp
	jp c, AIUseHyperPotion ; if below 33% use hyper potion
	ld a, 2 ; below 50%
	call AICheckIfHPBelowFraction ; second check hp
	ret nc ; do nothing if above 50%
	jp AISwitchIfEnoughMons ; if below, switch pokemon if another available

BrockAI:
	and a
	ret
; ; if his active monster has a status condition, use a full heal
; 	ld a, [wEnemyMonStatus]
; 	and a
; 	ret z
; 	jp AIUseFullHeal

MistyAI:
	and a
	ret
	; cp 25 percent + 1
	; ret nc
	; jp AIUseXDefend

LtSurgeAI:
	and a
	ret
	; cp 25 percent + 1
	; ret nc
	; jp AIUseXSpeed

ErikaAI:
	and a
	ret
	; cp 50 percent + 1
	; ret nc
	; ld a, 10
	; call AICheckIfHPBelowFraction
	; ret nc
	; jp AIUseSuperPotion

KogaAI:
	and a
	ret
	; cp 13 percent - 1
	; ret nc
	; jp AIUseXAttack

BlaineAI:
	and a
	ret
	; cp 25 percent + 1
	; ret nc
	; ld a, 10
	; call AICheckIfHPBelowFraction
	; ret nc
	; jp AIUseSuperPotion

SabrinaAI:
	and a
	ret
	; cp 25 percent + 1
	; ret nc
	; jp AIUseXDefend

Rival2AI:
	and a
	ret
	; cp 13 percent - 1
	; ret nc
	; ld a, 5
	; call AICheckIfHPBelowFraction
	; ret nc
	; jp AIUsePotion

Rival3AI:
	and a
	ret
	; cp 13 percent - 1
	; ret nc
	; ld a, 5
	; call AICheckIfHPBelowFraction
	; ret nc
	; jp AIUseFullRestore

LoreleiAI:
	and a
	ret
	; cp 50 percent + 1
	; ret nc
	; ld a, 5
	; call AICheckIfHPBelowFraction
	; ret nc
	; jp AIUseSuperPotion

BrunoAI:
	and a
	ret
	; cp 25 percent + 1
	; ret nc
	; jp AIUseXDefend

AgathaAI:
	and a
	ret
	; cp 8 percent
	; jp c, AISwitchIfEnoughMons
	; cp 50 percent + 1
	; ret nc
	; ld a, 4
	; call AICheckIfHPBelowFraction
	; ret nc
	; jp AIUseSuperPotion

LanceAI:
	and a
	ret
	; cp 50 percent + 1
	; ret nc
	; ld a, 5
	; call AICheckIfHPBelowFraction
	; ret nc
	; jp AIUseHyperPotion

GenericAI:
	and a ; clear carry
	ret

; end of individual trainer AI routines

DecrementAICount:
	ld hl, wAICount
	dec [hl]
	scf
	ret

AIPlayRestoringSFX:
	ld a, SFX_HEAL_AILMENT
	jp PlaySoundWaitForCurrent

; AIUseFullRestore: ; not in use anymore
	; call AICureStatus
	; ld a, FULL_RESTORE
	; ld [wAIItem], a
	; ld de, wHPBarOldHP
	; ld hl, wEnemyMonHP + 1
	; ld a, [hld]
	; ld [de], a
	; inc de
	; ld a, [hl]
	; ld [de], a
	; inc de
	; ld hl, wEnemyMonMaxHP + 1
	; ld a, [hld]
	; ld [de], a
	; inc de
	; ld [wHPBarMaxHP], a
	; ld [wEnemyMonHP + 1], a
	; ld a, [hl]
	; ld [de], a
	; ld [wHPBarMaxHP+1], a
	; ld [wEnemyMonHP], a
	; jr AIPrintItemUseAndUpdateHPBar

; ;AIUsePotion:; not in use anymore
; ; enemy trainer heals his monster with a potion
	; ld a, POTION
	; ld b, 20
	; jr AIRecoverHP

; AIUseSuperPotion:; not in use anymore
; ; enemy trainer heals his monster with a super potion
	; ld a, SUPER_POTION
	; ld b, 50
	; jr AIRecoverHP

AIUseHyperPotion:
; enemy trainer heals his monster with a hyper potion
	ld a, HYPER_POTION
	ld b, 200
	; fallthrough

AIRecoverHP:
; heal b HP and print "trainer used $(a) on pokemon!"
	ld [wAIItem], a
	ld hl, wEnemyMonHP + 1
	ld a, [hl]
	ld [wHPBarOldHP], a
	add b
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	ld [wHPBarNewHP+1], a
	jr nc, .next
	inc a
	ld [hl], a
	ld [wHPBarNewHP+1], a
.next
	inc hl
	ld a, [hld]
	ld b, a
	ld de, wEnemyMonMaxHP + 1
	ld a, [de]
	dec de
	ld [wHPBarMaxHP], a
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	ld [wHPBarMaxHP+1], a
	sbc b
	jr nc, AIPrintItemUseAndUpdateHPBar
	inc de
	ld a, [de]
	dec de
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [de]
	ld [hl], a
	ld [wHPBarNewHP+1], a
	; fallthrough

AIPrintItemUseAndUpdateHPBar:
	call AIPrintItemUse_
	hlcoord 2, 2
	xor a
	ld [wHPBarType], a
	predef UpdateHPBar2
	jp DecrementAICount

AISwitchIfEnoughMons:
; enemy trainer switches if there are 2 or more unfainted mons in party
	ld a, [wEnemyPartyCount]
	ld c, a
	ld hl, wEnemyMon1HP

	ld d, 0 ; keep count of unfainted monsters

	; count how many monsters haven't fainted yet
.loop
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .Fainted ; has monster fainted?
	inc d
.Fainted
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	add hl, bc
	pop bc
	dec c
	jr nz, .loop

	ld a, d ; how many available monsters are there?
	cp 2    ; don't bother if only 1
	jp nc, SwitchEnemyMon
	and a
	ret

SwitchEnemyMon:

; prepare to withdraw the active monster: copy hp, number, and status to roster

	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wEnemyMonHP
	ld bc, 4
	call CopyData

	ld hl, AIBattleWithdrawText
	call PrintText

	; This wFirstMonsNotOutYet variable is abused to prevent the player from
	; switching in a new mon in response to this switch.
	ld a, 1
	ld [wFirstMonsNotOutYet], a
	callfar EnemySendOut
	xor a
	ld [wFirstMonsNotOutYet], a

	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
	scf
	ret

AIBattleWithdrawText:
	text_far _AIBattleWithdrawText
	text_end

; AIUseFullHeal: ; not in use anymore
	; call AIPlayRestoringSFX
	; call AICureStatus
	; ld a, FULL_HEAL
	; jp AIPrintItemUse

; AICureStatus:	;shinpokerednote: CHANGED: modified to be more robust and also undo stat changes of brn/par ; not in use anymore
; ; cures the status of enemy's active pokemon
	; ld a, [wEnemyMonPartyPos]
	; ld hl, wEnemyMon1Status
	; ld bc, wEnemyMon2 - wEnemyMon1
	; call AddNTimes
	; xor a
	; ld [hl], a ; clear status in enemy team roster
	; ldh a, [hWhoseTurn]
	; push af
	; ld a, $01 	;forcibly set it to the AI's turn
	; ldh [hWhoseTurn], a
	; call UndoBurnParStats	;undo brn/par stat changes
	; pop af
	; ldh [hWhoseTurn], a
	; xor a
	; ld [wEnemyMonStatus], a ; clear status in active enemy data
	; ld hl, wEnemyBattleStatus3
	; res BADLY_POISONED, [hl]	;clear toxic bit
	; ret

; AIUseXAccuracy: ; unused
	; call AIPlayRestoringSFX
	; ld hl, wEnemyBattleStatus2
	; set 0, [hl]
	; ld a, X_ACCURACY
	; jp AIPrintItemUse

; AIUseGuardSpec: ; not in use anymore
	; call AIPlayRestoringSFX
	; ld hl, wEnemyBattleStatus2
	; set 1, [hl]
	; ld a, GUARD_SPEC
	; jp AIPrintItemUse

; AIUseDireHit: ; unused
	; call AIPlayRestoringSFX
	; ld hl, wEnemyBattleStatus2
	; set 2, [hl]
	; ld a, DIRE_HIT
	; jp AIPrintItemUse

; PureRGBnote: ADDED: if enemy HP is below a 1/[wUnusedC000], store 1 in wUnusedC000.
; used for checking whether the hyper ball item should guarantee success on use
AICheckIfHPBelowFractionStore::
	ld a, [wUnusedC000]
	call AICheckIfHPBelowFraction
	jr c, .below
	xor a
	jr .done
.below
	ld a, 1
.done
	ld [wUnusedC000], a 
	ret

AICheckIfHPBelowFractionWrapped: ; preload a with divisor for use
	push hl
	push bc
	push de
	call AICheckIfHPBelowFraction
	pop de
	pop bc
	pop hl
	ret

AICheckIfHPBelowFraction: ; use a to preload with divisor for use
; return carry if enemy trainer's current HP is below 1 / a of the maximum
	ldh [hDivisor], a
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ldh [hDividend], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld c, a
	ldh a, [hQuotient + 2]
	ld b, a
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, d
	sub b
	ret nz
	ld a, e
	sub c
	ret
	
AICheckIfPLayerHPBelowFractionWrapped: ; preload a with divisor for use
	push hl
	push bc
	push de
	call AICheckIfPLayerHPBelowFraction
	pop de
	pop bc
	pop hl
	ret

AICheckIfPLayerHPBelowFraction: ; use a to preload with divisor for use
; return carry if enemy trainer's current HP is below 1 / a of the maximum
	ldh [hDivisor], a
	ld a, [wAIMoveSpamAvoider]
	cp 2 ; set to two if switched
	jr z, .loadOldMaxHP ; load old max hp
	ld hl, wBattleMonMaxHP ; load current max hp; high byte first
.loadDividing
	ld a, [hli]
	ldh [hDividend], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld c, a
	ldh a, [hQuotient + 2]
	ld b, a
	ld a, [wAIMoveSpamAvoider]
	cp 2 ; set to two if switched
	jr z, .loadOldHP ; load old hp
	ld hl, wBattleMonHP + 1 ; load current hp; low byte first
.compareMaxHp
	ld a, [hld]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, d
	sub b
	ret nz
	ld a, e
	sub c
	ret

.loadOldMaxHP
    ld hl, wBuffer + 13 ; high byte first
    jr .loadDividing
    
.loadOldHP
    ld hl, wBuffer + 17 ; low byte first
    jr .compareMaxHp

AIUseXAttack:
	ld b, $A
	ld a, X_ATTACK
;	jr AIIncreaseStat ; fallthrough now that rest are unused

; AIUseXDefend: ; not in use anymore
	; ld b, $B
	; ld a, X_DEFEND
	; jr AIIncreaseStat

; AIUseXSpeed:; not in use anymore
	; ld b, $C
	; ld a, X_SPEED
	; jr AIIncreaseStat

; AIUseXSpecial: ; unused
	; ld b, $D
	; ld a, X_SPECIAL
	; ; fallthrough

AIIncreaseStat:
	ld [wAIItem], a
	push bc
	call AIPrintItemUse_
	pop bc
	ld hl, wEnemyMoveEffect
	ld a, [hld]
	push af
	ld a, [hl]
	push af
	push hl
	ld a, XSTATITEM_DUPLICATE_ANIM
	ld [hli], a
	ld [hl], b
	callfar StatModifierUpEffect
	pop hl
	pop af
	ld [hli], a
	pop af
	ld [hl], a
	jp DecrementAICount

AIPrintItemUse:
	ld [wAIItem], a
	call AIPrintItemUse_
	jp DecrementAICount

AIPrintItemUse_:
; print "x used [wAIItem] on z!"
	ld a, [wAIItem]
	ld [wd11e], a
	call GetItemName
	ld hl, AIBattleUseItemText
	jp PrintText

AIBattleUseItemText:
	text_far _AIBattleUseItemText
	text_end

;;;;;;;;;; PureRGBnote: ADDED: these wram properties are used to make sure the 
;;;;;;;;;;                     AI doesn't instantly read the player's current pokemon type after a player switches.
;;;;;;;;;;                     makes sure the AI doesn't appear to predict all your switch-outs of pokemon.
StoreBattleMonTypes:
	push hl
	ld hl, wBattleMonType
	ld a, [hl]                 ; b = type 1 of player's pokemon
	ld [wAITargetMonType1], a
	inc hl
	ld a, [hl]                 ; c = type 2 of player's pokemon
	ld [wAITargetMonType2], a
	pop hl
	ret

; Used by the pureRGB AI
;shinpokerednote: ADDED: doubles attack if burned or quadruples speed if paralyzed.
;It's meant to be run right before healing paralysis or burn so as to 
;undo the stat changes.
UndoBurnParStats:
	ld hl, wBattleMonStatus
	ld de, wPlayerStatsToDouble
	ldh a, [hWhoseTurn]
	and a
	jr z, .checkburn
	ld hl, wEnemyMonStatus
	ld de, wEnemyStatsToDouble
.checkburn
	ld a, [hl]		;load statuses
	and 1 << BRN	;test for burn 
	jr z, .checkpar
	ld a, $01
	ld [de], a	;set attack to be doubled to undo the stat change of BRN
	call DoubleSelectedStats
	jr .return
.checkpar
	ld a, [hl]		;load statuses
	and 1 << PAR	;test for paralyze 
	jr z, .return
	ld a, $04
	ld [de], a	;set speed to be doubled (done twice) to undo the stat change of BRN
	call DoubleSelectedStats
	call DoubleSelectedStats
.return
	xor a
	ld [de], a	;reset the stat change bits
	ret
