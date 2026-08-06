















# void initialize_system()
#
# Registers used:
#   s1 = SYSTEM_REGS_BASE_ADDRESS (0x0C9F)
#   s2 = DC_MOTOR_BASE_ADDRESS   (0x0BFF)
#   s3 = STEPPER_MOTOR_BASE_ADDRESS (0x0C1F)
#   s4 = SERVO_MOTOR_BASE_ADDRESS  (0x0C3F)
#   (s5, s6, s7 are saved but not used)

INITIALIZE_SYSTEM:
    addi  sp, sp, -40          # create stack frame (room for s0..s7 + ra)
    sw    s0, 39(sp)
    addi  s0, sp, 0            # frame pointer (unused)
    sw    ra, 38(sp)
    sw    s1, 37(sp)
    sw    s2, 36(sp)
    sw    s3, 35(sp)
    sw    s4, 34(sp)
    sw    s5, 33(sp)
    sw    s6, 32(sp)

    # Load base addresses
    # SYSTEM_REGS_BASE_ADDRESS = 0x0C9F
    lui   s1, 0x1
    addi  s1, s1, -0x361       # 0x1000 - 0x361 = 0x0C9F

    # DC_MOTOR_BASE_ADDRESS = 0x0BFF
    lui   s2, 0x1
    addi  s2, s2, -0x401       # 0x1000 - 0x401 = 0x0BFF

    # STEPPER_MOTOR_BASE_ADDRESS = 0x0C1F
    lui   s3, 0x1
    addi  s3, s3, -0x3E1       # 0x1000 - 0x3E1 = 0x0C1F

    # SERVO_MOTOR_BASE_ADDRESS = 0x0C3F
    lui   s4, 0x1
    addi  s4, s4, -0x3C1       # 0x1000 - 0x3C1 = 0x0C3F

    # ------------------------------------------------------------
    # 1) Set system mode to none:
    #    modify_register(SYSTEM_REGS_BASE_ADDRESS, 0xffffffff, 0, 0)
    # ------------------------------------------------------------
    addi  a0, s1, 0
    addi  a1, x0, -1           # mask = 0xffffffff
    addi  a2, x0, 0
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 2) DC motor: direction = 1
    #    modify_register(DC_MOTOR_BASE_ADDRESS, 0x1, 0, 1)
    # ------------------------------------------------------------
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER

    # 3) DC motor: freq counter = 0x1ff, shift = 1
    #    mask = (0x1ff << 1) = 0x3FE
    addi  a0, s2, 0
    addi  a1, x0, 0x3FE        # mask (fits in 12-bit)
    addi  a2, x0, 1
    addi  a3, x0, 0x1FF        # new_val = 511
    jal   ra, MODIFY_REGISTER

    # 4) DC motor: standby = 0, shift = 10
    #    mask = (0x1 << 10) = 0x400
    addi  a0, s2, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 5) Stepper motor: direction = 1
    #    modify_register(STEPPER_MOTOR_BASE_ADDRESS, 0x1, 0, 1)
    # ------------------------------------------------------------
    addi  a0, s3, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER

    # 6) Stepper motor: freq counter = 0x1ff, shift = 1
    addi  a0, s3, 0
    addi  a1, x0, 0x3FE
    addi  a2, x0, 1
    addi  a3, x0, 0x1FF
    jal   ra, MODIFY_REGISTER

    # 7) Stepper motor: standby = 0, shift = 10
    addi  a0, s3, 0
    addi  a1, x0, 0x400
    addi  a2, x0, 10
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 8) Servo motor: initial angle 1500 µs (90°)
    #    modify_register(SERVO_MOTOR_BASE_ADDRESS, 0xffff, 0, 1500)
    #    mask = 0xFFFF
    # ------------------------------------------------------------
    addi  a0, s4, 0
    lui   a1, 0x10             # a1 = 0x10000
    addi  a1, a1, -1           # a1 = 0x0FFFF (0xFFFF)
    addi  a2, x0, 0
    addi  a3, x0, 0x5DC        # 1500
    jal   ra, MODIFY_REGISTER

    # 9) Servo: standby = 0, shift = 16
    #    modify_register(SERVO_MOTOR_BASE_ADDRESS, (0x1 << 16), 16, 0)
    #    mask = 0x10000
    addi  a0, s4, 0
    lui   a1, 0x10             # a1 = 0x10000
    addi  a2, x0, 16
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 10) initialize_nrf_module()
    # ------------------------------------------------------------
    jal   ra, INITIALIZE_NRF_MODULE

    # ------------------------------------------------------------
    # 11) modify_register(&SYSTEM_REGS_BASE_ADDRESS[1], 0xffffffff, 0, 0)
    #     address = s1 + 1 (my memory is word addressable)
    # ------------------------------------------------------------
    addi  a0, s1, 1            # &SYSTEM_REGS_BASE_ADDRESS[1]
    addi  a1, x0, -1           # mask = 0xffffffff
    addi  a2, x0, 0
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # Return
    # ------------------------------------------------------------
    lw    s6, 32(sp)
    lw    s5, 33(sp)
    lw    s4, 34(sp)
    lw    s3, 35(sp)
    lw    s2, 36(sp)
    lw    s1, 37(sp)
    lw    ra, 38(sp)
    lw    s0, 39(sp)
    addi  sp, sp, 40
    jalr  x0, ra, 0