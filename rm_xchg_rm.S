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
	// xchg Reg Mem
	xchg %rdi, (%rsp)
	// i <- i - 1
	dec %rdx
	// if i = 0, goto loop
	jnz loop
	// return 0
	addq $8, %rsp
	xorl %eax, %eax
	ret
	.section 	.note.GNU-stack
