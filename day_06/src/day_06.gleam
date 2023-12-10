import gleam/int
import gleam/io
import gleam/iterator
import gleam/list
import gleam/regex
import gleam/result
import gleam/string
import simplifile

pub fn parse_input_part1(input: List(String)) {
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

pub fn parse_input_part2(input: List(String)) {
  let [duration_row, distance_row, _] = input
  let duration =
    duration_row
    |> string.replace("Time: ", "")
    |> string.replace(" ", "")
    |> int.parse
    |> result.unwrap(-1)

  let distance =
    distance_row
    |> string.replace("Distance: ", "")
    |> string.replace(" ", "")
    |> int.parse
    |> result.unwrap(-1)

  #(duration, distance)
}

pub fn get_number_of_ways_to_win(race: #(Int, Int)) {
  let #(duration, record_distance) = race
  let n =
    iterator.range(0, duration / 2)
    |> iterator.filter(fn(speed) {
      let duration_remaining = duration - speed
      let distance_travelled = speed * duration_remaining
      distance_travelled > record_distance
    })
    |> iterator.length

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
  |> parse_input_part1
  |> list.map(get_number_of_ways_to_win)
  |> int.product
}

pub fn solve_part2(filename: String) {
  read_input(filename)
  |> parse_input_part2
  |> get_number_of_ways_to_win
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
