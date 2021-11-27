defmodule AocWeb.Day3Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, result_1: "", result_2: "", map: [])
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Three</h1>
    <h3>Part one:</h3>
    <p>Find the number of trees intersecting with a slope for a 2D grid, wrapping boundaries.</p>
    <button phx-click="get_answer_1">Calculate</button> <button phx-click="show_map_1">Toggle Map</button>
    <p>Result: <%= @result_1 %></p>
    <%= for line <- @map do %>
      <span><code><%= line %></code></span>
      <br>
    <% end %>
    <h3>Part one:</h3>
    <p>Find the number of trees intersecting with a slope for multiple slopes and multiply the results.</p>
    <button phx-click="get_answer_2">Calculate</button>
    <p>Result: <%= @result_2 %></p>
    """
  end

  def handle_event("get_answer_1", _, socket) do
    socket = assign(socket, result_1: calc_result_1())
    {:noreply, socket}
  end

  def handle_event("show_map_1", _, %{assigns: %{map: []}} = socket) do
    socket = assign(socket, map: get_map_1())
    {:noreply, socket}
  end

  def handle_event("show_map_1", _, %{assigns: %{map: _}} = socket) do
    socket = assign(socket, map: [])
    {:noreply, socket}
  end

  def handle_event("get_answer_2", _, socket) do
    socket = assign(socket, result_2: calc_result_2())
    {:noreply, socket}
  end

  defp calc_result_1() do
    {count, _} =
      get_input()
      |> Enum.reduce({0, 0}, &check_tree/2)

    count
  end

  defp check_tree(line, {count, pos_x}) do
    next_pos = Integer.mod(pos_x + 3, length(line))

    if Enum.at(line, pos_x) == "#", do: {count + 1, next_pos}, else: {count, next_pos}
  end

  defp get_map_1() do
    {map, _} =
      get_input()
      |> Enum.map_reduce(0, &mark_spot/2)

    map
    |> Enum.map(&Enum.join/1)
  end

  defp mark_spot(line, pos_x) do
    next_pos = Integer.mod(pos_x + 3, length(line))

    if Enum.at(line, pos_x) == "#" do
      {List.replace_at(line, pos_x, "X"), next_pos}
    else
      {List.replace_at(line, pos_x, "O"), next_pos}
    end
  end

  defp calc_result_2() do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(&count_intersections/1)
    |> IO.inspect()
    |> Enum.product()
  end

  defp count_intersections(slope) do
    {count, _, _} =
      get_input()
      |> Enum.reduce({0, {0, 0}, slope}, &check_tree_2/2)

    count
  end

  defp check_tree_2(line, {count, {x_pos, _y_offset = 0}, {x_slope, y_slope} = slope}) do
    next_x_pos = Integer.mod(x_pos + x_slope, length(line))
    next_count = if Enum.at(line, x_pos) == "#", do: count + 1, else: count

    {next_count, {next_x_pos, y_slope - 1}, slope}
  end

  defp check_tree_2(_, {count, {x_pos, y_offset}, {x_slope, y_slope}}) do
    {count, {x_pos, y_offset - 1}, {x_slope, y_slope}}
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/day_3.txt")
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
  end
end
