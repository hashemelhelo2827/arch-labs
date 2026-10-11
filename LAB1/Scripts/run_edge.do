# ============================================================
#  Computer Architecture Lab #1 - ALU EDGE-CASE TESTBENCH
#  File : run_edge.do
#  Usage: compile work.alu, load it, then:  do Scripts/run_edge.do
#  Every vector uses boundary values (0000/FFFF/8000/0001/5555/AAAA)
#  and both Cin levels for the carry operations.
# ============================================================

# Restart simulation
restart -f

# Set Hex radix globally
radix hex

# Add top-level signals
add wave -position insertpoint sim:/alu/*

# Enable logging
log -r /*

# ============================================================
# Part A  (S = 0..3) : not implemented -> F = 0000, Cout = 0
# ============================================================
force -freeze sim:/alu/A 16#FFFF 0
force -freeze sim:/alu/B 16#FFFF 0
force -freeze sim:/alu/Cin 1 0
force -freeze sim:/alu/S 16#0 0
run 100 ns
force -freeze sim:/alu/S 16#3 0
run 100 ns

# ============================================================
# Part B : bitwise logic
# ============================================================
# S=4 (0100)  F = A and B
force -freeze sim:/alu/S 16#4 0
force -freeze sim:/alu/A 16#FFFF 0
force -freeze sim:/alu/B 16#0000 0
run 100 ns

force -freeze sim:/alu/A 16#AAAA 0
force -freeze sim:/alu/B 16#5555 0
run 100 ns

# S=5 (0101)  F = A or B
force -freeze sim:/alu/S 16#5 0
run 100 ns

force -freeze sim:/alu/A 16#0000 0
force -freeze sim:/alu/B 16#0000 0
run 100 ns

# S=6 (0110)  F = A xor B
force -freeze sim:/alu/S 16#6 0
force -freeze sim:/alu/A 16#AAAA 0
force -freeze sim:/alu/B 16#5555 0
run 100 ns

force -freeze sim:/alu/A 16#FFFF 0
force -freeze sim:/alu/B 16#FFFF 0
run 100 ns

# S=7 (0111)  F = not A
force -freeze sim:/alu/S 16#7 0
force -freeze sim:/alu/A 16#0000 0
run 100 ns

force -freeze sim:/alu/A 16#FFFF 0
run 100 ns

force -freeze sim:/alu/A 16#5555 0
run 100 ns

# ============================================================
# Part C : right shifts / rotates
# ============================================================
# S=8 (1000)  logic shift right A
force -freeze sim:/alu/S 16#8 0
force -freeze sim:/alu/A 16#0000 0
run 100 ns

force -freeze sim:/alu/A 16#0001 0
run 100 ns

force -freeze sim:/alu/A 16#8000 0
run 100 ns

force -freeze sim:/alu/A 16#FFFF 0
run 100 ns

# S=9 (1001)  rotate right A
force -freeze sim:/alu/S 16#9 0
force -freeze sim:/alu/A 16#0000 0
run 100 ns

force -freeze sim:/alu/A 16#0001 0
run 100 ns

force -freeze sim:/alu/A 16#8000 0
run 100 ns

force -freeze sim:/alu/A 16#FFFF 0
run 100 ns

# S=A (1010)  rotate right A with carry  (Cin swept)
force -freeze sim:/alu/S 16#A 0
force -freeze sim:/alu/A 16#0000 0
force -freeze sim:/alu/Cin 0 0
run 100 ns

force -freeze sim:/alu/Cin 1 0
run 100 ns

force -freeze sim:/alu/A 16#8000 0
force -freeze sim:/alu/Cin 0 0
run 100 ns

force -freeze sim:/alu/Cin 1 0
run 100 ns

force -freeze sim:/alu/A 16#FFFF 0
force -freeze sim:/alu/Cin 0 0
run 100 ns

force -freeze sim:/alu/A 16#0001 0
force -freeze sim:/alu/Cin 1 0
run 100 ns

# S=B (1011)  arithmetic shift right A
force -freeze sim:/alu/S 16#B 0
force -freeze sim:/alu/A 16#0000 0
run 100 ns

force -freeze sim:/alu/A 16#7FFF 0
run 100 ns

force -freeze sim:/alu/A 16#8000 0
run 100 ns

force -freeze sim:/alu/A 16#FFFF 0
run 100 ns

# ============================================================
# Part D : left shifts / rotates
# ============================================================
# S=C (1100)  logic shift left A
force -freeze sim:/alu/S 16#C 0
force -freeze sim:/alu/A 16#0000 0
run 100 ns

force -freeze sim:/alu/A 16#0001 0
run 100 ns

force -freeze sim:/alu/A 16#8000 0
run 100 ns

force -freeze sim:/alu/A 16#FFFF 0
run 100 ns

# S=D (1101)  rotate left A
force -freeze sim:/alu/S 16#D 0
force -freeze sim:/alu/A 16#0000 0
run 100 ns

force -freeze sim:/alu/A 16#0001 0
run 100 ns

force -freeze sim:/alu/A 16#8000 0
run 100 ns

force -freeze sim:/alu/A 16#FFFF 0
run 100 ns

# S=E (1110)  rotate left A with carry  (Cin swept)
force -freeze sim:/alu/S 16#E 0
force -freeze sim:/alu/A 16#0000 0
force -freeze sim:/alu/Cin 0 0
run 100 ns

force -freeze sim:/alu/Cin 1 0
run 100 ns

force -freeze sim:/alu/A 16#8000 0
force -freeze sim:/alu/Cin 0 0
run 100 ns

force -freeze sim:/alu/Cin 1 0
run 100 ns

# S=F (1111)  F = 0000
force -freeze sim:/alu/S 16#F 0
force -freeze sim:/alu/A 16#FFFF 0
run 100 ns

force -freeze sim:/alu/A 16#0000 0
run 100 ns

# Zoom wave view
wave zoom full
