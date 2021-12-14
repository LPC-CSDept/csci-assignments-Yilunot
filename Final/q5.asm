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

    .text
    .globl main

main:
    lw  $t1, digists    #load word to $t1, number of digist(3)
    lui $t0, 0ffff      #load upper immediate 

waitloop:
    lw   $t2, 0($t0)            #load word from the input control register
    andi $t2, $t2, 0x0001       #reset or clear all the bits except LSb
    beq  $t2, $zero, waitloop   #if the bit is not ready yet go back to the waitloop
    lw   $v0, 4($t0)            #input device is ready so read a character from I/O

    sub	$s0, $s0, 48		    # s0 = v0-48
    mul $s0, $s0, $t1           # s0 = s0 * v0
    div $t1, $t1, 10            # t1 = t1/10
    add	$s1, $s1, $s0		    # s1 = s1 + s0 
    beq $t1, $zero, done        #if is the zero go to print

done:
	
    move	$a0, $s1	        #copy from register to register for print
    li      $v0, 1              # system call code for print integers.
    syscall 

    li      $v0,10              # code 10 == exit
    syscall                     # Return to OS.