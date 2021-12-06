defmodule AdventOfCode2021.Day05 do
  alias AdventOfCode2021.InputReader

  defmodule Common do
    def parse_input() do
      InputReader.read("day05_input.txt")
      |> String.split("\n")
      |> Enum.map(fn row ->
        row
        |> String.split(" -> ")
        |> Enum.map(fn coord ->
          [x, y] = String.split(coord, ",")
          {String.to_integer(x), String.to_integer(y)}
        end)
      end)
    end

    def iterate(list), do: iterate(list, %{})

    def iterate([head | tail], lookup), do: iterate(tail, draw(head, lookup))

    def iterate([], lookup), do: lookup

    def draw([{from_x, from_y}, {to_x, to_y}], lookup)
        when from_x == to_x and from_y == to_y,
        do: place_coord(lookup, from_x, from_y)

    def draw([{from_x, from_y}, {_to_x, _to_y}] = coords, lookup),
      do: draw(move_toward_point(coords), place_coord(lookup, from_x, from_y))

    def place_coord(map, x, y) do
      key = "#{x},#{y}"
      existing = Map.get(map, key, 0)
      Map.put(map, key, existing + 1)
    end

    def move_toward_point([{from_x, from_y}, {to_x, to_y}]) do
      [{move(from_x, to_x), move(from_y, to_y)}, {to_x, to_y}]
    end

    def move(from, to) when from < to, do: from + 1
    def move(from, to) when from > to, do: from - 1
    def move(from, to) when from == to, do: from
  end

  defmodule Part01 do
    import AdventOfCode2021.Day05.Common

    def handle do
      parse_input()
      |> Enum.filter(fn [{x1, y1}, {x2, y2}] -> x1 == x2 || y1 == y2 end)
      |> iterate()
      |> Enum.count(fn {_k, v} -> v >= 2 end)
    end
  end

  defmodule Part02 do
    import AdventOfCode2021.Day05.Common

    def handle do
      parse_input()
      |> iterate()
      |> Enum.count(fn {_k, v} -> v >= 2 end)
    end
  end
end
