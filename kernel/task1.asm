; Clear screen
mov ah, 0
mov al, 3h
int 10h
xor ax, ax
mov bx, 0b800h
mov gs, bx
.l1:
mov byte[gs:0], al ;Знак
mov byte[gs:1h], 7 ;Цвет
inc al
jmp .l1