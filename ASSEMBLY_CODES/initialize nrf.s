


















INITIALIZE_NRF_MODULE:
    addi  sp, sp, -32          # create stack frame
    sw    s0, 31(sp)
    addi  s0, sp, 0            # frame pointer (unused but kept)
    sw    ra, 30(sp)


    sw    s1, 29(sp)
    sw    s2, 28(sp)
    sw    s3, 27(sp)
    sw    s4, 26(sp)

    # load SPI_BASE_ADDRESS (0x0C5F) into s1
    lui   s1, 0x1              # s1 = 0x00001000
    addi  s1, s1, -0x3A1       # s1 = 0x00001000 - 0x3A1 = 0x00000C5F

    # compute s2 = base + 1, s3 = base + 2 ( my memory is word addressable , not byte addressable , thus it progresses by 1 not 4)
    addi  s2, s1, 1
    addi  s3, s1, 2

    # ------------------------------------------------------------
    # 1) set SPI master clock frequency to 1 MHz (count = 27)
    #    modify_register(SPI_BASE_ADDRESS, 0xffff, 0, 27)
    # ------------------------------------------------------------
    addi  a0, s1, 0            # reg_address
    lui   a1, 0x10             # mask = 0x0000ffff (0x10000 - 1)
    addi  a1, a1, -1
    addi  a2, x0, 0            # shift = 0
    addi  a3, x0, 27           # new_val = 27
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 2) wait while TX busy (status bit 0)
    #    while(read_register_field(&SPI_BASE_ADDRESS[1], 0x01, 0)) { }
    # ------------------------------------------------------------
WAIT_TX_DONE_1:
    addi  a0, s2, 0            # &SPI_BASE_ADDRESS[1]
    addi  a1, x0, 1            # mask = 0x01
    addi  a2, x0, 0            # shift = 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_1

    # ------------------------------------------------------------
    # 3) Write to CONFIG register (0x20)
    #    modify_register(SPI_BASE_ADDRESS, (0xf<<16), 16, 2)
    #    modify_register(&SPI_BASE_ADDRESS[2], 0xffffffff, 0, 0x200f)
    #    modify_register(SPI_BASE_ADDRESS, (0x1<<24), 24, 1)
    #    while(read_register_field(&SPI_BASE_ADDRESS[1], 0x01, 0)) { }
    # ------------------------------------------------------------
    # set number of bytes = 2
    
    addi  a0, s1, 0
    lui   a1, 0xF0             # mask = 0x000F0000
    addi  a2, x0, 16           # shift = 16
    addi  a3, x0, 2            # new_val = 2
    jal   ra, MODIFY_REGISTER

    # put data 0x200f into TX buffer
    addi  a0, s3, 0            # &SPI_BASE_ADDRESS[2]
    addi  a1, x0, -1           # mask = 0xffffffff
    addi  a2, x0, 0            # shift = 0
    lui   a3, 0x2              # new_val = 0x200f (0x2000 + 0x0f)
    addi  a3, a3, 0x0f
    jal   ra, MODIFY_REGISTER

    # assert TX (set bit 24)
    lui   a1, 0x1000           # mask = 0x01000000
    addi  a2, x0, 24           # shift = 24
    addi  a3, x0, 1            # new_val = 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_2:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_2

    # ------------------------------------------------------------
    # 4) Write to EN_AA register (0x21)
    #    modify_register(SPI_BASE_ADDRESS, (0xf<<16), 16, 2)
    #    modify_register(&SPI_BASE_ADDRESS[2], 0xffffffff, 0, 0x2101)
    #    modify_register(SPI_BASE_ADDRESS, (0x1<<24), 24, 1)
    #    while(...)
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 2
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    lui   a3, 0x21             # 0x2101 = 0x2100 + 0x01
    addi  a3, a3, 0x01
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_3:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_3

    # ------------------------------------------------------------
    # 5) Write to EN_RX_ADDR register (0x22)
    #    data = 0x2201
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 2
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    lui   a3, 0x22
    addi  a3, a3, 0x01
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_4:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_4

    # ------------------------------------------------------------
    # 6) Write to SETUP_AW register (0x23)
    #    data = 0x2301
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 2
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    lui   a3, 0x23
    addi  a3, a3, 0x01
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_5:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_5

    # ------------------------------------------------------------
    # 7) Write to SETUP_RETY register (0x24)
    #    data = 0x2400
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 2
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    lui   a3, 0x24
    addi  a3, a3, 0x00
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_6:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_6

    # ------------------------------------------------------------
    # 8) Write to RF_CH register (0x25)
    #    data = 0x254C
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 2
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    lui   a3, 0x25
    addi  a3, a3, 0x4C
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_7:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_7

    # ------------------------------------------------------------
    # 9) Write to RF_SETUP register (0x26)
    #    data = 0x2606
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 2
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    lui   a3, 0x26
    addi  a3, a3, 0x06
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_8:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_8

    # ------------------------------------------------------------
    # 10) Write to STATUS register (0x27)
    #     data = 0x2770
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 2
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    lui   a3, 0x27
    addi  a3, a3, 0x70
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_9:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_9

    # ------------------------------------------------------------
    # 11) Write to RX_ADDR_P0 register (0x2A)
    #     bytes = 4, data = 0x2AAAAAAA
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 4            # number of bytes = 4
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0




     # lui a3, 0x2AAB
    # addi a3, a3, -0x556
    # This gives 0x2AAAAAAA.
    # So we'll do that.

    # So load 0x2AAAAAAA
    lui   a3, 0x2AAB
    addi  a3, a3, -0x556
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_10:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_10

    # ------------------------------------------------------------
    # 12) Write to RX_PW_P0 register (0x31)
    #     data = 0x3120
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 2
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    lui   a3, 0x31
    addi  a3, a3, 0x20
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_11:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_11

    # ------------------------------------------------------------
    # 13) Write to FLUSH_RX (0xE2)
    #     bytes = 1, data = 0xE2
    # ------------------------------------------------------------
    lui   a1, 0xF0
    addi  a2, x0, 16
    addi  a3, x0, 1            # number of bytes = 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

    addi  a0, s3, 0
    addi  a1, x0, -1
    addi  a2, x0, 0
    addi  a3, x0, -0x1E? # 0xE2 = 226, we can do addi a3, x0, 0xE2? 0xE2 = 226, fits in 12-bit? 226 < 2048, so we can do addi a3, x0, 0xE2.
    addi  a3, x0, 0xE2
    jal   ra, MODIFY_REGISTER

    lui   a1, 0x1000
    addi  a2, x0, 24
    addi  a3, x0, 1
    addi  a0, s1, 0
    jal   ra, MODIFY_REGISTER

WAIT_TX_DONE_12:
    addi  a0, s2, 0
    addi  a1, x0, 1
    addi  a2, x0, 0
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_TX_DONE_12

    # ------------------------------------------------------------
    # return
    # ------------------------------------------------------------
    lw    s4, 26(sp)
    lw    s3, 27(sp)
    lw    s2, 28(sp)
    lw    s1, 29(sp)
    lw    ra, 30(sp)
    lw    s0, 31(sp)
    addi  sp, sp, 32
    jalr  x0, ra, 0