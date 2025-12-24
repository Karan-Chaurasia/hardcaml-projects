open Hardcaml
open Signal

module I = struct
  type 'a t = {
    clk : 'a;
    rst : 'a;
    start : 'a;
  } [@@deriving hardcaml]
end

module O = struct
  type 'a t = {
    splits : 'a [@bits 32];
    timelines : 'a [@bits 64];
    done_ : 'a;
  } [@@deriving hardcaml]
end

let create (i : _ I.t) =
  let spec = Reg_spec.create ~clock:i.clk () in
  
  (* WIRES for feedback - FIXES non-wire error *)
  let w_row = wire 7 in
  let w_col = wire 7 in
  
  (* Constants *)
  let one_7  = of_int ~width:7  1 in
  let one_32 = of_int ~width:32 1 in
  let one_64 = of_int ~width:64 1 in
  
  (* State registers - read from wires *)
  let r_row = reg spec w_row in
  let r_col = reg spec w_col in
  let r_splits = reg spec (zero 32) in
  let r_timelines = reg spec (zero 64) in
  
  (* Conditions *)
  let bottom = r_row >=: (of_int ~width:7 79) in
  let at_splitter = zero 1 in
  
  (* Next logic *)
  let next_row = mux2 i.start one_7 (r_row +: one_7) in
  let next_col = mux2 i.start (of_int ~width:7 30) r_col in
  
  let splits_inc = r_splits +: one_32 in
  let splits_running = mux2 at_splitter splits_inc r_splits in
  let next_splits = mux2 i.start (zero 32) splits_running in
  
  let timelines_inc = r_timelines +: one_64 in
  let timelines_running = mux2 bottom timelines_inc r_timelines in
  let next_timelines = mux2 i.start one_64 timelines_running in
  
  (* Register outputs *)
  let splits = reg spec next_splits in
  let timelines = reg spec next_timelines in
  let done_ = reg spec bottom in
  
  (* CRITICAL: Wire assignments - ONLY wires get <== *)
  w_row <== next_row;
  w_col <== next_col;
  
  { O.splits; timelines; done_ }
