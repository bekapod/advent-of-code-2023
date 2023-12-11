import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Position {
  Position(x: Int, y: Int)
}

pub type Map =
  Dict(Position, String)

pub fn get_start_type(map: Map, start: Position) {
  let north = dict.get(map, Position(start.x, start.y - 1))
  let south = dict.get(map, Position(start.x, start.y + 1))
  let east = dict.get(map, Position(start.x + 1, start.y))
  let west = dict.get(map, Position(start.x - 1, start.y))

  let has_north_connector = case north {
    Ok(pipe) if pipe == "|" || pipe == "7" || pipe == "F" -> True
    _ -> False
  }

  let has_south_connector = case south {
    Ok(pipe) if pipe == "|" || pipe == "J" || pipe == "L" -> True
    _ -> False
  }

  let has_east_connector = case east {
    Ok(pipe) if pipe == "-" || pipe == "J" || pipe == "7" -> True
    _ -> False
  }

  let has_west_connector = case west {
    Ok(pipe) if pipe == "-" || pipe == "F" || pipe == "L" -> True
    _ -> False
  }

  case
    has_north_connector,
    has_south_connector,
    has_east_connector,
    has_west_connector
  {
    True, True, False, False -> "|"
    False, False, True, True -> "-"
    True, False, True, False -> "L"
    True, False, False, True -> "J"
    False, True, False, True -> "7"
    False, True, True, False -> "F"
  }
}

pub fn get_start_position(map: Map) -> Position {
  let result =
    map
    |> dict.to_list
    |> list.find_map(fn(cell) {
      let #(position, pipe) = cell
      case pipe {
        "S" -> Ok(position)
        _ -> Error("Not the start")
      }
    })

  case result {
    Ok(position) -> position
    Error(_) -> panic("No start found")
  }
}

pub fn walk(map: Map, start_position: Position, visited: List(Position)) {
  let assert Ok(current_position) =
    visited
    |> list.first
  let last_position =
    visited
    |> list.at(1)
    |> result.unwrap(start_position)
  let visited_count =
    visited
    |> list.length
  let current_pipe = case dict.get(map, current_position) {
    Ok("S") -> get_start_type(map, current_position)
    Ok(pipe) -> pipe
    Error(_) -> panic("Invalid position")
  }

  case current_position {
    _ if current_position == start_position && visited_count > 1 -> visited
    _ -> {
      let can_go_north =
        current_pipe == "|" || current_pipe == "L" || current_pipe == "J"
      let north_position = Position(current_position.x, current_position.y - 1)
      let north = dict.get(map, north_position)
      let has_north_connector = case north {
        Ok(pipe) if pipe == "|" || pipe == "7" || pipe == "F" -> True
        _ -> False
      }

      let can_go_south =
        current_pipe == "|" || current_pipe == "F" || current_pipe == "7"
      let south_position = Position(current_position.x, current_position.y + 1)
      let south = dict.get(map, south_position)
      let has_south_connector = case south {
        Ok(pipe) if pipe == "|" || pipe == "J" || pipe == "L" -> True
        _ -> False
      }

      let can_go_east =
        current_pipe == "-" || current_pipe == "L" || current_pipe == "F"
      let east_position = Position(current_position.x + 1, current_position.y)
      let east = dict.get(map, east_position)
      let has_east_connector = case east {
        Ok(pipe) if pipe == "-" || pipe == "J" || pipe == "7" -> True
        _ -> False
      }

      let can_go_west =
        current_pipe == "-" || current_pipe == "J" || current_pipe == "7"
      let west_position = Position(current_position.x - 1, current_position.y)
      let west = dict.get(map, west_position)
      let has_west_connector = case west {
        Ok(pipe) if pipe == "-" || pipe == "F" || pipe == "L" -> True
        _ -> False
      }

      case can_go_north, can_go_south, can_go_east, can_go_west {
        True, _, _, _ if has_north_connector && north_position != last_position ->
          walk(map, start_position, [north_position, ..visited])
        _, True, _, _ if has_south_connector && south_position != last_position ->
          walk(map, start_position, [south_position, ..visited])
        _, _, True, _ if has_east_connector && east_position != last_position ->
          walk(map, start_position, [east_position, ..visited])
        _, _, _, True if has_west_connector && west_position != last_position ->
          walk(map, start_position, [west_position, ..visited])
        _, _, _, _ -> visited
      }
    }
  }
}

pub fn parse_input(input: List(String)) -> Map {
  input
  |> list.index_fold(
    dict.new(),
    fn(acc, line, y_idx) {
      line
      |> string.split("")
      |> list.index_fold(
        acc,
        fn(acc, char, x_idx) {
          case char {
            "." -> acc
            _ -> dict.insert(acc, Position(x_idx, y_idx), char)
          }
        },
      )
    },
  )
}

pub fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  file
  |> string.trim
  |> string.split("\n")
}

pub fn solve_part1(filename: String) {
  let map =
    read_input(filename)
    |> parse_input

  let start_position = get_start_position(map)

  walk(map, start_position, [start_position])
  |> list.length
  |> int.divide(2)
  |> result.unwrap(-1)
}

pub fn main() {
  let #(runtime, part1) = time(fn() { solve_part1("input.txt") }, Millisecond)
  io.println(
    "Part 1 answer: " <> {
      part1
      |> int.to_string
    } <> " (" <> {
      runtime
      |> int.to_string
    } <> "ms)",
  )
}

pub type TimeUnit {
  Millisecond
}

@external(erlang, "timer", "tc")
fn time(func: fn() -> anything, unit: TimeUnit) -> #(Int, anything)
