defmodule Rexerbug do
  def trace(pattern, opts \\ []) do
    rexbug().start(pattern, opts)
  end

  @doc false
  def rexbug do
    Application.get_env(:rexerbug, :rexbug, Rexbug)
  end
end
