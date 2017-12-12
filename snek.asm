TITLE FILE READ (SIMPLFIED .EXE FORMAT)
.MODEL SMALL
;---------------------------------------------
.STACK 32
;---------------------------------------------
.DATA
  ;etc data
  MSG DB 'TEST$'
  NL DB 10, 13, '$'
  EMPTY DW 0
  SPACE DB " $"

  ;data for snake1, uses QUEUE_SI
  QUEUE_SI DB 10 DUP (?)
  ENDERZ DB '$'
  PREV_SI DB ?
  ENDERZ2 DB '$'
  SIZE_SI DW 00
  QUEUE_SI_OUT DB ?

  ;data for snake2, uses QUEUE_DI
  QUEUE_DI DB 10 DUP (?)
  ENDERZZ DB '$'
  PREV_DI DB ?
  ENDERZZ2 DB '$'
  SIZE_DI DW 00
  QUEUE_DI_OUT DB ?

  ;data for cursor
  MESSAGE DB "A$"
  LETTER DB "A$"
  DIRECTION DB ?
  NEW_INPUT DB ?
  CURR_POS_Y DB ?
  CURR_POS_X DB ?


  TEMP DB ?
;---------------------------------------------
.CODE
MAIN PROC FAR
  MOV AX, @data
  MOV DS, AX

  ;all code here
  CALL _PERFORM

  MOV AH, 4CH
  INT 21H
MAIN ENDP
;---------------------------------------------
;Procedures
;---------------------------------------------
  _PERFORM PROC NEAR



    EXIT:
      RET
  _PERFORM ENDP
;---------------------------------------------
;---------------------------------------------
;---------------------------------------------
;---------------------------------------------
;Procedure list
;---------------------------------------------
;---------------------------------------------
;---------------------------------------------
;---------------------------------------------
;-DIRECTIONS FOR EACH PROC

  ;QUEUES

  ;QUEUE_SI
    ;--_ENQUEUE_SI--
      ;PUSH AX, *value*
      ;CALL _ENQUEUE_SI
    ;--_DEQUEUE_SI--
      ;CALL _DEQUEUE_SI
      ;--value popped in QUEUE_SI_OUT--
  ;QUEUE_DI
    ;--_ENQUEUE_DI--
      ;PUSH AX, *value*
      ;CALL _ENQUEUE_DI
    ;--_DEQUEUE_DI--
      ;CALL _DEQUEUE_DI
      ;--value stored in QUEUE_DI_OUT--

    ;LOGIC

    ;CURSOR
      ;--_SET_CURSOR--
        ;DH = Position y
        ;DL = Position x
        ;push dx before calling _SET_CURSOR

        ;MOV CURR_POS_Y, 09H
        ;MOV CURR_POS_X, 10H
        ;MOV DH, CURR_POS_Y
        ;MOV DL, CURR_POS_X
        ;PUSH DX
        ;CALL _SET_CURSOR

      ;--_DISPLAY--
        ;LEA DX, MSG
        ;PUSH DX
        ;CALL _WRAP_DISPLAY_UP
        ;calling this proc moves cursor right

      ;--_MOVE_CURSOR_LEFT--
      ;--_MOVE_CURSOR_UP--
      ;--_MOVE_CURSOR_RIGHT--
      ;--_MOVE_CURSOR_DOWN--

      ;--_MOVE_LEFT--
      ;--_MOVE_UP--
      ;--_MOVE_RIGHT--
      ;--_MOVE_DOWN--

;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;Logic Procedures
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
_DELAY PROC	NEAR
			MOV BP, 2 ;lower value faster
			MOV SI, 2 ;lower value faster
		delay2:
			DEC BP
			NOP
			JNZ delay2
			DEC SI
			CMP SI,0
			JNZ delay2
			RET
_DELAY ENDP
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;Cursor Position and Movement Procedures
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
_SET_CURSOR PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   ;function code to request for set cursor
  MOV BH, 00    ;page number 0, i.e. current screen
  ;MOV DH, 12    ;set row
  ;mov DL, 40    ;set column
  INT 10H

  RET
_SET_CURSOR ENDP
;-------------------------------------------
_MOVE_UP PROC NEAR

  CMP CURR_POS_Y, 01H
  JG _REGULAR_DISPLAY_UP

  _WRAP_DISPLAY_UP:
  MOV CURR_POS_Y, 23
  MOV DH, CURR_POS_Y
  MOV DL, CURR_POS_X
  PUSH DX
  CALL _SET_CURSOR

  _REGULAR_DISPLAY_UP:

  CALL _MOVE_CURSOR_UP
  CALL _MOVE_CURSOR_LEFT
  LEA DX, MESSAGE
  PUSH DX
  CALL _DISPLAY

  RET
_MOVE_UP ENDP
;-------------------------------------------
_DISPLAY PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 9
  INT 21H
  RET
_DISPLAY ENDP
;-------------------------------------------
_MOVE_CURSOR_LEFT PROC NEAR
  DEC CURR_POS_X
  MOV DH, CURR_POS_Y
  MOV DL, CURR_POS_X
  PUSH DX
  CALL _SET_CURSOR
  RET
_MOVE_CURSOR_LEFT ENDP
;---------------------------------------------
_MOVE_CURSOR_UP PROC NEAR
  DEC CURR_POS_Y
  MOV DH, CURR_POS_Y
  MOV DL, CURR_POS_X
  PUSH DX
  CALL _SET_CURSOR
  RET
_MOVE_CURSOR_UP ENDP
;---------------------------------------------
_MOVE_CURSOR_RIGHT PROC NEAR
  INC CURR_POS_X
  MOV DH, CURR_POS_Y
  MOV DL, CURR_POS_X
  PUSH DX
  CALL _SET_CURSOR
  RET
_MOVE_CURSOR_RIGHT ENDP
;---------------------------------------------
_MOVE_CURSOR_DOWN PROC NEAR
  INC CURR_POS_Y
  MOV DH, CURR_POS_Y
  MOV DL, CURR_POS_X
  PUSH DX
  CALL _SET_CURSOR
  RET
_MOVE_CURSOR_DOWN ENDP







;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;QUEUE_SI Procedures
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;push to any L of a general purpose register and set H to 0 before calling function
;needs QUEUE_SI -> DB n DUP (?), SIZE_SI -> DW 00 to be initialized

_ENQUEUE_SI PROC NEAR
  POP BX
  POP DX
  LEA SI, QUEUE_SI
  MOV SI, SIZE_SI

  MOV QUEUE_SI[SI], DL
  INC SIZE_SI

  PUSH BX
    RET
_ENQUEUE_SI ENDP
;--------------------------------------------
;needs same as _ENQUEUE_SI and a PREV_SI variable
;Function stores popped variable in QUEUE_SI_OUT
_DEQUEUE_SI PROC NEAR
  POP BX            ;for return address

  CMP SIZE_SI, 0    ;compare logic block to immediately leave if size is 0
  JNE NEXT1_SI
  MOV QUEUE_SI_OUT, 00
  JMP LEAVE_SI

  NEXT1_SI:
  ;PART 1
  ;this part moves STACK_SI[0] to DL and QUEUE_SI_OUT
    LEA SI, QUEUE_SI
    MOV SI, 0
    MOV DH, 0
    MOV DL, QUEUE_SI[SI]
    MOV QUEUE_SI_OUT, DL

  ;PART 2
  ;this part shifts the digits left
    DEC SIZE_SI            ;decrements SIZE_SI
    LEA SI, SIZE_SI        ;this block sets the cursor of the array to size -1

    MOV CX, SIZE_SI        ;also moves to cx for loop
    MOV PREV_SI, 00        ;set PREV_SI to 00 for initial shift left to be replaced with null

    SHIFT_LEFT_SI:
      MOV SI, CX

      MOV AL, QUEUE_SI[SI]
      MOV AH, PREV_SI
      MOV QUEUE_SI[SI], AH       ;this block swaps variables
      MOV PREV_SI, AL

    LOOP SHIFT_LEFT_SI

    MOV AL, PREV_SI
    MOV QUEUE_SI[0], AL

  LEAVE_SI:
    PUSH BX
      RET
_DEQUEUE_SI ENDP
;--------------------------------------------
DISPLAY_QUEUE_SI PROC NEAR

  CALL NEW_LINE

  MOV AH, 09
  LEA DX, QUEUE_SI
  INT 21H

  CALL NEW_LINE

  LEA SI, QUEUE_SI
  MOV SI, 0
  MOV AL, QUEUE_SI[SI]

  MOV AH, 02
  MOV DL, AL
  INT 21H

  CALL NEW_LINE

  MOV BX, SIZE_SI
  ADD BX, 30H

  MOV AH, 02
  MOV DX, BX
  INT 21H

  CALL NEW_LINE
    RET
DISPLAY_QUEUE_SI ENDP
;--------------------------------------------









;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;QUEUE_DI Procedures
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;push to any L of a general purpose register and set H to 0 before calling function
;needs QUEUE_DI -> DB n DUP (?), SIZE_DI -> DW 00 to be initialized

_ENQUEUE_DI PROC NEAR
  POP BX
  POP DX
  LEA DI, QUEUE_DI
  MOV DI, SIZE_DI

  MOV QUEUE_DI[DI], DL
  INC SIZE_DI

  PUSH BX
    RET
_ENQUEUE_DI ENDP
;--------------------------------------------
;needs same as _ENQUEUE_DI and a PREV_DI variable
;Function stores popped variable in QUEUE_DI_OUT
_DEQUEUE_DI PROC NEAR
  POP BX            ;for return address

  CMP SIZE_DI, 0    ;compare logic block to immediately leave if size is 0
  JNE NEXT1_DI
  MOV QUEUE_DI_OUT, 00
  JMP LEAVE_DI

  NEXT1_DI:
  ;PART 1
  ;this part moves QUEUE_DI[0] to DL and QUEUE_DI_OUT
    LEA DI, QUEUE_DI
    MOV DI, 0
    MOV DH, 0
    MOV DL, QUEUE_DI[DI]
    MOV QUEUE_DI_OUT, DL

  ;PART 2
  ;this part shifts the digits left
    DEC SIZE_DI            ;decrements SIZE_DI
    LEA DI, SIZE_DI        ;this block sets the cursor of the array to size -1

    MOV CX, SIZE_DI        ;also moves to cx for loop
    MOV PREV_DI, 00        ;set PREV_DI to 00 for initial shift left to be replaced with null

    SHIFT_LEFT_DI:
      MOV DI, CX

      MOV AL, QUEUE_DI[DI]
      MOV AH, PREV_DI
      MOV QUEUE_DI[DI], AH       ;this block swaps variables
      MOV PREV_DI, AL

    LOOP SHIFT_LEFT_DI

    MOV AL, PREV_DI
    MOV QUEUE_DI[0], AL

  LEAVE_DI:
    PUSH BX
      RET
_DEQUEUE_DI ENDP
;--------------------------------------------
DISPLAY_QUEUE_DI PROC NEAR

  CALL NEW_LINE

  MOV AH, 09
  LEA DX, QUEUE_DI
  INT 21H

  CALL NEW_LINE

  LEA DI, QUEUE_DI
  MOV DI, 0
  MOV AL, QUEUE_DI[DI]

  MOV AH, 02
  MOV DL, AL
  INT 21H

  CALL NEW_LINE

  MOV BX, SIZE_DI
  ADD BX, 30H

  MOV AH, 02
  MOV DX, BX
  INT 21H

  CALL NEW_LINE
    RET
DISPLAY_QUEUE_DI ENDP
;--------------------------------------------
NEW_LINE PROC NEAR
  MOV AH, 09
  LEA DX, NL
  INT 21H
    RET
NEW_LINE ENDP
END MAIN
