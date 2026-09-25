restart -f

force -freeze sim:/alu/S 0100 0
force -freeze sim:/alu/A 0000000000001111 0
force -freeze sim:/alu/B 0000000000000011 0
run 100 ns

force -freeze sim:/alu/Cin 1 0
force -freeze sim:/alu/A 0101001101001010 0
force -freeze sim:/alu/B 1010001001001011 0
run 100 ns

force -freeze sim:/alu/S 0101 0
run 100 ns

force -freeze sim:/alu/S 0110 0
run 100 ns

force -freeze sim:/alu/S 0111 0
run 100 ns

force -freeze sim:/alu/S 1000 0
run 100 ns

force -freeze sim:/alu/S 1001 0
run 100 ns

force -freeze sim:/alu/S 1010 0
run 100 ns

force -freeze sim:/alu/S 1011 0
run 100 ns

force -freeze sim:/alu/S 1100 0
run 100 ns

force -freeze sim:/alu/S 1101 0
run 100 ns

force -freeze sim:/alu/S 1110 0
run 100 ns

force -freeze sim:/alu/S 1111 0
run 100 ns