defmodule AocWeb.Year2021.Day13Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Thirteen</h1>
    <h3>Part one:</h3>
    <p></p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @answer_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p></p>
    <button phx-click="get_answer_2">Calculate</button>
    <p>Result: </p>
    <pre>
      <code style="line-height: normal;"><%= @answer_2 %></code>
    </pre>
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
    {point_map, instructions} = get_input()

    instructions = Enum.take(instructions, 1)

    folded_map = fold_map(instructions, point_map)

    MapSet.size(folded_map)
  end

  defp fold_map(instructions, point_map) do
    Enum.reduce(instructions, point_map, fn instruction, acc ->
      [_, _, instruction] = String.split(instruction, " ")
      [axis, fold_line] = String.split(instruction, "=")
      axis = if axis == "x", do: 0, else: 1
      fold_line = String.to_integer(fold_line)

      Enum.reduce(acc, MapSet.new(), fn coords, acc ->
        coord_to_fold = Enum.at(coords, axis)

        if coord_to_fold > fold_line do
          new_coords = coords |> List.replace_at(axis, fold_line - (coord_to_fold - fold_line))
          MapSet.put(acc, new_coords)
        else
          MapSet.put(acc, coords)
        end
      end)
    end)
  end

  def get_answer_2() do
    {point_map, instructions} = get_input()

    folded_map = fold_map(instructions, point_map)

    {_, [max_x, _]} = Enum.min_max_by(folded_map, &Enum.at(&1, 0))
    {_, [_, max_y]} = Enum.min_max_by(folded_map, &Enum.at(&1, 1))

    map =
      for y <- 0..max_y do
        for x <- 0..max_x do
          if MapSet.member?(folded_map, [x, y]), do: "▓", else: "░"
        end
      end

    map
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> tap(&IO.puts/1)
  end

  defp get_input() do
    [points, instructions] =
      Application.app_dir(:aoc)
      |> Path.join("priv/inputs/2021/day_13.txt")
      |> File.read!()
      |> String.split("\n\n")

    points =
      points
      |> String.split("\n")
      |> Enum.map(&String.split(&1, ","))
      |> Enum.reduce(MapSet.new(), fn [x, y], acc ->
        MapSet.put(acc, [String.to_integer(x), String.to_integer(y)])
      end)

    instructions = instructions |> String.split("\n")

    {points, instructions}
  end
end
