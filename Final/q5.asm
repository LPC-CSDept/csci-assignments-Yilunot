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