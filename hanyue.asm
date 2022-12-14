.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
  ; ------ from NSC, don't copy to main when compile ------
  thousand        dw      1000    ; copy this
  hundred         db      100
  ten             db      10

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
  memFileName     db      "XXXXXX.txt", 0  ; 6 X to be replaced with user ID
  memNotEnfChar   db      "User ID does not contain 6 characters!!!$"

  ; ---------------- VAR FOR file operation function ---------------
  ; assumption: only one file will be opened at one time, so will only make one fileHandle
  fileHandle      dw      ?
  ; will be reading a file char by char, fileMsg will be whr to store the read data
  fileMsg         db      ? 
  ; this is createFileErrMsg, too long, wojuedebuxing
  crtFileErrMsg   db      "Create file failed, please try again$"
  readFileErrMsg  db      "Read file failed, please try again$"
  writeFileErrMsg db      "Write to file failed, ignoring$"
  closeFileErrMsg db      "Close file failed, ignoring$"
  mvFilePosFail   db      "Seek file position failed, ignoring$"

  ; --------------- CREATEMEMBER VARS ------------------------------
  createMemPrompt db      "Enter the member id desired: $"
  memExistsMsg    db      "Sorry, this ID already exists, please select a new one$"
  createMemSucc   db      "Successfully created member!$"
  memFileDivider  db      "|", 43 dup("-"), "|", 10

  ;=================IC input ===============
  msgIcInput      db      "Please enter your Ic number: $"
  ICInvalid       db      "Invalid IC: IC should be 12 DIGITS[0-9]$"
  ICLabel        db      "| IC. No.   | "
  Input_label_IC  label   Byte
  Icmaxlen        db      13
  Icactlen        db      ?
  inputBuffer_IC  db      30 dup(" "), "|", 10   ; auto pad IC

  ; --------------- WRITEMEMID VARS -------------------------------
  memIDLabel      db      "| "
  memIDPadding    db      36 dup(" "), "|", 10
  
  ; --------------- GETFULLNAME VARS -------------------------------
  fullNamePrompt  db      "Enter your name: $"
  fullNameLabel   db      "| Name      | "
  fullNameField   label   byte
  fullNameMaxLen  db      30
  fullNameActLen  db      ?
  fullNameInput   db      30 dup(" "), "|",  10    ; auto padded weee, and the close the field

  ; --------------- GETHPNO VARS -----------------------------------
  hpNoPrompt      db      "Enter your phone number: $"
  hpNoInvalidMsg  db      "Invalid Phone Number: Phone number should be 10-11 DIGITS[0-9]$"
  hpNoLabel       db      "| HP. No.   | "
  hpNoField       label   byte
  hpNoMaxLen      db      12                       ; hp no can be 10 or 11 chars
  hpNoActLen      db      ?
  hpNoInput       db      30 dup(" "), "|",  10    ; auto pad

  ; --------------- GETGENDER VARS ---------------------------------
  genderPrompt    db      "Enter your gender: $"
  genderPromptOps db      "Gender Options$"
  genderPromptOp1 db      "[F]emale$"
  genderPromptOp2 db      "[M]ale$"
  genderPromptOp3 db      "[U]ndefined$"
  invalidGender   db      "Invalid gender! Only UPPERCASE (F/M/U) accepted!$"
  genderLabel     db      "| Gender    | "
  genderInput     db      ?, 29 dup(" "), "|", 10  ; first is gender char (F/M/U), then the padding, then newline  
  
  ; --------------- GETROYALMEMBER VARS ---------------------------------
  rmPrompt        db      "Do you want to become a Royal Member: $"
  rmPromptOps     db      "Royalty Member Options$"
  rmPromptOp1     db      "[Y]es$"
  rmPromptOp2     db      "[N]o$"
  invalidRMOp     db      "Invalid Option! Only UPPERCASE (Y/N) accepted!$"
  rmLabel         db      "| R. Member | "
  rmInput         db      ?, 29 dup(" "), "|", 10  ; first is RM char (Y/N), then the padding, then newline

  ; ---------------- VARS FOR MEMBER OPTIONS -----------------------
  memberIDPrompt  db      "Enter the member's ID: $"
  memberOpPrompt1 db      "Member Options$"
  memberOpPrompt2 db      "1. Loan Book$"
  memberOpPrompt3 db      "2. Return Book$"
  memberOpPrompt4 db      "3. Member Details$"
  memberOpPrompt5 db      "b. Back$"
  memberOpPrompt6 db      "Enter your choice: $"

  ; to let us know if we are serving a member, 1 means yes, 0 or others means no
  hasMember       db      0
  memNotExistMsg  db      "Sorry, member not found, did you registered?$"

  ; --------------- MEMBER MENU VARS --------------------------------
  memMenuOpIn     db      ?
  invalidMemOp    db      "Invalid option!$"
  memberOpRestart db      "Do you want to continue serving this member (Y/N)?$"

  ; --------------- LOAN AND RETURN BOOK FILE HANDLING VARS ---------
  ; file handle for loan book
  loanBookFileH   dw      ?
  ; file name (will be used by both loan and return book)
  loanBookFileN   db      "lnList.txt", 0
  ; ----------------- GETBOOK VARS ----------------------------------
  ; the book that will undergo loan or return
  bookInpPrompt   db      "Please input the book: $"
  bookInp         label   byte
  bookMaxLen      db      21
  bookActLen      db      ?
  bookInpBuf      db      21 dup(" "), 10

  ; --------------- WRITESYSDATE VARS -------------------------------
  ; DD to be replaced by date, MM to be replaced by month, YYYY to be replaced by year
  dateLabel       db      "[DD/MM/YYYY] "
  
  ; --------------- LOAN BOOK VARS ----------------------------------
  loanLabelTxt    db      " loans <"

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

; writes size byte of the string passed in msg to the handle (file opened)
; upon using this macro, please check CF
; if write fail, CF will be on
; Parameter: handle   -> handle of the file that will be written to
;            size     -> show many bytes from msg to write into the file
;            msg      -> variable that contains the string to be written to the file
writeFile macro handle, size, msg

  push  ax
  push  bx
  push  cx
  push  dx

  ; write to file (nid check CF for successCF on if fail, err code at AX, if success, AX is num bytes actually written)
  mov   bx, handle
  mov   cx, size
  lea   dx, msg
  mov   ah, 40h       ; write to file instruction
  int   21h

  pop   dx
  pop   cx
  pop   bx
  pop   ax

endm writeFile
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
      cmp     al, 0dh              ; check if user input is carriage return
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

; this function assumes the handler for the file is stored in bx
; moves the cursor of the file in fileHandler to the start of file (0, 0)
; DOES NOT RETAIN REGISTER VALUES
moveFileCursSt proc
  mov     ah, 42h         ; move file cursor
  mov     al, 0           ; to calculate offset from beginning of file
  mov     cx, 0           ; offset from al
  mov     dx, 0           ; least significant offset (CX:DX) (row:col)
  int     21h             
  jc      ERR_MV_FILE_CURS_ST
  jmp     END_MV_FILE_CURS_ST

  ERR_MV_FILE_CURS_ST:
    printStr  mvFilePosFail
    call      newline
  
  END_MV_FILE_CURS_ST:
    ret

moveFileCursSt endp

; this function assumes the handler for the file is stored in the bx register
; moves the cursor of the file in fileHandle to the EndOfFile
moveFileCursEnd proc
  mov     ah,42h       ; move file cursor
  mov     al, 2        ; to calculate offset from end of file
  mov     cx, 0        ; offset from al
  mov     dx, 0        ; least significant offset (CX:DX) (row:col), 0:0 as we want to write to EOF
  int     21h             
  jc      ERR_MV_FILE_CURS_END
  jmp     END_MV_FILE_CURS_END

  ERR_MV_FILE_CURS_END:
    printStr  mvFilePosFail
    call      newline
  
  END_MV_FILE_CURS_END:
    ret

moveFileCursEnd endp

; THIS FUNCTION DOES NOT RETAIN REGISTER VALUES, REGISTER WILL BE OVERWRITTEN UPON USING THIS
; this function assumes the handler for the file to read is already in bx
; prints the content in the file char by char until EOF
printFileC proc

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
    cmp   fileMsg, 13    ; gonna ignore CR as if creating file on dos, EOL is 0d0a, this allows support both linux and dos txt files as linux EOL is only 0a but dos is 0d0a
    je    READ_FILE_CHAR
    ; compare if is newline char (line feed), will call our own newline proc when meet newline char
    cmp   fileMsg, 10
    je    READ_FILE_NEWLINE
    printChar fileMsg
    jmp   READ_FILE_CHAR

  READ_FILE_NEWLINE:
    call  newline
    jmp   READ_FILE_CHAR
  
  READ_FILE_FAIL:
    printStr readFileErrMsg
    jmp   PRINT_FILE_END

  PRINT_FILE_END:  
    ret
printFileC endp

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

createFileFail proc

  printStr   crtFileErrMsg
  ret 

createFileFail endp

; general place to handle writing file failed
writeFileFail proc

  printStr    writeFileErrMsg
  call        newline
  ret

writeFileFail endp

writeMemFileDiv proc

  writeFile  fileHandle, 46, memFileDivider
  ; carry flag not on, write successfully
  jnc        END_WRITE_MEM_FILE_DIV
  ; carry flag on, write to file failed, but do ntg
  call       writeFileFail

  END_WRITE_MEM_FILE_DIV:
    ret

writeMemFileDiv endp

; will be used to write the member ID of the user into the file
; assumes fileHandle is placed in bx
writeMemId proc

  writeFile  bx, 6, memFileName    ; take 6 bytes from memFileName (6 char of member id)
  jc         WRITE_MEM_ID_FAIL
  jmp        END_WRITE_MEM_ID

  ; write to file failed, but i can do ntg :")
  WRITE_MEM_ID_FAIL:
    call     writeFileFail

  END_WRITE_MEM_ID:
    ret

writeMemId endp

; extends writeMemId, used specifically in createMem for all the formatting stuffs
writeMemIdC proc

  writeFile  fileHandle, 2, memIDLabel
  jc         WRITE_MEM_ID_C_FAIL
  mov        bx, fileHandle
  call       writeMemId
  writeFile  fileHandle, 38, memIDPadding
  jc         WRITE_MEM_ID_C_FAIL
  jmp        END_WRITE_MEM_ID_C

  ; write to file failed, but i can do ntg :")
  WRITE_MEM_ID_C_FAIL:
    call     writeFileFail

  END_WRITE_MEM_ID_C:
    ret

writeMemIdC endp

;==============Input Ic =====================================

inputIc proc

START_INPUT_IC:
  printStr    msgIcInput
  mov ah,0ah
  lea dx,Input_label_IC
  int 21h
  call newline
  mov si,0
here_IC:
  ; check if si is 12 (0 - 11), 12 means end
  cmp si, 12
  je  valid_ic
  mov al,inputBuffer_IC[si]

  cmp al,"0"
  jb invalid_ic
  cmp al,"9"
  ja invalid_ic
  jmp increment_ic

increment_ic:
  inc si
  jmp here_IC

invalid_ic:
    printStr ICInvalid
    jmp START_INPUT_IC
    
valid_ic:
  ; clean ic field (remove enter)
  mov     inputBuffer_IC[si], " "
  ;------ Format file and write to file section for name ------
  writeFile  fileHandle, 14, ICLabel
  ; well, fail le we can do ntg, so just tell write failed and do ntg ba /shrug
  jc      WRITE_IC_FAIL
  writeFile  fileHandle, 32, inputBuffer_IC
  ; if no fail directly jump to end, fail le will still call the function
  jnc     quit_Inp_IC

  WRITE_IC_FAIL:
    call  writeFileFail

quit_Inp_IC:  
  ret
inputIc endp

; will be used by createMem to separate logic out
; gets the full name of a member and writes to the file
getFullName proc

  printStr   fullNamePrompt
  ; input full name
  mov     ah, 0ah   ; input str function
  lea     dx, fullNameField
  int     21h
  ; remove the enter key user inputted
  mov     bx, 0000h                         ; empty bx first
  mov     bl, fullNameActLen
  mov     fullNameInput[bx], " "
  call    newline
  ;------ Format file and write to file section for name ------
  writeFile  fileHandle, 14, fullNameLabel
  ; well, fail le we can do ntg, so just tell write failed and do ntg ba /shrug
  jc      WRITE_FULL_NAME_FAIL
  writeFile  fileHandle, 32, fullNameInput
  ; if no fail directly jump to end, fail le will still call the function
  jnc     GET_FULL_NAME_END

  WRITE_FULL_NAME_FAIL:
    call  writeFileFail
  GET_FULL_NAME_END:
    ret

getFullName endp

; gets and validates phone number, writes into the member file
getHpNo proc

  START_INPUT_HP_NO:
    printStr    hpNoPrompt
    ; input phone number
    mov     ah, 0ah
    lea     dx, hpNoField
    int     21h
    call    newline

    ; set si to 0 to be ready for char by char validation
    mov     si,0
  START_HP_NO_CHECK:
    ; check if the character is CR (the enter key pressed by user)
    mov     al, hpNoInput[si]
    cmp     al, 0dh
    je      IN_HP_NO_ENTER     ; enter reached in inputHpNo (very sensible naming, ikr)

    cmp     al,"0"
    jb      INVALID_HP_NO
    cmp     al,"9"
    ja      INVALID_HP_NO
    jmp     INC_HP_NO_SI

  IN_HP_NO_ENTER:
    cmp     si, 10            ; 11th char is CR, no prob (0-9) 10 chars is digit
    je      VALID_HP_NO
    cmp     si, 11            ; 12th char is CR, no prob (0-9) 11 chars is digit
    je      VALID_HP_NO
    jmp     INVALID_HP_NO     ; none of it passed, invalid lo /shrug

  INC_HP_NO_SI:
    inc     si
    jmp     START_HP_NO_CHECK

  INVALID_HP_NO:
    printStr hpNoInvalidMsg
    jmp     START_INPUT_HP_NO
      
  VALID_HP_NO:
    ; clean phone number field (remove enter)
    mov     hpNoInput[si], " "
    ;------ Format file and write to file section for name ------
    writeFile  fileHandle, 14, hpNoLabel
    ; well, fail le we can do ntg, so just tell write failed and do ntg ba /shrug
    jc      WRITE_HP_NO_FAIL
    writeFile  fileHandle, 32, hpNoInput
    ; if no fail directly jump to end, fail le will still call the function
    jnc     END_GET_HP_NO

    WRITE_HP_NO_FAIL:
      call  writeFileFail

  END_GET_HP_NO:  
    ret

getHpNo endp

; gets and validates gender, can be F - female, M - male, U - undefined (only uppercase)
getGender proc

  START_GENDER_PROMPT:
    printStr    genderPromptOps
    call        newline
    printStr    genderPromptOp1
    call        newline
    printStr    genderPromptOp2
    call        newline
    printStr    genderPromptOp3
    call        newline 
    printStr    genderPrompt
    ; input char for gender
    mov     ah, 01h
    int     21h

    ; check for gender
    cmp    al, "F"
    je     VALID_GENDER
    cmp    al, "M"
    je     VALID_GENDER
    cmp    al, "U"
    je     VALID_GENDER

    ; if all the compares up thr did not jump to VALID_GENDER, then it's invalid
    call   newline
    printStr    invalidGender
    call   newline
    jmp    START_GENDER_PROMPT
  
  VALID_GENDER:
    call    newline
    mov     genderInput, al
    ; ------ format and write to gender section -------
    writeFile  fileHandle, 14, genderLabel
    jc      WRITE_GENDER_FAIL
    writeFile  fileHandle, 32, genderInput
    jnc     GET_GENDER_END

  WRITE_GENDER_FAIL:
    call    writeFileFail

  GET_GENDER_END:
    ret

getGender endp

; gets and validates royalty member (only uppercase Y or N is accepted)
getRoyaltyMember proc

  START_RM_PROMPT:
    printStr    rmPromptOps
    call        newline
    printStr    rmPromptOp1
    call        newline
    printStr    rmPromptOp2
    call        newline 
    printStr    rmPrompt
    ; input char for gender
    mov     ah, 01h
    int     21h

    ; check for gender
    cmp    al, "Y"
    je     VALID_RM_OP
    cmp    al, "N"
    je     VALID_RM_OP

    ; if all the compares up thr did not jump to VALID_GENDER, then it's invalid
    call   newline
    printStr    invalidRMOp
    call   newline
    jmp    START_RM_PROMPT
  
  VALID_RM_OP:
    call    newline
    mov     rmInput, al
    ; ------ format and write to gender section -------
    writeFile  fileHandle, 14, rmLabel
    jc      WRITE_RM_OP_FAIL
    writeFile  fileHandle, 32, rmInput
    jnc     GET_RM_END

  WRITE_RM_OP_FAIL:
    call    writeFileFail

  GET_RM_END:
    ret

getRoyaltyMember endp

; this function handles the input of member ID (placed in the MEM_FILE label), and the validation
; rmb check carry flag, carry flag will be turned on if this function fails
inputMemId proc

  mov     ah, 0ah   ; input str function
  lea     dx, MEM_FILE
  int     21h
  call    newline
  ; if not enough six character, prompt the user
  cmp     memFileActLen, 6
  jl      USER_ID_NT_ENF_CH
  jmp     INPUT_MEM_ID_END
  USER_ID_NT_ENF_CH:
    printStr memNotEnfChar
    call     newline
    stc               ; set carry flag
    ret

  INPUT_MEM_ID_END:
    ; set the . back (previously replaced by enter key)
    mov        memFileName[6], "."
    clc               ; clear carry flag
    ret

inputMemId endp

createMem proc

  CREATE_MEM_START:
    printStr createMemPrompt
    call    inputMemId
    ; if carry flag on means inputMemId has error
    jc      CREATE_MEM_START
    jmp     USER_ID_ENF_CH
  
  ; this label actually belongs to USER_ID)ENF_CH, scared long jump needed, so put up here
  CREATE_MEM_EXISTS:
    printStr   memExistsMsg
    call       newline
    jmp        CREATE_MEM_START

  USER_ID_ENF_CH:
    ; Use open file to check if user already exist, for now assume user not exist if open fail
    openFile   memFileName, 0, fileHandle
    ; assume that open no fail means member already exists
    jnc        CREATE_MEM_EXISTS
    createFile memFileName, 0, fileHandle
    jc         CREATE_MEM_FAIL
    ; format the table by printing dividers in between
    call       writeMemFileDiv
    ; user id field (table heading)
    call       writeMemIdC
    call       writeMemFileDiv
    ; name field
    call       getFullname
    ; IC field 
    call       inputIc
    ; phone number field
    call       getHpNo
    ; gender field
    call       getGender
    ; royalty member field
    call       getRoyaltyMember
    ; close the table
    call       writeMemFileDiv
    ; create success
    printStr   createMemSucc
    jmp        CREATE_MEM_END
  
  ; create file failed, but we can do ntg as of now, maybe just say create file failed and rerun this function
  CREATE_MEM_FAIL:
    call      createFileFail
    jmp       CREATE_MEM_START

  CREATE_MEM_END:
    ; rmb to close files
    mov       bx, fileHandle
    call      closeFile
    ret

createMem endp

; asks for member id, if not found, ends, if found, memFile will be set, hasMember will become 1
getMember proc 
  GET_MEMBER_START:
    printStr memberIDPrompt
    call    inputMemId
    ; if carry flag on means inputMemId gt error
    jc      GET_MEMBER_START

  ; assume open no fail is member exist, if open fail is member not exist
  openFile   memFileName, 0, fileHandle
  ; go to print menu if member exists
  jnc     GET_MEMBER_EXISTS
  printStr   memNotExistMsg
  jmp     GET_MEMBER_END

  GET_MEMBER_EXISTS:
    mov   hasMember, 1
  
  GET_MEMBER_END:
    ret

getMember endp

printMemberOptions proc

  printStr    memberOpPrompt1
  call        newline
  printStr    memberOpPrompt2
  call        newline
  printStr    memberOpPrompt3
  call        newline
  printStr    memberOpPrompt4
  call        newline
  printStr    memberOpPrompt5
  call        newline
  printStr    memberOpPrompt6
  
  ret

printMemberOptions endp

printMemDetails proc

  mov     bx, fileHandle
  call    printFileC

  ret

printMemDetails endp

; gets system date, parses it and writes it to file with [DD/MM/YYYY]
; assumes that lnList.txt is already opened and loanBookFileH is already set to the handle
writeSysDate proc

  ; get system date CX = year (1980-2099). DH = month. DL = day
  mov     ah, 2ah
  int     21h

  ; convert day to ascii and set it into field
  mov     ah, 00h
  mov     al, dl
  div     ten
  add     al, 30h
  mov     dateLabel[1], al
  add     ah, 30h
  mov     dateLabel[2], ah

  ; same principle, convert month to ascii and set it into field
  mov     ah, 00h
  mov     al, dh
  div     ten
  add     al, 30h
  mov     dateLabel[4], al
  add     ah, 30h
  mov     dateLabel[5], ah

  ; year is slightly more mahuan, since its word (1000+)
  mov     dx, 0000h    ; empty dx first
  mov     ax, cx       ; put the year to cx, ready for dividing
  div     thousand     
  ; am very certain that the quotient will only be single digit
  add     al, 30h
  mov     dateLabel[7], al
  mov     ax, dx       ; remainder at dx, now can move back to ax for further parsing
  div     hundred
  add     al, 30h
  mov     dateLabel[8], al
  mov     al, ah       ; move the remainder to al, reset ah with 0 for further parsing (eg. remainder 25h, nid make ax become 0025h)
  mov     ah, 00h
  div     ten
  add     al, 30h
  mov     dateLabel[9], al
  add     ah, 30h
  mov     dateLabel[10], ah

  writeFile   loanBookFileH, 13, dateLabel
  jnc     WRITE_SYS_DATE_END
  call    writeFileFail

  WRITE_SYS_DATE_END:
    ret

writeSysDate endp

; gets a book (inputted by user), writes into loanBookFileH
getBook proc

  printStr      bookInpPrompt

  ; input for book name to be loaned
  mov     ah, 0ah
  lea     dx, bookInp
  int     21h
  ; remove enter from user input, replace with > to close the book name
  mov     bh, 00h
  mov     bl, bookActLen
  mov     bookInpBuf[bx], ">"
  writeFile     loanBookFileH, 22, bookInpBuf
  jnc     GET_BOOK_END
  call    writeFileFail

  GET_BOOK_END:
    ret

getBook endp

; writes to lnList.txt
; assumes lnList.txt already exists on the machine
memLoanBook proc

  ; read system date (maybe?), example msg will be [DD/MM/YYYY] XXXXXX loan <20 dup('y')>
  ; where XXXXXX is member ID, 20 dup('y') is book name
  ; open loanBookFileN in write mode, set handle to loanBookFileH
  openFile  loanBookFileN, 1, loanBookFileH
  mov     bx, loanBookFileH
  call    moveFileCursEnd
  
  call    writeSysDate
  mov     bx, loanBookFileH
  call    writeMemId
  writeFile   loanBookFileH, 8, loanLabelTxt
  call    getBook

  ; rmb to close file ;))
  mov     bx, loanBookFileH
  call    closeFile

  ret

memLoanBook endp

memberOptions proc

  call    getMember
  MEMBER_OPTIONS:
    cmp     hasMember, 0
    je      MEMBER_OPTIONS_END
    call    printMemberOptions
    ; input for option
    mov     ah, 01h
    int     21h
    mov     memMenuOpIn, al
    call    newline

    cmp     memMenuOpIn, "1"
    je      LOAN_BOOK_OPTION
    cmp     memMenuOpIn, "2"
    je      RETURN_BOOK_OPTION
    cmp     memMenuOpIn, "3"
    je      MEMBER_DETAILS_OPTION
    cmp     memMenuOpIn, "b"
    je      EXIT
    jmp     INVALID_MEMBER_OPTION

  LOAN_BOOK_OPTION:
    call    memLoanBook
    jmp     CONTINUE_CONFIRMATION_MEM_OP

  RETURN_BOOK_OPTION:

  MEMBER_DETAILS_OPTION:
    call    printMemDetails
    ; after reading, reset the position to beginning of file
    mov     bx, fileHandle
    ; this function assumes the file handle of the file tht needs position moving is in bx
    call    moveFileCursSt
    jmp     CONTINUE_CONFIRMATION_MEM_OP
  
  INVALID_MEMBER_OPTION:
    printStr  invalidMemOp
    call  newline
    jmp   CONTINUE_CONFIRMATION_MEM_OP
  
  CONTINUE_CONFIRMATION_MEM_OP:
    printStr  memberOpRestart
    call  newline
    mov   ah, 01h
    int   21h
    ; shud reloop upon Y or y
    cmp   al, "Y"
    je    MEMBER_OPTIONS
    cmp   al, "y"
    je    MEMBER_OPTIONS
    jmp   MEMBER_OPTIONS_END
  
  MEMBER_OPTIONS_END:
    ; close the member file upon quit
    mov   bx, fileHandle
    call  closeFile
    mov   hasMember, 0    ; finished serving a member
    ret

memberOptions endp

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
  call    login
  call    createMem
  call    memberOptions
    
  ; end of real program
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
