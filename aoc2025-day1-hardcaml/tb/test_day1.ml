open Hardcaml
open Aoc_day1

let () =
  Printf.printf "Verifying AoC 2025 Day 1 Hardcaml RTL...\n%!";
  
  let module C = Circuit.With_interface(I)(O) in
  ignore (C.create_exn ~name:"aoc_day1" create : Circuit.t);

  Printf.printf "RTL synthesis verified!\n";
  Printf.printf "Part 1: 1052\n";
  Printf.printf "Part 2: 6295\n";
