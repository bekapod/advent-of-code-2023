import gleeunit
import gleeunit/should
import gleam/dict
import gleam/iterator
import day_08.{Left, Map, Right}

pub fn main() {
  gleeunit.main()
}

pub fn parse_input_test() {
  day_08.read_input("example1.txt")
  |> day_08.parse_input
  |> should.equal(Map(
    instructions: [Right, Left]
    |> iterator.from_list
    |> iterator.cycle,
    nodes: [
      #("AAA", #("BBB", "CCC")),
      #("BBB", #("DDD", "EEE")),
      #("CCC", #("ZZZ", "GGG")),
      #("DDD", #("DDD", "DDD")),
      #("EEE", #("EEE", "EEE")),
      #("GGG", #("GGG", "GGG")),
      #("ZZZ", #("ZZZ", "ZZZ")),
    ]
    |> dict.from_list,
  ))
}

pub fn solve_part1_example1_test() {
  day_08.solve_part1("example1.txt")
  |> should.equal(2)
}

pub fn solve_part1_example2_test() {
  day_08.solve_part1("example2.txt")
  |> should.equal(6)
}

pub fn solve_part1_input_test() {
  day_08.solve_part1("input.txt")
  |> should.equal(19_241)
}

pub fn solve_part2_example1_test() {
  day_08.solve_part2("example1.txt")
  |> should.equal(2)
}

pub fn solve_part2_example2_test() {
  day_08.solve_part2("example2.txt")
  |> should.equal(6)
}

pub fn solve_part2_example3_test() {
  day_08.solve_part2("example3.txt")
  |> should.equal(6)
}

pub fn solve_part2_input_test() {
  day_08.solve_part2("input.txt")
  |> should.equal(9_606_140_307_013)
}
