_start:
	addi x2, x0, 0xEE # 0xEE -> x2 used for the value
	addi x3, x0, 0xF # 0xF -> x3 used for address
	sw x2, 0(x3)
	addi x3, x0, 0xF
	lw x5, 0(x3)
	addi x6, x5, 0x00000
