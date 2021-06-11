TITLE Programming Assignment 06 - Better random range

; Program 06
; Description:  Calculate a range of random numbers and get the sum and average of those numbers

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
welcome	BYTE   	"--------------------------------------------------			", 13, 10,
	      	" Project: Better Random Range						", 13, 10,
	       	" Take a range of numbers and print 10 random numbers			", 13, 10,
		"--------------------------------------------------			",0

	;prompt BYTE "Using this program we will get the lower and upper bount to print a range of random numbers	", 13, 10, 0
	string1 BYTE "Enter the lower bound: ", 0
	string2 BYTE "Enter the upper bount: ", 0
	sum BYTE "The sum of all the values returned by BetterRandomRange was: ", 0
	ave Byte "the average value returned by BetterRandomRange was: ", 0

	upBVal DWORD ?
	lowBVal DWORD ?
	totSum DWORD ?
	totAve DWORD ?
	divBy DWORD 10

.code
	BetterRandomRange PROC
		sub eax, ebx				; eax (upper bound) - ebx (lower bound)


		call RandomRange			; pass eax to RandomRange
		add eax, ebx				; add returned random number to the lower bound
		
		ret					; return eax

	BetterRandomRange ENDP

	main Proc
		;Randomize				; makes the call RandomRange output different random values 

		mov edx, OFFSET welcome			; move the address of greeting into the edx register
		call WriteString			; write out the greeting 
		call CrLf				; write out a newline (carriage-return Form-feed)

		mov edx, OFFSET string1			; move the address of string1 into the edx register
		call WriteString			; write out string1
		call ReadInt				; reads input as int and stores it in eax
		call CrLf				; write a blank line

		mov lowBVal, eax			; stores the lower bound value in lowBVal

		mov edx, OFFSET string2			; move the address of string2 into edx register
		call WriteString			; write out string2
		call ReadInt				; reads input as int and stores it in eax
		call CrLf				; write a blank line

		mov upBVal, eax				; stores upper bound value in upBVal

		mov ebx, lowBVal			; puts lower bound value in eax
		mov eax, upBVal				; puts upper bound value in ebx

		mov ecx, 10				; manually set loop counter to 10	

		randLoop:
			mov eax, upBVal			; move upBVal to eax
			call WriteInt			; prints the signed int in eax
			mov ebx, lowBVal		; move lowBVal to ebx

			call BetterRandomRange		; call BetterRandomRange proceedure

			call WriteInt			; prints the signed int in eax

			add totSum, eax			; adds eax to totSum variable to store
			call CrLf					; prints a blank line
		loop randLoop				; end of randLoop

		mov edx, OFFSET sum			; move the address of totSum into the edx register
		call WriteString			; write the sum message
		mov eax, totSum				; move the sum of the random numbers into eax
		call WriteInt				; write the total sum of the random numbers
		call CrLf				; print a blank line

		mov eax, totSum				; bring sum to eax
		mov ebx, divBy				; bring divBy to ecx

		cdq
		idiv ebx				; divide by 10 and save the quotient to eax
		mov totave, eax				; save average to totave

		mov edx, OFFSET ave			; move the address of ave into the edx register
		call WriteString			; write the ave message
		mov eax, totAve				; move the average of the random numbers into eax
		call WriteInt				; write the total average of the random numbers
		call CrLf				; print a blank line
		exit					; Exit to the operating system
	main ENDP
END main

