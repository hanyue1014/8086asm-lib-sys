.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
  hundred        db 100
  ten            db 10
  chargeLessDate db 2
  chargeMinDate  db 3
  remain         db ?
  quotient       db ?
  loanDateMsg    db "Please enter the days of the book loan: $"
  invalidInput   db "Invalid Input. Please enter integer.$"
  loanAmountMsg  db "The total amount need to be paid: RM$"
  chargeOverDate db "180$"
  loanPayMsg     db "Enter the price paid by the user:$" 
  loanReturnMsg  db "The balance needed to be return: $"
  
  dateBookLoan label byte
  max          db    3
  act          db    ?
  data         db    3 dup ('')   
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

clear proc

  push    ax
  push    bx
  push    cx
  push    dx
  
  ; screen clearing
  mov     ax, 0600h
  mov     bh, 71h
  mov     cx, 0000h
  mov     dx, 184fh
  int     10h

  pop     dx
  pop     cx
  pop     bx
  pop     ax
  ret
clear endp

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
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
    cmp data[si], 30H
    jl  INVALID_INPUT
    cmp data[si], 39H
    jg  INVALID_INPUT
    inc si
    loop CHECK_VALID
    jmp VALID_INPUT
  
  INVALID_INPUT:
    call newline
    printStr invalidInput
    call newline
    jmp      START_CAL_LOAN


  call newline
  ;printStr data         ;test for input received

  call newline
  
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
    jg overLimit
    cmp al, 21
    jg calLoanOver
    jle calLoanLessMiddle

    
    OverLimit:
      call newline
      printStr loanAmountMsg
      printStr chargeOverDate
      jmp EXIT
    
    calLoanLessMiddle:
      jmp calLoanLess

    calLoanOver:          ;function for date more than 21
      mul chargeMinDate   ;the book loan date will mul 2 bcuz 1 day charge RM3
      div hundred         ;quotient in al, remain in ah
      mov quotient, al  
      add quotient, 30H
      call newline
      printStr loanAmountMsg
      printChar quotient
      mov remain, ah
      mov ax, 0
      mov ah, 0
      mov al, remain  
      div ten             
      mov quotient, al
      add quotient, 30H    
      printChar quotient  
      mov remain, ah
      add remain, 30H
      printChar remain
      jmp EXIT
    
    calLoanLess:           ;function for date less than 21
      mul chargeLessDate   ;the book loan date will mul 2 bcuz 1 day charge RM2
      div hundred          ;quotient in al, remain in ah
      mov quotient, al  
      add quotient, 30H
      call newline
      printStr loanAmountMsg
      printChar quotient
      mov remain, ah
      mov ax, 0
      mov ah, 0
      mov al, remain  
      div ten             
      mov quotient, al
      add quotient, 30H    
      printChar quotient  
      mov remain, ah
      add remain, 30H
      printChar remain
      jmp EXIT
  
  ; end of real program
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
