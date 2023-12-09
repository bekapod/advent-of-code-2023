import gleeunit
import gleeunit/should
import day_06

pub fn main() {
  gleeunit.main()
}

pub fn parse_input_test() {
  day_06.read_input("example.txt")
  |> day_06.parse_input
  |> should.equal([#(7, 9), #(15, 40), #(30, 200)])
}

pub fn get_number_of_ways_to_win_1_test() {
  #(7, 9)
  |> day_06.get_number_of_ways_to_win
  |> should.equal(4)
}

pub fn get_number_of_ways_to_win_2_test() {
  #(15, 40)
  |> day_06.get_number_of_ways_to_win
  |> should.equal(8)
}

pub fn get_number_of_ways_to_win_3_test() {
  #(30, 200)
  |> day_06.get_number_of_ways_to_win
  |> should.equal(9)
}

pub fn solve_part1_test() {
  day_06.solve_part1("example.txt")
  |> should.equal(288)
}

pub fn solve_part1_input_test() {
  day_06.solve_part1("input.txt")
  |> should.equal(4_568_778)
}
