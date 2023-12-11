import gleeunit
import gleeunit/should
import gleam/dict
import day_10.{Position}

pub fn main() {
  gleeunit.main()
}

pub fn parse_input_test() {
  day_10.read_input("example1.txt")
  |> day_10.parse_input
  |> should.equal(dict.from_list([
    #(Position(1, 1), "S"),
    #(Position(2, 1), "-"),
    #(Position(3, 1), "7"),
    #(Position(1, 2), "|"),
    #(Position(3, 2), "|"),
    #(Position(1, 3), "L"),
    #(Position(2, 3), "-"),
    #(Position(3, 3), "J"),
  ]))
}

pub fn get_start_type_example1_test() {
  day_10.read_input("example1.txt")
  |> day_10.parse_input
  |> day_10.get_start_type(Position(1, 1))
  |> should.equal("F")
}

pub fn get_start_type_example2_test() {
  day_10.read_input("example2.txt")
  |> day_10.parse_input
  |> day_10.get_start_type(Position(1, 1))
  |> should.equal("F")
}

pub fn get_start_position_example1_test() {
  day_10.read_input("example1.txt")
  |> day_10.parse_input
  |> day_10.get_start_position
  |> should.equal(Position(1, 1))
}

pub fn walk_example1_test() {
  let map =
    day_10.read_input("example1.txt")
    |> day_10.parse_input

  let start_position = day_10.get_start_position(map)

  day_10.walk(map, start_position, [start_position])
  |> should.equal([
    Position(2, 1),
    Position(3, 1),
    Position(3, 2),
    Position(3, 3),
    Position(2, 3),
    Position(1, 3),
    Position(1, 2),
    Position(1, 1),
  ])
}

pub fn solve_part1_example1_test() {
  day_10.solve_part1("example1.txt")
  |> should.equal(4)
}

pub fn solve_part1_example2_test() {
  day_10.solve_part1("example2.txt")
  |> should.equal(4)
}

pub fn solve_part1_example3_test() {
  day_10.solve_part1("example3.txt")
  |> should.equal(8)
}

pub fn solve_part1_input_test() {
  day_10.solve_part1("input.txt")
  |> should.equal(6886)
}
