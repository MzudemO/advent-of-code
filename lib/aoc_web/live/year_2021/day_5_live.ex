defmodule AocWeb.Year2021.Day5Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Five</h1>
    <h3>Part one:</h3>
    <p>Mark straight lines on a field given by start and end coordinates and count the points where minimum two overlap.</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @answer_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>Do the same, but include diagonal lines.</p>
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

    {max_x, max_y} = input |> Enum.reduce({0, 0}, &max_x_y/2)

    field =
      for _ <- 0..max_x do
        for _ <- 0..max_y do
          0
        end
      end

    input
    |> Enum.reduce(field, &handle_instruction_straight/2)
    |> List.flatten()
    |> Enum.count(&(&1 >= 2))
  end

  defp handle_instruction_straight([[x, _], [x, _]] = instruction, field),
    do: _handle_instruction_straight(instruction, field)

  defp handle_instruction_straight([[_, y], [_, y]] = instruction, field),
    do: _handle_instruction_straight(instruction, field)

  defp handle_instruction_straight(_, field), do: field

  defp _handle_instruction_straight([[x1, y1], [x2, y2]], field) do
    field
    |> Enum.with_index()
    |> Enum.map(fn {line, y_index} ->
      if y_index in y1..y2 do
        line
        |> Enum.with_index()
        |> Enum.map(fn {value, x_index} ->
          if x_index in x1..x2 do
            value + 1
          else
            value
          end
        end)
      else
        line
      end
    end)
  end

  defp max_x_y([[x1, y1], [x2, y2]], {max_x, max_y}) do
    max_x = [x1, x2, max_x] |> Enum.max()
    max_y = [y1, y2, max_y] |> Enum.max()
    {max_x, max_y}
  end

  defp get_answer_2() do
    input = get_input()

    {max_x, max_y} = input |> Enum.reduce({0, 0}, &max_x_y/2)

    field =
      for _ <- 0..max_x do
        for _ <- 0..max_y do
          0
        end
      end

    input
    |> Enum.reduce(field, &handle_instruction_diagonal/2)
    |> List.flatten()
    |> Enum.count(&(&1 >= 2))
  end

  def handle_instruction_diagonal([[x, _], [x, _]] = instruction, field),
    do: _handle_instruction_straight(instruction, field)

  def handle_instruction_diagonal([[_, y], [_, y]] = instruction, field),
    do: _handle_instruction_straight(instruction, field)

  def handle_instruction_diagonal([[x1, y1], [x2, y2]], field) do
    field
    |> Enum.with_index()
    |> Enum.map(fn {line, y_index} ->
      if y_index in y1..y2 do
        line
        |> Enum.with_index()
        |> Enum.map(fn {value, x_index} ->
          if x_index in x1..x2 and abs(x_index - x1) == abs(y_index - y1) do
            value + 1
          else
            value
          end
        end)
      else
        line
      end
    end)
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_5.txt")
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.map(fn line ->
      line
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn coords -> Enum.map(coords, &String.to_integer/1) end)
    end)
  end
end
