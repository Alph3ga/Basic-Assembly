;first assembly program that im coding by myself
;for factorial

bits 64
default rel

segment .data
pstmt db "the factorial of %d is %d", 0xd, 0xa, 0 

segment .text
global main
extern ExitProcess
extern printf

factorial:
	;calling conventions, setting up the stack
	push rbp 
	mov rbp, rsp 
	sub rsp, 32 
	
	;checking if inp is 0 or 1
	test rcx, rcx
	jz .ifzeroorone
	cmp rcx, 1
	je .ifzeroorone
	
	;setting return value to one, and rbx to 2
	mov rbx, 2
	mov rax, 1

.loop:
	mul rbx ;multiply with rax
	cmp rbx, rcx ;compare value to input value, exit if equal
	je .endloop
	inc rbx
	jmp .loop
	
.endloop:
	leave
	ret
	
.ifzeroorone:
	mov rax, 1
	leave
	ret
	
main:
	
	mov ecx, [rdx]
	;calling conventions, setting up the stack
	push rbp ;pushing the address of the past stack segment base onto the stack
	mov rbp, rsp ;setting the stack base pointer to the stack pointer
	sub rsp, 32 ;leaving 32 bits in the stack as per calling conventions
	
	call factorial
	mov r8, rax
	mov rdx, rcx
	lea rcx, [pstmt]
	call printf
	
	xor rax, rax
	call ExitProcess
	
	
	
	