defmodule AocWeb.Year2021.Day2Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day One</h1>
    <h3>Part one:</h3>
    <p>Find the final horizontal and vertical position from commands like <code>down 5, forward 8</code> and multiply them.</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @answer_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p><code>down</code> and <code>up</code> now change aim, while <code>forward</code> changes depth according to the aim.</p>
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
    {x, y} =
      get_input()
      |> Enum.reduce({0, 0}, &move/2)

    x * y
  end

  defp move("forward " <> value, {x, y}), do: {x + String.to_integer(value), y}
  defp move("down " <> value, {x, y}), do: {x, y + String.to_integer(value)}
  defp move("up " <> value, {x, y}), do: {x, y - String.to_integer(value)}

  defp get_answer_2() do
    {x, y, _} =
      get_input()
      |> Enum.reduce({0, 0, 0}, &move_2/2)

    x * y
  end

  defp move_2("forward " <> value, {x, y, aim}),
    do: {x + String.to_integer(value), y + aim * String.to_integer(value), aim}

  defp move_2("down " <> value, {x, y, aim}), do: {x, y, aim + String.to_integer(value)}
  defp move_2("up " <> value, {x, y, aim}), do: {x, y, aim - String.to_integer(value)}

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_2.txt")
    |> File.read!()
    |> String.split("\n")
  end
end
