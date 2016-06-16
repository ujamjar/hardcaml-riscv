(* a simple asm interface with labels *)

let make ~memory ~start_addr ~code = 
  let labels = Hashtbl.create 73 in
  List.iteri 
    (fun i (label,instr) -> 
      if label <> "" then 
        Hashtbl.add labels label ((i*4) + start_addr))
    code;
  List.iteri 
    (fun i (_, instr) ->
      let cur = start_addr + (i*4) in
      memory.((start_addr/4)+i) <- 
        instr 
          (object
            method cur = cur
            method label l = Hashtbl.find labels l 
            method offset l = Hashtbl.find labels l - cur
          end))
    code

let x i = "", (fun _ -> i)
let l l i = l, (fun _ -> i)
let x' i = "", i
let l' l i = l, i

(* some test routines *)
open Riscv.RV32I_MACHINE.Asm 

let tests = [
  "csrs",
    (fun ~memory ~start_addr ->
    make ~memory ~start_addr ~code:[
      x @@ addi ~rd:1 ~rs1:0 ~imm:0xF0F;       (* x1  = 0xFFFFFF0F *)
      x @@ addi ~rd:2 ~rs1:0 ~imm:0x0F0;       (* x2  = 0x000000F0 *)

      x @@ csrrw ~rd:16 ~rs1:1 ~imm:0x340;     (* csr = 0xFFFFFF0F *)
      x @@ csrrs ~rd:17 ~rs1:2 ~imm:0x340;     (* csr = 0xFFFFFFFF (set bits) *)
      x @@ csrrc ~rd:18 ~rs1:2 ~imm:0x340;     (* csr = 0xFFFFFF0F (unset bits) *)
      x @@ csrrw ~rd:19 ~rs1:2 ~imm:0x340;     (* csr = 0x000000F0 *)
      x @@ csrrs ~rd:20 ~rs1:0 ~imm:0x340;     (* csr = no change *)
      x @@ csrrwi ~rd:21 ~rs1:0x1F ~imm:0x340; (* csf = 0x0000001F *)
      x @@ csrrci ~rd:21 ~rs1:0xF ~imm:0x340;  (* csf = 0x00000010 *)
      x @@ csrrsi ~rd:21 ~rs1:0x6 ~imm:0x340;  (* csf = 0x00000016 *)
    ]);

  "loop",
    (fun ~memory ~start_addr ->
    make ~memory ~start_addr ~code:[
      x @@ addi ~rd:1 ~rs1:0 ~imm:0;
      x @@ addi ~rd:2 ~rs1:0 ~imm:4;
      l "jmp" @@
           addi ~rd:1 ~rs1:1 ~imm:1;
      x' @@ fun x -> 
           bne ~rs1:1 ~rs2:2 ~imm:(x#offset "jmp")
    ]);
]

