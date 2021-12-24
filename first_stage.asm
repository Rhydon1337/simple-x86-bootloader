[bits 16]
[org 0x7c00]

SECOND_STAGE_LOADING_ADDRESS equ 0x00007E00
SECOND_STAGE_SECTOR_SIZE equ 40d

mov bp, 0x00007BFF
mov sp, bp

; read second stage from disk
mov ah, 2
mov al, SECOND_STAGE_SECTOR_SIZE
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, 80h
mov bx, SECOND_STAGE_LOADING_ADDRESS
int 0x13

; switch to 32 bit

cli
lgdt [gdt_descriptor]
mov eax, cr0
or  eax, 0x1
mov cr0, eax
jmp CODE_SEG:init_32bit

[bits 32]
init_32bit: 
mov ax, DATA_SEG
mov ds, ax
mov ss, ax
mov es, ax


mov ebp, 0x90000
mov esp, ebp
jmp SECOND_STAGE_LOADING_ADDRESS


gdt_start: ; don't remove the labels, they're needed to compute sizes and jumps
    ; the GDT starts with a null 8-byte
    dd 0x0 ; 4 byte
    dd 0x0 ; 4 byte

; GDT for code segment. base = 0x00000000, length = 0xfffff
; for flags, refer to os-dev.pdf document, page 36
gdt_code:
    dw 0xffff    ; segment length, bits 0-15
    dw 0x0       ; segment base, bits 0-15
    db 0x0       ; segment base, bits 16-23
    db 10011010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31

; GDT for data segment. base and length identical to code segment
; some flags changed, again, refer to os-dev.pdf
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit), always one less of its true size
    dd gdt_start ; address (32 bit)

; define some constants for later use
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510 - ($-$$) db 0
dw 0xaa55
