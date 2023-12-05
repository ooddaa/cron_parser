defmodule CronParser do
  @moduledoc """
  The best place to start navigating the module's
  functionality is to look at tests. 

  Main function `parser\1` expects a valid cron
  command and outputs a map with all expansions.

  It consumes cron string greedily, returning 
  first error that it encounters. 

  Validations on input are: 
  - must have valid length
  - must contain only valid tokens (0-9 * / - ,)
  """

  @keys [
    "minutes",
    "hours",
    "days",
    "months",
    "weekdays",
    "cmd"
  ]


  @doc """
  Main function.  
  
  Result %{
    "minutes" => list(integer()),
    "hours" => list(integer()),
    "days" => list(integer()),
    "months" => list(integer()),
    "weekdays" => list(integer()),
    "cmd" => list(String.t())
  }
  @return {:ok, Result} | {:error, reason, input}
  """
  def parser(input) when is_binary(input) do
      with {:ok, input} <- is_long?(input),
           {:ok, input} <- has_valid_tokens?(input),
           {:ok, minutes, rest} <- parse_with(input, &minute/1),
           {:ok, hours, rest} <- parse_with(rest, &hour/1),
           {:ok, days, rest} <- parse_with(rest, &day/1),
           {:ok, months, rest} <- parse_with(rest, &month/1),
           {:ok, weekdays, rest} <- parse_with(rest, &weekday/1),
           {:ok, cmd, nil} <- parse_with(rest, &cmd/1) do
      {:ok,
       %{
         "minutes" => minutes,
         "hours" => hours,
         "days" => days,
         "months" => months,
         "weekdays" => weekdays,
         "cmd" => cmd
       }}
    end
  end

  def parser(input), do: {:error, :bad_input, input}

  defp parse_with(input, parser) do
    case String.split(input, " ", parts: 2) do
      [cmd] -> {:ok, process(cmd, parser), nil}
      [input, rest] -> {:ok, process(input, parser), rest} 
    end
  end

  ##
  # Parsers 
  ##
  defp minute("*"), do: {0, 59, 1}
  defp minute(input), do: parse(input, &minute/1)

  defp hour("*"), do: {0, 23, 1}
  defp hour(input), do: parse(input, &hour/1)

  defp day("*"), do: {1, 31, 1}
  defp day(input), do: parse(input, &day/1)

  defp month("*"), do: {1, 12, 1}
  defp month(input), do: parse(input, &month/1)

  defp weekday("*"), do: {0, 6, 1}
  defp weekday(input), do: parse(input, &weekday/1)

  defp cmd(input), do: {:ok, input, nil}

  ##
  # Utility functions
  ##
  defp is_long?(input) do
    case input
         |> String.split(" ", trim: true)
         |> then(&(length(&1) == 6)) do
      true -> {:ok, input}
      false -> {:error, :bad_length, input}
    end
  end

  defp has_valid_tokens?(input) do
    input
    |> String.split(" ", trim: true)
    |> Enum.take(5)
    |> Enum.join(" ")
    |> has_only_allowed_tokens?()
    |> case do
      true -> {:ok, input}
      false -> {:error, :bad_tokens, input}
    end
  end

  defp has_only_allowed_tokens?(string) do
    string
    |> String.replace(~r/[a-zA-Z!?_+=(){}[\]|&#%@:;$<>.\\^]/, "")
    |> String.split(" ", trim: true)
    |> then(&(length(&1) == 5))
  end

  defp process(input, parser) do
    input
    |> fragment_input()
    |> apply_parser(parser)
    |> normalize_results()
  end

  defp apply_parser(input, parser) do
    Enum.map(input, parser)
  end

  defp fragment_input(input) do
    String.split(input, ",", trim: true)
  end

  ##
  # Main parser
  ##
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

  @doc"""
  Takes individual parser results
  range [{from, to, step}] :: [{integer(), integer(), integer()}] 
  cmd   [cmd] :: [String.t()] 
  And runs expansions on ranges. 
  Returns results ready for user consumption. 
  """
  def normalize_results(lists) do
    lists
    |> Enum.map(fn 
      {_,cmd,nil} -> [cmd] 
      range -> expand_range(range)
    end)
    |> Enum.flat_map(& &1)
    |> Enum.uniq()
    |> Enum.sort()
  end

  defp expand_range({from, to, step}) do
    Range.to_list(from..to//step)
  end

  defp expand_range(input), do: [input]

  def pretty_print(input) do
    @keys
    |> Enum.reduce("", fn key, output ->
      output <>
        "#{key}#{String.duplicate(" ", 14 - String.length(key))}#{Enum.join(Map.get(input, key), " ")}\n"
    end)
    |> IO.puts()
  end
end
