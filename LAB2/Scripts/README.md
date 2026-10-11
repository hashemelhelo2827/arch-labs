# Lab #2 — test scripts

ModelSim/QuestaSim **do files** for the ALSU (n-bit ALU) of Computer
Architecture Lab #2. The width comes from the generic `n`, overridden at
elaboration with `-gn=8`:

```tcl
vsim -gn=8 work.PARTA        ;# Part A only      (rtl/partA.vhd)
vsim -gn=8 work.ALU          ;# integrated design (rtl/partD.vhd)
```

## Usage

From the `LAB2` folder, in the ModelSim transcript:

```tcl
do Scripts/run_partA.do      ;# Part A table  (9 cases,  entity PARTA)
do Scripts/run.do            ;# assignment    (24 cases, entity ALU)
```

Each script compiles the sources, elaborates with `n = 8`, forces every input,
runs, then **self-checks** `F`/`Cout` with `examine` and prints `PASS`/`FAIL`
per vector plus a final tally at the bottom of the transcript.

## Files

| File | Target | Vectors |
| --- | --- | --- |
| `run_partA.do` | `PARTA` | 9 — the "To test part A" table |
| `run.do` | `ALU` | 24 — the "To Test the Assignment" table (A + B + C + D) |

## Vector summary (n = 8)

**Part A** (`S(3:2)=00`, `S(1:0)` = `0..3`): `F=A`, `A+B`, `A-B-1`, `A-1`,
`A+1`, `A+B+1`, `A-B`, `F=0`.

**Assignment**

| `S` | Operation | A | B | Cin | F | Cout |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | AND | F5 | AA | – | A0 | 0 |
| 5 | OR | F5 | AA | – | FF | 0 |
| 6 | NOR | F5 | AA | – | 00 | 0 |
| 7 | NOT A | F5 | – | – | 0A | 0 |
| 8 | logic shift right | F5 | – | – | 7A | 1 |
| 9 | rotate right | F5 | – | – | FA | 1 |
| A | rotate right w/ carry | F5 | – | 0/1 | 7A / FA | 1 |
| B | arithmetic shift right | F5 | – | – | FA | 1 |
| C | logic shift left | F5 | – | – | EA | 1 |
| D | rotate left | F5 | – | – | EB | 1 |
| E | rotate left w/ carry | F5 | – | 0/1 | EA / EB | 1 |
| F | clear | F5 | – | – | 00 | 0 |
| 9 | rotate right (extra) | 7A | – | – | 3D | 0 |

## Expected result

With the corrected RTL in `rtl/`, both scripts end with:

```
  RESULT: <all> passed, 0 failed
```

## Notes

* `rtl/` is the source of truth; `sim/multism.vhd` is the equivalent
  single-file (integrated) copy — compile one set or the other, not both
  (they define the same entities).
* `S(3:2)` selects the part, `S(1:0)` selects the operation inside it.
* Part B `Cout` is always `0` (logic operations); the ALU drives `Cout='0'`
  for `S(3:2)=01`.
