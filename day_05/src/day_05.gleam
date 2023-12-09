import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regex
import gleam/result
import gleam/string
import simplifile

pub fn parse_numbers(input: String) {
  input
  |> string.split(" ")
  |> list.filter_map(fn(x) {
    x
    |> string.trim
    |> int.parse
  })
}

pub fn parse_seed_numbers(input: String) {
  let assert Ok(re) = regex.from_string("seeds: (\\d+(?: +\\d+)*)")

  let matches = regex.scan(re, input)
  case matches {
    [match] -> {
      case match.submatches {
        [Some(seed_numbers)] ->
          Ok(
            seed_numbers
            |> parse_numbers,
          )
        _ -> Error("invalid seed number")
      }
    }

    _ -> Error("invalid input")
  }
}

pub fn parse_map(input: List(String), delimiter: String) {
  let [head, ..tail] = input
  use <- bool.guard(
    head != delimiter,
    Error("invalid delimiter, expected " <> delimiter <> " but got " <> head),
  )

  Ok(
    tail
    |> list.fold(
      [],
      fn(acc, map) {
        let parsed_map = parse_numbers(map)
        let [destination_range_start, source_range_start, range_length] =
          parsed_map

        [
          #(
            #(source_range_start, source_range_start + { range_length - 1 }),
            #(
              destination_range_start,
              destination_range_start + { range_length - 1 },
            ),
          ),
          ..acc
        ]
      },
    )
    |> list.reverse,
  )
}

pub fn read_input(filename: String) {
  let assert Ok(file) = simplifile.read(filename)
  let sections =
    file
    |> string.split("\n\n")

  let [
    seed_input,
    seed_soil_input,
    soil_fertilizer_input,
    fertilizer_water_input,
    water_light_input,
    light_temperature_input,
    temperature_humidity_input,
    humidity_location_input,
  ] = sections

  #(
    parse_seed_numbers(seed_input),
    parse_map(
      seed_soil_input
      |> string.split("\n"),
      "seed-to-soil map:",
    ),
    parse_map(
      soil_fertilizer_input
      |> string.split("\n"),
      "soil-to-fertilizer map:",
    ),
    parse_map(
      fertilizer_water_input
      |> string.split("\n"),
      "fertilizer-to-water map:",
    ),
    parse_map(
      water_light_input
      |> string.split("\n"),
      "water-to-light map:",
    ),
    parse_map(
      light_temperature_input
      |> string.split("\n"),
      "light-to-temperature map:",
    ),
    parse_map(
      temperature_humidity_input
      |> string.split("\n"),
      "temperature-to-humidity map:",
    ),
    parse_map(
      humidity_location_input
      |> string.trim
      |> string.split("\n"),
      "humidity-to-location map:",
    ),
  )
}

pub fn find_in_map(n: Int, map: List(#(#(Int, Int), #(Int, Int)))) {
  let range =
    map
    |> list.find(fn(map) {
      let #(source_range, _destination_range) = map
      let #(source_range_start, source_range_end) = source_range

      n >= source_range_start && n <= source_range_end
    })

  case range {
    Ok(#(source_range, destination_range)) -> {
      let #(destination_range_start, _destination_range_end) = destination_range
      let #(source_range_start, _source_range_end) = source_range
      let diff = n - source_range_start

      destination_range_start + diff
    }
    _ -> n
  }
}

pub fn solve_part1(filename: String) {
  let input = read_input(filename)
  let assert Ok(seeds) = input.0
  let assert Ok(seed_to_soil_map) = input.1
  let assert Ok(soil_to_fertilizer_map) = input.2
  let assert Ok(fertilizer_to_water_map) = input.3
  let assert Ok(water_to_light_map) = input.4
  let assert Ok(light_to_temperature_map) = input.5
  let assert Ok(temperature_to_humidity_map) = input.6
  let assert Ok(humidity_to_location_map) = input.7

  seeds
  |> list.map(fn(seed) {
    let soil = find_in_map(seed, seed_to_soil_map)
    let fertilizer = find_in_map(soil, soil_to_fertilizer_map)
    let water = find_in_map(fertilizer, fertilizer_to_water_map)
    let light = find_in_map(water, water_to_light_map)
    let temperature = find_in_map(light, light_to_temperature_map)
    let humidity = find_in_map(temperature, temperature_to_humidity_map)
    let location = find_in_map(humidity, humidity_to_location_map)

    location
  })
  |> list.sort(by: int.compare)
  |> list.first
  |> result.unwrap(-1)
}

pub fn main() {
  io.println(
    "Part 1 answer: " <> {
      solve_part1("input.txt")
      |> int.to_string
    },
  )
}
