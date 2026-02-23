ReadSuperRodData:
	ld hl, SuperRodFishingSlots
	ld a, [wCurMap]
	ld c, a
.loopSuper
	ld a, [hli]
	cp $ff
	jr z, .notfoundSuper
	cp c
	jr z, .foundSuper
	ld de, $8 ; this table has 4 pokemon per entry
	add hl, de
	jr .loopSuper
.foundSuper
        xor a ; set marker that we are coming from super rod
	call GenerateRandomFishingEncounter
	ret
.notfoundSuper
	ld de, $0
	ret

GenerateRandomFishingEncounter:
        and a ; check if we are coming from super rod
        jr z, .encounterSuperRod ; if so, jump to super rod section
	call Random ; else continue as good/old rods are similar
	cp $c0 ; 75% chance for first table entry
	jr c, .asm_f5ed6 ; load data and return
	inc hl ; increase pointer to next entry
	inc hl ; increase pointer to next entry
	jr .asm_f5ed6 ; load data and return
        
.encounterSuperRod
	call Random
	cp $66
	jr c, .asm_f5ed6
	inc hl
	inc hl
	cp $b2
	jr c, .asm_f5ed6
	inc hl
	inc hl
	cp $e5
	jr c, .asm_f5ed6
	inc hl
	inc hl
.asm_f5ed6
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret
	
ReadOldRodData:
	ld hl, OldRodFishingSlots
	ld a, [wCurMap]
	ld c, a
.loopOld
	ld a, [hli]
	cp $ff
	jr z, .notfoundOld
	cp c
	jr z, .foundOld
	ld de, $4 ; these tables have only 2 pokemon per entry
	add hl, de
	jr .loopOld
.foundOld
	ld a, 1; set marker we are not coming from super rod
	call GenerateRandomFishingEncounter
	ret
.notfoundOld
	ld de, $0
	ret
	
ReadGoodRodData:
	ld hl, GoodRodFishingSlots
	ld a, [wCurMap]
	ld c, a
.loopGood
	ld a, [hli]
	cp $ff
	jr z, .notfoundGood
	cp c
	jr z, .foundGood
	ld de, $4 ; these tables have only 2 pokemon per entry
	add hl, de
	jr .loopGood
.foundGood
	ld a, 1; set marker we are not coming from super rod
	call GenerateRandomFishingEncounter
	ret
.notfoundGood
	ld de, $0
	ret

INCLUDE "data/wild/super_rod.asm"
INCLUDE "data/wild/old_rod.asm"
INCLUDE "data/wild/good_rod.asm"
