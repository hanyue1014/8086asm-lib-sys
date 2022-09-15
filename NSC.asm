.model small
.stack 64

;-------------- VARIABLE DECLARATIONS ---------------------
.data
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

  call newline

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
          ret
returnCal endp    
  ; end of real program
  
  call returnCal
  jmp EXIT
  
  ; tell os to end program
  EXIT:
    mov     ax, 4c00h
    int     21h

main endp
end main
;-------- END OF WHOLE PROGRAM ----------------------------
