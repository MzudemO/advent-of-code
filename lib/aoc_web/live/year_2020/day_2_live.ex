defmodule AocWeb.Year2020.Day2Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, result_1: "", result_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day One</h1>
    <h3>Part one:</h3>
    <p>Find the number of valid passwords. Each password has a schema such as <code>1-3 a</code> which dictates how often that letter must be included in the password.</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @result_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>Find the number of valid passwords. Each password has a schema such as <code>1-3 a</code> where the character must be in exactly one of the two positions (1-indexed).</p>
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

  defp calc_result_1 do
    get_input()
    |> Enum.reduce(0, fn line, acc ->
      [amount, letter, password] = String.split(line, " ")
      [min, max] = String.split(amount, "-") |> Enum.map(&String.to_integer/1)
      letter = String.trim(letter, ":")
      matches = Regex.scan(~r/#{letter}/, password)
      if min <= length(matches) and length(matches) <= max, do: acc + 1, else: acc
    end)
  end

  defp calc_result_2 do
    get_input()
    |> Enum.reduce(0, fn line, acc ->
      [positions, letter, password] = String.split(line, " ")
      [pos1, pos2] = String.split(positions, "-") |> Enum.map(&String.to_integer/1)
      letter = String.trim(letter, ":")

      first = String.at(password, pos1 - 1) == letter
      second = String.at(password, pos2 - 1) == letter

      if (first or second) and not (first and second),
        do: acc + 1,
        else: acc
    end)
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/day_2.txt")
    |> File.read!()
    |> String.split("\n")
  end
end
