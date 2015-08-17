module T : sig
  type t = 
    | Lui | Auipc 
    | Jal | Jalr 
    | Beq | Bne | Blt | Bge | Bltu | Bgeu 
    | Lb | Lh | Lw | Lbu | Lhu | Sb | Sh | Sw 
    | Addi | Slti | Sltiu | Xori | Ori | Andi | Slli | Srli | Srai 
    | Add | Sub | Sll | Slt | Sltu | Xor | Srl | Sra | Or | And 
    | Fence | Fenchi | Scall | Sbreak
    | Rdcycle | Rdcycleh | Rdtime | Rdtimeh | Rdinstret | Rdinstreth 
    | Trap 
    deriving(Enum,Bounded,Show)
  val name : string
end
module V : Utils.BVec_S with type t = T.t

