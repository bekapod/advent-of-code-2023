import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn is_done(input: List(Int)) {
  input
  |> list.all(fn(n) { n == 0 })
}

pub fn get_next_sequence(input: List(Int)) {
  input
  |> list.window_by_2
  |> list.map(fn(pair) { pair.1 - pair.0 })
}

pub fn finish_sequence(input: List(List(Int))) {
  let [head, ..] = input
  case is_done(head) {
    True -> input
    False -> finish_sequence([get_next_sequence(head), ..input])
  }
}

pub fn extrapolate(input: List(List(Int))) {
  input
  |> list.fold(
    0,
    fn(acc, input) {
      let assert Ok(last) =
        input
        |> list.last
      last + acc
    },
  )
}

pub fn extrapolate_backwards(input: List(List(Int))) {
  input
  |> list.fold(
    0,
    fn(acc, input) {
      let assert Ok(head) =
        input
        |> list.first
      head - acc
    },
  )
}

pub fn parse_input(input: List(String)) {
  input
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.filter_map(fn(n) {
      n
      |> int.parse
    })
  })
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
  |> list.map(fn(input) {
    [input]
    |> finish_sequence
    |> extrapolate
  })
  |> int.sum
}

pub fn solve_part2(filename: String) {
  read_input(filename)
  |> parse_input
  |> list.map(fn(input) {
    [input]
    |> finish_sequence
    |> extrapolate_backwards
  })
  |> int.sum
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

  let #(runtime, part2) = time(fn() { solve_part2("input.txt") }, Millisecond)
  io.println(
    "Part 2 answer: " <> {
      part2
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
