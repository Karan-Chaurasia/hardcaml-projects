(* src/aoc_day1.ml - Advent of Code 2025 Day 1: Secret Entrance *)
open Hardcaml
open Signal

module I = struct
  type 'a t =
    { clk   : 'a
    ; rst   : 'a
    ; load  : 'a
    ; dir   : 'a
    ; dist  : 'a [@bits 10]
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t =
    { dial      : 'a [@bits 7]
    ; part1_cnt : 'a [@bits 32]
    ; part2_cnt : 'a [@bits 32]
    }
  [@@deriving hardcaml]
end

let create (i : _ I.t) : _ O.t =
  let spec = Reg_spec.create ~clock:i.clk () in

  (* State registers *)
  let dial_reg  = wire 7 in
  let p1_reg    = wire 32 in
  let p2_reg    = wire 32 in

  (* Constants *)
  let dial_init = of_int ~width:7  50 in
  let zero32    = zero 32 in
  let one32     = of_int ~width:32 1 in
  let hundred7  = of_int ~width:7  100 in
  let hundred32 = of_int ~width:32 100 in

  (* Dial rotation: (dial + delta) mod 100 *)
  let dist7 = uresize i.dist 7 in
  let delta = mux2 i.dir dist7 (zero 7 -: dist7) in
  let raw   = dial_reg +: delta in
  let dial_next =
    mux2 (raw >=: hundred7) (raw -:. 100)
      (mux2 (raw <:. 0) (raw +:. 100) raw)
  in

  (* Part 1: count when dial == 0 at END of rotation *)
  let p1_inc = i.load &: (dial_next ==:. 0) in
  let p1_next = p1_reg +: uresize p1_inc 32 in

  (* Part 2: count ALL times dial hits 0 during rotation *)
  let dial32 = uresize dial_reg 32 in

  (* full_turns = dist // 100 (bits 9:7 of 10-bit dist) *)
  let dist10 = uresize i.dist 10 in
  let full_turns = select dist10 9 7 in

  (* remainder = dist % 100 (lower 7 bits) *)
  let remainder = uresize i.dist 7 in

  (* Does remainder cross 0? *)
  let crosses = 
    let rem32 = uresize remainder 32 in
    (dial32 +: rem32) >=: hundred32
  in

  (* total = full_turns + (crosses ? 1 : 0) *)
  let extra = mux2 crosses one32 zero32 in
  let p2_add = uresize full_turns 32 +: extra in

  let p2_next = mux2 i.load (p2_reg +: p2_add) p2_reg in

  (* Reset muxes *)
  let dial_d = mux2 i.rst dial_init dial_next in
  let p1_d   = mux2 i.rst zero32 p1_next in
  let p2_d   = mux2 i.rst zero32 p2_next in

  (* Registered outputs *)
  let dial     = reg spec dial_d in
  let part1_cnt = reg spec p1_d in
  let part2_cnt = reg spec p2_d in

  (* Feedback *)
  dial_reg <== dial;
  p1_reg   <== part1_cnt;
  p2_reg   <== part2_cnt;

  { O.dial; part1_cnt; part2_cnt }
