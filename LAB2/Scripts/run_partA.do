# ============================================================================
#  Computer Architecture Lab #2  --  PART A test cases   (n = 8)
#  Table  : "To test part A use the following table, let n = 8"   (page 2)
#  Target : entity PARTA           (rtl/partA.vhd)
#  Usage  : from the LAB2 folder, in the ModelSim transcript:
#               do Scripts/run_partA.do
#
#  The width is taken from the generic, overridden at elaboration with -gn=8
#  (lecture slide 28: "vsim my_nadder -gn=8").
# ============================================================================

# --- compile + elaborate with n = 8 -----------------------------------------
vlib work
vmap work work
vcom rtl/partA.vhd
vsim -gn=8 work.PARTA

# --- view / logging ---------------------------------------------------------
restart -f
radix hex
if {[catch {add wave -position insertpoint sim:/parta/*}]} {}
log -r /*

# --- self-check helpers -----------------------------------------------------
set passes 0
set fails  0

# turn a displayed value (e.g. "0F", "1", "00000101") into an integer
proc hexval {v} {
    set v [string toupper [string trim $v]]
    regsub -all {[^0-9A-F]} $v "" v
    if {$v eq ""} { return -1 }
    return [expr "0x$v"]
}

proc chk {name f_exp c_exp} {
    global passes fails
    set f  [hexval [examine -hex sim:/parta/F]]
    set c  [hexval [examine -hex sim:/parta/Cout]]
    set fe [hexval $f_exp]
    set ce [hexval $c_exp]
    set fs "?" ; if {$f >= 0} { set fs [format %X $f] }
    set cs "?" ; if {$c >= 0} { set cs [format %X $c] }
    if {$f == $fe && $c == $ce} {
        echo [format "  PASS  %-10s F=%s Cout=%s" $name $f_exp $c_exp]
        incr passes
    } else {
        echo [format "  FAIL  %-10s got F=%s Cout=%s (expected F=%s Cout=%s)" \
              $name $fs $cs $f_exp $c_exp]
        incr fails
    }
    return
}

echo "===================== PART A  (n = 8) ====================="

# S=00, Cin=0   F = A
force -freeze sim:/parta/S   16#0 0
force -freeze sim:/parta/A   16#0F 0
force -freeze sim:/parta/B   16#00 0
force -freeze sim:/parta/Cin 0 0
run 100 ns ; chk "F = A"      0F 0

# S=01, Cin=0   F = A + B
force -freeze sim:/parta/S 16#1 0
force -freeze sim:/parta/A 16#0F 0
force -freeze sim:/parta/B 16#01 0
run 100 ns ; chk "F = A+B"    10 0

# S=01, Cin=0   F = A + B   (carry out)
force -freeze sim:/parta/A 16#FF 0
run 100 ns ; chk "F = A+Bcy"  00 1

# S=10, Cin=0   F = A - B - 1
force -freeze sim:/parta/S 16#2 0
force -freeze sim:/parta/A 16#FF 0
run 100 ns ; chk "F = A-B-1"  FD 1

# S=11, Cin=0   F = A - 1
force -freeze sim:/parta/S 16#3 0
force -freeze sim:/parta/A 16#FF 0
force -freeze sim:/parta/B 16#00 0
run 100 ns ; chk "F = A-1"    FE 1

# S=00, Cin=1   F = A + 1
force -freeze sim:/parta/S   16#0 0
force -freeze sim:/parta/A   16#0E 0
force -freeze sim:/parta/B   16#00 0
force -freeze sim:/parta/Cin 1 0
run 100 ns ; chk "F = A+1"    0F 0

# S=01, Cin=1   F = A + B + 1
force -freeze sim:/parta/S 16#1 0
force -freeze sim:/parta/A 16#FF 0
force -freeze sim:/parta/B 16#01 0
run 100 ns ; chk "F = A+B+1"  01 1

# S=10, Cin=1   F = A - B
force -freeze sim:/parta/S 16#2 0
force -freeze sim:/parta/A 16#0F 0
run 100 ns ; chk "F = A-B"    0E 1

# S=11, Cin=1   F = 0
force -freeze sim:/parta/S 16#3 0
force -freeze sim:/parta/A 16#F0 0
force -freeze sim:/parta/Cin 1 0
run 100 ns ; chk "F = 0"      00 0

echo "==========================================================="
echo [format "  RESULT: %d passed, %d failed" $passes $fails]
echo "==========================================================="
if {[catch {wave zoom full}]} {}
