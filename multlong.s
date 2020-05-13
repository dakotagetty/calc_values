
#BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I HAVE PERFORMED ALL   #OF THE WORK TO DETERMINE THE ANSWERS FOUND WITHIN THIS FILE MYSELF WITH   #NO ASSISTANCE FROM ANY PERSON OTHER THAN THE INSTRUCTOR OF THIS COURSE   #OR ONE OF OUR UNDERGRADUATE GRADERS. .  I UNDERSTAND THAT TO DO OTHERWISE  #IS A VIOLATION OF OHIO STATE UNIVERSITY’S ACADEMIC INTEGRITY POLICY. 

# Author: Dakota Getty
 
.file "multlong.s"
# Assembler directives to allocate storage for static array
.section .rodata
.data
.globl multlong
	.type multlong, @function
.text 
multlong:
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

   	movq %rsi, %r8			# make a copy of high y	
	
	movq $-1, %r9
	xorq %rdi, %r9			# creates a negative x to loop to
	movq $-1, %r12
	xorq %rsi, %r12			# creates a negative y to loop to

	movq $0, %r13			# set index variable to 0
	movq $0, %r14			# set count variable to 0
Calc_loop_x:
	movq %rdi, %rcx			# creates a copy of x
	
	movq %rcx, %rax			# put x into multiplicand
	pushq %rdx			# save the pointer to values
	imulq %rcx			# x^2
	movq %rax, %rcx			# put result back into %rcx
	popq %rdx			# restore pointer to values

	leaq (%rcx, %rcx, 4), %r15	# 5x^2 into %r15

	movq %r8, %rsi			# set y to high value
	jmp Calc_loop_y
Calc_loop_x_dec:
	decq %rdi			# decrement x
	cmpq %r9, %rdi			# compare x to low x
	jle Calc_exit
	jmp Calc_loop_x
Calc_loop_y:
	movq %rsi, %r10			# create a copy of current y	
	movq %rdi, 8(%rdx, %r14)	# put %rdi (x) into second 8 bytes of values
	movq %rsi, 16(%rdx, %r14)	# put %rsi (y) into final 8 bytes of values

	movq %r10, %rax			# put y into multiplicand
	pushq %rdx
	imulq %r10			# y^2
	movq %rax, %r10			# put result into %r10
	popq %rdx

	movq %r10, %rax			# put y^2 intto multiplicand
	pushq %rdx	
	imulq %rcx			# x^2 y^2
	movq %rax, %r11			# put result into %r11
	popq %rdx

	leaq (%r10, %r10, 8), %r10	# 9y^2 into %r10
	pushq %r12
	leaq (%r11, %r11, 4), %r12	# 5x^2 y^2 into %r12
	shlq $1, %r11			# 2x^2 y^2 into %r11
	addq %r12, %r11			# 7x^2 y^2 into %r11
	popq %r12
	movq $0, %rax			# set rax to 0 to prep for final z result
	addq %r15, %rax			# z = 5x^2
	addq %r11, %rax			# z = 5x^2 + 7x^2 y^2
	addq %r10, %rax			# z = 5x^2 + 7x^2 y^2 + 9y^2
	movq %rax, (%rdx, %r14)	        # put %rax (z) into first 8 bytes of values

	incq %r13			# increment the count
	leaq (%r13, %r13, 2), %r14	# 3 times the count into %r14
	shlq $3, %r14			# shift left 3 times (multiply by 8 to get spot in memory) to get an index of 24*count bytes
	decq %rsi
	cmp %r12, %rsi			# compare y to low y
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
.size multlong, .-multlong
