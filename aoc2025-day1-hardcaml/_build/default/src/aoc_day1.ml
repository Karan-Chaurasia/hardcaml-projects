open Hardcaml
open Signal

module I = struct
  type 'a t =
    { clk  : 'a
    ; rst  : 'a
    ; dir  : 'a        (* 1 = up, 0 = down *)
    ; dist : 'a
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t =
    { dial  : 'a [@bits 7]
    ; count : 'a [@bits 32]
    }
  [@@deriving hardcaml]
end

let create (i : Signal.t I.t) =
  let spec = Reg_spec.create ~clock:i.clk () in

  (* Current registers *)
  let dial_reg  = wire 7 in
  let count_reg = wire 32 in

  (* Directional delta *)
  let dist  = uresize i.dist 7 in
  let delta = mux2 i.dir dist (zero 7 -: dist) in

  (* Dial update *)
  let raw = dial_reg +: delta in
  let dial_next =
    mux2 (raw >=:. 100) (raw -:. 100)
      (mux2 (raw <:. 0) (raw +:. 100) raw)
  in

  (* Reset logic *)
  let dial_d  = mux2 i.rst (of_int ~width:7 50) dial_next in
  let count_d = mux2 i.rst (zero 32) (count_reg +:. 1) in

  (* Registers *)
  let dial  = reg spec dial_d in
  let count = reg spec count_d in

  dial_reg  <== dial;
  count_reg <== count;

  { O.dial; count }
