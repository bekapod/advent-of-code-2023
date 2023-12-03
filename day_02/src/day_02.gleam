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

pub type Bag =
  dict.Dict(String, Int)

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

pub fn parse_game(input: String) {
  let result =
    input
    |> string.split(": ")

  case result {
    [meta, rounds] ->
      option.Some(Game(
        parse_game_index(meta),
        rounds
        |> string.split("; ")
        |> list.map(parse_game_round),
      ))
    _ -> option.None
  }
}

pub fn is_game_playable(game: Game, bag: Bag) {
  game.rounds
  |> list.all(fn(round) {
    round
    |> dict.fold(
      True,
      fn(is_currently_playable, colour, count) {
        case is_currently_playable {
          True -> {
            case dict.get(bag, colour) {
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

pub fn get_minimum_bag(game: Game) {
  game.rounds
  |> list.fold(
    dict.new(),
    fn(bag, round) {
      round
      |> dict.fold(
        bag,
        fn(bag, colour, count) {
          dict.update(
            bag,
            colour,
            fn(current_value) {
              case current_value {
                option.Some(current_value) -> int.max(current_value, count)
                _ -> count
              }
            },
          )
        },
      )
    },
  )
}

pub fn get_bag_power(bag: Bag) {
  bag
  |> dict.fold(1, fn(power, _colour, count) { power * count })
}

pub fn solve_part_1(input: List(String), bag: Bag) {
  input
  |> list.filter_map(fn(input) {
    case parse_game(input) {
      option.Some(game) -> {
        case is_game_playable(game, bag) {
          True -> Ok(game.index)
          False -> Error("Game not playable")
        }
      }
      _ -> Error("Invalid game")
    }
  })
  |> int.sum
}

pub fn solve_part_2(input: List(String)) {
  input
  |> list.filter_map(fn(input) {
    case parse_game(input) {
      option.Some(game) -> {
        Ok(
          game
          |> get_minimum_bag
          |> get_bag_power,
        )
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

  io.println(
    "Part 2 answer: " <> {
      read_input("input.txt")
      |> solve_part_2
      |> int.to_string
    },
  )
}
