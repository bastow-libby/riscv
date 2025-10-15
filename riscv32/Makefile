



test:
	riscv64-unknown-elf-gcc -g -o test.elf test.c -O0 -march=rv32ima -mabi=ilp32 -nostdlib -T cpu.ld
	riscv64-unknown-elf-objcopy -O verilog test.elf loadfile_all.img

junk:
	riscv64-unknown-elf-gcc -g -o junk.elf junk.s -O0 -march=rv32ima -mabi=ilp32 -nostdlib -T cpu.ld
	riscv64-unknown-elf-objcopy -O verilog junk.elf loadfile_all.img


clean:
	rm -f test.elf loadfile_all.img
