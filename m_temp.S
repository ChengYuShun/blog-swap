	.text
	.global main
main:
	// Mem1 <- 1
	pushq $1
	// Mem2 <- 2
	pushq $2
	// Reg1 <- Mem1
	movq -8(%rsp), %rdi
	// Reg2 <- Mem2
	movq (%rsp), %rsi
	// Mem1 <- Reg2
	movq %rsi, -8(%rsp)
	// Mem2 <- Reg1
	movq %rdi, (%rsp)
	// return 0
	addq $16, %rsp
	xorl %eax, %eax
	ret
	.section 	.note.GNU-stack
