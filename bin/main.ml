let extract_string json =
  match json with
  | `String s -> s
  | _ -> ""
let extract_list json =
  match json with
  | `List l -> l
  | _ -> []

let () =
  let stdin = Stdio.stdin in
  let cardinfo = Yojson.Basic.from_channel stdin in
  match cardinfo with
  | `Assoc m ->
      let date = List.assoc "date" m |> extract_string in
      let title = List.assoc "title" m |> extract_string in
      let authors = List.assoc "authors" m |> extract_list |> List.map extract_string in
      let doi = List.assoc "doi" m |> extract_string in
      let abstract = List.assoc "abstract" m |> extract_string in
      print_endline date;
      print_endline title;
      print_endline doi;
      print_endline abstract;
  | _ ->
      print_string "Error: cardinfo is not an object";
      print_endline (Yojson.Basic.to_string cardinfo)
