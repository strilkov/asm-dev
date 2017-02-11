org 7e00h
start:
  mov ax, cs
  mov ds, ax
  mov es, ax
  mov ah, 0
  mov al, 3h
  int 10h
  cli
  mov ax, interruptf
  mov [25h*4], ax
  mov ax, cs
  mov [25h*4+2], ax
  sti
  mov ah, 0ffh
  int 25h
  cmp ax, -1
  jne char
  mov al, 'A'
  mov ah, 2h
  mov cx, [example_txt_len]
  mov si, example_txt
  int 25h
  ;call 8000h
  mov al, 'A'
  mov ah, 2h
  mov cx, [example2_txt_len]
  mov si, example2_txt
  int 25h
  ;call 8000h
  mov ah, 2h
  mov cx, [example2_txt_len]
  mov si, example2_txt
  int 25h
  ;jmp l1
@@:

  mov bx, 0b800h
  mov es, bx
  inc byte [es:0]
  jmp @b

char:
  mov bh, 0
  mov ah, 09h
  mov al, '9'
  mov cx, 10h
  mov bl, 07h
  int 10h
  jmp @b

interruptf:
  cli
  cmp ah, 1h
  je ch1
  cmp ah, 2h
  je str2
  jmp error

error:
  mov ax, -1
  iret

ch1:
  mov bx, 0b800h
  mov gs, bx
  mov byte[gs:0], al ;Знак
  mov byte[gs:1h], 7 ;Цвет
  iret

str2:
  mov bx, 0b800h
  mov gs, bx
  xor di, di
  .l1:
  mov bx, [ds:si]
  mov byte[gs:di], bl ;Знак
  inc di
  mov byte[gs:di], 7 ;Цвет
  inc si
  inc di
  loop .l1
  iret


example_txt db 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptatum iste nostrum ut magnam ipsa dolores natus, nihil omnis officia, corrupti eaque nemo eligendi facere quaerat veniam quam quasi ducimus ab.'
example_txt_len dw $-example_txt
example2_txt db 'text2 text2'
example2_txt_len dw $-example2_txt