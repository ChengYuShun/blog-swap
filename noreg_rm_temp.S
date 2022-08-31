	.text
	.global main
main:
	// Reg <- 1
	movq $1, %rdi
	// Mem <- 2
	pushq $2
	// i <- 1,000,000,000
	movq $1000000000, %rdx
loop:
	// PUSH Reg2
	movq %rcx, -8(%rsp)
	// Reg2 <- Reg
	movq %rdi, %rcx
	// Reg <- Mem
	movq (%rsp), %rdi
	// Mem <- temp
	movq %rcx, (%rsp)
	// POP Reg2
	movq -8(%rsp), %rcx
	// i <- i - 1
	dec %rdx
	// if i = 0, goto loop
	jnz loop
	// return 0
	addq $8, %rsp
	xorl %eax, %eax
	ret
	.section 	.note.GNU-stack
