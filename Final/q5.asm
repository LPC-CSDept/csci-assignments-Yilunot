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
    lw  $t9, digits    #load word to $t9, number of digist(3)
    lui $t0, 0xffff      #load upper immediate 

waitloop:
    lw   $t1, 0($t0)            #load word from the input control register
    andi $t1, $t1, 0x0001       #reset or clear all the bits except LSb
    beq  $t1, $zero, waitloop   #if the bit is not ready yet go back to the waitloop
    lw   $s0, 4($t0)            #input device is ready so read a character from I/O

    sub	$s0, $s0, 48		    # s0 = v0-48
    mul $s0, $s0, $t9           # s0 = s0 * v0
    div $t9, $t9, 10            # t1 = t1/10
    add	$s1, $s1, $s0		    # s1 = s1 + s0 
    bnez $t9, waitloop          # brach on no equal to zero 

    move	$a0, $s1	        # copy from register to register for print
    li      $v0, 1              # system call code for print integers.
    syscall 

    li      $v0,10              # code 10 == exit
    syscall                     # Return to OS.