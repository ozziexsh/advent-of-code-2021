defmodule AdventOfCode2021.Day06 do
  alias AdventOfCode2021.InputReader

  defmodule Part01 do
    def handle do
      InputReader.read("day06_input.txt")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> iterate(80)
      |> Enum.count()
    end

    def iterate(list, 0), do: list

    def iterate(list, days_remaining) do
      IO.puts("on day #{days_remaining}")
      iterate(age_fish(list), days_remaining - 1)
    end

    def age_fish(list), do: age_fish(list, [])

    def age_fish([fish | tail], carry) when fish == 0,
      do: age_fish(tail, [6, 8 | carry])

    def age_fish([fish | tail], carry), do: age_fish(tail, [fish - 1 | carry])
    def age_fish([], carry), do: carry
  end

  defmodule Part02 do
    @initial_list [0, 0, 0, 0, 0, 0, 0, 0, 0]

    def handle do
      InputReader.read("day06_input.txt")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(@initial_list, fn age, acc ->
        existing = Enum.at(acc, age)
        List.replace_at(acc, age, existing + 1)
      end)
      |> IO.inspect()
      |> iterate(256)
      |> Enum.sum()
    end

    def iterate(list, 0), do: list

    def iterate([day_0 | tail], days_remaining) do
      # create N new fish from fish on day 0
      new_list = tail ++ [day_0]

      # add day 0 fish to day 6
      day_6 = Enum.at(new_list, 6)
      new_list = List.replace_at(new_list, 6, day_6 + day_0)

      iterate(new_list, days_remaining - 1)
    end
  end
end
