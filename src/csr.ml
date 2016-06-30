(** Control and Status registers *)

(* register specs *)
module Specs = struct

  type level_rw = URW|URO|SRW|SRO|HRW|HRO|MRW|MRO

  type csr = 
    {
      addr : int;
      priv : level_rw;
      tag : Config.csr;
      name : string;
      desc : string;
    }

  let mk addr priv tag name desc = { addr; priv; tag; name; desc }

  (* User level CSRs - table 2.2 *)

  (* Floating point *)
  let fflags = mk 0x001 URW `fflags "fflags" "Floating-Point Accrued Exceptions."
  let frm = mk 0x002 URW `frm "frm" "Floating-Point Dynamic Rounding Mode."
  let fcsr = mk 0x003 URW `fcsr "fcsr" "Floating-Point Control and Status Register (frm + fflags)."

  (* User counters/times *)
  let cycle = mk 0xC00 URO `cycle "cycle" "Cycle counter for RDCYCLE instruction."
  let time = mk 0xC01 URO `time "time" "Timer for RDTIME instruction."
  let instret = mk 0xC02 URO `instret "instret" "Instructions-retired counter for RDINSTRET instruction."
  let cycleh = mk 0xC80 URO `cycleh "cycleh" "Upper 32 bits of cycle, RV32I only."
  let timeh = mk 0xC81 URO `timeh "timeh" "Upper 32 bits of time, RV32I only."
  let instreth = mk 0xC82 URO `instreth "instreth" "Upper 32 bits of instret, RV32I only."

  (* Supervisor level CSRs - table 2.3 *)

  (* Supervisor Trap Setup*)
  let sstatus = mk 0x100 SRW `sstatus "sstatus" "Supervisor status register."
  let stvec = mk 0x101 SRW `stvec "stvec" "Supervisor trap handler base address."
  let sie = mk 0x104 SRW `sie "sie" "Supervisor interrupt-enable register."
  let stimecmp = mk 0x121 SRW `stimecmp "stimecmp" "Wall-clock timer compare value."

  (* Supervisor Timer *)
  let stime = mk 0xD01 SRO `stime "stime" "Supervisor wall-clock time register."
  let stimeh = mk 0xD81 SRO `stimeh "stimeh" "Upper 32 bits of stime, RV32I only."

  (* Supervisor Trap Handling *)
  let sscratch = mk 0x140 SRW `sscratch "sscratch" "Scratch register for supervisor trap handlers."
  let sepc = mk 0x141 SRW `sepc "sepc" "Supervisor exception program counter."
  let scause = mk 0xD42 SRO `scause "scause" "Supervisor trap cause."
  let sbadaddr = mk 0xD43 SRO `sbadaddr "sbadaddr" "Supervisor bad address."
  let sip = mk 0x144 SRW `sip "sip" "Supervisor interrupt pending."

  (* Supervisor Protection and Translation *)
  let sptbr = mk 0x180 SRW `sptbr "sptbr" "Page-table base register."
  let sasid = mk 0x181 SRW `sasid "sasid" "Address-space ID."

  (* Supervisor Read/Write Shadow of User Read-Only registers *)
  let cyclew = mk 0x900 SRW `cyclew "cyclew" "Cycle counter for RDCYCLE instruction."
  let timew = mk 0x901 SRW `timew "timew" "Timer for RDTIME instruction."
  let instretw = mk 0x902 SRW `instretw "instretw" "Instructions-retired counter for RDINSTRET instruction."
  let cyclehw = mk 0x980 SRW `cyclehw "cyclehw" "Upper 32 bits of cycle, RV32I only."
  let timehw = mk 0x981 SRW `timehw "timehw" "Upper 32 bits of time, RV32I only."
  let instrethw = mk 0x982 SRW `instrethw "instrethw" "Upper 32 bits of instret, RV32I only."

  (* Hypervisor level CSRs - table 2.4 *)

  (* Hypervisor Trap Setup *)
  let hstatus = mk 0x200 HRW `hstatus "hstatus" "Hypervisor status register."
  let htvec = mk 0x201 HRW `htvec "htvec" "Hypervisor trap handler base address."
  let htdeleg = mk 0x202 HRW `htdeleg "htdeleg" "Hypervisor trap delegation register."
  let htimecmp = mk 0x221 HRW `htimecmp "htimecmp" "Hypervisor wall-clock timer compare value."

  (* Hypervisor Timer *)
  let htime = mk 0xE01 HRO `htime "htime" "Hypervisor wall-clock time register."
  let htimeh = mk 0xE81 HRO `htimeh "htimeh" "Upper 32 bits of htime, RV32I only."

  (* Hypervisor Trap Handling *)
  let hscratch = mk 0x240 HRW `hscratch "hscratch" "Scratch register for hypervisor trap handlers."
  let hepc = mk 0x241 HRW `hepc "hepc" "Hypervisor exception program counter."
  let hcause = mk 0x242 HRW `hcause "hcause" "Hypervisor trap cause."
  let hbadaddr = mk 0x243 HRW `hbadaddr "hbadaddr" "Hypervisor bad address."

  (* Hypervisor Protection and Translation *)
  (*0x28X TBD "TBD" "TBD."*)

  (* Hypervisor Read/Write Shadow of Supervisor Read-Only Registers *)
  let stimew = mk 0xA01 HRW `stimew "stimew" "Supervisor wall-clock timer."
  let stimehw = mk 0xA81 HRW `stimehw "stimehw" "Upper 32 bits of supervisor wall-clock timer, RV32I only."

  (* Machine level CSRs - table `. 2.4 *)

  (* Machine Information Registers *)
  let mcpuid = mk 0xF00 MRO `mcpuid "mcpuid" "CPU description."
  let mimpid = mk 0xF01 MRO `mimpid "mimpid" "Vendor ID and version number."
  let mhartid = mk 0xF10 MRO `mhartid "mhartid" "Hardware thread ID."

  (* Machine Trap Setup *)
  let mstatus = mk 0x300 MRW `mstatus "mstatus" "Machine status register."
  let mtvec = mk 0x301 MRW `mtvec "mtvec" "Machine trap-handler base address."
  let mtdeleg = mk 0x302 MRW `mtdeleg "mtdeleg" "Machine trap delegation register."
  let mie = mk 0x304 MRW `mie "mie" "Machine interrupt-enable register."
  let mtimecmp = mk 0x321 MRW `mtimecmp "mtimecmp" "Machine wall-clock timer compare value."

  (* Machine Timers and Counters *)
  let mtime = mk 0x701 MRW `mtime "mtime" "Machine wall-clock time."
  let mtimeh = mk 0x741 MRW `mtimeh "mtimeh" "Upper 32 bits of mtime, RV32I only."

  (* Machine Trap Handling *)
  let mscratch = mk 0x340 MRW `mscratch "mscratch" "Scratch register for machine trap handlers."
  let mepc = mk 0x341 MRW `mepc "mepc" "Machine exception program counter."
  let mcause = mk 0x342 MRW `mcause "mcause" "Machine trap cause."
  let mbadaddr = mk 0x343 MRW `mbadaddr "mbadaddr" "Machine bad address."
  let mip = mk 0x344 MRW `mip "mip" "Machine interrupt pending."

  (* Machine Protection and Translation *)
  let mbase = mk 0x380 MRW `mbase "mbase" "Base register."
  let mbound = mk 0x381 MRW `mbound "mbound" "Bound register."
  let mibase = mk 0x382 MRW `mibase "mibase" "Instruction base register."
  let mibound = mk 0x383 MRW `mibound "mibound" "Instruction bound register."
  let mdbase = mk 0x384 MRW `mdbase "mdbase" "Data base register."
  let mdbound = mk 0x385 MRW `mdbound "mdbound" "Data bound register."

  (* Machine Read-Write Shadow of Hypervisor Read-Only Registers *)
  let htimew = mk 0xB01 MRW `htimew "htimew" "Hypervisor wall-clock timer."
  let htimehw = mk 0xB81 MRW `htimehw "htimehw" "Upper 32 bits of hypervisor wall-clock timer, RV32I only."

  (* Machine Host-Target Interface `Non (Non-Standard Berkeley Extension) *)
  let mtohost = mk 0x780 MRW `mtohost "mtohost" "Output register to host."
  let mfromhost = mk 0x781 MRW `mfromhost "mfromhost" "Input register from host."

  let all_csrs = List.map (fun x -> x.tag, x)
    [
      fflags;
      frm;
      fcsr;
      cycle;
      time;
      instret;
      cycleh;
      timeh;
      instreth;
      sstatus;
      stvec;
      sie;
      stimecmp;
      stime;
      stimeh;
      sscratch;
      sepc;
      scause;
      sbadaddr;
      sip;
      sptbr;
      sasid;
      cyclew;
      timew;
      instretw;
      cyclehw;
      timehw;
      instrethw;
      hstatus;
      htvec;
      htdeleg;
      htimecmp;
      htime;
      htimeh;
      hscratch;
      hepc;
      hcause;
      hbadaddr;
      stimew;
      stimehw;
      mcpuid;
      mimpid;
      mhartid;
      mstatus;
      mtvec;
      mtdeleg;
      mie;
      mtimecmp;
      mtime;
      mtimeh;
      mscratch;
      mepc;
      mcause;
      mbadaddr;
      mip;
      mbase;
      mbound;
      mibase;
      mibound;
      mdbase;
      mdbound;
      htimew;
      htimehw;
      mtohost;
      mfromhost;
    ]

end

module Make(B : HardCaml.Comb.S)(Ifs : Interfaces.S) = struct

  open Ifs

  type timer_spec = [ `cycle | `time | `instret | `mtime ]
  type csr_ospec = 
    [ `zero | `ones | `const of B.t | `consti of int
    | `counter64 of timer_spec
    | `counter64h of timer_spec
    | `writeable of Config.csr * int * B.t * B.t 
    | `writeable_ext of Config.csr * int * B.t * B.t * B.t * B.t ] 
  type csr_ispec = B.t * B.t

  let csr_spec i = 
    let module X = Xlen.F in
    let open B in
    let instr_set = if xlen=32 then `rv32i else `rv64i in
    let zero' _ = `zero in
    let writeable ~csr ~ofs ~cv ~e = `writeable(csr,ofs,cv,e) in
    let writeable_ext ~csr ~ofs ~cv ~e i = 
      let ext_we, ext_data = i in
      `writeable_ext(csr,ofs,cv,e,ext_we,ext_data) 
    in

    let ofs = Csr_regs_ex.(map (fun x -> x mod 32) (offsets ~rev:false ())) in

    let regs = 
      { 
        Csr_regs.cycle = { X.data = `counter64 `cycle };
        time           = { X.data = `counter64 `time };
        instret        = { X.data = `counter64 `instret };
        cycleh         = { X.data = `counter64h `cycle }; 
        timeh          = { X.data = `counter64h `time };
        instreth       = { X.data = `counter64h `instret };

        mcpuid      = 
          { Mcpuid.F.(map zero' t) with
              Mcpuid.F.base = `consti (Mcpuid.base instr_set);
              extensions    = `const (constibl @@ Mcpuid.extensions ~base:instr_set ['U']); };
        mimpid      = { Mimpid.F.(map zero' t) with Mimpid.F.vendor = `consti(Mimpid.vendor) };
        mhartid     = { Mhartid.F.hartid = `zero };

        mstatus     = 
          { Mstatus.F.(map zero' t) with
              Mstatus.F.sd = `zero;
              vm           = `zero; (* Mbare *)
              mprv         = `zero;
              xs           = `zero;
              fs           = `zero;
              prv3         = `ones; (* XXX TODO; priv stack, interrupt support *)
              ie3          = `zero;
              prv2         = `ones;
              ie2          = `zero;
              prv1         = `ones;
              ie1          = `zero;
              prv          = writeable_ext ~csr:`mstatus 
                                           ~ofs:ofs.Csr_regs.mstatus.Mstatus.F.prv 
                                           ~cv:(ones 2) ~e:vdd
                                           i.Csr_regs.mstatus.Mstatus.F.prv;
              ie           = writeable_ext ~csr:`mstatus 
                                           ~ofs:ofs.Csr_regs.mstatus.Mstatus.F.ie 
                                           ~cv:gnd ~e:vdd
                                           i.Csr_regs.mstatus.Mstatus.F.ie;
          };
        mtvec       = { Mtvec.F.(map zero' t) with Mtvec.F.addr = `consti (Mtvec.Lo.trap/4) };
        mtdeleg     = Mtdeleg.F.(map zero' t);
        mie         = Mie.F.(map zero' t);
        mtimecmp    = { Mtimecmp.F.(map zero' t) with 
                          Mtimecmp.F.mtimecmp = writeable ~csr:`mtimecmp ~ofs:0 
                                                          ~cv:(zero 32) ~e:vdd };
        mtime       = { Mtime.F.mtime = `counter64 `mtime };
        mtimeh      = { Mtime.F.mtime = `counter64h `mtime };
        mscratch    = { Mscratch.F.mscratch = writeable ~csr:`mscratch ~ofs:0 
                                                        ~cv:(zero xlen) ~e:vdd };
        mepc        = { Mepc.F.mepc = writeable_ext ~csr:`mepc ~ofs:0 ~cv:(zero xlen) ~e:vdd
                                                    i.Csr_regs.mepc.Mepc.F.mepc };
        mcause      = 
          { Mcause.F.(map zero' t) with 
            Mcause.F.interrupt = writeable_ext ~csr:`mcause ~cv:gnd ~e:vdd
                                  ~ofs:ofs.Csr_regs.mcause.Mcause.F.interrupt
                                  i.Csr_regs.mcause.Mcause.F.interrupt;
            cause              = writeable_ext ~csr:`mcause ~cv:(zero 4) ~e:vdd
                                  ~ofs:ofs.Csr_regs.mcause.Mcause.F.cause
                                  i.Csr_regs.mcause.Mcause.F.cause;
                                   
          };

        mbadaddr    = { Mbadaddr.F.mbadaddr = 
                          writeable_ext ~csr:`mbadaddr ~ofs:0 ~cv:(zero xlen) ~e:vdd
                            i.Csr_regs.mbadaddr.Mbadaddr.F.mbadaddr };
        mip         = Mip.F.(map zero' t);

        mbase       = { Xlen.F.data = writeable ~csr:`mbase ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mbound      = { Xlen.F.data = writeable ~csr:`mbound ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mibase      = { Xlen.F.data = writeable ~csr:`mbase ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mibound     = { Xlen.F.data = writeable ~csr:`mbound ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mdbase      = { Xlen.F.data = writeable ~csr:`mbase ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mdbound     = { Xlen.F.data = writeable ~csr:`mbound ~ofs:0 ~cv:(zero xlen) ~e:vdd };

      }
    in
    regs

  let csr_read_mux dec regs csrs = 
    let rec read csr = 
      let to_vec csr l = 
        let csr_name = 
          try 
            let str = Config.Show_csr.show csr in
            String.sub str 1 (String.length str - 1)
          with _ -> "XXX"
        in
        let check w = 
          if w <> xlen then begin
            failwith (Printf.sprintf "CSR bad width %s[%i]" csr_name w)
          end
        in
        let x = B.concat_e l in
        check (B.width x);
        B.(x -- ("csr_" ^ csr_name))
      in
      match csr with
      | `cycle    -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.cycle
      | `time     -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.time
      | `instret  -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.instret
      | `cycleh   -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.cycleh
      | `timeh    -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.timeh
      | `instreth -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.instreth

      | `mcpuid   -> to_vec csr @@ Mcpuid.F.to_list @@ regs.Csr_regs.mcpuid
      | `mimpid   -> to_vec csr @@ Mimpid.F.to_list @@ regs.Csr_regs.mimpid
      | `mhartid  -> to_vec csr @@ Mhartid.F.to_list @@ regs.Csr_regs.mhartid

      | `mstatus  -> to_vec csr @@ Mstatus.F.to_list @@ regs.Csr_regs.mstatus
      | `mtvec    -> to_vec csr @@ Mtvec.F.to_list @@ regs.Csr_regs.mtvec
      | `mtdeleg  -> to_vec csr @@ Mtdeleg.F.to_list @@ regs.Csr_regs.mtdeleg
      | `mie      -> to_vec csr @@ Mie.F.to_list @@ regs.Csr_regs.mie
      | `mtimecmp -> to_vec csr @@ Mtimecmp.F.to_list @@ regs.Csr_regs.mtimecmp

      | `mtime    -> to_vec csr @@ Mtime.F.to_list @@ regs.Csr_regs.mtime
      | `mtimeh   -> to_vec csr @@ Mtime.F.to_list @@ regs.Csr_regs.mtimeh

      | `mscratch -> to_vec csr @@ Mscratch.F.to_list @@ regs.Csr_regs.mscratch
      | `mepc     -> to_vec csr @@ Mepc.F.to_list @@ regs.Csr_regs.mepc
      | `mcause   -> to_vec csr @@ Mcause.F.to_list @@ regs.Csr_regs.mcause
      | `mbadaddr -> to_vec csr @@ Mbadaddr.F.to_list @@ regs.Csr_regs.mbadaddr
      | `mip      -> to_vec csr @@ Mip.F.to_list @@ regs.Csr_regs.mip

      | `mbase    -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.mbase
      | `mbound   -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.mbound
      | `mibase   -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.mibase
      | `mibound  -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.mibound
      | `mdbase   -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.mdbase
      | `mdbound  -> to_vec csr @@ Xlen.F.to_list @@ regs.Csr_regs.mdbound

      | _ -> failwith "unsupported CSR"
    in
    let read_csrs = List.mapi 
      (fun i x -> B.(dec.[i:i]), read x) 
      csrs
    in
    B.(pmux read_csrs (B.zero xlen) -- "csr_rdata")

end

module Build(Ifs : Interfaces.S) = struct

  module B = HardCaml.Signal.Comb
  module Machine = Make(B)(Ifs)

  open Ifs

  let csr_index csr = 
    let rec find idx = function 
      | [] -> -1 
      | x::t when x=csr -> idx 
      | _::t -> find (idx+1) t 
    in
    find 0 Ifs.csrs 

  (* all the logic for csrs goes here *)
  let make ~clk ~clr ~csr_ctrl ~ext ~wdata = 
    let module Seq = Utils.Regs(struct let clk=clk let clr=clr end) in
    let open HardCaml.Signal.Comb in
    let open Machine in
    let module X = Xlen.F in
    let open Ifs.Csr_ctrl in
 
    let spec = Machine.csr_spec ext in
  
    let wdata = 
      (mux2 csr_ctrl.csr_use_imm (uresize csr_ctrl.csr_imm 32) wdata) -- "csr_wdata" 
    in

    (* set, clear or write bits to a register *)
    let csr_reg ~cv ~e ~clr ~set ~write ~data ~f = 
      Seq.reg_fb ~e:(e &: (clr |: set |: write)) ~cv ~w:(width cv) 
        (fun dprev ->
          pmux [
            clr, (dprev &: (~: data));
            set, (dprev |: data);
            write, data;
          ] (f dprev))
    in

    (* R/W csr register *)
    let writeable_fb ~csr ~ofs ~cv ~e ~f =
      let csr_index = csr_index csr in
      if csr_index = -1 then cv
      else
        csr_reg ~cv 
          ~e:(e &: csr_ctrl.csr_dec.[csr_index:csr_index])
          ~clr:csr_ctrl.csr_clr
          ~set:csr_ctrl.csr_set
          ~write:csr_ctrl.csr_write
          ~data:(wdata.[(width cv)+ofs-1:ofs]) (* XXX ... from pipeline *)
          ~f
    in
    let writeable = writeable_fb ~f:(fun x -> x) in

    (* R/W csr register that can also be set externally.
     * XXX which should get priority??? *)
    let writeable_ext ~ext_we ~ext_data = writeable_fb ~f:(fun x -> mux2 ext_we ext_data x) in

    (* split 32/32 counter *)
    let counter64 =
      if xlen = 64 then
        writeable_fb ~csr:`mtime ~ofs:0 ~cv:(zero 64) ~e:vdd ~f:(fun d -> d +:. 1)
      else
        let open Ifs.Csr_ctrl in
        let csr_index0 = csr_index `mtime in
        let csr_index1 = csr_index `mtimeh in
        if csr_index0 = (-1) || csr_index1 = (-1) then (zero 64)
        else
          let w = wire 64 in
          let reg ~cv ~e ~clr ~set ~write ~data ~w = 
            Seq.reg_fb ~e:e ~cv ~w:(width cv) 
              (fun dprev ->
                pmux [
                  clr, (dprev &: (~: data));
                  set, (dprev |: data);
                  write, data;
                ] w)
          in
          let rlo = 
            let wr = csr_ctrl.csr_dec.[csr_index0:csr_index0] in
            reg
              ~cv:(zero 32)
              ~e:vdd
              ~clr:(wr &: csr_ctrl.csr_clr)
              ~set:(wr &: csr_ctrl.csr_set)
              ~write:((wr &: csr_ctrl.csr_write) -- "csr_counter_write0")
              ~data:wdata
              ~w:w.[31:0]
          in
          let rhi = 
            let wr = csr_ctrl.csr_dec.[csr_index1:csr_index1] in
            reg
              ~cv:(zero 32)
              ~e:vdd
              ~clr:(wr &: csr_ctrl.csr_clr)
              ~set:(wr &: csr_ctrl.csr_set)
              ~write:((wr &: csr_ctrl.csr_write) -- "csr_counter_write1")
              ~data:wdata
              ~w:w.[63:32]
          in
          let q = rhi @: rlo in
          let () = w <== q +:. 1 in
          q
    in
 
    let regs = 
      Ifs.Csr_regs.(map2 
        (fun (n,b) r ->
          let open B in
          match r with
          | `zero -> zero b
          | `ones -> ones b
          | `consti x -> consti b x
          | `const x -> x
          | `counter64 _ -> counter64.[xlen-1:0]
          | `counter64h _ -> if xlen=32 then counter64.[63:32] else zero 64
          | `writeable(csr, ofs, cv, e) -> writeable ~csr ~ofs ~cv ~e
          | `writeable_ext(csr, ofs, cv, e, ext_we, ext_data) -> 
            writeable_ext ~csr ~ofs ~cv ~e ~ext_we ~ext_data)
        t spec)
    in
    regs, Machine.csr_read_mux csr_ctrl.Ifs.Csr_ctrl.csr_dec regs Ifs.csrs
  
end

