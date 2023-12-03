import gleeunit
import gleeunit/should
import day_03.{Coordinate, Part, Schematic, Symbol}

pub fn main() {
  gleeunit.main()
}

pub fn parse_schematic_line_1_test() {
  ["467..114.."]
  |> day_03.parse_schematic
  |> should.equal(day_03.Schematic(
    parts: [
      Part(
        number: [4, 1, 1],
        coordinates: [
          Coordinate(x: 7, y: 0),
          Coordinate(x: 6, y: 0),
          Coordinate(x: 5, y: 0),
        ],
      ),
      Part(
        number: [7, 6, 4],
        coordinates: [
          Coordinate(x: 2, y: 0),
          Coordinate(x: 1, y: 0),
          Coordinate(x: 0, y: 0),
        ],
      ),
    ],
    symbols: [],
  ))
}

pub fn parse_schematic_example_test() {
  [
    "467..114..", "...*......", "..35..633.", "......#...", "617*......",
    ".....+.58.", "..592.....", "......755.", "...$.*....", ".664.598..",
  ]
  |> day_03.parse_schematic
  |> should.equal(Schematic(
    parts: [
      Part(
        number: [8, 9, 5],
        coordinates: [
          Coordinate(x: 7, y: 9),
          Coordinate(x: 6, y: 9),
          Coordinate(x: 5, y: 9),
        ],
      ),
      Part(
        number: [4, 6, 6],
        coordinates: [
          Coordinate(x: 3, y: 9),
          Coordinate(x: 2, y: 9),
          Coordinate(x: 1, y: 9),
        ],
      ),
      Part(
        number: [5, 5, 7],
        coordinates: [
          Coordinate(x: 8, y: 7),
          Coordinate(x: 7, y: 7),
          Coordinate(x: 6, y: 7),
        ],
      ),
      Part(
        number: [2, 9, 5],
        coordinates: [
          Coordinate(x: 4, y: 6),
          Coordinate(x: 3, y: 6),
          Coordinate(x: 2, y: 6),
        ],
      ),
      Part(
        number: [8, 5],
        coordinates: [Coordinate(x: 8, y: 5), Coordinate(x: 7, y: 5)],
      ),
      Part(
        number: [7, 1, 6],
        coordinates: [
          Coordinate(x: 2, y: 4),
          Coordinate(x: 1, y: 4),
          Coordinate(x: 0, y: 4),
        ],
      ),
      Part(
        number: [3, 3, 6],
        coordinates: [
          Coordinate(x: 8, y: 2),
          Coordinate(x: 7, y: 2),
          Coordinate(x: 6, y: 2),
        ],
      ),
      Part(
        number: [5, 3],
        coordinates: [Coordinate(x: 3, y: 2), Coordinate(x: 2, y: 2)],
      ),
      Part(
        number: [4, 1, 1],
        coordinates: [
          Coordinate(x: 7, y: 0),
          Coordinate(x: 6, y: 0),
          Coordinate(x: 5, y: 0),
        ],
      ),
      Part(
        number: [7, 6, 4],
        coordinates: [
          Coordinate(x: 2, y: 0),
          Coordinate(x: 1, y: 0),
          Coordinate(x: 0, y: 0),
        ],
      ),
    ],
    symbols: [
      Symbol(name: "*", coordinate: Coordinate(x: 5, y: 8)),
      Symbol(name: "$", coordinate: Coordinate(x: 3, y: 8)),
      Symbol(name: "+", coordinate: Coordinate(x: 5, y: 5)),
      Symbol(name: "*", coordinate: Coordinate(x: 3, y: 4)),
      Symbol(name: "#", coordinate: Coordinate(x: 6, y: 3)),
      Symbol(name: "*", coordinate: Coordinate(x: 3, y: 1)),
    ],
  ))
}

pub fn get_valid_parts_example_test() {
  [
    "467..114..", "...*......", "..35..633.", "......#...", "617*......",
    ".....+.58.", "..592.....", "......755.", "...$.*....", ".664.598..",
  ]
  |> day_03.parse_schematic
  |> day_03.get_valid_parts
  |> should.equal([
    Part(
      number: [8, 9, 5],
      coordinates: [
        Coordinate(x: 7, y: 9),
        Coordinate(x: 6, y: 9),
        Coordinate(x: 5, y: 9),
      ],
    ),
    Part(
      number: [4, 6, 6],
      coordinates: [
        Coordinate(x: 3, y: 9),
        Coordinate(x: 2, y: 9),
        Coordinate(x: 1, y: 9),
      ],
    ),
    Part(
      number: [5, 5, 7],
      coordinates: [
        Coordinate(x: 8, y: 7),
        Coordinate(x: 7, y: 7),
        Coordinate(x: 6, y: 7),
      ],
    ),
    Part(
      number: [2, 9, 5],
      coordinates: [
        Coordinate(x: 4, y: 6),
        Coordinate(x: 3, y: 6),
        Coordinate(x: 2, y: 6),
      ],
    ),
    Part(
      number: [7, 1, 6],
      coordinates: [
        Coordinate(x: 2, y: 4),
        Coordinate(x: 1, y: 4),
        Coordinate(x: 0, y: 4),
      ],
    ),
    Part(
      number: [3, 3, 6],
      coordinates: [
        Coordinate(x: 8, y: 2),
        Coordinate(x: 7, y: 2),
        Coordinate(x: 6, y: 2),
      ],
    ),
    Part(
      number: [5, 3],
      coordinates: [Coordinate(x: 3, y: 2), Coordinate(x: 2, y: 2)],
    ),
    Part(
      number: [7, 6, 4],
      coordinates: [
        Coordinate(x: 2, y: 0),
        Coordinate(x: 1, y: 0),
        Coordinate(x: 0, y: 0),
      ],
    ),
  ])
}

pub fn get_valid_gears_example_test() {
  [
    "467..114..", "...*......", "..35..633.", "......#...", "617*......",
    ".....+.58.", "..592.....", "......755.", "...$.*....", ".664.598..",
  ]
  |> day_03.parse_schematic
  |> day_03.get_valid_gears
  |> should.equal([
    #(Symbol(name: "*", coordinate: Coordinate(x: 5, y: 8)), [598, 755]),
    #(Symbol(name: "*", coordinate: Coordinate(x: 3, y: 1)), [35, 467]),
  ])
}

pub fn solve_part_1_example_test() {
  [
    "467..114..", "...*......", "..35..633.", "......#...", "617*......",
    ".....+.58.", "..592.....", "......755.", "...$.*....", ".664.598..",
  ]
  |> day_03.solve_part1
  |> should.equal(4361)
}

pub fn solve_part_1_input_test() {
  day_03.read_input("input.txt")
  |> day_03.solve_part1
  |> should.equal(537_732)
}

pub fn solve_part_2_example_test() {
  [
    "467..114..", "...*......", "..35..633.", "......#...", "617*......",
    ".....+.58.", "..592.....", "......755.", "...$.*....", ".664.598..",
  ]
  |> day_03.solve_part2
  |> should.equal(467_835)
}

pub fn solve_part_2_input_test() {
  day_03.read_input("input.txt")
  |> day_03.solve_part2
  |> should.equal(84_883_664)
}
