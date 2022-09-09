.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data

  ; ---------------------- LOGIN VARS ------------------------------
  greetLoginMsg   db      "Welcome, Admin, please enter password: $"
  loginSuccMsg    db      "Login Success!!!$"
  loginFailMsg    db      "Wrong Password, please try again!!!$"
  ; to store user input password, max can only 8 characters
  passBuf         db      9 dup(?)
  password        db      "abcd1234", 0

  ; ---------------- COMMON VAR FOR FILE HANDLING ------------------
  fileHandle      dw      ?
  fileMsg         db      ?

  ; --------------- VAR FOR TESTING TODO: REMOVE -------------------
  testFile        db      "test.txt", 0

  ; ---------------- VARS FOR MEMBER OPTIONS -----------------------

;-------------- END of data segment

;-------------- CODES go here -----------------------------
.code

; ALL MACRO WILL NOT ALTER THE REGISTER VALUES, IT WILL BE RESTORED WHEN IT ENDS
; EXCEPT FOR THOSE LABELLED NO RETAIN 
;   (Use case: jump out of range [repeated push and pop make the code long, so possible jump out of range])
;---- SELF_DEFINED MACRO (utility functions that are reusable) ----

; Prints the char given
; Parameter: char -> the character to be printed
printChar macro char

  push    ax
  push    dx

  mov     ah, 02h
  mov     dl, char
  int     21h

  pop     dx
  pop     ax

endm printChar

; Prints string given
; Parameter: str -> $ terminated string VARIABLE to be printed
printStr macro str

  push    ax
  push    dx

  mov     ah, 09h
  lea     dx, str
  int     21h

  pop     dx
  pop     ax

endm printStr

; sets cursor position on the terminal
; Parameter: page -> the page, 
;            row -> row for cursor to be placed on, 
;            col -> column for cursor to be placed on
setCursp macro page, row, col

  push    ax
  push    bx
  push    dx

  mov     ah,02h	  		
  mov     bh, page			; set cursor at given page
  mov     dh, row 			; set cursor at given row
  mov     dl, col   		; set cursor at given column
  int     10h			      

  pop     dx
  pop     bx
  pop     ax

endm setCursp

; opens the file and set the global variable fileHandle if open successfully
; if open fail, carry flag will be on
; Parameter: fileName -> 0 terminated string containing the file name of the file to be opened
openFile macro fileName

  push  ax
  push  dx

  ; open file (TODO: Check CF for success: CF on if fail, err code at AX, if success, AX is file handle)
  mov   ah, 3dh       ; open file instruction
  mov   al, 2         ; open in read, write mode
  lea   dx, fileName
  int   21h
  mov   fileHandle, ax

  pop   dx
  pop   ax

endm openFile
;------ END MACRO DECLARATIONS ----------------------------

;------ FUNCTION DECLARATIONS -----------------------------
; when used, prints a new line (carriage return and line feed to screen)
newline proc

  ; store register data to stack so when end macro the register will have original value
  push    ax
  push    dx
  
  mov     ah, 02h
  mov     dl, 0ah     ; carriage return
  int     21h
  
  mov     dl, 0dh     ; line feed
  int     21h     

  ; restore register original data
  pop     dx
  pop     ax
  ret
newline endp

; when used, scroll by one screen
clear proc

  push    ax
  push    bx
  push    cx
  push    dx
  
  ; screen clearing
  mov     ax, 0600h
  mov     bh, 0Fh
  mov     cx, 0000h
  mov     dx, 18ffh
  int     10h

  pop     dx
  pop     cx
  pop     bx
  pop     ax
  ret
clear endp

; function for login
login proc
  STARTLOGIN:
    mov         bx, 0
    printStr    greetLoginMsg
    ; get character from user 1 by one, outputting * for every character they entered
    INPUT_PASS:
      mov     ah, 07h
      int     21h
      cmp     al, 0dh              ; check if user input is new line
      je      INPUT_FINISH
      printChar   "*"              ; at least user know they typed a char
      mov     passBuf[bx], al      ; put the inputted character into passBuf
      cmp     bx, 8                ; only allow 8 characters, put the last char as $
      jl      INCREMENT_INPUT_PW
      jge     INPUT_MORE_THAN_NINE
    INCREMENT_INPUT_PW:
      inc     bx
      jmp     INPUT_PASS
    
    ; if the user input more than 8 characters, we know for sure it is wrong password
    ; We will let the user continue input (but discard the input) until the user press enter to prevent password being bruteforced
    INPUT_MORE_THAN_NINE:
      mov     ah, 07h
      int     21h
      cmp     al, 0dh
      je      PASS_CHAR_NOT_EQ
      printChar   "*"
      jmp     INPUT_MORE_THAN_NINE

    ; if user input enter (before 8 characters)
    INPUT_FINISH:
      mov     passBuf[bx], 0       ; make it terminate

      mov     bx, 0                ; clean bx before compare password

    PASS_CHAR_EQUAL:
      cmp     passBuf[bx], 0       ; if passBuf is terminated, compare password to see if password is terminated or not
      je      CHECK_PASS_END
      mov     dl, passBuf[bx]
      cmp     dl, password[bx]     ; if havent check until end of password, compare if they are equal
      je      INCREMENT_PW_CHECK
      jne     PASS_CHAR_NOT_EQ           ; if not equal, tell them to reenter password
    PASS_CHAR_NOT_EQ:
      call      newline
      printStr  loginFailMsg
      call      newline
      jmp       STARTLOGIN         ; wrong password lol, please login again
    INCREMENT_PW_CHECK:
      inc       bx
      jmp       PASS_CHAR_EQUAL
    CHECK_PASS_END:
      cmp       password[bx], 0
      je        LOGIN_PASS
      jne       PASS_CHAR_NOT_EQ

  LOGIN_PASS:
    call        newline
    printStr    loginSuccMsg
  ret
login endp

; TODO: See if this function is rlly needed, if no, remove
; this function assumes the handler for the file is stored in the fileHandle global variable
; moves the cursor of the file in fileHandler to the start of file (0, 0)
moveFileCursSt proc

  
  ret
moveFileCursSt endp

; this function assumes the handler for the file is stored in the fileHandle global variable
; moves the cursor of the file in fileHandler to the EndOfFile
moveFileCursEnd proc

  
  ret
moveFileCursEnd endp

; this function assumes the handler for the file is stored in the fileHandle global variable
; prints the content in the file until EOF
printFile proc

  ; read file (CF on if fail, err code at AX, if success, AX is num bytes actually read, 0 IF when call eh time alrd at EOF, rmb move the cursor back to position 0 first when repeated read without reopening)
  READ_FILE_CHAR:
    mov   bx, fileHandle
    lea   dx, fileMsg
    mov   cx, 1         ; num bytes to read (will be reading byte by byte repeatedly until EOF)
    mov   ah, 3fh       ; read file instruction
    int   21h
    ; compare if at EOF, if no, print the character read and loop again
    cmp   ax, 0
    je    PRINT_FILE_END
    printChar fileMsg
    jmp   READ_FILE_CHAR

  PRINT_FILE_END:  
    ret
printFile endp

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
  
  openFile testFile
  call     printFile
    
  ; end of real program
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
