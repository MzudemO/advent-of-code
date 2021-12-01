defmodule AocWeb.Year2020.Day5Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, result_1: "", result_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Five</h1>
    <h3>Part one:</h3>
    <p>Find row and column number with binary partitioning, calculate the highest seat ID with <code>row * 8 + column</code></p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @result_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>Find row and column number with binary partitioning, find the missing seat with IDs +1 and -1 present</p>
    <button phx-click="get_answer_2">Calculate</button>
    <p>Result: <%= @result_2 %></p>
    """
  end

  def handle_event("get_answer_1", _, socket) do
    socket = assign(socket, result_1: calc_result_1())
    {:noreply, socket}
  end

  def handle_event("get_answer_2", _, socket) do
    socket = assign(socket, result_2: calc_result_2())
    {:noreply, socket}
  end

  defp calc_result_1() do
    get_input()
    |> Enum.map(&get_seat_id/1)
    |> Enum.max()
  end

  defp calc_result_2() do
    ids =
      get_input()
      |> Enum.map(&get_seat_id/1)

    lower_id =
      ids
      |> Enum.find(fn nr ->
        Enum.member?(ids, nr + 2) and not Enum.member?(ids, nr + 1)
      end)

    lower_id + 1
  end

  defp get_seat_id(instructions) do
    col_range = 0..127//1 |> Enum.to_list()
    row_range = 0..7//1 |> Enum.to_list()

    {[row], [col]} = Enum.reduce(instructions, {col_range, row_range}, &partition/2)

    row * 8 + col
  end

  defp partition("F", {col_range, row_range}),
    do: {Enum.take(col_range, div(length(col_range), 2)), row_range}

  defp partition("B", {col_range, row_range}),
    do: {Enum.take(col_range, div(length(col_range), -2)), row_range}

  defp partition("L", {col_range, row_range}),
    do: {col_range, Enum.take(row_range, div(length(row_range), 2))}

  defp partition("R", {col_range, row_range}),
    do: {col_range, Enum.take(row_range, div(length(row_range), -2))}

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/day_5.txt")
    |> File.read!()
    |> String.split()
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
  end
end
