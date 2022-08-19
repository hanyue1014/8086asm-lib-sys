.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
  testStr         db      "LOL This is a test$"
  greetLoginMsg   db      "Welcome, Admin, please enter password: $"
  loginSuccMsg    db      "Login Success!!!$"
  loginFailMsg    db      "Wrong Password, please try again!!!$"
  password        db      "abcd1234$"

;-------------- END of data segment

;-------------- CODES go here -----------------------------
.code

;------- MACRO (utility functions that are reusable) ------

; when used, prints a new line (carriage return and line feed to screen)
newline macro

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

endm newline

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

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
  START:
    printChar 't'
    newline
    printChar 'b'
    newline
    printStr  testStr
    newline
  STARTLOGIN:
    mov         bx, 0
    printStr    greetLoginMsg
    ; get character from user 1 by one, outputting * for every character they entered, directly tell them wrong password if any is unequal
    PASS_CHAR_EQUAL:
      mov     ah, 07h
      int     21h
      printChar   "*"              ; at least user know they typed a char
      cmp     password[bx], "$"    ; if already checked until end of password, then password is correct
      je      LOGINPASS
      cmp     al, password[bx]     ; if havent check until end of password, compare if they are equal
      inc     bx
      je      PASS_CHAR_EQUAL
      jne     PASS_CHAR_NOT_EQ           ; if not equal, directly tell them to reenter password
    PASS_CHAR_NOT_EQ:
      newline
      printStr  loginFailMsg
      newline
      jmp       STARTLOGIN         ; wrong password lol, please login again

  LOGINPASS:
    printStr    loginSuccMsg
    
  ; end of real program
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
