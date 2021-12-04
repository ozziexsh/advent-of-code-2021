defmodule AdventOfCode2021.Day03 do
  alias AdventOfCode2021.InputReader

  defmodule Part01 do
    def handle do
      input =
        InputReader.read("day03_input.txt")
        |> String.split("\n")

      most_frequent = count_frequency(input, 0, [])
      least_frequent = invert(most_frequent, [])

      {most_freq_int, _} = Integer.parse(Enum.join(most_frequent), 2)
      {least_freq_int, _} = Integer.parse(Enum.join(least_frequent), 2)

      most_freq_int * least_freq_int
    end

    # iterates horizontally
    def count_frequency(_list, 12, carry), do: carry

    def count_frequency(list, index, carry) do
      num = count_column(list, index, {0, 0})
      count_frequency(list, index + 1, carry ++ [num])
    end

    # iterates vertically
    def count_column([head | tail], index, {zeros, ones}) do
      char = String.at(head, index)
      count_column(tail, index, count_char(char, {zeros, ones}))
    end

    def count_column([], _index, {zeros, ones}) when zeros > ones, do: 0
    def count_column([], _index, {zeros, ones}) when ones > zeros, do: 1

    def count_char("0", {zeros, ones}), do: {zeros + 1, ones}
    def count_char("1", {zeros, ones}), do: {zeros, ones + 1}

    def invert([0 | tail], carry), do: invert(tail, carry ++ [1])
    def invert([1 | tail], carry), do: invert(tail, carry ++ [0])
    def invert([], carry), do: carry
  end
end
