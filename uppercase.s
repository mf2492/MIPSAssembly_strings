#############################################################################
##         DATA REQUIRED BY TEST CODE -- DO NOT MODIFY
	      
	      .data
hello:	      .asciiz "Hello"
world:	      .asciiz "1World"
abc:	      .asciiz "abc?"
before:	      .asciiz "Before: "
return:	      .asciiz "Return: "
after:	      .asciiz "After: "
newline:      .asciiz "\n"
	      .text
	      .globl main

##############################################################################
##               YOUR CODE HERE

uppercase:                                                                                    
              li $v0, 0
                                                                                              
check:                                                                                         
                          add $t0, $v0, $a0		# $t0 = &str[i]                                   
                          lb $t5, ($t0)			# $t5 = str[i]                                       
                          beq $t5, $0, exit		# $end of string
						  blt $t5, 48, invalid	# if t5<48
						  
						  slti $t1, $t5, 58		#if t5 between 58 and 65
						  slti $t2, $t5, 65 
						  slt $t3 $t1, $t2
						  bne $t3, $zero, invalid 
						  
						  slti $t1, $t5, 91		#if t5 between 91 and 97
						  slti $t2, $t5, 97 
						  slt $t3 $t1, $t2
						  bne $t3, $zero, invalid						  
						  
						  bgt $t5, 'z', invalid	# t5 > z
						  
                          blt $t5, 'a', next	# $t5 < 97?                                       
                          
						  sub $t5, $t5, 32		# convert to Uppercase                                         
                          sb $t5, ($t0)			# store back
						  
next:                                                                                         
                          addi $v0, $v0, 1		# i++                                              
                          j check

backwards:                                                                                         
                          addi $v0, $v0, -1		# i--                                              
                          j invalid

invalid: 
		      add $t0, $v0, $a0					# $t0 = &str[i]
			  lb $t5, ($t0)						# $t5 = str[i]  
			  add $t5, $t5, 32					#convert back to lowercase
			  sb $t5, ($t0)						# store back
			  bne $v0, $0, backwards
			  add $v0, $0, 1
			  jr $ra
						                                                         
exit:         add $v0, $0, 0                                     
			  jr $ra                                                                          
                         

##########################################################################
##            TEST CODE -- DO NOT MODIFY BELOW THIS LINE                      

print_string: 
	      li    $v0, 4
	      syscall
	      jr    $ra

print_int:    li    $v0, 1
	      syscall
	      jr    $ra

test_uppercase:
	      addi $sp, $sp, -12   # save preserved state
	      sw    $s0, 0($sp)
	      sw    $s1, 4($sp)
	      sw    $ra, 8($sp)

	      move  $s0, $a0      # save pointer to string, bc. about to make calls
	      la    $a0, before
	      jal   print_string  # print "Before: "
	      move  $a0, $s0
	      jal   print_string  # print "<string>"
	      la    $a0, newline
	      jal   print_string  # print "\n"

	      move  $a0, $s0
	      jal   uppercase     # call uppercase function
	      move  $s1, $v0      # save result to $s1
	      
	      la    $a0, return
	      jal   print_string  # print "Return: "
	      move  $a0, $s1
	      jal   print_int     # print "<return val>"
	      la    $a0, newline
	      jal   print_string  # print "\n"

	      la    $a0, after
	      jal   print_string  # print "After: "
	      move  $a0, $s0
	      jal   print_string  # print "<string>"
	      la    $a0, newline
	      jal   print_string  # print "\n"
      
	      lw    $s0, 0($sp)	  # restore state
	      lw    $s1, 4($sp)	
	      lw    $ra, 8($sp)
	      addi  $sp, $sp, 12
	      jr    $ra           # return
	      
main:
	      la    $a0, hello
	      jal   test_uppercase
 	      la    $a0, world
 	      jal   test_uppercase
 	      la    $a0, abc
 	      jal   test_uppercase

	      li    $v0, 10              # exit
	      syscall

	
