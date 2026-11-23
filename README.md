# Verilog RTL Design & Verification Labs

Educational Verilog projects organized for an ASIC/FPGA portfolio. Eight lab designs/groups with RTL source and testbenches. The Verilog **module names are preserved** from the original coursework; descriptive filenames do not change module identifiers.

## Projects

| Folder | Design | Testbench |
|---|---|---|
| `01_basic_registered_logic` | Four inputs, three registered Boolean outputs | All 16 input combinations (new) |
| `02_counters/down_counter_4bit` | Loadable, saturating 4-bit down counter | Load, decrement, zero, hold, priority (revised) |
| `02_counters/up_down_counter_5bit` | Loadable, saturating 5-bit up/down counter | Limits, priority, hold (revised) |
| `03_alu/standalone` | Single-module 16-bit ALU | Operations, flags, carry/borrow (revised) |
| `03_alu/modular` | Decoder + arithmetic, logic, comparison, shift units | Original stimulus TB plus new 29-case self-check |
| `04_register_file` | 8x16 register file with async reset, registered read | Read/write/hold/reset/enable conflicts (new) |
| `05_crc_lfsr` | Serial LSB-first 8-bit CRC | 10 supplied reference vectors and VALID checks |
| `06_garage_door_fsm` | Three-state Moore garage-door controller | Six directed 50 MHz checks |

## Verification results (23 November 2026)

The complete regression was executed by the project author in **ModelSim ALTERA 10.1d** on Windows. The recorded output reports **127 passing checks, 0 failures, across all eight design groups**:

| Design group | Passing checks | Failures |
|---|---:|---:|
| Registered logic | 16 | 0 |
| 4-bit down counter | 16 | 0 |
| 5-bit up/down counter | 11 | 0 |
| Standalone ALU | 19 | 0 |
| Modular ALU | 29 | 0 |
| 8x16 register file | 20 | 0 |
| CRC/LFSR | 10 | 0 |
| Garage-door Moore FSM | 6 | 0 |
| **Total** | **127** | **0** |

These are directed simulation checks, **not** exhaustive proof, formal verification, synthesis, timing closure, or physical implementation. See `VERIFICATION_RESULTS.md` for evidence and scope.

## Run all eight labs in ModelSim

Download/extract this folder and open **ModelSim Transcript**. Change to its actual location:

```tcl
cd {C:/Users/danie/Downloads/verilog-rtl-design-labs-complete}
do run_all.do
```

You can instead place it anywhere else and adjust that first path. **Do not run `run_all.do` in plain Tclsh**: `vlog` and `vsim` are ModelSim commands.

The script compiles each design/testbench, runs each simulation, and prints summary lines containing `PASS` or `FAIL`. On **ModelSim ALTERA 10.1d**, the `.do` macro pauses when a testbench executes `$finish`: enter `resume` in the ModelSim Transcript to advance to the next design (repeat for each paused test). The `Break in Module` and `MACRO ... PAUSED` lines in the recorded run were expected pauses, not verification failures. Review all eight summaries carefully; compilation success alone does not prove correctness.

### Verification claims and limitations

- Complete user-supplied ModelSim Transcript for this package (23 November 2026) shows all eight lab groups passed: **127/127 checks**, **0 failures**. The runs were performed on the author's Windows machine, not inside this preparation environment.
- The original modular ALU stimulus testbench has 28 print-only stimuli. The new `alu_top_selfcheck_tb.v` is the basis for the **29/29 PASS** claim; it automatically checks results.
- The modular ALU comparison unit treats its 16-bit inputs as **unsigned**. The arithmetic unit uses signed inputs. Both designs are learning projects rather than tape-out-ready IP.
- The register file accepts read or write only when the other enable is low; when both are high, neither operation is performed.
- CRC vectors are reconstructed from the assignment values; CRC test data files are resolved relative to the **repository root**.

See `AUDIT.md` and `CHANGES.md` for a source-by-source review and changes.
