let extract_string json =
  match json with
  | `String s -> s
  | _ -> ""
let extract_list json =
  match json with
  | `List l -> l
  | _ -> []

let author s = "\\author{" ^ s ^ "}"

type arxivcard = {
  date: string;         [@printer fun fmt -> fprintf fmt "\\date{%s}"]
  title: string;        [@printer fun fmt -> fprintf fmt "\\title{%s}"]
  authors: string list; [@printer fun fmt a -> List.map author a |> String.concat "" |> fprintf fmt "%s"]
  doi: string;          [@printer fun fmt -> fprintf fmt "\\meta{doi}{%s}"]
  abstract: string      [@printer fun fmt -> fprintf fmt "\\p{%s}"]
} [@@deriving show]

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
      let card : arxivcard = {
        date;
        title;
        authors;
        doi;
        abstract
      } in
      print_endline (show_arxivcard card)
  | _ ->
      print_string "Error: cardinfo is not an object";
      print_endline (Yojson.Basic.to_string cardinfo)
