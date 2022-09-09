.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
  ten           db 10
  ;minLoanDate   db 21
  chargeMinDate db 2
  ans db ?
  remain db ?
  quotient db ?
  loanDateMsg   db "Please enter the days of the book loan: $"
  loanAmountMsg db "The total amount need to be paid: $"
  loanPayMsg    db "Enter the price paid by the user:$" 
  loanReturnMsg db "The balance needed to be return: $"
  
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

;------- main function ------------------------------------
main proc far

  ; initialize data segment
  mov     ax, @data
  mov     ds, ax
  
  ; the real program is actually here
  printStr loanDateMsg

  mov ah, 0ah           ;let user to enter the amount of date of loan book
  lea dx, dateBookLoan
  int 21h
  
  mov bl, act           ;end the input
  mov data[bx], '$'
  
  call newline
  ;printStr data         ;test for input received

  call newline
  
  cmp data, 21 
  ja calLoanOver        ;jmp if the date of book loan is more than 21
  
  calLoanOver:          ;function for date more than 21
    mov al, 0
    mov al, data[0]     ;move 1st digit into al then minus 30
    sub al, 30H
    mul ten
    mov bl, 0
    mov bl, data[1]     ;move 2nd digit into bl
    sub bl, 30H
    add al, bl
    mul chargeMinDate   ;the book loan date will mul 2 bcuz 1 day charge RM2
    ;mov ans, ax         ;store ans in ans
    div ten             ;1st digit store in al 2nd digit store in ah
    mov quotient, al
    mov remain, ah
    add remain, 30H
    mov al, quotient 
    mul ten             ;mul al with 10
    add al, 30H
    add al, remain      ;add remainder into al
    mov ans, al
    printStr ans
  
  ; end of real program
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
