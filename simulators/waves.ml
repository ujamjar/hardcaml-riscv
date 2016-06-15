open HardCamlRiscV
open Cfg32
open Ui
open Printf

let decode_insn b = 
  if B.(to_int (b ==:. 0) = 1) then "---"
  else if B.(to_int (msb b)) = 1 then "TRAP"
  else
    let idx = B.(to_int (onehot_to_binary b)) in
    Config.T.(Show_t.show (Enum_t.to_enum idx))

let decode_csr b = 
  if B.(to_int (b ==:. 0) = 1) then "---"
  else 
    try 
      let idx = B.(to_int (onehot_to_binary b)) in
      let csr = List.nth Cfg32.Cfg.csrs idx in
      Config.Show_csr.show csr
    with _ -> 
      "???"

let signal_display = function (n,b) -> 
  let open Waveterm_waves in
  match n with
  | "dec_insn" | "fet_insn" | "alu_insn" | "mem_insn" | "com_insn" ->
    n, F(decode_insn)
  | "dec_csr_dec" | "fet_csr_dec" | "alu_csr_dec" | "mem_csr_dec" | "com_csr_dec" ->
    n, F(decode_csr)
  | _ ->
    if b=1 then n, B
    else n, H

(* configure waveform display *)
let wave_cfg = 
  let open Waveterm_waves in

  let csr_waves = 
    List.map (fun csr ->
      let csr_name = 
        try 
          let str = Config.Show_csr.show csr in
          String.sub str 1 (String.length str - 1)
        with _ -> "XXX"
      in
      "csr_" ^ csr_name, H) Cfg32.Cfg.csrs
  in

  let interleave = true in
  let stage_sigs1 = Rv.Ifs.Stages.(to_list @@ map signal_display t) in
  let stage_sigs2 = List.concat @@ 
    Rv.Ifs.Stage.(to_list @@ 
      map (fun (n,b) ->
        List.map signal_display
          [ "state_" ^ n, b; "fet_" ^ n, b; "dec_" ^ n, b; "alu_" ^ n, b; 
            "mem_" ^ n, b; "com_" ^ n, b; ]) t)
  in
  let stage_sigs = if interleave then stage_sigs2 else stage_sigs1 in

  Some( 
    [signal_display ("clk",1); signal_display ("clr",1)] @
    Rv.Ifs.I.(to_list @@ map signal_display t) @ 
    Rv_o.(to_list @@ map signal_display t) @
    [ ("pipe_en",B); ("pipe_bubble",B) ] @
    stage_sigs @ 
    (Array.to_list @@ Array.init 31 (fun i -> sprintf "reg_%.2i" (i+1), H)) @
    csr_waves @ [ ("csr_rdata",H); ("csr_wdata",H) ]
  )

let is_prefixed pre str = 
  (String.length pre <= String.length str) && 
    (String.sub str 0 (String.length pre) = pre)

let is_prefixed_list pre str = 
  List.fold_left (fun ok pre -> ok || is_prefixed pre str) false pre

let get_wave_class pre waves =
  let open Waveterm_waves in
  let get_waves = List.filter (function
    | Clock _ -> true
    | Binary(n,_) when is_prefixed_list pre n -> true
    | Data(n,_,_) when is_prefixed_list pre n -> true
    | _ -> false)
  in
  Array.of_list @@ get_waves @@ Array.to_list waves

let wave_classes waves = 
  [
    `all,     waves;
    `regs,    get_wave_class ["reg_"] waves;
    `fetch,   get_wave_class ["fet_"] waves;
    `decode,  get_wave_class ["dec_"] waves;
    `execute, get_wave_class ["alu_"] waves;
    `memory,  get_wave_class ["mem_"] waves;
    `commit,  get_wave_class ["com_"] waves;
    `state,   get_wave_class ["state_";"csr_"] waves;
  ]

let init_waves sim = 
  let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in
  sim, waves

(*let show_waves waves = 
  let ui = Ui.make_ui (wave_classes waves) in
  Lwt_main.run (Waveterm_ui.run_widget ui.vbox)
*)
