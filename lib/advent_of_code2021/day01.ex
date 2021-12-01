defmodule AdventOfCode2021.Day01 do
  @type input :: [integer]
  @type three_measurement_window :: [integer]
  @type offset :: integer
  @type total :: integer
  @type index :: integer

  def handle_pt1 do
    read_input()
    |> parse_pt1()
  end

  # Recursively loops through a list, returning how many
  # elements are greater than the one previous to it

  @spec parse_pt1(input) :: total
  defp parse_pt1(list), do: parse_pt1(list, 0, 0)

  @spec parse_pt1(input, total, index) :: total
  defp parse_pt1(list, total, 0), do: parse_pt1(list, total, 1)

  defp parse_pt1(list, total, index) when length(list) == index do
    total
  end

  defp parse_pt1(list, total, index) do
    prev = Enum.at(list, index - 1)
    current = Enum.at(list, index)

    new_total = if current > prev, do: total + 1, else: total

    parse_pt1(list, new_total, index + 1)
  end

  ### PT 2

  def handle_pt2 do
    read_input()
    |> parse_pt2()
    |> parse_pt1()
  end

  # Recursively loops through a list, returning a new list where
  # each item is the sum of the current offset + the next two items
  # in the original list, stopping when their are no longer 3 items ahead
  # of the offset

  @spec parse_pt2(input) :: three_measurement_window
  defp parse_pt2(list), do: parse_pt2(list, [], 0)

  @spec parse_pt2(input, three_measurement_window, offset) :: three_measurement_window
  defp parse_pt2(list, carry, offset) when length(list) - offset < 3, do: carry

  defp parse_pt2(list, carry, offset) do
    one = Enum.at(list, offset)
    two = Enum.at(list, offset + 1)
    three = Enum.at(list, offset + 2)

    parse_pt2(list, carry ++ [one + two + three], offset + 1)
  end

  defp read_input do
    input = File.read!(Path.join([File.cwd!(), "static", "day01_input.txt"]))

    input
    |> to_string()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end
