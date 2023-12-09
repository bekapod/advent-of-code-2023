import gleam/int
import gleam/io
import gleam/list
import gleam/regex
import gleam/string
import simplifile

pub fn parse_input(input: List(String)) {
  let [duration_row, distance_row, _] = input

  let assert Ok(re) = regex.from_string("\\d+")
  let matches = regex.scan(re, duration_row)
  let durations =
    matches
    |> list.filter_map(fn(match) {
      match.content
      |> int.parse
    })

  let matches = regex.scan(re, distance_row)
  let distances =
    matches
    |> list.filter_map(fn(match) {
      match.content
      |> int.parse
    })

  durations
  |> list.zip(distances)
}

pub fn get_number_of_ways_to_win(race: #(Int, Int)) {
  let #(duration, record_distance) = race
  let n =
    list.range(0, duration / 2)
    |> list.filter_map(fn(speed) {
      let duration_remaining = duration - speed
      let distance_travelled = speed * duration_remaining
      case distance_travelled > record_distance {
        True -> Ok(speed)
        False -> Error("Not fast enough")
      }
    })
    |> list.length

  case duration % 2 == 0 {
    True -> n * 2 - 1
    False -> n * 2
  }
}

pub fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  file
  |> string.split("\n")
}

pub fn solve_part1(filename: String) {
  read_input(filename)
  |> parse_input
  |> list.map(get_number_of_ways_to_win)
  |> int.product
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
  // let #(runtime, part2) = time(fn() { solve_part2("input.txt") }, Millisecond)
  // io.println(
  //   "Part 2 answer: " <> {
  //     part2
  //     |> int.to_string
  //   } <> " (" <> {
  //     runtime
  //     |> int.to_string
  //   } <> "ms)",
  // )
}

pub type TimeUnit {
  Millisecond
}

@external(erlang, "timer", "tc")
fn time(func: fn() -> anything, unit: TimeUnit) -> #(Int, anything)
