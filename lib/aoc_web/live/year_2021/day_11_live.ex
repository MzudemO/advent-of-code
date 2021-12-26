defmodule AocWeb.Year2021.Day11Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Eleven</h1>
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

    {_, count} =
      for _ <- 1..100, reduce: {input, 0} do
        {acc, count} ->
          acc =
            acc
            |> add_1()
            |> flash()

          {acc |> set_flashed_0(), count + MapSet.size(Map.get(acc, :flashed, MapSet.new()))}
      end

    count
  end

  defp flash(map) do
    # get eligible coords for flashing (value > 9 and not flashed)

    flash_coords = get_flash_coords(map)

    flash_rec(map, flash_coords)
  end

  defp get_flash_coords(map) do
    eligible_keys = Map.keys(map) |> Enum.filter(&(&1 > 9 and is_integer(&1)))

    eligible_keys
    |> Enum.map(&map[&1])
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
    |> MapSet.to_list()
  end

  defp flash_rec(map, []), do: map

  defp flash_rec(map, [coord | tl]) do
    # get adjacent nodes
    neighbors = get_neighbors(coord)

    # increase adjacent nodes by 1 (move to higher key)
    added_map =
      for neighbor <- neighbors, reduce: map do
        acc ->
          neighbor_value =
            acc
            |> Map.filter(fn {_k, v} -> MapSet.member?(v, neighbor) end)
            |> Map.keys()
            |> List.first()

          case neighbor_value do
            nil ->
              acc

            :flashed ->
              acc

            value ->
              acc
              |> Map.update(value + 1, MapSet.new([neighbor]), fn prev ->
                MapSet.put(prev, neighbor)
              end)
              |> Map.update(value, MapSet.new(), fn prev ->
                MapSet.delete(prev, neighbor)
              end)
          end
      end

    # delete flashed coord from map
    new_map = added_map |> Map.map(fn {_k, v} -> MapSet.delete(v, coord) end)

    # add to flashed key so we don't re-flash it
    new_map =
      new_map |> Map.update(:flashed, MapSet.new([coord]), fn prev -> MapSet.put(prev, coord) end)

    # get new eligible coords for flashing
    flash_coords = get_flash_coords(new_map)

    # add to coords to flash
    to_flash = (tl ++ flash_coords) |> Enum.uniq()
    flash_rec(new_map, to_flash)
  end

  defp set_flashed_0(map) do
    flashed = Map.get(map, :flashed, MapSet.new())

    map
    # move flashed to 0
    |> Map.update(0, flashed, fn prev ->
      MapSet.union(prev, flashed)
    end)
    # delete flashed
    |> Map.delete(:flashed)
  end

  def get_neighbors({x, y}) do
    [
      {x + 1, y},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x - 1, y - 1},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  defp add_1(map) do
    map
    |> Enum.map(fn {k, v} -> {k + 1, v} end)
    |> Enum.into(%{})
  end

  def get_answer_2() do
    input = get_input()

    {_, step} =
      for step <- 1..100_000, reduce: {input, 0} do
        {acc, 0} ->
          acc =
            acc
            |> add_1()
            |> flash()

          if acc |> Map.delete(:flashed) |> Enum.all?(fn {_k, v} -> MapSet.size(v) == 0 end) do
            {acc, step}
          else
            {acc |> set_flashed_0(), 0}
          end

        {acc, step} ->
          {acc, step}
      end

    step
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_11.txt")
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_index}, acc ->
      new_acc =
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {value, col_index}, acc ->
          node_index = {row_index, col_index}

          acc
          |> Map.update(value, MapSet.new([node_index]), fn prev_value ->
            MapSet.put(prev_value, node_index)
          end)
        end)

      new_acc
    end)
  end
end
