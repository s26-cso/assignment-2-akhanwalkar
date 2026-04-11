.data
arr: .space 800  # array to store input integers
stack: .space 800 # stack storing indices
result_arr: .space 800  # result array storing the next greater index

fmt: .asciz "%d " # printf format to print numbers with space
nl: .asciz "\n"  # newline string

.text
.globl main


#psueodcode 
#function next_greater(arr) {
#    let stack = new Stack()
#    let result = [-1] * len(arr)
#   for (let i = len(arr) - 1; i >= 0; i--) {
#    while (!stack.empty() && arr[stack.top()] <= arr[i]) stack.pop()
#        if (!stack.empty()) result[i] = stack.top()
#        stack.push(i)
#    }
#    return result
#}

main:
    mv s0, a1 #s0=argv (input strings)
    addi s1, a0, -1 #s1=n (num of strings)
    li t0, 0 #basiclaly started with i=0

input: ##comverting int to store in arr
    bge t0, s1, input_over #goes uptil i>=n
    slli t1, t0, 3 #offsetting it, 8 times at a time 
    add t2, s0, t1
    ld a0, 8(t2) #goes to i+1 input now
    call atoi #converting string to int
    la t3, arr #base
    slli t4, t0, 3 #again times 8 move
    add t3, t3, t4
    sd a0, 0(t3) #arr[i]=value
    addi t0, t0, 1
    j input

input_over:
    li t0, 0 #i=0

init_arr: #initialise the resulting arr w/ -1
    bge t0, s1, init_over
    la t1, result_arr
    slli t2, t0, 3
    add t1, t1, t2
    li t3, -1
    sd t3, 0(t1) #result_arr[i]=-1
    addi t0, t0, 1 #i=i+1
    j init_arr

init_over:
    li s2, -1 ##top stack pointer to -1, stack is empty 
    addi t0, s1, -1 ##for i=n-1 to 0

loop:
    blt t0, zero, done #if i<0 it stops cuz yes

# while stack not empty &&
# arr[stack.top] <= arr[i]
# pop

while:
    blt s2, zero, while_over #exit loop if stack is empty
    la t1, stack #base
    slli t2, s2, 3 
    add t1, t1, t2 #addr of stack top (t1)
    ld t3, 0(t1) # index = stack[top]
    la t4, arr  #base of arr
    slli t5, t3, 3 #index*8
    add t4, t4, t5  #addr of arr[stack[top]]
    ld t6, 0(t4)  # arr[stack[top]]
    la t4, arr #its val
    slli t5, t0, 3  
    add t4, t4, t5
    ld t5, 0(t4)   # arr[i]
    ble t6, t5, pop # if arr[top] <= arr[i], pop stack
    j while_over #else finish loop

pop:
    addi s2, s2, -1 # stack.pop()
    j while

while_over: ## if stack not empty # result[i] = stack.top
    blt s2, zero, stack_empty #if stack empty it dpesnt store as per code
    la t1, stack #bsae addr
    slli t2, s2, 3 
    add t1, t1, t2
    ld t3, 0(t1) #stack[top]
    la t4, result_arr
    slli t5, t0, 3
    add t4, t4, t5
    sd t3, 0(t4) #val

stack_empty:
    addi s2, s2, 1 #top++
    la t1, stack
    slli t2, s2, 3
    add t1, t1, t2 #addr of new stack pos
    sd t0, 0(t1)
    addi t0, t0, -1  #move to previous element (i--)
    j loop  #repeat algorithm

done:
# print_loop
# prints result array
    li t0, 0 # i = 0

print_loop:
    bge t0, s1, exit # if i>=n stop
    la t1, result_arr #base address of result array
    slli t2, t0, 3 
    add t1, t1, t2  #address of result_arr[i]
    ld a1, 0(t1)  #orintf arg load
    la a0, fmt #load format string "%d "
    call printf  
    addi t0, t0, 1 # i++
    j print_loop  #cont prinitng

exit:
    la a0, nl   # load newline string
    call printf # print newline
    ret  # return from main




