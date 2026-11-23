# Changes in the cleaned copy

All **included RTL design modules remain functionally unchanged**; only the source filenames/folders were standardized. Verilog module identifiers and interfaces were preserved for compatibility.

- New testbenches: `01_basic_registered_logic/tb/registered_logic_tb.v`, `04_register_file/tb/register_file_8x16_tb.v`, and `03_alu/modular/tb/alu_top_selfcheck_tb.v`.
- Replaced counter and standalone ALU testbench scripts with clock-aligned, self-checking directed tests; old down-counter TB's incorrect 10-3=15 expectation was removed.
- Original modular ALU display-only testbench is retained for reference alongside the self-checking testbench.
- CRC testbench now rejects unknown test data and checks vector paths relative to the repository root, avoiding past `xx == xx` false positives.
- Added `run_all.do` for running all eight testbenches from a single ModelSim Transcript command.
- Added CRC reference input and expected-output text files, reconstructed from the ten known assignment vectors.

**Status:** New regression awaits local ModelSim execution. These changes are testbench-only, not claims of independent simulator validation.
