import gleeunit
import gleeunit/should
import day_05

pub fn main() {
  gleeunit.main()
}

pub fn parse_seed_numbers_test() {
  "seeds: 79 14 55 13"
  |> day_05.parse_seed_numbers
  |> should.equal(Ok([79, 14, 55, 13]))
}

pub fn parse_seed_ranges_test() {
  "seeds: 79 14 55 13"
  |> day_05.parse_seed_ranges
  |> should.equal(Ok([#(79, 92), #(55, 67)]))
}

pub fn parse_seed_soil_map_test() {
  ["seed-to-soil map:", "50 98 2", "52 50 48"]
  |> day_05.parse_map("seed-to-soil map:")
  |> should.equal(Ok([#(#(98, 99), #(50, 51)), #(#(50, 97), #(52, 99))]))
}

pub fn read_input_test() {
  let #(a, b, c, _, _, _, _, _) =
    day_05.read_input("example.txt", day_05.parse_seed_numbers)

  a
  |> should.equal(Ok([79, 14, 55, 13]))

  b
  |> should.equal(Ok([#(#(98, 99), #(50, 51)), #(#(50, 97), #(52, 99))]))

  c
  |> should.equal(Ok([
    #(#(15, 51), #(0, 36)),
    #(#(52, 53), #(37, 38)),
    #(#(0, 14), #(39, 53)),
  ]))
}

pub fn find_in_map_exists_test() {
  let map = [#(#(98, 99), #(50, 51)), #(#(50, 97), #(52, 99))]

  day_05.find_in_map(79, map)
  |> should.equal(81)

  day_05.find_in_map(55, map)
  |> should.equal(57)
}

pub fn find_in_map_not_exists_test() {
  let map = [#(#(98, 99), #(50, 51)), #(#(50, 97), #(52, 99))]

  day_05.find_in_map(14, map)
  |> should.equal(14)

  day_05.find_in_map(13, map)
  |> should.equal(13)
}

pub fn find_in_map_reverse_exists_test() {
  let map = [#(#(98, 99), #(50, 51)), #(#(50, 97), #(52, 99))]

  day_05.find_in_map_reverse(81, map)
  |> should.equal(79)

  day_05.find_in_map_reverse(57, map)
  |> should.equal(55)
}

pub fn find_in_map_reverse_not_exists_test() {
  let map = [#(#(98, 99), #(50, 51)), #(#(50, 97), #(52, 99))]

  day_05.find_in_map_reverse(14, map)
  |> should.equal(14)

  day_05.find_in_map_reverse(13, map)
  |> should.equal(13)
}

pub fn solve_part1_test() {
  day_05.solve_part1("example.txt")
  |> should.equal(35)
}

pub fn solve_part1_input_test() {
  day_05.solve_part1("input.txt")
  |> should.equal(3_374_647)
}

pub fn solve_part2_test() {
  day_05.solve_part2("example.txt")
  |> should.equal(46)
}
