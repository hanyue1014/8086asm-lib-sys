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

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
  call      printMenu
  ; end of real program
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
