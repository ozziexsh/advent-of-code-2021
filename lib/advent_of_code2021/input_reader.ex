defmodule AdventOfCode2021.InputReader do
  def read(filename) do
    File.read!(Path.join([File.cwd!(), "static", filename]))
    |> to_string()
  end
end
