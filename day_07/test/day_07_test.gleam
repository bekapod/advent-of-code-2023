import gleeunit
import gleeunit/should
import gleam/order
import day_07.{
  FiveOfAKind, FourOfAKind, FullHouse, HighCard, OnePair, ThreeOfAKind, TwoPair,
}

pub fn main() {
  gleeunit.main()
}

pub fn get_hand_type_five_of_a_kind_test() {
  day_07.get_hand_type("AAAAA", False)
  |> should.equal(FiveOfAKind)
}

pub fn get_hand_type_four_of_a_kind_test() {
  day_07.get_hand_type("AA8AA", False)
  |> should.equal(FourOfAKind)
}

pub fn get_hand_type_full_house_test() {
  day_07.get_hand_type("23332", False)
  |> should.equal(FullHouse)
}

pub fn get_hand_type_three_of_a_kind_test() {
  day_07.get_hand_type("TTT98", False)
  |> should.equal(ThreeOfAKind)
}

pub fn get_hand_type_two_pair_test() {
  day_07.get_hand_type("23432", False)
  |> should.equal(TwoPair)
}

pub fn get_hand_type_one_pair_test() {
  day_07.get_hand_type("A23A4", False)
  |> should.equal(OnePair)
}

pub fn get_hand_type_high_card_test() {
  day_07.get_hand_type("23456", False)
  |> should.equal(HighCard)
}

pub fn get_hand_type_joker_rule_test() {
  day_07.get_hand_type("T55J5", True)
  |> should.equal(FourOfAKind)

  day_07.get_hand_type("KTJJT", True)
  |> should.equal(FourOfAKind)

  day_07.get_hand_type("QQQJA", True)
  |> should.equal(FourOfAKind)
}

pub fn parse_input_test() {
  day_07.read_input("example.txt")
  |> day_07.parse_input(False)
  |> should.equal([
    #("32T3K", 765, OnePair),
    #("T55J5", 684, ThreeOfAKind),
    #("KK677", 28, TwoPair),
    #("KTJJT", 220, TwoPair),
    #("QQQJA", 483, ThreeOfAKind),
  ])
}

pub fn compare_hands_equal_test() {
  day_07.compare_hands(
    #("23456", 123, HighCard),
    #("23456", 123, HighCard),
    False,
  )
  |> should.equal(order.Eq)
}

pub fn compare_hands_greater_test() {
  day_07.compare_hands(
    #("AAAAA", 123, FiveOfAKind),
    #("23456", 122, HighCard),
    False,
  )
  |> should.equal(order.Gt)

  day_07.compare_hands(
    #("33332", 123, FourOfAKind),
    #("2AAAA", 122, FourOfAKind),
    False,
  )
  |> should.equal(order.Gt)
}

pub fn compare_hands_less_test() {
  day_07.compare_hands(
    #("23456", 123, HighCard),
    #("AAAAA", 122, FiveOfAKind),
    False,
  )
  |> should.equal(order.Lt)

  day_07.compare_hands(
    #("2AAAA", 123, FourOfAKind),
    #("33332", 122, FourOfAKind),
    False,
  )
  |> should.equal(order.Lt)
}

pub fn solve_part1_test() {
  day_07.solve_part1("example.txt")
  |> should.equal(6440)
}

pub fn solve_part2_test() {
  day_07.solve_part2("example.txt")
  |> should.equal(5905)
}

pub fn solve_part1_input_test() {
  day_07.solve_part1("input.txt")
  |> should.equal(247_815_719)
}

pub fn solve_part2_input_test() {
  day_07.solve_part2("input.txt")
  |> should.equal(248_747_492)
}
