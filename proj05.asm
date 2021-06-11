TITLE Program to make shapes with ascii character

; Author: 
; CSC 221 / Program 05
; Description: Program to make shapes with ascii character
; DUE DATE:  03/19/2021

; Make two shapes with the *, and use the length of the rectangle to make the right triangle
; ***       *
; ***       **
; ***       ***

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data

welcome	BYTE   "--------------------------------------------------", 13, 10,
			   " CSC 221 Project 05: Print an asterisk to build a rectangle and a right triangle                  ", 13, 10,
			   " Author: Adam Chavez                                  ", 13, 10,
			   " Get user input to build a rectangle and a triangle     ", 13, 10,
			   "--------------------------------------------------",0
explain BYTE "First number is for height, secound is for the width", 13, 10, 0
prompt BYTE "Enter a small integer to build the shape: ", 0

heig DWORD ?
leng DWORD ?
item BYTE "*", 0					; asterisk character to be printed


.code

   main PROC						; start of the MAIN prodecure 
      mov edx, OFFSET welcome		; move the address of greeting into edx register
      call WriteString				; write out the greeting 
      call CrLf						; write out a newline (carriage-return Form-feed) 

	  mov edx, OFFSET explain		; move the address of explain into edx register
      call WriteString				; write out the greeting 
      call CrLf						; write out a newline (carriage-return Form-feed) 

	  ; ask for input for length then height

	  mov edx, OFFSET prompt		; move the address of prompt into edx register
	  call WriteString				; write out the greeting 
	  Call ReadDec					; eax is input

	  mov heig, eax					; stores value for length

	  mov edx, OFFSET prompt
	  call WriteString
	  Call ReadDec					; eax is input

	  mov leng, eax					; stores value for height


	  ; starts drawing the rectangle with given input
	  mov ecx, heig

	  outLoop:						; loop to make rectangle
	  
	  PUSH ecx						; clears ecx with height
	  mov ecx, leng					; makes ecx equal the length for the loop

	  inLoop:
	  movzx eax, item
	  call WriteChar				; writes the item 

	  loop inLoop

	  POP ecx						; takes out the length value on ecx

	  call CrLf

	  loop outLoop

	  ; starts instructions to draw the triangle with width from above

	  call CrLf						; makes a space between the shapes

	  mov ecx, leng					; bring in leng as the width for the right triangle
	  mov ebx, 1					; set the inside loop to one so it counts from there

	  rTriOut:						; start of right triangle outer loop

	  push ecx						; clear ecx 
	  mov ecx, ebx					; brings in ebx to ecx for inner loop
	  
	  rTriIn:						; start of inner loop

	  movzx eax, item				; brings in the item variable to be printed
	  call WriteChar				; prints the item variable as a char
	  
	  loop rTriIn					; end of inner loop

	  inc ebx						; increments ebx 
	  call CrLf						; goes to next line

	  POP ecx						; clears inner value of ecx

	  loop rTriOut					; end of outer loop


      exit							; Exit to the operating system
   main ENDP						; end of MAIN procedure 

END main							; program tell MASM to end the MAIN procedure 
