defmodule Rexerbug do
  @type pattern :: function | mfa | {module, function} | module | Rexbug.trace_pattern()

  @spec trace(pattern, Keyword.t()) :: Rexbug.rexbug_return()
  defdelegate trace(pattern, opts \\ []), to: Rexerbug.MfaTracer
end
