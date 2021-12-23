defmodule AocWeb.Year2021.Day7Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Seven</h1>
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

    {min, max} = Enum.min_max(input)

    min..max
    |> Enum.map(fn position ->
      input
      |> Enum.map(&abs(position - &1))
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def get_answer_2() do
    input = get_input()

    {min, max} = Enum.min_max(input)

    min..max
    |> Enum.map(fn position ->
      input
      |> Enum.map(fn crab_pos ->
        distance = abs(crab_pos - position)
        0..distance |> Enum.sum()
      end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_7.txt")
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
