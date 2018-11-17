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
j exit                                      #  exit if it is an empty string

li $s2, -1                                  # checks the validity of the program
li $s3, 0                                   # keeps track of length of valid characters
li $t1, 0                                   #  initializing $t1 to zero to later find the length of chars in string
li $t3, 0                                   #  to count spaces.
li $t4, -20                                 #  initializing $t4 to -20, when a character is found, $t4 is set to 1

loop:
lb $a0, 0($t0)
beq $a0, 10, calculate_value                # last char of the string is line feed. If keyword 'enter' is pressed, it starts conversion.

addi $t0, $t0, 1                            #  shifing the pointer by one byte

slti $t2, $a0, 114                          # $t2=1 if $a0 < 114 which is the ascii value of upper limit of valid character q
beq $t2, $zero, char_invalid

beq $a0, 32, space_found                    #  skip the space
slti $t2, $a0, 48                           # $t2 = 1 if the character  $a0 is less than 48
