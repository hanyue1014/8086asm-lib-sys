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

  ; ---------------- var for create member file --------------------
  ; ---------------- AND                        --------------------
  ; ---------------- var for open member file   --------------------
  ; data structure to store user inputted file name (user id inputted by user)
  MEM_FILE        label   byte
  memFileMaxLen   db      7                ; max is 6, 7th for enter char
  memFileActLen   db      ?
  memFileName     db      "XXXXXX.txt", 0  ; 6 X to be replaced with uID
  memNotEnfChar   db      "User ID does not contain 6 characters!!!$"

  ; ---------------- VAR FOR file operation function ---------------
  fileHandle      dw      ?
  fileMsg         db      ?
  readFileErrMsg  db      "Read file failed, please try again$"
  closeFileErrMsg db      "Close file failed, ignoring$"

  ; --------------- CREATEMEMBER VARS ------------------------------
  createMemPrompt db      "Enter the user id desired: $"
  memExistsMsg    db      "Sorry, this ID already exists, please select a new one$"

  ; --------------- VAR FOR TESTING TODO: REMOVE -------------------
  testFile        db      "test.txt", 0
  testCreate      db      "testCr.txt", 0

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

; creates the file and set the variable passed to handle if create successfully
; if file already exists, the old file will be deleted without any warning, so please do check
; upon using this macro, please check CF
; if create fail, carry flag will be on and variable passed to handle will be the error code
; Parameter: fileName -> 0 terminated string containing the file name of the file to be created
;            attrib   -> attribute for the file, 0 for none, 1 for readonly, 2 for hidden, 4 for system, 7 for all, 16 for archive
;            handle   -> variable to store the file handle in
createFile macro fileName, attrib, handle
  push  cx
  push  dx

  ; attempt to create file
  mov   cx, attrib      ; file attributes
  lea   dx, fileName
  mov   ah, 3ch         ; interrupt to create file
  int   21h
  mov   handle, ax

  pop   dx
  pop   cx

endm createFile

; opens the file and set the variable passed to handle if open successfully
; upon using this macro, please check CF
; if open fail, carry flag will be on and variable passed to handle will be the error code
; Parameter: fileName -> 0 terminated string containing the file name of the file to be opened
;            mode     -> mode to open the file in, 0 for r, 1 for w, 2 for rw
;            handle   -> variable to store the file handle in
openFile macro fileName, mode, handle

  push  ax
  push  dx

  mov   ah, 3dh           ; open file instruction
  mov   al, mode          ; open in read, write mode
  lea   dx, fileName
  int   21h
  mov   handle, ax

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

; THIS FUNCTION DOES NOT RETAIN REGISTER VALUES, REGISTER WILL BE OVERWRITTEN UPON USING THIS
; this function assumes the handler for the file to read is already in bx
; prints the content in the file until EOF
printFile proc

  ; read file (CF on if fail, err code at AX, if success, AX is num bytes actually read, 0 IF when call eh time alrd at EOF, rmb move the cursor back to position 0 first when repeated read without reopening)
  READ_FILE_CHAR:
    ; address of the place to store the content read
    lea   dx, fileMsg
    mov   cx, 1           ; num bytes to read (will be reading byte by byte repeatedly until EOF)
    mov   ah, 3fh         ; read file instruction
    int   21h
    jc    READ_FILE_FAIL  ; cf on, read file failed 
    ; compare if at EOF, if no, print the character read and loop again
    cmp   ax, 0
    je    PRINT_FILE_END
    printChar fileMsg
    jmp   READ_FILE_CHAR
  
  READ_FILE_FAIL:
    printStr readFileErrMsg
    jmp   PRINT_FILE_END

  PRINT_FILE_END:  
    ret
printFile endp

; always close a file if u opened it
; this function overwrites register values
; this function assumes bx is set to the handle of the file to be closed
closeFile proc

  mov     ah, 3eh
  int     21h
  jc      CLOSE_FILE_FAILED
  jmp     CLOSE_FILE_END

  CLOSE_FILE_FAILED:
    printStr closeFileErrMsg

  CLOSE_FILE_END:
    ret
closeFile endp

createMem proc

  CREATE_MEM_START:
    printStr createMemPrompt
    ; input user id (will be used as the file name)
    mov     ah, 0ah   ; input str function
    lea     dx, MEM_FILE
    int     21h
    call    newline
    ; if not enough six character, prompt the user
    cmp     memFileActLen, 6
    jl      USER_ID_NT_ENF_CH
    ; it wont be longer than 7 as max len is 7
    jmp     USER_ID_ENF_CH

  USER_ID_NT_ENF_CH:
    printStr memNotEnfChar
    jmp      CREATE_MEM_START

  USER_ID_ENF_CH:
    ; set the . back (previously replaced by enter key)
    mov        memFileName[6], "."
    ; TODO: Use open file to check if user already exist, for now assume user not exist if open fail
    openFile   memFileName, 0, fileHandle
    ; assume that open no fail means member already exists
    jnc        CREATE_MEM_EXISTS
    createFile memFileName, 0, fileHandle
    ; TODO: write to file if create success
    jmp        CREATE_MEM_END

  CREATE_MEM_EXISTS:
    printStr   memExistsMsg
    call       newline
    jmp        CREATE_MEM_START
  
  CREATE_MEM_END:
    ret

createMem endp

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
  
  ; openFile testFile, 2, fileHandle
  ; createFile testCreate, 0, fileHandle
  call    createMem

  ; printFile assumes the file handle for the file to be printed is already in bx when called
  ; mov      bx, fileHandle
  ; call     printFile

  mov      bx, fileHandle
  call     closeFile
    
  ; end of real program
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
