










# void parse_command()
#
# Register usage:
#   s1 = SPI_BASE_ADDRESS
#   s2 = SYSTEM_REGS_BASE_ADDRESS
#   s3 = DC_MOTOR_BASE_ADDRESS
#   s4 = STEPPER_MOTOR_BASE_ADDRESS
#   s5 = SERVO_MOTOR_BASE_ADDRESS
#   s6 = system_mode (read from SYSTEM_REGS_BASE_ADDRESS[0])
#   s7 = command
#   s8 = param
#   s9 = action

PARSE_COMMAND:
    addi  sp, sp, -48          # create stack frame (room for s0..s10 + ra)
    sw    s0, 47(sp)
    addi  s0, sp, 0            # frame pointer (unused)
    sw    ra, 46(sp)
    sw    s1, 45(sp)
    sw    s2, 44(sp)
    sw    s3, 43(sp)
    sw    s4, 42(sp)
    sw    s5, 41(sp)
    sw    s6, 40(sp)
    sw    s7, 39(sp)
    sw    s8, 38(sp)
    sw    s9, 37(sp)

    # Load base addresses
    # SPI_BASE_ADDRESS = 0x0C5F
    lui   s1, 0x1
    addi  s1, s1, -0x3A1       # 0x1000 - 0x3A1 = 0x0C5F

    # SYSTEM_REGS_BASE_ADDRESS = 0x0C9F
    lui   s2, 0x1
    addi  s2, s2, -0x361       # 0x1000 - 0x361 = 0x0C9F

    # DC_MOTOR_BASE_ADDRESS = 0x0BFF
    lui   s3, 0x1
    addi  s3, s3, -0x401       # 0x1000 - 0x401 = 0x0BFF

    # STEPPER_MOTOR_BASE_ADDRESS = 0x0C1F
    lui   s4, 0x1
    addi  s4, s4, -0x3E1       # 0x1000 - 0x3E1 = 0x0C1F

    # SERVO_MOTOR_BASE_ADDRESS = 0x0C3F
    lui   s5, 0x1
    addi  s5, s5, -0x3C1       # 0x1000 - 0x3C1 = 0x0C3F

    # ------------------------------------------------------------
    # Read system mode: uint32_t mode = SYSTEM_REGS_BASE_ADDRESS[0];
    # ------------------------------------------------------------
    lw    s6, 0(s2)            # s6 = *SYSTEM_REGS_BASE_ADDRESS

    # ------------------------------------------------------------
    # Read command, param, action from SPI_BASE_ADDRESS[3] (offset 12)
    #   command = read_register_field(&SPI_BASE_ADDRESS[3], 255, 0)
    #   param   = read_register_field(&SPI_BASE_ADDRESS[3], (255<<8), 8)
    #   action  = read_register_field(&SPI_BASE_ADDRESS[3], (255<<16), 16)
    # ------------------------------------------------------------
    # &SPI_BASE_ADDRESS[3] = s1 + 3 (my memory is word addressed)
    addi  a0, s1, 3            # a0 = address of SPI_BASE_ADDRESS[3]

    # command: mask = 255, shift = 0
    addi  a1, x0, 0xFF          # mask = 255
    addi  a2, x0, 0             # shift = 0
    jal   ra, READ_REGISTER_FIELD
    addi  s7, a0, 0             # s7 = command

    # param: mask = 0xFF00, shift = 8
    addi  a0, s1, 3
    lui   a1, 0x0              # load 0xFF00 using lui+addi? 0xFF00 = 65280.
    # lui a1, 0x0 gives 0, then addi with 0xFF00? But 0xFF00 > 2047, not possible. Need lui+addi.
    # 0xFF00 = 0x0000FF00, split: lui a1, 0x0 (upper 20 bits 0), then addi a1, a1, 0xFF00? Not valid.
    # Actually 0xFF00 can be built by lui a1, 0x10 and then addi a1, a1, -0x100? Let's find: 0x10 << 12 = 0x10000, subtract 0x100 gives 0xFF00. So:
    lui   a1, 0x10             # a1 = 0x10000
    addi  a1, a1, -0x100       # a1 = 0x0FF00 (0x10000 - 0x100 = 0xFF00)
    addi  a2, x0, 8            # shift = 8
    jal   ra, READ_REGISTER_FIELD
    addi  s8, a0, 0            # s8 = param

    # action: mask = 0xFF0000, shift = 16
    addi  a0, s1, 3
    # 0xFF0000 = 0x00FF0000, split: lui a1, 0xFF00? That would be 0xFF00000? Actually lui a1, 0xFF0 gives 0xFF0000? lui << 12: 0xFF0 << 12 = 0xFF00000? Wait: 0xFF0 is 4080, <<12 = 0xFF0000? No: 0xFF0 << 12 = 0xFF0000? Actually 0xFF0 * 4096 = 0xFF0000? 0xFF0 = 4080, 4080*4096 = 16,711,680 = 0xFF0000? Let's compute: 0xFF0000 = 16,711,680. So lui a1, 0xFF0 gives 0xFF0000. Yes! Because 0xFF0 << 12 = 0xFF0000. So we can use lui a1, 0xFF0.
    lui   a1, 0xFF0            # a1 = 0xFF0000
    addi  a2, x0, 16           # shift = 16
    jal   ra, READ_REGISTER_FIELD
    addi  s9, a0, 0            # s9 = action

    # ------------------------------------------------------------
    # Switch on system_mode (s6)
    # ------------------------------------------------------------
    # case 0: IDLE
    beq   s6, x0, CASE_0
    addi  t0, x0, 1
    beq   s6, t0, CASE_1
    addi  t0, x0, 2
    beq   s6, t0, CASE_2
    addi  t0, x0, 4
    beq   s6, t0, CASE_4
    j     END_SWITCH           # default (do nothing)

# ------------------------------------------------------------
# CASE 0: IDLE SYSTEM MODE
# ------------------------------------------------------------
CASE_0:
    # switch (command)
    beq   s7, x0, CASE_0_DEFAULT   # command == 0? Actually command default is anything other than 4, we can just check for 4.
    addi  t0, x0, 4
    bne   s7, t0, CASE_0_DEFAULT   # if command != 4, go default
    # command == 4: change system mode
    # switch (param)
    addi  t0, x0, 0
    beq   s8, t0, CASE_0_PARAM_0
    addi  t0, x0, 1
    beq   s8, t0, CASE_0_PARAM_1
    addi  t0, x0, 2
    beq   s8, t0, CASE_0_PARAM_2
    j     CASE_0_DEFAULT

CASE_0_PARAM_0:
    # change to drive mode (set system mode to 1)
    addi  a0, s2, 0
    addi  a1, x0, -1           # mask = 0xffffffff
    addi  a2, x0, 0
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_0_PARAM_1:
    # change to excavator arm mode (set to 2)
    addi  a0, s2, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, 2
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_0_PARAM_2:
    # change to excavator base mode (set to 4)
    addi  a0, s2, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, 4
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_0_DEFAULT:
    j     END_SWITCH

# ------------------------------------------------------------
# CASE 1: DRIVE SYSTEM MODE
# ------------------------------------------------------------
CASE_1:
    # switch (command)
    addi  t0, x0, 1
    beq   s7, t0, CASE_1_CMD_1
    addi  t0, x0, 2
    beq   s7, t0, CASE_1_CMD_2
    addi  t0, x0, 4
    beq   s7, t0, CASE_1_CMD_4
    addi  t0, x0, 5
    beq   s7, t0, CASE_1_CMD_5
    j     END_SWITCH           # default

CASE_1_CMD_1:   # command == 1: move
    # switch (param)
    addi  t0, x0, 1
    beq   s8, t0, CASE_1_MOVE_FORWARD
    addi  t0, x0, 2
    beq   s8, t0, CASE_1_MOVE_BACKWARD
    j     END_SWITCH

CASE_1_MOVE_FORWARD:
    # modify_register(DC_MOTOR_BASE_ADDRESS, (0x1<<10), 10, 0) ; standby=0
    addi  a0, s3, 0
    addi  a1, x0, 0x400        # mask = 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    # modify_register(DC_MOTOR_BASE_ADDRESS, 0x01, 0, 1) ; direction=1
    addi  a0, s3, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_1_MOVE_BACKWARD:
    # modify_register(DC_MOTOR_BASE_ADDRESS, (0x1<<10), 10, 0) ; standby=0
    addi  a0, s3, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    # modify_register(DC_MOTOR_BASE_ADDRESS, 0x01, 0, 0) ; direction=0
    addi  a0, s3, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_1_CMD_2:   # command == 2: steer
    # switch (param)
    addi  t0, x0, 5
    beq   s8, t0, CASE_1_STEER_LEFT
    addi  t0, x0, 6
    beq   s8, t0, CASE_1_STEER_RIGHT
    j     END_SWITCH

CASE_1_STEER_LEFT:
    # modify_register(SERVO_MOTOR_BASE_ADDRESS, 0xffff, 0, 1750)
    addi  a0, s5, 0
    lui   a1, 0x10             # mask = 0xFFFF via lui+addi
    addi  a1, a1, -1
    addi  a2, x0, 0
    addi  a3, x0, 1750         # 0x6D6, fits 12-bit? 1750 < 2048, ok.
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_1_STEER_RIGHT:
    # modify_register(SERVO_MOTOR_BASE_ADDRESS, 0xffff, 0, 1250)
    addi  a0, s5, 0
    lui   a1, 0x10
    addi  a1, a1, -1
    addi  a2, x0, 0
    addi  a3, x0, 1250         # 0x4E2, fits
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_1_CMD_4:   # command == 4: change system mode
    # switch (param)
    addi  t0, x0, 0
    beq   s8, t0, CASE_1_CHANGE_0
    addi  t0, x0, 1
    beq   s8, t0, CASE_1_CHANGE_1
    addi  t0, x0, 2
    beq   s8, t0, CASE_1_CHANGE_2
    j     END_SWITCH

CASE_1_CHANGE_0:
    # change to drive mode: set system mode = 1, standby DC motor = 0
    addi  a0, s3, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    # set system mode
    addi  a0, s2, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_1_CHANGE_1:
    # change to excavator arm mode: set system mode = 2, standby stepper = 0
    addi  a0, s4, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    addi  a0, s2, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, 2
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_1_CHANGE_2:
    # change to excavator base mode: set system mode = 4, standby stepper = 0
    addi  a0, s4, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    addi  a0, s2, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, 4
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_1_CMD_5:   # command == 5: NO KEY PRESSED -> standby DC motor
    # modify_register(DC_MOTOR_BASE_ADDRESS, (0x1<<10), 10, 1)
    addi  a0, s3, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

# ------------------------------------------------------------
# CASE 2: EXCAVATOR BASE MODE
# ------------------------------------------------------------
CASE_2:
    # switch (command)
    addi  t0, x0, 1
    beq   s7, t0, CASE_2_CMD_1
    addi  t0, x0, 4
    beq   s7, t0, CASE_2_CMD_4
    addi  t0, x0, 5
    beq   s7, t0, CASE_2_CMD_5
    j     END_SWITCH

CASE_2_CMD_1:   # command == 1: move (stepper)
    # switch (param)
    addi  t0, x0, 3
    beq   s8, t0, CASE_2_MOVE_CW
    addi  t0, x0, 4
    beq   s8, t0, CASE_2_MOVE_CCW
    j     END_SWITCH

CASE_2_MOVE_CW:
    # standby=0, direction=1
    addi  a0, s4, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    addi  a0, s4, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_2_MOVE_CCW:
    # standby=0, direction=0
    addi  a0, s4, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    addi  a0, s4, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_2_CMD_4:   # command == 4: change system mode
    # switch (param)
    addi  t0, x0, 0
    beq   s8, t0, CASE_2_CHANGE_0
    addi  t0, x0, 1
    beq   s8, t0, CASE_2_CHANGE_1
    addi  t0, x0, 2
    beq   s8, t0, CASE_2_CHANGE_2
    j     END_SWITCH

CASE_2_CHANGE_0:
    # change to drive mode: set system = 1, standby stepper = 0 (already? we set it)
    addi  a0, s4, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    addi  a0, s2, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_2_CHANGE_1:
    # change to excavator base mode? (set system=2, standby stepper=0)
    addi  a0, s4, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    addi  a0, s2, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, 2
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_2_CHANGE_2:
    # change to excavator arm mode: set system=4, standby stepper=0
    addi  a0, s4, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER
    addi  a0, s2, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, 4
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

CASE_2_CMD_5:   # command == 5: NO KEY PRESSED -> standby stepper = 1
    addi  a0, s4, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER
    j     END_SWITCH

# ------------------------------------------------------------
# CASE 4: EXCAVATOR ARM MODE (currently does nothing)
# ------------------------------------------------------------
CASE_4:
    # switch (command)
    # Since arm mode does nothing, we just skip to end.
    # But for completeness, we still check command 3, 4, 5 and do nothing.
    # We'll just jump to END_SWITCH unconditionally.
    j     END_SWITCH

# ------------------------------------------------------------
# End of switch
# ------------------------------------------------------------
END_SWITCH:
    # restore registers and return
    lw    s9, 37(sp)
    lw    s8, 38(sp)
    lw    s7, 39(sp)
    lw    s6, 40(sp)
    lw    s5, 41(sp)
    lw    s4, 42(sp)
    lw    s3, 43(sp)
    lw    s2, 44(sp)
    lw    s1, 45(sp)
    lw    ra, 46(sp)
    lw    s0, 47(sp)
    addi  sp, sp, 48
    jalr  x0, ra, 0