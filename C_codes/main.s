	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	modify_register
	.type	modify_register, @function
modify_register:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	lw	a5,-36(s0)
	lw	a5,0(a5)
	sw	a5,-20(s0)
	lw	a5,-40(s0)
	not	a5,a5
	lw	a4,-20(s0)
	and	a5,a4,a5
	sw	a5,-24(s0)
	lw	a5,-44(s0)
	lw	a4,-48(s0)
	sll	a5,a4,a5
	lw	a4,-24(s0)
	or	a5,a4,a5
	sw	a5,-28(s0)
	lw	a5,-36(s0)
	lw	a4,-28(s0)
	sw	a4,0(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	modify_register, .-modify_register
	.align	2
	.globl	read_register_field
	.type	read_register_field, @function
read_register_field:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	lw	a5,-36(s0)
	lw	a5,0(a5)
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	and	a4,a4,a5
	lw	a5,-44(s0)
	srl	a5,a4,a5
	sw	a5,-24(s0)
	lw	a5,-24(s0)
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	read_register_field, .-read_register_field
	.align	2
	.globl	parse_command
	.type	parse_command, @function
parse_command:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a2,0
	li	a1,255
	li	a5,4096
	addi	a0,a5,-917
	call	read_register_field
	sw	a0,-20(s0)
	li	a2,8
	li	a5,65536
	addi	a1,a5,-256
	li	a5,4096
	addi	a0,a5,-917
	call	read_register_field
	sw	a0,-24(s0)
	li	a2,16
	li	a1,16711680
	li	a5,4096
	addi	a0,a5,-917
	call	read_register_field
	sw	a0,-28(s0)
	li	a5,4096
	addi	a5,a5,-865
	lw	a5,0(a5)
	li	a4,4
	beq	a5,a4,.L5
	li	a4,4
	bgtu	a5,a4,.L70
	li	a4,2
	beq	a5,a4,.L7
	li	a4,2
	bgtu	a5,a4,.L70
	beq	a5,zero,.L8
	li	a4,1
	beq	a5,a4,.L9
	j	.L70
.L8:
	lw	a4,-20(s0)
	li	a5,4
	bne	a4,a5,.L71
	lw	a4,-24(s0)
	li	a5,2
	beq	a4,a5,.L11
	lw	a4,-24(s0)
	li	a5,2
	bgtu	a4,a5,.L72
	lw	a5,-24(s0)
	beq	a5,zero,.L13
	lw	a4,-24(s0)
	li	a5,1
	beq	a4,a5,.L14
	j	.L72
.L13:
	li	a3,1
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L15
.L14:
	li	a3,2
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L15
.L11:
	li	a3,4
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L15
.L72:
	nop
.L15:
	j	.L16
.L71:
	nop
.L16:
	j	.L17
.L9:
	lw	a4,-20(s0)
	li	a5,5
	beq	a4,a5,.L18
	lw	a4,-20(s0)
	li	a5,5
	bgtu	a4,a5,.L73
	lw	a4,-20(s0)
	li	a5,4
	beq	a4,a5,.L20
	lw	a4,-20(s0)
	li	a5,4
	bgtu	a4,a5,.L73
	lw	a4,-20(s0)
	li	a5,1
	beq	a4,a5,.L21
	lw	a4,-20(s0)
	li	a5,2
	beq	a4,a5,.L22
	j	.L73
.L21:
	lw	a4,-24(s0)
	li	a5,1
	beq	a4,a5,.L23
	lw	a4,-24(s0)
	li	a5,2
	beq	a4,a5,.L24
	j	.L26
.L23:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	li	a3,1
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	j	.L26
.L24:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	li	a3,0
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	nop
.L26:
	j	.L27
.L22:
	lw	a4,-24(s0)
	li	a5,5
	beq	a4,a5,.L28
	lw	a4,-24(s0)
	li	a5,6
	beq	a4,a5,.L29
	j	.L31
.L28:
	li	a3,1750
	li	a2,0
	li	a5,65536
	addi	a1,a5,-1
	li	a5,4096
	addi	a0,a5,-961
	call	modify_register
	j	.L31
.L29:
	li	a3,1250
	li	a2,0
	li	a5,65536
	addi	a1,a5,-1
	li	a5,4096
	addi	a0,a5,-961
	call	modify_register
	nop
.L31:
	j	.L27
.L20:
	lw	a4,-24(s0)
	li	a5,2
	beq	a4,a5,.L32
	lw	a4,-24(s0)
	li	a5,2
	bgtu	a4,a5,.L74
	lw	a5,-24(s0)
	beq	a5,zero,.L34
	lw	a4,-24(s0)
	li	a5,1
	beq	a4,a5,.L35
	j	.L74
.L34:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	li	a3,1
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L36
.L35:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,2
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L36
.L32:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,4
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L36
.L74:
	nop
.L36:
	j	.L27
.L18:
	li	a3,1
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	j	.L27
.L73:
	nop
.L27:
	j	.L17
.L7:
	lw	a4,-20(s0)
	li	a5,5
	beq	a4,a5,.L37
	lw	a4,-20(s0)
	li	a5,5
	bgtu	a4,a5,.L75
	lw	a4,-20(s0)
	li	a5,1
	beq	a4,a5,.L39
	lw	a4,-20(s0)
	li	a5,4
	beq	a4,a5,.L40
	j	.L75
.L39:
	lw	a4,-24(s0)
	li	a5,3
	beq	a4,a5,.L41
	lw	a4,-24(s0)
	li	a5,4
	beq	a4,a5,.L42
	j	.L44
.L41:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,1
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	j	.L44
.L42:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,0
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	nop
.L44:
	j	.L45
.L40:
	lw	a4,-24(s0)
	li	a5,2
	beq	a4,a5,.L46
	lw	a4,-24(s0)
	li	a5,2
	bgtu	a4,a5,.L76
	lw	a5,-24(s0)
	beq	a5,zero,.L48
	lw	a4,-24(s0)
	li	a5,1
	beq	a4,a5,.L49
	j	.L76
.L48:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,1
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L50
.L49:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,2
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L50
.L46:
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,4
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L50
.L76:
	nop
.L50:
	j	.L45
.L37:
	li	a3,1
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	j	.L45
.L75:
	nop
.L45:
	j	.L17
.L5:
	lw	a4,-20(s0)
	li	a5,5
	beq	a4,a5,.L77
	lw	a4,-20(s0)
	li	a5,5
	bgtu	a4,a5,.L78
	lw	a4,-20(s0)
	li	a5,3
	beq	a4,a5,.L53
	lw	a4,-20(s0)
	li	a5,4
	beq	a4,a5,.L54
	j	.L78
.L53:
	lw	a4,-28(s0)
	li	a5,6
	bgtu	a4,a5,.L79
	lw	a5,-28(s0)
	slli	a4,a5,2
	lui	a5,%hi(.L57)
	addi	a5,a5,%lo(.L57)
	add	a5,a4,a5
	lw	a5,0(a5)
	jr	a5
	.section	.rodata
	.align	2
	.align	2
.L57:
	.word	.L79
	.word	.L79
	.word	.L79
	.word	.L79
	.word	.L79
	.word	.L79
	.word	.L79
	.text
.L79:
	nop
	j	.L64
.L54:
	lw	a4,-24(s0)
	li	a5,2
	beq	a4,a5,.L65
	lw	a4,-24(s0)
	li	a5,2
	bgtu	a4,a5,.L80
	lw	a5,-24(s0)
	beq	a5,zero,.L67
	lw	a4,-24(s0)
	li	a5,1
	beq	a4,a5,.L68
	j	.L80
.L67:
	li	a3,1
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L69
.L68:
	li	a3,2
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L69
.L65:
	li	a3,4
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	j	.L69
.L80:
	nop
.L69:
	j	.L64
.L77:
	nop
	j	.L17
.L78:
	nop
.L64:
	j	.L17
.L70:
	nop
.L17:
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	parse_command, .-parse_command
	.align	2
	.globl	initialize_nrf_module
	.type	initialize_nrf_module, @function
initialize_nrf_module:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a3,27
	li	a2,0
	li	a5,65536
	addi	a1,a5,-1
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L82:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L82
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,8192
	addi	a3,a5,15
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L83:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L83
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,8192
	addi	a3,a5,257
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L84:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L84
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,8192
	addi	a3,a5,513
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L85:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L85
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,8192
	addi	a3,a5,769
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L86:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L86
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,8192
	addi	a3,a5,1024
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L87:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L87
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,8192
	addi	a3,a5,1356
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L88:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L88
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,8192
	addi	a3,a5,1542
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L89:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L89
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,8192
	addi	a3,a5,1904
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L90:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L90
	li	a3,4
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,715829248
	addi	a3,a5,-1366
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L91:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L91
	li	a3,2
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a5,12288
	addi	a3,a5,288
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
.L92:
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-925
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L92
	li	a3,1
	li	a2,16
	li	a1,983040
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a3,226
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-921
	call	modify_register
	li	a3,1
	li	a2,24
	li	a1,16777216
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	initialize_nrf_module, .-initialize_nrf_module
	.align	2
	.globl	receive_data
	.type	receive_data, @function
receive_data:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a3,27
	li	a2,0
	li	a5,65536
	addi	a1,a5,-1
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a3,3
	li	a2,20
	li	a1,15728640
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a3,1
	li	a2,25
	li	a1,33554432
	li	a5,4096
	addi	a0,a5,-929
	call	modify_register
	li	a3,0
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-893
	call	modify_register
	nop
.L95:
	li	a2,25
	li	a1,33554432
	li	a5,4096
	addi	a0,a5,-929
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L95
	call	parse_command
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	receive_data, .-receive_data
	.align	2
	.globl	initialize_system
	.type	initialize_system, @function
initialize_system:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a3,0
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-865
	call	modify_register
	li	a3,1
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	li	a3,511
	li	a2,1
	li	a1,1022
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-1025
	call	modify_register
	li	a3,1
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,511
	li	a2,1
	li	a1,1022
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,0
	li	a2,10
	li	a1,1024
	li	a5,4096
	addi	a0,a5,-993
	call	modify_register
	li	a3,1500
	li	a2,0
	li	a5,65536
	addi	a1,a5,-1
	li	a5,4096
	addi	a0,a5,-961
	call	modify_register
	li	a3,0
	li	a2,16
	li	a1,65536
	li	a5,4096
	addi	a0,a5,-961
	call	modify_register
	call	initialize_nrf_module
	li	a3,0
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-861
	call	modify_register
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	initialize_system, .-initialize_system
	.align	2
	.globl	main
	.type	main, @function
main:
    addi sp , x0 , 255
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	call	initialize_system
.L100:
	li	a2,0
	li	a1,-1
	li	a5,4096
	addi	a0,a5,-861
	call	read_register_field
	mv	a5,a0
	bne	a5,zero,.L98
	li	a2,0
	li	a1,1
	li	a5,4096
	addi	a0,a5,-893
	call	read_register_field
	mv	a5,a0
	beq	a5,zero,.L100
	call	receive_data
	j	.L100
.L98:
	call	initialize_system
	j	.L100
	.size	main, .-main
	.ident	"GCC: (GNU) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
