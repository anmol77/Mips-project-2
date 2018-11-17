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
bne $t2, $zero, char_invalid
slti $t2, $a0, 58                           # $t2 = 1 if the character $a0 is less than 58
bne $t2, $zero, char_is_digit
slti $t2, $a0, 65                           #  if $a0 is less than 65 at this point, $t2 = 1. This checks if the values lie between the invalid characters between upper and lower case values
bne $t2, $zero, char_invalid
slti $t2, $a0, 82                           #  if $a0 is less than 82, the character chosen is in uppercase which is handled in label upper case
bne $t2, $zero, char_is_upper
slti $t2, $a0, 97                           #  if $a0 is less than 97, $t2 = 1, which helps to check the validity of character as 97 is the lower limit for valid lower case letters
bne $t2, $zero, char_invalid
slti $t2, $a0, 114                          # sets $t2 = 1 if $a0 is less than 114 which is the range for lower case value for the valid character
bne $t2, $zero, char_is_lower
j loop

space_found:
beq $t1, 0, loop                            #  skips the spaces until it finds first non-space character
beq $t4, 1, space_after_valid_char          #  if a valid char is previously seen
beq $t4, 0, increase_space_count
j loop

increase_space_count:
addi $t3, $t3, 1                             # increase the space count by one after the non-space character is seen
j loop

space_after_valid_char:
li $t4, 0
addi $t3, $t3, 1                            # increase the space counter
j loop

char_invalid:
li $s2, -1
addi $t1, $t1, 1                            #  increase the character count
bne $t1, 1, check_previous_char             #  if more than one valid characters are present, check if previous character is correct
li $t4, 1                                   # if first valid char is seen
j loop

char_is_digit:
addi $s3, $s3, 1                            #  increase the valid character count
addi $t1, $t1, 1                            #  increase character count
bne $t1, 1, check_previous_char             #  if valid char occered for multiple occurences check all prev char to be valid
li $t4, 1                                   # only set if first valid char is seen
j loop
