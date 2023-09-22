; Maia Johnson - 100739773
; Luke Jackson - 100749102
; encrypt.asm

extern printf
extern scanf
extern exit

global main

section .text

encrypt:
    ;rdi = message
    mov rsi, key            ; rsi = key
    mov rdx, duplicateKey   ; rdx = duplicateKey, empty
    mov r8, 0               ; key counter = 0
    mov r9, 0               ; word len counter = 0

duplicateLoop:
    mov rcx, 0 
    mov cl, [rsi]           ; cl = key[r8]
    mov [rdx], cl           ; rdx[r9] = cl

    inc rdi
    inc r9
    inc r8
    inc rsi
    inc rdx

    mov bl, [rdi]           ; bl = rdi[r9]
    cmp bl, 0               ; check for null terminator 
    je fixValues            ; jmp if at the end of the message

    mov bl, [rsi]           ; bl = rsi[r8]
    cmp bl, 0               ; check for null terminator
    je resetKey             ; reset key index to 0 if null is found
    jmp duplicateLoop       ; run loop again

resetKey:
    sub rsi, r8
    mov r8, 0
    jmp duplicateLoop

fixValues:
    sub rdi, r9         ; reset the index of rdi and rdx to 0
    sub rdx, r9
    mov rax, cipherText ; so rax returns cipherText

cipherLoop:
    mov cl, [rdx]       ; rdx = duplicateKey
    mov bl, [rdi]       ; rdi = message
    
    add bl, cl          ; add the characters
    sub bl, 65          ; subtract A to get the new letter
    cmp bl, 91          ; check if the ASCII is past Z
    jl makeCipher
    sub bl, 26          ; subtract 26 to get new letter

makeCipher:
    mov [rax], bl       ; move the new letter into cipherText

    inc rax             ; rax index ++
    inc rdi             ; rdi index ++
    inc rdx             ; rdx index ++

    mov cl, [rdi]
    cmp cl, 0           ; check if it's at the end of message
    jne cipherLoop

    sub rax, r9
    ret

main:

    ; printf(messagePrompt)
    mov rdi, messagePrompt
    mov rax, 0
    push rbx
    call printf
    pop rbx

    ; scanf("%s", message)
    mov rdi, inputFormat
    mov rsi, message
    mov rax, 0
    push rbx
    call scanf
    pop rbx

    ; printf(keyPrompt)
    mov rdi, keyPrompt
    mov rax, 0
    push rbx
    call printf
    pop rbx

    ; scanf("%s", key)
    mov rdi, inputFormat
    mov rsi, key
    mov rax, 0
    push rbx
    call scanf
    pop rbx 

    ; encrypt(message)
    mov rdi, message            
    mov rax, 0
    push rbx
    call encrypt
    pop rbx

    ; printf(outputFormat, cipherText)
    mov rdi, outputFormat
    mov rsi, rax
    mov rax, 0
    push rbx
    call printf
    pop rbx

    ; exit(0)
    mov rax, 0
    call exit

section .data

    inputFormat db "%s", 0
    messagePrompt db "Enter a message: ", 0
    keyPrompt db "Enter a key: ", 0
    outputFormat db "Encrypted message: %s", 0ah, 0dh, 0

section .bss

    key resb 51
    message resb 51
    duplicateKey resb 51
    cipherText resb 51