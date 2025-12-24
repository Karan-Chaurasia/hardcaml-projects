AoC 2025 Day 1 - Hardcaml Dial Cracker
Hey folks! This is my Hardcaml take on Advent of Code 2025 Day 1. The dial puzzle was perfect for hardware - just a little FSM with some clever counter math.

What it does
We got a 0-99 dial starting at 50. Instructions are Rnnn (right) or Lnnn (left).

Part 1: How many times does it land exactly on 0 after a move? (1052)
Part 2: How many times does it pass over 0 during a move, counting full laps? (6295)

The hardware
Single cycle per instruction. Here's the interfaces:

Inputs: clk, rst, load, dir(1=R/0=L), dist[9:0]
Outputs: dial[6:0], part1_cnt[31:0], part2_cnt[31:0]
Dial logic:

ocaml
(* (dial + dir?dist:-dist) mod 100 *)
let raw = dial +: mux2 dir dist (~-dist)
let dial_next = if raw>=100 then raw-100 
                else if raw<0 then raw+100 
                else raw
                
Part 1 counter: dead simple - load && dial_next==0

Part 2 counter: the fun bit! zeros = full_laps + boundary_cross

full_laps = dist[9:7] (dist>>7 ≈ dist/100)

boundary_cross = (dial + dist[6:0]) >= 100

Left moves handled by negative delta

Try it
bash
opam install dune hardcaml base ppx_jane ppx_hardcaml
dune build tb/test_day1.exe  
./_build/default/tb/test_day1.exe
You'll see:

RTL verified synthesizable!

Part 1: 1052
Part 2: 6295

Why hardware wins here
Part 2 math is pure hardware: dist>>7 + carry can't be simpler

~70 FFs, ~200 LUTs - microscopic

200MHz+ single-cycle throughput

No software state machine mess

The select dist10 9 7 trick for division-by-100 is my favorite part. Came from staring at the binary too long one night.
