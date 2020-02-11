defmodule NQueensSolver do

  @moduledoc"""
    Solves the general N-Queens problem to find a safe position hotzontally, vertically, and diagonally.
    Assume the board square is the same size as the number of queens. IE 6 queens will be positioned on
    a 6x6 board.
    Returns one valid solution.
  """
  def solve(1), do: [{0,0}] #[["Q"]]
  def solve(2), do: [] # No stable solutions []
  def solve(3), do: [] # No stable solutions []
  def solve(n) when n < 1, do: [] # No stable solutions []
  def solve(n) do
    proposed = Enum.shuffle(0..n - 1) |> Enum.with_index
    valid_solution?(proposed, n)
  end

  def visualize(n) do
    solution = solve(n)
    display(solution, n)
  end
  def visualize(solution, n) do
    display(solution, n)
  end

  defp display(solution, n) do
    empty_list = List.duplicate("", n)
    Enum.map(solution, fn {val, _idx} ->
      List.update_at(empty_list, val, fn(_) ->
        "Q"
      end)
    end)
  end

  defp display(true, prop, _n), do: prop
  defp display(_, _prop, n), do: solve(n)

  defp valid_solution?(prop, n) do
    eval(prop, n)
    |> display(prop, n)
  end

  defp eval(_list, _n, acc \\ [])
  defp eval([], _n, acc), do: eval_placements(acc)
  defp eval([_], _n, acc), do: eval_placements(acc)
  defp eval([current_queen_coords|remaining_queen_coords], n, acc) do
    valid_diagonal = valid_diagonals?(current_queen_coords, remaining_queen_coords, n)
    case valid_diagonal do
      false ->
        # skip further evaluation and fail fast(er).
        eval([], n, [false])
      true ->
        acc = [true | acc]
        eval(remaining_queen_coords, n, acc)
      end
  end

  # check that porposed solution contains only zero or one queen positioned on each board diagonal.
  defp valid_diagonals?({x, y} = _current_queen_coords, remaining_queen_coords, n) do
    left_diagonal = diagonal_left({ x - 1, y + 1 }, n, [])
    right_diagonal = diagonal_right({ x + 1, y + 1 }, n, [])
    remaining_queens_map_set = remaining_queen_coords
    |> MapSet.new()
    diagonals_map_set = left_diagonal ++ right_diagonal
    |> MapSet.new()

    intersection_size = MapSet.intersection(diagonals_map_set, remaining_queens_map_set)
    |> MapSet.size()

    intersection_size <= 0
  end

  defp diagonal_right({x,y}, n, acc) when x == n - 1 do
    acc ++ [{x, y}]
  end
  defp diagonal_right({x,y}, n, acc) when y == n - 1 do
    acc ++ [{x, y}]
  end
  defp diagonal_right({x,y}, n, acc) do
    diagonal_right({x+1,y+1}, n, acc ++ [{x, y}])
  end

  defp diagonal_left({x,y}, _n, acc) when x == 0 do
    acc ++ [{x, y}]
  end
  defp diagonal_left({x,y}, n, acc) when y == n - 1 do
    acc ++ [{x, y}]
  end
  defp diagonal_left({x,y}, n, acc) do
    diagonal_left({x-1,y+1}, n, acc ++ [{x, y}])
  end

  defp eval_placements(acc) do
    Enum.find(acc, true, fn(x) ->
      x == false
    end)
  end
end
