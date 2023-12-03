import gleeunit
import gleeunit/should
import gleam/dict
import gleam/option
import day_02

pub fn main() {
  gleeunit.main()
}

pub fn parse_game_index_1_test() {
  day_02.parse_game_index("Game 1")
  |> should.equal(1)
}

pub fn parse_game_index_23_test() {
  day_02.parse_game_index("Game 24")
  |> should.equal(24)
}

pub fn parse_game_index_empty_test() {
  day_02.parse_game_index("")
  |> should.equal(0)
}

pub fn parse_game_round_test() {
  day_02.parse_game_round("3 blue, 4 red, 25 green")
  |> should.equal(dict.from_list([#("red", 4), #("blue", 3), #("green", 25)]))
}

pub fn parse_game_round_empty_test() {
  day_02.parse_game_round("")
  |> should.equal(dict.from_list([]))
}

pub fn parse_game_example_1_test() {
  day_02.parse_game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
  |> should.equal(option.Some(day_02.Game(
    1,
    [
      dict.from_list([#("red", 4), #("blue", 3)]),
      dict.from_list([#("red", 1), #("green", 2), #("blue", 6)]),
      dict.from_list([#("green", 2)]),
    ],
  )))
}

pub fn parse_game_example_3_test() {
  day_02.parse_game(
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
  )
  |> should.equal(option.Some(day_02.Game(
    3,
    [
      dict.from_list([#("green", 8), #("blue", 6), #("red", 20)]),
      dict.from_list([#("blue", 5), #("red", 4), #("green", 13)]),
      dict.from_list([#("green", 5), #("red", 1)]),
    ],
  )))
}

pub fn parse_game_empty_test() {
  day_02.parse_game("")
  |> should.equal(option.None)
}

pub fn is_game_playable_yes_test() {
  day_02.is_game_playable(
    day_02.Game(
      1,
      [
        dict.from_list([#("red", 4), #("blue", 3)]),
        dict.from_list([#("red", 1), #("green", 2), #("blue", 6)]),
        dict.from_list([#("green", 2)]),
      ],
    ),
    dict.from_list([#("red", 12), #("green", 13), #("blue", 14)]),
  )
  |> should.equal(True)
}

pub fn is_game_playable_no_test() {
  day_02.is_game_playable(
    day_02.Game(
      1,
      [
        dict.from_list([#("green", 1), #("red", 3), #("blue", 6)]),
        dict.from_list([#("green", 3), #("red", 6)]),
        dict.from_list([#("green", 3), #("blue", 15), #("red", 14)]),
      ],
    ),
    dict.from_list([#("red", 12), #("green", 13), #("blue", 13)]),
  )
  |> should.equal(False)
}

pub fn is_game_playable_no_again_test() {
  day_02.is_game_playable(
    day_02.Game(
      96,
      [
        dict.from_list([#("blue", 20), #("green", 18), #("red", 3)]),
        dict.from_list([#("blue", 1), #("green", 20), #("red", 1)]),
        dict.from_list([#("blue", 18), #("green", 4), #("red", 8)]),
      ],
    ),
    dict.from_list([#("red", 12), #("green", 13), #("blue", 14)]),
  )
  |> should.equal(False)
}

pub fn get_minimum_bag_test() {
  day_02.get_minimum_bag(day_02.Game(
    1,
    [
      dict.from_list([#("red", 4), #("blue", 3)]),
      dict.from_list([#("red", 1), #("green", 2), #("blue", 6)]),
      dict.from_list([#("green", 2)]),
    ],
  ))
  |> should.equal(dict.from_list([#("red", 4), #("green", 2), #("blue", 6)]))
}

pub fn get_minimum_bag_again_test() {
  day_02.get_minimum_bag(day_02.Game(
    1,
    [
      dict.from_list([#("green", 1), #("red", 3), #("blue", 6)]),
      dict.from_list([#("green", 3), #("red", 6)]),
      dict.from_list([#("green", 3), #("blue", 15), #("red", 14)]),
    ],
  ))
  |> should.equal(dict.from_list([#("red", 14), #("green", 3), #("blue", 15)]))
}

pub fn solve_part_1_example_test() {
  day_02.read_input("example.txt")
  |> day_02.solve_part_1(dict.from_list([
    #("red", 12),
    #("green", 13),
    #("blue", 14),
  ]))
  |> should.equal(8)
}

pub fn solve_part_1_input_test() {
  day_02.read_input("input.txt")
  |> day_02.solve_part_1(dict.from_list([
    #("red", 12),
    #("green", 13),
    #("blue", 14),
  ]))
  |> should.equal(2239)
}

pub fn solve_part_2_example_test() {
  day_02.read_input("example.txt")
  |> day_02.solve_part_2
  |> should.equal(2286)
}

pub fn solve_part_2_input_test() {
  day_02.read_input("input.txt")
  |> day_02.solve_part_2
  |> should.equal(83_435)
}
