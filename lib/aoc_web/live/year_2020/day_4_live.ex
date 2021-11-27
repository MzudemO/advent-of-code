defmodule AocWeb.Day4Live do
  use AocWeb, :live_view

  @required_keys ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  def mount(_params, _session, socket) do
    socket = assign(socket, result_1: "", result_2: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Day Four</h1>
    <h3>Part one:</h3>
    <p>Find the number of passports containing the required keys.</p>
    <button phx-click="get_answer_1">Calculate</button>
    <p>Result: <%= @result_1 %></p>
    <hr>
    <h3>Part two:</h3>
    <p>Find the number of passports containing required keys and valid values.</p>
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
    get_input()
    |> Enum.count(&has_required_keys/1)
  end

  defp has_required_keys(passport) do
    @required_keys
    |> Enum.all?(fn key ->
      Enum.any?(passport, fn datapoint -> String.starts_with?(datapoint, key) end)
    end)
  end

  defp calc_result_2() do
    get_input()
    |> Enum.count(fn passport -> has_required_keys(passport) and has_valid_data(passport) end)
  end

  defp has_valid_data(passport) do
    passport
    |> Enum.all?(&key_is_valid/1)
  end

  def key_is_valid("byr:" <> year) do
    year >= "1920" and year <= "2002"
  end

  def key_is_valid("iyr:" <> year) do
    year >= "2010" and year <= "2020"
  end

  def key_is_valid("eyr:" <> year) do
    year >= "2020" and year <= "2030"
  end

  def key_is_valid("hgt:" <> height) do
    case String.split_at(height, -2) do
      {nr, "in"} ->
        nr >= "59" and nr <= "76"

      {nr, "cm"} ->
        nr >= "150" and nr <= "193"

      _ ->
        false
    end
  end

  def key_is_valid("hcl:" <> color) do
    String.match?(color, ~r/^#[0-9a-f]{6}$/)
  end

  def key_is_valid("ecl:" <> color) do
    color in ~w[amb blu brn gry grn hzl oth]s
  end

  def key_is_valid("pid:" <> id) do
    String.match?(id, ~r/^[0-9]{9}$/)
  end

  def key_is_valid("cid:" <> _), do: true

  defp get_input() do
    Application.app_dir(:aoc)
    |> Path.join("priv/inputs/day_4.txt")
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(&String.split/1)
  end
end
