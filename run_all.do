# In ModelSim Transcript: cd {FULL_PATH_TO_REPOSITORY}; do run_all.do
# Assumes ModelSim's current working directory is the repository root.
if {![file exists work]} {vlib work}
vmap work work
proc run_lab {label top files} {
    puts "\n========== $label ==========" 
    foreach file $files {
        if {[catch {vlog $file} e]} {
            error "Compilation failed for $file: $e"
        }
    }
    if {[catch {vsim work.$top} e]} {error "Unable to load $top: $e"}
    run -all
    quit -sim
}
run_lab "Registered logic" registered_logic_tb {
  01_basic_registered_logic/rtl/registered_logic.v
  01_basic_registered_logic/tb/registered_logic_tb.v
}
run_lab "4-bit down counter" down_counter_tb {
  02_counters/down_counter_4bit/rtl/down_counter_4bit.v
  02_counters/down_counter_4bit/tb/down_counter_4bit_tb.v
}
run_lab "5-bit up/down counter" down_counter_ass2 {
  02_counters/up_down_counter_5bit/rtl/up_down_counter_5bit.v
  02_counters/up_down_counter_5bit/tb/up_down_counter_5bit_tb.v
}
run_lab "Standalone ALU" ALU_TB {
  03_alu/standalone/rtl/alu_standalone.v
  03_alu/standalone/tb/alu_standalone_tb.v
}
run_lab "Modular ALU" alu_top_selfcheck_tb {
  03_alu/modular/rtl/alu_top.v
  03_alu/modular/rtl/arithmetic_unit.v
  03_alu/modular/rtl/logic_unit.v
  03_alu/modular/rtl/comparison_unit.v
  03_alu/modular/rtl/shift_unit.v
  03_alu/modular/rtl/alu_decoder.v
  03_alu/modular/tb/alu_top_selfcheck_tb.v
}
run_lab "Register file" register_file_8x16_tb {
  04_register_file/rtl/register_file_8x16.v
  04_register_file/tb/register_file_8x16_tb.v
}
run_lab "CRC/LFSR" LFSR_MINE_TB {
  05_crc_lfsr/rtl/crc_lfsr.v
  05_crc_lfsr/tb/crc_lfsr_tb.v
}
run_lab "Garage-door Moore FSM" door_tb {
  06_garage_door_fsm/rtl/garage_door_fsm.v
  06_garage_door_fsm/tb/garage_door_tb.v
}
puts "\nEND OF REGRESSION: inspect all eight PASS/FAIL summaries above."
