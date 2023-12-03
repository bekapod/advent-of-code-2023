import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regex
import gleam/result
import gleam/string
import simplifile

pub type Game {
  Game(index: Int, rounds: List(dict.Dict(String, Int)))
}

pub fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  file
  |> string.split("\n")
}

pub fn parse_game_index(meta: String) {
  let assert Ok(re) = regex.from_string("Game (\\d+)")
  let matches = regex.scan(re, meta)
  case matches {
    [match] -> {
      case match.submatches {
        [option.Some(index)] -> {
          int.parse(index)
          |> result.unwrap(0)
        }
        _ -> 0
      }
    }
    _ -> 0
  }
}

pub fn parse_game_round(input: String) {
  let assert Ok(re) = regex.from_string("(\\d+) (\\w+)")

  regex.scan(re, input)
  |> list.fold(
    dict.new(),
    fn(round, match) {
      case match.submatches {
        [option.Some(value), option.Some(colour)] -> {
          round
          |> dict.insert(
            colour,
            int.parse(value)
            |> result.unwrap(0),
          )
        }
        _ -> round
      }
    },
  )
}

pub fn parse_game_rounds(input: String) {
  input
  |> string.split("; ")
  |> list.map(parse_game_round)
}

pub fn parse_game(input: String) {
  let result =
    input
    |> string.split(": ")

  case result {
    [meta, rounds] ->
      option.Some(Game(parse_game_index(meta), parse_game_rounds(rounds)))
    _ -> option.None
  }
}

pub fn is_game_playable(game: Game, bag_contents: dict.Dict(String, Int)) {
  game.rounds
  |> list.all(fn(round) {
    round
    |> dict.fold(
      True,
      fn(is_currently_playable, colour, count) {
        case is_currently_playable {
          True -> {
            case dict.get(bag_contents, colour) {
              Ok(bag_count) -> bag_count >= count
              _ -> False
            }
          }
          False -> False
        }
      },
    )
  })
}

pub fn solve_part_1(input: List(String), bag_contents: dict.Dict(String, Int)) {
  input
  |> list.filter_map(fn(input) {
    case parse_game(input) {
      option.Some(game) -> {
        case is_game_playable(game, bag_contents) {
          True -> Ok(game.index)
          False -> Error("Game not playable")
        }
      }
      _ -> Error("Invalid game")
    }
  })
  |> int.sum
}

pub fn main() {
  io.println(
    "Part 1 answer: " <> {
      read_input("input.txt")
      |> solve_part_1(dict.from_list([
        #("red", 12),
        #("green", 13),
        #("blue", 14),
      ]))
      |> int.to_string
    },
  )
}
