defmodule AdventOfCode2021.Day08 do
  alias AdventOfCode2021.InputReader

  defmodule Part01 do
    def handle do
      InputReader.read("day08_input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, " | ")
        |> Enum.map(&String.split(&1, " ", trim: true))
      end)
      |> iterate()
    end

    def iterate(list), do: iterate(list, 0)
    def iterate([], total), do: total
    def iterate([[_input, output] | tail], total), do: iterate(tail, count_output(output) + total)

    def count_output(list), do: count_output(list, 0)

    def count_output([head | tail], total) do
      case String.length(head) do
        n when n in [2, 4, 3, 7] -> count_output(tail, total + 1)
        _ -> count_output(tail, total)
      end
    end

    def count_output([], total), do: total
  end

  defmodule Part02 do
    def handle do
      InputReader.read("day08_input.txt")
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, " | ")
        |> Enum.map(&String.split(&1, " "))
      end)
      |> iterate()
    end

    @doc """
        t1t1t1t1
      l1        r1
      l1        r1
        t2t2t2t2
      l2        r2
      l2        r2
        t3t3t3t3
    """
    def iterate(list), do: iterate(list, 0)
    def iterate([], total), do: total

    def iterate([[input, output] | tail], total) do
      # find right signals
      [maybe_r1, maybe_r2] = signal_by_size(input, 2) |> String.split("", trim: true)

      # deduce top signal
      num_7 = signal_by_size(input, 3)

      [t1] =
        num_7
        |> String.split("", trim: true)
        |> Enum.reject(fn char -> char in [maybe_r1, maybe_r2] end)

      # 6 (r1)
      [num_6] =
        signals_by_size(input, 6)
        |> Enum.reject(fn str ->
          String.contains?(str, maybe_r1) && String.contains?(str, maybe_r2)
        end)

      [r1, r2] =
        if String.contains?(num_6, maybe_r1), do: [maybe_r2, maybe_r1], else: [maybe_r1, maybe_r2]

      # 3 (t2,t3)
      num_3 =
        signals_by_size(input, 5)
        |> Enum.find(fn str -> String.contains?(str, r1) && String.contains?(str, r2) end)

      [maybe_t2, maybe_t3] =
        String.split(num_3, "", trim: true) |> Enum.reject(fn char -> char in [r1, r2, t1] end)

      # 5 (l1)
      num_5 = signals_by_size(input, 5) |> Enum.find(fn str -> !String.contains?(str, r1) end)

      [l1] =
        num_5
        |> String.split("", trim: true)
        |> Enum.reject(fn char -> char in [t1, maybe_t2, maybe_t3, r2] end)

      num_8 = signal_by_size(input, 7)

      # 9 (l2) -> take 8 and find missing
      num_9_chars =
        input
        |> Enum.filter(fn str -> String.length(str) == 6 end)
        |> Enum.filter(fn str ->
          String.split(str, "", trim: true)
          |> Enum.all?(fn char -> char in [t1, maybe_t2, maybe_t3, r1, r2, l1] end)
        end)
        |> List.first()
        |> String.split("", trim: true)

      [l2] =
        num_8 |> String.split("", trim: true) |> Enum.reject(fn char -> char in num_9_chars end)

      num_0 =
        signals_by_size(input, 6)
        |> Enum.reject(fn str ->
          String.contains?(str, t1) && String.contains?(str, maybe_t2) &&
            String.contains?(str, maybe_t3)
        end)
        |> List.first()

      [t2, t3] =
        if String.contains?(num_0, maybe_t2), do: [maybe_t3, maybe_t2], else: [maybe_t2, maybe_t3]

      num_0 = [t1, l1, r1, l2, r2, t3]
      num_1 = [r1, r2]
      num_2 = [t1, r1, t2, l1, t3]
      num_3 = [t1, r1, t2, r2, t3]
      num_4 = [l1, r1, t2, r2]
      num_5 = [t1, l1, t2, r2, t3]
      num_6 = [t1, l1, t2, l2, r2, t3]
      num_7 = [t1, r1, r2]
      num_8 = [t1, l1, r1, t2, l2, r2, t3]
      num_9 = [t1, l1, r1, t2, r2, t3]

      numbers = [num_0, num_1, num_2, num_3, num_4, num_5, num_6, num_7, num_8, num_9]

      output_decoded =
        Enum.map(output, fn signal ->
          signal_normalized =
            signal
            |> String.split("", trim: true)
            |> Enum.sort()

          Enum.find_index(numbers, fn num -> signal_normalized == Enum.sort(num) end) || 2
        end)

      # %{
      #   t1: t1,
      #   t2: t2,
      #   t3: t3,
      #   r1: r1,
      #   r2: r2,
      #   l1: l1,
      #   l2: l2
      # }

      output_total = output_decoded |> Enum.join("") |> String.to_integer()

      iterate(tail, total + output_total)
    end

    def signal_by_size(inputs, length) do
      inputs
      |> Enum.find(fn signal -> String.length(signal) == length end)
    end

    def signals_by_size(inputs, length) do
      inputs
      |> Enum.filter(fn signal -> String.length(signal) == length end)
    end
  end
end
