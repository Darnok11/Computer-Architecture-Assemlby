# Course: Computer Architecture - Konrad Grzyb 227305
# Swap the position of characters consecutive pairs
# Konrad Grzyb -> oKrndaG zrby
# --------------------------------------------
# seted
# t0 - store string into buff1
# t1 - counter of elements to check if zero ele
# t2 - flag to recognize odd number of ele
# evaluated
# t3 - given element from the string
# t4 - tmp memorized element for swap
# t5 - store result
# --------------------------------------------

         .data
msg0:    .asciiz "Empty string - nothing to swap\n"
msg1:    .asciiz "Succesfull swap:\n"
msg2:    .asciiz "There were odd number of elements. Add last element at the end.\n"
msg3:    .asciiz "Old result:\n"
msg4:    .asciiz "New result:\n"
msg5:    .asciiz "\nNumber of elements:\n"

buff1:    .space 1024 # input string
buff2:    .space 1024 # output string
# --------------------------------------------

         .text
main:
# read_string syscall A = aa...a
         la     $a0, buff1
         li     $a1, 1024
         li     $v0, 8
         syscall
# print_string syscall
         la     $a0, buff1
         li     $v0, 4
         syscall

# load @ of the string into reg t0
         la     $t0, buff1
# load @ of the reserved space for the output string
         la     $t5, buff2
# store counter for elements of the string
         li     $t1, 0
# store flag to recognize even odd "cycle" in the loop
         li     $t2, 1

# --------------------------------------------
loop:

# 1) load byte from the string
         lb     $t3, ($t0)
# 2) if this is the last element finish
         bltu   $t3, ' ', finish
# 3) if the flag == 1 (if odd)
         beq    $t2, 1, odd
# --------------------------------------------
# even:

# 5) reverse store to t5
         sb     $t3, ($t5)
         addu   $t5, $t5, 1
         sb     $t4, ($t5)
         addu   $t5, $t5, 1
         # sb    $t5, ($t3)
         b     change
# --------------------------------------------
odd:
# 4) copy the content of t3 into t4 (memorise)
         move    $t4, $t3
# --------------------------------------------
change:
# 6)
# negate flag
         neg   $t2, $t2
# increment number of elements
         addiu $t1, $t1, 1
# increment pointer
         addu  $t0, $t0, 1
# --------------------------------------------
         b     loop
# --------------------------------------------
finish:
# 7) if there were no elements
         beqz  $t1, print_msg0
# 8) if even # of ele skip
         beq   $t2, 1, print_msg1
# 9) else add last stored element in odd string
         sb    $t4, ($t5)

# print msg about odd # of ele
         la    $a0, msg2
         li    $v0, 4
         syscall
# --------------------------------------------
print_msg1:
# Succesfull swap
         la    $a0, msg1
         li    $v0, 4
         syscall
         b     exit
# --------------------------------------------
print_msg0:
         la    $a0, msg0
         li    $v0, 4
         syscall
         b     exit0
# --------------------------------------------
exit:
# Input string:
         la    $a0, msg3
         li    $v0, 4
         syscall
         la    $a0, buff1
         li    $v0, 4
         syscall
# --------------------------------------------
# Output string:
         la    $a0, msg4
         li    $v0, 4
         syscall
         la    $a0, buff2
         li    $v0, 4
         syscall
# --------------------------------------------
exit0:
# number of elements
         la    $a0, msg5
         li    $v0, 4
         syscall

         move  $a0, $t1
         li    $v0, 1
         syscall
# --------------------------------------------
# exit
         li    $v0, 10
         syscall
