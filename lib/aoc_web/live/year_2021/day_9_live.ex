defmodule AocWeb.Year2021.Day9Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Nine</h1>
    <h3>Part one:</h3>
    <p></p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @answer_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p></p>
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
    input = get_input()

    input
    |> Enum.with_index()
    |> Enum.reduce({[], input}, fn {line, line_index}, {low_points, input} ->
      new_low_points =
        line
        |> Enum.with_index()
        |> Enum.filter(fn {column, column_index} ->
          column < Enum.at(line, column_index - 1, 10) and
            column < Enum.at(line, column_index + 1, 10) and
            column < input |> Enum.at(line_index - 1, []) |> Enum.at(column_index, 10) and
            column < input |> Enum.at(line_index + 1, []) |> Enum.at(column_index, 10)
        end)
        |> Enum.map(&elem(&1, 0))

      {new_low_points ++ low_points, input}
    end)
    |> elem(0)
    |> Enum.map(&(&1 + 1))
    |> Enum.sum()
  end

  def get_answer_2() do
    :ok
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_9_test.txt")
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end
end
