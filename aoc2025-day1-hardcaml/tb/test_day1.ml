open Hardcaml
open Aoc_day1

module C = Circuit.With_interface (I) (O)

let () =
  let circuit =
    C.create_exn
      ~name:"aoc_day1"
      create
  in

  let sim = Cyclesim.create circuit in

  (* Run a few cycles *)
  Cyclesim.cycle sim;
  Cyclesim.cycle sim;
  Cyclesim.cycle sim;

  print_endline "Simulation completed successfully."
