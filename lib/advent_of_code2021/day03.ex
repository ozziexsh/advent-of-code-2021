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

  defmodule Part02 do
    def handle do
      input =
        InputReader.read("day03_input.txt")
        |> String.split("\n")

      oxygen_generator_rating = get_most_frequent(input, 0)
      co2_scrubber_rating = get_least_frequent(input, 0)

      oxygen_generator_rating * co2_scrubber_rating
    end

    def get_most_frequent([final], _index) do
      {num, _} = Integer.parse(final, 2)
      num
    end

    def get_most_frequent(list, index) do
      most_frequent = count_frequency(list, index, {0, 0})

      remaining = Enum.filter(list, fn str -> String.at(str, index) == most_frequent end)

      get_most_frequent(remaining, index + 1)
    end

    def get_least_frequent([final], _index) do
      {num, _} = Integer.parse(final, 2)
      num
    end

    def get_least_frequent(list, index) do
      most_frequent = count_frequency(list, index, {0, 0})

      remaining = Enum.filter(list, fn str -> String.at(str, index) != most_frequent end)

      get_least_frequent(remaining, index + 1)
    end

    def count_frequency([head | tail], index, {zeros, ones}) do
      char = String.at(head, index)
      count_frequency(tail, index, count_char(char, {zeros, ones}))
    end

    def count_frequency([], _index, {zeros, ones}) when zeros > ones, do: "0"
    def count_frequency([], _index, {zeros, ones}) when ones > zeros, do: "1"
    def count_frequency([], _index, {zeros, ones}) when zeros == ones, do: "1"

    def count_char("0", {zeros, ones}), do: {zeros + 1, ones}
    def count_char("1", {zeros, ones}), do: {zeros, ones + 1}
  end
end
