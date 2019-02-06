section .data
	FirstMess db "Input first value:", 0x0a, "Введите первое значение:", 0x0a
	SecondMess db "Input second value:", 0x0a, "Введите второе значение:", 0x0a
	AgainMess db "Do the steps again? Press [Y/N] "
	SignMess db "Select an arithmetic operation:", 0x0a, "Выберете апперацию:", 0x0a
	AnswerMess db "Answer [Ответ] = "
section .bss
	FirstIn resb 11
	SecondIn resb 11
	Sign resb 2
	Answer resb 12
	Again resb 2

section .text
global _start
	_start:

;;; Request a first value ;;;
	mov RAX, 1
	mov RDI, 1
	mov RSI, FirstMess
	mov RDX, 65
	syscall
FirstInput:
	mov RAX, 0
	mov RDI, 0
	mov RSI, FirstIn
	mov RDX, 11
	syscall
	mov rcx, RAX
	dec rcx
FirstToInt:
	mov RBX, 1
	mov RAX, 0
FTI:
	dec RCX
	mov AL, [FirstIn+RCX]
	inc RCX
	sub AL, 48
	mul RBX
	add R13, RAX
	mov RAX, 10
	mul RBX
	mov RBX, RAX
	mov RAX, 0
	loop FTI


;;; Request sign
	mov RAX, 1
	mov RDI, 1
	mov RSI, SignMess
	mov RDX, 69
	syscall
InputSing:
	mov RAX, 0
	mov RDI, 0
	mov RSI, Sign
	mov RDX, 2
	syscall
	mov R10B, [Sign]

;;; Request a second value ;;;
	mov RAX, 1
	mov RDI, 1
	mov RSI, SecondMess
	mov RDX, 66
	syscall
SecondInput:
	mov RAX, 0
	mov RDI, 0
	mov RSI, SecondIn
	mov RDX, 11
	syscall
	mov rcx, RAX
	dec rcx
SecondToInt:
	mov RBX, 1
	mov RAX, 0
STI:
	dec RCX
	mov AL, [SecondIn+RCX]
	inc RCX
	sub AL, 48
	mul RBX
	add R12, RAX
	mov RAX, 10
	mul RBX
	mov RBX, RAX
	mov RAX, 0
	loop STI

;;; The block transitions to the actions ;;;
Cmp:
	mov RAX, R10
	cmp RAX, 42
	je Mul
	mov R10, R10
	cmp RAX, 43
	je Add
	mov RAX, R10
	cmp RAX, 45
	je Sub
	mov RAX, R10
	cmp RAX, 47
	je Div

;;; Block of arithmetic operations ;;;
Add:
	add R13, R12
	mov R11, R13
	jmp AnswertToString
Sub:
	sub R13, R12
	mov R11, R13
	jmp AnswertToString
Div:
	mov RDX, 0
	mov RAX, R13
	mov RBX, R12
	div RBX
	mov R11, RAX
	mov R9, RDX
	jmp AnswertToString
Mul:
	mov RAX, R13
	mov RBX, R12
	mul RBX
	mov R11, RAX

AnswertToString:
	mov RBX, 10
	mov RCX, 10
	mov RAX, R11
ATS:
	mov RDX, 0
	div RBX
	add rdx, 48
	mov [Answer+RCX], DL
	loop ATS
	mov RAX, 0x0a
	mov [Answer+11], al

	mov RAX, 1
	mov RDI, 1
	mov RSI, AnswerMess
	mov RDX, 24
	syscall
		
	mov RAX, 1
	mov RDI, 1
	mov RSI, Answer
	mov RDX, 12
	syscall
	
;;; Request a retry operation ;;;
	mov RAX, 1
	mov RDI, 1
	mov RSI, AgainMess
	mov RDX, 32
	syscall
	mov RAX, 0
	mov RDI, 0
	mov RSI, Again
	mov RDX, 2
	syscall
	mov RAX, 0
	mov AL, [Again]
	mov r12, 0
	mov r13, 0
	cmp al, 89	
	je _start
	cmp al, 121
	je _start

	mov RAX, 60
	mov RDI, r13
	syscall
