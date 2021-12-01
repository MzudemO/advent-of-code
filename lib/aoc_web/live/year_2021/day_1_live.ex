defmodule AocWeb.Year2021.Day1Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day One</h1>
    <h3>Part one:</h3>
    <p>Find the number of times a value is higher than the previous value.</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @answer_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>Finder the number of times a three-value sliding window is larger than the previous.</p>
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
    get_input()
    |> Enum.reduce(0, &count_increases/2)
    |> elem(0)
  end

  defp get_answer_2() do
    get_input()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.reduce(0, &count_increases/2)
    |> elem(0)
  end

  defp count_increases(value, 0), do: {0, value}

  defp count_increases(value, {counter, prev}) do
    if value > prev, do: {counter + 1, value}, else: {counter, value}
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_1.txt")
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
