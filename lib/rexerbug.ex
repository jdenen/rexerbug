defmodule Rexerbug do
  @moduledoc """
  An opinionated wrapper for `Rexbug`, which wraps `:redbug`, for tracing
  purposes. It allows you to pass native Elixir code instead of strings.

      Rexerbug.trace(&String.split/2)

  It cannot fully replace `Rexbug` and will take `Rexbug` binary patterns
  to make up for it.

      Rexerbug.trace("Foo.bar(a, b) when is_binary(b) :: stack")

  Process mailboxes can be traced, too.

      Rexerbug.monitor(pid)

      Rexerbug.monitor(pid, 1_000)
  """

  @type pattern ::
          function
          | {module, atom, list}
          | {module, atom}
          | module
          | Rexbug.trace_pattern()

  @typep stop_response :: :stopped | :not_started

  @doc """
  Starts `Rexbug`/`:redbug` tracing for the given pattern.

  Pattern will be converted to a `Rexbug.trace_pattern` with a `return;stack`
  return value. Options are passed straight through to `Rexbug`. See
  `Rexbug.start/2` for possible options.

  Pass a first class function to match against a function with specific
  arity. This will not work with anonymous functions.

      # "Function.identity/1 :: return;stack"
      Rexerbug.trace(&Function.identity/1)

  Pass a tuple with module and function to trace any arity.

      # "String.split/_ :: return;stack"
      Rexerbug.trace({String, :split})

  Pass a `{module, :function, [args]}` tuple to trace against specific arguments.

      # "List.first([1, 2, 3]) :: return;stack"
      Rexerbug.trace({List, :first, [[1, 2, 3]]})

  Rexbug binary patterns will be passed through.

      Rexerbug.trace("List.first/1 :: return")
  """
  @spec trace(pattern, Keyword.t()) :: Rexbug.rexbug_return()
  defdelegate trace(pattern, opts \\ []), to: Rexerbug.MfaTracer

  @doc """
  Starts tracing `:send` and `:receive` events for a specific process mailbox.
  See `Rexbug.start/2` for possible options, but know that `procs` will be
  set with the given process.

      Rexerbug.monitor(pid, time: 300_000)

  This function is a convenience helper. It's equivalent to:

      Rexerbug.trace([:send, :receive], procs: [pid])

  A new `:count` option is available in case you can never remember `:msgs`.

      # Rexbug.start([:send, :receive], procs: [pid], msgs: 1_000)
      Rexerbug.monitor(pid, count: 1_000)
  """
  @spec monitor(pid, Keyword.t()) :: Rexbug.rexbug_return()
  def monitor(pid, opts \\ []) when is_pid(pid) do
    {count, opts} = Keyword.pop_first(opts, :count, 10)
    opts = Keyword.merge(opts, procs: [pid], msgs: count)

    trace([:send, :receive], opts)
  end

  @doc """
  See `Rexbug.stop/0`.
  """
  @spec stop() :: stop_response
  defdelegate stop(), to: Rexbug

  @doc """
  See `Rexbug.stop_sync/1`.
  """
  @spec stop_sync(integer) :: stop_response | {:error, :could_not_stop_redbug}
  defdelegate stop_sync(n), to: Rexbug
end
