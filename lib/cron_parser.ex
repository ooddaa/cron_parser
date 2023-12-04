defmodule CronParser do
  @moduledoc """
  Documentation for `CronParser`.
  """

  @doc """
  """
  def parse_to_ast(input) when is_binary(input) do
    case validate_input(input) do
      true ->
        with {:ok, minutes, rest} <- parse_minutes(input),
             {:ok, hours, rest} <- parse_hours(rest),
             {:ok, days, rest} <- parse_days(rest),
             {:ok, months, rest} <- parse_months(rest),
             {:ok, weekdays, rest} <- parse_weekdays(rest),
             {:ok, cmd, nil} <- parse_cmd(rest) do
          %{
            "minutes" => minutes,
            "hours" => hours,
            "days" => days,
            "months" => months,
            "weekdays" => weekdays,
            "cmd" => cmd
          }
        end

      false ->
        {:error, :bad_input, input}
    end
  end

  def parse_to_ast(input), do: {:error, :bad_input, input}

  def parse_minutes(input) do
    [input, rest] = String.split(input, " ", parts: 2)
    minutes = process(input, &minute/1)
    {:ok, minutes, rest}
  end

  defp minute("*"), do: {0, 59, 1}
  defp minute(input), do: parse(input, &minute/1)

  def parse_hours(input) do
    [input, rest] = String.split(input, " ", parts: 2)
    hours = process(input, &hour/1)
    {:ok, hours, rest}
  end

  defp hour("*"), do: {0, 23, 1}
  defp hour(input), do: parse(input, &hour/1)

  def parse_days(input) do
    [input, rest] = String.split(input, " ", parts: 2)
    days = process(input, &day/1)
    {:ok, days, rest}
  end

  defp day("*"), do: {1, 31, 1}
  defp day(input), do: parse(input, &day/1)

  def parse_months(input) do
    [input, rest] = String.split(input, " ", parts: 2)
    months = process(input, &month/1)
    {:ok, months, rest}
  end

  defp month("*"), do: {1, 12, 1}
  defp month(input), do: parse(input, &month/1)

  def parse_weekdays(input) do
    [input, rest] = String.split(input, " ", parts: 2)
    weekdays = process(input, &weekday/1)
    {:ok, weekdays, rest}
  end

  defp weekday("*"), do: {0, 6, 1}
  defp weekday(input), do: parse(input, &weekday/1)

  def parse_cmd(input) do
    cmds = process(input, &cmd/1)
    {:ok, cmds, nil}
  end

  defp cmd(input), do: input

  defp validate_input(input) do
    input
    |> String.split(" ", trim: true)
    |> then(&(length(&1) == 6))
  end

  defp process(input, parser) do
    input
    |> fragment_input()
    |> Enum.map(&parser.(&1))
    |> normalize()
  end

  defp fragment_input(input) do
    input
    |> String.split(",", trim: true)
  end

  defp parse(input, parser) do
    cond do
      String.contains?(input, "-") ->
        [from, to] = String.split(input, "-")
        {String.to_integer(from), String.to_integer(to), 1}

      String.contains?(input, "/") ->
        [range, step] = String.split(input, "/")
        {from, to, _} = parser.(range)
        {from, to, String.to_integer(step)}

      true ->
        {String.to_integer(input), String.to_integer(input), 1}
    end
  end

  defp normalize(lists) do
    lists
    |> Enum.map(&expand_range/1)
    |> Enum.flat_map(& &1)
    |> Enum.uniq()
    |> Enum.sort()
  end

  defp expand_range({from, to, step}) do
    Range.to_list(from..to//step)
  end
  defp expand_range(input), do: [input]

  def pretty_print(input) do
    input
  end
end
