defmodule AocWeb.Year2021.Day10Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Ten</h1>
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
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&is_binary/1)
    |> Enum.map(&score_lookup/1)
    |> Enum.sum()
  end

  defp parse_line(line) do
    Enum.reduce_while(line, [], fn char, opened ->
      cond do
        opens?(char) ->
          {:cont, [char | opened]}

        matches?(char, hd(opened)) ->
          {:cont, tl(opened)}

        true ->
          {:halt, char}
      end
    end)
  end

  defp opens?(char), do: char in ["(", "[", "{", "<"]

  defp matches?(closing, opening), do: get_closing(opening) == closing

  defp score_lookup(")"), do: 3
  defp score_lookup("]"), do: 57
  defp score_lookup("}"), do: 1197
  defp score_lookup(">"), do: 25137

  def get_answer_2() do
    input = get_input()

    sorted_input =
      input
      |> Enum.map(&parse_line/1)
      |> Enum.filter(&is_list/1)
      |> Enum.map(&autocomplete_line/1)
      |> Enum.map(&score_autocomplete/1)
      |> Enum.sort()

    Enum.at(sorted_input, floor(length(sorted_input) / 2))
  end

  defp autocomplete_line(line) do
    Enum.reduce(line, [], fn unopened, closing ->
      [get_closing(unopened) | closing]
    end)
    |> Enum.reverse()
  end

  defp score_autocomplete(line) do
    Enum.reduce(line, 0, fn symbol, score ->
      score * 5 + autocomplete_lookup(symbol)
    end)
  end

  defp get_closing("("), do: ")"
  defp get_closing("["), do: "]"
  defp get_closing("{"), do: "}"
  defp get_closing("<"), do: ">"

  defp autocomplete_lookup(")"), do: 1
  defp autocomplete_lookup("]"), do: 2
  defp autocomplete_lookup("}"), do: 3
  defp autocomplete_lookup(">"), do: 4

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_10.txt")
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
  end
end
