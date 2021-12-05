defmodule AocWeb.Year2021.Day3Live do
  use AocWeb, :live_view

  use Bitwise

  def mount(_params, _session, socket) do
    socket = assign(socket, answer_1: "", answer_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Three</h1>
    <h3>Part one:</h3>
    <p>Multiply the binary numbers consisting of the least common and most common bits in each position.</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @answer_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>Recursively look at the most common bit until only one binary remains.</p>
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
    list_length = get_input() |> length()
    number_length = get_input() |> Enum.at(0) |> length()

    gamma_rate =
      get_input()
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.sum/1)
      |> Enum.map(fn sum -> if sum > list_length / 2, do: 1, else: 0 end)
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)

    epsilon_rate = bnot(gamma_rate) &&& 2 ** number_length - 1

    epsilon_rate * gamma_rate
  end

  defp get_answer_2() do
    input = get_input()

    gamma = _2(input, [], &Kernel.>=/2) |> Enum.join() |> Integer.parse(2) |> elem(0)
    beta = _2(input, [], &Kernel.</2) |> Enum.join() |> Integer.parse(2) |> elem(0)

    gamma * beta
  end

  defp _2([[]], bits, _op), do: bits |> Enum.reverse()

  defp _2([], bits, _op), do: bits |> Enum.reverse()

  defp _2([[hd | tl]], bits, op), do: _2([tl], [hd | bits], op)

  defp _2(list, bits, op) do
    column_sum = list |> Enum.map(fn l -> Enum.at(l, 0) end) |> Enum.sum()
    bit = if op.(column_sum, length(list) / 2), do: 1, else: 0

    new_list =
      list
      |> Enum.filter(fn l -> Enum.at(l, 0) == bit end)
      |> Enum.map(fn l -> Enum.drop(l, 1) end)

    _2(new_list, [bit | bits], op)
  end

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/2021/day_3.txt")
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
  end
end
