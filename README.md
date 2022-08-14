# Rexerbug

An opinionated wrapper for Elixir trace debugging

## What?

[`Rexbug`](https://github.com/nietaki/rexbug) wraps [`:redbug`](https://github.com/massemanet/redbug),
providing a more Elixir-like syntax for trace debugging. But `Rexbug` isn't Elixir-y enough for me,
so I made `Rexerbug` to wrap `Rexbug`.

### Function tracing

Instead of passing a magic string to `Rexbug`, you pass code that will be parsed into a trace.
For example:

```elixir
# Rexerbug
Rexerbug.trace(&Map.new/1)

# Rexbug
Rexbug.start("Map.new/1 :: return;stack")

# redbug
:redbug.start('\'Elixir.Map\':new -> return;stack')
```

An installation of `Rexerbug` includes `Rexbug`, so its magic strings will still work.

```elixir
Rexerbug.trace("String.starts_with?(_, \"a\") :: return")
```

### Process tracing

When tracing processes, `Rexbug` requires a magic list instead of a magic string.
I wanted to cut all that out and focus on the process to be traced:

```elixir
myself = self()

process = Process.spawn(fn ->
  receive do
    msg -> send(myself, {:got, msg})
  end
end)

# Rexerbug
Rexerbug.monitor(process)

# Rexbug
Rexbug.start([:send, :receive], procs: [process])
```

### Options

I've renamed some options toward more "expected" names. These are completely my own bias,
but I think they make more sense. Here are the new names compared to the old. Shown values
are the defaults, which have NOT changed from `Rexbug` to `Rexerbug`:

```elixir
Rexerbug.trace(
  &Map.new/1,
  count: 10,
  timeout: 60_000,
  pids: :all,
  connect: Node.self(),
  arity?: false,
  buffer?: false,
  discard?: false
)

Rexbug.start(
  "Map.new/1 :: return;stack",
  msgs: 10,
  time: 60_000,
  procs: :all,
  target: Node.self(),
  arity: false,
  buffered: false,
  discard: false
)
```

### Caveats

Because my wrapper is opinionated toward how I always use `Rexbug`, it has lost some
flexibility. A return value of `return;stack` is assumed. Both `:send` and `:receive`
events are assumed when `monitor/2`ing a process.

## Installation

```elixir
def deps do
  [
    {:rexerbug, "~> 0.1.0"}
  ]
end
```
