defmodule NQueens do

  """
    moduledoc
    Solves the general N-Queens problem to find a safe position hotzontally, vertically, and diagonally.
    Assume the board square is the same size as the number of queens. IE 6 queens will be positioned on
    a 6x6 board.
  """
  def solve(1), do: [{0,0}] #{:ok, [["Q"]]}
  def solve(2), do: [] #{:invalid, []}
  def solve(3), do: [] #{:invalid, []}
  def solve(n) when n < 1, do: [] #{:invalid, []}
  # def solve(n) do
  #   proposed = Enum.shuffle(0..n - 1) |> Enum.with_index
  #   valid_solution?(proposed, n)
  # end
  def solve(n) do
    # list = Enum.to_list(0..n-1)
    # solutions = Permutations.perms(list)
    # solutions
    # |> Enum.count()
    # |> IO.inspect

    Enum.to_list(0..n-1)
    |> Permutations.perms()
    |> Enum.reduce([], fn(x, acc) ->
      x_indexed = x |> Enum.with_index
      if trivally_valid?(x_indexed) do
        if eval(x_indexed, n) do
          acc ++ [x_indexed]
        else
          acc
        end
      else
        acc
      end
    end)
  end

  def visualize(1), do: [["Q"]]
  def visualize(n) do
    solution = solve(n)
    |> List.first
    |> visualize(n)
  end
  def visualize(nil, _n), do: []
  def visualize([], _n), do: []
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

  # defp display(true, prop, _n), do: prop
  # defp display(_, _prop, n), do: solve(n)

  # defp valid_solution?(prop, n) do
  #   eval(prop, n)
  #   |> display(prop, n)
  # end

  defp trivally_valid?([{h_x, h_y}|tail]) do
    trivally_valid?({h_x, h_y}, tail, false)
  end
  defp trivally_valid?({_, _}, [], _), do: true
  defp trivally_valid?(_, _, true), do: false
  defp trivally_valid?({h_x, h_y}, [{t_x, t_y}|tail], false) do
    trivally_valid?({t_x, t_y}, tail, h_x + 1 == t_x || h_x - 1 == t_x)
  end

  defp eval(_list, _n, acc \\ [])
  defp eval([], n, acc), do: eval_placements(acc)
  defp eval([el], n, acc), do: eval_placements(acc)
  defp eval([current_queen_coords|remaining_queen_coords], n, acc) do
    acc = acc ++ [valid_diagonals?(current_queen_coords, remaining_queen_coords, n)]
    eval(remaining_queen_coords, n, acc)
  end

  # [{2, 0}, {4, 1}, {0, 2}, {3, 3}, {1, 4}]
  # defp valid_placement?({a_val, b_idx} = h, {_c_val, _d_idx} = tv) do
  #   if tv == {a_val + 1, b_idx + 1} || tv == {a_val - 1, b_idx + 1} do
  #     false
  #   else
  #     true
  #   end
  # end

  defp valid_diagonals?({x, y} = current_queen_coords, remaining_queen_coords, n) do
    # current_queen_coords
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

  defp diagonal_left({x,y}, n, acc) when x == 0 do
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

defmodule Permutations do
  def perms(%MapSet{} = set), do: MapSet.to_list(set) |> perms
  def perms([]), do: [[]]
  def perms(l) do
    for h <- l, t <- perms(l -- [h]) do
      [h|t]
    end
  end

  # def non_adjacent_perms([]), do: [[]]
  # def non_adjacent_perms(l) do
  #   for h <- l, t <- non_adjacent_perms(l -- [h]) do
  #     append_conditional(h, t)
  #   end
  # end

  # defp append_conditional(h, []), do: [h]
  # defp append_conditional(h, t) do
  #   IO.inspect h

  #   [t_0|t_t] = t
  #   IO.inspect t_0
  #   if h + 1 == t_0 || h - 1 == t_0 do
  #     []
  #   else
  #     [h|t]
  #   end

  # end
end
