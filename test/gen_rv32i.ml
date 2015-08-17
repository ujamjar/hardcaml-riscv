open HardCamlRiscV.Pipe

let () = Test.write_pipe_stage "fetch" 0 (module Test.Rv.Fetch : Test.Rv.Stage)
let () = Test.write_pipe_stage "decoder" 1 (module Test.Rv.Decoder : Test.Rv.Stage)
let () = Test.write_pipe_stage "alu" 2 (module Test.Rv.Alu : Test.Rv.Stage)
let () = Test.write_pipe_stage "memory" 3 (module Test.Rv.Mem : Test.Rv.Stage)
let () = Test.write_pipe_stage "commit" 4 (module Test.Rv.Commit : Test.Rv.Stage)
let () = Test.write_core()

