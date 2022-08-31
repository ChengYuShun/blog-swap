	.text
	.global main
main:
	// Num1 <- 1
	movq $1, %rdi
	// Num2 <- 2
	movq $2, %rsi
	// i <- 10,000,000,000
	movq $10000000000, %rdx
loop:	
	// Num2 <- Num1 ^ Num2
	xorq %rdi, %rsi
	// Num1 <- Num1 ^ Num2
	xorq %rsi, %rdi
	// Num2 <- Num1 ^ Num2
	xorq %rdi, %rsi
	// i <- i - 1
	dec %rdx
	// if i = 0, goto loop
	jnz loop
	// return 0
	xorl %eax, %eax
	ret
	.section 	.note.GNU-stack
