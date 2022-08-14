defmodule Rexerbug.Options do
  @moduledoc """
  Parses sensible option names into `Rexbug`/`:redbug` options.

  ## Options

  - `:count` stops tracing after `n` number of messages are traced.
  - `:timeout` stops tracing after `n` milliseconds.
  - `:pids` limits tracing to the list of processes.
  - `:connect` connects to the target `node` for remote tracing.
  - `arity?` toggles printng arity instead of arguments.
  - `buffer?` toggles buffering messages until the trace ends.
  - `discard?` toggles into discarding traced messages.
  """

  @type rexerbug ::
          {:count, integer}
          | {:timeout, integer}
          | {:pids, [Process.dest()]}
          | {:connect, Node.t()}
          | {:arity?, boolean}
          | {:buffer?, boolean}
          | {:discard?, boolean}

  @type rexbug ::
          {:cookie, String.t()}
          | {:blocking, boolean}
          | {:max_queue, integer}
          | {:max_msg_size, integer}
          | {:print_calls, boolean}
          | {:print_file, File.io_device()}
          | {:print_msec, boolean}
          | {:print_depth, integer}
          | {:print_re, String.t()}
          | {:print_return, boolean}
          | {:print_fun, function}

  @type result ::
          rexbug
          | {:time, integer}
          | {:msgs, integer}
          | {:procs, :all | :new | [Process.dest()]}

  @type t :: [rexbug | rexerbug]

  @doc """
  Parses `Options.rexerbug` into `Options.result`. Converted
  options are merged back into the original opts keyword. Rexerbug
  values will be preferred in case of conflict.
  """
  @spec parse(t) :: [result]
  def parse(opts) do
    {rexerbug_opts, rexbug_opts} =
      Enum.map_reduce(key_conversions(), opts, fn {rexer, rex, default}, acc ->
        {value, acc} = Keyword.pop_first(acc, rexer, default)
        {{rex, value}, acc}
      end)

    Keyword.merge(rexbug_opts, rexerbug_opts)
  end

  # {rexerbug_key, rexbug_key, default}
  defp key_conversions do
    [
      {:count, :msgs, 10},
      {:timeout, :time, 60_000},
      {:pids, :procs, :all},
      {:connect, :target, Node.self()},
      {:arity?, :arity, false},
      {:buffer?, :buffered, false},
      {:discard?, :discard, false}
    ]
  end
end
