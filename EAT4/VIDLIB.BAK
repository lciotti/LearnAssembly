;-----------------------------------------------------------------------------
;                               VIDLIB.ASM
;                          Video Display Library
;
;                                           by Louis Ciotti
;                                           TASM
;                                           Last Update: 05/01/21
;-----------------------------------------------------------------------------

MyData     SEGMENT PUBLIC

           EXTRN   CRLF:BYTE,LRXY:WORD

MyData     ENDS

MyCODE     SEGMENT PUBLIC

           PUBLIC GotoXY,ClrScr,ClrWin,ScrlWin,VIDEO6
           PUBLIC Write,Writeln

           ASSUME CS:MyCode,DS:MyData

;----------------------------------------------------------------------------|
;   GotoXY     --  Postion the hardware cursor to X,Y                        |
;   Last update: 05/01/21                                                    |
;                                                                            |
;   1 Entry point:                                                           |
;                                                                            |
;   GotoXY:                                                                  |
;      Caller must pass:                                                     |
;       DL: X Value        These are both 0 based:  i.e. they                |
;       DH: Y Value          assume a screen 24 x 79 not 25 x 80             |
;      Action:  Moves the hardware cursor to the X,Y postion                 |
;               loaded into DL and DH                                        |
;----------------------------------------------------------------------------|
GotoXY    PROC
          mov  AH,02H      ; Select VIDEO service 2: Position Cursor
          mov  BH,0        ; Stay with display page 0
          int  10H         ; Call VIDEO
          ret              ; Return to caller
GotoXY    ENDP

;----------------------------------------------------------------------------|
;   CLRSCR     --  Cleas or Scrolls screens or windows                       |
;   Last update: 05/01/21                                                    |
;                                                                            |
;   4 Entry Points:                                                          |
;                                                                            |
;   ClrScr:                                                                  |
;      No values expected from caller                                        |
;      Action: Clears the entire screen to blanks with 07H as                |
;              the display attribute                                         |
;                                                                            |
;   ClrWin:                                                                  |
;      Caller must pass:                                                     |
;                                                                            |
;      Action: Clears the window specified by the caller to                  |
;              blanks with 07H as the display attribut                       |
;                                                                            |
;   ScrlWin:                                                                 |
;      Caller must pass:                                                     |
;          Scrolls the window specified by the caller by                     |
;              the number of lines passed in AL. The blank                   |
;              lines inserted at screen bottom are cleared                   |
;              blanks with 07H as the display attribute                      |
;                                                                            |
;   VIDEO6:                                                                  |
;      Caller must pass:                                                     |
;         CH: Y coordinate. upper-left corner of window                      |
;         CL: X coordinate. upper-left corner of window                      |
;         DH: Y coordinate. lower-right corner of window                     |
;         DL: X coordinate. lower-right corner of window                     |
;         AL: number of lines to scroll window by (0 clears it)              |
;         BH: display attribute for blanked lines (07H is "normal")          |
;      Action: Generic access to BIOS VIDEO service 6.  Caller               |
;              must pass ALL register parameters as shown above              |
;----------------------------------------------------------------------------|
ClrScr    PROC
          mov  CX,0        ; Upper-left corner of screen (0,0)
          mov  DX,LRXY     ; Lower-right X,Y coordinates of screen into DX
ClrWin:   mov  AL,0        ; 0 specifies clear entire region
ScrlWin:  mov  BH,07H      ; Specify "normal" attribute for blanked line(s)
VIDEO6:   mov  AH,06H      ; Select VIDEO service 6: Initialize/Scroll
          int  10H         ; call VIDEO
          ret              ; return to caller
clrScr    ENDP

;----------------------------------------------------------------------------|
;   WRITE     -- Displays indoemation to the screen via DOS                  |
;                service 9: Print String                                     |
;   Last update: 05/01/21                                                    |
;                                                                            |
;   1 entry point:                                                           |
;                                                                            |
;   Write:                                                                   |
;      Caller must pass:                                                     |
;         DS: The segment of the string to be displayed                      |
;         DX: The offset of the string to be diaplayed                       |
;             String must be terminated by "$"                               |
;      Action: Displays the string at DS:DX up to the "$" marker             |
;----------------------------------------------------------------------------|
Write     PROC
          mov  AH,09H      ; Select DOS service 09H: Print String
          int  21H         ; Call DOS
          ret              ; Return to the caller
Write     ENDP

;----------------------------------------------------------------------------|
;   WRITELN     -- Displays information to the screen via DOS                |
;                  service 9 and issues a newline                            |
;   Last update: 05/01/21                                                    |
;                                                                            |
;   1 enty point                                                             |
;                                                                            |
;   Writeln:                                                                 |
;      Caller must pass:                                                     |
;         DS: The segment of the string to be displayed                      |
;         DX: The offset of the string to be displayed                       |
;             The string must be terminated by "$"                           |
;         Action:  Displays the string at DS:DX up to the "$" marker         |
;                  then issues a newline.  Harware cursor will               |
;                  move the the left margin of the following line.           |
;                  If the display is to the bottom of the screen line,       |
;                  the screen will scroll.                                   |
;     Calls: Write                                                           |
;----------------------------------------------------------------------------|
Writeln   PROC
          call Write          ; Display the strin proper through Write
          mov DX,OFFSET CRLF  ; Load address of newline string into DS:DX
          call Write          ; Display newline string through Write
          ret                 ; Return to the Caller
Writeln   ENDP

MyCode    ENDS

          END