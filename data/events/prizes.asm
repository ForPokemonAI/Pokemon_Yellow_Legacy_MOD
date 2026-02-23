PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries, PrizeMenuMon1Cost
	dw PrizeMenuMon2Entries, PrizeMenuMon2Cost
	dw PrizeMenuTMsEntries,  PrizeMenuTMsCost

PrizeMenuMon1Entries:
;	db ABRA ; (too easy)
;	db SEEL ; (too early for ice)
	db MAGMAR
	db ELECTABUZZ ; Allow all human types
	db MR_MIME ; Allow all human types (jynx too early for ice)
	db "@"

PrizeMenuMon1Cost:
;	bcd2 230
;	bcd2 500
	bcd2 1500 ; (30 000 $)
	bcd2 2000 ; (40 000 $)
	bcd2 2500 ; (50 000 $)
	db "@"

PrizeMenuMon2Entries:
;	db ELECTABUZZ ; moved to first list
	db DRATINI
	db EEVEE ; if you can't catch it, buy it
	db PORYGON
	db "@"

PrizeMenuMon2Cost:
;	bcd2 1500 ; (30 000 $)
	bcd2 5000 ; (100 000 $)
	bcd2 9999 ; (200 000 $)
	bcd2 3000 ; (60 000 $)
;	bcd2 4500 ; (90 000 $)
	db "@"

PrizeMenuTMsEntries:
	db TM_DRAGON_RAGE
	db TM_HYPER_BEAM
	db TM_SUBSTITUTE
	db "@"

PrizeMenuTMsCost:
	bcd2 1000
	bcd2 5000
	bcd2 3000
	db "@"
