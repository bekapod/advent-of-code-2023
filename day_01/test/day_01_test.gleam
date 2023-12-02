import gleeunit
import gleeunit/should
import day_01

pub fn main() {
  gleeunit.main()
}

pub fn parse_digits_1abc2_test() {
  day_01.parse_digits("1abc2", False)
  |> should.equal(["1", "2"])
}

pub fn parse_digits_pqr3stu8vwx_test() {
  day_01.parse_digits("pqr3stu8vwx", False)
  |> should.equal(["3", "8"])
}

pub fn parse_digits_a1b2c3d4e5f_test() {
  day_01.parse_digits("a1b2c3d4enine5f", False)
  |> should.equal(["1", "2", "3", "4", "5"])
}

pub fn parse_digits_treb7uchet_test() {
  day_01.parse_digits("treb7ucsevenhet", False)
  |> should.equal(["7"])
}

pub fn parse_digits_two1nine_test() {
  day_01.parse_digits("two1nine", True)
  |> should.equal(["2", "1", "9"])
}

pub fn parse_digits_zmeightwohkgs6_test() {
  day_01.parse_digits("zmeightwohkgs6", True)
  |> should.equal(["8", "2", "6"])
}

pub fn capture_digits_1abc2_test() {
  day_01.capture_digits(["1", "2"])
  |> should.equal(["1", "2"])
}

pub fn capture_digits_a1b2c3d4e5f_test() {
  day_01.capture_digits(["1", "2", "3", "4", "5"])
  |> should.equal(["1", "5"])
}

pub fn capture_digits_treb7uchet_test() {
  day_01.capture_digits(["7"])
  |> should.equal(["7", "7"])
}

pub fn capture_digits_blah_test() {
  day_01.capture_digits([])
  |> should.equal(["0", "0"])
}

pub fn get_calibration_value_1abc2_test() {
  day_01.get_calibration_value(["1", "2"])
  |> should.equal(12)
}

pub fn get_calibration_value_treb7uchet_test() {
  day_01.get_calibration_value(["7", "7"])
  |> should.equal(77)
}

pub fn get_calibration_value_10_test() {
  day_01.get_calibration_value(["1", "0"])
  |> should.equal(10)
}

pub fn get_calibration_value_0_test() {
  day_01.get_calibration_value(["0", "0"])
  |> should.equal(0)
}

pub fn get_calibration_value_1_test() {
  day_01.get_calibration_value(["0", "1"])
  |> should.equal(1)
}

pub fn part1_example_test() {
  day_01.solve(["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"], False)
  |> should.equal(142)
}

pub fn part2_example_test() {
  day_01.solve(
    [
      "two1nine", "eightwothree", "abcone2threexyz", "xtwone3four",
      "4nineeightseven2", "zoneight234", "7pqrstsixteen",
    ],
    True,
  )
  |> should.equal(281)
}

pub fn part1_test() {
  day_01.read_input("input.txt")
  |> day_01.solve(False)
  |> should.equal(53_386)
}

pub fn part2_test() {
  day_01.read_input("input.txt")
  |> day_01.solve(True)
  |> should.equal(53_312)
}
