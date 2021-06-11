TITLE Programming Project 4

; Program 04
; Description: A program that takes a string from user and copies it  

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data

welcome	BYTE	"--------------------------------------------------	", 13, 10,
		" Project 04: Copy Strings				", 13, 10,
		" Copy a string from user and copies it			", 13, 10,
		"--------------------------------------------------	",0
	grabString Byte "Please enter a String", 0
	buffsize = 128					; sybolic constant
	source BYTE buffsize DUP(0), 0			; 128 null and one more
	target BYTE LENGTHOF source DUP(0)		; LENGTHOF is a directive,
							; returns number of elements

.code
  main PROC						; start of the MAIN prodecure 	
	mov edx, OFFSET welcome				; move the address of greeting into edx register
	call WriteString				; write out the greeting 
    call CrLf						; write out a newline (carriage-return Form-feed) 

	mov edx, OFFSET grabString			; asks for the input string from user
	call WriteString				; write grabString
    call CrLf						; write out a newline (carriage-return Form-feed) 

	mov edx, OFFSET source
	mov ecx, buffsize				; buffer size - 1
	call ReadString

	mov esi, 0					; indext register - start it at zero

	L1:
	 mov al, [source + esi]				; get char from the source
	 mov [target + esi], al				; store it in the target
	 inc esi					; move to next character
	loop L1						; repeat while ecs is not zero 

	mov edx, OFFSET target			
	call WriteString				; writes what is in target
	call CrLf

	exit						; exit the operation system
 main ENDP						; end of MAIN procedure 
END main						; program tell MASM to execute start the MAIN procedure 
