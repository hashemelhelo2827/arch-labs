# ============================================================================
#  Computer Architecture Lab #2  --  ASSIGNMENT test cases   (n = 8)
#  Table  : "To Test the Assignment"   (page 2)  -- Parts A, B, C, D
#  Target : entity ALU             (rtl/partD.vhd)
#  Usage  : from the LAB2 folder, in the ModelSim transcript:
#               do Scripts/run.do
#
#  The width is taken from the generic, overridden at elaboration with -gn=8
#  (lecture slide 28: "vsim my_nadder -gn=8").
# ============================================================================

# --- compile + elaborate with n = 8 -----------------------------------------
vlib work
vmap work work
vcom rtl/partA.vhd rtl/partB.vhd rtl/partC.vhd rtl/partD.vhd
vsim -gn=8 work.ALU

# --- view / logging ---------------------------------------------------------
restart -f
radix hex
if {[catch {add wave -position insertpoint sim:/alu/*}]} {}
log -r /*

# --- self-check helpers -----------------------------------------------------
set passes 0
set fails  0

proc hexval {v} {
    set v [string toupper [string trim $v]]
    regsub -all {[^0-9A-F]} $v "" v
    if {$v eq ""} { return -1 }
    return [expr "0x$v"]
}

proc chk {name f_exp c_exp} {
    global passes fails
    set f  [hexval [examine -hex sim:/alu/F]]
    set c  [hexval [examine -hex sim:/alu/Cout]]
    set fe [hexval $f_exp]
    set ce [hexval $c_exp]
    set fs "?" ; if {$f >= 0} { set fs [format %X $f] }
    set cs "?" ; if {$c >= 0} { set cs [format %X $c] }
    if {$f == $fe && $c == $ce} {
        echo [format "  PASS  %-14s F=%s Cout=%s" $name $f_exp $c_exp]
        incr passes
    } else {
        echo [format "  FAIL  %-14s got F=%s Cout=%s (expected F=%s Cout=%s)" \
              $name $fs $cs $f_exp $c_exp]
        incr fails
    }
    return
}

echo "===================== ASSIGNMENT  (n = 8) ====================="

# ------------------------------------------------------------------ PART A ---
# S=0, Cin=0   F = A
force -freeze sim:/alu/S   16#0 0
force -freeze sim:/alu/A   16#0F 0
force -freeze sim:/alu/B   16#00 0
force -freeze sim:/alu/Cin 0 0
run 100 ns ; chk "F = A"        0F 0

# S=1, Cin=0   F = A + B
force -freeze sim:/alu/S 16#1 0
force -freeze sim:/alu/A 16#0F 0
force -freeze sim:/alu/B 16#01 0
run 100 ns ; chk "F = A+B"      10 0

# S=1, Cin=0   F = A + B   (carry)
force -freeze sim:/alu/A 16#FF 0
run 100 ns ; chk "F = A+B cy"   00 1

# S=2, Cin=0   F = A - B - 1
force -freeze sim:/alu/S 16#2 0
force -freeze sim:/alu/A 16#FF 0
run 100 ns ; chk "F = A-B-1"    FD 1

# S=3, Cin=0   F = A - 1
force -freeze sim:/alu/S 16#3 0
force -freeze sim:/alu/A 16#FF 0
force -freeze sim:/alu/B 16#00 0
run 100 ns ; chk "F = A-1"      FE 1

# S=0, Cin=1   F = A + 1
force -freeze sim:/alu/S   16#0 0
force -freeze sim:/alu/A   16#0E 0
force -freeze sim:/alu/Cin 1 0
run 100 ns ; chk "F = A+1"      0F 0

# S=1, Cin=1   F = A + B + 1
force -freeze sim:/alu/S 16#1 0
force -freeze sim:/alu/A 16#FF 0
force -freeze sim:/alu/B 16#01 0
run 100 ns ; chk "F = A+B+1"    01 1

# S=2, Cin=1   F = A - B
force -freeze sim:/alu/S 16#2 0
force -freeze sim:/alu/A 16#0F 0
run 100 ns ; chk "F = A-B"      0E 1

# S=3, Cin=1   F = 0
force -freeze sim:/alu/S 16#3 0
force -freeze sim:/alu/A 16#F0 0
run 100 ns ; chk "F = 0"        00 0

# ------------------------------------------------------------------ PART B ---
# S=4   F = A and B
force -freeze sim:/alu/S 16#4 0
force -freeze sim:/alu/A 16#F5 0
force -freeze sim:/alu/B 16#AA 0
run 100 ns ; chk "F = A and B"  A0 0

# S=5   F = A or B
force -freeze sim:/alu/S 16#5 0
run 100 ns ; chk "F = A or B"   FF 0

# S=6   F = A nor B
force -freeze sim:/alu/S 16#6 0
run 100 ns ; chk "F = A nor B"  00 0

# S=7   F = not A
force -freeze sim:/alu/S 16#7 0
force -freeze sim:/alu/B 16#00 0
run 100 ns ; chk "F = not A"    0A 0

# ------------------------------------------------------------------ PART C ---
# S=8   logic shift right A
force -freeze sim:/alu/S 16#8 0
force -freeze sim:/alu/A 16#F5 0
run 100 ns ; chk "LSR A"        7A 1

# S=9   rotate right A
force -freeze sim:/alu/S 16#9 0
run 100 ns ; chk "ROR A"        FA 1

# S=A   rotate right A with carry, Cin=0
force -freeze sim:/alu/S  16#A 0
force -freeze sim:/alu/Cin 0 0
run 100 ns ; chk "RORC A C0"    7A 1

# S=A   rotate right A with carry, Cin=1
force -freeze sim:/alu/Cin 1 0
run 100 ns ; chk "RORC A C1"    FA 1

# S=B   arithmetic shift right A
force -freeze sim:/alu/S 16#B 0
run 100 ns ; chk "ASR A"        FA 1

# S=9   rotate right A  (extra vector: 7A -> 3D)
force -freeze sim:/alu/S 16#9 0
force -freeze sim:/alu/A 16#7A 0
run 100 ns ; chk "ROR 7A"       3D 0

# ------------------------------------------------------------------ PART D ---
# S=C   logic shift left A
force -freeze sim:/alu/S 16#C 0
force -freeze sim:/alu/A 16#F5 0
force -freeze sim:/alu/Cin 0 0
run 100 ns ; chk "LSL A"        EA 1

# S=D   rotate left A
force -freeze sim:/alu/S 16#D 0
run 100 ns ; chk "ROL A"        EB 1

# S=E   rotate left A with carry, Cin=0
force -freeze sim:/alu/S  16#E 0
force -freeze sim:/alu/Cin 0 0
run 100 ns ; chk "ROLC A C0"    EA 1

# S=E   rotate left A with carry, Cin=1
force -freeze sim:/alu/Cin 1 0
run 100 ns ; chk "ROLC A C1"    EB 1

# S=F   F = 0000
force -freeze sim:/alu/S 16#F 0
run 100 ns ; chk "F = 0000"     00 0

echo "==============================================================="
echo [format "  RESULT: %d passed, %d failed" $passes $fails]
echo "==============================================================="
if {[catch {wave zoom full}]} {}
