# Audit of original 24 Verilog files

## Included design families

- `DigCt.v` -> `01_basic_registered_logic/rtl/registered_logic.v`
- `Hello.v`, `down_counter_tb.v` -> `02_counters/down_counter_4bit/` (reworked TB)
- `Ass_2.v`, `ass_2_tb.v` -> `02_counters/up_down_counter_5bit/` (reworked TB)
- `assig_3.v`, `assign_3_tb.v` -> `03_alu/standalone/` (reworked TB)
- `alu_unit.v`, `arth_unit.v`, `logic_unit.v`, `cmp_unit.v`, `shift_unit.v`, `decoder_unit.v`, `ALU_TOP_TB.v` -> `03_alu/modular/` (plus new self-checking TB)
- `8x16_reg.v` -> `04_register_file/rtl/register_file_8x16.v` (plus new TB)
- `LFSR_MINE.v`, `LFSR_MINE_TB.v` -> `05_crc_lfsr/` (CRC vectors included)
- `autodoor.v`, `door_tb.v` -> `06_garage_door_fsm/`

## Excluded from publication candidate

- `Try.v`: duplicate of `DigCt.v`.
- `RAM.v`: syntax error in parameter declaration, and default address width inconsistent with depth; requires repair and verification.
- `Top_Design.v`: references missing `REG_FILE`, `ENCODER`, and `SERIALIZER` modules.
- `LFSR.v`: separate teaching exercise with `valid` asserted during output but no normal deassertion; no dedicated verified TB.
- `auto_example.v`: locker Moore machine instructional example; omitted from finished independent portfolio projects.

No files were deleted from the original uploaded ZIP or the original Windows ModelSim directory. Please do not publish the held-out source as verified.
