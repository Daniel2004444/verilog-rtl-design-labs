# ModelSim Regression Results

**Date:** 23 November 2026  
**Simulator:** Model Technology ModelSim ALTERA 10.1d (2012.11), Windows  
**Command:** `do run_all.do`, followed by `resume` each time ModelSim paused on `$finish`  
**Source:** Transcript output supplied by the project author after executing the packaged regression locally.

## Summary

| Design / testbench | Result reported by ModelSim |
|---|---|
| Registered logic / `registered_logic_tb` | `REGISTERED LOGIC: 16/16 PASS, 0 FAIL` |
| 4-bit down counter / `down_counter_tb` | `DOWN COUNTER: 16 PASS, 0 FAIL` |
| 5-bit up/down counter / `down_counter_ass2` | `UP/DOWN COUNTER: 11 PASS, 0 FAIL` |
| Standalone ALU / `ALU_TB` | `STANDALONE ALU: 19 PASS, 0 FAIL` |
| Modular ALU / `alu_top_selfcheck_tb` | `MODULAR ALU: 29/29 PASS, 0 FAIL` |
| 8x16 register file / `register_file_8x16_tb` | `REGISTER FILE: 20 PASS, 0 FAIL` |
| CRC/LFSR / `LFSR_MINE_TB` | `RESULT: 10 / 10 passed` |
| Garage-door FSM / `door_tb` | Six printed `PASS:` messages, followed by `Simulation completed` |

**Total: 127 directed checks passed, zero failures across eight lab groups.**

### CRC reference vectors

| Input byte (hex) | Expected and observed CRC (hex) |
|---|---|
| 93 | 78 |
| 72 | 44 |
| 36 | 11 |
| 1B | D2 |
| A6 | 09 |
| C0 | B2 |
| 55 | 36 |
| F2 | 80 |
| 5E | 2C |
| 11 | 63 |

## Limits

These results are from directed functional simulation. They do not establish exhaustive verification or sign-off for timing, synthesis, lint, CDC/RDC, area, or power. The modular ALU comparison unit performs unsigned comparisons; signed comparisons remain a separately identified edge case. The ModelSim `Break in Module` and `MACRO ... PAUSED` messages in the transcript were due to testbench `$finish` statements and did not indicate failed tests.
