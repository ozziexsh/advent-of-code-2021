defmodule AdventOfCode2021.Day07 do
  alias AdventOfCode2021.InputReader

  defmodule Part01 do
    def handle do
      input =
        InputReader.read("day07_input.txt")
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      min = Enum.min(input)
      max = Enum.max(input)

      iterate(input, {min, max}, 999_999_999_999)
    end

    def iterate(_list, {from, to}, smallest_distance) when from > to, do: smallest_distance

    def iterate(list, {from, to}, smallest_distance) do
      distance = gather_distance(list, from, 0)

      iterate(list, {from + 1, to}, min(smallest_distance, distance))
    end

    def gather_distance([head | tail], anchor, sum),
      do: gather_distance(tail, anchor, sum + distance(anchor, head))

    def gather_distance([], _anchor, sum), do: sum

    def distance(a, b), do: abs(a - b)
  end

  defmodule Part02 do
    def handle do
      input =
        InputReader.read("day07_input.txt")
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      min = Enum.min(input)
      max = Enum.max(input)

      iterate(input, {min, max}, 999_999_999_999)
    end

    def iterate(_list, {from, to}, smallest_distance) when from > to, do: smallest_distance

    def iterate(list, {from, to}, smallest_distance) do
      distance = gather_distance(list, from, 0)

      iterate(list, {from + 1, to}, min(smallest_distance, distance))
    end

    def gather_distance([head | tail], anchor, sum),
      do: gather_distance(tail, anchor, sum + triangular_distance(anchor, head))

    def gather_distance([], _anchor, sum), do: sum

    def distance(a, b), do: abs(a - b)

    def triangular_distance(a, b) do
      n = distance(a, b)
      n * (n + 1) / 2
    end
  end
end
