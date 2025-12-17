open Hardcaml

type direction =
  | Up
  | Down

let dir_to_signal = function
  | Up -> Signal.vdd
  | Down -> Signal.gnd

type 'a t =
  { dist        : 'a
  ; full_turns  : 'a
  ; remainder   : 'a
  }
[@@deriving hardcaml]
