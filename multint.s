
#BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I HAVE PERFORMED ALL   #OF THE WORK TO DETERMINE THE ANSWERS FOUND WITHIN THIS FILE MYSELF WITH   #NO ASSISTANCE FROM ANY PERSON OTHER THAN THE INSTRUCTOR OF THIS COURSE   #OR ONE OF OUR UNDERGRADUATE GRADERS. .  I UNDERSTAND THAT TO DO OTHERWISE  #IS A VIOLATION OF OHIO STATE UNIVERSITY’S ACADEMIC INTEGRITY POLICY. 

# Author: Dakota Getty
 
.file "multint.s"
# Assembler directives to allocate storage for static array
.section .rodata
.data
.globl multint
	.type multlong, @function
.text 
multint:
    	push %rbp			# save caller's %rbp
    	movq %rsp, %rbp		# copy %rsp to %rbp so our stack frame is ready to use

				# %rdi contains high x value
				# %rsi contains high y value
				# %rdx contains structure values
    				# use %rcx for z variable

	# Calculate z = 5x^2 + 7 x^2 y^2 + 9y^2 over all values -x to x and -y to y
	# between 0 and high values passed

	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
	pushq %r12

   	movl %esi, %r8d			# make a copy of high y	
	
	movl $-1, %r9d
	xorl %edi, %r9d			# creates a negative x to loop to
	movl $-1, %r12d
	xorl %esi, %r12d		# creates a negative y to loop to

	movq $0, %r13			# set index variable to 0
	movq $0, %r14			# set count variable to 0
Calc_loop_x:
	movl %edi, %ecx			# creates a copy of x
	
	movl %ecx, %eax			# put x into multiplicand
	pushq %rdx			# save the pointer to values
	imull %ecx			# x^2
	movl %eax, %ecx			# put result back into %rcx
	popq %rdx			# restore pointer to values

	leaq (%rcx, %rcx, 4), %r15	# 5x^2 into %r15

	movl %r8d, %esi			# set y to high value
	jmp Calc_loop_y
Calc_loop_x_dec:
	decl %edi			# decrement x
	cmpl %r9d, %edi			# compare x to low x
	jle Calc_exit
	jmp Calc_loop_x
Calc_loop_y:
	movl %esi, %r10d		# create a copy of current y	
	movl %edi, 4(%rdx, %r14)	# put %rdi (x) into second 8 bytes of values
	movl %esi, 8(%rdx, %r14)	# put %rsi (y) into final 8 bytes of values

	movl %r10d, %eax		# put y into multiplicand
	pushq %rdx
	imull %r10d			# y^2
	movl %eax, %r10d			# put result into %r10
	popq %rdx

	movl %r10d, %eax		# put y^2 intto multiplicand
	pushq %rdx	
	imull %ecx			# x^2 y^2
	movl %eax, %r11d		# put result into %r11
	popq %rdx

	leaq (%r10, %r10, 8), %r10	# 9y^2 into %r10
	pushq %r12
	leaq (%r11, %r11, 4), %r12	# 5x^2 y^2 into %r12
	shll $1, %r11d			# 2x^2 y^2 into %r11
	addl %r12d, %r11d		# 7x^2 y^2 into %r11
	popq %r12
	movq $0, %rax			# set rax to 0 to prep for final z result
	addl %r15d, %eax			# z = 5x^2
	addl %r11d, %eax			# z = 5x^2 + 7x^2 y^2
	addl %r10d, %eax			# z = 5x^2 + 7x^2 y^2 + 9y^2
	movl %eax, (%rdx, %r14)	        # put %rax (z) into first 8 bytes of values

	incl %r13d			# increment the count
	leaq (%r13, %r13, 2), %r14	# 3 times the count into %r14
	shll $2, %r14d			# shift left 2 times (multiply by 4 to get spot in memory) to get an index of 12*count bytes
	decl %esi
	cmpl %r12d, %esi		# compare y to low y
	jle Calc_loop_x_dec
	jmp Calc_loop_y
Calc_exit:
	
	pushq %r12
	pushq %r11
	pushq %r10
	pushq %r9
	pushq %r8

    	leave
    	ret
.size multint, .-multint
