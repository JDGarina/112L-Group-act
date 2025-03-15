.MODEL SMALL
.STACK 100h

.DATA
    names db 'Balagao', 0
          db 'Florentino', 0
          db 'Garina', 0
          db 'Novero', 0
          db 'DelaCruz', 0
          db '$'  ; End marker

    newline db 0Dh, 0Ah, '$'  ; Newline for DOS print

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    MOV SI, OFFSET names  ; Start at first name
    MOV CX, 1             ; 'X' count starts at 1

next_name:
    CMP BYTE PTR [SI], '$'  ; Check if end marker is reached
    JE program_end

    ; Print 'X' pattern
    MOV BX, CX
print_x:
    MOV DL, 'X'
    MOV AH, 2
    INT 21H
    DEC BX
    JNZ print_x

    ; Print space
    MOV DL, ' '
    MOV AH, 2
    INT 21H

    ; Print name
    MOV DI, SI  ; Store SI in DI to prevent overwriting
print_name:
    MOV AL, [DI]  ; Get the character
    CMP AL, 0     ; End of current name?
    JE newline_print
    MOV DL, AL
    MOV AH, 2
    INT 21H
    INC DI        ; Move to the next character
    JMP print_name

newline_print:
    ; Print newline
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    ; Move SI to the next name properly
find_next_name:
    CMP BYTE PTR [SI], 0  ; If null, move to the next name
    JE skip_null
    INC SI
    JMP find_next_name

skip_null:
    INC SI  ; Move past the null byte

    CMP BYTE PTR [SI], '$'  ; If end marker, stop
    JE program_end

    INC CX  ; Increase 'X' count
    JMP next_name

program_end:
    ; Exit program
    MOV AH, 4Ch
    INT 21h

MAIN ENDP
END MAIN





