import gleeunit
import gleeunit/should
import day_04.{Card}

pub fn main() {
  gleeunit.main()
}

pub fn parse_card_test() {
  "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
  |> day_04.parse_card
  |> should.equal(Ok(Card(
    idx: 1,
    winning_numbers: [41, 48, 83, 86, 17],
    numbers: [83, 86, 6, 31, 17, 9, 48, 53],
  )))
}

pub fn get_card_score_test() {
  Card(
    idx: 1,
    winning_numbers: [41, 48, 83, 86, 17],
    numbers: [83, 86, 6, 31, 17, 9, 48, 53],
  )
  |> day_04.get_card_score
  |> should.equal(8)
}

pub fn get_card_score_example_2_test() {
  let assert Ok(card) =
    "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19"
    |> day_04.parse_card
  card
  |> day_04.get_card_score
  |> should.equal(2)
}

pub fn get_card_score_example_3_test() {
  let assert Ok(card) =
    "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1"
    |> day_04.parse_card
  card
  |> day_04.get_card_score
  |> should.equal(2)
}

pub fn get_card_score_example_4_test() {
  let assert Ok(card) =
    "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83"
    |> day_04.parse_card
  card
  |> day_04.get_card_score
  |> should.equal(1)
}

pub fn get_card_score_example_5_test() {
  let assert Ok(card) =
    "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36"
    |> day_04.parse_card
  card
  |> day_04.get_card_score
  |> should.equal(0)
}

pub fn get_card_score_example_6_test() {
  let assert Ok(card) =
    "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
    |> day_04.parse_card
  card
  |> day_04.get_card_score
  |> should.equal(0)
}

pub fn get_card_score_input_1_test() {
  let assert Ok(card) =
    "Card   1:  8 86 59 90 68 52 55 24 37 69 | 10 55  8 86  6 62 69 68 59 37 91 90 24 22 78 61 58 89 52 96 95 94 13 36 81"
    |> day_04.parse_card
  card
  |> day_04.get_card_score
  |> should.equal(512)
}

pub fn get_card_score_input_63_test() {
  let assert Ok(card) =
    "Card  63: 19 45 77 86  6 33 83 91 52 36 | 18 68 60 58 84 29  9 67 21 99 24 80 69 96 25 85 46 50 95 27 61  4 90 63 88"
    |> day_04.parse_card
  card
  |> day_04.get_card_score
  |> should.equal(0)
}

pub fn get_card_score_input_142_test() {
  let assert Ok(card) =
    "Card 142: 90 10 32 43 65 91 24 22 34 62 | 91 26 72 81  7 11 32 10 90 33 34 87 35 24 29  3 59 62  2 65 22 43 57 74 79"
    |> day_04.parse_card
  card
  |> day_04.get_card_score
  |> should.equal(512)
}

pub fn solve_part1_example_test() {
  day_04.read_input("example.txt")
  |> day_04.solve_part1
  |> should.equal(13)
}

pub fn solve_part1_input_test() {
  day_04.read_input("input.txt")
  |> day_04.solve_part1
  |> should.equal(25_651)
}
