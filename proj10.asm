TITLE Project 10 ASCII letter frequency analyzer

; Project 10
; Description: Takes name of a file from user and finds the frequency of letters in the file
; some of this program came as is. Mainly the stuff that handles files
;  letter_freq_starter.asm
;
;  Starter file for ASCII letter frequency analyzer start file   
;               asks user for a file name 
;               open files
;               reads file into buffer 
;               show the file 
;               ADD - counts the number of EXTENDED ASCII chars (all 256) 
;               ADD - displays count for each ASCII value  

INCLUDE Irvine32.inc
INCLUDE macros.inc

MAX = 26                                            	; 26 letters A-Z
BUFFER_SIZE = 8192                                  	; Will not be able to read file greater 
.data
   buffer       BYTE    BUFFER_SIZE DUP(?),0        	; buffer for file contents 
   filename     BYTE    80 DUP(0)                   	; buffer for filename 
   fileHandle   HANDLE  ?                           	; access to file (set in open_file proc) 
   bufSize      DWORD   BUFFER_SIZE                 	; size buffer/#char read-set ReadTheFile
   freqs        DWORD   MAX DUP(0)                  	; buffer holds count frequencies of 'A'-'Z' 
   item         BYTE    ".", 0				; period character to be printed

.code
    main PROC
        ; get filename
        mov edx,OFFSET filename
        mov ecx,SIZEOF filename
        call GetFileName                            	; askes and fills in filename buffer

        ; open the file 
        call OpenTheFile                            	; uses filename sets fileHandle
        jc QUIT                                     	; there was an error so quit program 

        ; read the file text into buffer
        mov edx,OFFSET buffer 
        mov ecx,BUFFER_SIZE 
        call ReadTheFile                           	; uses fileHandle; fill buffer
        mov bufSize, eax                            	; save number of chars in buffer - set by ReadTheFile

        call ShowTheFile                            	; displays buffer (WriteString) 
        mov eax, 3000                               	; pause for 3 seconds 
        call Delay    

        mov ecx, bufSize                            	; make sure ecx has the is the size of elements of the file
        mov eax, 0                                  	; make sure eax is zero for any starting position

        ; convert to upper case
        call StartToUpper                           	; call the proceedure to convert contents in file to uppercase

        ; count letters 
        LOOPY1:                                     	; start of loopy1 loop
            mov al, [edx]                           	; take what is in edx into al
            cmp al, 'A'                             	; compare al to A
            jb to_Count                             	; jump if below A to_Count
            cmp al, 'Z'                             	; compare al to Z
            ja to_Count                             	; jump if above Z to_Count
            sub al, 'A'                             	; subtract A from what is in al
            shl al, 2                               	; multiply al by 4
            add [freqs + eax], WORD PTR 1           	; goes to destination of uppercase letter
            to_Count:                               	; to_Count 
               inc edx                              	; keeps count of repeated characters
        loop LOOPY1                                 	; end of loopy1

        ; show count
        mov eax, 65                                 	; put A int eax
        mov esi, 0                                  	; make sure esi is 0
        mov edi, 0                                  	; make sure edi is 0
        mov ecx, max                                	; make sure the range of characters is 26

        LOOPY2:                                     	; start of loopy2 loop
            push eax                                	; push what is in eax to stack
            mov eax, 'A'                            	; put A into eax
            add eax, edi                            	; add what is in edi to eax
            call WriteChar                          	; Write the character at this position
            mwrite" : "                             	; writes a space colon and a space
            pop eax                                 	; pops eax off of the stack
            mov eax, [freqs + esi]                  	; take the count at destination to eax
            call WriteDec                           	; write the decimal value in eax

            push ecx                                	; push the value of ecx
            mov ecx, eax                            	; puts the value of eax into ecx
            call HistoGram                          	; calls the histogram proceedure
            pop ecx                                 	; pops the value of ecx

            call CRLF                               	; write a new line
            add esi, TYPE freqs                 
            inc edi                                 	; increments edi
        loop LOOPY2

        ; close file
        mov eax,fileHandle 
        call CloseFile          
      QUIT:
        exit
    main ENDP
   
   ; Discription: Let user input a filename.
   ; Receives: edx - address of buffer for filename
   ;           ecx - size of filename buffer -1  
   ; Returns : eax - number of characters in filename 
   ;           modifies the filename buffer
   ; Requires: one extra space in filenme buffer for null 
   GetFileName PROC  USES EDX ECX
      mWrite "Enter an input filename: " 
      call ReadString
      ret
   GetFileName ENDP

    ; Discription: Open the file for input. 
    ; Receives: edx - address of buffer with the filename
    ; Returns : set carry flag is failes to open file 
    ; Requires: fileHandle (fileHandle  HANDLE ?) to be declaired (.data) 
    OpenTheFile PROC USES EDX
        call OpenInputFile                          	; irvine proc calls win32 IPA
        mov fileHandle,eax
		
        ; Check for errors.
        cmp   eax,INVALID_HANDLE_VALUE              	; error opening file?
        jne FILE_OK			; no: skip
        mWrite <"Cannot open file: ">               	; error message  
        mov edx, OFFSET filename                    	
        call WriteString                            	; print filename
        stc                                         	; error so set carry flag     
        jmp DONE                                    	; jump over clearing the CF
      FILE_OK:                                      	; file is ok we are done
      	clc                                         	; clear the carry flag
      DONE:
        ret                                   
    OpenTheFile ENDP

    ; Discription: Read the file into a buffer. 
    ; Receives: EDX - address of buffer with the filename
    ; Returns : EAX - number of cahrsread in 
    ;           CF    set carry flag is failes to  read file 
    ; Requires: the files ahs been opened (OpenTheFile) 
    ReadTheFile PROC  USES EDX ESI
        mov esi, edx                                	; save address of buffer
	call ReadFromFile                               ; irvine proc call win32 API
	jnc CHECK_BUFFER_SIZE                           ; if CF NOT we failed to read file 
	mWriteln "Error reading file "                  ; error message
		stc                                   	; error - set cary flag to signal error 
        ret                                         	; could not read the file so exit

	CHECK_BUFFER_SIZE:                              ; was buffer big enough?
	cmp eax,BUFFER_SIZE                             ; 
	jb BUF_SIZE_OK                                  ; yep !!
	mWriteln "Error reading file"                   ; error message
	mWriteln " Buffer too small to read "
        stc                                         	; error - set cary flag to signal error 
        ret                                         	; could not read the file so exit
	
        BUF_SIZE_OK:
        add esi, eax                                	; mov the end of buffer 
	mov [esi], BYTE PTR 0                           ; insert null terminator
	mWrite "File size: " 	                        ; display file size
	call WriteDec
	call Crlf
        clc                                         	; no error so clear CF			
	ret
    ReadTheFile ENDP
	
    ; Discription: Dispalys the contents of a buffer. 
    ; Receives: edx - address of buffer
    ; Returns :  
    ; Requires:  
   ShowTheFile PROC
      ; Display the buffer.
      mWrite <"Buffer:",0dh,0ah,0dh,0ah>
      call WriteString
      call Crlf
      call Crlf
      ret
    ShowTheFile ENDP	

    ; Description:
    ;       if ascii value not 32 to 126 write out as dec 
    ;       if ascii value 32-126 write out as char 
    ; Receives:  EAX (AL) has ascii value
    ; Returns :  
    ; Requires:
    PrintASCII PROC
        or eax,eax
        cmp al, ' '                                 ; SPACE - 1st printable 
        jb NONPRITABLE
        cmp al, 127                                 ; - DEL key  
        je NONPRITABLE
        mwrite <"(">  
        call WriteChar
        mwrite <"): ">
        jmp SKIP  
      NONPRITABLE:
        call WriteDec
        mwrite <": "> 
      SKIP:
        ret
    PrintASCII ENDP

    ; Description:
    ;       prints letter freq as historgram  
    ; Receives:  ESI address of array to print
    ; Returns :  
    ; Requires:
    HistoGram PROC
        cmp ecx, 00                                 	; compares ecx to 0
        jbe skip_Print                              	; jumps to skip_Print if equal or below to 0

        LOOPY3:                                     	; starts LOOPY3 loop
            movzx ax, item                          	; move the item into ax 
            call WriteChar				; writes the item
        loop LOOPY3                                 	; end LOOPY3 loop

        skip_print:                                 	; skip_Print destination
               
        ret                                         	; returns to where called
    HistoGram ENDP

    ;  Description: converts lowercase letters to upper case letters
    ;  Recieves:    EDX  - address of buffer
    ;               ECX  - num of char user gave 
    ;  Returns:     buffer has been changed 
    ;  Requires: 
    StartToUpper PROC USES EDX ECX
        LOOPY: 
		    mov al, [edx]                 	; move to al character at edx position in the string 

		    cmp al, 'A'                      	; compare al to 'A'
		    jb skip_toggle                    	; if al is less then 'A' jump to skip toggle

		    cmp al, 'z'                        	; compare al to 'z'
		    ja skip_toggle                     	; if al is greater then 'z' jump to skip toggle

		    cmp al, 'a'                       	; compare al to 'a'
		    jae do_Toggle                      	; if al is greater than or equal to 'a' jump to toggle

		    cmp al, 'Z'                    	; compare al to 'Z'
		    jbe skip_Toggle                   	; if al is less than or equal to 'Z' jump to toggle

		    do_Toggle:                       	; destination to do xor
		    XOR al, 00100000b               	; compare to letter to change 5th bit

		    skip_Toggle:                    	; destination to skip xor
		    mov [edx], al                    	; puts the changed character back to the position at edx

		    inc edx                         	; increments edx by 1
	    loop LOOPY                                  ; end of loopy
        ret                                         	; return to where called
    StartToUpper ENDP
END main
