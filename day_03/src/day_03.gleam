import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Coordinate {
  Coordinate(x: Int, y: Int)
}

pub type Part {
  Part(number: List(Int), coordinates: List(Coordinate))
}

pub type Symbol {
  Symbol(name: String, coordinate: Coordinate)
}

pub type Schematic {
  Schematic(parts: List(Part), symbols: List(Symbol))
}

pub fn parse_schematic(input: List(String)) {
  input
  |> list.index_fold(
    Schematic(parts: [], symbols: []),
    fn(schematic, line, y_idx) {
      line
      |> string.split("")
      |> list.index_fold(
        schematic,
        fn(schematic, char, x_idx) {
          case char {
            "." -> schematic
            "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" -> {
              let previous_part =
                schematic.parts
                |> list.first

              case previous_part {
                Ok(part) -> {
                  // there was a previous part
                  let previous_coordinate =
                    part.coordinates
                    |> list.first

                  case previous_coordinate {
                    Ok(coordinate) -> {
                      // there was a previous coordinate
                      case coordinate.x + 1 == x_idx {
                        True -> {
                          // the previous coordinate is next to the current one
                          Schematic(
                            parts: [
                              Part(
                                number: [
                                  int.parse(char)
                                  |> result.unwrap(0),
                                  ..part.number
                                ],
                                coordinates: [
                                  Coordinate(x: x_idx, y: y_idx),
                                  ..part.coordinates
                                ],
                              ),
                              ..{
                                schematic.parts
                                |> list.rest
                                |> result.unwrap([])
                              }
                            ],
                            symbols: schematic.symbols,
                          )
                        }

                        False -> {
                          // the previous coordinate is not next to the current one
                          Schematic(
                            parts: [
                              Part(
                                number: [
                                  int.parse(char)
                                  |> result.unwrap(0),
                                ],
                                coordinates: [Coordinate(x: x_idx, y: y_idx)],
                              ),
                              ..schematic.parts
                            ],
                            symbols: schematic.symbols,
                          )
                        }
                      }
                    }
                    _ -> {
                      // there was no previous coordinate
                      Schematic(
                        parts: [
                          Part(
                            number: [
                              int.parse(char)
                              |> result.unwrap(0),
                            ],
                            coordinates: [Coordinate(x: x_idx, y: y_idx)],
                          ),
                          ..schematic.parts
                        ],
                        symbols: schematic.symbols,
                      )
                    }
                  }
                }
                _ -> {
                  // there was no previous part
                  Schematic(
                    parts: [
                      Part(
                        number: [
                          int.parse(char)
                          |> result.unwrap(0),
                        ],
                        coordinates: [Coordinate(x: x_idx, y: y_idx)],
                      ),
                      ..schematic.parts
                    ],
                    symbols: schematic.symbols,
                  )
                }
              }
            }
            _ -> {
              Schematic(
                parts: schematic.parts,
                symbols: [
                  Symbol(name: char, coordinate: Coordinate(x: x_idx, y: y_idx)),
                  ..schematic.symbols
                ],
              )
            }
          }
        },
      )
    },
  )
}

pub fn get_valid_parts(schematic: Schematic) {
  schematic.parts
  |> list.filter(fn(part) {
    let first_coordinate =
      part.coordinates
      |> list.first
    let last_coordinate =
      part.coordinates
      |> list.last

    case #(first_coordinate, last_coordinate) {
      #(Ok(first_coordinate), Ok(last_coordinate)) -> {
        let x_range = list.range(last_coordinate.x - 1, first_coordinate.x + 1)
        let y_range = list.range(last_coordinate.y - 1, first_coordinate.y + 1)

        schematic.symbols
        |> list.any(fn(symbol) {
          let is_in_x_range =
            x_range
            |> list.contains(symbol.coordinate.x)
          let is_in_y_range =
            y_range
            |> list.contains(symbol.coordinate.y)
          is_in_x_range && is_in_y_range
        })
      }
      _ -> False
    }
  })
}

pub fn get_valid_gears(schematic: Schematic) {
  schematic.symbols
  |> list.filter_map(fn(symbol) {
    case symbol.name {
      "*" -> {
        let parts =
          schematic.parts
          |> list.filter_map(fn(part) {
            let first_coordinate =
              part.coordinates
              |> list.first
            let last_coordinate =
              part.coordinates
              |> list.last

            case #(first_coordinate, last_coordinate) {
              #(Ok(first_coordinate), Ok(last_coordinate)) -> {
                let x_range =
                  list.range(last_coordinate.x - 1, first_coordinate.x + 1)
                let y_range =
                  list.range(last_coordinate.y - 1, first_coordinate.y + 1)
                let is_in_x_range =
                  x_range
                  |> list.contains(symbol.coordinate.x)
                let is_in_y_range =
                  y_range
                  |> list.contains(symbol.coordinate.y)

                case is_in_x_range && is_in_y_range {
                  True ->
                    Ok(
                      part.number
                      |> list.reverse
                      |> int.undigits(10)
                      |> result.unwrap(0),
                    )
                  False -> Error("Invalid coordinates")
                }
              }

              _ -> Error("Invalid coordinates")
            }
          })

        case parts {
          [_, _] -> Ok(#(symbol, parts))
          _ -> Error("Incorrect number of parts")
        }
      }
      _ -> Error("Not a gear")
    }
  })
}

pub fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  file
  |> string.split("\n")
}

pub fn solve_part1(input: List(String)) {
  input
  |> parse_schematic
  |> get_valid_parts
  |> list.map(fn(part) {
    part.number
    |> list.reverse
    |> int.undigits(10)
    |> result.unwrap(0)
  })
  |> int.sum
}

pub fn solve_part2(input: List(String)) {
  input
  |> parse_schematic
  |> get_valid_gears
  |> list.map(fn(gear) {
    gear.1
    |> int.product
  })
  |> int.sum
}

pub fn main() {
  io.println(
    "Part 1 answer: " <> {
      read_input("input.txt")
      |> solve_part1
      |> int.to_string
    },
  )
}
