.data
user_input: .space 11000
input_value_empty: .asciiz "Input is empty."
input_value_invalid: .asciiz "Invalid base-27 number."
input_too_long: .asciiz "Input is too long."

.text
main:
li $v0, 8                                   #  syscall code to get user input
la $a0, user_input                          #  loading byte space into address
li $a1, 11000                               #  allocating byte space for input string
syscall
move $t8, $a0                               #  keeping the copy of string in other register
move $t0, $a0                               #  move string to t0

if_input_empty:
lb $a0, 0($t0)
beq $a0, 10, input_is_empty
j loop                                      #  if it is not empty, go through the loop

input_is_empty:
li $v0, 4                                   #  system call code to print string
la $a0, input_value_empty                   # load address of string to be printed into $a0
syscall
