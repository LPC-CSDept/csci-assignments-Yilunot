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
q_msg:	.asciiz  " 'q' key was pressed  \n End Program"

#Section that contains instructions and program logic
        .text     
		.globl     main    

main:   
#Coprocessor 0 register $12; starus register

        mfc0    $a0, $12     	    #read from the status register     
		ori     $a0, 0xff11     	#enable all interrupts     
		mtc0 	$a0, $12     	    #write back to the status register

		lui     $t0, 0xFFFF     	#$t0 =   0xFFFF0000     
		ori     $a0, $0, 2     	    #enable keyboard interrupt     
		sw     	$a0, 0($t0)     	#write back to 0xFFFF0000;Receiver Control

loop:   j 	loop    			    #   stay here forever keep program running


	# KERNEL text
		
	.ktext  0x80000180     	        # kernel code starts here section
#save registers
    sw     	$v0, s1     		    #  We need to use these registers  
	sw     	$a0, s2     	        #  not using the stack because the interrupt
#Coprocessor 0 Register $13; Cause Registe
    mfc0 	$k0, $13     	        #   Cause register     
	srl     $a0, $k0, 2     	    #   Extract   ExcCode     Field     
	andi    $a0, $a0, 0x1f 	        #   Get the exception code     
	bne     $a0, $zero, kdone       # Exception Code 0 is I/O. Only processing I/O

    lui     $v0, 0xffff    	        #   $v0 =   0xFFFF0000     
	lw     	$a0, 4($v0)   	        #  get the input key
    li 	    $s0, 113		        # load the q key into s0
    beq 	$a0, $s0, quit 	        # exit if 'q' is typed in not print 
    li 	$v0,1     		            # print it here.      
	syscall     			        	
						               
	li $v0,4     			        #   print the new line     
	la $a0, new
	syscall   

kdone:     
	lw     	$v0, s1     		    # Restore other registers     
	lw     	$a0, s2     
#Clear the kernel Cause register $13
	mtc0 	$0, $13     	        # Clear Cause register 
#Set the interrupt bit in Status register $12 to 1    
	mfc0 	$k0, $12     	        # Set Status register     
	#andi   $k0, 0xfffd  	        # clear EXL bit d = 1101   
	ori    	$k0, 0x11     	        # Interrupts enabled     
	mtc0 	$k0, $12     	        # write back to status
#Return to the user program with EPC  
	eret    			            # return to EPC    

quit:
	li 	$v0, 4
	la 	$a0, q_msg      #print quit message text 
	syscall				#quit,end the program when the qkey pressed 								#quit,end the program when the q key pressed 
	li $v0	10		
	syscall

