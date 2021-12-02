defmodule AdventOfCode2021.Day01 do
  alias AdventOfCode2021.InputReader

  defmodule Part01 do
    def handle do
      InputReader.read("day01_input.txt")
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> parse()
    end

    def parse([head | tail]), do: parse(tail, head, 0)

    def parse([head | tail], prev, total) when head > prev,
      do: parse(tail, head, total + 1)

    def parse([head | tail], _prev, total), do: parse(tail, head, total)
    def parse([], _prev, total), do: total
  end

  defmodule Part02 do
    def handle do
      InputReader.read("day01_input.txt")
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> parse([])
      |> Part01.parse()
    end

    defp parse([one, two, three | tail], carry),
      do: parse([two, three | tail], carry ++ [one + two + three])

    defp parse([_, _], carry), do: carry
  end
end
