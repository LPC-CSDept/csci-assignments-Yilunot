#
#q5.asm
#Tony Liu
#12/17/2021
#
#take the 3 digits through the MM I/O
#
#data section

    .data
digits:.word   100     # (one, ten, hundred) taking the 3 digits
askdigit: .asciiz  "Enter 3 digit: "    #ask user to enter digits
newline: .asciiz "\n"           #tab
result: .asciiz "Result: "      #result 
    .text
    .globl main

main:
    lw  $t2, digits    #load word to $t9, number of digist(3)
    lui $t0, 0xffff      #load upper immediate 

    li $v0,4     			        #   print the askdigit     
    la $a0, askdigit
    syscall 

waitloop:
    lw   $t1, 0($t0)            #load word from the input control register
    andi $t1, $t1, 0x0001       #reset or clear all the bits except LSb
    beq  $t1, $zero, waitloop   #if the bit is not ready yet go back to the waitloop
    lw   $s0, 4($t0)            #input device is ready so read a character from I/O
#temporal holding 
#print everysingle digit from the user
    move $t2, $s0               #move temporal to t2
    add $t2,$t2 ,-48              #take the input asciiz value of the digit and subtract to 48 that is 0 in decimal
    move $a0,$t2                #move to the t2 to $a0 to be print
    li $v0, 1                      #system call to print 
    syscall   



    sub	$s0, $s0, 48		    # s0 = s0(user input)-48
    mul $s0, $s0, $t2           # s0 = s0 * digits
    div $t2, $t2, 10            # t1 = t1/10
    add	$s1, $s1, $s0		    # s1 = s1 + s0 
    bnez $t2, waitloop          # brach on no equal to zero 

    li $v0,4     			    #   print the new line     
    la $a0, newline             #format next line tab print
    syscall   

    
 	li $v0,4     			    #   print the message result.  
    la $a0, result
    syscall  

    move	$a0, $s1	        # copy from register to register for print
    li      $v0, 1              # system call code for print integers.
    syscall 

    li      $v0,10              # code 10 == exit
    syscall                     # Return to OS.