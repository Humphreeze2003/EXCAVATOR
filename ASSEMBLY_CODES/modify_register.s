

// a0 = reg_address
// a1 = mask
// a2 = shift
// a3 = action 


// t0 = val
// t1 = field_bits
// t2 = 64
// t3 = 128
// t4 = cleared field reg
// t5 = new reg bits

// s1 = shifted mask
// s2 = shifted reg
// s3 = shifted entity  
// s4 = inverted mask


MODIFY_REGISTER : 

addi sp , sp , -32 # create stack frame
sw , s0 , 31(sp)
addi , s0 , s0 , 0
sw ra , 30(sp)


sw s1 , 29(sp)
sw s2 , 28(sp)
sw s3 , 27(sp)
sw s4 , 26(sp)


addi t2 , x0 , 64
addi t3 , x0 , 128

lw t0 , 0(a0)
sll s1 , a1 , a2 # shift mask left
sll s2 , a0 , a2 # shift register bits right
or t1 , s1 , s2

beq a3 , t2 , AC




