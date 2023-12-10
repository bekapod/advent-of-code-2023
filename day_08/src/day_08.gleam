import gleam/dict.{type Dict}
import gleam/int
import gleam/iterator.{type Iterator}
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regex
import gleam/string
import simplifile

pub type Direction {
  Left
  Right
}

pub type Map {
  Map(instructions: Iterator(Direction), nodes: Dict(String, #(String, String)))
}

pub fn parse_input(input: List(String)) -> Map {
  let [instructions, _, ..rest] = input
  let assert Ok(re) = regex.from_string("([A-Z]+) = \\(([A-Z]+), ([A-Z]+)\\)")

  Map(
    instructions: instructions
    |> string.split("")
    |> list.map(fn(char) {
      case char {
        "L" -> Left
        "R" -> Right
        _ -> panic("Invalid direction")
      }
    })
    |> iterator.from_list
    |> iterator.cycle,
    nodes: rest
    |> list.map(fn(node) {
      let [match] = regex.scan(re, node)

      case match.submatches {
        [Some(name), Some(left), Some(right)] -> #(name, #(left, right))
        _ -> panic("Invalid node")
      }
    })
    |> dict.from_list,
  )
}

fn walk(map: Map) -> Int {
  let Map(instructions, nodes) = map

  instructions
  |> iterator.fold_until(
    [
      #(
        "AAA",
        nodes
        |> dict.get("AAA"),
      ),
    ],
    fn(visited_nodes, direction) {
      let assert Ok(#(current_node, paths)) =
        visited_nodes
        |> list.first

      case current_node {
        "ZZZ" -> list.Stop(visited_nodes)
        _ -> {
          let assert Ok(#(left, right)) = paths

          let next_node = case direction {
            Left -> {
              #(left, dict.get(nodes, left))
            }
            Right -> {
              #(right, dict.get(nodes, right))
            }
          }

          list.Continue([next_node, ..visited_nodes])
        }
      }
    },
  )
  |> list.length
  |> int.subtract(1)
}

pub fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  file
  |> string.trim
  |> string.split("\n")
}

pub fn solve_part1(filename: String) {
  read_input(filename)
  |> parse_input
  |> walk
}

pub fn main() {
  let #(runtime, part1) = time(fn() { solve_part1("input.txt") }, Millisecond)
  io.println(
    "Part 1 answer: " <> {
      part1
      |> int.to_string
    } <> " (" <> {
      runtime
      |> int.to_string
    } <> "ms)",
  )
}

pub type TimeUnit {
  Millisecond
}

@external(erlang, "timer", "tc")
fn time(func: fn() -> anything, unit: TimeUnit) -> #(Int, anything)
