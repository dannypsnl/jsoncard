let () =
  let stdin = Stdio.stdin in
  Yojson.Basic.from_channel stdin
  |> Yojson.Basic.to_string
  |> print_endline
