# arch-labs

Computer architecture labs in VHDL — a 16-bit ALU built from logic, shift, and rotate units, verified in ModelSim.

## Modules

| Entity | File | Function |
| --- | --- | --- |
| `ALU` | `LAB1/rtl/ALU.vhd` | Top level. 4-bit select `S`, operands `A`/`B`, carry-in `Cin`, result `F`. Instantiates the three units plus a MUX. |
| `PARTB` | `LAB1/rtl/partB.vhd` | Logic unit: `AND`, `OR`, `XOR`, `NOT` on `A` and `B`, selected by `S(1:0)`. |
| `PARTC` | `LAB1/rtl/partC.vhd` | Shift unit: logical shift left, logical shift right, `Cin` bit insert, complement + rotate. |
| `PARTD` | `LAB1/rtl/partD.vhd` | Shift/rotate unit: shift left, rotate left, shift right, clear-to-zero. |
| `MUX4` | `LAB1/rtl/ALU.vhd` | 4:1 output multiplexer driven by `S(3:2)`, choosing between the `PARTB`/`PARTC`/`PARTD` results. |

### ALU select map

`S(3:2)` picks which unit feeds the output; `S(1:0)` then picks the operation inside that unit.

| `S(3:2)` | Active unit | `S(1:0)` = `00` | `01` | `10` | `11` |
| --- | --- | --- | --- | --- | --- |
| `00` | *none* | output forced to `0` | `0` | `0` | `0` |
| `01` | `PARTB` | `A and B` | `A or B` | `A xor B` | `not A` |
| `10` | `PARTC` | shift left | shift right | insert `Cin` | complement + rotate |
| `11` | `PARTD` | shift left | shift right (`Cin`) | rotate left | clear to `0` |

Note that `S(3:2) = 00` is not wired to a unit — `MUX4` drives the output to all zeros for that
range, so select codes `0000`–`0011` produce `F = 0` regardless of the operands. `run.do` only
exercises `0100`–`1111`, which is exactly the implemented range. If the lab spec calls for one of
the three functions on the lower codes, the `S(3:2)` decoding in `MUX4` is where to change it.

## Layout

```
LAB1/
├── rtl/               # Design sources
│   ├── ALU.vhd        # Top-level ALU + MUX4
│   ├── partB.vhd      # Logic unit
│   ├── partC.vhd      # Shift unit
│   └── partD.vhd      # Rotate unit
├── Scripts/
│   └── run.do         # ModelSim test script
└── sim/
    ├── multism.vhd    # Combined file for quick simulation
    └── wave           # ModelSim wave/signal configuration
```

## Running the simulation

`LAB1/Scripts/run.do` force-drives the ALU across twelve select codes, `0100` through `1111`,
covering all three implemented units.

In ModelSim:

```tcl
# compile the design
vlog ../rtl/ALU.vhd ../rtl/partB.vhd ../rtl/partC.vhd ../rtl/partD.vhd

# load the testbench and run the script
vsim work.multism
do run.do
```

Then add the signals from `wave` to inspect the results. The testbench instance is `alu`, so signal
paths are `/alu/S`, `/alu/A`, `/alu/B`, `/alu/Cin`, and `/alu/F`.

## Notes

The assignment PDFs (`Arch_Lab1.pdf`, `Arch_Lab1_Req.pdf`) are intentionally excluded via
`.gitignore`.

`LAB1/sim/multism.vhd` is a scratch file that concatenates copies of `PARTB`/`PARTC`/`PARTD` so the
design can be simulated as a single unit without re-listing every file. `LAB1/rtl/` is the source of
truth.
