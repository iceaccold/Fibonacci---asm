TITLE Project 9 Pack time

; Project 9
; Description: take user given time and packet up into a 16 bit string  

; Pack the date into a string of bits and display them. 
; Afterwards unpack them starting from day to month to year and display everytime you take something out

INCLUDE Irvine32.inc

.data
	welcome	BYTE	"--------------------------------------------------					", 13, 10,
			" Project 9: Pack time									", 13, 10,
			" Take the date and display it in a string of bits					", 13, 10,
			"--------------------------------------------------					",0
	prompt BYTE "This program will take user input to get the date and pack it into a 16 bit string		", 13, 10, 0
	getDay BYTE "What day is it, between 1-31: ", 0
	getMonth BYTE "What month is it, between 1-12: ", 0
	getYear BYTE "What year is it, between 1980-2107: ", 0
	showDate Byte "The date in bits is: ", 0
	showDay BYTE "The day is: ", 0
	showMonth BYTE "The month is: ", 0
	showYear BYTE "The year is: ", 0

	day BYTE ?
	month BYTE ?
	year BYTE ?
		
.code
main PROC
	mov edx, OFFSET welcome			; move the address of greeting into the edx register
	call WriteString			; write out the greeting 
	call CrLf				; write out a newline (carriage-return Form-feed)

	mov edx, OFFSET prompt			; move to the prompt address
	call WriteString			; write prompt
    call CrLf					; write out a newline (carriage-return Form-feed) 

	mov edx, OFFSET getDay			; move to the getDay address
	call WriteString			; write getDay
	call ReadDec				; read in a decimal value
	mov day, al				; put in the decimal value into day
    call CrLf					; write out a newline

	mov edx, OFFSET getMonth		; move to the getMonth address
	call WriteString			; write getMonth
	call ReadDec				; read in a decimal value
	mov month, al				; put in the decimal value into month
    call CrLf					; write out a newline

	mov edx, OFFSET getYear			; move to the getYear address
	call WriteString			; write getYear
	call ReadDec				; read in a decimal value
	sub ax, 1980				; subtract 1980 to get the years from 1980
	mov year, al				; put in the decimal value into year
    call CrLf					; write out a newline
	
	movzx ax, day				; move 0's to the left of day which is added to ax
	shl ax, 4				; shift the values in ax to the left 4 bits for month

	add al, month				; move month into al after day

	shl ax, 7				; shift the values to the left 7 bits for year

	add al, year				; move year into al after month

	mov edx, OFFSET showDate		; move to address of showDate
	call WriteString			; write showDate

	mov ebx, 2				; limits how many bits to show to 16
	call WriteBinB				; prints what is in ax as binary
	call CrLf				; write out a newline

	mov cx, ax				; move a copy of cx into ax

	shr ax, 11				; shift right 11 to get the last 5 bits that are for day
	
	mov edx, OFFSET showDay			; move to address of showDay
	call WriteString			; write showDay
	call WriteDec				; write output as decimal
	call CrLf				; write out a newline

	mov ax, cx				; move a copy of ax from cx

	shr ax, 7				; shift right 7 bits to the 4 bits that are for month
	and ax, 00001111b			; uses the and operation to compare 4 bits for the month 
	
	mov edx, OFFSET showMonth		; move to address of showMonth
	call WriteString			; write showMonth
	call WriteDec				; write output as decimal
	call CrLf				; write out a newline
	
	mov ax, cx				; move a copy of cx into ax
	
	and ax, 01111111b			; uses the and operation to compare the 7 bits for the year

	mov edx, OFFSET showYear		; move to address of showYear
	call WriteString			; write showYear
	add ax, 1980				; add 1980 back to year
	call WriteDec				; write output as decimal
	call CrLf				; write out a newline

    exit					; Exit to the operating system
main ENDP					; end of MAIN procedure 
END main					; program tell MASM to end the MAIN procedure 
