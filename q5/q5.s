.data
filename:.asciz "input.txt"
yes: .asciz "Yes\n"     # message to print if palindrome
no: .asciz "No\n"   # message to print if not palindrome
buf1: .space 1    # buffer to store left character
buf2: .space 1     # buffer to store right character

.text
.globl main

main:
##openat(AT_FDCWD, "input.txt", O_RDONLY, 0) == Open input.txt in the current directory for reading
    li a0, -100  #use the current working directory (this is a thing called AT_FDCWD)
    la a1, filename# filename
    li a2, 0 # O_RDONLY(Open the file for reading only)
    li a3, 0
    li a7, 56   # openat syscall
    ecall
    mv s0, a0

    ##using lseek 
    mv a0, s0 #a0 becomes file descritipor
    li a1, 0
    li a2, 2 #moving pointer ot the end
    li a7, 62 #syscall for lseek
    ecall #reutring file size in a0
    addi s2, a0, -1   # assume last char
    li s1, 0   # left pointer = 0
    # checking if last char is newline
    mv a0, s0
    mv a1, s2
    li a2, 0
    li a7, 62
    ecall  # lseek to last char
    mv a0, s0
    la a1, buf2
    li a2, 1
    li a7, 63
    ecall # read last char
    lb t0, buf2
    li t1, 10            # '\n'
    bne t0, t1, comparison_loop
    addi s2, s2, -1      # skip newline

comparison_loop:
    bge s1, s2, palindrome #if left>=right then we're done

    mv a0, s0 #staring to read from left side
    mv a1, s1
    li a2, 0
    li a7, 62 #again lseek syscall
    ecall   # move file pointer to left index

    mv a0, s0
    la a1, buf1  #a1 = address of buffer
    li a2, 1 #read 1 byte
    li a7, 63 #read syscall
    ecall #reading char into buf1

    mv a0, s0   #reading char from the right side 
    mv a1, s2  #a1 = position we want to read
    li a2, 0
    li a7, 62 
    ecall #move file pointer to right index

    mv a0, s0 
    la a1, buf2 #buffer for right character
    li a2, 1 #read 1 byte
    li a7, 63 #read syscall
    ecall  #read character into buf2

    #comparision of chars
    la t2, buf1
    lb t0, 0(t2)
    la t2, buf2
    lb t1, 0(t2)
    bne t0, t1, not_palindrome #if theyre diff

    addi s1, s1, 1 #left++
    addi s2, s2, -1 #right--
    j comparison_loop

palindrome:
    li a0, 1 #this is the srdout file descr
    la a1, yes #goes to print yes
    li a2, 4  # length of string
    li a7, 64 # write syscall
    ecall    #print Yes
    j exit 

not_palindrome:
    li a0, 1
    la a1, no ##goes to addr of no
    li a2, 3   # string length
    li a7, 64 
    ecall  # print No

exit:
    li a7, 93 #syscall for exiting
    ecall