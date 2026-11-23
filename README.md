# Verilog RTL Labs — Functionally Tested Designs

A small portfolio of introductory Verilog RTL modules with accompanying ModelSim testbenches and documented functional checks.

> **Scope:** These designs passed the specified directed simulations during coursework. They have not undergone exhaustive verification, formal verification, synthesis sign-off, or physical implementation. The original RTL module names are retained to preserve testbench compatibility.

## Included projects

| Project | Description | Observed coursework result |
|---|---|---|
| `01_crc_lfsr/` | Serial 8-bit CRC generator with active-low asynchronous reset, LSB-first input/output and `valid` control | **10/10** reference vectors passed in ModelSim |
| `02_garage_door_fsm/` | Three-state Moore FSM for garage-door up/down motors | **6/6** directed checks passed in ModelSim |

The CRC testbench includes an additional unknown-value guard added during repository cleanup to avoid false positives if input files are absent. The modified testbench has **not** been rerun here, though the original vectors were previously observed to pass. The included `DATA_h.txt` and `Expec_Out_h.txt` were reconstructed from the course values previously provided; compare them with the original files where possible.

## Running in ModelSim

From the repository root:

**CRC (10 MHz clock):**

```tcl
cd 01_crc_lfsr
vlog rtl/crc_lfsr.v tb/crc_lfsr_tb.v
vsim work.LFSR_MINE_TB
run -all
cd ..
```

**Garage door (50 MHz clock):**

```tcl
vlog 02_garage_door_fsm/rtl/garage_door_fsm.v 02_garage_door_fsm/tb/garage_door_tb.v
vsim work.door_tb
run -all
```

## Publication policy

This public-facing set intentionally excludes incomplete, duplicate, example-only, and not-yet-verified assignments. See `REVIEW_NOTES.md` for details. Other original source files remain in the user's original local folder/ZIP; this package does not remove them.
