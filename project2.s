.data
user_input: .space 11000
input_value_empty: .asciiz "Input is empty."
input_value_invalid: .asciiz "Invalid base-27 number."
input_too_long: .asciiz "Input is too long."

.text
main:
li $v0, 8                                   #  syscall code to get user input
la $a0, user_input                          #  loading byte space into address
