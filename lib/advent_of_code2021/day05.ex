defmodule AdventOfCode2021.Day05 do
  alias AdventOfCode2021.InputReader

  defmodule Part01 do
    def handle do
      input =
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
        |> Enum.filter(fn [{x1, y1}, {x2, y2}] -> x1 == x2 || y1 == y2 end)

      input
      |> iterate(%{})
      |> Enum.count(fn {_k, v} -> v >= 2 end)
    end

    def iterate([head | tail], lookup) do
      [{x1, y1}, {x2, y2}] = head

      updated_map = if x1 == x2, do: draw_vertical(x1, y1, y2, lookup), else: lookup
      updated_map = if y1 == y2, do: draw_horizontal(y1, x1, x2, updated_map), else: updated_map

      iterate(tail, updated_map)
    end

    def iterate([], lookup), do: lookup

    def draw_vertical(x, from_y, to_y, carry) when from_y > to_y,
      do: draw_vertical(x, to_y, from_y, carry)

    def draw_vertical(x, from_y, to_y, carry) when from_y == to_y,
      do: place_coord(carry, x, from_y)

    def draw_vertical(x, from_y, to_y, carry) do
      draw_vertical(x, from_y + 1, to_y, place_coord(carry, x, from_y))
    end

    def draw_horizontal(y, from_x, to_x, carry) when from_x > to_x,
      do: draw_horizontal(y, to_x, from_x, carry)

    def draw_horizontal(y, from_x, to_x, carry) when from_x == to_x,
      do: place_coord(carry, from_x, y)

    def draw_horizontal(y, from_x, to_x, carry) do
      draw_horizontal(y, from_x + 1, to_x, place_coord(carry, from_x, y))
    end

    def place_coord(map, x, y) do
      key = "#{x},#{y}"
      existing = Map.get(map, key, 0)
      Map.put(map, key, existing + 1)
    end
  end
end
