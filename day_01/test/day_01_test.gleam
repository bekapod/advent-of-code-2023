import gleeunit
import gleeunit/should
import day_01

pub fn main() {
  gleeunit.main()
}

pub fn parse_digits_1abc2_test() {
  day_01.parse_digits("1abc2")
  |> should.equal(["1", "2"])
}

pub fn parse_digits_pqr3stu8vwx_test() {
  day_01.parse_digits("pqr3stu8vwx")
  |> should.equal(["3", "8"])
}

pub fn parse_digits_a1b2c3d4e5f_test() {
  day_01.parse_digits("a1b2c3d4e5f")
  |> should.equal(["1", "2", "3", "4", "5"])
}

pub fn parse_digits_treb7uchet_test() {
  day_01.parse_digits("treb7uchet")
  |> should.equal(["7"])
}

pub fn capture_digits_1abc2_test() {
  day_01.capture_digits("1abc2")
  |> should.equal(["1", "2"])
}

pub fn capture_digits_pqr3stu8vwx_test() {
  day_01.capture_digits("pqr3stu8vwx")
  |> should.equal(["3", "8"])
}

pub fn capture_digits_a1b2c3d4e5f_test() {
  day_01.capture_digits("a1b2c3d4e5f")
  |> should.equal(["1", "5"])
}

pub fn capture_digits_treb7uchet_test() {
  day_01.capture_digits("treb7uchet")
  |> should.equal(["7", "7"])
}

pub fn get_calibration_value_1abc2_test() {
  day_01.get_calibration_value("1abc2")
  |> should.equal(12)
}

pub fn get_calibration_value_pqr3stu8vwx_test() {
  day_01.get_calibration_value("pqr3stu8vwx")
  |> should.equal(38)
}

pub fn get_calibration_value_a1b2c3d4e5f_test() {
  day_01.get_calibration_value("a1b2c3d4e5f")
  |> should.equal(15)
}

pub fn get_calibration_value_treb7uchet_test() {
  day_01.get_calibration_value("treb7uchet")
  |> should.equal(77)
}

pub fn part1_example_test() {
  day_01.part1(["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"])
  |> should.equal(142)
}
