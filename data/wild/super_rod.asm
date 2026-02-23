;The chances are ~40% first slot, ~30% second slot, ~20% thid slot, ~11% last slot
SuperRodFishingSlots::
        db PALLET_TOWN, GOLDEEN, 31, KRABBY, 27, SEAKING, 36, KINGLER, 35
        db VIRIDIAN_CITY, GOLDEEN, 29, GOLDEEN, 32, POLIWHIRL, 32, POLIWHIRL, 34
        db CERULEAN_CITY, GOLDEEN, 31, GOLDEEN, 32, POLIWHIRL, 33, POLIWHIRL, 35
        db VERMILION_CITY, KRABBY, 27, GOLDEEN, 29, GRIMER, 28, KINGLER, 30
        db CELADON_CITY, POLIWHIRL, 27, POLIWHIRL, 30, GRIMER, 28, GRIMER, 31
        db FUCHSIA_CITY, MAGIKARP, 25, MAGIKARP, 30, MAGIKARP, 35, MAGIKARP, 40
        db CINNABAR_ISLAND, KINGLER, 39, SEADRA, 43, SHELLDER, 42, STARYU, 41
        db ROUTE_4, GOLDEEN, 32, SEAKING, 35, KINGLER, 33, POLIWHIRL, 36
        db ROUTE_6, GOLDEEN, 30, POLIWHIRL, 31, GOLDEEN, 32, POLIWHIRL, 33
        db ROUTE_24, SEAKING, 34, SEAKING, 35, KINGLER, 32, KINGLER, 34
        db ROUTE_25, GOLDEEN, 32, SEAKING, 34, KINGLER, 33, SEADRA, 35
        db ROUTE_10, KINGLER, 31, SEAKING, 33, MAGNEMITE, 23, VOLTORB, 25
        db ROUTE_11, GOLDEEN, 28, KRABBY, 27, GOLDEEN, 30, KINGLER, 31
        db ROUTE_12, HORSEA, 25, TENTACOOL, 26, TENTACOOL, 28, SEADRA, 30
        db ROUTE_13, HORSEA, 26, TENTACOOL, 27, TENTACOOL, 29, SEADRA, 31
        db ROUTE_17, TENTACOOL, 26, TENTACOOL, 28, SHELLDER, 26, SHELLDER, 29
        db ROUTE_18, TENTACOOL, 27, TENTACOOL, 29, SHELLDER, 27, SHELLDER, 30
        db ROUTE_19, TENTACOOL, 27, TENTACOOL, 29, STARYU, 27, STARYU, 30
        db ROUTE_20, STARYU, 35, SHELLDER, 34, SHELLDER, 39, STARYU, 40
        db ROUTE_21, SEAKING, 35, SEADRA, 37, SHELLDER, 39, STARYU, 40
        db ROUTE_22, POLIWHIRL, 32, POLIWHIRL, 35, POLIWHIRL, 38, DRATINI, 28
        db ROUTE_23, SEAKING, 37, SEAKING, 41, DRAGONAIR, 35, GYARADOS, 38
        db VERMILION_DOCK, GOLDEEN, 28, GOLDEEN, 31, GRIMER, 30, SEAKING, 33
        db SAFARI_ZONE_CENTER, SEAKING, 34, POLIWHIRL, 31, SEAKING, 37, POLIWHIRL, 34
        db SAFARI_ZONE_EAST, GOLDEEN, 32, SEAKING, 35, POLIWHIRL, 36, SEAKING, 40
        db SAFARI_ZONE_NORTH, POLIWHIRL, 30, POLIWHIRL, 33, POLIWHIRL, 37, POLIWHIRL, 40
        db SAFARI_ZONE_WEST, POLIWHIRL, 28, GOLDEEN, 29, POLIWHIRL, 35, GOLDEEN, 32
        db SEAFOAM_ISLANDS_B3F, KINGLER, 39, SHELLDER, 43, STARYU, 41, SEADRA, 44
        db SEAFOAM_ISLANDS_B4F, KABUTO, 35, OMANYTE, 34, OMANYTE, 37, KABUTO, 38
        db CERULEAN_CAVE_1F, POLIWRATH, 60, SEADRA, 60, TENTACRUEL, 60, GYARADOS, 60
        db CERULEAN_CAVE_B1F, KINGLER, 60, SEAKING, 60, CLOYSTER, 60, STARMIE, 60
	db -1 ; end, JOONAS CHANGED THE WHOLE ENCOUNTER TABLE

; This is just used for the pokedex where do monsters appear feature
; This is responsible for adding ALL rod encounters, not just super rod
; This needs to be modified to check for good/old rod tables, if those are added
CheckMapForFishingMon: 
	push hl
	push bc
	ld hl, SuperRodFishingSlots
.loopsSuper
	ld a, [hl] ; current map idW
	cp $ff
	jr z, .doneSuper
	ld c, a
	inc hl

	ld b, $0
.loopSuper2
	ld a, $4 ; 4 pokemon per map database entry
	cp b
	jr z, .loopsSuper
	ld a, [wd11e] ; ID of the mon we're searching for
	cp [hl]
	jr nz, .notfoundSuper
.foundSuper
	dec de
	ld a, [de]
	cp c
	inc de
	jr z, .notfoundSuper ; already added this to buffer
	ld a, c ; found so add map id to list
	ld [de], a
	inc de
.notfoundSuper
	inc hl
	inc hl
	inc b
	jr .loopSuper2
.doneSuper ; super rod is done, check good rod
	ld hl, GoodRodFishingSlots
.loopGood
	ld a, [hl] ; current map idW
	cp $ff
	jr z, .doneGood
	ld c, a
	inc hl

	ld b, $0
.loopGood2
	ld a, $2 ; 2 pokemon per map database entry
	cp b
	jr z, .loopGood
	ld a, [wd11e] ; ID of the mon we're searching for
	cp [hl]
	jr nz, .notfoundGood
.foundGood
	dec de
	ld a, [de]
	cp c
	inc de
	jr z, .notfoundGood ; already added this to buffer
	ld a, c ; found so add map id to list
	ld [de], a
	inc de
.notfoundGood
	inc hl
	inc hl
	inc b
	jr .loopGood2
.doneGood ; good rod is done, check old rod
	ld hl, OldRodFishingSlots
.loopOld
	ld a, [hl] ; current map idW
	cp $ff
	jr z, .doneOld
	ld c, a
	inc hl

	ld b, $0
.loopOld2
	ld a, $2 ; 2 pokemon per map database entry
	cp b
	jr z, .loopOld
	ld a, [wd11e] ; ID of the mon we're searching for
	; Do old rod and good rod mons manually because there's so little of them
	cp [hl]
	jr nz, .notfoundOld
.foundOld
	dec de
	ld a, [de]
	cp c
	inc de
	jr z, .notfoundOld ; already added this to buffer
	ld a, c ; found so add map id to list
	ld [de], a
	inc de
.notfoundOld
	inc hl
	inc hl
	inc b
	jr .loopOld2
.doneOld
	pop bc
	pop hl
	ret
