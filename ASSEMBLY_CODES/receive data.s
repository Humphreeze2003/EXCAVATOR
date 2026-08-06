
























# void receive_data()
#
# Register usage:
#   s1 = SPI_BASE_ADDRESS (0x0C5F)
#   s2 = NRF24_BASE_ADDRESS (0x0C7F)

RECEIVE_DATA:
    addi  sp, sp, -32          # create stack frame
    sw    s0, 31(sp)
    addi  s0, sp, 0            # frame pointer (unused)
    sw    ra, 30(sp)
    sw    s1, 29(sp)
    sw    s2, 28(sp)

    # Load base addresses
    # SPI_BASE_ADDRESS = 0x0C5F
    lui   s1, 0x1
    addi  s1, s1, -0x3A1       # 0x1000 - 0x3A1 = 0x0C5F

    # NRF24_BASE_ADDRESS = 0x0C7F
    lui   s2, 0x1
    addi  s2, s2, -0x381       # 0x1000 - 0x381 = 0x0C7F

    # ------------------------------------------------------------
    # 1) Set SPI frequency to 1 MHz (count = 27)
    #    modify_register(SPI_BASE_ADDRESS, 0xffff, 0, 27)
    # ------------------------------------------------------------
    addi  a0, s1, 0
    lui   a1, 0x10             # a1 = 0x10000
    addi  a1, a1, -1           # a1 = 0x0FFFF (mask = 0xFFFF)
    addi  a2, x0, 0
    addi  a3, x0, 27
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 2) Set number of bytes to receive: 3
    #    modify_register(SPI_BASE_ADDRESS, (0xf << 20), 20, 3)
    #    mask = 0x00F00000
    # ------------------------------------------------------------
    addi  a0, s1, 0
    lui   a1, 0xF00            # a1 = 0x00F00000 (since 0xF00 << 12 = 0x00F00000)
    addi  a2, x0, 20
    addi  a3, x0, 3
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 3) Assert RX in control register (bit 25)
    #    modify_register(SPI_BASE_ADDRESS, (0x1 << 25), 25, 1)
    #    mask = 0x02000000
    # ------------------------------------------------------------
    addi  a0, s1, 0
    lui   a1, 0x2000           # a1 = 0x02000000 (0x2000 << 12 = 0x2000000 = 0x02000000)
    addi  a2, x0, 25
    addi  a3, x0, 1
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 4) Reset IRQ bit in NRF24 status register
    #    modify_register(&NRF24_BASE_ADDRESS[1], 0x1, 0, 0)
    #    address = s2 + 1 (word-addressed)
    # ------------------------------------------------------------
    addi  a0, s2, 1            # &NRF24_BASE_ADDRESS[1]
    addi  a1, x0, 1
    addi  a2, x0, 0
    addi  a3, x0, 0
    jal   ra, MODIFY_REGISTER

    # ------------------------------------------------------------
    # 5) Wait while RX is still busy (bit 25 set)
    #    while (read_register_field(SPI_BASE_ADDRESS, (0x1 << 25), 25)) { }
    # ------------------------------------------------------------
WAIT_RX_DONE:
    addi  a0, s1, 0
    lui   a1, 0x2000           # mask = 0x02000000
    addi  a2, x0, 25
    jal   ra, READ_REGISTER_FIELD
    bne   a0, x0, WAIT_RX_DONE   # if result != 0, loop

    # ------------------------------------------------------------
    # 6) Parse the received command
    # ------------------------------------------------------------
    jal   ra, PARSE_COMMAND

    # ------------------------------------------------------------
    # Return
    # ------------------------------------------------------------
    lw    s2, 28(sp)
    lw    s1, 29(sp)
    lw    ra, 30(sp)
    lw    s0, 31(sp)
    addi  sp, sp, 32
    jalr  x0, ra, 0