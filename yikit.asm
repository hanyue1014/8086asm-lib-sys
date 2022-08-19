.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
  PrintMenumsg1   db     "Enter the process you want to carry >> $"
  PrintMenu1      db     "1.Member Menu$"
  PrintMenu2      db     "2.Register Member$"
  PrintMenu3      db     "3.Book Loan List$"
  PrintMenu4      db     "4.Book Search$"

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


printStr        PrintMenu1
call            newline
printStr        PrintMenu2
call            newline
printStr        PrintMenu3
call            newline
printStr        PrintMenu4
call            newline
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
