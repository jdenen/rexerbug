defmodule Rexerbug do
  def trace(pattern, opts \\ []) do
    rexbug = rexbug()

    pattern
    |> parse_pattern()
    |> ensure_return()
    |> rexbug.start(opts)
  end

  @doc false
  def rexbug do
    Application.get_env(:rexerbug, :rexbug, Rexbug)
  end

  defp parse_pattern(pattern) when is_function(pattern) do
    info = Function.info(pattern)
    mod = mod_name(info[:module])

    "#{mod}.#{info[:name]}/#{info[:arity]}"
  end

  defp parse_pattern({module, fun}) do
    mod = mod_name(module)
    "#{mod}.#{fun}/_"
  end

  defp parse_pattern({module, fun, args}) when is_list(args) do
    mod = mod_name(module)
    args = parse_args(args)

    "#{mod}.#{fun}(#{args})"
  end

  defp parse_pattern(pattern), do: pattern

  defp parse_args(args) do
    args
    |> Enum.map(&inspect/1)
    |> Enum.join(", ")
  end

  defp ensure_return(pattern) do
    case String.split(pattern, "::") do
      [_, _] -> pattern
      [match] -> "#{match} :: return;stack"
    end
  end

  defp mod_name(mod) do
    mod
    |> to_string()
    |> String.trim_leading("Elixir.")
  end
end
