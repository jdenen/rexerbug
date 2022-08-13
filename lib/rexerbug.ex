defmodule Rexerbug do
  defdelegate trace(pattern, opts \\ []), to: Rexerbug.MfaTracer
end
