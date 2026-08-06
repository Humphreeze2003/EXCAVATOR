

// a0 = reg_address
// a1 = mask
// a2 = shift
// a3 = value


// t0 = value
// t1 = field_bits (used)


// s1 = shifted mask (not used)
// s2 = shifted reg (not used)



READ_REGISTER_FIELD: 

addi sp  sp , -32 # create stack frame
sw  s0 , 31(sp)
addi  s0 , sp , 0
sw ra  30(sp)


sw s1 , 29(sp)
sw s2 , 28(sp)


lw t0  , 0(a0)

srl s1 , a1 , a2 # shifted mask (right)
srl s2 , t0 , a2 # shifted reg bits (right)






and t1 , s2 , s1

addi a0 , t1 , 0 # store return value in a0






lw s1 , 29(sp)
lw s2 , 28(sp)



lw ra , 30(sp)
lw s0 , 31(sp)
addi sp , sp , 32


jalr x0 , ra , 0
