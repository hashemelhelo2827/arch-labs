# Restart simulation
restart -f

# Set Hex radix globally
radix hex

# Add top-level signals
add wave -position insertpoint sim:/alu/*

# Enable logging
log -r /*

# --- Part B Tests ---
# S = 0100 (4 in hex)
force -freeze sim:/alu/S 16#4 0
force -freeze sim:/alu/A 16#F00F 0
force -freeze sim:/alu/B 16#000A 0
force -freeze sim:/alu/Cin 0 0
run 100 ns

force -freeze sim:/alu/Cin 1 0
run 100 ns

# S = 0101 (5 in hex)
force -freeze sim:/alu/S 16#5 0
run 100 ns

# S = 0110 (6 in hex)
force -freeze sim:/alu/S 16#6 0
run 100 ns

# S = 0111 (7 in hex)
force -freeze sim:/alu/S 16#7 0
run 100 ns

# --- Part C Tests ---
# S = 1000 (8 in hex)
force -freeze sim:/alu/S 16#8 0
run 100 ns

# S = 1001 (9 in hex)
force -freeze sim:/alu/S 16#9 0
run 100 ns

# S = 1010 (A in hex)
force -freeze sim:/alu/S 16#A 0
run 100 ns

# S = 1010 (A in hex) with Cin = 0
force -freeze sim:/alu/Cin 0 0
run 100 ns

# S = 1011 (B in hex)
force -freeze sim:/alu/S 16#B 0
run 100 ns

# --- Part D Tests ---
# S = 1100 (C in hex)
force -freeze sim:/alu/S 16#C 0
run 100 ns

# S = 1101 (D in hex)
force -freeze sim:/alu/S 16#D 0
run 100 ns

# S = 1110 (E in hex)
force -freeze sim:/alu/S 16#E 0
run 100 ns

# S = 1110 (E in hex) with Cin = 1
force -freeze sim:/alu/Cin 1 0
run 100 ns

# S = 1111 (F in hex)
force -freeze sim:/alu/S 16#F 0
run 100 ns

# Zoom wave view
wave zoom full