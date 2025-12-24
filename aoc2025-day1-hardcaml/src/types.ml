open Hardcaml

type direction =
  | Up   (* R *)
  | Down (* L *)

let dir_to_signal = function
  | Up   -> Signal.vdd
  | Down -> Signal.gnd
