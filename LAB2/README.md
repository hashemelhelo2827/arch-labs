# arch-lab-2

Computer Architecture Lab #2 — an **n-bit ALSU** (arithmetic / logic / shift unit) written in VHDL
and verified in ModelSim (Intel FPGA Edition). The width is a generic `n`, set at elaboration with
`-gn=8` for the lab test vectors.

## Modules

| Entity | File | Function |
| --- | --- | --- |
| `ALU` | `LAB2/rtl/partD.vhd` | Top level. 4-bit select `S`, n-bit operands `A`/`B`, `Cin` → `F`, `Cout`. Instantiates the four parts; `S(3:2)` selects the part, `S(1:0)` the operation. |
| `PARTA` | `LAB2/rtl/partA.vhd` | Arithmetic unit. `A`, `A+B`, `A-B`, `A-1`, `A+1`, `A+B+1`, `A-B-1`, `F=0` — built from one full adder reused with `for … generate`. |
| `adder` | `LAB2/rtl/partA.vhd` | 1-bit full adder with a B-invert control `E`. |
| `PARTB` | `LAB2/rtl/partB.vhd` | Logic unit: `A and B`, `A or B`, `A nor B`, `not A`. |
| `PARTC` | `LAB2/rtl/partC.vhd` | Right-shift unit: logic shift right, rotate right, rotate right through carry, arithmetic shift right. |
| `PARTD` | `LAB2/rtl/partD.vhd` | Left-shift unit: logic shift left, rotate left, rotate left through carry, clear to 0. |

### Select map

`S(3:2)` picks the part; `S(1:0)` picks the operation inside it.

| `S(3:2)` | Part | `S(1:0)=00` | `01` | `10` | `11` |
| --- | --- | --- | --- | --- | --- |
| `00` | PARTA | `A` / `A+1` (Cin) | `A+B` / `A+B+1` | `A-B-1` / `A-B` | `A-1` / `0` |
| `01` | PARTB | `A and B` | `A or B` | `A nor B` | `not A` |
| `10` | PARTC | logic shift right | rotate right | rotate right w/ carry | arithmetic shift right |
| `11` | PARTD | logic shift left | rotate left | rotate left w/ carry | clear to 0 |

## Test scripts

| File | Target | Vectors |
| --- | --- | --- |
| `LAB2/Scripts/run_partA.do` | `PARTA` | 9 — the "To test part A" table |
| `LAB2/Scripts/run.do` | `ALU` | 24 — the "To Test the Assignment" table (parts A + B + C + D) |

Each script compiles the sources, elaborates with `-gn=8`, forces every input, runs, and
self-checks `F`/`Cout` with `examine`, printing a `PASS`/`FAIL` line per vector plus a final tally.

In ModelSim, from the `LAB2` folder:

```tcl
cd {C:/Users/hashe/Desktop/ARCH_LABS/LAB2}
do Scripts/run_partA.do      ;# RESULT: 9 passed, 0 failed
do Scripts/run.do            ;# RESULT: 24 passed, 0 failed
```

## Layout

```
LAB2/
├── rtl/                # Design sources (source of truth)
│   ├── partA.vhd       # PARTA + adder
│   ├── partB.vhd       # PARTB
│   ├── partC.vhd       # PARTC
│   ├── partD.vhd       # PARTD + ALU (top)
│   └── ALU.vhd         # ALU (standalone copy)
├── Scripts/            # ModelSim do files
│   ├── run.do
│   ├── run_partA.do
│   └── README.md
└── sim/
    └── multism.vhd     # Combined single-file design (all entities)
```

## Notes

- `rtl/` is the source of truth; `sim/multism.vhd` is the equivalent one-file copy (now including
  the `ALU` top). Compile one set, not both — they define the same entities.
- The width comes from the generic `n`: `vsim -gn=8 work.ALU` (or `work.PARTA`) selects the 8-bit
  lab configuration.
- `rtl/ALU.vhd` and `rtl/partD.vhd` both define `ALU` (a leftover); the scripts compile
  `partA|partB|partC|partD`, so the `ALU` used is the one in `partD.vhd`.
- Fixes applied for this lab: PARTD undefined `S1`/`S0` → `S = "11"` and hardcoded `A(14 DOWNTO 0)`
  → `A(n-2 DOWNTO 0)`; PARTB `xor` → `nor`; PARTA multiple driver on `F` and the
  `S="11", Cin=1 → F=0` case; `with … select` choices fixed to `when "00" … when others`.
