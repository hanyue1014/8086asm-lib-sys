.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
  PrintHeader1    db     " ==================================$"
  PrintHeader2    db    " |          Library System         | $"
  PrintHeader3    db     " ==================================$"

  PrintMenumsg1   db     "Enter the process you want to carry >> $"
  PrintMenu1      db     "1.Member Menu$"
  PrintMenu2      db     "2.Register Member$"
  PrintMenu3      db     "3.Book Loan List$"
  PrintMenu4      db     "4.Book Search$"
  PrintMenu5      db     "5.Quit Program$"
  
  ;=============== data for book search func =====================
  BookSearchHeader1    db     " ==================================$"
  BookSearchHeader2    db     "|            Book Search          |$"
  BookSearchHeader3    db     " ==================================$"
  BookSearchMenu1     db      "   1 .Computer Science$"
  BookSearchMenu2     db      "   2 .English$"
  BookSearchMenu3     db      "   3 .Mathematics$"
  BookSearchMenu4     db      "   4 .Back$"
  BookSearchMsg       db      "Enter the action you want to perform>>$"
  BookSearchUsrInput    db    ?
  Shelf1              db      " 1. C++, 2. Java,  3. C#,  4. Php$"
  Shelf2              db      " 5. Harry Porter, 6. William Shakespeare$"
  Shelf3              db      " 7.Calculus , 8. statistics, 9. discrete Math$"
  BookLocation1       db      "Shelf 1 row 2$"
  BookLocation2       db      "Shelf 1 row 1$"
  BookLocation3       db      "Shelf 2 row 1$"
  BookLocation4       db      "Shelf 2 row 4$"
  BookLocation5       db      "Shelf 3 row 2$"
  BookLocation6       db      "Shelf 3 row 5$"
  BookLocation7       db      "Shelf 4 row 6$"
  BookLocation8       db      "Shelf 5 row 7$"
  BookLocation9       db      "Shelf 1 row 5$"
  BookLocationMsg     db      "What location of book do you want to find >>$"
  S1input             db      ?
  S2input             db      ?
  S3input             db      ?
  ;=================IC input ===============
  msgIcInput          db       "Please enter your Ic number >>$"
  ICInvalid           db       "You enter an invalid input $"
  ICValid           db       "You enter an valid input$"
  ICInput             db       ?
  userIc               db      ?
  Input_label       label       Byte
  Icmaxlen            db        13
  Icactlen            db        ?
  inputBuffer         db        13 dup("")
  
;-------------- END of data segment

;-------------- CODES go here -----------------------------
.code

;------- MACRO (utility functions that are reusable) ------

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
;------ END MACRO DECLARATIONS ----------------------------

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

printMenu proc


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

mov ax,0600h
mov bh,11011110b
mov ch,05
mov cl,15           ;window size starts from here 
mov dh,07
mov dl,69	;windows size ends here
int 10h	
printStr        PrintHeader1
call            newline
mov ah,02h			;pls prepare i want to set cursor position
mov bh,00h			;set cursur in current video page
mov dh,06			;set cursor at row 12
mov dl,20		;set cursor at column 39
int 10h			;carry out operation

printStr        PrintHeader2
call            newline
mov ah,02h			;pls prepare i want to set cursor position
mov bh,00h			;set cursur in current video page
mov dh,07		;set cursor at row 12
mov dl,20		;set cursor at column 39
int 10h			;carry out operation
	
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
printStr        PrintMenu1
call            newline
mov ah,02h			;pls prepare i want to set cursor position
mov bh,00h			;set cursur in current video page
mov dh,11		;set cursor at row 12
mov dl,20		;set cursor at column 39
int 10h			;carry out operation
printStr        PrintMenu2
call            newline
mov ah,02h			;pls prepare i want to set cursor position
mov bh,00h			;set cursur in current video page
mov dh,12		;set cursor at row 12
mov dl,20		;set cursor at column 39
int 10h			;carry out operation
printStr        PrintMenu3
call            newline
mov ah,02h			;pls prepare i want to set cursor position
mov bh,00h			;set cursur in current video page
mov dh,13		;set cursor at row 12
mov dl,20		;set cursor at column 39
int 10h			;carry out operation
printStr        PrintMenu4
call            newline
mov ah,02h			;pls prepare i want to set cursor position
mov bh,00h			;set cursur in current video page
mov dh,14		;set cursor at row 12
mov dl,20		;set cursor at column 39
int 10h			;carry out operation
printStr        PrintMenu5
call            newline
mov ah,02h			;pls prepare i want to set cursor position
mov bh,00h			;set cursur in current video page
mov dh,16		;set cursor at row 12
mov dl,20		;set cursor at column 39
int 10h			;carry out operation
printStr        PrintMenumsg1
mov ah, 01h
int 21h

ret

printMenu endp

;=================== Book Search =============================
bookSearch proc
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
    ;cmp BookSearchUsrInput,3
    ;jmp shelf3
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
ret
bookSearch endp

;==============Input Ic =====================================

inputIc proc
printStr    msgIcInput
mov ah,0ah
lea dx,Input_label
int 21h
call newline
mov si,0
here:
; check if si is 11 (0 - 11)
cmp si, 12
je  valid
mov al,inputBuffer[si]

cmp al,"0"
jb invalid
cmp al,"9"
ja invalid
jmp increment

increment:
  inc si
  jmp here
;cmp ICInput[si],"0"
;jge valid
;cmp ICInput[si],"9"
;jb valid
;cmp ICInput[si],"48"
;jge digit
;cmp ICInput[si],"48"
;jl special

invalid:
    printStr ICInvalid
    jmp quit
    
valid:
    printStr ICValid
    jmp quit
    
ret
inputIc endp

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
  
  call      inputIc
  ; end of real program
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
