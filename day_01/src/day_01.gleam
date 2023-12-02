import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regex
import gleam/result
import gleam/string
import simplifile

pub fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  file
  |> string.split("\n")
}

pub fn parse_digits(input: String, parse_words: Bool) {
  let assert Ok(re) = case parse_words {
    True ->
      regex.from_string(
        "(?=(one|two|three|four|five|six|seven|eight|nine|[0-9]))\\w|\\d",
      )
    False -> regex.from_string("(?=(\\d))\\w|\\d")
  }

  let matches = regex.scan(re, input)

  matches
  |> list.map(fn(m) {
    case m.content {
      "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> m.content
      _ -> {
        case m.submatches {
          [option.Some("one")] -> "1"
          [option.Some("two")] -> "2"
          [option.Some("three")] -> "3"
          [option.Some("four")] -> "4"
          [option.Some("five")] -> "5"
          [option.Some("six")] -> "6"
          [option.Some("seven")] -> "7"
          [option.Some("eight")] -> "8"
          [option.Some("nine")] -> "9"
          _ -> "0"
        }
      }
    }
  })
}

pub fn capture_digits(input: List(String)) {
  case input {
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

pub fn get_calibration_value(input: List(String)) {
  input
  |> string.concat
  |> int.parse
  |> result.unwrap(0)
}

pub fn solve(input: List(String), parse_words: Bool) {
  input
  |> list.map(fn(line) { parse_digits(line, parse_words) })
  |> list.map(capture_digits)
  |> list.map(get_calibration_value)
  |> int.sum
}

pub fn main() {
  io.println(
    "Part 1 answer: " <> {
      read_input("input.txt")
      |> solve(False)
      |> int.to_string
    },
  )
  io.println(
    "Part 2 answer: " <> {
      read_input("input.txt")
      |> solve(True)
      |> int.to_string
    },
  )
}
