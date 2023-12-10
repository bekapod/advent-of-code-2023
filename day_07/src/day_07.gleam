import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/order.{type Order, Eq, Gt, Lt}
import gleam/result
import gleam/string
import simplifile

pub type HandType {
  FiveOfAKind
  FourOfAKind
  FullHouse
  ThreeOfAKind
  TwoPair
  OnePair
  HighCard
}

fn map_hand_type_to_int(hand_type: HandType) -> Int {
  case hand_type {
    FiveOfAKind -> 6
    FourOfAKind -> 5
    FullHouse -> 4
    ThreeOfAKind -> 3
    TwoPair -> 2
    OnePair -> 1
    HighCard -> 0
  }
}

fn map_card_to_int(card: String) -> Int {
  case card {
    "A" -> 14
    "K" -> 13
    "Q" -> 12
    "J" -> 11
    "T" -> 10
    _ ->
      card
      |> int.parse
      |> result.unwrap(0)
  }
}

pub fn get_hand_type(hand: String) -> HandType {
  let cards =
    hand
    |> string.split("")

  let counts =
    cards
    |> list.group(fn(card) { card })
    |> dict.map_values(fn(_card_type, occurrences) {
      occurrences
      |> list.length
    })
    |> dict.values
    |> list.sort(by: int.compare)

  case counts {
    [5] -> FiveOfAKind
    [1, 4] -> FourOfAKind
    [2, 3] -> FullHouse
    [1, 1, 3] -> ThreeOfAKind
    [1, 2, 2] -> TwoPair
    [1, 1, 1, 2] -> OnePair
    _ -> HighCard
  }
}

pub fn parse_input(input: List(String)) {
  input
  |> list.map(fn(line) {
    let [hand, bid] =
      line
      |> string.split(" ")

    #(
      hand,
      bid
      |> int.parse
      |> result.unwrap(0),
      get_hand_type(hand),
    )
  })
}

pub fn compare_hands(
  hand1: #(String, Int, HandType),
  hand2: #(String, Int, HandType),
) -> Order {
  let #(hand1_cards, _hand1_bid, hand1_type) = hand1
  let #(hand2_cards, _hand2_bid, hand2_type) = hand2

  use <- bool.guard(hand1_cards == hand2_cards, Eq)
  use <- bool.guard(
    map_hand_type_to_int(hand1_type) > map_hand_type_to_int(hand2_type),
    Gt,
  )
  use <- bool.guard(
    map_hand_type_to_int(hand1_type) < map_hand_type_to_int(hand2_type),
    Lt,
  )

  list.zip(
    hand1_cards
    |> string.split(""),
    hand2_cards
    |> string.split(""),
  )
  |> list.fold_until(
    Eq,
    fn(_, cards) {
      let #(card1, card2) = cards
      let card1_int = map_card_to_int(card1)
      let card2_int = map_card_to_int(card2)

      use <- bool.guard(card1_int > card2_int, list.Stop(Gt))
      use <- bool.guard(card1_int < card2_int, list.Stop(Lt))

      list.Continue(Eq)
    },
  )
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
  |> list.sort(by: compare_hands)
  |> list.index_map(fn(idx, hand) {
    let #(_cards, bid, _hand_type) = hand

    bid * { idx + 1 }
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
}

pub type TimeUnit {
  Millisecond
}

@external(erlang, "timer", "tc")
fn time(func: fn() -> anything, unit: TimeUnit) -> #(Int, anything)
