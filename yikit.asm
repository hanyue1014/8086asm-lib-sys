.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
  msg1   db     "LOLLL"

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


printStr        msg1
call            newline

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
