import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regex
import gleam/result
import gleam/set
import gleam/string
import simplifile

pub type Card {
  Card(idx: Int, winning_numbers: List(Int), numbers: List(Int))
}

pub fn parse_numbers(input: String) {
  input
  |> string.split(" ")
  |> list.filter_map(fn(x) {
    x
    |> string.trim
    |> int.parse
  })
}

pub fn parse_card(input: String) {
  let assert Ok(re) =
    regex.from_string(
      "Card *(\\d+): *(\\d+(?: +\\d+)*)(?: \\| *(\\d+(?: +\\d+)*))",
    )

  let matches = regex.scan(re, input)
  case matches {
    [match] -> {
      case match.submatches {
        [Some(idx), Some(winning_numbers), Some(numbers)] ->
          Ok(Card(
            idx: idx
            |> int.parse
            |> result.unwrap(-5),
            winning_numbers: winning_numbers
            |> parse_numbers,
            numbers: numbers
            |> parse_numbers,
          ))
        _ -> Error("invalid card")
      }
    }

    _ -> Error("invalid card")
  }
}

pub fn get_number_of_winners(card: Card) {
  card.winning_numbers
  |> set.from_list
  |> set.intersection(
    card.numbers
    |> set.from_list,
  )
  |> set.size
}

pub fn get_card_score(card: Card) {
  int.bitwise_shift_left(
    1,
    card
    |> get_number_of_winners
    |> int.subtract(1),
  )
}

pub fn get_card_stash(card_winning_numbers: List(Int)) {
  card_winning_numbers
  |> list.index_fold(
    dict.new(),
    fn(acc, number_of_cards_won, idx) {
      let stash = dict.update(acc, idx, fn(count) { option.unwrap(count, 1) })
      let assert Ok(current_card_stash) = dict.get(stash, idx)

      case number_of_cards_won {
        0 -> stash
        _ -> {
          list.range(idx + 1, idx + number_of_cards_won)
          |> list.fold(
            stash,
            fn(acc, won_card_number) {
              dict.update(
                acc,
                won_card_number,
                fn(count) { option.unwrap(count, 1) + current_card_stash },
              )
            },
          )
        }
      }
    },
  )
}

pub fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  file
  |> string.split("\n")
}

pub fn solve_part1(input: List(String)) {
  input
  |> list.filter_map(parse_card)
  |> list.map(get_card_score)
  |> int.sum
}

pub fn solve_part2(input: List(String)) {
  input
  |> list.filter_map(parse_card)
  |> list.map(get_number_of_winners)
  |> get_card_stash
  |> dict.values
  |> int.sum
}

pub fn main() {
  io.println(
    "Part 1 answer: " <> {
      read_input("input.txt")
      |> solve_part1
      |> int.to_string
    },
  )

  io.println(
    "Part 2 answer: " <> {
      read_input("input.txt")
      |> solve_part2
      |> int.to_string
    },
  )
}
