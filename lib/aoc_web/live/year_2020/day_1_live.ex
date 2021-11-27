defmodule AocWeb.Day1Live do
  use AocWeb, :live_view

  @sum_up_to 2020

  def mount(_params, _session, socket) do
    socket = assign(socket, sum_up_to: @sum_up_to, result_1: "", result_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day One</h1>
    <h3>Part one:</h3>
    <p>Find the two numbers that sum up to <%= @sum_up_to %> and multiply them.</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @result_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>Find the three numbers that sum up to <%= @sum_up_to %> and multiply them.</p>
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

  defp calc_result_1() do
    numbers = get_input()

    {number, match} =
      numbers
      |> Enum.reduce_while({}, fn number, acc ->
        match = @sum_up_to - number

        if Enum.member?(numbers, match) do
          {:halt, {number, match}}
        else
          {:cont, acc}
        end
      end)

    number * match
  end

  defp calc_result_2() do
    numbers = get_input()

    numbers
    |> Enum.reduce_while(0, fn number, acc ->
      match = @sum_up_to - number

      numbers
      |> Enum.find_value(fn x ->
        new_match = match - x

        if Enum.member?(numbers, new_match) do
          x * new_match
        end
      end)
      |> case do
        nil -> {:cont, acc}
        product -> {:halt, product * number}
      end
    end)
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/day_1.txt")
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
