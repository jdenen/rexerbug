defmodule Rexerbug.Options do
  @moduledoc """
  Parses sensible option names into `Rexbug`/`:redbug` options.

  ## Options

  - `:count` stops tracing after `n` number of messages are traced.
  - `:timeout` stops tracing after `n` milliseconds.
  - `:pids` limits tracing to the list of processes.
  """

  @type rexerbug ::
          {:count, integer}
          | {:timeout, integer}
          | {:pids, [Process.dest()]}

  @type rexbug ::
          {:target, Node.t()}
          | {:cookie, String.t()}
          | {:blocking, boolean}
          | {:arity, boolean}
          | {:buffered, boolean}
          | {:discard, boolean}
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
    {count, opts} = Keyword.pop_first(opts, :count, 10)
    {timeout, opts} = Keyword.pop_first(opts, :timeout, 60_000)
    {pids, opts} = Keyword.pop_first(opts, :pids, :all)

    Keyword.merge(opts, msgs: count, time: timeout, procs: pids)
  end
end
