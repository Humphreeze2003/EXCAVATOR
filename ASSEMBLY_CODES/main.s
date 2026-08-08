
MAIN:

addi sp , sp , -32
addi s0  , sp , 0




              # system regs base adress (3231)   
lui  t0, 0x1
addi t0, t0, -865


              # nrf base address ( 3199)
lui  t1, 0x1
addi t1, t1, -897  

addi t2 , x0 ,1


sw t0 , 31(sp)  # save t0 before calling initialize system
sw t1 , 30(sp)  # save t1 before calling initialize system
sw t2 , 29(sp)  # save t2 before calling initialize system


jal ra , INITIALIZE_SYSTEM

lw t0 , 31(sp)  # reload t0
lw t1 , 30(sp)  # reload t1
lw t2 , 29(sp)  # reload t2





MAIN_LOOP:
# set arguments for read register field ( for system reset reg)
addi a0 , t0 , 1
addi a1 , x0 , 0xffffffff
addi a2 , x0 , 0

sw t0 , 31(sp)  # save t0 before calling read reg field
sw t1 , 30(sp)  # save t1 before calling read reg field
sw t2 , 29(sp)  # save t2 before calling read reg field

jal ra , READ_REGISTER_FIELD

lw t0 , 31(sp)  # reload t0
lw t1 , 30(sp)  # reload t1
lw t2 , 29(sp)  # reload t2

beq a0 , t2 , RESET_TRUE  # check result of the read field for system reset register

# set arguments for read register field (for nrf status reg)
addi a0 , t1 , 1
addi a1 , x0 , 0x01
addi a2 , x0 , 0

sw t0 , 31(sp)  # save t0 before calling read reg field
sw t1 , 30(sp)  # save t1 before calling read reg field
sw t2 , 29(sp)  # save t2 before calling read reg field

jal ra , READ_REGISTER_FIELD


lw t0 , 31(sp)  # reload t0
lw t1 , 30(sp)  # reload t1
lw t2 , 29(sp)  # reload t2



beq a0 , x0 , MAIN_LOOP # IRQ STATUS BIT IS LOW , THUS NO PACKET HAS BEEN RECEIVED 

sw t0 , 31(sp)  # save t0 before calling read receive data
sw t1 , 30(sp)  # save t1 before calling read receive data
sw t2 , 29(sp)  # save t2 before calling read receive data

jal ra , RECEIVE_DATA

lw t0 , 31(sp)  # reload t0
lw t1 , 30(sp)  # reload t1
lw t2 , 29(sp)  # reload t2


jal x0 , MAIN_LOOP # restart the loop


RESET_TRUE:

sw t0 , 31(sp)  # save t0 before calling initialize system
sw t1 , 30(sp)   # save t1 before calling initialize system
sw t2 , 29(sp)  # save t2 before calling initialize system

jal ra , INITIALIZE_SYSTEM

lw t0 , 31(sp)  # reload t0
lw t1 , 30(sp)  # reload t1
lw t2 , 29(sp)  # reload t2


jal x0 , MAIN_LOOP # restart the loop


