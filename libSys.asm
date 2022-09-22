.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
  ; common vars for flow handling
  anyKeyContMsg   db      "Press any key to continue...$"
  ; common vars for formatting
  ; row and column of where the cursor at on screen, defaults to 0
  currRow         db      0
  currCol         db      0
  ; to let newline know where to where should be colored
  winRowSt        db      0
  winRowEnd       db      18h
  winSizeSt       db      0
  winSizeEnd      db      4fh
  ; ---------------------- LOGIN VARS ------------------------------
  greetLoginMsg   db      "Welcome, Admin, please enter password: $"
  loginSuccMsg    db      "Login Success!!!$"
  loginFailMsg    db      "Wrong Password, please try again!!!$"
  ; to store user input password, max can only 8 characters
  passBuf         db      9 dup(?)
  password        db      "abcd1234", 0
  
  ; PRINT HEADER VARS
  Printimg1      db        ",--.   ,--.       ,--.                                 $"
  Printimg2      db        "|  |   |  | ,---. |  | ,---. ,---. ,--,--,--. ,---.    $"
  Printimg3      db        "|  |.'.|  || .-. :|  || .--'| .-. ||        || .-. :   $"
  Printimg4      db        "|   ,'.   |\   --.|  |\ `--.' '-' '|  |  |  |\   --.   $"
  Printimg5      db        "'--'   '--' `----'`--' `---' `---' `--`--`--' `----'   $"
  
  ; PRINT MENU VARS
  PrintHeader1    db     " ==================================$"
  PrintHeader2    db    " |          Library System         | $"
  PrintHeader3    db     " ==================================$"

  PrintMenuMsg1   db     "Enter the process you want to carry >> $"
  PrintMenu1      db     "1.Member Menu$"
  PrintMenu2      db     "2.Register Member$"
  PrintMenu3      db     "3.Book Loan List$"
  PrintMenu4      db     "4.Book Search$"
  PrintMenu5      db     "5.Quit Program$"
  
  ;=============== data for book search func =====================
  BookSearchHeader1    db     " ==================================$"
  BookSearchHeader2    db     " |           Book Search          |$"
  BookSearchHeader3    db     " ==================================$"
  BookSearchMenu1      db     "   1. Computer Science$"
  BookSearchMenu2      db     "   2. English$"
  BookSearchMenu3      db     "   3. Mathematics$"
  BookSearchMenu4      db     "   4. Back$"
  BookSearchMsg        db     "Enter the category of the book>> $"
  BookSearchUsrInput   db     ?
  Shelf1               db     " 1. C++, 2. Java,  3. C#,  4. Php$"
  Shelf2               db     " 5. Harry Porter, 6. William Shakespeare$"
  Shelf3               db     " 7. Calculus , 8. Statistics, 9. Discrete Math$"
  BookLocation1        db     " Shelf 1 row 2$"
  BookLocation2        db     " Shelf 1 row 1$"
  BookLocation3        db     " Shelf 2 row 1$"
  BookLocation4        db     " Shelf 2 row 4$"
  BookLocation5        db     " Shelf 3 row 2$"
  BookLocation6        db     " Shelf 3 row 5$"
  BookLocation7        db     " Shelf 4 row 6$"
  BookLocation8        db     " Shelf 5 row 7$"
  BookLocation9        db     " Shelf 1 row 5$"
  BookLocationMsg      db     " Which book's location do you wish to find>> $"
  S1input              db     ?
  S2input              db     ?
  S3input              db     ?

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
  memberOpPromptH db      "==========================$"
  memberOpPrompt1 db      "| Member Options         |$"
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
  memberOpRestart db      "Do you want to continue serving this member (Y)es?$"

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
  thousand        dw      1000        ; used to parse year
  ; DD to be replaced by date, MM to be replaced by month, YYYY to be replaced by year
  dateLabel       db      "[DD/MM/YYYY] "
  
  ; --------------- LOAN BOOK VARS ----------------------------------
  loanLabelTxt    db      " loans   <"
  loanSuccMsg     db      "Loan book success!$"

  ; --------------- return book vars --------------------------------
  retLabelTxt     db      " returns <"
  retSuccMsg      db      "Return book success!$"

  ; ---------------- user quit confirmation msgs -------------------------------
  wantToQuitH     db  "====================================$"
  wantToQuitM     db  "| Do you want to quit the program? |$"
  wantToQuitOp1   db  "[Y/y]es$"
  wantToQuitOp2   db  "Anything else: No$"

  ; ---- soon chee's vars (can u label it which function they belong to in the future) ----
  hundred         db 100
  ten             db 10
  discount        db 80
  chargeLessDate  db 2
  chargeMinDate   db 3
  temp            db ?
  ans             db ?
  remain          db ?
  quotient        db ?
  wholeNum        db ?
  decimalNum      db ?
  priceWholeNum   db ?
  priceDecimalNum db ?
  decimalChange   db ?
  wholeChange     db ?
  loanDateMsg     db "Please enter the days of the book loan: $"
  invalidInput    db "Invalid Input. Please enter integer.$"
  loanAmountMsg   db "The total amount need to be paid: RM $"
  chargeOverDate  db "180$"
  memberMsg       db "Is the member a royal member (Y for yes/ N for no): $"
  nonRoyalMsg     db "Not royal member cannot enjoy 20% discount.$"
  invalidChoice   db "Invalid Input. Please only input 'Y' or 'N'.$"
  priceNotEnough  db "The price need to be paid is not enough.$"
  discountMsg     db "The price after discount: RM $"
  loanPayMsg      db "Enter the price paid by the user: RM $" 
  loanReturnMsg   db "The balance needed to be return: RM $"
  
  dateBookLoan label byte
  max          db    3
  act          db    ?
  data         db    3 dup ('') 

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
; when used, increments currRow and sets cursor position to the incremented currRow
; if currRow >= 18h (max row of dosbox, screen will be scrolled)
newline proc

  push    ax
  push    bx
  push    cx
  push    dx
  
  ; original behavior (ditched becuz want formatting)
  ; mov     ah, 02h
  ; mov     dl, 0ah     ; carriage return
  ; int     21h
  ; mov     dl, 0dh     ; line feed
  ; int     21h     

  ; increment currRow
  START_NEW_LINE:
  inc     currRow
  cmp     currRow, 18h
  jge     NEED_SCROLL_SCREEN

  setCursP 00h, currRow, currCol
  jmp     END_NEW_LINE

  ; scroll screen up by 4, subtract 5 from currRow, jump back to increment currRow
  NEED_SCROLL_SCREEN:
    ; screen clearing with color
    ; pls prepare ,i want to scroll screen up (06h), scroll 4 lines (04H)
    mov ax, 0604h
    mov bh, 00011110b
    sub currRow, 5
    mov cx, 0000h
    mov dx, 184fh
    int 10h

    jmp START_NEW_LINE

  END_NEW_LINE:
    
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    ret
    
newline endp

; when used, scroll by one screen
clear proc
  ; store register data to stack so when end proc the register will have original value
  push    ax
  push    bx
  push    cx
  push    dx
  
  ; screen clearing with color
  ; pls prepare ,i want to scroll screen up (06h),scroll entire page (00H)
  mov ax, 0600h
  mov bh, 00011110b
  mov cx, 0000h
  mov dx, 184fh
  int 10h

  ; restore register original data
  pop     dx
  pop     cx
  pop     bx
  pop     ax
  ret
clear endp

; waits for user to input a key before continuing
pause proc

  printStr anyKeyContMsg
  mov ah, 07h
  int 21h
  ret

pause endp

; function for login
login proc
  call        clear
  mov         currRow, 07h
  mov         currCol, 0ah
  setCursP    00h, currRow, currCol
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

printHeader proc 
  mov ax,0600h		;pls prepare ,i want to scroll screen up (06h),scroll entire page (00H)
	mov bh,00011110b			;set bliking effect , bg-red,fg -yellow (1 100 1110)
	mov cx,0000h		;window size starts from here 
	mov dx,184fh		;windows size ends here   
  int 10h			;carry out the operation
	;the following section show cursor position
	mov ah,02h			;pls prepare i want to set cursor position
	mov bh,00h			;set cursur in current video page
	mov dh,05			;set cursor at row 12
	mov dl,20		;set cursor at column 39
	int 10h			;carry out operation
  mov ah,02h			;pls prepare i want to set cursor position
  mov bh,00h			;set cursur in current video page
  mov dh,00			;set cursor at row 12
  mov dl,17		;set cursor at column 36
  int 10h			;carry out operation
  mov ax,0600h
  mov bh,00011110b
  mov ch,00
  mov cl,00           ;window size starts from here 
  mov dh,04
  mov dl,79	;windows size ends here
  int 10h	
  printStr        Printimg1
  call            newline
  mov ah,02h			;pls prepare i want to set cursor position
  mov bh,00h			;set cursur in current video page
  mov dh,01			;set cursor at row 12
  mov dl,17		;set cursor at column 36
  int 10h			;carry out operation
  printStr       Printimg2
  call            newline
  mov ah,02h			;pls prepare i want to set cursor position
  mov bh,00h			;set cursur in current video page
  mov dh,02			;set cursor at row 12
  mov dl,17		;set cursor at column 36
  int 10h			;carry out operation
  printStr        Printimg3
  call            newline
  mov ah,02h			;pls prepare i want to set cursor position
  mov bh,00h			;set cursur in current video page
  mov dh,03			;set cursor at row 12
  mov dl,17		;set cursor at column 36
  int 10h			;carry out operation
  printStr        Printimg4
  call            newline
  mov ah,02h			;pls prepare i want to set cursor position
  mov bh,00h			;set cursur in current video page
  mov dh,04			;set cursor at row 12
  mov dl,17 	;set cursor at column 36
  int 10h			;carry out operation
  printStr        Printimg5
  call            newline
  mov ah,02h			;pls prepare i want to set cursor position
  mov bh,00h			;set cursur in current video page
  mov dh,05			;set cursor at row 12
  mov dl,17		;set cursor at column 36
  int 10h			;carry out operation
  mov ax,0600h
  mov bh,11011110b
  mov ch,05
  mov cl,15           ;window size starts from here 
  mov dh,07
  mov dl,69	;windows size ends here
  int 10h	
  ret
printHeader endp

printMenu proc
  ;call clear
	;the following section sets cursor position
	mov currRow, 05			  ; set cursor at row 5 (dec)
	mov currCol, 20		    ;set cursor at column 20 (dec)
	setCursP 00h, currRow, currCol

  ; cannot call clear as this special section colour
  mov ax,0600h
  mov bh,11011110b
  mov ch,05
  mov cl,15           ;window size starts from here 
  mov dh,07
  mov dl,69	;windows size ends here
  int 10h	

printStr        PrintHeader1
call            newline
printStr        PrintHeader2
call            newline
printStr        PrintHeader3
call            newline

mov ah,02h			;pls prepare i want to set cursor position
mov bh,00h			;set cursur in current video page
mov dh,10		;set cursor at row 12
mov dl,20		;set cursor at column 39
int 10h			;carry out operation
mov ax,0600h
mov bh,00111110b
mov ch,08
mov cl,15           ;window size starts from here 
mov dh,18
mov dl,69	;windows size ends here
int 10h	

mov currRow, 10
setCursP 00h, currRow, currCol
printStr        PrintMenu1
call            newline
printStr        PrintMenu2
call            newline
printStr        PrintMenu3
call            newline
printStr        PrintMenu4
call            newline
printStr        PrintMenu5
call            newline
ret

printMenu endp

;=================== Book Search =============================
bookSearch proc
call clear
;the following section sets cursor position
mov currRow, 05			  ; set cursor at row 5 (dec)
mov currCol, 20		    ;set cursor at column 20 (dec)
setCursP 00h, currRow, currCol

printStr      BookSearchHeader1
call          newline
printStr      BookSearchHeader2
call          newline
printStr      BookSearchHeader3
call          newline
printStr      BookSearchMenu1
call          newline
printStr      BookSearchMenu2
call          newline
printStr      BookSearchMenu3
call          newline
printStr      BookSearchMenu4
call          newline
printStr      BookSearchMsg

mov ah,01h
int 21h
call newline
mov BookSearchUsrInput,al

cmp BookSearchUsrInput,"1"
je s1
cmp BookSearchUsrInput,"2"
je middle
cmp BookSearchUsrInput,"3"
je middle2
cmp BookSearchUsrInput,"4"
jmp quit

s1:
    printStr Shelf1
    call newline
    printStr BookLocationMsg
    mov ah,01h
    int 21h
    call newline
    mov S1input,al
    cmp S1input,"1"
    je BLoc1
    cmp S1input,"2"
    je BLoc2
    cmp S1input,"3"
    je Bloc3
    cmp S1input,"4"
    je Bloc4
    jmp quit
middle:
    jmp s2
middle2:
    jmp s3
BLoc1:
    printStr    BookLocation1
    jmp quit
BLoc2:
    printStr    BookLocation2
    jmp quit
BLoc3:
    printStr    BookLocation3
    jmp quit
BLoc4:
    printStr    BookLocation4
    jmp quit
s2:
    printStr  Shelf2
    call newline
    printStr BookLocationMsg
    mov ah,01h
    int 21h
    call newline
    mov S2input,al
    cmp S2input,"5"
    je BLoc5
    cmp S2input,"6"
    je BLoc6
    jmp quit
BLoc5:
   printStr    BookLocation5
    jmp quit
BLoc6:
   printStr    BookLocation6
    jmp quit
s3:
    printStr  Shelf3
    call newline
    printStr BookLocationMsg
    mov ah,01h
    int 21h
    call newline
    mov S3input,al
    cmp S3input,"7"
    je BLoc7
    cmp S3input,"8"
    je BLoc8
    cmp S3input,"9"
    je BLoc9
    jmp quit
BLoc7:
    printStr   BookLocation7
    jmp quit
BLoc8:
    printStr    BookLocation8
    jmp quit
BLoc9:
    printStr    BookLocation9
    jmp quit
quit:
call newline
call pause
ret
bookSearch endp

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
    call        newline
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
    call        newline
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
    ; wait for the user to see the message, tell them to press any key to continue
    call       pause
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
  call    newline
  jmp     GET_MEMBER_END

  GET_MEMBER_EXISTS:
    mov   hasMember, 1
  
  GET_MEMBER_END:
    ret

getMember endp

printMemberOptions proc

  call        clear
	
	;the following section sets cursor position
	mov         currRow, 05			  ; set cursor at row 5 (dec)
	mov         currCol, 20		    ;set cursor at column 20 (dec)
	setCursP    00h, currRow, currCol

  printStr    memberOpPromptH
  call        newline
  printStr    memberOpPrompt1
  call        newline
  printStr    memberOpPromptH
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

  call    clear
	
	;the following section sets cursor position
	mov     currRow, 05			  ; set cursor at row 5 (dec)
	mov     currCol, 15		    ;set cursor at column 20 (dec)
  setCursP 00h, currRow, currCol

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
    call  newline
    ret

getBook endp

; writes to lnList.txt
; assumes lnList.txt already exists on the machine
memLoanBook proc

  call    clear
	
	;the following section sets cursor position
	mov     currRow, 05			  ; set cursor at row 5 (dec)
	mov     currCol, 15		    ;set cursor at column 20 (dec)
  setCursP 00h, currRow, currCol

  ; example msg will be [DD/MM/YYYY] XXXXXX loan <20 dup('y')>
  ; where XXXXXX is member ID, 20 dup('y') is book name
  ; open loanBookFileN in write mode, set handle to loanBookFileH
  openFile    loanBookFileN, 1, loanBookFileH
  mov     bx, loanBookFileH
  call    moveFileCursEnd
  
  call    writeSysDate
  mov     bx, loanBookFileH
  call    writeMemId
  writeFile   loanBookFileH, 10, loanLabelTxt
  call    getBook
  printStr    loanSuccMsg
  call    newline

  ; rmb to close file ;))
  mov     bx, loanBookFileH
  call    closeFile
  ret

memLoanBook endp

;=============== Calculaiton for the price needed to paid ============
returnCal proc far
START_CAL_LOAN:
  printStr loanDateMsg

  mov ah, 0ah           ;let user to enter the amount of date of loan book
  lea dx, dateBookLoan
  int 21h
  
  mov bl, act           ;end the input
  mov data[bx], '$'
  
  mov cx, 2
  mov si, 0
  CHECK_VALID:
    cmp  data[si], 30H
    jl   INVALID_INPUT
    cmp  data[si], 39H
    jg   INVALID_INPUT
    inc  si
    loop CHECK_VALID
    jmp  VALID_INPUT
  
  INVALID_INPUT:
    call     newline
    printStr invalidInput
    call     newline
    jmp      START_CAL_LOAN

  ;convert input to a integer
  VALID_INPUT:
    mov al, 0
    mov al, data[0]     ;move 1st digit into al then minus 30
    sub al, 30H
    mul ten
    mov bl, 0
    mov bl, data[1]     ;move 2nd digit into bl
    sub bl, 30H
    add al, bl
    ;if else statement
    cmp al, 40
    jg OVER_LIMIT
    cmp al, 21
    jg CAL_LOAN_OVER
    jle CAL_LOAN_LESS_MIDDLE

    OVER_LIMIT:
      call newline
      mov ans, 180
      printStr loanAmountMsg
      printStr chargeOverDate
      jmp CHECK_MEMBER
    
    CAL_LOAN_LESS_MIDDLE:
      jmp CAL_LOAN_LESS

    CAL_LOAN_OVER:        ;function for date more than 21
      mul chargeMinDate   ;the book loan date will mul 2 bcuz 1 day charge RM3
      div hundred         ;quotient in al, remain in ah
      mov quotient, al 
      add quotient, 30H   ;add 30H to ready to print out the ans
      mov ans, al         ;protect the first digit
      mov remain, ah      ;protect the remainder
      mov ah, 0
      mov al, 0
      mov al, ans 
      mul hundred         ;multiply the first digit with hundred to get it original value
      mov ans, al         ;move the first digit value into ans
      call newline
      printStr loanAmountMsg
      printChar quotient
      mov ax, 0
      mov ah, 0
      mov al, remain  
      div ten             
      mov quotient, al    ;protect the second digit
      mov remain, ah      ;protect the last digit  
      mov ah, 0
      mov al, 0
      mov al, quotient    ;move the second digit back to al register to multiply
      mul ten             ;multiply the second digit with ten to get it original value
      ;mov temp, al       ;protect the ans
      add ans, al         ;add the first digit and second digit
      add quotient, 30H   ;add 30H to ready to print out the ans
      printChar quotient  
      mov al, remain
      add ans, al         ;add the last digit with the ans
      add remain, 30H     ;add 30H to ready to print out the ans
      printChar remain
      jmp CHECK_MEMBER
    
    CAL_LOAN_LESS:        ;function for date less than 21
      mul chargeMinDate   ;the book loan date will mul 2 bcuz 1 day charge RM3
      div hundred         ;quotient in al, remain in ah
      mov quotient, al 
      add quotient, 30H   ;add 30H to ready to print out the ans
      mov ans, al         ;protect the first digit
      mov remain, ah      ;protect the remainder
      mov ah, 0
      mov al, 0
      mov al, ans 
      mul hundred         ;multiply the first digit with hundred to get it original value
      mov ans, al         ;move the first digit value into ans
      call newline
      printStr loanAmountMsg
      printChar quotient
      mov ax, 0
      mov ah, 0
      mov al, remain  
      div ten             
      mov quotient, al    ;protect the second digit
      mov remain, ah      ;protect the last digit  
      mov ah, 0
      mov al, 0
      mov al, quotient    ;move the second digit back to al register to multiply
      mul ten             ;multiply the second digit with ten to get it original value
      add ans, al       ;add the first digit and second digit
      add quotient, 30H   ;add 30H to ready to print out the ans
      printChar quotient  
      mov al, remain
      add ans, al         ;add the last digit with the ans
      add remain, 30H     ;add 30H to ready to print out the ans
      printChar remain
      jmp CHECK_MEMBER
  
  ;check member for discount
  CHECK_MEMBER:
    call newline
    mov ah, 0
    mov al, 0
    printStr memberMsg
    mov ah, 01h
    int 21h
    jmp CHECK_VALID_CHOICE

    CHECK_VALID_CHOICE:
      cmp al, 'Y'  ;check is the input is 'Y'(59H)
      je ROYAL_MEMBER
      cmp al, 'N'  ;check is the input is 'N'(4eH)
      je NOT_ROYAL_MEMBER_MIDDLE
      jne INVALID_INPUT_CHOICE

    INVALID_INPUT_CHOICE:
      call newline
      printStr invalidChoice
      jmp CHECK_MEMBER
    
    NOT_ROYAL_MEMBER_MIDDLE:
      jmp NOT_ROYAL_MEMBER

    ROYAL_MEMBER:
      call newline
      printStr discountMsg
      mov ah, 0         ;clear ax
      mov al, 0
      mov al, ans       ;move original price into al
      mul discount      ;*80
      div hundred       ;/100, to get the price after discount
      mov wholeNum, al  ;move whole number to a variable to use for changes
      mov decimalNum, ah;move decimal to a variable to use for changes
      mov quotient, al  ;store the whole number
      mov remain, ah    ;store the decimal point
      mov ah, 0         ;clear ax
      mov al, 0
      mov al, quotient  ;move whole number into al to divide
      div hundred
      mov temp, ah      ;store the remainder for whole number 
      add al, 30H       ;ready to print the first digit of the whole number
      printChar al
      mov ah, 0         ;clear ax
      mov al, 0
      mov al, temp      ;move remainder to register for calculation
      div ten 
      mov quotient, al  ;protect second digit of the whole number
      mov temp, ah      ;protect third digit of the whole number
      add quotient, 30H ;ready to print second digit
      add temp, 30H     ;ready to prit the third digit
      printChar quotient
      printChar temp
      printChar '.'     ;print '.' to seperate decimal and whole number
      mov ah, 0         ;clear ax
      mov al, 0
      mov al, remain    ;move the decimal point into register for cal
      div ten 
      mov quotient, al  ;protect first digit of decimal point
      mov remain, ah    ;protect second digit of decimal point
      add quotient, 30H ;ready to print first digit of decimal point
      printChar quotient
      add remain, 30H   ;ready to print second digit of decimal point
      printChar remain
      jmp TOTAL_PRICE_INPUT

    NOT_ROYAL_MEMBER:
      call newline
      printStr nonRoyalMsg  ;tell user not royal member no discount
      call newline
      printStr discountMsg
      mov ah, 0             ;clear ax
      mov al, 0
      mov al, ans           ;move original price into al
      mov wholeNum, al     ;move the price need to pay into wholeNum
      mov decimalNum, 0     ;since no discount decimal point will remain 0
      div hundred 
      mov quotient, al      ;protect first digit of the price
      mov remain, ah        ;protect second and third digit of the price
      mov ah, 0             ;clear ax
      mov al, 0
      add quotient, 30H     ;ready to print first digit
      printChar quotient
      mov al, remain        ;move second and third digit into register for cal
      div ten 
      mov quotient, al      ;protect second digit of the price
      mov remain, ah        ;protect third digit of the price
      add quotient, 30H     ;ready to print second digit
      printChar quotient    
      add remain, 30H       ;ready to print third digit
      printChar remain
      printChar '.'         ;seperate whole number and decimal point
      printChar '0'         ;since no discount will not have decimal point so can direct print '0''0'
      printChar '0'
      jmp TOTAL_PRICE_INPUT

  ;ready to input for price paid
  TOTAL_PRICE_INPUT:
    call newline
    printStr loanPayMsg

    INPUT_wNUMBER:          ;input for whole number
      mov ah, 01h           ;ready to input char
      int 21h
        cmp al, 30H
        jl INVALID
        cmp al, 39H
        jg INVALID
      sub al, 30H           ;turn to int
      mul hundred           ;get the first input as hundred
      mov priceWholeNum, al
      mov ah, 0
      mov al, 0
      mov ah, 01h           ;ready to input char
      int 21h
        cmp al, 30H
        jl INVALID
        cmp al, 39H
        jg INVALID
      sub al, 30H           ;turn to int
      mul ten               ;get the second input as ten
      add priceWholeNum, al ;add the ans with the first input
      mov ah, 01h           ;ready to input char
      int 21h
        cmp al, 30H
        jl INVALID
        cmp al, 39H
        jg INVALID
      sub al, 30H           ;turn to int
      add priceWholeNum, al ;add the ans with the last input
      printChar '.'
    
    INPUT_dnumber:            ;input for decimal number
      mov ah, 01h
      int 21h
        cmp al, 30H
        jl INVALID
        cmp al, 39H
        jg INVALID
      sub al, 30H             ;turn to decimal
      mul ten                 ;get it as first digit
      mov priceDecimalNum, al
      mov ah, 0
      mov al, 0
      mov ah, 01h
      int 21h
        cmp al, 30H
        jl INVALID
        cmp al, 39H
        jg INVALID
      sub al, 30H             ;turn to decimal
      add priceDecimalNum, al ;add up with the second digit
      jmp VALID_CHECK

    INVALID:
      call     newline
      printStr invalidInput
      call     newline
      jmp      TOTAL_PRICE_INPUT

    VALID_CHECK:
      mov ah, 0               ;clear ax
      mov al, 0
      mov al, priceWholeNum 
      cmp al, wholeNum 
      jl INVALID_PRICE 
      jg PRINT_PRICE  
      mov ah, 0               ;clear ax
      mov al, 0
      mov al, priceDecimalNum
      cmp al, decimalNum
      jl INVALID_PRICE
      jmp PRINT_PRICE 

    INVALID_PRICE:
      call newline
      printStr priceNOtEnough
      jmp TOTAL_PRICE_INPUT

    ;ready to print the changes
    PRINT_PRICE:
      call newline
      printStr loanReturnMsg
      mov ah, 0               ;clear ax
      mov al, 0
      mov al, decimalNum      ;move price need to pay by the user to al for comparison
      cmp priceDecimalNum, al ;compare the decimal point to check wether need to lend from whole number
      jge NORMAL_SUBTRACT      
      jl OVER_SUBTRACT_MIDDLE

      OVER_SUBTRACT_MIDDLE:
        jmp OVER_SUBTRACT

      NORMAL_SUBTRACT:
        mov ah, 0               ;clear ax
        mov al, 0
        mov al, priceDecimalNum ;move decimal point(sen) paid by user into register to subtract
        sub al, decimalNum      ;subtract with the price needed to pay
        mov decimalChange, al   ;protect the answer
        mov ah, 0               ;claer ax
        mov al, 0 
        mov al, priceWholeNum   ;move whole number paid by the user into register to subtract
        sub al, wholeNum        ;subtract with the price needed to pay
        mov wholeChange, al     ;protect the answer
        mov ah, 0               ;clear ax
        mov al, 0
        mov al, wholeChange
        div hundred             ;seperate the numbers
        mov quotient, al        ;protect the first digit
        mov remain, ah          ;protect the second and third digit
        add quotient, 30H       ;ready to print the first digit
        printChar quotient      
        mov ah, 0               ;clear ax
        mov al, 0
        mov al, remain          ;move second and third digit into register to seperate both digits
        div ten 
        mov quotient, al        ;protect the second digit
        mov remain, ah          ;protect the third digit
        add quotient, 30H       ;ready to print the second digit
        add remain, 30H         ;ready to print the third digit
        printChar quotient
        printChar remain
        printChar '.'           ;print as the seperator for whole number and decimal
        mov ah, 0               ;clear ax
        mov al, 0
        mov al, decimalChange   ;move decimal point(sen) paid by the user into register to subtract
        div ten 
        mov quotient, al        ;protect the first digit
        mov remain, ah          ;protect the second digit
        add quotient, 30H       ;ready to print the first digit
        add remain, 30H         ;ready to print the second digit
        printChar quotient
        printChar remain
        ret
      
      OVER_SUBTRACT:
        mov ah, 0               ;clear ax
        mov al, 0
        add priceDecimalNum, 100
        sub priceWholeNum, 1
        mov al, priceDecimalNum
        sub al, decimalNum 
        mov decimalChange, al
        mov ah, 0               ;clear ax
        mov al, 0
        mov al, priceWholeNum 
        sub al, wholeNum 
        mov wholeChange, al
        mov ah, 0               ;clear ax
        mov al, 0
        mov al, wholeChange
        div hundred             ;seperate the numbers
        mov quotient, al        ;protect the first digit
        mov remain, ah          ;protect the second and third digit
        add quotient, 30H       ;ready to print the first digit
        printChar quotient      
        mov ah, 0               ;clear ax
        mov al, 0
        mov al, remain          ;move second and third digit into register to seperate both digits
        div ten 
        mov quotient, al        ;protect the second digit
        mov remain, ah          ;protect the third digit
        add quotient, 30H       ;ready to print the second digit
        add remain, 30H         ;ready to print the third digit
        printChar quotient
        printChar remain
        printChar '.'           ;print as the seperator for whole number and decimal
        mov ah, 0               ;clear ax
        mov al, 0
        mov al, decimalChange   ;move decimal point(sen) paid by the user into register to subtract
        div ten 
        mov quotient, al        ;protect the first digit
        mov remain, ah          ;protect the second digit
        add quotient, 30H       ;ready to print the first digit
        add remain, 30H         ;ready to print the second digit
        printChar quotient
        printChar remain
        call newline
        ret
returnCal endp 

; writes to lnList.txt
; assumes lnList.txt already exists on the machine
memRetBook proc

  call    clear
	;the following section sets cursor position
	mov     currRow, 05			  ; set cursor at row 5 (dec)
	mov     currCol, 15		    ;set cursor at column 20 (dec)
  setCursP 00h, currRow, currCol

  ; calculate the loan first
  call    returnCal
  call    newline

  ; [DD/MM/YYYY] XXXXXX returns <20 dup('y')>
  ; where XXXXXX is member ID, 20 dup('y') is book name
  ; open loanBookFileN in write mode, set handle to loanBookFileH
  openFile  loanBookFileN, 1, loanBookFileH
  mov     bx, loanBookFileH
  call    moveFileCursEnd
  call    writeSysDate
  mov     bx, loanBookFileH
  call    writeMemId
  writeFile   loanBookFileH, 10, retLabelTxt
  call    getBook
  printStr    retSuccMsg
  call    newline

  ; rmb to close file ;))
  mov     bx, loanBookFileH
  call    closeFile
  ret

memRetBook endp

memberOptions proc

  call    getMember
  MEMBER_OPTIONS:
    cmp     hasMember, 0
    je      MEMBER_NOT_EXIST
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
    je      MEMBER_OPTIONS_END
    jmp     INVALID_MEMBER_OPTION

  MEMBER_NOT_EXIST:
    call  pause           ; pause to let the user see the member not exist message (printed by getMember)
    jmp   MEMBER_OPTIONS_EXIT

  LOAN_BOOK_OPTION:
    call    memLoanBook
    jmp     CONTINUE_CONFIRMATION_MEM_OP

  RETURN_BOOK_OPTION:
    call    memRetBook
    jmp     CONTINUE_CONFIRMATION_MEM_OP

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
    mov   ah, 07h
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

  MEMBER_OPTIONS_EXIT:
    ret

memberOptions endp

bookLoanList proc

  ; open lnList.txt in read mode
  openFile  loanBookFileN, 0, loanBookFileH
  mov     bx, loanBookFileH
  call    printFileC
  call    pause
  
  mov     bx, loanBookFileH
  call    closeFile
  ret

bookLoanList endp

; utility function to clear screen and set cursor position for main proc
; refactored out as it will be used twice
clearForMain proc

  call   clear     ; no worries register values wont be overriden
  mov    currRow, 05h
  mov    currCol, 0dh
  setCursP 00h, currRow, currCol

  ret

clearForMain endp

; prints confirmation message menu for user whether they wanna quit or not
quitConfirmMenu proc

  printStr wantToQuitH
  call    newline
  printStr wantToQuitM
  call    newline
  printStr wantToQuitH
  call    newline
  printStr wantToQuitOp1
  call    newline
  printStr wantToQuitOp2
  call    newline
  ret

quitConfirmMenu endp

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
  ; login first
  call    login

  START_MAIN:
    ; display header and menu for user
    call    printHeader
    call    printMenu

    ; get the choice of main menu from user
    printStr PrintMenuMsg1
    mov     ah, 01h
    int     21h

    call    clearForMain

    cmp     al, "1"
    je      MEMBER_MENU_OPTION
    cmp     al, "2"
    je      CREATE_MEMBER_OPTION
    cmp     al, "3"
    je      SHOW_BOOK_LOAN_OPTION
    cmp     al, "4"
    je      BOOK_SEARCH_OPTION
    cmp     al, "5"
    je      EXIT_CONFIRMATION_MAIN
    jmp     START_MAIN

    ; all jump to EXIT for now
    MEMBER_MENU_OPTION:
      call  memberOptions
      jmp   EXIT_CONFIRMATION_MAIN
    
    CREATE_MEMBER_OPTION:
      call  createMem
      jmp   EXIT_CONFIRMATION_MAIN

    SHOW_BOOK_LOAN_OPTION:
      call  bookLoanList
      jmp   EXIT_CONFIRMATION_MAIN

    BOOK_SEARCH_OPTION:
      call  bookSearch
      jmp   EXIT_CONFIRMATION_MAIN
    ; end of real program
  
  ; ask user whether they wanna exit
  EXIT_CONFIRMATION_MAIN:
    call    clearForMain
    
    call    quitConfirmMenu
    
    mov     ah, 07h
    int     21h

    ; check user input
    cmp     al, "Y"
    je      EXIT
    cmp     al, "y"
    je      EXIT
    jmp     START_MAIN    

  ; if not Y/y just quit
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
