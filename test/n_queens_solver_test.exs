defmodule NQueensSolverTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest NQueens

  test "n = 1" do
    assert NQueensSolver.solve(1) == [{0,0}]
    assert NQueensSolver.visualize(1) == [["Q"]]
  end

  test "n = 2" do
    assert NQueensSolver.solve(2) == []
    assert NQueensSolver.visualize(2) == []
  end

  test "n = 3" do
    assert NQueensSolver.solve(3) == []
    assert NQueensSolver.visualize(3) == []
  end

  # test "n = 4" do
  #   solutions = NQueensSolver.solve(4)
  #   assert Enum.count(solutions) == 2
  #   assert solutions |> Enum.at(0) == [{1, 0}, {3, 1}, {0, 2}, {2, 3}]
  #   assert solutions |> Enum.at(-1) == [{2, 0}, {0, 1}, {3, 2}, {1, 3}]
  # end

  # test "visualize/2 n = 4" do
  #   NQueensSolver.solve(4)
  #   |> NQueensSolver.visualize(4)
  #   |> IO.inspect
  #   # assert solutions |> Enum.at(0) |> NQueensSolver.visualize(4) == [["", "Q", "", ""], ["", "", "", "Q"], ["Q", "", "", ""], ["", "", "Q", ""]]
  #   # assert solutions |> Enum.at(-1) |> NQueensSolver.visualize(4) == [["", "", "Q", ""], ["Q", "", "", ""], ["", "", "", "Q"], ["", "Q", "", ""]]
  # end

  # test "visualize/2 n = 5" do
  #   solutions = NQueensSolver.solve(5)
  #   assert solutions |> Enum.at(0)
  #   |> NQueensSolver.visualize(5) == [["Q", "", "", "", ""], ["", "", "Q", "", ""], ["", "", "", "", "Q"], ["", "Q", "", "", ""], ["", "", "", "Q", ""]]
  #   assert solutions |> Enum.at(-1)
  #   |> NQueensSolver.visualize(5) == [["", "", "", "", "Q"], ["", "", "Q", "", ""], ["Q", "", "", "", ""], ["", "", "", "Q", ""], ["", "Q", "", "", ""]]
  # end

  # test "n = 5" do
  #   solutions = NQueensSolver.solve(5)
  #   assert Enum.count(solutions) == 10
  #   assert solutions |> Enum.at(0) == [{0, 0}, {2, 1}, {4, 2}, {1, 3}, {3, 4}]
  #   assert solutions |> Enum.at(1) == [{0, 0}, {3, 1}, {1, 2}, {4, 3}, {2, 4}]
  #   assert solutions |> Enum.at(-1) == [{4, 0}, {2, 1}, {0, 2}, {3, 3}, {1, 4}]
  # end

  # test "visualize/2 n = 6" do
  #   n = 6
  #   assert NQueensSolver.solve(n) |> Enum.at(0)
  #   |> NQueensSolver.visualize(n) == [["", "Q", "", "", "", ""], ["", "", "", "Q", "", ""], ["", "", "", "", "", "Q"], ["Q", "", "", "", "", ""], ["", "", "Q", "", "", ""], ["", "", "", "", "Q", ""]]
  #   assert NQueensSolver.solve(n) |> Enum.at(1)
  #   |> NQueensSolver.visualize(n) == [["", "", "Q", "", "", ""], ["", "", "", "", "", "Q"], ["", "Q", "", "", "", ""], ["", "", "", "", "Q", ""], ["Q", "", "", "", "", ""], ["", "", "", "Q", "", ""]]
  # end

  # test "n = 6" do
  #   solutions = NQueensSolver.solve(6)
  #   assert Enum.count(solutions) == 4
  #   assert solutions |> Enum.at(0) == [{1, 0}, {3, 1}, {5, 2}, {0, 3}, {2, 4}, {4, 5}]
  #   assert solutions |> Enum.at(1) == [{2, 0}, {5, 1}, {1, 2}, {4, 3}, {0, 4}, {3, 5}]
  #   assert solutions |> Enum.at(2) == [{3, 0}, {0, 1}, {4, 2}, {1, 3}, {5, 4}, {2, 5}]
  #   assert solutions |> Enum.at(3) == [{4, 0}, {2, 1}, {0, 2}, {5, 3}, {3, 4}, {1, 5}]
  # end

  describe "visualize/1 properties" do
    property "solution length == n, and each el length == n" do
      check all int <- integer(4..9) do
        case int do
          1 ->
            solution = NQueensSolver.visualize(int)
            assert length(solution) == 1
            row = List.first(solution)
            assert length(row) == 1
          2 ->
            solution = NQueensSolver.visualize(int)
            assert length(solution) == 0
          3 ->
            solution = NQueensSolver.visualize(int)
            assert length(solution) == 0
          _ ->
            solution = NQueensSolver.visualize(int)
            assert length(solution) == int
            Enum.map(solution, &(assert length(&1) == int))
        end
      end
    end

    property "each row has n elements, one 'Q', and n-1 ''" do
      check all int <- integer(4..9) do
        solution = NQueensSolver.visualize(int)
        assert length(solution) == int
        Enum.map(solution, fn(row) ->
          assert length(row) == int;
          assert Enum.count(row, &(&1 == "Q")) == 1;
          assert Enum.count(row, &(&1 == "")) == int - 1;
        end)
      end
    end

    property "each column has one 'Q' and n-1 ''" do
      check all int <- integer(4..9) do
        solution = NQueensSolver.visualize(int)
        |> Util.transpose()
        assert length(solution) == int
        Enum.map(solution, fn(row) ->
          assert length(row) == int;
          assert Enum.count(row, &(&1 == "Q")) == 1;
          assert Enum.count(row, &(&1 == "")) == int - 1;
        end)
      end
    end
  end

  describe "solve/1 validate diagonal property" do
    # @tag timeout: 300_000
    property "each diagonal contains zero or one 'Q'" do
      check all int <- integer(4..10) do
        # IO.inspect("N: #{int}")
        solution = NQueensSolver.solve(int)
        |> MapSet.new()
        # IO.inspect("Solutions size: #{MapSet.size(solution)}")

        diagonal_coords = diagonals(int)
        Enum.each(diagonal_coords, fn(diag) ->
          dms = MapSet.new(diag)
          intersection_size = MapSet.intersection(dms, solution)
          |> MapSet.size()
          assert intersection_size <= 1
        end)
      end
    end
  end

  describe "solve/1 larger values of N" do
    test "N=4" do
      int = 4
      IO.inspect("N: #{int}")
      solution = NQueensSolver.solve(int)
      |> MapSet.new()
      IO.inspect("Solutions size: #{MapSet.size(solution)}")
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    test "N=6" do
      int = 6
      IO.inspect("N: #{int}")
      solution = NQueensSolver.solve(int)
      |> MapSet.new()
      IO.inspect("Solutions size: #{MapSet.size(solution)}")
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    test "N=7" do
      int = 7
      IO.inspect("N: #{int}")
      solution = NQueensSolver.solve(int)
      |> MapSet.new()
      IO.inspect("Solutions size: #{MapSet.size(solution)}")
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    test "N=8" do
      int = 8
      # IO.inspect("N: #{int}")
      solution = NQueensSolver.solve(int)
      |> MapSet.new()
      |> IO.inspect(label: "size 8")
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    test "N=9" do
      int = 9
      IO.inspect("N: #{int}")
      solution = NQueensSolver.solve(int)
      |> MapSet.new()
      IO.inspect("Solutions size: #{MapSet.size(solution)}")
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    @tag timeout: 120_000
    test "N=10" do
      int = 10
      IO.inspect("N: #{int}")
      solution = NQueensSolver.solve(int)
      |> MapSet.new()
      IO.inspect("Solutions size: #{MapSet.size(solution)}")
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    @tag timeout: 300_000
    test "N=11" do
      int = 11
      IO.inspect("N: #{int}")
      solution = NQueensSolver.solve(int)
      |> MapSet.new()
      IO.inspect("Solutions size: #{MapSet.size(solution)}")
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    @tag timeout: 300_000
    test "N=12" do
      int = 12
      solution = NQueensSolver.solve(int)
      |> NQueensSolver.visualize(int)
      |> IO.inspect(label: "Visualized N Queens Solutions for board of size: #{int}")
      |> MapSet.new()
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    # @tag :skip
    @tag timeout: 300_000
    test "N=13" do
      int = 13
      solution = NQueensSolver.solve(int)
      |> NQueensSolver.visualize(int)
      |> IO.inspect
      |> MapSet.new()
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    # @tag :skip
    @tag timeout: 300_000
    test "N=14" do
      int = 14
      solution = NQueensSolver.solve(int)
      |> NQueensSolver.visualize(int)
      |> IO.inspect(label: "Visualized N Queens Solutions for board of size: #{int}")
      |> MapSet.new()
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end

    @tag :skip
    @tag timeout: 300_000
    test "N=15" do
      int = 15
      solution = NQueensSolver.solve(int)
      |> NQueensSolver.visualize(int)
      |> IO.inspect(label: "Visualized N Queens Solutions for board of size: #{int}")
      |> MapSet.new()
      diagonal_coords = diagonals(int)
      Enum.each(diagonal_coords, fn(diag) ->
        dms = MapSet.new(diag)
        intersection_size = MapSet.intersection(dms, solution)
        |> MapSet.size()
        assert intersection_size <= 1
      end)
    end
  end

  test "diagonal_right" do
    all_diagonals = [
      [{0, 0}, {1, 1}, {2, 2}, {3, 3}],
      [{3, 0}, {2, 1}, {1, 2}, {0, 3}],
      [{1, 0}, {2, 1}, {3, 2}],
      [{0, 1}, {1, 2}, {2, 3}],
      [{2, 0}, {1, 1}, {0, 2}],
      [{3, 1}, {2, 2}, {1, 3}],
      [{2, 0}, {3, 1}],
      [{0, 2}, {1, 3}],
      [{1, 0}, {0, 1}],
      [{3, 2}, {2, 3}],
      [{3, 0}],
      [{0, 3}],
      [{0, 0}],
      [{3, 3}]
    ]
    assert diagonals(4) == all_diagonals
  end

  # given square matrix of size n
  # output == [[{1,1},..{n,n}],[{2,1}..{n,n-1}]..[{n,n}]]
  def diagonals(n) do
    Enum.flat_map(0..n-1, fn(i) ->
      acc0 = diagonal_right({i,0}, n, [])
      acc1 = diagonal_right({0,i}, n, [])
      acc2 = diagonal_left({n-1-i,0}, n, [])
      acc3 = diagonal_left({n-1,i}, n, [])
      [acc0, acc1, acc2, acc3]
    end)
    |> Enum.uniq()
  end

  def diagonal_right({x,y}, n, acc) when x == n - 1 do
    acc ++ [{x, y}]
  end
  def diagonal_right({x,y}, n, acc) when y == n - 1 do
    acc ++ [{x, y}]
  end
  def diagonal_right({x,y}, n, acc) do
    diagonal_right({x+1,y+1}, n, acc ++ [{x, y}])
  end

  def diagonal_left({x,y}, _n, acc) when x == 0 do
    acc ++ [{x, y}]
  end
  def diagonal_left({x,y}, n, acc) when y == n - 1 do
    acc ++ [{x, y}]
  end
  def diagonal_left({x,y}, n, acc) do
    diagonal_left({x-1,y+1}, n, acc ++ [{x, y}])
  end
end