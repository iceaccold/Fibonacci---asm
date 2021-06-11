TITLE Programming Assignment 3 - Fibonacci Sequence (Fibonacci_numbers.asm)
; Program 03
; Description:  Fibonacci sequence using  a loop

; Fibonacci is a sequence of number that sums up the previous two numbers in the
; sequence. The first two numbers are 1, and once they are added up, they equal the
; next number in the sequence. Formula: f(n) = f(n-1) + f(n-2) 
; For example: 1 + 1 = 2, 1 + 2 = 3, 2 + 3 = 5, 3 + 5 = 8, 5 + 8 = 13, and so on.
;                                    
;     sequence: 0 1 1 2 3 5 8 13 21 34 

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data

welcome	BYTE   "----------------------------------------------------		", 13, 10,
	           " Project 3: Fibonacci sequence using a loop			", 13, 10,
	           " Author: 							", 13, 10,
	           " Calculating the Fibonacci Numbers up to number asked.	", 13, 10,
	           "----------------------------------------------------		",0

prompt BYTE "Enter a positive number greater then 2 to find the fibonacci value ", 13, 10, 0
num0 BYTE 0	; first  variable, used in calculations (n-2)
num1 BYTE 1	; second variable 
num2 BYTE ?


.code
	main PROC					; start of the MAIN prodecure 
		mov edx, OFFSET welcome			; move the address of greeting into edx register      
		call WriteString			; write out the greeting 
		call CrLf				; write out a newline (carriage-return Form-feed) 

		mov edx, OFFSET prompt			; move to the address of prompt to edx
		call WriteString			; write out the prompt
		call ReadDec				; user value is put into eax
		call CrLf				; write out a newline (carriage-return Form-feed) 

		mov ecx, eax				; mov value to loop counter

		dec ecx					; subtract 1 because we are starting with 0 and printing 0
		mov al, num0				; stores the first number in num0
		call WriteDec				; display first number 0
		mWriteSpace				; writes a space infront of the first value

		dec ecx					; subtract 1 because we are directly printing second number
		mov al, num1				; moves the second number into al
		call WriteDec				; displays the second number 1
		mWriteSpace				; writes a space infront of the second value

	LOOPY:						; start of loop LOOPY
		mov al, num0				; move num0 to al
		add al, num1				; add num1 to al
		mov num2, al				; move the value in al into num2

		mov bl, num1				; move num1 into bl 
		mov num0, bl				; move the value in bl into num0

		mov num1, al				; move the value of al to num1				
		call WriteDec				; write the value as a decimal
		mWriteSpace				; write a space infront of the new value
	loop LOOPY					; go to top_of_loop if and only if (--ecx) == 0
	
	exit						; Exit to the operating system
	main ENDP					; end of MAIN procedure 
END main						; program tell MASM to execute start the MAIN procedure 
