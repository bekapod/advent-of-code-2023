import gleam/int
import gleam/io
import gleam/list
import gleam/regex
import gleam/result
import gleam/string
import simplifile

fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  file
  |> string.split("\n")
}

pub fn parse_digits(input: String) {
  let assert Ok(re) = regex.from_string("[0-9]")
  regex.scan(re, input)
  |> list.map(fn(m) { m.content })
}

pub fn capture_digits(input: String) {
  case parse_digits(input) {
    [] -> ["0", "0"]
    [digit] -> [digit, digit]
    [first, ..rest] -> {
      let [last, ..] =
        rest
        |> list.reverse

      [first, last]
    }
  }
}

pub fn get_calibration_value(input: String) {
  capture_digits(input)
  |> string.concat
  |> int.parse
  |> result.unwrap(0)
}

pub fn part1(input: List(String)) {
  input
  |> list.map(get_calibration_value)
  |> list.fold(0, int.add)
}

pub fn main() {
  io.println(
    "Part 1: " <> {
      read_input("input.txt")
      |> part1
      |> int.to_string
    },
  )
}
