;-----------------------------------------------------------------------------
;                                 EAT4.ASM
;                     Backhanded advertising program
;
;                                           by Louis Ciotti
;                                           TASM
;                                           Last Update 05/01/21
;-----------------------------------------------------------------------------

;--------------------------------|
;    BEGIN STACK SEGMENT         |
;--------------------------------|
MyStack    SEGMENT Stack            ; STACK word ensures loading of SS by DOS

           DB   64 DUP ('STACK!!!') ; This reserves 512 bytes for the stack

MyStack    ENDS
;--------------------------------|
;     END STACK SEGMENT          |
;--------------------------------|

;--------------------------------|
;     BEGIN DATA SEGMENT         |
;--------------------------------|
MyData     SEGMENT PUBLIC
           PUBLIC LRXY,CRLF


LRXY       DW      184FH  ; 18H = 24D; 4F = 79D; 0-based XY of LR screen corner

TextPos    DW      ?
Eat1       DB      "Eat at Joes's...",'$'
Eat2       DB      "...ten million files can't ALL be wrong!",'$'
CRLF       DB      0DH,0AH,'$'

MyData     ENDS
;--------------------------------|
;     END DATA SEGMENT           |
;--------------------------------|

;--------------------------------|
;     BEGIN CODE SEGMENT         |
;--------------------------------|

; Note that the following items are external to EAT4.ASM, and must
;  be linked from the external file VIDLIB.OBJ.  Assemble VIDLIB.ASM
;  first to VIDLIB.OBJ before attempting the link.

           EXTRN GotoXY:PROC,Write:PROC,Writeln:PROC,ClrScr:PROC

MyCode     SEGMENT PUBLIC

           ASSUME CS:MyCode,DS:MyData
Main       PROC

Start:     ; This is where program execution begins:

           mov  AX,MyData   ; Set up our own data segment address in DS
           mov  DS,AX       ; Can't load segment reg. directly from memory

           call ClrScr      ; Clear the full screen

           mov  TextPos, 0914H     ; 0914H = X @ 20 Y @9

           mov  DX,TextPos  ; TextPos contains the X,Y values
           call GotoXY      ; Position the Cursor
           lea  DX,Eat1     ; Load offset of Eat1 message strin into DX
           call Writeln     ;   and display it

           mov  DX,TextPos  ; Reuse the TextPos variable
           mov  DH, 10      ; Put new value of Y postion into DH
           call GotoXY      ; Postion the cursor
           lea  DX,Eat2     ; Load offset of CRLF string into DX
           call Writeln     ;   and display it

           mov  AH,4CH      ; Terminate process DOS service
           mov  AL,0        ; Pass this value back to ERRORLEVEL
           int  21H         ; Control  returns to DOS

Main       ENDP

MyCode     ENDS

;---------------------------|
;     END CODE SEGMENT      |
;---------------------------|
           END Start      ; The procedure named Start becomes the main proram