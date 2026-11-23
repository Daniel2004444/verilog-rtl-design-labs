# Audit Notes — Files Not Included

The source audit covered 24 original Verilog files. Only the CRC and garage-door projects had explicit passing simulation transcripts in the conversation.

## Hold pending verification or review

- Modular ALU and standalone ALU — testbenches exist, but the modular ALU testbench does not automatically compare all 28 outputs against expected results; reverify before publication.
- 4-bit down counter and 5-bit up/down counter — testbenches exist, but need rerun after one expected value was corrected in the down-counter testbench.
- 8×16 register file and `DigCt` — no dedicated testbench in reviewed ZIP.
- Original `LFSR.v` — `valid` remains asserted after output without reset in the present source.
- `RAM.v` — parameter syntax error; not compilable as supplied.
- `Top_Design.v` — missing dependent modules.
- `auto_example.v` — locker FSM example; no dedicated TB in reviewed ZIP and source attribution should be checked.
- `Try.v` — duplicate implementation of `DigCt.v`.
- Other unnamed experiments are excluded until classified and verified.

**Note:** Omission is not a claim that every held-out lab is incorrect; it means correctness has not yet been demonstrated to the same standard as the two published examples.
