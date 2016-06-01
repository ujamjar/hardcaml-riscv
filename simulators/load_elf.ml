(* use https://github.com/crabtw/ocaml-elf to load the elf into memory *)

module type T = module type of Mem32.Mem

module Make(M : T) = struct

  type sym32 = 
    {
      st32_name : Int32.t;
      st32_value : Int32.t;
      st32_size : Int32.t;
      st32_info : int; (* 8 *)
      st32_other : int; (* 8 *)
      st32_shndx : int; (* 16 *)
    }

  type sym64 = 
    {
      st64_name : Int32.t;
      st64_info: int (* 8 *);
      st64_other: int (* 8 *);
      st64_shndx: int (* 16 *);
      st64_value : Int64.t;
      st64_size : Int64.t;
    }

  let get_8 s o = Char.code s.[o]
  let get_16 s o = 
    (Char.code s.[o+0] lsl 0) lor
    (Char.code s.[o+1] lsl 8)
  let get_32 s o = 
    fst @@ List.fold_left 
      (fun (r,i) x -> Int32.(logor r (shift_left (of_int x) i)), i+8)
      (0l,0) (List.map Char.code [ s.[o+0]; 
                                   s.[o+1]; 
                                   s.[o+2]; 
                                   s.[o+3]; ])
  let get_64 s o = 
    fst @@ List.fold_left 
      (fun (r,i) x -> Int64.(logor r (shift_left (of_int x) i)), i+8)
      (0L,0) (List.map Char.code [ s.[o+0]; 
                                   s.[o+1]; 
                                   s.[o+2]; 
                                   s.[o+3]; 
                                   s.[o+4]; 
                                   s.[o+5]; 
                                   s.[o+6]; 
                                   s.[o+7]; ])

  let get_sym32 s o = 
    let st32_name  = get_32 s (o+ 0) in
    let st32_value = get_32 s (o+ 4) in
    let st32_size  = get_32 s (o+ 8) in
    let st32_info  = get_8  s (o+12) in
    let st32_other = get_8  s (o+13) in
    let st32_shndx = get_16 s (o+14) in
    { st32_name; st32_value; st32_size; st32_info; st32_other; st32_shndx }

  let get_sym64 s o = 
    let st64_name  = get_32 s (o+ 0) in
    let st64_info  = get_8  s (o+12) in
    let st64_other = get_8  s (o+13) in
    let st64_shndx = get_16 s (o+14) in
    let st64_value = get_64 s (o+ 4) in
    let st64_size  = get_64 s (o+ 8) in
    { st64_name; st64_value; st64_size; st64_info; st64_other; st64_shndx }


  let print_sym32 s = 
    let open Printf in
    printf "{ name  = %li\n" s.st32_name;
    printf "  value = %li\n" s.st32_value;
    printf "  size  = %li\n" s.st32_size;
    printf "  info  = %i\n"  s.st32_info;
    printf "  other = %i\n"  s.st32_other;
    printf "  shndx = %i"    s.st32_shndx;
    printf " }\n"

  let print_sym64 s = 
    let open Printf in
    printf "{ name  = %li\n" s.st64_name;
    printf "  info  = %i\n"  s.st64_info;
    printf "  other = %i\n"  s.st64_other;
    printf "  shndx = %i\n"    s.st64_shndx;
    printf "  value = %Li\n" s.st64_value;
    printf "  size  = %Li" s.st64_size;
    printf " }\n"

  let sym32_length = 16
  let sym64_length = 24

  (*type sym = S64 of sym64 | S32 of sym32*)
  type sym = sym64
  let get_sym = get_sym64
  let print_sym = print_sym64
  let sym_length = sym64_length

  let get_string s n = 
    let rec f n = if s.[n] = Char.chr 0 then n else f (n+1) in
    let e = f n in
    String.sub s n (e-n)

  module String_map = Map.Make(String)

  let to_mem fname mem = 
    let open Elf in
    let f = open_in fname in
    let len = in_channel_length f in
    let s = String.make len ' ' in
    let rec read pos = 
      if pos = len then s
      else read (pos + input f s pos (len-pos))
    in
    let elf = read 0 in
    close_in f;
    match parse elf with
    | None -> failwith ("couldnt load elf file " ^ fname)
    | Some(elf) -> begin
      (* load all segments *)
      List.iter (fun ph ->
        let fsize = String.length ph.p_data in
        let write_byte addr data = (* XXX this should be in the Mem module *)
          let data = Mem32.D.of_int data in
          let lo_addr = addr land 3 in
          let addr = addr land (lnot 3) in
          let data,strb = 
            match lo_addr with
            | 0 ->             data   , 1
            | 1 -> Mem32.D.sll data  8, 2
            | 2 -> Mem32.D.sll data 16, 4
            | _ -> Mem32.D.sll data 24, 8
          in
          M.write' ~memory:mem ~addr:addr ~data ~strb
        in
        (*Printf.printf "segment: %i(%Li) -> %Li\n" fsize ph.p_memsz ph.p_paddr;*)
        (* load data *)
        for i=0 to fsize - 1 do
          (*M.store 0 mem (i + Int64.to_int ph.p_paddr) 
            (T.D.of_int (Char.code ph.p_data.[i]))*)
          let addr = i + Int64.to_int ph.p_paddr in
          let data = Char.code ph.p_data.[i] in
          write_byte addr data 
        done;
        (* zeros up to memsz *)
        for i=fsize to Int64.to_int ph.p_memsz - 1 do
          (*M.store 0 mem (i + Int64.to_int ph.p_paddr) (T.D.zero)*)
          let addr = i + Int64.to_int ph.p_paddr in 
          write_byte addr 0
        done;
      ) elf.e_segments;
      (* grap the .strtab and .symtab sections *)
      let symtab,strtab = List.fold_left 
        (fun (sym,str) sh ->
          (if sh.sh_type <> SHT_NOBITS && sh.sh_name = ".symtab" then Some(sh) else sym),
          (if sh.sh_type <> SHT_NOBITS && sh.sh_name = ".strtab" then Some(sh) else str)) 
        (None,None) elf.e_sections
      in
      match symtab,strtab with
      | Some(symtab),Some(strtab) -> begin
        (* extract info *)
        let len = String.length symtab.sh_data in
        let rec f n m =
          if n >= len then m
          else 
            let sym = get_sym symtab.sh_data n in
            let str = get_string strtab.sh_data (Int32.to_int sym.st64_name) in
            f (n + sym_length) String_map.(add str sym m)
        in
        f 0 String_map.empty
      end
      | _ -> begin
        String_map.empty
      end
    end

end

