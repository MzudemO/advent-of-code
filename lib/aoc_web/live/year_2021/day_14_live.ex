defmodule AocWeb.Year2021.Day14Live do
  use AocWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Fourteen</h1>
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
    {polymer, instructions} = get_input()

    final_polymer = pair_insertion(polymer, instructions)

    {{_, least_frequent_count}, {_, most_frequent_count}} =
      final_polymer
      |> String.split("", trim: true)
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {_k, v} -> v end)

    most_frequent_count - least_frequent_count
  end

  def get_answer_2() do
    {polymer, instructions} = get_input()

    final_polymer = pair_insertion(polymer, instructions, 40)

    {{_, least_frequent_count}, {_, most_frequent_count}} =
      final_polymer
      |> String.split("", trim: true)
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {_k, v} -> v end)

    most_frequent_count - least_frequent_count
  end

  defp pair_insertion(polymer, instructions, steps \\ 10) do
    for step <- 1..steps, reduce: polymer do
      polymer ->
        IO.puts(step)

        splices =
          Enum.reduce(instructions, [], fn instruction, acc ->
            [pattern, replacement] = String.split(instruction, " -> ")

            # use lookahead (?=...) to get overlapping matches
            indexes =
              Regex.scan(~r/(?=#{pattern})/, polymer, return: :index)
              # to insert in the middle, add 1 to pattern start index
              |> Enum.map(fn [{index, _}] -> {index + 1, replacement} end)

            indexes ++ acc
          end)
          |> Enum.sort_by(&elem(&1, 0))

        {polymer, _} =
          splices
          |> Enum.reduce({String.split(polymer, "", trim: true), 0}, fn {index, replacement},
                                                                        {polymer, index_offset} ->
            new_polymer = List.insert_at(polymer, index + index_offset, replacement)

            {new_polymer, index_offset + 1}
          end)

        polymer
        |> Enum.join()
    end
  end

  defp get_input() do
    [polymer, instructions] =
      Application.app_dir(:aoc)
      |> Path.join("priv/inputs/2021/day_14.txt")
      |> File.read!()
      |> String.split("\n\n")

    {polymer, instructions |> String.split("\n")}
  end
end
