org 8000h
name db 'io sys' ;6 byte
start_ptr dw startptr
end_ptr dw endptr
int_n db 85h
startptr:

install:
mov ax, cs
mov es, ax
mov ds, ax
	mov bh, 0
	mov ah, 09h
    mov al, 'c'
	mov cx, 10h
	mov bl, 07h
		int		10h
cli
mov ax, 0
mov es, ax
mov ax, cs
mov bx, interrupt
mov [es:85*4], bx
mov [es:85*4+2], ax
sti
ret

interrupt:
cmp ah, 0ffh
je ver
jmp errr
ret

errr:
mov ax, -1
iret

ver:
mov ax, 1
iret

endptr:
