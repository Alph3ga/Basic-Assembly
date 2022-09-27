bits 64
default rel

segment .data
clrstmt db 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0
teststmt db 0x43, 0xa, 0
nextline db 0xa, 0
land db '_', 0
pos db 48 ;the number of _ needed to be printed before <^>
ship db '<^>',0
testst db '%s',0
waitint dq 0.03

segment .bss
storehere resb 15

segment .text
global main
extern ExitProcess
extern printf
extern usleep
extern kbhit
extern getch
extern itoa

clrscr:
	push rbp 
	mov rbp, rsp 
	sub rsp, 32
	
	lea rcx, [clrstmt]
	call printf
	leave 
	ret

show:
	push rbp 
	mov rbp, rsp 
	sub rsp, 32
	
	;call clrscr
	
	lea rcx, [nextline]
	mov bl, 30
	
.lineloop:
	call printf
	lea rcx, [nextline]
	dec bl
	jnz .lineloop
	
	lea rcx, [land]
	mov bl, [pos]
	test bl, bl
	jz .endthis
	
.landloop:
	call printf
	lea rcx, [land]
	dec bl
	jnz .landloop
	
	lea rcx, [ship]
	call printf
	mov bl, 97
	sub bl, byte[pos]
	jz .endthis
	
	lea rcx, [land]
.landloopa:
	call printf
	lea rcx, [land]
	dec bl
	jnz .landloopa

.endthis:
	leave
	ret

wait30:
	push rbp 
	mov rbp, rsp 
	sub rsp, 32
	
	mov rcx, 30000
	
	call usleep
	leave
	ret

managemove:
	push rbp 
	mov rbp, rsp 
	sub rsp, 32
	
	cmp rcx, 0x4b
	je .left
	cmp rcx, 0x4d
	je .right
	cmp rcx, 0x1b
	je quit
	leave
	ret
	
.left:
	dec byte[pos]
	js .right
	leave
	ret
	
.right:
	inc byte[pos]
	mov r9b, 97
	sub r9b, [pos]
	js .left
	leave
	ret

main:
	push rbp 
	mov rbp, rsp 
	sub rsp, 32

.loop:	
	call show
	call kbhit
	cmp rax, 1
	jne .loop
	call getch
	mov rcx, rax
	call managemove
	call wait30
	jmp .loop

quit:
	push rbp 
	mov rbp, rsp 
	sub rsp, 32
	
	xor rax, rax
	call ExitProcess
	