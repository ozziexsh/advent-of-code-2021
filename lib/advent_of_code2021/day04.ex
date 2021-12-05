defmodule AdventOfCode2021.Day04 do
  alias AdventOfCode2021.InputReader

  defmodule Common do
    def parse_input() do
      input =
        InputReader.read("day04_input.txt")
        |> String.split("\n")

      [number_string | tail] = input

      boards =
        tail
        |> Enum.join("\n")
        |> String.trim()
        |> String.split("\n")
        |> Enum.reject(fn str -> str == "" end)
        |> Enum.chunk_every(5)
        |> Enum.map(fn board ->
          Enum.map(board, fn row ->
            String.split(row, " ")
            |> Enum.reject(fn str -> str == "" end)
            |> Enum.map(fn str -> %{value: elem(Integer.parse(str), 0), called?: false} end)
          end)
        end)

      called_numbers = number_string |> String.split(",") |> Enum.map(&String.to_integer/1)

      {called_numbers, boards}
    end

    def sum_unmarked_cells(list), do: sum_unmarked_cells(list, 0)

    def sum_unmarked_cells([row | tail], sum) do
      total =
        Enum.reject(row, fn cell -> cell.called? end)
        |> Enum.map(&Map.fetch!(&1, :value))
        |> Enum.sum()

      sum_unmarked_cells(tail, sum + total)
    end

    def sum_unmarked_cells([], sum), do: sum

    def mark_boards(boards, number), do: mark_boards(boards, number, [])
    def mark_boards([], _number, new_boards), do: new_boards

    def mark_boards([board | tail], number, new_boards),
      do: mark_boards(tail, number, new_boards ++ [mark_board(board, number)])

    def mark_board(board, number) do
      Enum.map(board, fn row ->
        Enum.map(row, fn cell ->
          if cell.value == number, do: %{cell | called?: true}, else: cell
        end)
      end)
    end

    def has_row?([row | tail]) do
      Enum.all?(row, fn item -> item.called? end) || has_row?(tail)
    end

    def has_row?([]), do: false

    def has_col?(board), do: has_col?(board, 0)
    def has_col?(_board, index) when index == 5, do: false

    def has_col?(board, index) do
      Enum.all?(board, fn row -> Enum.at(row, index).called? end) || has_col?(board, index + 1)
    end
  end

  defmodule Part01 do
    import AdventOfCode2021.Day04.Common

    def handle do
      {called_numbers, boards} = parse_input()

      iterate(called_numbers, boards)
    end

    # draw number
    # loop through boards
    #   mark board if has number
    #   check if board has vert / horiz line
    #     yes -> return board
    #     no -> next board
    def iterate([drawn_number | tail], boards) do
      updated_boards = mark_boards(boards, drawn_number)

      winner = Enum.find(updated_boards, fn board -> has_row?(board) || has_col?(board) end)

      if winner do
        sum_unmarked_cells(winner) * drawn_number
      else
        iterate(tail, updated_boards)
      end
    end

    def iterate([], _boards), do: nil
  end

  defmodule Part02 do
    import AdventOfCode2021.Day04.Common

    def handle do
      {called_numbers, boards} = parse_input()

      iterate(called_numbers, boards)
    end

    def iterate([drawn_number | tail], boards) do
      updated_boards = mark_boards(boards, drawn_number)

      open_boards =
        Enum.reject(updated_boards, fn board ->
          has_row?(board) || has_col?(board)
        end)

      if Enum.count(open_boards) == 0 do
        sum_unmarked_cells(List.last(updated_boards)) * drawn_number
      else
        iterate(tail, open_boards)
      end
    end

    def iterate([], _boards), do: nil
  end
end
