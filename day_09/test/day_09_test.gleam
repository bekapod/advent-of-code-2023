import gleeunit
import gleeunit/should
import day_09

pub fn main() {
  gleeunit.main()
}

pub fn parse_input_test() {
  day_09.read_input("example.txt")
  |> day_09.parse_input
  |> should.equal([
    [0, 3, 6, 9, 12, 15],
    [1, 3, 6, 10, 15, 21],
    [10, 13, 16, 21, 30, 45],
  ])
}

pub fn get_next_sequence_test() {
  [0, 3, 6, 9, 12, 15]
  |> day_09.get_next_sequence
  |> should.equal([3, 3, 3, 3, 3])
}

pub fn finish_sequence_example_1_test() {
  [[0, 3, 6, 9, 12, 15]]
  |> day_09.finish_sequence
  |> should.equal([[0, 0, 0, 0], [3, 3, 3, 3, 3], [0, 3, 6, 9, 12, 15]])
}

pub fn finish_sequence_example_2_test() {
  [[1, 3, 6, 10, 15, 21]]
  |> day_09.finish_sequence
  |> should.equal([
    [0, 0, 0],
    [1, 1, 1, 1],
    [2, 3, 4, 5, 6],
    [1, 3, 6, 10, 15, 21],
  ])
}

pub fn finish_sequence_example_3_test() {
  [[10, 13, 16, 21, 30, 45]]
  |> day_09.finish_sequence
  |> should.equal([
    [0, 0],
    [2, 2, 2],
    [0, 2, 4, 6],
    [3, 3, 5, 9, 15],
    [10, 13, 16, 21, 30, 45],
  ])
}

pub fn extrapolate_example_1_test() {
  [[0, 0, 0, 0], [3, 3, 3, 3, 3], [0, 3, 6, 9, 12, 15]]
  |> day_09.extrapolate
  |> should.equal(18)
}

pub fn extrapolate_example_2_test() {
  [[0, 0, 0], [1, 1, 1, 1], [2, 3, 4, 5, 6], [1, 3, 6, 10, 15, 21]]
  |> day_09.extrapolate
  |> should.equal(28)
}

pub fn extrapolate_example_3_test() {
  [[0, 0], [2, 2, 2], [0, 2, 4, 6], [3, 3, 5, 9, 15], [10, 13, 16, 21, 30, 45]]
  |> day_09.extrapolate
  |> should.equal(68)
}

pub fn extrapolate_backwards_example_1_test() {
  [[0, 0, 0, 0], [3, 3, 3, 3, 3], [0, 3, 6, 9, 12, 15]]
  |> day_09.extrapolate_backwards
  |> should.equal(-3)
}

pub fn extrapolate_backwards_example_2_test() {
  [[0, 0, 0], [1, 1, 1, 1], [2, 3, 4, 5, 6], [1, 3, 6, 10, 15, 21]]
  |> day_09.extrapolate_backwards
  |> should.equal(0)
}

pub fn extrapolate_backwards_example_3_test() {
  [[0, 0], [2, 2, 2], [0, 2, 4, 6], [3, 3, 5, 9, 15], [10, 13, 16, 21, 30, 45]]
  |> day_09.extrapolate_backwards
  |> should.equal(5)
}

pub fn solve_part1_example_test() {
  day_09.solve_part1("example.txt")
  |> should.equal(114)
}

pub fn solve_part1_input_test() {
  day_09.solve_part1("input.txt")
  |> should.equal(1_819_125_966)
}

pub fn solve_part2_example_test() {
  day_09.solve_part2("example.txt")
  |> should.equal(2)
}

pub fn solve_part2_input_test() {
  day_09.solve_part2("input.txt")
  |> should.equal(1140)
}
