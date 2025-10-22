_start:
        addi x2, x0, 0xff
	jal x1, 0x20
	and x5, x5, x4
        or x6, x2, x5
        lui x7, 0x11100 # equals 0x100000
        addi x7, x7, 0x0000
        addi x8, x7, 0xf # should equal 0x10000f
        lui x9, 0x00001
	addi x2, x0, 0xff
	addi x2, x0, 0x1
	addi x2, x0, 0x2
	addi x2, x0, 0x3
	addi x2, x0, 0x4
	jalr x1, x1, 0x0
	
	add x10, x7, x9
	lw
	sw
