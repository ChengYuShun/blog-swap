	.text
	.global main
main:
	// Reg1 <- 1
	movq $1, %rdi
	// Mem <- 2
	pushq $2
	// i <- 1,000,000,000
	movq $1000000000, %rdx
loop:	
	// Reg2 <- Mem
	movq (%rsp), %rsi
	// Reg1 <- Reg1 ^ Reg 2
	xorq %rsi, %rdi
	// Reg2 <- Reg1 ^ Reg 2
	xorq %rdi, %rsi
	// Reg1 <- Reg1 ^ Reg 2
	xorq %rsi, %rdi
	// Mem <- Reg2
	movq %rsi, (%rsp)
	// i <- i - 1
	dec %rdx
	// if i = 0, goto loop
	jnz loop
	// return 0
	addq $8, %rsp
	xorl %eax, %eax
	ret
	.section 	.note.GNU-stack
