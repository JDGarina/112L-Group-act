.model small
.stack 100h
.data
    names   db 'alex lexy heroo lez lame',0
    scrl    db 'alex lexy heroo lez lame$',0
    row     db 10
    col     db 30
.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 06h
    mov al, 0        
    mov bh, 07h       
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    int 10h

    mov ah, 02h
    mov bh, 0
    mov dh, 10        
    mov dl, 30       
    int 10h

    mov si, offset names

pinitial:
    lodsb
    cmp al, 0
    je dinitail
    mov ah, 0Eh      
    mov bh, 0
    mov bl, 07h      
    int 10h
    jmp pinitial
dinitail:

mainL:
    mov ah, 7
    int 21h
    cmp al, '4'
    je dscrl        
    cmp al, '6'
    je exit          
    jmp mainL

;start of num 4
dscrl: 
loopscrl:
    mov al, [col]
    cmp al, 56

    mov ah, 06h
    mov al, 0
    mov bh, 07h
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    int 10h

    mov ah, 02h
    mov bh, 0
    mov dl, [col]
    mov dh, [row]
    int 10h

    mov ah, 9
    mov dx, offset scrl
    int 21h

    mov cx, 15

x_loop4:
    push cx
    mov cx, 0FFFFh
y_loop4:
    loop y_loop4
    pop cx
    loop x_loop4

    mov al, [col]
    inc al
    mov [col], al

    jmp loopscrl

donescrl:
    jmp mainL

exit:
    mov ah, 4Ch
    int 21h
main endp
end main
