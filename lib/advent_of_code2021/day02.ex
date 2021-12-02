defmodule AdventOfCode2021.Day02 do
  alias AdventOfCode2021.InputReader

  defmodule Part01 do
    def handle do
      coords =
        InputReader.read("day02_input.txt")
        |> String.split("\n")
        |> iterate(%{x: 0, z: 0})

      coords.x * coords.z
    end

    defp iterate([head | tail], coords) do
      iterate(tail, move(head, coords))
    end

    defp iterate([], coords), do: coords

    defp move("forward " <> num, %{x: x} = coords), do: %{coords | x: x + String.to_integer(num)}
    defp move("down " <> num, %{z: z} = coords), do: %{coords | z: z + String.to_integer(num)}
    defp move("up " <> num, %{z: z} = coords), do: %{coords | z: z - String.to_integer(num)}
  end

  defmodule Part02 do
    def handle do
      coords =
        InputReader.read("day02_input.txt")
        |> String.split("\n")
        |> iterate(%{x: 0, z: 0, aim: 0})

      coords.x * coords.z
    end

    defp iterate([head | tail], coords) do
      iterate(tail, move(head, coords))
    end

    defp iterate([], coords), do: coords

    defp move("forward " <> num, %{x: x, z: z, aim: aim} = coords) do
      value = String.to_integer(num)
      depth_mod = aim * value
      %{coords | x: x + value, z: z + depth_mod}
    end

    defp move("down " <> num, %{aim: aim} = coords),
      do: %{coords | aim: aim + String.to_integer(num)}

    defp move("up " <> num, %{aim: aim} = coords),
      do: %{coords | aim: aim - String.to_integer(num)}
  end
end
