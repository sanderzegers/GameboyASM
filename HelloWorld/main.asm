; Based on Hello-World tutorial https://eldred.fr/gb-asm-tutorial/hello-world.html

INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]


; We have just 4 bytes of code here until the GB Header start. So only space for a jump
Entrypoint:
    di; disable interrupts
    jp Start;


; Just put enpty space. rgbfix will add necessary data later
REPT $150 - $104
    db 0
ENDR


Section "Game code", rom0

Start:
;turn off LCD (to access VRAM)

.waitVBlank
ld a, [rLY]
cp 144; Check if LCD is past VBLANK
jr c, .waitVBlank

xor a;
ld a,0; // reset bit 7 (or all flags in this case)
ld [rLCDC], a;

ld hl, $9000
ld de, FontTiles
ld bc, FontTilesEnd -  FontTiles

.copyFont

ld a, [de]; grab 1 byte from source
ld [hli], a; place it at the dest, incr hl
inc de; move to next byte
dec bc; decremt count
ld a,b; check if count is 0
or c
jr nz, .copyFont

ld hl, $9800; will print string at top-left corner
ld de, HelloWorldStr

.copyString

ld a, [de]
ld [hli], a
inc de
and a; check if byte we just copied is zero
jr nz, .copyString; continue if not

; Init display registers

ld a, %11100100
ld [rBGP], a

xor a; ld a,0
ld [rSCX], a
ld [rSCY], a

; disable sound
ld [rNR52], a

;Turn screen on, display background
ld a, %10000001
ld [rLCDC], a

; lock up

.lockup
jr .lockup


SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello World string", rom0

HelloWorldStr:
    db "Cool stuff!", 0
    db "Hmm", 0

