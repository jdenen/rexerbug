defmodule Rexerbug.Tracer do
  @moduledoc false

  @typep monitor_event :: :send | :receive
  @typep monitor_pattern :: [monitor_event]

  @monitor_pattern [:send, :receive]

  @spec trace(Rexerbug.pattern() | monitor_pattern, Keyword.t()) :: Rexbug.rexbug_return()
  def trace(@monitor_pattern, opts) do
    opts = Rexerbug.Options.parse(opts)
    Rexerbug.Api.rexbug().start(@monitor_pattern, opts)
  end

  def trace(pattern, opts) do
    rexbug = Rexerbug.Api.rexbug()
    opts = Rexerbug.Options.parse(opts)

    pattern
    |> parse_pattern()
    |> ensure_return()
    |> rexbug.start(opts)
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

  defp parse_pattern(pattern) when is_atom(pattern) do
    mod_name(pattern)
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
    # Check if this is a module like String
    # or an atom like :ets.
    case Module.split(mod) do
      [mod] -> mod
      _ -> mod
    end
  rescue
    _ ->
      inspect(mod)
  end
end
