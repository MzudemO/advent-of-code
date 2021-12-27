defmodule AocWeb.Year2021.Day12Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Twelve</h1>
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

    dfs(input, "start", [], 0)
  end

  defp dfs(_, "end", _, count) do
    count + 1
  end

  defp dfs(graph, node, explored, count) do
    explored = if lowercase?(node), do: [node | explored], else: explored

    new_nodes =
      graph
      |> Enum.flat_map(fn
        [^node, b] -> if b not in explored, do: [b], else: []
        [a, ^node] -> if a not in explored, do: [a], else: []
        _ -> []
      end)

    new_nodes
    |> Enum.reduce(count, fn new_node, count ->
      dfs(graph, new_node, explored, count)
    end)
  end

  defp lowercase?(string), do: String.downcase(string) == string

  def get_answer_2() do
    # doesn't work
    input = get_input()

    dfs2(input, "start", ["start"], 0, false, [])
  end

  defp dfs2(_, "end", _, count, _, path) do
    IO.inspect(["end" | path] |> Enum.reverse())
    count + 1
  end

  defp dfs2(graph, node, explored, count, once?, path) do
    explored = if lowercase?(node) and once?, do: [node | explored], else: explored
    once? = if node != "start" and lowercase?(node) and not once?, do: true, else: once?

    new_nodes =
      graph
      |> Enum.flat_map(fn
        [^node, b] -> if b not in explored, do: [b], else: []
        [a, ^node] -> if a not in explored, do: [a], else: []
        _ -> []
      end)

    new_nodes
    |> Enum.reduce(count, fn new_node, count ->
      dfs2(graph, new_node, explored, count, once?, [node | path])
    end)
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_12_test.txt")
    |> File.read!()
    |> String.split(["\n", "-"])
    |> Enum.chunk_every(2)
  end
end
