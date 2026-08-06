

// a0 = reg_address
// a1 = mask
// a2 = shift
// a3 = value


// t0 = value
// t1 = field_bits (not used)
// t2 = cleared field reg
// t3 = new reg bits

// s1 = shifted mask (not used)
// s2 = shifted reg (not used)
// s3 = shifted new val left  
// s4 = inverted mask


MODIFY_REGISTER : 

addi sp , sp , -32 # create stack frame
sw  s0 , 31(sp)
addi  s0 , sp , 0
sw ra , 30(sp)


# sw s1 , 29(sp)
# sw s2 , 28(sp)
sw s3 , 27(sp)
sw s4 , 26(sp)

lw t0  , 0(a0)

# srl s1 , a1 , a2 # shifted mask (right)
# srl s2 , t0 , a2 # shifted reg bits (right)

sll s3 , a3 , a2  # shifted new val left
xori s4, a1, -1 # inverted mask




# and t1 , s2 , s1

and t2 , t0 , s4

or t3 , t2 , s3 

sw t3 , 0(a0)




# lw s1 , 29(sp)
# lw s2 , 28(sp)
lw s3 , 27(sp)
lw s4 , 26(sp)


lw ra , 30(sp)
lw s0 , 31(sp)
addi sp , sp , 32


jalr x0 , ra , 0
