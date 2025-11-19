base_test:
	riscv64-unknown-elf-gcc -g -O0 -march=rv32ima -mabi=ilp32 -nostdlib -T cpu.ld -o base_test.elf base_test.c
	riscv64-unknown-elf-objcopy -O verilog base_test.elf loadfile_all.img
	riscv64-unknown-elf-objdump -d -M no-aliases -M numeric base_test.elf > base_test_disasm.txt
	riscv64-unknown-elf-gcc -S -O0 -march=rv32ima -mabi=ilp32 -nostdlib -Wa,-r base_test.c -o base_test.s

test_2:
	riscv64-unknown-elf-gcc -g -O0 -march=rv32i -mabi=ilp32 -nostdlib -T cpu.ld -o test_2.elf test_2.c -lgcc
	riscv64-unknown-elf-objcopy -O verilog test_2.elf loadfile_all.img
	riscv64-unknown-elf-objdump -d -M no-aliases -M numeric test_2.elf > test_2_disasm.txt
	riscv64-unknown-elf-gcc -S -O0 -march=rv32i -mabi=ilp32 -nostdlib -Wa,-r test_2.c -o test_2.s -lgcc

junk:
	riscv64-unknown-elf-gcc -g -o junk.elf junk.s -O0 -march=rv32ima -mabi=ilp32 -nostdlib -T cpu.ld
	riscv64-unknown-elf-objcopy -O verilog junk.elf loadfile_all.img

clean:
	rm -f base_test.elf test_2.elf base_test.s test_2.s base_test_disasm.txt test_2_disasm.txt loadfile_all.img 
