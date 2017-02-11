org 7c00h
jmp start
nop
; BIOS Parameter Block
OEMName db 'TEST OS '
BytesPerSector dw 200h
SectorPerCluster db 1
ReservedSectors dw 1
NumFATs db 2
RootEntries dw 224;
TotalSectors dw 2880
MediaDescriptor db 0f0h
SectorPerFat dw 9
SectorPerTrack dw 18
Heads dw 2
HiddenSectors dd 0
BigTotalSectors dd 0
PDiscNumder db 0
CurrentHead db 0
Signature db 41
VolSerialNumber dd 74c1d396h
VolumeLabel db 'NO NAME    '
SystemID db 'FAT12   '

start:

cli
mov ax, cs
mov ds, ax
mov ss, ax
mov ax, 07c0h
mov sp, ax
push 0b800h
pop es
sti

xor ah, ah
mov al, 03h 
int 10h
mov ah, 01h
mov ch, 20h
mov cl, 0
int 10h


;jmp @f
mov cx, 2000
xor si, si
inc si
l1:
mov [es:si], byte 00010000b
inc si
inc si 
loop l1

@@:
push 10000000b 
push 10
push 2001
call draw_line 

push 10010000b 
push 10
push 2321
call draw_line


push 10010000b 
push 10
push 2161
call draw_line

push kernel_txt
push [kernel_txt_len]
push 0
push 11110100b
call draw_text 

push module_txt
push [module_txt_len]
push 160
push 11110100b
call draw_text

push boot_txt
push [boot_txt_len]
push 320
push 11110100b
call draw_text 

push reboot_txt
push [reboot_txt_len]
push 480
push 11110100b
call draw_text

push halt_txt
push [halt_txt_len]
push 640
push 11110100b
call draw_text


@@:
  mov ah, 0
  int 16h
  cmp al, 'k'
  je L_kernel
  cmp al, 'm'
  je L_module
  cmp al, 'b'
  je Go
  cmp al, 'r'
  je reboot
  cmp al, 'h'
  je halt
  jmp @b


L_kernel:
  mov   ch, 00h
  mov   cl, 02h
  mov   dh, 00h
  mov   dl, 00h
  mov   ax, cs
  mov   es, ax
  mov   bx, 7e00h
  mov   ah, 02h
  mov   al, 01h
  int   13h
  jmp @b

L_module:

  mov   ch, 00h
  mov   cl, 03h
  mov   dh, 00h
  mov   dl, 00h 
  mov   ax, cs
  mov   es, ax
  mov   bx, 8000h
  mov   ah, 02h
  mov   al, 01h
  int   13h
  jmp @b

reboot:
  ; store magic value at 0040h:0072h:
  ;   0000h - cold boot.
  ;   1234h - warm boot.
  mov ax, 0040h
  mov ds, ax
  mov word [0072h], 0000h
  jmp 0ffffh:0000h
  ret

halt:
  mov ax, 5307h
  xor bx, bx
  inc bx
  mov cx, 3
  int 15h

Go:
  jmp 7e00h

draw_line:
  mov bp, sp
  mov si, [bp+2]
  mov cx, [bp+4]
  mov ax, [bp+6]
  .l1:
  mov [es:si], al
  inc si
  inc si
  loop .l1
  ret

  draw_text:
  mov bp, sp
  mov ax, [bp+2]
  mov si, [bp+4]
  mov cx, [bp+6]
  mov di, [bp+8]
  .l1:
  mov bx, [ds:di]
  mov [es:si], bx
  inc si
  mov [es:si], ax
  inc si
  inc di
  loop .l1
  ret

kernel_txt db 'load [k]ernel'
kernel_txt_len dw $-kernel_txt 
module_txt db 'load [m]odule'
module_txt_len dw $-module_txt
boot_txt db '[b]oot'
boot_txt_len dw $-boot_txt
halt_txt db '[h]alt'
halt_txt_len dw $-halt_txt 
reboot_txt db '[r]eboot'
reboot_txt_len dw $-reboot_txt

TIMES 510-($-$$) DB 0
DW 0xAA55
