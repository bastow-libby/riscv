_start:
	addi x1, x0, 0xff
	addi x2, x1, 1
	addi x3, x1, -1
	sub x4, x3, x2
	and x5, x5, x4
	or x6, x2, x5
	lui x7, 0x100 # equals 0x100000
	addi x7, x1, 0x0000
	addi x8, x7, 0xf # should equal 0x10000f
