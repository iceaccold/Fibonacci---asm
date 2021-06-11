TITLE Project 8 Add functionality to program 7

; Project 8
; Description: Allow program 7 to handle spaces in the String taken by the user

; Does a comparison to evaluate a - z and A - Z and uses the result to jump to 
; Either skips or goes to the toggle function to be able to handle spaces in the string
; The XOR is used to switch the bit at the fifth position from 1 to 0  or 0 to 1
; The difference of an uppercase letter in binary is 20 so that puts it at the 5th bit postion

INCLUDE Irvine32.inc

.data
	msg BYTE "Please enter a string of mixed case characters, no longer then 128 bytes", 13, 10, 0
	bufferSize = 128
	string BYTE bufferSize DUP(0), 0		; 128 null and one more
	stringSize = ($ - string)			; number of bytes in string
		
.code
toggle PROC USES eax ecx edx
	LOOPY: 
		mov al, [edx]				; move to al character at edx position in the string 

		cmp al, 'A'				; compare al to 'A'
		jb skip_toggle				; if al is less then 'A' jump to skip toggle

		cmp al, 'z'				; compare al to 'z'
		ja skip_toggle				; if al is greater then 'z' jump to skip toggle

		cmp al, 'a'				; compare al to 'a'
		jae do_Toggle				; if al is greater than or equal to 'a' jump to toggle

		cmp al, 'Z'				; compare al to 'Z'
		jbe do_Toggle				; if al is less than or equal to 'Z' jump to toggle

		do_Toggle:				; destination to do xor
		XOR al, 00100000b			; compare to letter to change 5th bit

		skip_Toggle:				; destination to skip xor
		mov [edx], al				; puts the changed character back to the position at edx

		inc edx					; increments edx by 1
	loop LOOPY					; end of loopy

	ret						; return to position from called
toggle ENDP						; end of toggle PROC

main PROC

	mov edx, OFFSET msg				; asks for the input string from user
	call WriteString				; write msg
    call CrLf						; write out a newline (carriage-return Form-feed) 

	mov edx, OFFSET string				; takes the address of string
	mov ecx, stringSize				; buffer size - 1
	call ReadString					; reads in the string and stores it in string

	mov ecx, eax					; sets ecx to how many characters were put into string
	
	call toggle					; call toggle to switch the case of the letter

	call WriteString				; writes what is in string
	call CrLf					; write out a newline (carriage-return Form-feed) 

    exit						; Exit to the operating system
main ENDP						; end of MAIN procedure 
END main						; program tell MASM to end the MAIN procedure 
