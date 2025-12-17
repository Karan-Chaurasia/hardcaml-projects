=> Advent of Code 2025 – Day 1 (Part 1) in Hardcaml

This repository contains a synthesizable Hardcaml implementation of
Advent of Code 2025 Day 1, Part 1.

The design models the rotating dial as hardware:
-> A 7-bit register stores the current dial position (0–99).
-> A 32-bit register counts events as defined by Part 1.
-> Each input instruction is applied per clock cycle.

The implementation is written in Hardcaml and is fully synthesizable.

=> Files

-> `src/aoc_day1_part1.ml` – Frozen Part 1 RTL implementation
-> `src/aoc_day1.ml` – Active development file (extended later)
-> `tb/test_part1.ml` – Simple cycle-based testbench

=> How to build and run

bash
dune build
dune exec tb/test_part1.exe
