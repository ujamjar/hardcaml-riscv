module Make(Ifs : Interfaces.S) : sig

  open HardCaml.Signal.Comb

  module I : interface
    clk clr
    wr wa d
    ra1 ra2
  end

  module O : interface
    q1 q2
  end

  val f : t I.t -> t O.t

end

