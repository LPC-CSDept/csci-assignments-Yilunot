#
#q6.asm
#
#Tony Liu
#12/15/21
#
#Take the user charater and prin it in a console until 'q' is typed.

# Kernel data section
        .kdata

#value holding
s1:     .word 10         # storage for register $v0     
s2:     .word 11         # storage for register $a0

new:    .asciiz     "\n"

#Section that contains instructions and program logic
        .text     
		.globl     main    

main:   
#Coprocessor 0 register $12; starus register

        mfc0    $a0, $12     	    #read from the status register     
		ori     $a0,   0xff11     	#enable all interrupts     
		mtc0 	$a0, $12     	    #write back to the status register

		lui     $t0, 0xFFFF     	#$t0 =   0xFFFF0000     
		ori     $a0, $0, 2     	    #enable keyboard interrupt     
		sw     	$a0, 0($t0)     	#write back to 0xFFFF0000;Receiver Control

