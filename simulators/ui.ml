(* create the debug user interface *)

(*

  keys:

    return     step 1 cycle
    space      step 'n' cycles

    A+<>       cursor +/- 1
    A+S+<>     cursor +/- n

    S+<>       scroll
    C+<>       scroll

    a          all
    r          registers
    f          fetch
    d          decode
    x          execute
    m          memory
    c          commit
    t          state
    
    C+c        cycle edit
    C+s        step edit
    C+w        wave window

*)

open LTerm_widget
open LTerm_geom

open Lwt_react
open CamomileLibraryDyn.Camomile
open LTerm_key
open LTerm_read_line
open LTerm_edit
open LTerm_geom

(* ↑ ↓ ← → *)

module Make(B : HardCaml.Comb.S) = struct

  module Waveterm_waves = HardCamlWaveTerm.Wave.Make(HardCamlWaveTerm.Wave.Bits(B))
  module Waveterm_sim = HardCamlWaveTerm.Sim.Make(B)(Waveterm_waves)
  module Waveterm_ui = HardCamlWaveLTerm.Widget.Make(B)(Waveterm_waves)

  open Waveterm_ui

  let wave_cfg = Waveterm_waves.{ default with wave_cursor=0 }
  let no_state = Waveterm_waves.{ cfg=wave_cfg; waves=[||] }
  let wrap_waves waves = Waveterm_waves.({ cfg=wave_cfg; waves }) 

  let button txt = new button ~brackets:("","") txt 

  let def_zero = "00000000"

  (* 32, 32 bit registers over n_rows *)
  class registers n_rows = object(self)
    inherit t "registers" as super

    method can_focus = false

    val mutable size = { rows=0; cols=0 }
    method size_request = { 
      rows = n_rows; 
      cols = ((32 + n_rows - 1) / n_rows) * 12; 
    }
    method set_allocation r = 
      size <- size_of_rect r;
      super#set_allocation r

    val mutable style = LTerm_style.none
    method update_resources =
      let rc = self#resource_class and resources = self#resources in
      style <- LTerm_resources.get_style rc resources

    val mutable waves = no_state
    val mutable reg_data : Waveterm_waves.t array = 
      let open Waveterm_waves in
      Array.init 32 (fun i -> init 0 (fun _ -> B.empty))
    val mutable reg_data_view : [`lo of string | `hi of string] array = 
      Array.init 32 (fun _ -> `lo def_zero)
    val mutable prev_cursor = 0
    method set_waves w = 
      let open Waveterm_waves in
      (* get the register signals *)
      let is_reg n = try String.length n = 6 && String.sub n 0 4 = "reg_" with _ -> false in
      let reg_num n = try int_of_string (String.sub n 4 2) with _ -> -1 in
      Array.iter 
        (function
          | Data(n, d, _) -> 
            let r = reg_num n in
            if is_reg n && (r <> -1) then begin
              reg_data.(r) <- d
            end
          | _ -> ()) w.waves;
      waves <- w

    method draw ctx focused = 
      let { rows; cols } = LTerm_draw.size ctx in
      LTerm_draw.fill_style ctx style;
      let n_rows = max n_rows (min rows 32) in
      let n_cols = (32 + n_rows - 1) / n_rows in
      let cursor = Waveterm_waves.(waves.cfg.wave_cursor) in
      if prev_cursor <> cursor then begin
        let open Waveterm_waves in
        let open HardCaml.Utils in
        for i=0 to 31 do
          let d0 = reg_data_view.(i) in
          let d1 = 
            try
              hstr_of_bstr Unsigned @@ B.to_bstr @@
              get reg_data.(i) cursor 
            with _ -> def_zero
          in
          match d0 with
          | `lo d0
          | `hi d0 -> 
            reg_data_view.(i) <- if d0 = d1 then `lo d1 else `hi d1
        done;
        prev_cursor <- cursor
      end;
      for r=0 to n_rows-1 do
        for c=0 to n_cols-1 do
          let open Printf in
          let idx = (r * n_cols) + c in
          if idx < 32 then begin
            let c = (c*12) in
            let invert style = LTerm_style.{ style with reverse=Some(true) } in
            LTerm_draw.draw_string ctx r c (sprintf "%.2i" idx);
            (match reg_data_view.(idx) with
            | `lo data -> LTerm_draw.draw_string ~style ctx r (c+3) data;
            | `hi data -> LTerm_draw.draw_string ~style:(invert style) ctx r (c+3) data);
          end
        done
      done

  end

  class asm n_rows = object(self)
    inherit t "asm" as super

    method can_focus = false

    val mutable size = { rows = 0; cols = 0 }
    method size_request = { rows = n_rows; cols = 28 }
    method set_allocation r = 
      size <- size_of_rect r;
      super#set_allocation r

    val mutable style = LTerm_style.none
    method update_resources =
      let rc = self#resource_class and resources = self#resources in
      style <- LTerm_resources.get_style rc resources

    val mutable waves = no_state
    val mutable fet = Waveterm_waves.init 0 (fun _ -> B.empty)
    val mutable dec = Waveterm_waves.init 0 (fun _ -> B.empty)
    val mutable alu = Waveterm_waves.init 0 (fun _ -> B.empty)
    val mutable mem = Waveterm_waves.init 0 (fun _ -> B.empty)
    val mutable com = Waveterm_waves.init 0 (fun _ -> B.empty)
    method set_waves w = 
      let open Waveterm_waves in
      let find name = 
        let rec f i = 
          if i < Array.length w.waves then
            match w.waves.(i) with
            | Data(n, d, _) 
            | Binary(n, d) when n=name -> d
            | _ -> f (i+1)
          else raise Not_found
        in
        f 0
      in
      fet <- find "fet_pc";
      dec <- find "dec_instr";
      alu <- find "alu_instr";
      mem <- find "mem_instr";
      com <- find "com_instr";
      waves <- w

    method draw ctx focused = 
      let open Printf in
      (*let { rows; cols } = LTerm_draw.size ctx in*)
      LTerm_draw.fill_style ctx style;
    
      let open Waveterm_waves in
      let cursor = waves.cfg.wave_cursor in
      let pc = 
        try sprintf "pc=%.8lx" (B.to_int32 (get fet cursor))
        with _ -> "???"
      in

      LTerm_draw.draw_string ctx 0 0 ("f: " ^ pc);

      let asm r l d = 
        (*let pretty = Riscv.RV32I.T.pretty in*)
        let pretty = Prettyasm.pretty in
        let asm = try pretty (B.to_int32 (get d cursor)) with _ -> "???" in
        LTerm_draw.draw_string ctx r 0 (l ^ ": " ^ asm)
      in

      asm 1 "d" dec;
      asm 2 "x" alu;
      asm 3 "m" mem;
      asm 4 "c" com

  end

  class memory_view mem = object(self)
    inherit t "memory_view" as super

    method can_focus = false

    val mutable size = { rows=0; cols=0 }
    method size_request = { 
      rows = 0; 
      cols = 0;
    }
    method set_allocation r = 
      size <- size_of_rect r;
      super#set_allocation r

    val mutable style = LTerm_style.none
    method update_resources =
      let rc = self#resource_class and resources = self#resources in
      style <- LTerm_resources.get_style rc resources

    val mutable offset = 0
    method set_offset o = offset <- o

    method draw ctx focused = 
      let open Printf in
      LTerm_draw.fill_style ctx style;
      
      let cwidth = 9 in
      let cols = (size.cols / cwidth) - 1 in
      let rows = size.rows in

      if cols > 0 then begin
        for row=0 to rows-1 do
          let offset = offset / 4 in (* offset is a byte address *)
          let offset = offset + (row * cols) in
          LTerm_draw.draw_string ctx row 0 (sprintf "%.8x:" (offset*4));
          for col=0 to cols-1 do
            LTerm_draw.draw_string ctx row (10+(col*9)) 
              (try sprintf "%.8lx" mem.(offset+col)
               with _ -> "--------");
          done
        done
      end

  end

  class input_num cols = object(self)
    inherit LTerm_edit.edit_integer ~positive:true ()
    method! size_request = { rows=1; cols }
  end

  let make_wave_view (waveform : #waveform) waves = 
    let open LTerm_widget in
    let vbox = new vbox in
    let wave_grp = new radiogroup in
    vbox#add ~expand:false (new radiobutton wave_grp "All" `all);
    vbox#add ~expand:false (new radiobutton wave_grp "Reg" `regs);
    vbox#add ~expand:false (new radiobutton wave_grp "Fet" `fetch);
    vbox#add ~expand:false (new radiobutton wave_grp "Dec" `decode);
    vbox#add ~expand:false (new radiobutton wave_grp "Exe" `execute);
    vbox#add ~expand:false (new radiobutton wave_grp "Mem" `memory);
    vbox#add ~expand:false (new radiobutton wave_grp "Com" `commit);
    vbox#add ~expand:false (new radiobutton wave_grp "Sta" `state);
    vbox#add (new spacing());
    wave_grp#on_state_change (function
      | Some(x) -> waveform#set_waves @@ wrap_waves @@ List.assoc x waves
      | None -> ());
    vbox, wave_grp

  (* | step [123   ] + | cursor - [123   ] + | <- trans -> |

    step [123   ]    run to cycle number
    step +           increment cycles by number
    cursor [123   ]  goto cycle
    cursor -/+       increment/decrement cursor
    
    TODO: trans: select signals, goto next/prev transition
  *)

  type wave_ctrl = 
    {
      step_num : input_num;
      step_incr : button;
      cursor_num : input_num;
      cursor_incr : button;
      cursor_decr : button;
      hbox : hbox;
      (*trans_incr : button;
      trans_decr : button;*)
    }

  let make_wave_ctrl () = 
    let hbox = new hbox in
    let step_label = new label " step " in
    let step_num = new input_num 12 in
    let step_incr = new button ~brackets:(" "," ") "+" in
    let cursor_label = new label " cursor" in
    let cursor_num = new input_num 12 in
    let cursor_incr = new button ~brackets:(" "," ") "+" in
    let cursor_decr = new button ~brackets:(" "," ") "-" in
    hbox#add ~expand:false step_label;
    hbox#add ~expand:false step_num;
    hbox#add ~expand:false step_incr;
    hbox#add ~expand:false (new vline);
    hbox#add ~expand:false cursor_label;
    hbox#add ~expand:false cursor_decr;
    hbox#add ~expand:false cursor_num;
    hbox#add ~expand:false cursor_incr;
    hbox#add ~expand:false (new vline);
    hbox#add (new spacing ());
    { step_num; step_incr; cursor_num; cursor_incr; cursor_decr; hbox }

  type memory_ctrl = 
    {
      memory : memory_view;
      edit : input_num;
      vbox : vbox;
    }

  let make_memory_view memory = 
    let hbox = new hbox in
    let label = new label "mem addr: " in
    let edit = new input_num 12 in
    hbox#add ~expand:false label;
    hbox#add ~expand:false edit;
    hbox#add (new spacing ());

    let vbox = new vbox in
    let memory = new memory_view memory in
    vbox#add ~expand:false hbox;
    vbox#add ~expand:true memory;
    { vbox; edit; memory }

  type ui = 
    {
      waveform : waveform;
      wave_ctrl : wave_ctrl;
      registers : registers;
      asm : asm;
      view : [`all|`commit|`state|`decode|`execute|`fetch|`memory|`regs] radiogroup;
      memory : memory_ctrl;
      vbox : vbox;
    }

  let make_ui_events ui cycle_count incr_cycles = 
    let maybe d f = function
      | None -> d
      | Some(x) -> f x
    in

    let set_cycle_to n = 
      if n > !cycle_count then begin
        incr_cycles (Some(n - !cycle_count));
        ui.wave_ctrl.step_num#queue_draw
      end
    in
    let incr_cycles n = 
      incr_cycles(Some(n));
      ui.wave_ctrl.step_num#queue_draw
    in

    ui.wave_ctrl.step_num#on_event 
      (function 
        | LTerm_event.Key { LTerm_key.code=LTerm_key.Enter } -> 
          maybe true (fun cycle -> set_cycle_to cycle; true) 
            ui.wave_ctrl.step_num#value
        | _ -> false);

    ui.wave_ctrl.step_incr#on_click 
      (fun () -> 
        let cycles = maybe 1 (fun x -> x) ui.wave_ctrl.step_num#value in
          incr_cycles cycles;
          ui.wave_ctrl.step_num#queue_draw); 

    let set_cursor f = 
      let open Waveterm_waves in
      let cycles = maybe 1 (fun x -> x) ui.wave_ctrl.cursor_num#value in
      let cfg = ui.waveform#get_waves.cfg in
      let max_cycles = Waveterm_ui.R.get_max_cycles ui.waveform#get_waves in
      cfg.wave_cursor <- max 0 (min max_cycles (f cfg.wave_cursor cycles));
      (* set scroll *)
      ui.waveform#waves#hscroll#set_offset cfg.wave_cursor;
      ui.wave_ctrl.cursor_num#queue_draw
    in

    ui.wave_ctrl.cursor_num#on_event
      (function
        | LTerm_event.Key { LTerm_key.code=LTerm_key.Enter } -> begin
          set_cursor (fun _ x -> x);
          true
        end
        | _ -> false);
        
    ui.wave_ctrl.cursor_incr#on_click (fun () -> set_cursor (+));
    ui.wave_ctrl.cursor_decr#on_click (fun () -> set_cursor (-));

    (* memory address *)
    ui.memory.edit#on_event
      (function 
        | LTerm_event.Key { LTerm_key.code=LTerm_key.Enter } -> 
          maybe true (fun v -> 
            ui.memory.memory#set_offset v; 
            ui.memory.memory#queue_draw;
            true) 
            ui.memory.edit#value
        | _ -> false);

    let open LTerm_key in
    ui.vbox#on_event (function

      (* stepping *)
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Enter -> 
        incr_cycles 1; true
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char ' ') -> 
        maybe true (fun cycles -> incr_cycles cycles; true) 
          ui.wave_ctrl.step_num#value

      (* cursor movement *)
      | LTerm_event.Key { shift=false; meta=true; control=false; code } 
          when code = Left -> 
        set_cursor (fun c _ -> c-1); true
      | LTerm_event.Key { shift=false; meta=true; control=false; code } 
          when code = Right -> 
        set_cursor (fun c _ -> c+1); true
      | LTerm_event.Key { shift=true; meta=true; control=false; code } 
          when code = Left -> 
        set_cursor (-); true
      | LTerm_event.Key { shift=true; meta=true; control=false; code } 
          when code = Right -> 
        set_cursor (+); true

      (* switch view *)
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char 'a') -> 
        ui.view#switch_to `all; true
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char 'r') -> 
        ui.view#switch_to `regs; true
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char 'f') -> 
        ui.view#switch_to `fetch; true
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char 'd') -> 
        ui.view#switch_to `decode; true
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char 'x') -> 
        ui.view#switch_to `execute; true
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char 'm') -> 
        ui.view#switch_to `memory; true
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char 'c') -> 
        ui.view#switch_to `commit; true
      | LTerm_event.Key { shift=false; meta=false; control=false; code } 
          when code = Char (UChar.of_char 's') -> 
        ui.view#switch_to `state; true

      (* set focus *)
      | LTerm_event.Key { shift=false; meta=false; control=true; code } 
          when code = Char (UChar.of_char 's') -> 
        ui.vbox#move_focus_to (ui.wave_ctrl.step_num :> LTerm_widget.t); true
      | LTerm_event.Key { shift=false; meta=false; control=true; code } 
          when code = Char (UChar.of_char 'c') -> 
        ui.vbox#move_focus_to (ui.wave_ctrl.cursor_num :> LTerm_widget.t); true
      | LTerm_event.Key { shift=false; meta=false; control=true; code } 
          when code = Char (UChar.of_char 'w') -> 
        ui.vbox#move_focus_to (ui.waveform#waves :> LTerm_widget.t); true
      | LTerm_event.Key { shift=false; meta=false; control=true; code } 
          when code = Char (UChar.of_char 'a') -> 
        ui.vbox#move_focus_to (ui.memory.edit :> LTerm_widget.t); true

      | _ -> false
    )

  let make_ui waves memory = 
    let waveform = new waveform ~framed:false () in
    waveform#set_waves @@ wrap_waves @@ List.assoc `all waves;
    let vbox = new LTerm_widget.vbox in
    vbox#add waveform;
    vbox#add ~expand:false (new LTerm_widget.hline);
    let wave_ctrl = make_wave_ctrl () in
    vbox#add ~expand:false wave_ctrl.hbox;
    vbox#add ~expand:false (new hline);
    let hbox = new LTerm_widget.hbox in
    let registers = new registers 8 in
    registers#set_waves @@ wrap_waves @@ List.assoc `all waves;
    hbox#add ~expand:false registers;
    hbox#add ~expand:false (new LTerm_widget.vline);
    let asm = new asm 8 in
    asm#set_waves @@ wrap_waves @@ List.assoc `all waves;
    hbox#add ~expand:false asm;
    hbox#add ~expand:false (new LTerm_widget.vline);
    let memory = make_memory_view memory in
    hbox#add ~expand:true memory.vbox;
    hbox#add ~expand:false (new LTerm_widget.vline);
    let radio, view = make_wave_view waveform waves in
    hbox#add ~expand:false radio;

    vbox#add ~expand:false hbox;
    { waveform; wave_ctrl; registers; asm; view; memory; vbox }

end

