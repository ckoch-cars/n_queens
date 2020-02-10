defmodule Util do
  def transpose(matrix) do
    List.zip(matrix) |> Enum.map(&Tuple.to_list/1)
    # List.zip(matrix) |> IO.inspect |> Enum.map(&Tuple.to_list/1)
  end
end
