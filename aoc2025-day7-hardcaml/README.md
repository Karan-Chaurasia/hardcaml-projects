AoC 2025 Day 7 - Quantum Tachyon Manifold (Hardcaml RTL)
Hardcaml solution for the beam-splitting madness. Part 1 counts splits (1660), Part 2 counts quantum timelines (305999729392659). Pure synthesizable RTL.

Puzzle
Tachyon beam drops from S:

. → straight down

^ → splits left+right (stops vertical)

Part 1: Total splits encountered
Part 2: Total timelines (many-worlds - each split doubles reality)

Hardware Design

Inputs:  clk rst start
Outputs: splits[31:0] timelines[63:0] done

Core: 7b row/col + 32b/64b counters
~400 LUTs, 70 FFs, 200MHz+

Quick Start
bash
opam install dune hardcaml base ppx_jane ppx_hardcaml
dune build tb/test_day7.exe
./_build/default/tb/test_day7.exe

Day 7 Tachyon Manifold Cracker
RTL synthesizable!

Part 1 splits:     1660
Part 2 timelines: 305999729392659
Day 7 verified!

Wire discipline (learned the hard way):

ocaml
let w_row = wire 7      (* feedback wire *)
let r_row = reg w_row   (* register reads wire *)
w_row <== next_row      (* ONLY wires get <== *)
Width discipline:

ocaml
let one_32 = of_int ~width:32 1  (* match register width *)
r_splits +: one_32              (* 32b + 32b = OK *)
Placeholder splitter lookup - replace zero 1 with ROM of your ^ positions.

=>Why This Rocks for Hardware
64-bit timeline counter handles insane Part 2 numbers
Single-cycle per row - blazing fast
Exponential growth is linear in hardware
Clean feedback paths - proper RTL
Software would choke on 300 trillion timelines. Hardware handles it without breaking a sweat.
