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
  ARR_LEFT DB 4BH
  ARR_UP DB 48H
  ARR_RIGHT DB 4DH
  ARR_DOWN DB 50H

  ;data for SNAKE_1, uses QUEUE_S1
  QUEUE_S1 DB 10 DUP (?)
  ENDERZ DB '$'
  PREV_S1 DB ?
  ENDERZ2 DB '$'
  SIZE_S1 DW 00
  QUEUE_S1_OUT DB ?
  ENDY DB '$'

  ;data for SNAKE_2, uses QUEUE_S2
  QUEUE_S2 DB 10 DUP (?)
  ENDERZZ DB '$'
  PREV_S2 DB ?
  ENDERZZ2 DB '$'
  SIZE_S2 DW 00
  QUEUE_S2_OUT DB ?
  ENDY2 DB '$'

  ;general data
  MESSAGE DB "A$"
  LETTER DB "A$"
  NEW_INPUT DB ?
  CURR_POS_Y DB ?
  CURR_POS_X DB ?
  CURR_DIRECTION DB ?
  CURR_DIRECTION_T DB ?
  SNAKE_ATE DB ?


  ;data for snakes
  ;SNAKE_1 uses DI - SNAKE_2 uses SI
  SNAKE_1_POS_H_X DB 15H
  SNAKE_1_POS_H_Y DB 0CH
  SNAKE_1_POS_T_X DB 13H
  ENDOY DB '$'
  SNAKE_1_POS_T_Y DB 0CH
  ENDOYER DB '$'
  DIRECTION_SNAKE_1 DB 03H
  DIRECTION_SNAKE_1_T DB 03H
  SNAKE_1_HAS_EATEN DB 0

  SNAKE_2_POS_H_X DB 3AH
  SNAKE_2_POS_H_Y DB 0CH
  SNAKE_2_POS_T_X DB 3CH
  ENDOYA DB '$'
  SNAKE_2_POS_T_Y DB 0CH
  ENDOYINA DB '$'
  DIRECTION_SNAKE_2 DB 01H
  DIRECTION_SNAKE_2_T DB 01H
  SNAKE_2_HAS_EATEN DB 0

  SNAKE_BODY DB '@$'

  ;Game data
    ;identify which snake listens for next input
    SNAKE_TURN DB 1
    IS_GAME_OVER DB 0
    FOOD DB '*$'
    FOOD_POS_X DB ?
    FOOD_POS_Y DB ?
    FOOD_IS_SPAWNED DB 0

  ;other data
  ACTUAL_SCORE DW 0
  ACTUAL_SCORE_END DB '$'
  SCORE DB 'Score: $'
  WALL DB 'M$'
  TEMP DB ?
  GENERATER_UPPER_LIMIT DW ?
  GENERATER_LOWER_LIMIT DW ?
  RANDOM_NUMBER DB ?
  RANDOM_NUMBER_END_DISPLAY DB '$'
;---------------------------------------------
.CODE
MAIN PROC FAR
  MOV AX, @data
  MOV DS, AX

  ;all code here
  CALL _PERFORM
  ;CALL _TESTS

  MOV AH, 4CH
  INT 21H
MAIN ENDP
;---------------------------------------------
;Procedures
;---------------------------------------------
  _PERFORM PROC NEAR
    ;Initialize everything
    CALL _INITIALIZE


    GAME_PROPER:
      CALL _DELAY
      CALL _GET_KEY

      MOV AH, 02
      MOV DL, AL
      INT 21H

      CMP NEW_INPUT, 1
      JE EXIT
      CMP IS_GAME_OVER, 01
      JE EXIT

      CALL _GENERATE_FOOD
      CALL _MOVE_LOGIC
      JMP GAME_PROPER

    EXIT:
      RET
  _PERFORM ENDP
;---------------------------------------------
  _TESTS PROC NEAR
    MOV GENERATER_LOWER_LIMIT, 01
    MOV GENERATER_UPPER_LIMIT, 09
    CALL _GENERATE_NUMBER

    ADD RANDOM_NUMBER, 30H
    LEA DX, RANDOM_NUMBER
    CALL _DISPLAY
      RET
  _TESTS ENDP
;---------------------------------------------
;---------------------------------------------
;---------------------------------------------
;Procedure list
;---------------------------------------------
;---------------------------------------------
;---------------------------------------------

;-DIRECTIONS FOR EACH PROC

  ;MAIN
    ;calls _PERFORM function

  ;--_PERFORM--
    ;calls initialize and sets the game after title screen selects game
    ;calls both generate food and move logic functions on loop until IS_GAME_OVER is 1

  ;QUEUES
  ;QUEUES are used for DIRECTION
  ;1-left 2-up 3-right 4-down

    ;QUEUE_S2
      ;--_ENQUEUE_S2--
        ;PUSH AX, *value*
        ;CALL _ENQUEUE_S2
      ;--_DEQUEUE_S2--
        ;CALL _DEQUEUE_S2
        ;--value stored in QUEUE_S2_OUT--

    ;QUEUE_S1
      ;--_ENQUEUE_S1--
        ;PUSH AX, *value*
        ;CALL _ENQUEUE_S1
      ;--_DEQUEUE_S1--
        ;CALL _DEQUEUE_S1
        ;--value popped in QUEUE_S1_OUT--

  ;CURSOR
      ;--_SET_CURSOR--
        ;DL = Position x
        ;DH = Position y
        ;set CURR_POS_X and CURR_POS_Y first before calling _SET_CURSOR

        ;MOV CURR_POS_Y, 09H
        ;MOV CURR_POS_X, 10H
        ;CALL _SET_CURSOR


      ;--_MOVE_CURSOR_LEFT--
      ;--_MOVE_CURSOR_UP--
      ;--_MOVE_CURSOR_RIGHT--
      ;--_MOVE_CURSOR_DOWN--

    ;LOGIC
      ;--_MOVE_LOGIC--
        ;this has the logic for direction changing of each snake
        ;as well as calling each snake's move logic

      ;--_SNAKE_1_CHANGE_DIR--
        ;logic if snake 1 should change direction

      ;--_S1_VERTICAL_LOGIC--
        ;calls _GET_KEY and changes direction
        ;when the snake's head is moving vertically

      ;--_S1_HORIZONTAL_LOGIC--
        ;calls _GET_KEY and changes DIRECTION
        ;when the snake's head is moving horizontally

      ;--_SNAKE_2_CHANGE_DIR--
      ;--_S2_VERTICAL_LOGIC--
      ;--_S2_HORIZONTAL_LOGIC--
        ;same as snake 1's but for snake 2

      ;each horizontal and vertical logic swaps SNAKE_TURN variable
      ;to the opposite snake's variable

      ;--_DELAY--

      ;--_GENERATE_FOOD--
        ;calls _GENERATE_NUMBER twice generates food based on the position of those

      ;--_GENERATE_NUMBER--
        ;generates a number given an upper limit and lower limit
        ;stored in GENERATER_UPPER_LIMIT and GENERATER_LOWER_LIMIT
        ;lower limit is included but upper limit is not
        ;output stored in RANDOM_NUMBER
        ;Logic ex:
        ;upperLimit = 9 lowerLimit = 3
        ;upperLimit -= lowerLimit
        ;generates number from 0 to 6 e.g. 2
        ;output += lower limit
        ;output = 5

      ;--_DISPLAY--
        ;LEA DX, MSG
        ;CALL _DISPLAY

      ;--_GET_KEY--
        ;gets key
        ;stores key at NEW_INPUT

      ;--_GET_CHAR_AT_CURSOR--
        ;gets character at cursor
        ;stores character at AL

      ;--_MOVE_SNAKE_1--
        ;contains logic for snake 1's movement given direction at DIRECTION_SNAKE_1
        ;calls _SNAKE_1_MOVE_LEFT, _SNAKE_1_MOVE_UP, _SNAKE_1_MOVE_RIGHT, _SNAKE_1_MOVE_down
        ;if DIRECTION_SNAKE_1 is 1, 2, 3, 4 respectively

      ;--_MOVE_SNAKE_2--
        ;same as _MOVE_SNAKE_1 but for snake 2

      ;--_CHECK_COLLISION--
        ;checks collision at cursor position
        ;contains logic for if collision is food, wall, or snake tail

    ;General Movement Procedures
    ;General movement procedures require positions of snake to be set to
    ;a general position variable such as CURR_POS_X and CURR_POS_Y
    ;don't forget to store position afterwards
      ;--_MOVE_LEFT_GENERAL--
        ;calls move cursor left
        ;prints snake icon on it

      ;--_MOVE_UP_GENERAL--
      ;--_MOVE_RIGHT_GENERAL--
      ;--_MOVE_DOWN_GENERAL--
        ;same as move left but towards their corresponding direction

      ;_T_MOVE_LEFT_GENERAL--
        ;contains logic for moving snake tail left
        ;replaces current position with space
        ;moves location up

      ;_T_MOVE_UP_GENERAL
      ;_T_MOVE_RIGHT_GENERAL
      ;_T_MOVE_DOWN_GENERAL

      ;--_MOVE_T_LOGIC--
        ;contains logic for tail movement using general cursor position
        ;store position back from general variable back to corresponding tail

      ;--_SNAKE_1_MOVE_LEFT--
        ;combines logic for head and tail when head moves left
        ;moves cursor to snake 1's head position and stores after movement
        ;also enqueues direction into QUEUE_S1

      ;--_SNAKE_1_MOVE_UP--
      ;--_SNAKE_1_MOVE_RIGHT--
      ;--_SNAKE_1_MOVE_DOWN--

      ;--_SNAKE_1_MOVE_T--
        ;logic for moving tail
        ;checks if SNAKE_1_HAS_EATEN and does not make the tail move to extend length
        ;dequeues from queue to get direction for next movement
        ;moves cursor to snake 1's tail and stores after movement
        ;calls general _MOVE_T_LOGIC

      ;--_SNAKE_2_MOVE_LEFT--
      ;--_SNAKE_2_MOVE_UP--
      ;--_SNAKE_2_MOVE_RIGHT--
      ;--_SNAKE_2_MOVE_DOWN--
      ;--_SNAKE_2_MOVE_T--
        ;snake 2 version of above code

    ;Cursor Position Procedures
      ;--_SET_CURSOR--
        ;sets cursor at the general purpose cursors CURR_POS_X, CURR_POS_Y

      ;--_MOVE_CURSOR_LEFT--
        ;decrements CURR_POS_X and sets cursor

      ;--_MOVE_CURSOR_UP--
      ;--_MOVE_CURSOR_RIGHT--
      ;--_MOVE_CURSOR_DOWN--

      ;--_SET_CURSOR_SNAKE_1_H--
        ;transfers snake 1 head position to CURR_POS_X and Y variables
        ;sets cursor

      ;--_SET_CURSOR_SNAKE_1_T--
        ;same as above but for tail

      ;--_SET_CURSOR_SNAKE_2_H--
      ;--_SET_CURSOR_SNAKE_2_T--
        ;same as above but for snake 2

      ;--_STORE_SNAKE_POS_1_H--
        ;stores the positions from CURR_POS_X and Y to snake 1 head x and y

      ;--_STORE_SNAKE_POS_1_T--
        ;same as above but for tail

      ;--_STORE_SNAKE_POS_2_H--
      ;--_STORE_SNAKE_POS_2_T--
        ;same as above but for snake 2

    ;INITIALIZATION
      ;--_INITIALIZE--
        ;calls all initializing functions to initialize all display before game starts
      ;--_INITIALIZE_SNAKES
        ;sets up snake position and queues for snake tail direction
      ;--_INITIALIZE_BORDERS
      ;--_CLEAR_SCREEN


;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;Logic Procedures
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
_MOVE_LOGIC PROC NEAR
  CMP SNAKE_TURN, 01
  JNE P2TURN
  CALL _SNAKE_1_CHANGE_DIR
  MOV NEW_INPUT, 00
  JMP MOVE

  P2TURN:
  CALL _SNAKE_2_CHANGE_DIR
  MOV NEW_INPUT, 00

  MOVE:
  CALL _MOVE_SNAKE_1
  CALL _MOVE_SNAKE_2
    RET
_MOVE_LOGIC ENDP
;-------------------------------------------
_SNAKE_1_CHANGE_DIR PROC NEAR

  CALL _GET_KEY
  CMP DIRECTION_SNAKE_1, 01
  JNE S1_NEXT_DIR
  CALL _S1_HORIZONTAL_LOGIC
  JMP DONE_S1_DIR

  S1_NEXT_DIR:
  CMP DIRECTION_SNAKE_1, 03
  JNE S1_NEXT1_DIR
  CALL _S1_HORIZONTAL_LOGIC
  JMP DONE_S1_DIR

  S1_NEXT1_DIR:
  CALL _S1_VERTICAL_LOGIC

  DONE_S1_DIR:
    RET
_SNAKE_1_CHANGE_DIR ENDP
;-------------------------------------------
_SNAKE_2_CHANGE_DIR PROC NEAR

  CALL _GET_KEY
  CMP DIRECTION_SNAKE_2, 01
  JNE S2_NEXT_DIR
  CALL _S2_HORIZONTAL_LOGIC
  JMP DONE_S2_DIR

  S2_NEXT_DIR:
  CMP DIRECTION_SNAKE_2, 03
  JNE S2_NEXT1_DIR
  CALL _S2_HORIZONTAL_LOGIC
  JMP DONE_S2_DIR

  S2_NEXT1_DIR:
  CALL _S2_VERTICAL_LOGIC

  DONE_S2_DIR:
    RET
_SNAKE_2_CHANGE_DIR ENDP
;-------------------------------------------
_S1_VERTICAL_LOGIC PROC NEAR

  CALL _GET_KEY
  CMP NEW_INPUT, 4BH
  JNE NEXT_VL
  MOV SNAKE_TURN, 02
  MOV DIRECTION_SNAKE_1, 01
  JMP LEAVE_VL

  NEXT_VL:
    CMP NEW_INPUT, 4DH
    JNE NEXT1_VL
    MOV SNAKE_TURN, 02
    MOV DIRECTION_SNAKE_1, 03
    JMP LEAVE_VL

  NEXT1_VL:
    CMP NEW_INPUT, 48H
    JNE NEXT2_VL
    MOV SNAKE_TURN, 02
    JMP LEAVE_VL

  NEXT2_VL:
    CMP NEW_INPUT, 50H
    JNE LEAVE_VL
    MOV SNAKE_TURN, 02
    JMP LEAVE_VL

  LEAVE_VL:
    RET
_S1_VERTICAL_LOGIC ENDP
;-------------------------------------------
_S1_HORIZONTAL_LOGIC PROC NEAR

  CALL _GET_KEY
  CMP NEW_INPUT, 48H
  JNE NEXT_HL
  MOV SNAKE_TURN, 02
  MOV DIRECTION_SNAKE_1, 02
  JMP LEAVE_HL

  NEXT_HL:
    CMP NEW_INPUT, 50H
    JNE NEXT1_HL
    MOV SNAKE_TURN, 02
    MOV DIRECTION_SNAKE_1, 04
    JMP LEAVE_HL

  NEXT1_HL:
    CMP NEW_INPUT, 4BH
    JNE NEXT2_HL
    MOV SNAKE_TURN, 02
    JMP LEAVE_HL

  NEXT2_HL:
    CMP NEW_INPUT, 4DH
    JNE LEAVE_HL
    MOV SNAKE_TURN, 02
    JMP LEAVE_HL

  LEAVE_HL:
    RET
_S1_HORIZONTAL_LOGIC ENDP
;-------------------------------------------
_S2_VERTICAL_LOGIC PROC NEAR

  CALL _GET_KEY
  CMP NEW_INPUT, 4BH
  JNE NEXT_VL2
  MOV SNAKE_TURN, 01
  MOV DIRECTION_SNAKE_2, 01
  JMP LEAVE_VL2

  NEXT_VL2:
  CMP NEW_INPUT, 4DH
  JNE LEAVE_VL2
  MOV SNAKE_TURN, 01
  MOV DIRECTION_SNAKE_2, 03
  JMP LEAVE_VL2

    NEXT1_VL2:
      CMP NEW_INPUT, 48H
      JNE NEXT2_VL2
      MOV SNAKE_TURN, 01
      JMP LEAVE_VL2

    NEXT2_VL2:
      CMP NEW_INPUT, 50H
      JNE LEAVE_VL2
      MOV SNAKE_TURN, 01
      JMP LEAVE_VL2
  LEAVE_VL2:
    RET
_S2_VERTICAL_LOGIC ENDP
;-------------------------------------------
_S2_HORIZONTAL_LOGIC PROC NEAR

  CALL _GET_KEY
  CMP NEW_INPUT, 48H
  JNE NEXT_HL2
  MOV SNAKE_TURN, 01
  MOV DIRECTION_SNAKE_2, 02
  JMP LEAVE_HL2

  NEXT_HL2:
  CMP NEW_INPUT, 50H
  JNE LEAVE_HL2
  MOV SNAKE_TURN, 01
  MOV DIRECTION_SNAKE_2, 04
  JMP LEAVE_HL2

  NEXT1_HL2:
    CMP NEW_INPUT, 4BH
    JNE NEXT2_HL2
    MOV SNAKE_TURN, 01
    JMP LEAVE_HL2

  NEXT2_HL2:
    CMP NEW_INPUT, 4DH
    JNE LEAVE_HL2
    MOV SNAKE_TURN, 01
    JMP LEAVE_HL2

  LEAVE_HL2:
    RET
_S2_HORIZONTAL_LOGIC ENDP
;-------------------------------------------
_DELAY PROC	NEAR
			MOV BP, 8 ;lower value faster
			MOV SI, 8 ;lower value faster
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
_GENERATE_FOOD PROC NEAR

  CMP FOOD_IS_SPAWNED, 01
  JE EXIT_FOOD_GEN

  GENSTART:
    MOV GENERATER_LOWER_LIMIT, 01
    MOV GENERATER_UPPER_LIMIT, 23
    CALL _GENERATE_NUMBER
    MOV DL, RANDOM_NUMBER
    MOV CURR_POS_Y, DL

    MOV GENERATER_LOWER_LIMIT, 01
    MOV GENERATER_UPPER_LIMIT, 79
    CALL _GENERATE_NUMBER
    MOV DL, RANDOM_NUMBER
    MOV CURR_POS_X, DL

    CALL _SET_CURSOR
    CALL _GET_CHAR_AT_CURSOR

    CMP AL, SNAKE_BODY
    JE GENSTART

    MOV FOOD_IS_SPAWNED, 01
    LEA DX, FOOD
    CALL _DISPLAY
    EXIT_FOOD_GEN:
      RET
_GENERATE_FOOD ENDP
;-------------------------------------------
_GENERATE_NUMBER PROC NEAR        ; generate a rand no using the system time

   MOV BX, GENERATER_LOWER_LIMIT
   SUB GENERATER_UPPER_LIMIT, BX

   MOV AH, 00h  ; interrupts to get system time
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight
                ; lets just take the lower bits of DL for a start..

   MOV AX, DX
   XOR DX, DX
   MOV CX, GENERATER_UPPER_LIMIT ;how many numbers to generate from 0 to variable
   DIV CX ;HERE DX CONTAINS THE REMAINDER OF THE DIVISION - FROM 0 TO 9

   MOV DH, 00H
   ADD DX, GENERATER_LOWER_LIMIT
   MOV RANDOM_NUMBER, DL

   ;value is stored in dl btw
   lea dx, RANDOM_NUMBER
   call _DISPLAY
    RET
_GENERATE_NUMBER ENDP
;-------------------------------------------
_DISPLAY PROC NEAR
  MOV AH, 9
  INT 21H
  RET
_DISPLAY ENDP
;-------------------------------------------
_GET_KEY	PROC	NEAR
			MOV		AH, 01H		;check for input
			INT		16H
			JZ		__LEAVETHIS

			MOV		AH, 00H		;get input	MOV AH, 10H; INT 16H
			INT		16H

			MOV		NEW_INPUT, AH

	__LEAVETHIS:
			RET
_GET_KEY 	ENDP
;---------------------------------------------
_GET_CHAR_AT_CURSOR PROC	NEAR
			MOV		AH, 08H
			MOV		BH, 00
			INT		10H
			RET
_GET_CHAR_AT_CURSOR ENDP
;-------------------------------------------
_MOVE_SNAKE_1 PROC NEAR
  CMP DIRECTION_SNAKE_1, 01
  JNE MS11
  CALL _SNAKE_1_MOVE_LEFT
  JMP LEAVE_MS1

  MS11:
  CMP DIRECTION_SNAKE_1, 02
  JNE MS12
  CALL _SNAKE_1_MOVE_UP
  JMP LEAVE_MS1

  MS12:
  CMP DIRECTION_SNAKE_1, 03
  JNE MS13
  CALL _SNAKE_1_MOVE_RIGHT
  JMP LEAVE_MS1

  MS13:
  CMP DIRECTION_SNAKE_1, 04
  CALL _SNAKE_1_MOVE_DOWN

  LEAVE_MS1:
    RET
_MOVE_SNAKE_1 ENDP
;-------------------------------------------
_MOVE_SNAKE_2 PROC NEAR
  CMP DIRECTION_SNAKE_2, 01
  JNE MS21
  CALL _SNAKE_2_MOVE_LEFT
  JMP LEAVE_MS2

  MS21:
  CMP DIRECTION_SNAKE_2, 02
  JNE MS22
  CALL _SNAKE_2_MOVE_UP
  JMP LEAVE_MS2

  MS22:
  CMP DIRECTION_SNAKE_2, 03
  JNE MS23
  CALL _SNAKE_2_MOVE_RIGHT
  JMP LEAVE_MS2

  MS23:
  CMP DIRECTION_SNAKE_2, 04
  CALL _SNAKE_2_MOVE_DOWN

  LEAVE_MS2:
    RET
_MOVE_SNAKE_2 ENDP
;-------------------------------------------
_CHECK_COLLISION PROC NEAR

  CALL _GET_CHAR_AT_CURSOR
  CMP AL, SNAKE_BODY
  JNE NEXT_COL_CHECK
  MOV IS_GAME_OVER, 01
  JMP LEAVE_COL

  NEXT_COL_CHECK:
  CMP AL, FOOD
  JNE NEXT1_COL_CHECK
  MOV SNAKE_ATE, 01
  JMP LEAVE_COL

  NEXT1_COL_CHECK:
  CMP CURR_POS_X, 0
  JNE NEXT2_COL_CHECK
  MOV IS_GAME_OVER, 01
  JMP LEAVE_COL

  NEXT2_COL_CHECK:
  CMP CURR_POS_X, 79
  JNE NEXT3_COL_CHECK
  MOV IS_GAME_OVER, 01
  JMP LEAVE_COL

  NEXT3_COL_CHECK:
  CMP CURR_POS_Y, 0
  JNE NEXT4_COL_CHECK
  MOV IS_GAME_OVER, 01
  JMP LEAVE_COL

  NEXT4_COL_CHECK:
  CMP CURR_POS_Y, 24
  JNE LEAVE_COL
  MOV IS_GAME_OVER, 01
  JMP LEAVE_COL

  LEAVE_COL:
    RET
_CHECK_COLLISION ENDP
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;General Movement Procedures
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
_MOVE_LEFT_GENERAL PROC NEAR

  CALL _MOVE_CURSOR_LEFT
  LEA DX, SNAKE_BODY
  CALL _DISPLAY

    RET
_MOVE_LEFT_GENERAL ENDP
;-------------------------------------------
_MOVE_UP_GENERAL PROC NEAR

  CALL _MOVE_CURSOR_UP
  LEA DX, SNAKE_BODY
  CALL _DISPLAY

    RET
_MOVE_UP_GENERAL ENDP
;-------------------------------------------
_MOVE_RIGHT_GENERAL PROC NEAR

  CALL _MOVE_CURSOR_RIGHT
  LEA DX, SNAKE_BODY
  CALL _DISPLAY

    RET
_MOVE_RIGHT_GENERAL ENDP
;-------------------------------------------
_MOVE_DOWN_GENERAL PROC NEAR

  CALL _MOVE_CURSOR_DOWN
  LEA DX, SNAKE_BODY
  CALL _DISPLAY

    RET
_MOVE_DOWN_GENERAL ENDP
;-------------------------------------------
_T_MOVE_LEFT_GENERAL PROC NEAR

  LEA DX, SPACE
  CALL _DISPLAY
  CALL _MOVE_CURSOR_LEFT

    RET
_T_MOVE_LEFT_GENERAL ENDP
;-------------------------------------------
_T_MOVE_UP_GENERAL PROC NEAR

  LEA DX, SPACE
  CALL _DISPLAY
  CALL _MOVE_CURSOR_UP

    RET
_T_MOVE_UP_GENERAL ENDP
;-------------------------------------------
_T_MOVE_RIGHT_GENERAL PROC NEAR

  LEA DX, SPACE
  CALL _DISPLAY
  CALL _MOVE_CURSOR_RIGHT

    RET
_T_MOVE_RIGHT_GENERAL ENDP
;-------------------------------------------
_T_MOVE_DOWN_GENERAL PROC NEAR

  LEA DX, SPACE
  CALL _DISPLAY
  CALL _MOVE_CURSOR_DOWN

    RET
_T_MOVE_DOWN_GENERAL ENDP
;-------------------------------------------
_MOVE_T_LOGIC PROC NEAR

  CMP CURR_DIRECTION_T, 01
  JNE MT1
  CALL _T_MOVE_LEFT_GENERAL
  JMP LEAVE_MOVE_T_LOGIC

  MT1:
  CMP CURR_DIRECTION_T, 02
  JNE MT2
  CALL _T_MOVE_UP_GENERAL
  JMP LEAVE_MOVE_T_LOGIC

  MT2:
  CMP CURR_DIRECTION_T, 03
  JNE MT3
  CALL _T_MOVE_RIGHT_GENERAL
  JMP LEAVE_MOVE_T_LOGIC

  MT3:
  CMP CURR_DIRECTION_T, 04
  CALL _T_MOVE_DOWN_GENERAL

  LEAVE_MOVE_T_LOGIC:
    RET
_MOVE_T_LOGIC ENDP
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;Snake 1 Movement Procedures
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
_SNAKE_1_MOVE_LEFT PROC NEAR

  CALL _SET_CURSOR_SNAKE_1_H
  CALL _MOVE_LEFT_GENERAL
  CALL _STORE_SNAKE_POS_1_H

  ;this enqueues move left
  MOV AH, 00H
  MOV AL, 01H
  PUSH AX
  CALL _ENQUEUE_S1

  CALL _SNAKE_1_MOVE_T

    RET
_SNAKE_1_MOVE_LEFT ENDP
;-------------------------------------------
_SNAKE_1_MOVE_UP PROC NEAR

  CALL _SET_CURSOR_SNAKE_1_H
  CALL _MOVE_UP_GENERAL
  CALL _STORE_SNAKE_POS_1_H

  ;this enqueues move up
  MOV AH, 00H
  MOV AL, 02H
  PUSH AX
  CALL _ENQUEUE_S1

  CALL _SNAKE_1_MOVE_T

    RET
_SNAKE_1_MOVE_UP ENDP
;-------------------------------------------
_SNAKE_1_MOVE_RIGHT PROC NEAR

  CALL _SET_CURSOR_SNAKE_1_H
  CALL _MOVE_RIGHT_GENERAL
  CALL _STORE_SNAKE_POS_1_H

  ;this enqueues move right
  MOV AH, 00H
  MOV AL, 03H
  PUSH AX
  CALL _ENQUEUE_S1

  CALL _SNAKE_1_MOVE_T

    RET
_SNAKE_1_MOVE_RIGHT ENDP
;-------------------------------------------
_SNAKE_1_MOVE_DOWN PROC NEAR

  CALL _SET_CURSOR_SNAKE_1_H
  CALL _MOVE_DOWN_GENERAL
  CALL _STORE_SNAKE_POS_1_H

  ;this enqueues move down
  MOV AH, 00H
  MOV AL, 04H
  PUSH AX
  CALL _ENQUEUE_S1

  CALL _SNAKE_1_MOVE_T

    RET
_SNAKE_1_MOVE_down ENDP
;-------------------------------------------
_SNAKE_1_MOVE_T PROC NEAR

  CMP SNAKE_1_HAS_EATEN, 01
  JE S1_IS_FULL

  ;movement for tail
  CALL _SET_CURSOR_SNAKE_1_T

  CALL _DEQUEUE_S1
  MOV AL, QUEUE_S1_OUT
  MOV CURR_DIRECTION_T, AL

  CALL _MOVE_T_LOGIC

  CALL _STORE_SNAKE_POS_1_T

  S1_IS_FULL:
  MOV SNAKE_1_HAS_EATEN, 00
    RET
_SNAKE_1_MOVE_T ENDP
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;Snake 2 Movement Procedures
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
_SNAKE_2_MOVE_LEFT PROC NEAR

  CALL _SET_CURSOR_SNAKE_2_H
  CALL _MOVE_LEFT_GENERAL
  CALL _STORE_SNAKE_POS_2_H

  ;this enqueues move left
  MOV AH, 00H
  MOV AL, 01H
  PUSH AX
  CALL _ENQUEUE_S2

  CALL _SNAKE_2_MOVE_T

    RET
_SNAKE_2_MOVE_LEFT ENDP
;-------------------------------------------
_SNAKE_2_MOVE_UP PROC NEAR

  CALL _SET_CURSOR_SNAKE_2_H
  CALL _MOVE_UP_GENERAL
  CALL _STORE_SNAKE_POS_2_H

  ;this enqueues move up
  MOV AH, 00H
  MOV AL, 02H
  PUSH AX
  CALL _ENQUEUE_S2

  CALL _SNAKE_2_MOVE_T

    RET
_SNAKE_2_MOVE_UP ENDP
;-------------------------------------------
_SNAKE_2_MOVE_RIGHT PROC NEAR

  CALL _SET_CURSOR_SNAKE_2_H
  CALL _MOVE_RIGHT_GENERAL
  CALL _STORE_SNAKE_POS_2_H

  ;this enqueues move right
  MOV AH, 00H
  MOV AL, 03H
  PUSH AX
  CALL _ENQUEUE_S2

  CALL _SNAKE_2_MOVE_T

    RET
_SNAKE_2_MOVE_RIGHT ENDP
;-------------------------------------------
_SNAKE_2_MOVE_DOWN PROC NEAR

  CALL _SET_CURSOR_SNAKE_2_H
  CALL _MOVE_DOWN_GENERAL
  CALL _STORE_SNAKE_POS_2_H

  ;this enqueues move down
  MOV AH, 00H
  MOV AL, 04H
  PUSH AX
  CALL _ENQUEUE_S2

  CALL _SNAKE_2_MOVE_T

    RET
_SNAKE_2_MOVE_down ENDP
;-------------------------------------------
_SNAKE_2_MOVE_T PROC NEAR

  CMP SNAKE_2_HAS_EATEN, 01
  JE S2_IS_FULL
  ;movement for tail
  CALL _SET_CURSOR_SNAKE_2_T

  CALL _DEQUEUE_S2
  MOV AH, QUEUE_S2_OUT
  MOV CURR_DIRECTION_T, AH

  CALL _MOVE_T_LOGIC

  CALL _STORE_SNAKE_POS_2_T

  S2_IS_FULL:
  MOV SNAKE_2_HAS_EATEN, 00
    RET
_SNAKE_2_MOVE_T ENDP
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;Cursor Position Procedures
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
;-------------------------------------------
_SET_CURSOR PROC NEAR
  MOV DL, CURR_POS_X
  MOV DH, CURR_POS_Y
  MOV AH, 02H   ;function code to request for set cursor
  MOV BH, 00    ;page number 0, i.e. current screen
  ;MOV DH, 12    ;set row
  ;mov DL, 40    ;set column
  INT 10H

  RET
_SET_CURSOR ENDP
;-------------------------------------------
_MOVE_CURSOR_LEFT PROC NEAR
  DEC CURR_POS_X
  CALL _SET_CURSOR
  RET
_MOVE_CURSOR_LEFT ENDP
;---------------------------------------------
_MOVE_CURSOR_UP PROC NEAR
  DEC CURR_POS_Y
  CALL _SET_CURSOR
  RET
_MOVE_CURSOR_UP ENDP
;---------------------------------------------
_MOVE_CURSOR_RIGHT PROC NEAR
  INC CURR_POS_X
  CALL _SET_CURSOR
  RET
_MOVE_CURSOR_RIGHT ENDP
;---------------------------------------------
_MOVE_CURSOR_DOWN PROC NEAR
  INC CURR_POS_Y
  CALL _SET_CURSOR
  RET
_MOVE_CURSOR_DOWN ENDP
;---------------------------------------------
_SET_CURSOR_SNAKE_1_H PROC NEAR

  MOV DL, SNAKE_1_POS_H_X
  MOV DH, SNAKE_1_POS_H_Y
  MOV CURR_POS_X, DL
  MOV CURR_POS_Y, DH
  CALL _SET_CURSOR

    RET
_SET_CURSOR_SNAKE_1_H ENDP
;---------------------------------------------
_SET_CURSOR_SNAKE_1_T PROC NEAR

  MOV DL, SNAKE_1_POS_T_X
  MOV DH, SNAKE_1_POS_T_Y
  MOV CURR_POS_X, DL
  MOV CURR_POS_Y, DH
  CALL _SET_CURSOR

    RET
_SET_CURSOR_SNAKE_1_T ENDP
;---------------------------------------------
_SET_CURSOR_SNAKE_2_H PROC NEAR

  MOV DL, SNAKE_2_POS_H_X
  MOV DH, SNAKE_2_POS_H_Y
  MOV CURR_POS_X, DL
  MOV CURR_POS_Y, DH
  CALL _SET_CURSOR

    RET
_SET_CURSOR_SNAKE_2_H ENDP
;---------------------------------------------
_SET_CURSOR_SNAKE_2_T PROC NEAR

  MOV DL, SNAKE_2_POS_T_X
  MOV DH, SNAKE_2_POS_T_Y
  MOV CURR_POS_X, DL
  MOV CURR_POS_Y, DH
  CALL _SET_CURSOR
    RET
_SET_CURSOR_SNAKE_2_T ENDP
;---------------------------------------------
_STORE_SNAKE_POS_1_H PROC NEAR

  MOV DL, CURR_POS_X
  MOV DH, CURR_POS_Y
  MOV SNAKE_1_POS_H_X, DL
  MOV SNAKE_1_POS_H_Y, DH

    RET
_STORE_SNAKE_POS_1_H ENDP
;---------------------------------------------
_STORE_SNAKE_POS_1_T PROC NEAR

  MOV DL, CURR_POS_X
  MOV DH, CURR_POS_Y
  MOV SNAKE_1_POS_T_X, DL
  MOV SNAKE_1_POS_T_Y, DH

    RET
_STORE_SNAKE_POS_1_T ENDP
;---------------------------------------------
_STORE_SNAKE_POS_2_H PROC NEAR

  MOV DL, CURR_POS_X
  MOV DH, CURR_POS_Y
  MOV SNAKE_2_POS_H_X, DL
  MOV SNAKE_2_POS_H_Y, DH

    RET
_STORE_SNAKE_POS_2_H ENDP
;---------------------------------------------
_STORE_SNAKE_POS_2_T PROC NEAR

  MOV DL, CURR_POS_X
  MOV DH, CURR_POS_Y
  MOV SNAKE_2_POS_T_X, DL
  MOV SNAKE_2_POS_T_Y, DH

    RET
_STORE_SNAKE_POS_2_T ENDP

;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;QUEUE_S1 Procedures
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;push to any L of a general purpose register and set H to 0 before calling function
;needs QUEUE_S1 -> DB n DUP (?), SIZE_S1 -> DW 00 to be initialized

_ENQUEUE_S1 PROC NEAR
  POP BX
  POP DX
  LEA SI, QUEUE_S1
  MOV SI, SIZE_S1

  MOV QUEUE_S1[SI], DL
  INC SIZE_S1

  PUSH BX
    RET
_ENQUEUE_S1 ENDP
;--------------------------------------------
;needs same as _ENQUEUE_S1 and a PREV_S1 variable
;Function stores popped variable in QUEUE_S1_OUT
_DEQUEUE_S1 PROC NEAR
  POP BX            ;for return address

  CMP SIZE_S1, 0    ;compare logic block to immediately leave if size is 0
  JNE NEXT1_S1
  MOV QUEUE_S1_OUT, 00
  JMP LEAVE_S1

  NEXT1_S1:
  ;PART 1
  ;this part moves STACK_S1[0] to DL and QUEUE_S1_OUT
    LEA SI, QUEUE_S1
    MOV SI, 0
    MOV DH, 0
    MOV DL, QUEUE_S1[SI]
    MOV QUEUE_S1_OUT, DL

  ;PART 2
  ;this part shifts the digits left
    DEC SIZE_S1            ;decrements SIZE_S1
    LEA SI, SIZE_S1        ;this block sets the cursor of the array to size -1

    MOV CX, SIZE_S1        ;also moves to cx for loop
    MOV PREV_S1, 00        ;set PREV_S1 to 00 for initial shift left to be replaced with null

    SHIFT_LEFT_S1:
      MOV SI, CX

      MOV AL, QUEUE_S1[SI]
      MOV AH, PREV_S1
      MOV QUEUE_S1[SI], AH       ;this block swaps variables
      MOV PREV_S1, AL

    LOOP SHIFT_LEFT_S1

    MOV AL, PREV_S1
    MOV QUEUE_S1[0], AL

  LEAVE_S1:
    PUSH BX
      RET
_DEQUEUE_S1 ENDP
;--------------------------------------------
DISPLAY_QUEUE_S1 PROC NEAR

  CALL _NEW_LINE

  MOV AH, 09
  LEA DX, QUEUE_S1
  INT 21H

  CALL _NEW_LINE

  LEA SI, QUEUE_S1
  MOV SI, 0
  MOV AL, QUEUE_S1[SI]

  MOV AH, 02
  MOV DL, AL
  INT 21H

  CALL _NEW_LINE

  MOV BX, SIZE_S1
  ADD BX, 30H

  MOV AH, 02
  MOV DX, BX
  INT 21H

  CALL _NEW_LINE
    RET
DISPLAY_QUEUE_S1 ENDP
;--------------------------------------------



;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;QUEUE_S2 Procedures
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;push to any L of a general purpose register and set H to 0 before calling function
;needs QUEUE_S2 -> DB n DUP (?), SIZE_S2 -> DW 00 to be initialized

_ENQUEUE_S2 PROC NEAR
  POP BX
  POP DX
  LEA SI, QUEUE_S2
  MOV SI, SIZE_S2

  MOV QUEUE_S2[SI], DL
  INC SIZE_S2

  PUSH BX
    RET
_ENQUEUE_S2 ENDP
;--------------------------------------------
;needs same as _ENQUEUE_S2 and a PREV_S2 variable
;Function stores popped variable in QUEUE_S2_OUT
_DEQUEUE_S2 PROC NEAR
  POP BX            ;for return address

  CMP SIZE_S2, 00    ;compare logic block to immediately leave if size is 0
  JNE NEXT1_S2
  MOV QUEUE_S2_OUT, 00
  JMP LEAVE_S2

  NEXT1_S2:
  ;PART 1
  ;this part moves QUEUE_S2[0] to DL and QUEUE_S2_OUT
    LEA SI, QUEUE_S2
    MOV SI, 0
    MOV DH, 0
    MOV DL, QUEUE_S2[SI]
    MOV QUEUE_S2_OUT, DL

  ;PART 2
  ;this part shifts the digits left
    DEC SIZE_S2            ;decrements SIZE_S2
    LEA SI, SIZE_S2        ;this block sets the cursor of the array to size -1

    MOV CX, SIZE_S2        ;also moves to cx for loop
    MOV PREV_S2, 00        ;set PREV_S2 to 00 for initial shift left to be replaced with null

    SHIFT_LEFT_S2:
      MOV SI, CX

      MOV AL, QUEUE_S2[SI]
      MOV AH, PREV_S2
      MOV QUEUE_S2[SI], AH       ;this block swaps variables
      MOV PREV_S2, AL

    LOOP SHIFT_LEFT_S2

    MOV AL, PREV_S2
    MOV QUEUE_S2[0], AL

  LEAVE_S2:
    PUSH BX
      RET
_DEQUEUE_S2 ENDP
;--------------------------------------------
DISPLAY_QUEUE_S2 PROC NEAR

  CALL _NEW_LINE

  MOV AH, 09
  LEA DX, QUEUE_S2
  INT 21H

  CALL _NEW_LINE

  LEA SI, QUEUE_S2
  MOV SI, 0
  MOV AL, QUEUE_S2[SI]

  ADD AL, 30H
    MOV AH, 02
    MOV DL, AL
    INT 21H

  LEA SI, QUEUE_S2
  MOV SI, 1
  MOV AL, QUEUE_S2[SI]

    ADD AL, 30H
    MOV AH, 02
    MOV DL, AL
    INT 21H

  LEA SI, QUEUE_S2
  MOV SI, 2
  MOV AL, QUEUE_S2[SI]

    ADD AL, 30H
  MOV AH, 02
  MOV DL, AL
  INT 21H

  CALL _NEW_LINE

  MOV BX, SIZE_S2
  ADD BX, 30H

  MOV AH, 02
  MOV DX, BX
  INT 21H

  CALL _NEW_LINE
    RET
DISPLAY_QUEUE_S2 ENDP
;--------------------------------------------
_NEW_LINE PROC NEAR
  MOV AH, 09
  LEA DX, NL
  INT 21H
    RET
_NEW_LINE ENDP
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;Initializing Procedures
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
;--------------------------------------------
_INITIALIZE PROC NEAR
  CALL _CLEAR_SCREEN
  CALL _INITIALIZE_BORDERS
  CALL _INITIALIZE_SNAKES
    RET
_INITIALIZE ENDP
;--------------------------------------------
_INITIALIZE_BORDERS PROC NEAR
  MOV CX, 40
  MOV CURR_POS_X, 00
  MOV CURR_POS_Y, 00
  CALL _SET_CURSOR

  SET_TOP_BORDER:
    LEA DX, WALL
    CALL _DISPLAY
    LEA DX, SPACE
    CALL _DISPLAY
  LOOP SET_TOP_BORDER

  MOV CURR_POS_X, 79
  MOV CURR_POS_Y, 00
  MOV CX, 23
  CALL _SET_CURSOR

  SET_RIGHT_BORDER:
    CMP CX, 00
    JE RIGHT_BORDER_SKIP
    CALL _MOVE_CURSOR_DOWN
    RIGHT_BORDER_SKIP:
    LEA DX, WALL
    CALL _DISPLAY
  LOOP SET_RIGHT_BORDER

  MOV CX, 40

  SET_BOTTOM_BORDER:
    CMP CX, 00
    JE BOTTOM_BORDER_SKIP
    CALL _MOVE_CURSOR_LEFT
    BOTTOM_BORDER_SKIP:
      LEA DX, SPACE
      CALL _DISPLAY
      CALL _MOVE_CURSOR_LEFT
      LEA DX, WALL
      CALL _DISPLAY

  LOOP SET_BOTTOM_BORDER

  MOV CX, 22
  MOV CURR_POS_X, 00
  MOV CURR_POS_Y, 23
  SET_LEFT_BORDER:
    CALL _MOVE_CURSOR_UP
    LEA DX, WALL
    CALL _DISPLAY
  LOOP SET_LEFT_BORDER


  MOV CURR_POS_X, 04
  MOV CURR_POS_Y, 24
  CALL _SET_CURSOR
  LEA DX, SCORE
  CALL _DISPLAY
    RET
_INITIALIZE_BORDERS ENDP
;--------------------------------------------
 _INITIALIZE_SNAKES PROC NEAR

  MOV DL, SNAKE_1_POS_T_X
  MOV DH, SNAKE_1_POS_T_Y
  MOV CURR_POS_X, DL
  MOV CURR_POS_Y, DH
  CALL _SET_CURSOR

  MOV CX, 03
  INIT_SNAKE_1:
    LEA DX, SNAKE_BODY
    CALL _DISPLAY
  LOOP INIT_SNAKE_1

  MOV DL, SNAKE_2_POS_H_X
  MOV DH, SNAKE_2_POS_H_Y
  MOV CURR_POS_X, DL
  MOV CURR_POS_Y, DH
  CALL _SET_CURSOR

  MOV CX, 03
  INIT_SNAKE_2:
    LEA DX, SNAKE_BODY
    CALL _DISPLAY
  LOOP INIT_SNAKE_2

  MOV AH, 00
  MOV AL, 03
  PUSH AX
  CALL _ENQUEUE_S1

  MOV AH, 00
  MOV AL, 03
  PUSH AX
  CALL _ENQUEUE_S1

  MOV AH, 00
  MOV AL, 01
  PUSH AX
  CALL _ENQUEUE_S2

  MOV AH, 00
  MOV AL, 01
  PUSH AX
  CALL _ENQUEUE_S2

      RET
 _INITIALIZE_SNAKES ENDP
;--------------------------------------------
_CLEAR_SCREEN PROC NEAR
  MOV AX, 0600H   ;full screen
  MOV BH, 07H     ;white background (7), blue foreground (1)
  MOV CX, 0000H   ;upper left row:column (0:0)
  MOV DX, 184FH   ;lower right row:column (24:79)
  INT 10H

  RET
_CLEAR_SCREEN ENDP
END MAIN
