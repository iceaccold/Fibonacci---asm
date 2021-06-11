TITLE Project 7 Change characters of a string from upper case to lower case or vise versa

; Project 7
; Description: Flips the 5th bit of element of an array of BYTES

; Uses toggle proceedure to switch the bit at the fifth position from 1 to 0  or 0 to 1
; The difference of an uppercase letter in binary is 20 so that puts it at the 5th bit postion

INCLUDE Irvine32.inc

.data
	msg BYTE "Please enter a string of mixed case characters, no longer then 128 bytes	", 13, 10, 0
	bufferSize = 128
	string BYTE bufferSize DUP(0), 0	; 128 null and one more
	stringSize = ($ - string)		; number of bytes in string
		
.code
toggle PROC USES eax ecx edx
	LOOPY: 
		mov al, [edx]			; move to al character at edx position in the string 
		XOR al, 00100000b		; compare to letter to change 5th bit
		mov [edx], al			; puts the changed character back to the position at edx
		inc edx				; increments edx by 1
	loop LOOPY				; end of loopy

	ret					; return to position from called
toggle ENDP					; end of toggle PROC

main PROC

	mov edx, OFFSET msg			; asks for the input string from user
	call WriteString			; write msg
    call CrLf					; write out a newline (carriage-return Form-feed) 

	mov edx, OFFSET string			; takes the address of string
	mov ecx, stringSize			; buffer size - 1
	call ReadString				; reads in the string and stores it in string

	mov ecx, eax				; sets ecx to how many characters were put into string
	
	call toggle				; call toggle to switch the case of the letter

	call WriteString			; writes what is in string
	call CrLf				; write out a newline (carriage-return Form-feed) 

    exit					; Exit to the operating system
main ENDP					; end of MAIN procedure 
END main					; program tell MASM to end the MAIN procedure 
