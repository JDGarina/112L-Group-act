.model small
.stack 100h
.data
    names     db 'Balagao Florentino Garina Novero DelaCruz', 0
    scrl      db 'Balagao Florentino Garina Novero DelaCruz$', 0

    ;var of number 4 rarw
    row       db 10
    col       db 0
    scn       db 0
    toggle0   db 0
    toggle1   db 0
    direction db ?
    endCol    db ?
    currAttr  db ?

    ;var of number 5 
    namesStr    db  'Balagao Florentino Garina Novero DelaCruz', 0
    namesCopy   db  50 dup(?)

    ;menu var 
    menuText  db '===============================================================================',0Dh,0Ah
              db 'Enter a Number',0Dh,0Ah
              db '(1) Color                (3) Background Patterns    (5) String Manipulation',0Dh,0Ah
              db '(2) Text Patterns        (4) Moving Text            (6) Exit Program ',0Dh,0Ah   
              db 0
.code
;this is for printing the menu po 
printMenu proc near
    mov ah, 02h
    mov bh, 0
    mov dh, 19
    mov dl, 0
    int 10h

    mov si, offset menuText

nextChar:
    lodsb               
    cmp al, 0
    je donePM         

    cmp al, 0Dh         
    jne notCR

    lodsb               
    mov ah, 03h         
    mov bh, 0
    int 10h             
    inc dh             
    mov ah, 02h         
    mov bh, 0
    mov dl, 0           
    int 10h
    jmp nextChar

notCR:
    mov ah, 0Eh
    mov bh, 0
    mov bl, 07h        
    int 10h
    jmp nextChar

donePM:
    ret

printMenu endp

;main stuff ito
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

    call printMenu

    mov ah, 02h
    mov bh, 0
    mov dh, 10
    mov dl, 19
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

;dito add yung number ninyo and use jump or some shit to go there
mainL:
    mov ah, 7
    int 21h
    
    cmp al, '1'
    jne not1
    jmp colors

not1:
    cmp al, '2'
    jne not2
    jmp colors 
not2:
    cmp al, '3'
    jne not3
    jmp drawBackground

not3:
    cmp al, '4'
    jne not4
    jmp scroll

not4:
    cmp al, '5'
    jne not5
    jmp colors 

not5:
    cmp al, '6'
    jne not6
    jmp exit

not6:
    jmp mainL

;------- start of number 1 -------
colors:
    push ds                    ; Save DS register
    mov ax, 0B800h             ; Load video memory segment
    mov ds, ax                 ; Set DS to point to video memory

    ; Cycle through Red → Orange → Yellow → Green → Blue → Pink → White
    cmp currAttr, 0Ch         
    je set_orange
    cmp currAttr, 06h          
    je set_yellow
    cmp currAttr, 0Eh         
    je set_green
    cmp currAttr, 02h          
    je set_blue
    cmp currAttr, 01h          
    je set_pink
    cmp currAttr, 0Dh         
    je set_white
    mov currAttr, 0Ch          
    jmp change_color

set_orange:
    mov currAttr, 06h         
    jmp change_color

set_yellow:
    mov currAttr, 0Eh         
    jmp change_color

set_green:
    mov currAttr, 02h          
    jmp change_color

set_blue:
    mov currAttr, 01h         
    jmp change_color

set_pink:
    mov currAttr, 0Dh          
    jmp change_color

set_white:
    mov currAttr, 0Fh         
    jmp change_color

change_color: ;heres where you select the location of the cursor to set the entire color of text
    mov si, 10 * 160 + 19 * 2  
    mov cx, 41                 
    mov al, currAttr           

change_color_loop:
    mov [si+1], al             
    add si, 2                  
    loop change_color_loop     

    pop ds                    
    jmp mainL                 

;------- start of number 3 -------

bgVariant db 0  ; Variable to keep track of the current background variant

drawBackground proc
    ; Set video mode
    mov ah, 06h  ; Scroll Up Window / Clear Area
    mov al, 0    ; Clear entire area

    ; Load the current background variant
    mov al, bgVariant
    cmp al, 0
    je variant1
    cmp al, 1
    je variant2
    cmp al, 2
    je variant3
    cmp al, 3
    je variant4
    cmp al, 4
    je variant5
    cmp al, 5
    je variant6

variant1:
    mov bh, 01000000b  ; Red
    mov bl, 00010000b  ; Blue
    jmp draw

variant2:
    mov bh, 00000000b  ; Black
    mov bl, 01110000b  ; White
    jmp draw

variant3:
    mov bh, 00010000b  ; Blue
    mov bl, 01010000b  ; Purple
    jmp draw

variant4:
    mov bh, 01010000b  ; Magenta
    mov bl, 11000000b  ; Light Red
    jmp draw

variant5:
    mov bh, 11100000b  ; Yellow
    mov bl, 11110000b  ; White
    jmp draw

variant6:
    mov bh, 00100000b  ; Green
    mov bl, 00110000b  ; Cyan
    jmp draw

draw:
    ; === left ===
    mov bh, bh  
    mov ch, 0
    mov cl, 0
    mov dh, 18
    mov dl, 39
    mov ah, 06h
    mov al, 0
    int 10h

    ; === right ===
    mov bh, bl  
    mov ch, 0
    mov cl, 40
    mov dh, 18
    mov dl, 79
    int 10h

    ; Cycle background variant (increment and wrap around)
    inc bgVariant
    cmp bgVariant, 6
    jl skipReset
    mov bgVariant, 0  ; Reset back to first variant

    ; Increment bgVariant
    inc bgVariant
    cmp bgVariant, 6
    jl skipReset
    mov bgVariant, 0  ; Reset to 0 if it exceeds 5

skipReset:
    ; === PRINT NAMES AFTER BACKGROUND ===
    call printNames

    jmp mainL  ; Make sure control goes back to the main loop

drawBackground endp



printNames proc
    ; Set cursor position
    mov ah, 02h  
    mov bh, 0    
    mov dh, 10    ; Row
    mov dl, 19    ; Column
    int 10h      

    ; Print names
    mov si, offset names  
print_names_loop:  ; <== Renamed this to avoid conflict
    mov al, [si]  
    cmp al, 0     ; Check if end of string
    je done_printing
    mov ah, 0Eh   ; Teletype function
    int 10h       ; Print character
    inc si        ; Move to next character
    jmp print_names_loop  

done_printing:
    ret
printNames endp



;------- start of number 4 -------
scroll:
    cmp [scn], 0
    je scn0

    mov byte ptr [col], 39
    mov direction, -1
    mov endCol, 0
    jmp startScrl

scn0:
    mov byte ptr [col], 0
    mov direction, 1
    mov endCol, 39

startScrl:
loopscrl:
    mov al, [col]
    cmp al, [endCol]
    jne doScroll
    jmp doneScroll

doScroll:
    cmp [scn], 0
    je doScn0

doScn1:
    mov al, [toggle1]
    cmp al, 0
    je setRed1
    mov currAttr, 010h  
    mov byte ptr [toggle1], 0
    jmp setAttrDone

setRed1:
    mov currAttr, 040h   
    mov byte ptr [toggle1], 1
    jmp setAttrDone

doScn0:
    mov al, [toggle0]
    cmp al, 0
    je setGreen0
    mov currAttr, 0F0h   
    mov byte ptr [toggle0], 0
    jmp setAttrDone

setGreen0:
    mov currAttr, 020h   
    mov byte ptr [toggle0], 1

setAttrDone:
    mov ah, 06h
    mov al, 0
    mov bh, currAttr
    mov ch, 0
    mov cl, 0
    mov dh, 18      
    mov dl, 79
    int 10h

    mov ah, 02h
    mov bh, 0
    mov dl, [col]
    mov dh, [row]
    int 10h

    mov si, offset scrl

print_loop:
    lodsb
    cmp al, '$'
    je end_print_string

    mov ah, 09h
    mov bh, 0
    mov bl, currAttr
    mov cx, 1
    int 10h

    mov ah, 03h
    mov bh, 0
    int 10h
    inc dl
    mov ah, 02h
    mov bh, 0
    int 10h
    jmp print_loop

end_print_string:
    mov cx, 15

x_loop4:
    push cx
    mov cx, 0FFFFh
y_loop4:
    loop y_loop4
    pop cx
    loop x_loop4

    mov al, [col]
    add al, direction
    mov [col], al
    jmp loopscrl

doneScroll:
    mov al, [scn]
    xor al, 1
    mov [scn], al
    jmp mainL

;------- start of number 5 -------

exit:
    mov ah, 4Ch
    int 21h
main endp
end main
