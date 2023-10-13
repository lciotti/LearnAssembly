;-----------------------------------------------------------------------------
;                                 EAT.ASM
;                     Backhanded advertising program
;
;                                           by Louis Ciotti
;                                           TASM
;                                           Last Update 4/27/2021
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
MyData     SEGMENT

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
MyProg    SEGMENT
          assume CS:MyProg,DS:MyData
Main      PROC

Start:    ; This is where program execution begins:

          mov  AX,MyData   ; Set up our own data segment address in DS
          mov  DS,AX       ; Can't load segment reg. directly from memory

          lea  DX,Eat1     ; Load offset of Eat1 message strin into DX
          call Writeln     ;   and display it
          lea  DX,Eat2     ; Load offset of CRLF string into DX
          call Writeln     ;   and display it

          mov  AH,4CH      ; Terminate process DOS service
          mov  AL,0        ; Pass this value back to ERRORLEVEL
          int  21H         ; Control  returns to DOS

;-----------------------------|
;      PROCEDURE SEGMENT      |
;-----------------------------|

Write     PROC
          mov  AH,09H      ; Select DOS service 09H: Print String
          int  21H         ; Call DOS
          ret              ; Return to the caller
Write     ENDP

Writeln   PROC
          call Write          ; Display the strin proper through Write
          mov DX,OFFSET CRLF  ; Load address of newline string into DS:DX
          call Write          ; Display newline string through Write
          ret                 ; Return to the Caller
Writeln   ENDP

;-----------------------------|
;      END PROCEDURE SEGMENT  |
;-----------------------------|

Main      ENDP

MyProg    ENDS

;---------------------------|
;     END CODE SEGMENT      |
;---------------------------|
          END Start      ; The procedure named Start becomes the main proram