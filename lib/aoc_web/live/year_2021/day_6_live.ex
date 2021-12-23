defmodule AocWeb.Year2021.Day6Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Six</h1>
    <h3>Part one:</h3>
    <p>Lanternfish reproduce every 7 days. How many lanternfish are there after 80 days?</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @answer_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>How many after 256 days?</p>
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

    calc_day(input, 80)
    |> length()
  end

  defp calc_day(fish, 0), do: fish

  defp calc_day(fish, day) do
    {fish, spawn} =
      fish
      |> Enum.map_reduce([], fn
        0, spawn -> {6, [8 | spawn]}
        age, spawn -> {age - 1, spawn}
      end)

    calc_day(fish ++ spawn, day - 1)
  end

  def get_answer_2() do
    input = get_input()

    frequencies =
      input
      |> Enum.frequencies()

    %{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0}
    |> Map.merge(frequencies)
    |> calc_day_cheap(256)
    |> Enum.sum()
  end

  defp calc_day_cheap(fish, 0), do: Map.values(fish)

  defp calc_day_cheap(fish, day) do
    new_fish = %{
      0 => fish[1],
      1 => fish[2],
      2 => fish[3],
      3 => fish[4],
      4 => fish[5],
      5 => fish[6],
      6 => fish[0] + fish[7],
      7 => fish[8],
      8 => fish[0]
    }

    calc_day_cheap(new_fish, day - 1)
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_6.txt")
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
