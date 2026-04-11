.globl make_node
.globl insert
.globl get
.globl getAtMost

.extern malloc

#a0=val
#returns pointer in a0

##make_node(int val)
make_node:
    addi sp, sp, -16 ##making space on stanck pointer
    sw a0, 8(sp) #Store the input value on the stack because we call malloc, will overwrite a0.
    sw ra, 12(sp) ##save return address, again because of malloc
    li a0, 24  #24 bytes of memory cuz 4 val, 8 for node left, 8 for node right
    call malloc #size of node part 

    lw t0, 8(sp) #temp, restoring val
    sw t0, 0(a0)  #node->val=val, storing the values from now
    sw zero, 8(a0) #node->left=NULL
    sw zero, 16(a0) #node->right=NULL

    lw ra, 12(sp) #restoring return address here
    addi sp, sp, 16 #freeing stack
    ret

##insert(Node* root, int val)
#a0 is root, a1 is val this will return root
insert:
##saved stuff same as last time again
    addi sp, sp, -16
    sw a0, 8(sp)
    sw ra, 12(sp)

    beq a0, zero, create_node #3if the root==NULL we make node rn

    lw t0, 0(a0) #root->val
    blt a1, t0, left ##bst props: lesser left, higher right is what happens here
    bgt a1, t0, right
    j insert_at_end #If values are equal, do nothing return root.

create_node:
    mv a0, a1 #moving val into a0
    call make_node
    j end 

left:
    lw t1, 8(a0) #root->left
    mv a0, t1 #a0 = root->left
    call insert #a0 = updated subtree root

    lw t2, 8(sp) #restoring og root pointer
    sw a0, 8(t2)
    mv a0, t2
    j insert_at_end

right:
    lw t1, 16(a0) # root->right
    mv a0, t1 #paasing as arg
    call insert

    lw t2, 8(sp)
    sw a0, 16(t2) #root->right = returned subtree
    mv a0, t2

insert_at_end: ##restoring stuff basiclaly
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

end:
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

#get(Node* root, int val)
get:
    beq a0, x0, not_found ##if root==NULL return root is what happens in the funciton
    lw t0, 0(a0) #t0=root->val
    beq a1, t0, found ##if val==root->val we go on found and reutnr
    blt a1, t0, bst_left ##val<root->val, we go left cuz bst prop
    lw a0, 16(a0) ##if wanna go right
    j get
    
bst_left:
    lw a0, 8(a0) ##root=root->left (we defined this before only)
    j get

found:
    ret

not_found:
    li a0, 0 #3this returns null
    ret

#getAtMost(int val, Node* root)
# a0 = val
# a1 = root
# return int
getAtMost:
    li t0, -1 #if no value<=val exists, we return -1

loop:
    beq a1, zero, done ##root was null we stop searching
    lw t1, 0(a1)
    bgt t1, a0, left_subtree ##search left now
    mv t0, t1 #update best candidate=root->val
    lw a1, 16(a1) #move to right subtree
    j loop

left_subtree:
    lw a1, 8(a1) #moving to left child
    j loop

done:
    mv a0, t0
    ret






