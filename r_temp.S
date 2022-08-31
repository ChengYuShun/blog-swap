	.global main
	.text
main:
	// Num1 <- 1
	movq $1, %rdi
	// Num2 <- 2
	movq $2, %rsi
	// i <- 10,000,000,000
	movq $10000000000, %rdx
loop:
	// temp <- Num1
	movq %rdi, %rcx
	// Num1 <- Num2
	movq %rsi, %rdi
	// Num2 <- temp
	movq %rcx, %rsi
	// i <- i - 1
	dec %rdx
	// if i = 0, goto loop
	jnz loop
	// return 0
	xorl %eax, %eax
	ret
	.section 	.note.GNU-stack
