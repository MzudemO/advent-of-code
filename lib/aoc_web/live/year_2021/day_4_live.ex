defmodule AocWeb.Year2021.Day4Live do
  use AocWeb, :live_view

  use Bitwise

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Four</h1>
    <h3>Part one:</h3>
    <p>Find the first winning bingo board (no diagonals) and calculate the sum of unmarked numbers times the last number.</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @answer_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>Find the last winning bingo board (no diagonals) and do the same.</p>
    <button phx-click="get_answer_2">Calculate</button>
    <p>Result: <%= @answer_2 %></p>
    """
  end

  def handle_event("get_answer_1", _, socket) do
    socket = assign(socket, answer_1: get_answer_1())
    {:noreply, socket}
  end

  def handle_event("get_answer_2", _, socket) do
    socket = assign(socket, answer_2: get_answer_2())
    {:noreply, socket}
  end

  defp get_answer_1() do
    [numbers | boards] = get_input()
    instructions = numbers |> String.split(",")

    boards =
      boards
      |> Enum.map(fn board -> board |> String.split("\n") |> Enum.map(&String.split/1) end)

    {board, last_num} = Enum.reduce_while(instructions, boards, &do_move/2)

    board_sum =
      List.flatten(board)
      |> Enum.filter(&(&1 != "X"))
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    board_sum * (last_num |> String.to_integer())
  end

  defp do_move(number, boards) do
    new_boards = Enum.map(boards, &mark_board(&1, number))

    case Enum.filter(new_boards, &has_bingo/1) do
      [] ->
        {:cont, new_boards}

      [board] ->
        {:halt, {board, number}}
    end
  end

  defp has_bingo(board) do
    row = Enum.any?(board, &is_full/1)

    col =
      board
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.any?(&is_full/1)

    row or col
  end

  defp is_full(row_or_col), do: Enum.all?(row_or_col, fn x -> x == "X" end)

  def mark_board(board, number) do
    board
    |> Enum.map(fn row -> Enum.map(row, &mark_space(&1, number)) end)
  end

  defp mark_space(number, number), do: "X"
  defp mark_space(space, _), do: space

  defp get_answer_2() do
    [numbers | boards] = get_input()
    instructions = numbers |> String.split(",")

    boards =
      boards
      |> Enum.map(fn board -> board |> String.split("\n") |> Enum.map(&String.split/1) end)

    {board, last_num} = Enum.reduce_while(instructions, boards, &do_move_2/2)

    board_sum =
      List.flatten(board)
      |> Enum.filter(&(&1 != "X"))
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    board_sum * (last_num |> String.to_integer())
  end

  defp do_move_2(number, boards) do
    new_boards = Enum.map(boards, &mark_board(&1, number))

    case Enum.reject(new_boards, &has_bingo/1) do
      [] ->
        {:halt, {new_boards, number}}

      boards ->
        {:cont, boards}
    end
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_4.txt")
    |> File.read!()
    |> String.split("\n\n")
  end
end
