defmodule AocWeb.Year2021.Day8Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Eight</h1>
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
    |> Enum.map(fn [_, output] ->
      Enum.count(output, fn str -> String.length(str) in [2, 3, 4, 7] end)
    end)
    |> Enum.sum()
  end

  def get_answer_2() do
    :ok
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_8.txt")
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.split(" | ") |> Enum.map(&String.split/1) end)
  end
end
