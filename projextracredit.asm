TITLE Extra Credit Project Encrypt and Decrypt a given string

; Extra Credit Project
; Description: Uses indirect addressing to manipulate what is in buffer

; Rewrite the authors encryption program (chapter 6) to it uses indirect addressing 
; for all procedures except main. 


INCLUDE Irvine32.inc
INCLUDE Macros.inc

KEY = 239					; any value between 1-255
BUFMAX = 128					; maximum buffer size

.data
prompt		BYTE "Enter the plain text: 	", 13, 10, 0
encryptStr	BYTE "Cirpher text:      	", 0
decryptStr	BYTE "Decrypted:       		", 0
buffer		BYTE BUFMAX+1 DUP(0)
bufSize		DWORD ?

.code
main PROC
	mov edx, OFFSET prompt			; move to the prompt address
	call WriteString			; write the prompt

	mov ecx, BUFMAX				; saves the maximum character count
	mov edx, OFFSET buffer			; move to the address of buffer
	call ReadString				; read the input to eax

	mov bufSize, eax			; save the length into bufsize
	call CrLf				; adds a new line

	call ChangeStr				; encrypt the buffer

	mov edx, OFFSET encryptStr	
	mov edx, OFFSET buffer			; move to the address of the buffer
	call WriteString			; display what is in the buffer
	call CrLf
	call CrLf

	call ChangeStr				; use ChangeStr to decrypt the buffer

	mov edx, OFFSET decryptStr	
	mov edx, OFFSET buffer			; move to the address of the buffer
	call WriteString			; display what is in the buffer
	call CrLf

	exit
main ENDP

ChangeStr PROC
	mov ecx, bufSize			; move the bufsize into ecx
	mov esi, edx				; move the esi address to point at edx

	LOOPY1:
		xor BYTE PTR [esi],KEY		; translate the byte at esi 
		inc esi				; increment esi
	loop LOOPY1

	ret
ChangeStr ENDP
END main
